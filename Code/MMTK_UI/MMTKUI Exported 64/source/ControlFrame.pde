// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;

  float mmtkVel = 50.0;
  int bgColor = 100;

  public void settings() {
    size(w, h);
    
  }

  public void setup() {
    surface.setLocation(100, 100);
    surface.setResizable(false);
    surface.setVisible(true);
    frameRate(25);
    cp5 = new ControlP5(this);


    int x = 0;
    int y = 0;
    
    cp5.addTextlabel("label")
      .setText("Set Movment Speed (mm per second)")
      .setPosition(x=5, y=5)
      .setFont(createFont("Georgia", 24));
    
    cp5.addTextfield("runVel")
      .setPosition(x=15, y=35)
      .setText("50")
      .setSize(100,30)
      .setAutoClear(true);
      
    cp5.addButton("Tare")
      .setValue(1)
      .setPosition(x=5, y=100)
      .setSize(150,25);
    
    cp5.addButton("Start")
      .setValue(1)
      .setPosition(x=5, y=150)
      .setSize(100,50);
      
     
    cp5.addButton("Stop")
      .setValue(1)
      .setPosition(x+150, y)
      .setSize(100,50);

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
      
      if (parameter == "runVel") {
        mmtkVel = float(value);
        serialPort.write("V" + mmtkVel + "\n");
      }
      
      // Send Serial Commands to MMTK
      if (!mockupSerial) {
        if (parameter == "Start") {
          serialPort.write("Begin\n");
        } else if (parameter == "Tare") {
          serialPort.write("Tare\n");
        } else if (parameter == "Stop") {
          serialPort.write("Stop\n");
        }
      }
      
    }
  }

  public void draw() {
    background(bgColor);
    text("Speed Set: " + String.format("%.03f", mmtkVel) + " MM/min", 125, 55);
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
