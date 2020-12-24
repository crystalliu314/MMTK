// If you want to debug the plotter without using a real serial port
// MOdified to mock a mmtk output
// SPEED POSITION LOADCELL FEEDBACK_COUNT STATE ESTOP STALL DIRECTION INPUT_VOLTAGE BT_FWD BT_BAK BT_TARE BT_START BT_AUX
// typedef enum {running, stopped, hold, jogFwd, jogBak, fastFwd, fastBak, noChange} MMTKState_t;

// These values are retained after function exits





String mockupSerialFunction() {

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
      r += mockEstop+" ";
      break;
    case 6:
      r += mockStall+" ";
      break;
    case 7:
      r += mockDirection+" ";
      break;
    case 8:
      r += mockInputVolts+" ";
      break;
    case 9:
      r += mockBtFwd+" ";
      break;
    case 10:
      r += mockBtBak+" ";
      break;
    case 11:
      r += mockBtTare+" ";
      break;
    case 12:
      r += mockBtStart+" ";
      break;
    case 13:
      r += mockBtAux+" ";
      break;
    }
    if (i < 7)
      r += '\r';
  }
  delay(10);
  return r;
}
