// If you want to debug the plotter without using a real serial port
// MOdified to mock a mmtk output
// SPEED POSITION LOADCELL FEEDBACK_COUNT STATE ESTOP STALL DIRECTION INPUT_VOLTAGE BT_FWD BT_BAK BT_TARE BT_START BT_AUX
// typedef enum {running, stopped, hold, jogFwd, jogBak, fastFwd, fastBak, noChange} MMTKState_t;

import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;
Random rand = new Random();

// These values are retained after function exits

float mockSpeed = 0.0;
int mockPosition = 0;
float mockLoadCell = 0.0;
int mockFeedBack = 0;
int mockState = 0;
boolean mockEstop = false;
boolean mockStall = false;
boolean mockDirection = false;
float mockInputVolts = 12.0;
boolean mockBtBak = false;
boolean mockBtFwd = false;
boolean mockBtTare = false;
boolean mockBtStart = false;
boolean mockBtAux = false;

String mockupSerialFunction() {
  mockPosition += 1;
  
  if (mockLoadCell > 1000) {
    mockPosition = 0;
  }
  
  if (mockPosition > 1000) {
    mockPosition = 0;
  }
  
  mockLoadCell = mockPosition * mockPosition;
  
  mockFeedBack += 1;
  
  mockSpeed = (mockLoadCell + mockPosition) / 3;
  
  mockInputVolts = 11.5 + rand.nextFloat();
  
  if (mockPosition % 25 == 0) {
    mockState = ThreadLocalRandom.current().nextInt(0, 6);
  }
  
  if (mockPosition % 10 == 0) {
    mockEstop = rand.nextFloat() > 0.3;
    mockStall = rand.nextFloat() > 0.4;
    mockDirection = rand.nextFloat() > 0.5;
    mockBtBak = rand.nextFloat() > 0.7;
    mockBtFwd = rand.nextFloat() > 0.3;
    mockBtTare = rand.nextFloat() > 0.4;
    mockBtStart = rand.nextFloat() > 0.5;
    mockBtAux = rand.nextFloat() > 0.6;
  }
  
  

  String r = "";
  for (int i = 0; i<14; i++) {
    switch (i) {
    case 0:
      r += mockSpeed+" ";
      break;
    case 1:
      r += mockPosition+" ";
      break;
    case 2:
      r += mockLoadCell+" ";
      break;
    case 3:
      r += mockFeedBack+" ";
      break;
    case 4:
      r += mockState+" ";
      break;
    case 5:
      if (mockEstop) {
        r += "1 ";
      } else {
        r += "0 ";
      }
      break;
    case 6:
      if (mockStall) {
        r += "1 ";
      } else {
        r += "0 ";
      }
      break;
    case 7:
      if (mockDirection) {
        r += "1 ";
      } else {
        r += "0 ";
      }
      break;
    case 8:
      r += mockInputVolts+" ";
      break;
    case 9:
      if (mockBtFwd) {
        r += "1 ";
      } else {
        r += "0 ";
      }
      break;
    case 10:
      if (mockBtBak) {
        r += "1 ";
      } else {
        r += "0 ";
      }
      break;
    case 11:
      if (mockBtTare) {
        r += "1 ";
      } else {
        r += "0 ";
      }
      break;
    case 12:
      if (mockBtStart) {
        r += "1 ";
      } else {
        r += "0 ";
      }
      break;
    case 13:
      if (mockBtAux) {
        r += "1 ";
      } else {
        r += "0 ";
      }
      break;
    }
    if (i < 14)
      r += '\r';
  }
  delay(10);
  return r;
}
