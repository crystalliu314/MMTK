import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.Frame; 
import java.awt.BorderLayout; 
import controlP5.*; 
import processing.serial.*; 
import java.util.Arrays; 
import javax.swing.JOptionPane; 
import java.util.Random; 
import java.util.concurrent.ThreadLocalRandom; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MMTK_UI extends PApplet {

 /**
 * MMTK UI
 *
 * Simple UI sketch to plot the output data and show state of buttons and stuff
 *
 * Requires:
 * - ControlP5 library (install from processing)
 * 
 * This is based on Real Time Plotter Library from https://github.com/sebnil/RealtimePlotter
 */
 
// import libraries


 // http://www.sojamo.de/libraries/controlP5/



PFont buttonTitle_f, mmtkState_f, indicatorTitle_f, indicatorNumbers_f;

// If you want to debug the plotter without using a real serial port set this to true
boolean mockupSerial = false;

// Serial Setup
String serialPortName;
Serial serialPort;  // Create object from Serial class

// interface stuff
ControlP5 cp5;
ControlFrame cf;

// Settings for MMUK UI are stored in this config file
JSONObject mmtkUIConfig;

// Generate the plot
int[] XYplotFloatDataDims = {4, 10000};
int[] XYplotIntDataDims = {5, 10000};

// XY Plot
int[] XYplotOrigin = {98, 125};
int[] XYplotSize = {900, 580};
int XYplotColor = color(20, 20, 200);

Graph XYplot = new Graph(XYplotOrigin[0], XYplotOrigin[1], XYplotSize[0], XYplotSize[1], XYplotColor);
float[][] XYplotFloatData = new float[XYplotFloatDataDims[0]][XYplotFloatDataDims[1]];
int[][] XYplotIntData = new int[XYplotIntDataDims[0]][XYplotIntDataDims[1]];
// This value grows and is used for slicing
int XYplotCurrentSize = 0;


// ************************
// ** Variables for Data **
// ************************

int newLoadcellData = 0;
float velocity = 0.0f;
float position = 0.0f;
float positionCorrected = 0.0f;
float loadCell = 0.0f;
int feedBack = 0;
int MMTKState = 7;
int eStop = 0;
int stall = 0;
int direction = 0;
float inputVolts = 12.0f;

int btBak = 0;
int btFwd = 0;
int btTare = 0;
int btStart = 0;
int btAux = 0;

float[] correctionFactors = new float[2];
float maxForce = 0;
float maxDisplacment = 0;


// helper for saving the executing path
String topSketchPath = "";

// Log File
PrintWriter logFile;
boolean logAllData;

// Console Print Configs
boolean printAllData;


// MMTK logo image
PImage mmtkLogo;


public void settings() {
    size(screenSize[0], screenSize[1]);
}

public void setup() 
{
  // settings save file
  topSketchPath = sketchPath();
  mmtkUIConfig = loadJSONObject(topSketchPath+"/mmtk_ui_config.json");

  PImage icon = loadImage(topSketchPath+"/images/icon.png");
  surface.setIcon(icon);
  
  String[] serialPortList = Serial.list();
  String[] serialPortChoices = new String[serialPortList.length + 1];
  for (i = 0; i < Serial.list().length; i++) {
    serialPortChoices[i] = serialPortList[i];
  }
  serialPortChoices[serialPortChoices.length - 1] = "- Mock Serial For Testing -";
  
  cf = new ControlFrame(this, 500, 300, "MMTK Control Panel");
  
  serialPortName = (String) JOptionPane.showInputDialog(null, "Please Select The Serial Port for MMTK","Serial Port", JOptionPane.QUESTION_MESSAGE, null, serialPortChoices, serialPortChoices[0]);
 
  // If User Picked Mock Serial, use mock serial
  if (serialPortName == serialPortChoices[serialPortChoices.length - 1]) {
    mockupSerial = true;
    serialPort = null;
    serialPortName = "MOCK";
  } else {
    System.out.println(serialPortName);
    serialPort = new Serial(this, serialPortName, 250000);
  }
  
  // Create a new file in the sketch directory
  String logFileName = "logs/MMTK" 
                       +" " + String.format("%04d", year()) 
                       + "-" + String.format("%02d", month()) 
                       + "-" + String.format("%02d", day()) 
                       + " " + String.format("%02d", hour()) 
                       + "-" + String.format("%02d", minute()) 
                       + "-" + String.format("%02d", second())
                       + "-" + serialPortName
                       + ".txt";
                       
  try {
   logFile = createWriter(logFileName); 
  }
  catch (Exception e) {
    System.out.println(e);
  }
  
  logFile.println("Started Log File:     " + logFileName);
  logFile.println("Data Source:     " + serialPortName + "\n");
  logFile.flush(); // Writes the remaining data to the file
    
  // Initialize GUI components
  cp5 = new ControlP5(this);
  buttonTitle_f = createFont("Arial", 10, true); 
  indicatorTitle_f = createFont("Arial", 16, true);
  mmtkState_f = createFont("Arial", 24, true);
  indicatorNumbers_f = createFont("Arial", 35, true);
  
  
  // init charts
  setChartSettings();
  
  logAllData = mmtkUIConfig.getBoolean("logAllData");
  printAllData = mmtkUIConfig.getBoolean("printAllData");
  
  // Draw MMTK Logo image
  mmtkLogo = loadImage(topSketchPath+"/images/mmtk-logo.png");
  background(200); 
  image(mmtkLogo, mmtkLogoOrigin[0], mmtkLogoOrigin[1], mmtkLogoSize[0],mmtkLogoSize[1]);
  
  
  // Draw No Data Text under the plot, if there is no data this will be shown
  textFont(indicatorNumbers_f);
  textAlign(CENTER);
  fill(0);
  
  text("NO DATA", XYplotOrigin[0]+XYplotSize[0]/2, XYplotOrigin[1]+XYplotSize[1]/2);

}




// *******************************
// ** MAIN DRAW LOOP START HERE **
// *******************************


int i = 0; // loop variable
int j = 0;

public void draw()
{  
  
  setChartSettings();
  /* Read serial and update values */
  if (mockupSerial || serialPort.available() > 0) {
    String myString = "";
    if (!mockupSerial) {
      try {
        myString = serialPort.readStringUntil('\n');
      }
      catch (Exception e) {
      }
    }
    else {
      myString = mockupSerialFunction();
    }
    
    if (myString == null) {
      return;
    }
    
    if (myString.contains("TARE")) {
      // This is a tare frame, empty the array and ignore it
      // Also ignore the next line with indices
      logFile.print(myString);
      logFile.print(serialPort.readStringUntil('\n'));
      XYplotCurrentSize = 0;
      maxForce = 0.0f;
      maxDisplacment = 0.0f;
      
    } else {
      // split the string at delimiter (space)
      String[] tempData = split(myString, '\t');   

      // build the arrays for bar charts and line graphs
      if (tempData.length == 16) {
        // This is a normal data frame
        // SPEED POSITION LOADCELL FEEDBACK_COUNT STATE ESTOP STALL DIRECTION INPUT_VOLTAGE BT_FWD BT_BAK BT_TARE BT_START BT_AUX and a space
        
        try {
          newLoadcellData = Integer.parseInt(trim(tempData[0]));
          velocity = Float.parseFloat(trim(tempData[1]));
          position = Float.parseFloat(trim(tempData[2]));
          loadCell = Float.parseFloat(trim(tempData[3]));
          feedBack = Integer.parseInt(trim(tempData[4]));
          MMTKState = Integer.parseInt(trim(tempData[5]));
          eStop = Integer.parseInt(trim(tempData[6]));
          stall = Integer.parseInt(trim(tempData[7]));
          direction = Integer.parseInt(trim(tempData[8]));
          inputVolts = Float.parseFloat(trim(tempData[9]));
          
          btFwd = Integer.parseInt(trim(tempData[10]));
          btBak = Integer.parseInt(trim(tempData[11]));
          btTare = Integer.parseInt(trim(tempData[12]));
          btStart = Integer.parseInt(trim(tempData[13]));
          btAux = Integer.parseInt(trim(tempData[14]));
          
          //positionCorrected = position - (loadCell * correctionFactor[0] - loadCell * loadCell * correctionFactor[1]);
        }
        catch (NumberFormatException e) {
          System.out.println(e);
        }
        
      } else {
        // invalid message ignore it
        System.out.println("Corrupted Serial Message Frame Ignored");
      }
      
      
      // Update data to plot only if there is a new data point
      if (newLoadcellData == 1) {
        // If the current data is longer than our buffer
        // Have to expand the buffer and continue
        if (XYplotCurrentSize >= XYplotIntData[0].length) {
          System.out.println("=========== expand buffer ==============");
          int newLength = XYplotIntDataDims[1] + XYplotIntData[0].length;
          int[][] tempIntData = new int[XYplotIntDataDims[0]][newLength];
          float[][] tempFloatData = new float[XYplotFloatDataDims[0]][newLength];
  
          // Copy data to this bigger array
          for (i=0; i<tempIntData.length; i++) {
            System.arraycopy(XYplotIntData[i], 0, tempIntData[i], 0, XYplotIntData[i].length);    
          }
          for (i=0; i<XYplotFloatData.length; i++) {
            System.arraycopy(XYplotFloatData[i], 0, tempFloatData[i], 0, XYplotFloatData[i].length);    
          }
          XYplotIntData = tempIntData;
          XYplotFloatData = tempFloatData;
        }
      
          // update the data buffer
          XYplotFloatData[0][XYplotCurrentSize] = velocity;
          XYplotFloatData[1][XYplotCurrentSize] = position;
          XYplotFloatData[2][XYplotCurrentSize] = loadCell;
          XYplotFloatData[3][XYplotCurrentSize] = inputVolts;
          
          XYplotIntData[0][XYplotCurrentSize] = feedBack;
          XYplotIntData[1][XYplotCurrentSize] = MMTKState;
          XYplotIntData[2][XYplotCurrentSize] = eStop;
          XYplotIntData[3][XYplotCurrentSize] = stall;
          XYplotIntData[4][XYplotCurrentSize] = direction;
          
          if (loadCell > maxForce) {
            maxForce = loadCell;
          }
          
          if (position > maxDisplacment) {
            maxDisplacment = position;
          }
          
          XYplotCurrentSize ++;
          
      }
      
      
      // Print out the data for debugging and logging
      if (printAllData || newLoadcellData == 1) { 
        System.out.print(myString); 
      }
      
      if (logAllData || newLoadcellData == 1) { 
        logFile.print(myString);
        logFile.flush(); // Writes the remaining data to the file
      }
    }
  }
  // == Finish Reading Data From Serial
    
  // Redraw plot only if there is new data
  if (newLoadcellData == 1) {
    
    // Copy data to plot into new array for plotting
    float[] plotDisplacement = Arrays.copyOfRange(XYplotFloatData[1], 0, XYplotCurrentSize);
    float[] plotForce = Arrays.copyOfRange(XYplotFloatData[2], 0, XYplotCurrentSize);
    
    // check if graph need to expand
    if ( maxDisplacment > XYplot.xMax || maxForce > XYplot.xMin ) {
      XYplot.xMax = max(maxDisplacment, mmtkUIConfig.getInt("mainPlotXMax"));
      XYplot.yMax = max(maxForce, mmtkUIConfig.getInt("mainPlotYMax"));
    }
    
  
    // draw the line graphs
    XYplot.DrawAxis();
    XYplot.GraphColor = XYplotColor;
    XYplot.DotXY(plotDisplacement, plotForce);
  }
  
  
  
  // Draw / update buttons
  
  // Buttons
  stroke(buttonBorderColor);
  fill(buttonActiveColor);
  
  textFont(buttonTitle_f);
  textAlign(LEFT);
  
  if (btFwd >= 1) {
    fill(buttonActiveColor);
  } else {
    fill(buttonInactiveColor);
  }
  rect(buttonForwardOrigin[0], buttonForwardOrigin[1], buttonIndicatorSize[0], buttonIndicatorSize[1]);
  fill(textColor);
  text("Forward\nButton", buttonForwardOrigin[0]+10, buttonForwardOrigin[1]+buttonIndicatorSize[1]/2-5);
  
  if (btBak >= 1) {
    fill(buttonActiveColor);
  } else {
    fill(buttonInactiveColor);
  }
  rect(buttonBackOrigin[0], buttonBackOrigin[1],  buttonIndicatorSize[0], buttonIndicatorSize[1]);
  fill(textColor);
  text("Back\nButton", buttonBackOrigin[0]+10, buttonBackOrigin[1]+buttonIndicatorSize[1]/2-5);
  
  if (btTare >= 1) {
    fill(buttonActiveColor);
  } else {
    fill(buttonInactiveColor);
  }
  rect(buttonTareOrigin[0], buttonTareOrigin[1], buttonIndicatorSize[0], buttonIndicatorSize[1]);
  fill(textColor);
  text("Tare\nButton", buttonTareOrigin[0]+10, buttonTareOrigin[1]+buttonIndicatorSize[1]/2-5);
  
  if (btStart >= 1) {
    fill(buttonActiveColor);
  } else {
    fill(buttonInactiveColor);
  }
  rect(buttonStartOrigin[0], buttonStartOrigin[1], buttonIndicatorSize[0], buttonIndicatorSize[1]);
  fill(textColor);
  text("Start\nButton", buttonStartOrigin[0]+10, buttonStartOrigin[1]+buttonIndicatorSize[1]/2-5);
  
  if (btAux >= 1) {
    fill(buttonActiveColor);
  } else {
    fill(buttonInactiveColor);
  }
  rect(buttonAuxOrigin[0], buttonAuxOrigin[1], buttonIndicatorSize[0], buttonIndicatorSize[1]);
  fill(textColor);
  text("Aux\nButton", buttonAuxOrigin[0]+10, buttonAuxOrigin[1]+buttonIndicatorSize[1]/2-5);
  
  textFont(indicatorTitle_f);
  
  // eStop and stall indicators
  if (stall >= 1) {
    fill(stallActiveColor);
  } else {
    fill(stallInactiveColor);
  }
  rect(stallIndicatorOrigin[0], stallIndicatorOrigin[1], booleanIndicatorSize[0], booleanIndicatorSize[1]);
  fill(textColor);
  text("Motor Stall", stallIndicatorOrigin[0]+10, stallIndicatorOrigin[1]+20);
  
  if (eStop >= 1) {
    fill(eStopActiveColor);
  } else {
    fill(eStopInactiveColor);
  }
  rect(eStopIndicatorOrigin[0], eStopIndicatorOrigin[1], booleanIndicatorSize[0], booleanIndicatorSize[1]);
  fill(textColor);
  text("eStop", eStopIndicatorOrigin[0]+10, eStopIndicatorOrigin[1]+20);
  
  // Indicator boxes
  fill(textIndicatorBackgroundColor);
  rect(stateIndicatorOrigin[0], stateIndicatorOrigin[1], textIndicatorSize[0], textIndicatorSize[1]);
  rect(forceIndicatorOrigin[0], forceIndicatorOrigin[1], textIndicatorSize[0], textIndicatorSize[1]);
  rect(velocityIndicatorOrigin[0], velocityIndicatorOrigin[1], textIndicatorSize[0], textIndicatorSize[1]);
  rect(positionIndicatorOrigin[0], positionIndicatorOrigin[1], textIndicatorSize[0], textIndicatorSize[1]);
  rect(maxForceIndicatorOrigin[0], maxForceIndicatorOrigin[1], textIndicatorSize[0], textIndicatorSize[1]);
  
  // Indicator title texts
  fill(textColor);
  text("MMTK State: ", stateIndicatorOrigin[0] + 10, stateIndicatorOrigin[1] + 20);
  text("Displacement: ", positionIndicatorOrigin[0] + 10, positionIndicatorOrigin[1] + 20);
  text("Force: ", forceIndicatorOrigin[0] + 10, forceIndicatorOrigin[1] + 20);
  text("Speed: ", velocityIndicatorOrigin[0] + 10, velocityIndicatorOrigin[1] + 20);
  text("Max Force: ", maxForceIndicatorOrigin[0] + 10, maxForceIndicatorOrigin[1] + 20);
  
  // Indicator value Texts
  textAlign(CENTER);
  textFont(mmtkState_f);
  text(MMTKstateEnum[MMTKState], stateTextLocation[0], stateTextLocation[1]);
  
  textFont(indicatorNumbers_f);
  text(String.format("%.02f", position) + " mm", positionTextLocation[0], positionTextLocation[1]);
  text(String.format("%.01f", loadCell) + " N", forceTextLocation[0], forceTextLocation[1]);
  text(String.format("%.02f", velocity) + " mm/min", velocityTextLocation[0], velocityTextLocation[1]);
  text(String.format("%.01f", maxForce) + " N", maxForceTextLocation[0], maxForceTextLocation[1]);
}






// *********************
// ** HELPER FUNCTIONS **
// **********************


// called each time the chart settings are changed by the user 
public void setChartSettings() {
  XYplot.xLabel=mmtkUIConfig.getString("mainPlotXLabel");
  XYplot.yLabel=mmtkUIConfig.getString("mainPlotYLabel");
  XYplot.Title=mmtkUIConfig.getString("mainPlotTitle");  
  XYplot.xDiv=2;  
  XYplot.xMax=mmtkUIConfig.getInt("mainPlotXMax"); 
  XYplot.xMin=mmtkUIConfig.getInt("mainPlotXMin");  
  XYplot.yMax=mmtkUIConfig.getInt("mainPlotYMax"); 
  XYplot.yMin=mmtkUIConfig.getInt("mainPlotYMin");
}
// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;

  float mmtkVel = 50.0f;
  int bgColor = 200;

  public void settings() {
    size(400, 230);
    
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
      .setText("MMTK Control Panel")
      .setPosition(x=15, y=5)
      .setColorValue(color(0, 0, 0))
      .setFont(createFont("Arial", 22));
    
    cp5.addTextfield("input speed")
      .setPosition(x=15, y=50)
      .setColorValue(color(0, 0, 0))
      .setColorCursor(color(0, 0, 0))
      .setColorLabel(color(0, 0, 0))
      .setColorBackground(color(255, 255, 255))
      .setFont(createFont("Arial", 14))
      .setText("50")
      .setSize(100,30)
      .setAutoClear(false);
   
    
    
    cp5.addButton("Tare")
      .setValue(1)
      .setFont(createFont("Arial Black", 10))
      .setPosition(x=15, y=115)
      .setSize(250,25);
    
    cp5.addButton("Start")
      .setValue(1)
      .setFont(createFont("Arial Black", 10))
      .setPosition(x=15, y=155)
      .setSize(100,50);
      
     
    cp5.addButton("Stop")
      .setValue(1)
      .setFont(createFont("Arial Black", 10))
      .setPosition(x+150, y)
      .setSize(100,50);
      
 

    textFont(createFont("Arial", 16, true));

  }



  public void controlEvent(ControlEvent theEvent) {
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
        mmtkVel = PApplet.parseFloat(value);
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
        } else if (parameter == "5kg calibration"){
          serialPort.write("Calibration\n");
        }
      }
      
    }
  }

  public void draw() {
    background(bgColor);
    text("Current Speed: " + String.format("%.02f", mmtkVel) + " mm/min", 125, 70);
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
  
/*   =================================================================================       
     The Graph class contains functions and variables that have been created to draw 
     graphs. Here is a quick list of functions within the graph class:
          
       Graph(int x, int y, int w, int h,color k)
       DrawAxis()
       Bar([])
       smoothLine([][])
       DotGraph([][])
       LineGraph([][]) 
     
     =================================================================================*/   

    
    class Graph 
    {
      
      boolean Dot=true;            // Draw dots at each data point if true
      boolean RightAxis;            // Draw the next graph using the right axis if true
      boolean ErrorFlag=false;      // If the time array isn't in ascending order, make true  
      boolean ShowMouseLines=true;  // Draw lines and give values of the mouse position
    
      int     xDiv=5,yDiv=5;            // Number of sub divisions
      int     xPos,yPos;            // location of the top left corner of the graph  
      int     Width,Height;         // Width and height of the graph
    

      int   GraphColor;
      int   BackgroundColor=color(255);  
      int   StrokeColor=color(0);     
      
      String  Title="Title";          // Default titles
      String  xLabel="x - Label";
      String  yLabel="y - Label";

      float   yMax=1024, yMin=0;      // Default axis dimensions
      float   xMax=10, xMin=0;
      float   yMaxRight=1024,yMinRight=0;
  
      PFont   Font;                   // Selected font used for text 
      
  //    int Peakcounter=0,nPeakcounter=0;
     
      Graph(int x, int y, int w, int h,int k) {  // The main declaration function
        xPos = x;
        yPos = y;
        Width = w;
        Height = h;
        GraphColor = k;
        
      }
    
     
       public void DrawAxis(){
       
   /*  =========================================================================================
        Main axes Lines, Graph Labels, Graph Background
       ==========================================================================================  */
    
        fill(BackgroundColor); color(0);stroke(StrokeColor);strokeWeight(1);
        int t=60;
        
        rect(xPos-t*1.6f,yPos-t,Width+t*2.5f,Height+t*2);            // outline
        textAlign(CENTER);textSize(24);
        float c=textWidth(Title);
        fill(BackgroundColor); color(0);stroke(0);strokeWeight(1);
        rect(xPos+Width/2-c/2,yPos-35,c,0);                         // Heading Rectangle  
        
        fill(0);
        text(Title,xPos+Width/2,yPos-37);                            // Heading Title
        textAlign(CENTER);textSize(20);
        text(xLabel,xPos+Width/2,yPos+Height+t/1.5f);                     // x-axis Label 
        
        rotate(-PI/2);                                               // rotate -90 degrees
        text(yLabel,-yPos-Height/2,xPos-t*1.6f+20);                   // y-axis Label  
        rotate(PI/2);                                                // rotate back
        
        textSize(14); noFill(); stroke(0); smooth();strokeWeight(1);
          //Edges
          line(xPos-3,yPos+Height,xPos-3,yPos);                        // y-axis line 
          line(xPos-3,yPos+Height,xPos+Width+5,yPos+Height);           // x-axis line 
          
           stroke(200);
          if(yMin<0){
                    line(xPos-7,                                       // zero line 
                         yPos+Height-(abs(yMin)/(yMax-yMin))*Height,   // 
                         xPos+Width,
                         yPos+Height-(abs(yMin)/(yMax-yMin))*Height
                         );
          
                    
          }
          
          if(RightAxis){                                       // Right-axis line   
              stroke(0);
              line(xPos+Width+3,yPos+Height,xPos+Width+3,yPos);
            }
            
           /*  =========================================================================================
                Sub-devisions for both axes, left and right
               ==========================================================================================  */
            
            stroke(0);
            
           for(int x=0; x<=xDiv; x++){
       
            /*  =========================================================================================
                  x-axis
                ==========================================================================================  */
             
            line(PApplet.parseFloat(x)/xDiv*Width+xPos-3,yPos+Height,       //  x-axis Sub devisions    
                 PApplet.parseFloat(x)/xDiv*Width+xPos-3,yPos+Height+5);     
                 
            textSize(16);                                      // x-axis Labels
            String xAxis=str(xMin+PApplet.parseFloat(x)/xDiv*(xMax-xMin));  // the only way to get a specific number of decimals 
            String[] xAxisMS=split(xAxis,'.');                 // is to split the float into strings 
            text(xAxisMS[0]+"."+xAxisMS[1].charAt(0),          // ...
                 PApplet.parseFloat(x)/xDiv*Width+xPos-3,yPos+Height+18);   // x-axis Labels
          }
          
          
           /*  =========================================================================================
                 left y-axis
               ==========================================================================================  */
          
          for(int y=0; y<=yDiv; y++){
            line(xPos-3,PApplet.parseFloat(y)/yDiv*Height+yPos,                // ...
                  xPos-7,PApplet.parseFloat(y)/yDiv*Height+yPos);              // y-axis lines 
            
            textAlign(RIGHT);fill(20);
            
            String yAxis=str(yMin+PApplet.parseFloat(y)/yDiv*(yMax-yMin));     // Make y Label a string
            String[] yAxisMS=split(yAxis,'.');                    // Split string
           
            text(yAxisMS[0]+"."+yAxisMS[1].charAt(0),             // ... 
                 xPos-15,PApplet.parseFloat(yDiv-y)/yDiv*Height+yPos+3);       // y-axis Labels 
                        
                        
            /*  =========================================================================================
                 right y-axis
                ==========================================================================================  */
            
            if(RightAxis){
             
              color(GraphColor); stroke(GraphColor);fill(20);
            
              line(xPos+Width+3,PApplet.parseFloat(y)/yDiv*Height+yPos,             // ...
                   xPos+Width+7,PApplet.parseFloat(y)/yDiv*Height+yPos);            // Right Y axis sub devisions
                   
              textAlign(LEFT); 
            
              String yAxisRight=str(yMinRight+PApplet.parseFloat(y)/                // ...
                                yDiv*(yMaxRight-yMinRight));           // convert axis values into string
              String[] yAxisRightMS=split(yAxisRight,'.');             // 
           
               text(yAxisRightMS[0]+"."+yAxisRightMS[1].charAt(0),     // Right Y axis text
                    xPos+Width+15,PApplet.parseFloat(yDiv-y)/yDiv*Height+yPos+3);   // it's x,y location
            
              noFill();
            }stroke(0);
            
          
          }
          
 
      }
      
      
   /*  =========================================================================================
       Bar graph
       ==========================================================================================  */   
      
      public void Bar(float[] a ,int from, int to) {
        
         
          stroke(GraphColor);
          fill(GraphColor);
          
          if(from<0){                                      // If the From or To value is out of bounds 
           for (int x=0; x<a.length; x++){                 // of the array, adjust them 
               rect(PApplet.parseInt(xPos+x*PApplet.parseFloat(Width)/(a.length)),
                    yPos+Height-2,
                    Width/a.length-2,
                    -a[x]/(yMax-yMin)*Height);
                 }
          }
          
          else {
          for (int x=from; x<to; x++){
            
            rect(PApplet.parseInt(xPos+(x-from)*PApplet.parseFloat(Width)/(to-from)),
                     yPos+Height-2,
                     Width/(to-from)-2,
                     -a[x]/(yMax-yMin)*Height);
                     
    
          }
          }
          
      }
  public void Bar(float[] a ) {
  
              stroke(GraphColor);
          fill(GraphColor);
    
  for (int x=0; x<a.length; x++){                 // of the array, adjust them 
               rect(PApplet.parseInt(xPos+x*PApplet.parseFloat(Width)/(a.length)),
                    yPos+Height-2,
                    Width/a.length-2,
                    -a[x]/(yMax-yMin)*Height);
                 }
          }
  
  
   /*  =========================================================================================
       Dot graph
       ==========================================================================================  */   
       
        public void DotGraph(float[] x ,float[] y) {
          
         for (int i=0; i<x.length; i++){
                    strokeWeight(2);stroke(GraphColor);noFill();smooth();
           ellipse(
                   xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                   yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                   2,2
                   );
         }
                             
      }
      
   /*  =========================================================================================
       XY Dot graph
       ==========================================================================================  */   
       
        public void DotXY(float[] x ,float[] y) {
          
         for (int i=0; i<x.length; i++){
                    strokeWeight(2);stroke(GraphColor);noFill();smooth();
           ellipse(
                   xPos-(xMin/(xMax-xMin)*Width)+(x[i])/(xMax-xMin)*Width,
                   yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                   2,2
                   );
         }
                             
      }
      
   /*  =========================================================================================
       Streight line graph 
       ==========================================================================================  */
       
      public void LineGraph(float[] x ,float[] y) {
          
         for (int i=0; i<(x.length-1); i++){
                    strokeWeight(2);stroke(GraphColor);noFill();smooth();
           line(xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                                            yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                                            xPos+(x[i+1]-x[0])/(x[x.length-1]-x[0])*Width,
                                            yPos+Height-(y[i+1]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height);
         }
                             
      }
      
      /*  =========================================================================================
             smoothLine
          ==========================================================================================  */
    
      public void smoothLine(float[] x ,float[] y) {
         
        float tempyMax=yMax, tempyMin=yMin;
        
        if(RightAxis){yMax=yMaxRight;yMin=yMinRight;} 
         
        int counter=0;
        int xlocation=0,ylocation=0;
         
//         if(!ErrorFlag |true ){    // sort out later!
          
          beginShape(); strokeWeight(2);stroke(GraphColor);noFill();smooth();
         
            for (int i=0; i<x.length; i++){
              
           /* ===========================================================================
               Check for errors-> Make sure time array doesn't decrease (go back in time) 
              ===========================================================================*/
              if(i<x.length-1){
                if(x[i]>x[i+1]){
                   
                  ErrorFlag=true;
                
                }
              }
         
         /* =================================================================================       
             First and last bits can't be part of the curve, no points before first bit, 
             none after last bit. So a streight line is drawn instead   
            ================================================================================= */ 

              if(i==0 || i==x.length-2)line(xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                                            yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                                            xPos+(x[i+1]-x[0])/(x[x.length-1]-x[0])*Width,
                                            yPos+Height-(y[i+1]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height);
                                            
          /* =================================================================================       
              For the rest of the array a curve (spline curve) can be created making the graph 
              smooth.     
             ================================================================================= */ 
                            
              curveVertex( xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                           yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height);
                           
           /* =================================================================================       
              If the Dot option is true, Place a dot at each data point.  
             ================================================================================= */    
           
             if(Dot)ellipse(
                             xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                             yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                             2,2
                             );
                             
         /* =================================================================================       
             Highlights points closest to Mouse X position   
            =================================================================================*/ 
                          
              if( abs(mouseX-(xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width))<5 ){
                
                 
                  float yLinePosition = yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height;
                  float xLinePosition = xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width;
                  strokeWeight(1);stroke(240);
                 // line(xPos,yLinePosition,xPos+Width,yLinePosition);
                  strokeWeight(2);stroke(GraphColor);
                  
                  ellipse(xLinePosition,yLinePosition,4,4);
              }
              
     
              
            }  
       
          endShape(); 
          yMax=tempyMax; yMin=tempyMin;
                float xAxisTitleWidth=textWidth(str(map(xlocation,xPos,xPos+Width,x[0],x[x.length-1])));
          
           
       if((mouseX>xPos&mouseX<(xPos+Width))&(mouseY>yPos&mouseY<(yPos+Height))){   
        if(ShowMouseLines){
              // if(mouseX<xPos)xlocation=xPos;
            if(mouseX>xPos+Width)xlocation=xPos+Width;
            else xlocation=mouseX;
            stroke(200); strokeWeight(0.5f);fill(255);color(50);
            // Rectangle and x position
            line(xlocation,yPos,xlocation,yPos+Height);
            rect(xlocation-xAxisTitleWidth/2-10,yPos+Height-16,xAxisTitleWidth+20,12);
            
            textAlign(CENTER); fill(160);
            text(map(xlocation,xPos,xPos+Width,x[0],x[x.length-1]),xlocation,yPos+Height-6);
            
           // if(mouseY<yPos)ylocation=yPos;
             if(mouseY>yPos+Height)ylocation=yPos+Height;
            else ylocation=mouseY;
          
           // Rectangle and y position
            stroke(200); strokeWeight(0.5f);fill(255);color(50);
            
            line(xPos,ylocation,xPos+Width,ylocation);
             int yAxisTitleWidth=PApplet.parseInt(textWidth(str(map(ylocation,yPos,yPos+Height,y[0],y[y.length-1]))) );
            rect(xPos-15+3,ylocation-6, -60 ,12);
            
            textAlign(RIGHT); fill(GraphColor);//StrokeColor
          //    text(map(ylocation,yPos+Height,yPos,yMin,yMax),xPos+Width+3,yPos+Height+4);
            text(map(ylocation,yPos+Height,yPos,yMin,yMax),xPos -15,ylocation+4);
           if(RightAxis){ 
                          
                           stroke(200); strokeWeight(0.5f);fill(255);color(50);
                           
                           rect(xPos+Width+15-3,ylocation-6, 60 ,12);  
                            textAlign(LEFT); fill(160);
                           text(map(ylocation,yPos+Height,yPos,yMinRight,yMaxRight),xPos+Width+15,ylocation+4);
           }
            noStroke();noFill();
         }
       }
            
   
      }

       
          public void smoothLine(float[] x ,float[] y, float[] z, float[] a ) {
           GraphColor=color(188,53,53);
            smoothLine(x ,y);
           GraphColor=color(193-100,216-100,16);
           smoothLine(z ,a);
   
       }
       
       
       
    }
    
 
// If you want to debug the plotter without using a real serial port
// MOdified to mock a mmtk output
// SPEED POSITION LOADCELL FEEDBACK_COUNT STATE ESTOP STALL DIRECTION INPUT_VOLTAGE BT_FWD BT_BAK BT_TARE BT_START BT_AUX
// typedef enum {running, stopped, hold, jogFwd, jogBak, fastFwd, fastBak, noChange} MMTKState_t;



Random rand = new Random();

// These values are retained after function exits

int mockNewData = 0;
float mockSpeed = 0.0f;
float mockPosition = 0;
float mockLoadCell = 0.0f;
int mockFeedBack = 0;
int mockState = 0;
boolean mockEstop = false;
boolean mockStall = false;
boolean mockDirection = false;
float mockInputVolts = 12.0f;
boolean mockBtBak = false;
boolean mockBtFwd = false;
boolean mockBtTare = false;
boolean mockBtStart = false;
boolean mockBtAux = false;

public String mockupSerialFunction() {
  mockPosition += 0.1f;
  
  if (mockPosition > 150) {
    mockPosition = 0;
  }
  
  if (mockLoadCell > 500) {
    mockLoadCell = 0;
  }
  
  mockLoadCell += rand.nextFloat();
  
  mockFeedBack += 1;
  
  mockSpeed = (mockLoadCell + mockPosition) / 3;
  
  mockInputVolts = 11.5f + rand.nextFloat();
  
  if (mockPosition % 5 <= 0.1f) {
    mockState = ThreadLocalRandom.current().nextInt(0, 6);
  }
  
  if (mockPosition % 1 <= 0.1f) {
    mockEstop = rand.nextFloat() > 0.3f;
    mockStall = rand.nextFloat() > 0.4f;
    mockDirection = rand.nextFloat() > 0.5f;
    mockBtBak = rand.nextFloat() > 0.7f;
    mockBtFwd = rand.nextFloat() > 0.3f;
    mockBtTare = rand.nextFloat() > 0.4f;
    mockBtStart = rand.nextFloat() > 0.5f;
    mockBtAux = rand.nextFloat() > 0.6f;
  }
  
  if (mockNewData == 1) {
    mockNewData = 0;
  } else {
    mockNewData = 1;
  }
    
    
  String r = "";
  mockNewData = rand.nextFloat() > 0.5f ? 1 : 0;
  
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
// *************************
// ** UI Layout Constants **
// *************************

// Screen
int[] screenSize = {1366, 768};

// Generic Text Color
int textColor = color(0,0,0);

// MMTK Logo
int[] mmtkLogoOrigin = {2,5};
int[] mmtkLogoSize = {1050,58};

int x = 1080, y = 5;
int dx = 0, dy = 100;

int textIndicatorBackgroundColor = color(200,200,255);
int[] textIndicatorSize = {275,100};
int[] booleanIndicatorSize = {275,50};

// Position Indicator
int[] positionIndicatorOrigin = {x, y};
int[] positionTextLocation = {positionIndicatorOrigin[0] + textIndicatorSize[0]/2, positionIndicatorOrigin[1] + 60};

// Force Indicator
int[] forceIndicatorOrigin = {x=x+dx, y=y+dy};
int[] forceTextLocation = {forceIndicatorOrigin[0] + textIndicatorSize[0]/2, forceIndicatorOrigin[1] + 60};

// Velocity Indicator
int[] velocityIndicatorOrigin = {x=x+dx, y=y+dy};
int[] velocityTextLocation = {velocityIndicatorOrigin[0] + textIndicatorSize[0]/2, velocityIndicatorOrigin[1] + 60};

// MMTK States
String[] MMTKstateEnum = {"Running", "Stopped", "Hold", "Jog Forward", "Jog Back", "Fast Jog Forward", "Fast Jog Back", " - "};
int[] stateIndicatorOrigin = {x=x+dx, y=y+dy};
int[] stateTextLocation = {stateIndicatorOrigin[0] + textIndicatorSize[0]/2, stateIndicatorOrigin[1] + 60};

// Velocity Indicator
int[] maxForceIndicatorOrigin = {x=x+dx, y=y+dy};
int[] maxForceTextLocation = {maxForceIndicatorOrigin[0] + textIndicatorSize[0]/2, maxForceIndicatorOrigin[1] + 60};

{
x = 1080;
y = 560;
dx = 0;
dy = 50;
}

// eStop Indicator
int[] eStopIndicatorOrigin = {x=x+dx, y=y+dy};
int eStopActiveColor = color(250,0,0);
int eStopInactiveColor = color(0,250,0);

// motor stall indicator
int[] stallIndicatorOrigin = {x=x+dx, y=y+dy};
int stallActiveColor = color(250,0,0);
int stallInactiveColor = color(0,250,0);

// Button Indicators
int buttonActiveColor = color(120,255,120);
int buttonInactiveColor = color(255,120,120);
int buttonBorderColor = 10;
int[] buttonIndicatorSize = {55,55};

{
x = 1080;
y = 705;
dx = 55;
dy = 0;
}

int [] buttonForwardOrigin = {x,y};
int [] buttonBackOrigin = {x = x+55,y};
int [] buttonTareOrigin = {x = x+55,y};
int [] buttonStartOrigin = {x = x+55,y};
int [] buttonAuxOrigin = {x = x+55,y};


// Control Window Constants
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MMTK_UI" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
