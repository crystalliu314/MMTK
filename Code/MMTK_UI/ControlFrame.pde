// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;
  
  
  public void settings() {
    size(800, 480);
    
  }

  public void setup() {
    surface.setLocation(100, 100);
    surface.setResizable(true);
    surface.setVisible(true);
    frameRate(25);
    cp5 = new ControlP5(this);


    int x = 0;
    int y = 0;
    
    fill(0, 0, 0);
    
    cp5.addTextlabel("label")
      .setText("Cell Stretcher Control Panel")
      .setPosition(x=15, y=5)
      .setColorValue(color(0, 0, 0))
      .setFont(createFont("Arial", 22));
    
    //cp5.addTextfield("input speed")
    //  .setPosition(x=15, y=50)
    //  .setColorValue(color(0, 0, 0))
    //  .setColorCursor(color(0, 0, 0))
    //  .setColorLabel(color(0, 0, 0))
    //  .setColorBackground(color(255, 255, 255))
    //  .setFont(createFont("Arial", 14))
    //  .setText("50")
    //  .setSize(100,30)
    //  .setAutoClear(false);
   
    
    
    //cp5.addButton("Tare")
    //  .setValue(1)
    //  .setFont(createFont("Arial Black", 10))
    //  .setPosition(x=15, y=115)
    //  .setSize(250,25);
    
    //cp5.addButton("Start")
    //  .setValue(1)
    //  .setFont(createFont("Arial Black", 10))
    //  .setPosition(x=15, y=155)
    //  .setSize(100,50);
      
     
    //cp5.addButton("Stop")
    //  .setValue(1)
    //  .setFont(createFont("Arial Black", 10))
    //  .setPosition(x+150, y)
    //  .setSize(100,50);
      
    cp5.addButton("Square")
      .setValue(1)
      .setFont(createFont("Arial Black", 10))
      .setPosition(x, y=50)
      .setSize(100,25);
      
    cp5.addButton("Sinusoid")
      .setValue(1)
      .setFont(createFont("Arial Black", 10))
      .setPosition(x+150, y=50)
      .setSize(100,25);

    cp5.addTextfield("stretch length (mm)")
      .setPosition(x=15, y+80)
      .setColorValue(color(0, 0, 0))
      .setColorCursor(color(0, 0, 0))
      .setColorLabel(color(0, 0, 0))
      .setColorBackground(color(255, 255, 255))
      .setFont(createFont("Arial", 14))
      .setText("20")
      .setSize(100,30)
      .setAutoClear(false);
      
    cp5.addButton("Run")
      .setValue(1)
      .setFont(createFont("Arial Black", 10))
      .setPosition(x+190, y+80)
      .setSize(100,50);
   
    cp5.addTextfield("time A")
      .setPosition(x, y = 195)
      .setColorValue(color(0, 0, 0))
      .setColorCursor(color(0, 0, 0))
      .setColorLabel(color(68, 114, 196))
      .setColorBackground(color(68, 114, 196))
      .setFont(createFont("Arial", 14))
      .setText("5.0")
      .setSize(50,30)
      .setAutoClear(false);
      
    cp5.addTextfield("time B")
      .setPosition(x+80, y)
      .setColorValue(color(0, 0, 0))
      .setColorCursor(color(0, 0, 0))
      .setColorLabel(color(237, 125, 49))
      .setColorBackground(color(237, 125, 49))
      .setFont(createFont("Arial", 14))
      .setText("2.0")
      .setSize(50,30)
      .setAutoClear(false);

    cp5.addTextfield("time C")
      .setPosition(x+160, y)
      .setColorValue(color(0, 0, 0))
      .setColorCursor(color(0, 0, 0))
      .setColorLabel(color(255, 192, 0))
      .setColorBackground(color(255, 192, 0))
      .setFont(createFont("Arial", 14))
      .setText("5.0")
      .setSize(50,30)
      .setAutoClear(false);
      
    cp5.addTextfield("time D")
      .setPosition(x+240, y)
      .setColorValue(color(0, 0, 0))
      .setColorCursor(color(0, 0, 0))
      .setColorLabel(color(112, 173, 71))
      .setColorBackground(color(112, 173, 71))
      .setFont(createFont("Arial", 14))
      .setText("2.0")
      .setSize(50,30)
      .setAutoClear(false);
      
    cp5.addTextfield("Hour")
      .setPosition(x=15, y=285)
      .setColorValue(color(0, 0, 0))
      .setColorCursor(color(0, 0, 0))
      .setColorLabel(color(0, 0, 0))
      .setColorBackground(color(255, 255, 255))
      .setFont(createFont("Arial", 14))
      .setText("0")
      .setSize(50,30)
      .setAutoClear(false);
      
    cp5.addTextfield("Min")
      .setPosition(x+80, y)
      .setColorValue(color(0, 0, 0))
      .setColorCursor(color(0, 0, 0))
      .setColorLabel(color(0, 0, 0))
      .setColorBackground(color(255, 255, 255))
      .setFont(createFont("Arial", 14))
      .setText("0")
      .setSize(50,30)
      .setAutoClear(false);
      
      
      
    textFont(createFont("Arial", 16, true));
    


  }



  void controlEvent(ControlEvent theEvent) {
    print(theEvent);
    if (theEvent.isAssignableFrom(Textfield.class) || theEvent.isAssignableFrom(Toggle.class) || theEvent.isAssignableFrom(Button.class)) {
      String parameter = theEvent.getName();
      String value = "";
      if (theEvent.isAssignableFrom(Textfield.class))
        value = theEvent.getStringValue();
      else if (theEvent.isAssignableFrom(Toggle.class) || theEvent.isAssignableFrom(Button.class))
        value = theEvent.getValue()+"";

      print("set "+parameter+" "+value+";\n");
      
      if (parameter == "input speed") {
        mmtkVel = float(value);
        serialPort.write("V" + mmtkVel + "\n");
      }
      
      if (parameter == "stretch length (mm)") {
        stretchL = float(value)*1000;
      }
      
      if (parameter == "time A") {
        timeA = float(value)*1000;
      }
 
      if (parameter == "time B") {
        timeB = float(value)*1000;
      }
      
      if (parameter == "time C") {
        timeC = float(value)*1000;
      }
      
      if (parameter == "time D") {
        timeD = float(value)*1000;
      }
      
      cycleT = (timeA + timeB + timeC + timeD);
      
      if (parameter == "Run") {
        patternReady = 1;
        startT = millis();
      }
      
      if (parameter == "Square") {
        squareWave = 1;
        sinWave = 0;
      }
      
      if (parameter == "Sinusoid") {
        sinWave = 1;
        squareWave = 0;
      }
      
 
      // Send Serial Commands to MMTK
      if (!mockupSerial) {
        if (parameter == "Start") {
          serialPort.write("Begin\n");
        } else if (parameter == "Tare") {
          serialPort.write("Tare\n");
        } else if (parameter == "Stop") {
          serialPort.write("Stop\n");
        } else if (parameter == "5kg calibration"){
          serialPort.write("Calibration\n");
        }
      }
      
    }
  }

  public void draw() {
    background(bgColor);
    //text("Current Speed: " + String.format("%.02f", mmtkVel) + " mm/min", 125, 70);
    text("Wave Form: ", 15, 100);
    if (squareWave == 1){
    text("Square", 105, 100);
    wavePattern = loadImage(topSketchPath+"/images/SquarePattern.jpg");
    image(wavePattern, 350, 50, 293, 181);
    }
    if (sinWave == 1){
    text("Sinusoid", 105, 100);
    wavePattern = loadImage(topSketchPath+"/images/SinPattern.jpg");
    image(wavePattern, 350, 50, 293, 181);
    }
    text("Machine run time: ", 15, 270);

  }

  private ControlFrame() {
  }

  public ControlFrame(PApplet theParent, int theWidth, int theHeight, String _name) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }


  public ControlP5 control() {
    return cp5;
  }


  ControlP5 cp5;

  PApplet parent;
}
