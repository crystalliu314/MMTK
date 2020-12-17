// Board Description for MMTK V1
#pragma once

// BOARD VERSION
#define BOARD_VERSION 1

// Pin Assignemtns
#define STEPPER_TYPE TMC2209
#define STEPPER_RX 11 // PB3
#define STEPPER_TX 10 // PB2
#define STEPPER_STEP 7 // PD7
#define STEPPER_DIR 6 // PD6
#define STEPPER_ENN 8 // PB0
#define STEPPER_ENN_SENS 9 // PB1  PCINT1 (interrupt PCINT0)

// Step port and pin for faster ISR
#define USE_DIRECT_PORT_MANIPULATION_FOR_STEP
#define STEPPER_ENN_SENS_PORT PORTD
#define STEPPER_ENN_SENS_PIN 7

// Step port and pin for faster ISR
#define USE_DIRECT_PORT_MANIPULATION_FOR_ENN_SENSE
#define STEPPER_STEP_PORT PORTB
#define STEPPER_STEP_PIN 1

#define TMC_R_SENS 0.10f
#define TMC_ADDRESS 0b00
#define TMC_RMS_CURRENT 1900
#define TMC_MICROSTEPS 8
#define TMC_STALL_VALUE 128
#define TMC_SS_BAUD 115200

#define SERVO_DIAG A4
#define SERVO_INDEX A5 // PC5

#define BT_FW 2 // S5 - BT3
#define BT_BK 3 // S3 - BT2
#define BT_TARE 4 // S4 - BT1
#define BT_START 5 // S2 - BT0
#define BT_AUX A3 // S1 - BT4

#define LOADCELL_DATA A1
#define LOADCELL_CLOCK A2

#define LED_RUN 12 // D9 - LED0
#define LED_AUX 13 // D10 - LED1

// Mechanical Constants
#define MECH_STEP_PER_REV 200
#define MECH_MM_PER_REV 5

// Load Cell Calibrations
#define LS_MV_PER_V 2
#define LS_MAX_FORCE 1000
#define LS_GAIN 128
#define LS_N_PER_LSB 4277 // 100kg, 23 effective signed bits, 22 per end


