#include <TMCStepper.h>
#include <HX711.h>
#include "MMTK_V1.h" 

// General Vars
double TMC_PulsePerRev = 0.0f
long stepperPosition = 0
bool stepperStopped = true
enum MMTKStates {running, stopped, hold, jogFwd, jogBak}
enum MMTKStates currentState

// Last Button States
bool lastFwButton, lastBkButton, lastTareButton, lastStartButton, lastAuxButton


// Timer ISR for stepping motor and recording steps
ISR(TIMER1_COMPA_vect){
  
  // Check if motor is enabled
  if stepperStopped {
    return;
  }

  if stepperDirection {
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
    stepperStopped = (STEPPER_ENN_SENS_PORT & (1 << STEPPER_ENN_SENS_PIN))
  #else
    stepperStopped = digitalRead(STEPPER_ENN_SENS)
  #endif
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
    Serial.begin(250000)

    // Print Headers here once we figure out
    Serial.print(" TEST ")
  }

  // #############
  // Setup TMC2209
  // #############
  {
  TMC2209Stepper stepper(STEPPER_RX, STEPPER_TX, TMC_R_SENS, TMC_ADDRESS);
  stpper.beginSerial(TMC_SS_BAUD);

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
    PCMSK0 |= (1 << 1)

    // Clear PCINT1 flag, proably not nessenary
    PCIFR |= (1 << 0)

    // Enable Interrupt for PCINT0
    PCICR |= (1 << 0);
  }

  }


  // #############
  // Setup HX711
  // #############

  // Initialize HX711
  HX711 loadcell;
  loadcell.begin()

  unsigned long ls_divider = 0

  switch LS_GAIN {
    case 128:
      // HX711 full range at 128 gain is +-20mv
      // 8388608 is max digital value (max + or -)
      // Load Cell supply voltage: 5
      // (8388608 / 20) * (5 * LS_MV_PER_V) / LS_MAX_FORCE
      ls_divider = 8388608 * 5 * LS_MV_PER_V / (LS_MAX_FORCE * 20)

    case 64:
      // HX711 full range at 64 gain is +-40mv
      ls_divider = 8388608 * 5 * LS_MV_PER_V / (LS_MAX_FORCE * 40)

    default:
      Serial.print(" = ERROR = \n Load Cell Gain Invalid")
  }

  loadcell.begin(LOADCELL_DATA, LOADCELL_CLOCK, LS_GAIN);
  loadcell.set_scale(ls_divider);
  loadcell.set_offset(LS_ZERO_OFFET);

  
  // #############
  // Setup TMC2209
  // #############

    sei(); //allow interrupts

}

void loop() {
  
  // Check if extenal ESTOP is active, if so turn off arduino estop
  if stepperStopped {
    digitalWrite(STEPPER_ENN, HIGH);
  }

  // State Transitions

  switch currentState {
    case running: 
      {
        if !digitalRead(BT_FW) {
          currentState = jogFwd
          break;
        }
        
        if !digitalRead(BT_BK) {
          currentState = jogBak
          break;
        }


      }

    case stopped:
      {

      }
    
    case hold:
    
    case jogFwd:
    
    case jogBak:
  }
  
  // Logging

  switch currentState {
    case running:
    
    case stopped:
    
    case hold:
    
    case jogFwd:
    
    case jogBak:
  }
  

  // Business Logic
  
  switch currentState {
    case running:

      if loadcell.is_ready() {
        long ls_reading = HX711::read();
      }

    case stopped:

      {

      }
    
    case hold:
    
    case jogFwd:
    
    case jogBak:
  }

}



