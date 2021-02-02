// If you want to debug the plotter without using a real serial port
// MOdified to mock a mmtk output
// SPEED POSITION LOADCELL FEEDBACK_COUNT STATE ESTOP STALL DIRECTION INPUT_VOLTAGE BT_FWD BT_BAK BT_TARE BT_START BT_AUX
// typedef enum {running, stopped, hold, jogFwd, jogBak, fastFwd, fastBak, noChange} MMTKState_t;

import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;
Random rand = new Random();

// These values are retained after function exits

int mockNewData = 0;
float mockSpeed = 0.0;
float mockPosition = 0;
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
  mockPosition += 0.1;
  
  if (mockPosition > 150) {
    mockPosition = 0;
  }
  
  if (mockLoadCell > 500) {
    mockLoadCell = 0;
  }
  
  mockLoadCell += rand.nextFloat();
  
  mockFeedBack += 1;
  
  mockSpeed = (mockLoadCell + mockPosition) / 3;
  
  mockInputVolts = 11.5 + rand.nextFloat();
  
  if (mockPosition % 5 <= 0.1) {
    mockState = ThreadLocalRandom.current().nextInt(0, 6);
  }
  
  if (mockPosition % 1 <= 0.1) {
    mockEstop = rand.nextFloat() > 0.3;
    mockStall = rand.nextFloat() > 0.4;
    mockDirection = rand.nextFloat() > 0.5;
    mockBtBak = rand.nextFloat() > 0.7;
    mockBtFwd = rand.nextFloat() > 0.3;
    mockBtTare = rand.nextFloat() > 0.4;
    mockBtStart = rand.nextFloat() > 0.5;
    mockBtAux = rand.nextFloat() > 0.6;
  }
  
  if (mockNewData == 1) {
    mockNewData = 0;
  } else {
    mockNewData = 1;
  }
    
    
  String r = "";
  mockNewData = rand.nextFloat() > 0.5 ? 1 : 0;
  
  r += mockNewData+"\t";
  r += mockSpeed+"\t";
  r += mockPosition+"\t";
  r += mockLoadCell+"\t";
  r += mockFeedBack+"\t";
  r += mockState+"\t";
  
  if (mockEstop) {
    r += "1\t";
  } else {
    r += "0\t";
  }
  
  if (mockStall) {
    r += "1\t";
  } else {
    r += "0\t";
  }
  
  if (mockDirection) {
    r += "1\t";
  } else {
    r += "0\t";
  }
  
  r += mockInputVolts+"\t";
  
  if (mockBtFwd) {
    r += "1\t";
  } else {
    r += "0\t";
  }
  
  if (mockBtBak) {
    r += "1\t";
  } else {
    r += "0\t";
  }
  
  if (mockBtTare) {
    r += "1\t";
  } else {
    r += "0\t";
  }
  
  if (mockBtStart) {
    r += "1\t";
  } else {
    r += "0\t";
  }
  
  if (mockBtAux) {
    r += "1\t";
  } else {
    r += "0\t";
  }
  
  r += '\n';
  delay(10);
  return r;
}
