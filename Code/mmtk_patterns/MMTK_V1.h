// Board Description for MMTK V1
#pragma once

// BOARD VERSION
#define BOARD_VERSION 1

// Mechanical Constants
#define MECH_MM_PER_REV 5
#define MECH_STEP_PER_REV 200

// Pin Assignemtns
#define STEPPER_TYPE TMC2209
#define STEPPER_RX 11 // PB3
#define STEPPER_TX 10 // PB2
#define STEPPER_STEP 7 // PD7
#define STEPPER_DIR 6 // PD6
#define STEPPER_ENN 8 // PB0
#define STEPPER_ENN_SENS 9 // PB1  PCINT1 (interrupt PCINT0)
#define STEPPER_MIN_TIMER 250
#define STEPPER_MAX_TIMER 65535
#define STEPPER_DEFAULT_TIMER 7500
#define STEPPER_SPEED_INCREMENT 1000

#define STEPPER_FAST_JOG_TIMER 250
#define STEPPER_NORMAL_JOG_TIMER 750


#define STEPPER_DIAG A4 // PC4
#define STEPPER_INDEX A5 // PC5

// Step port and pin for faster ISR
#define USE_DIRECT_PORT_MANIPULATION_FOR_STEP
#define STEPPER_STEP_PORT PORTD
#define STEPPER_STEP_PIN 7

// ENN Sense port and pin for faster ISR
#define USE_DIRECT_PORT_MANIPULATION_FOR_ENN_SENSE
#define STEPPER_ENN_SENS_PORT PINB
#define STEPPER_ENN_SENS_PIN 1

// DIAG port and pin for faster ISR
#define USE_DIRECT_PORT_MANIPULATION_FOR_DIAG
#define STEPPER_DIAG_PORT PINC
#define STEPPER_DIAG_PIN 4

// INDEX port and pin for faster ISR
#define USE_DIRECT_PORT_MANIPULATION_FOR_INDEX
#define STEPPER_INDEX_PORT PINC
#define STEPPER_INDEX_PIN 5

#define STEPPER_HAULT_WHEN_STALL 1

#define TMC_R_SENS 0.10f
#define TMC_ADDRESS 0b00
#define TMC_RMS_CURRENT 1825
#define TMC_MICROSTEPS 8
#define TMC_STALL_VALUE 5
#define TMC_SS_BAUD 115200

#define BT_FW 2 // S5 - BT3
#define BT_BK 3 // S3 - BT2
#define BT_TARE 4 // S4 - BT1
#define BT_START 5 // S2 - BT0
#define BT_AUX A3 // S1 - BT4

#define LOADCELL_DATA A1
#define LOADCELL_CLOCK A2

#define LED_RUN 12 // D9 - LED0
#define LED_AUX 13 // D10 - LED1


// Load Cell Calibrations
#define LC_MV_PER_V 2
// #define LC_MAX_FORCE 1961 // Test jig with 200KG load cell
#define LC_MAX_FORCE 981 // INT Approximaion, floats are way to expensive on 8 bit
#define LC_DEFAULT_GAIN 128
#define LC_DEFAULT_ZERO_OFFSET 0 // Offset for center value of loadcell
#define LC_DRIVE_VOLTAGE 4.2

// Power input sensing
#define READ_POWER_VOLTAGE // Read Voltage, slightly slower per loop
#define POWER_SENSE A0
#define POWER_SENSE_SCALE 51.2 // Bits per Volt

// EEPROM Constants
#define EEPROM_MAGIC_VALUE 0x7A8176B3
#define EEPROM_MAGIC_VALUE_ADDRESS 0x01
#define EEPROM_LC_DIVIDER_ADDRESS 0x05
#define EEPROM_LC_OFFSET_ADDRESS 0x09
