// If you want to debug the plotter without using a real serial port

int mockupValue = 0;
int mockupDirection = 1;
String mockupSerialFunction() {
  mockupValue = (mockupValue + mockupDirection);
  if (mockupValue > 1000)
    mockupDirection = -1;
  else if (mockupValue < -1000)
    mockupDirection = 1;
  String r = "";
  for (int i = 0; i<3; i++) {
    switch (i) {
    case 0:
      r += "0 ";
      break;
    case 1:
      r += 10*sin(mockupValue*(2*3.14)/1000)+" ";
      break;
    case 2:
      r += 10*cos(mockupValue*(2*3.14)/1000)+" ";
      break;
    }
    if (i < 7)
      r += '\r';
  }
  delay(10);
  return r;
}
