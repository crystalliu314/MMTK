#include <arduino.h>
#include <EEPROM.h>
#include <HX711.h>
#include "MMTK_V1.h" 
#include <TMCStepper.h>

// QA Mode Toggle
//#define QAMODE true

#define HEADER_TEXT "NEW_DATA\tSPEED\tPOSITION\tLOADCELL\tFEEDBACK_COUNT\tSTATE\tESTOP\tSTALL\tDIRECTION\tINPUT_VOLTAGE\tBT_FWD\tBT_BAK\tBT_TARE\tBT_START\tBT_AUX\n"

// General Vars
double TMC_PulsePerRev = 0.0f;
bool eStopInput = true;
bool stepperDirection = 0;
bool stepperStall = false;
bool lastIndexPin = 0;
bool currentIndexPin = 0;
long stepperPosition = 0;
long stepperFeedbackPosition = 0;
float stepperSpeed = 0.0f;
// Set this to select if printing of data should continute when MMTK is haulted
bool printWhileStopped = true;
// Set when there is a new data point from load cell
bool newLsData = false;

unsigned int stepperRunTimer = STEPPER_DEFAULT_TIMER; // Set Normal Jog Speed

unsigned long loopLastMillis = 0;
unsigned long millisPerLoop = 40;
unsigned long LC_divider = 0;
long LC_offset = 0;

#ifdef READ_POWER_VOLTAGE
  float powerInput = 0.0f;
#else
  bool powerInput = false;
#endif



typedef enum {running, stopped, hold, jogFwd, jogBak, fastFwd, fastBak, noChange} MMTKState_t;
MMTKState_t MMTKState = stopped;
MMTKState_t MMTKNextState = noChange;

typedef enum {down, up, press, release} ButtonState_t;
ButtonState_t forwardButton, backButton, startButton, tareButton, auxButton;

HX711 loadcell;
float LC_reading;

#ifdef QAMODE
// QA mode only vars
bool buttonFwPressed = 0;
bool buttonBkPressed = 0;
bool buttonTarePressed = 0;
bool buttonStartPressed = 0;
bool buttonAuxPressed = 0;
bool eStopOn = 0;
bool eStopOff = 0;

#endif


// Timer ISR for stepping motor and recording steps
ISR(TIMER1_COMPA_vect) {
  if (eStopInput) {
    return;
  }

  // Check Index Pin, if that is high, increment index counter
  #ifdef USE_DIRECT_PORT_MANIPULATION_FOR_INDEX
    if (STEPPER_INDEX_PORT & (1 << STEPPER_INDEX_PIN)) {
  #else 
    if (digitalRead(STEPPER_INDEX)) {
  #endif
      if (stepperDirection) {
      stepperFeedbackPosition--;
    } else {
      stepperFeedbackPosition++;
    }
  }

  // Check Diag Pin, if that is high we stalled last step
  #ifdef USE_DIRECT_PORT_MANIPULATION_FOR_DIAG
    stepperStall =  (STEPPER_DIAG_PORT & (1 << STEPPER_DIAG_PIN));
  #else 
    stepperStall = digitalRead(STEPPER_DIAG);
  #endif
 
  if (!stepperStall) {
    if (stepperDirection) {
      stepperPosition--;
    } else {
      stepperPosition++;
    }
  }

  #ifdef USE_DIRECT_PORT_MANIPULATION_FOR_STEP
    STEPPER_STEP_PORT ^= 1 << STEPPER_STEP_PIN;
  #else
    digitalWrite(STEPPER_STEP, !digitalRead(STEPPER_STEP));
  #endif

}

// ******************
// Helper Functions
// ******************

// Read state of buttons and capture edges
ButtonState_t updateButtonState (int buttonToCheck, ButtonState_t lastState) {
  if (!digitalRead(buttonToCheck)) {
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

// Calculate travel speed based on the motor timer, prescalers, and ball screw pitch
float getCurrentSpeed() {
  // Factors that affect speed:
  // Microstepping: TMC_MICROSTEPS
  // Ball Screw Pitch: MECH_MM_PER_REV
  // Timer Prescaler: This is fixed at 8 for now
  // Type casing after some dividing because interger operation is faster
  // and the first few divisions are by powers of 2 so there won't be remainders
  //
  // Function return is mm/min
  if (eStopInput || !TIMSK1) {
    return 0.0f;
  } else {
    return ( (float)(F_CPU / 8 / TMC_MICROSTEPS) / MECH_STEP_PER_REV / (unsigned int)OCR1A * MECH_MM_PER_REV * 60);
  }
  
}

void tareAll() {
  loadcell.tare();
  stepperPosition = 0;
  stepperFeedbackPosition = 0;
  Serial.println(" ========= TARE ==========");
  Serial.print(HEADER_TEXT);
}

void setup() {
  loopLastMillis = millis();

  cli(); //stop interrupts

  // #############
  // Pin Config
  // #############
  {
    pinMode(STEPPER_DIR, OUTPUT);
    digitalWrite(STEPPER_DIR, LOW);
    
    pinMode(STEPPER_STEP, OUTPUT);
    digitalWrite(STEPPER_STEP, LOW);
    
    pinMode(STEPPER_ENN, OUTPUT);
    digitalWrite(STEPPER_ENN, LOW);
    
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
    digitalWrite(LED_AUX, LOW);


  }

  // #############
  // Setup Serial Logging
  // #############

  {
    // Faster Baud is great because logging is blocking
    Serial.begin(250000);

    // Print Headers here once we figure out
    Serial.print(HEADER_TEXT);
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
    OCR1A = STEPPER_DEFAULT_TIMER;// = (16*10^6) / (1*1024) - 1 (must be <65536)
    // turn on CTC mode
    TCCR1B |= (1 << WGM12);
    // Set CS11 bits for 8 prescaler
    TCCR1B |= (1 << CS11);
    // enable timer compare interrupt
    TIMSK1 |= (1 << OCIE1A);
  }

  }


  // #############
  // Setup HX711
  // #############

  // Initialize HX711
  {

  // Check EEPROM if there is a stored value. Do this by verifying eeprom magic value
  unsigned long eepromMagicRead = 0UL;
  if (EEPROM.get(EEPROM_MAGIC_VALUE_ADDRESS, eepromMagicRead) == EEPROM_MAGIC_VALUE) {
    // eeprom magic match
    EEPROM.get(EEPROM_LC_DIVIDER_ADDRESS, LC_divider);
    EEPROM.get(EEPROM_LC_OFFSET_ADDRESS, LC_offset);
  } 
  else 
  {
    switch (LC_DEFAULT_GAIN) {
        case 128:
          // HX711 full range at 128 gain is +-20mv
          // 8388608 is max digital value (max + or -)
          // Load Cell supply voltage: 5
          // (8388608 / 20) * (DRIVE_VOLTAGE * LC_MV_PER_V) / LC_MAX_FORCE
          // Numbers pre devided to easy computation at run time
          LC_divider = (unsigned long) (8388608 / LC_MAX_FORCE / 20 * LC_DRIVE_VOLTAGE * LC_MV_PER_V);
          break;
  
        case 64:
          // HX711 full range at 64 gain is +-40mv
          LC_divider = (unsigned long) (8388608 / LC_MAX_FORCE / 40 * LC_DRIVE_VOLTAGE * LC_MV_PER_V);
          break;
  
        default:
          Serial.print(" = ERROR = \n Load Cell Gain Invalid");
          break;
      }
      LC_offset = LC_DEFAULT_ZERO_OFFSET;
  }

  loadcell.begin(LOADCELL_DATA, LOADCELL_CLOCK);
  loadcell.set_scale(LC_divider);
  loadcell.set_offset(LC_offset);
  }
  

  // Next State is Stop
  TIMSK1 = 0; // Stop Motor
  digitalWrite(STEPPER_ENN, HIGH); // Motor is Disabled, unlocked
  digitalWrite(LED_RUN, LOW); // RUN LED is OFF
  digitalWrite(LED_AUX, LOW); // AUX LES is OFF
  MMTKState = stopped;

  sei(); //allow interrupts

}



// ******************************
// *** MAIN LOOP START HERE *****
// ******************************

void loop() {

  // Monitor Estop Button
  #ifdef USE_DIRECT_PORT_MANIPULATION_FOR_ENN_SENSE
    eStopInput = (STEPPER_ENN_SENS_PORT & (1 << STEPPER_ENN_SENS_PIN));
  #else
    eStopInput = digitalRead(STEPPER_ENN_SENS);
  #endif

  
  // Check if extenal ESTOP is active, if so turn off arduino estop
  if (eStopInput) {
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

  MMTKNextState = noChange;

  // ****************************
  // ** Serial Command Parsing **
  // ****************************

  if (Serial.available()) {
    int incomingByte = Serial.read();

    if (incomingByte == 'v' || incomingByte == 'V') {
      // Set Speed Command
      float newSpeed = Serial.parseFloat();
      if (!isnan(newSpeed)) {
        // convert mm/min to step timer
        unsigned int newTimerValue;

        if (newSpeed < 6.0f) newSpeed = 6.0;
        // The equation below causes a interger overflow, so swap around order to remedy that
        // newTimerValue = (int) ((F_CPU * 60 * MECH_MM_PER_REV) / (newSpeed * MECH_STEP_PER_REV * TMC_MICROSTEPS * 8));
        newTimerValue = (unsigned int) (F_CPU / 8 / TMC_MICROSTEPS * 60 * MECH_MM_PER_REV / MECH_STEP_PER_REV / newSpeed);
        Serial.print(F("== NEW SPEED: "));
        Serial.print(newSpeed);
        Serial.print(F(" -- "));
        Serial.println(newTimerValue);

        // Verify value is valid
        if ( newTimerValue < STEPPER_MAX_TIMER && newTimerValue > STEPPER_MIN_TIMER) {
          stepperRunTimer = newTimerValue;
          OCR1A = stepperRunTimer;
          stepperSpeed = getCurrentSpeed();
        }
      }
      
    }

    if (incomingByte == 'b' || incomingByte == 'B') {
      if (Serial.readStringUntil('\n') == "egin") {
        // Start Running
        if (MMTKState == hold) {
          MMTKNextState = running;
        }
      }
    }
    if (incomingByte == 'c' || incomingByte == 'C') {      
      LC_divider = loadcell.get_value(10)/49;
      loadcell.set_scale(LC_divider);
      EEPROM.put(EEPROM_MAGIC_VALUE_ADDRESS, (unsigned long)EEPROM_MAGIC_VALUE);
      EEPROM.put(EEPROM_LC_DIVIDER_ADDRESS, LC_divider);
      EEPROM.put(EEPROM_LC_OFFSET_ADDRESS, loadcell.get_offset());
    }

    if (incomingByte == 's' || incomingByte == 'S') {      
      if (MMTKState == running) {
        MMTKNextState = hold;
      }
    }

    if (incomingByte == 't' || incomingByte == 'T') {
      if (Serial.readStringUntil('\n') == "are") {
        if (MMTKState != running) {
          tareAll();
        }
      }
    }
    
    // Other start symbols ignored
  }




  switch (MMTKState) {
    case running: // This is the running and printing stage
      // Press Forward Make Stepper Faster
      if (forwardButton == press) {
        if ((OCR1A + STEPPER_SPEED_INCREMENT) < STEPPER_MAX_TIMER) {
          OCR1A += STEPPER_SPEED_INCREMENT;
        }
        stepperSpeed = getCurrentSpeed();
        break;
      }
      // Press Forward Make Stepper Slower
      if (backButton == press) {
        if ((OCR1A - STEPPER_SPEED_INCREMENT) > STEPPER_MIN_TIMER) {
          OCR1A -= STEPPER_SPEED_INCREMENT;
        }
        stepperSpeed = getCurrentSpeed();
        break;
      }
      // Press Aux Button To Pause
      if (auxButton == press) {
        MMTKNextState = hold;
        break;
      }
      break;
      // If motor stalled, and we are configured to haut movement when stalled
      if ((bool)STEPPER_HAULT_WHEN_STALL && stepperStall) {
        MMTKNextState = hold;
        break;
      }

    case stopped: // Stopped, Motor is Disabled (HIGH-Z)
      if (auxButton == press) {
        // Only allow transition out of stopped if stepper is not in haulted state
        MMTKNextState = hold;
        break;
      }
      if (tareButton == press || tareButton == down) {
          tareAll();
        break;
      }
      break;
    
    case hold: // Stopped, Motor is Stopped and Hold
      if (auxButton == press || auxButton == down) {
        // Jogging with Aux button held will initiate fast jog
        if (forwardButton == press || forwardButton == down) {
          MMTKNextState = fastFwd;
          break;
        }
        if (backButton == press || backButton == down) {
          MMTKNextState = fastBak;
          break;
        }
      }

      // Jog buttons will initiate slow jog
      if (forwardButton == press || forwardButton == down) {
        MMTKNextState = jogFwd;
        break;
      }
      if (backButton == press || backButton == down) {
        MMTKNextState = jogBak;
        break;
      }

      if (startButton == press || startButton == down) {
        MMTKNextState = running;        
        break;
      }
      if (tareButton == press || tareButton == down) {
          tareAll();
        break;
      }
      break;
    
    case jogFwd: // jogging forward
      if (forwardButton == up || forwardButton == release) {
        MMTKNextState = hold;
        break;
      }
      if (auxButton == press || auxButton == down) {
        MMTKNextState = fastFwd;
        break;
      }
      break;
    
    case jogBak:  // jogging back
      if (backButton == up || backButton == release) {
        MMTKNextState = hold;
        break;
      }
      if (auxButton == press || auxButton == down) {
        MMTKNextState = fastBak;
        break;
      }
      break;

    case fastFwd: // fast jogging forward
      if (forwardButton == up || forwardButton == release) {
        MMTKNextState = hold;
        break;
      }
      if (auxButton == release || auxButton == up) {
        MMTKNextState = jogFwd;
        break;
      }
      break;
    
    case fastBak:  // fast jogging back
      if (backButton == up || backButton == release) {
        MMTKNextState = hold;
        break;
      }
      if (auxButton == release || auxButton == up) {
        MMTKNextState = jogBak;
        break;
      }
      break;

    default:
      MMTKNextState = stopped;
      break;
  }
  
  // Read Power Input, If Power Input is not connected, stay stopped
  #ifdef READ_POWER_VOLTAGE
    powerInput = (float)(analogRead(POWER_SENSE)) / POWER_SENSE_SCALE;
    if (powerInput < 6.0f) {
      MMTKNextState = stopped;
    }
  #else
    powerInput = digitalRead(POWER_SENSE);
    if (!powerInput) {
      MMTKNextState = stopped;
    }
  #endif


  // State Transitions
  switch (MMTKNextState)
  {
  case running: // Transition into running state
      // Next State is hold
      stepperDirection = 0; // Run Forward
      digitalWrite(STEPPER_DIR, stepperDirection);
      TIMSK1 |= (1 << OCIE1A); // Start Motor
      digitalWrite(STEPPER_ENN, LOW); // Motor is Disabled, unlocked
      digitalWrite(LED_RUN, HIGH); // RUN LED is ON
      digitalWrite(LED_AUX, LOW); // AUX LED is OFF
      OCR1A = stepperRunTimer;
      stepperSpeed = getCurrentSpeed();
      MMTKState = running;
    break;
  case stopped:
      // Next State is Stop
      TIMSK1 = 0; // Stop Motor
      digitalWrite(STEPPER_ENN, HIGH); // Motor is Disabled, unlocked
      digitalWrite(LED_RUN, LOW); // RUN LED is OFF
      digitalWrite(LED_AUX, LOW); // AUX LED is OFF
      stepperSpeed = getCurrentSpeed();
      MMTKState = stopped;
    break;
  case hold: 
      // Next State is hold
      TIMSK1 = 0; // Stop Motor
      digitalWrite(STEPPER_ENN, LOW); // Motor is Enabled, locked
      digitalWrite(LED_RUN, LOW); // RUN LED is OFF
      digitalWrite(LED_AUX, LOW); // AUX LED is OFF
      OCR1A = stepperRunTimer;
      stepperSpeed = getCurrentSpeed();
      MMTKState = hold;
      delay(10);
    break;
  case jogFwd:
      stepperDirection = 1; // Direction, Forward
      digitalWrite(STEPPER_DIR, HIGH);
      TIMSK1 |= (1 << OCIE1A); // Start Motor
      digitalWrite(STEPPER_ENN, LOW); // Motor is Enabled
      digitalWrite(LED_RUN, LOW); // RUN LED is OFF
      digitalWrite(LED_AUX, HIGH); // AUX LED is ON
      OCR1A = STEPPER_NORMAL_JOG_TIMER; // Set Normal Jog Speed
      stepperSpeed = getCurrentSpeed();
      MMTKState = jogFwd;
    break;
  case fastFwd:
      stepperDirection = 1; // Direction, Forward
      digitalWrite(STEPPER_DIR, HIGH);
      TIMSK1 |= (1 << OCIE1A); // Start Motor
      digitalWrite(STEPPER_ENN, LOW); // Motor is Enabled
      digitalWrite(LED_RUN, LOW); // RUN LED is OFF
      digitalWrite(LED_AUX, HIGH); // AUX LED is ON
      OCR1A = STEPPER_FAST_JOG_TIMER; // Set Fast Jog Speed
      stepperSpeed = getCurrentSpeed();
      MMTKState = fastFwd;
    break;
  case jogBak:
      stepperDirection = 0; // Direction, Back
      digitalWrite(STEPPER_DIR, LOW);
      TIMSK1 |= (1 << OCIE1A); // Start Motor
      digitalWrite(STEPPER_ENN, LOW); // Motor is Enabled
      digitalWrite(LED_RUN, LOW); // RUN LED is OFF
      digitalWrite(LED_AUX, HIGH); // AUX LED is ON
      OCR1A = STEPPER_NORMAL_JOG_TIMER; // Set Normal Jog Speed
      stepperSpeed = getCurrentSpeed();
      MMTKState = jogBak;
    break;
  case fastBak:
      stepperDirection = 0; // Direction, Back
      digitalWrite(STEPPER_DIR, LOW);
      TIMSK1 |= (1 << OCIE1A); // Start Motor
      digitalWrite(STEPPER_ENN, LOW); // Motor is Enabled
      digitalWrite(LED_RUN, LOW); // RUN LED is OFF
      digitalWrite(LED_AUX, HIGH); // AUX LED is ON
      OCR1A = STEPPER_FAST_JOG_TIMER; // Set Fast Jog Speed
      stepperSpeed = getCurrentSpeed();
      MMTKState = fastBak;
    break;
  default: // No change
    break;
  }
      
  // Limit Rate of the main loop here so we do not overwhelm the UI
    if ((millis() - loopLastMillis) < millisPerLoop) {
      return;
    }
    loopLastMillis = millis();

  // Read Loacell
  // Remove the if statement if you wish to print slower and only new new loadcell value is available
  if (loadcell.is_ready()) {
    LC_reading = loadcell.get_units(1);
    newLsData = true;
  } else {
    newLsData = false;
  }


  #ifdef QAMODE
  if (forwardButton == press) {
    // Forward button was pressed
    buttonFwPressed = true;
  }
  if (backButton == press) {
    // Back button was pressed
    buttonBkPressed = true;
  }

  if (startButton == press) {
    // Start button was pressed
    buttonTarePressed = true;
  }

  if (tareButton == press) {
    // Tare button was pressed
    buttonStartPressed = true;
  }

  if (auxButton == press) {
    // Aux button was pressed
    buttonAuxPressed = true;
  }

  if (eStopInput && eStopOff) {
    eStopOn = true;
  }

  if (!eStopInput) {
    eStopOff = true;
  }

  // Logging in QA Mode
  // Normal format + button states
  delay(100);
  #endif


  // Logging
  // Logging format
  // NEW_DATA SPEED POSITION LOADCELL FEEDBACK_COUNT STATE ESTOP STALL DIRECTION INPUT_VOLTAGE
  if (MMTKState != stopped || printWhileStopped) {  

    Serial.print(newLsData ? 1:0);
    Serial.print("\t");

    Serial.print(stepperSpeed);
    Serial.print("\t");
    float stepperPositionFloat = (float) stepperPosition / TMC_MICROSTEPS / MECH_STEP_PER_REV * MECH_MM_PER_REV/2;
    Serial.print(stepperPositionFloat);
    Serial.print("\t");
    Serial.print(LC_reading);
    Serial.print("\t");
    Serial.print(stepperFeedbackPosition);
    Serial.print("\t");
    Serial.print(MMTKState);
    Serial.print("\t");
    Serial.print(eStopInput);
    Serial.print("\t");
    Serial.print(stepperStall);
    Serial.print("\t");
    Serial.print(stepperDirection);
    Serial.print("\t");

    Serial.print(powerInput);
    Serial.print("\t");
    
    Serial.print(forwardButton);
    Serial.print("\t");
    Serial.print(backButton);
    Serial.print("\t");
    Serial.print(tareButton);
    Serial.print("\t");
    Serial.print(startButton);
    Serial.print("\t");
    Serial.print(auxButton);
    Serial.print("\t");

    
  #ifdef QAMODE
  // QAMODE
  if (buttonFwPressed) {  
    Serial.print("OK");
  } else {
    Serial.print("-");
  }
  Serial.print("\t");
  
  if (buttonBkPressed) {  
    Serial.print("OK");
  } else {
    Serial.print("-");
  }
  Serial.print("\t");
  
  if (buttonTarePressed) {  
    Serial.print("OK");
  } else {
    Serial.print("-");
  }
  Serial.print("\t");
  
  if (buttonStartPressed) {  
    Serial.print("OK");
  } else {
    Serial.print("-");
  }
  Serial.print("\t");
  
  if (buttonAuxPressed) {  
    Serial.print("OK");
  } else {
    Serial.print("-");
  }
  Serial.print("\t");
  
  if (eStopOff) {  
    Serial.print("OK");
  } else {
    Serial.print("-");
  }
  Serial.print("\t");
  
  if (eStopOn) {  
    Serial.print("OK");
  } else {
    Serial.print("-");
  }
  Serial.print("\t");

  #endif
    
    Serial.print("\n");
  }




}
