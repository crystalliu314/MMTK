#include <arduino.h>
#include <TMCStepper.h>
#include <HX711.h>
#include "MMTK_V1.h" 

// QA Mode Toggle
#define QAMODE true

// General Vars
double TMC_PulsePerRev = 0.0f;
long stepperPosition = 0;
bool stepperStopped = true;
bool stepperDirection = 0;
bool stepperStall = false;
bool lastIndexPin = 0;
bool currentIndexPin = 0;
long stepperFeedbackPosition = 0;
typedef enum {running, stopped, hold, jogFwd, jogBak} MMTKState_t;
MMTKState_t MMTKState;

typedef enum {down, up, press, release} ButtonState_t;
ButtonState_t forwardButton, backButton, startButton, tareButton, auxButton;

HX711 loadcell;
float ls_reading;


// Timer ISR for stepping motor and recording steps
ISR(TIMER1_COMPA_vect){
  
  // Check if motor is enabled
  if (stepperStopped) {
    return;
  }

  if (stepperDirection) {
    stepperPosition++;
  } else {
    stepperPosition--;
  }

  #ifdef USE_DIRECT_PORT_MANIPULATION_FOR_STEP
    STEPPER_STEP_PORT ^= 1 << STEPPER_STEP_PIN;
  #else
    digitalWrite(STEP_PIN, !digitalRead(STEP_PIN));
  #endif
}


// Pin Change ISR for ESTOP Sense, stop motor asap to avoid losing count
ISR(PCINT0_vect) { 
  // Currently only one PCINT is enabled, so we know this is the only pin that could have changed
  // If more PCINT is unmasked, there would need to be checking logic
  #ifdef USE_DIRECT_PORT_MANIPULATION_FOR_ENN_SENSE
    stepperStopped = (STEPPER_ENN_SENS_PORT & (1 << STEPPER_ENN_SENS_PIN));
  #else
    stepperStopped = digitalRead(STEPPER_ENN_SENS);
  #endif
  if (stepperStopped) {
    MMTKState = stopped;
  }
}

// Pin Change ISR for Index and Diag Sense
ISR(PCINT1_vect) { 

  // Check Diag Pin, if that is high, motor stalled
  #ifdef USE_DIRECT_PORT_MANIPULATION_FOR_DIAG
    stepperStall =  (STEPPER_DIAG_PORT & (1 << STEPPER_DIAG_PIN));
  #else 
    stepperStall = digitalRead(STEPPER_DIAG);
  #endif

  #ifdef USE_DIRECT_PORT_MANIPULATION_FOR_INDEX
    currentIndexPin = (STEPPER_INDEX_PORT & (1 << STEPPER_INDEX_PIN));
  #else 
    currentIndexPin = digitalRead(STEPPER_INDEX);
  #endif

  // Check Index Pin, if that is high, increment index counter
  if (!lastIndexPin && currentIndexPin) {
      if (stepperDirection) {
        stepperFeedbackPosition++;
      } else {
        stepperFeedbackPosition--;
      }
  }
  
  lastIndexPin = currentIndexPin;

}

ButtonState_t updateButtonState (int buttonToCheck, ButtonState_t lastState) {
  if (digitalRead(buttonToCheck)) {
    switch (lastState) {
      case down:
        return down;
      case up:
        return press;
      case press:
        return down;
      case release:
        return press;
    }
  } else {
    switch (lastState) {
      case down:
        return release;
      case up:
        return up;
      case press:
        return release;
      case release:
        return up;
    }
  }
  return up;
}



void setup() {
  
  cli(); //stop interrupts

  // #############
  // Pin Config
  // #############
  {
    pinMode(STEPPER_DIR, OUTPUT);
    pinMode(STEPPER_DIR, LOW);
    
    pinMode(STEPPER_STEP, OUTPUT);
    pinMode(STEPPER_STEP, LOW);
    
    pinMode(STEPPER_ENN, OUTPUT);
    pinMode(STEPPER_ENN, LOW);
    
    pinMode(STEPPER_ENN_SENS, INPUT);
    pinMode(STEPPER_DIAG, INPUT);
    pinMode(STEPPER_INDEX, INPUT);

    pinMode(BT_FW, INPUT);
    pinMode(BT_BK, INPUT);
    pinMode(BT_TARE, INPUT);
    pinMode(BT_START, INPUT);
    pinMode(BT_AUX, INPUT);

    pinMode(LED_RUN, OUTPUT);
    pinMode(LED_RUN, LOW);

    pinMode(LED_AUX, OUTPUT);
    pinMode(LED_AUX, LOW);
  }

  // #############
  // Setup Serial Logging
  // #############

  {
    // Faster Baud is great because logging is blocking
    Serial.begin(250000);

    // Print Headers here once we figure out
    Serial.print("POSITION\tLOADCELL\tFEEDBACK_COUNT\tSTATE\tESTOP\tSTALL\tDIRECTION\n");
  }

  // #############
  // Setup TMC2209
  // #############
  {
  TMC2209Stepper stepper(STEPPER_RX, STEPPER_TX, TMC_R_SENS, TMC_ADDRESS);
  stepper.beginSerial(TMC_SS_BAUD);

  stepper.begin();
  stepper.toff(4);
  stepper.blank_time(24);
  stepper.rms_current(TMC_RMS_CURRENT); // mA
  stepper.microsteps(TMC_MICROSTEPS);
  stepper.TCOOLTHRS(0xFFFFF); // 20bit max
  stepper.semin(5);
  stepper.semax(2);
  stepper.sedn(0b01);
  stepper.SGTHRS(TMC_STALL_VALUE);

  // Setup Stepper Interrupt, Step is triggered and counted here
  {
    TCCR1A = 0; // Clear Timer1 Config Regs (16 bit timer)
    TCCR1B = 0; 
    TCNT1  = 0; //initialize counter value to 0
    OCR1A = 256;// = (16*10^6) / (1*1024) - 1 (must be <65536)
    // turn on CTC mode
    TCCR1B |= (1 << WGM12);
    // Set CS11 bits for 8 prescaler
    TCCR1B |= (1 << CS11);// | (1 << CS10);
    // enable timer compare interrupt
    TIMSK1 |= (1 << OCIE1A);
  }

  // Setup PCINT interrupt
  // Arduino Pin 9: PB1 PCINT1 (interrupt PCINT0)
  {
    // Unmask PCINT1 pin
    PCMSK0 |= (1 << PCINT1);
    PCMSK1 |= (1 << PCINT12);
    PCMSK1 |= (1 << PCINT13);

    // Clear PCINT0 and 1 flag, proably not nessenary
    PCIFR |= (1 << PCIF0);
    PCIFR |= (1 << PCIF1);

    // Enable Interrupt for PCINT0
    PCICR |= (1 << PCIE0);
    PCICR |= (1 << PCIE1);
  }

  }


  // #############
  // Setup HX711
  // #############

  // Initialize HX711
  {
  unsigned long ls_divider = 0;

  switch (LS_GAIN) {
    case 128:
      // HX711 full range at 128 gain is +-20mv
      // 8388608 is max digital value (max + or -)
      // Load Cell supply voltage: 5
      // (8388608 / 20) * (5 * LS_MV_PER_V) / LS_MAX_FORCE
      // Numbers pre devided to easy computation at run time
      ls_divider = 8388608 / LS_MAX_FORCE / 20 * 5 * LS_MV_PER_V;
      break;

    case 64:
      // HX711 full range at 64 gain is +-40mv
      ls_divider = 8388608 / LS_MAX_FORCE / 40 * 5 * LS_MV_PER_V ;
      break;

    default:
      Serial.print(" = ERROR = \n Load Cell Gain Invalid");
      break;
  }

  loadcell.begin(LOADCELL_DATA, LOADCELL_CLOCK, LS_GAIN);
  loadcell.set_scale(ls_divider);
  loadcell.set_offset(LS_ZERO_OFFET);
  }
    sei(); //allow interrupts

}

void loop() {
  
  // Check if extenal ESTOP is active, if so turn off arduino estop
  if (stepperStopped) {
    digitalWrite(STEPPER_ENN, HIGH);
    MMTKState = stopped;
  }

  // Buttons
  // Read All buttons and check edge
  {
    forwardButton = updateButtonState(BT_FW, forwardButton);
    backButton = updateButtonState(BT_BK, backButton);
    tareButton = updateButtonState(BT_TARE, tareButton);
    startButton = updateButtonState(BT_START, startButton);
    auxButton = updateButtonState(BT_AUX, auxButton);
  }

  switch (MMTKState) {
    case running: // This is the running and printing stage
      {
        // Press Forward Make Stepper Faster
        if (forwardButton == press) {
          if ((OCR1A + STEPPER_SPEED_INCREMENT) < STEPPER_MAX_TIMER) {
            OCR1A += STEPPER_SPEED_INCREMENT;
          }
          break;
        }
        // Press Forward Make Stepper Slower
        if (backButton == press) {
          if ((OCR1A - STEPPER_SPEED_INCREMENT) < STEPPER_MIN_TIMER) {
            OCR1A -= STEPPER_SPEED_INCREMENT;
          }
          break;
        }
        // Press Aux Button Again To Pause
        if (auxButton == press || auxButton == down ) {
          MMTKState = hold;
          break;
        }
        // Start and Aux Button not used

      }

    case stopped: // Stopped, Motor is Disabled (HIGH-Z)
      {
        if (auxButton == press || auxButton == down) {
          // Only allow transition out of stopped if stepper is not in haulted state
          MMTKState = hold;
          break;
        }
        if (tareButton == press || tareButton == down) {
          loadcell.tare();
          break;
        }
      }
    
    case hold: // Stopped, Motor is Stopped and Hold
      {
        if (forwardButton == press || forwardButton == down) {
          MMTKState = jogFwd;
          break;
        }
        if (backButton == press || backButton == down) {
          MMTKState = jogBak;
          break;
        }
        if (startButton == press || startButton == down) {
          MMTKState = running;
          break;
        }
        if (tareButton == press || tareButton == down) {
          loadcell.tare();
          break;
        }
        if (auxButton == press || auxButton == down) {
          MMTKState = stopped;
          break;
        }
      }
    
    case jogFwd: // jogging forward
      {
        if (forwardButton == up || forwardButton == release) {
          MMTKState = hold;
          break;
        }
        if (auxButton == press || auxButton == down) {
          MMTKState = hold;
          break;
        }
      }
    
    case jogBak:  // jogging back
      {
        if (backButton == up || backButton == release) {
          MMTKState = hold;
          break;
        }
        if (auxButton == press || auxButton == down) {
          MMTKState = hold;
          break;
        }
      }
    
  }
  
  // Read Loacell
  ls_reading = loadcell.get_units();
  
  // Logging
  // Logging format
  // POSITION LOADCELL FEEDBACK_COUNT STATE ESTOP STALL DIRECTION 

  Serial.print(stepperPosition);
  Serial.print("\t");
  Serial.print(ls_reading);
  Serial.print("\t");
  Serial.print(stepperFeedbackPosition);
  Serial.print("\t");
  Serial.print(MMTKState);
  Serial.print("\t");
  Serial.print(stepperStopped);
  Serial.print("\t");
  Serial.print(stepperStall);
  Serial.print("\t");
  Serial.print(stepperDirection);
  Serial.print("\t");
  Serial.print("\n");

}
