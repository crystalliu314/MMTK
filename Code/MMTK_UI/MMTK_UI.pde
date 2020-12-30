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
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*; // http://www.sojamo.de/libraries/controlP5/
import processing.serial.*;
import java.util.Arrays;
PFont buttonTitle_f, mmtkState_f, indicatorTitle_f, indicatorNumbers_f;

// If you want to debug the plotter without using a real serial port set this to true
boolean mockupSerial = true;

// Serial Setup
String serialPortName;
Serial serialPort;  // Create object from Serial class

// interface stuff
ControlP5 cp5;

// Settings for MMUK UI are stored in this config file
JSONObject mmtkUIConfig;

// Generate the plot
int[] XYplotFloatDataDims = {4, 10000};
int[] XYplotIntDataDims = {5, 10000};

// XY Plot
int[] XYplotOrigin = {100, 125};
int[] XYplotSize = {630, 530};
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
float velocity = 0.0;
float position = 0.0;
float loadCell = 0.0;
int feedBack = 0;
int MMTKState = 0;
int eStop = 0;
int stall = 0;
int direction = 0;
float inputVolts = 12.0;

int btBak = 0;
int btFwd = 0;
int btTare = 0;
int btStart = 0;
int btAux = 0;


// helper for saving the executing path
String topSketchPath = "";

// Log File
PrintWriter logFile;
boolean logAllData;

// Console Print Configs
boolean printAllData;


// MMTK logo image
PImage mmtkLogo;


void settings() {
    size(screenSize[0], screenSize[1]);
}

void setup() 
{
  // Create a new file in the sketch directory
  String logFileName = "logs/MMTK" 
                       +" " + String.format("%04d", year()) 
                       + "-" + String.format("%02d", month()) 
                       + "-" + String.format("%02d", day()) 
                       + " " + String.format("%02d", hour()) 
                       + "-" + String.format("%02d", minute()) 
                       + "-" + String.format("%02d", second()) 
                       + ".txt";
  try {
   logFile = createWriter(logFileName); 
  }
  catch (Exception e) {
    System.out.println(e);
  }
  
  logFile.print("Started Log File:     " + logFileName);
  logFile.flush(); // Writes the remaining data to the file
    
  // settings save file
  topSketchPath = sketchPath();
  mmtkUIConfig = loadJSONObject(topSketchPath+"/mmtk_ui_config.json");

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
  
  
  // start serial communication
  if (!mockupSerial) {
    //String serialPortName = Serial.list()[3];
    System.out.println(Serial.list());
    serialPortName = Serial.list()[0];
    System.out.println(serialPortName);
    serialPort = new Serial(this, serialPortName, 250000);
  }
  else
    serialPort = null;

  
  // Draw MMTK Logo image
  mmtkLogo = loadImage("/images/mmtk-logo.png");
  background(200); 
  image(mmtkLogo, mmtkLogoOrigin[0], mmtkLogoOrigin[1], mmtkLogoSize[0],mmtkLogoSize[1]);

}




// *******************************
// ** MAIN DRAW LOOP START HERE **
// *******************************


int i = 0; // loop variable
int j = 0;

void draw()
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
      serialPort.readBytesUntil('\n');
      XYplotCurrentSize = 0;
      
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
    
  // Redraw plot only if there is new data
  if (newLoadcellData == 1) {
    
    // Copy data to plot into new array for plotting
    float[] plotDisplacement = Arrays.copyOfRange(XYplotFloatData[1], 0, XYplotCurrentSize);
    float[] plotForce = Arrays.copyOfRange(XYplotFloatData[2], 0, XYplotCurrentSize);
    
  
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
  
  // Indicator title texts
  fill(textColor);
  text("MMTK State: ", stateIndicatorOrigin[0] + 10, stateIndicatorOrigin[1] + 20);
  text("Displacment: ", positionIndicatorOrigin[0] + 10, positionIndicatorOrigin[1] + 20);
  text("Force: ", forceIndicatorOrigin[0] + 10, forceIndicatorOrigin[1] + 20);
  text("Strain Rate: ", velocityIndicatorOrigin[0] + 10, velocityIndicatorOrigin[1] + 20);
  
  // Indicator value Texts
  textAlign(CENTER);
  textFont(mmtkState_f);
  text(MMTKstateEnum[MMTKState], stateTextLocation[0], stateTextLocation[1]);
  
  textFont(indicatorNumbers_f);
  text(String.format("%.02f", position) + " mm", positionTextLocation[0], positionTextLocation[1]);
  text(String.format("%.01f", loadCell) + " N", forceTextLocation[0], forceTextLocation[1]);
  text(String.format("%.02f", velocity) + " mm/min", velocityTextLocation[0], velocityTextLocation[1]);
}






// *********************
// ** HELPER FUNCTIONS **
// **********************


// called each time the chart settings are changed by the user 
void setChartSettings() {
  XYplot.xLabel=mmtkUIConfig.getString("mainPlotXLabel");
  XYplot.yLabel=mmtkUIConfig.getString("mainPlotYLabel");
  XYplot.Title=mmtkUIConfig.getString("mainPlotTitle");  
  XYplot.xDiv=2;  
  XYplot.xMax=mmtkUIConfig.getInt("mainPlotXMax"); 
  XYplot.xMin=mmtkUIConfig.getInt("mainPlotXMin");  
  XYplot.yMax=mmtkUIConfig.getInt("mainPlotYMax"); 
  XYplot.yMin=mmtkUIConfig.getInt("mainPlotYMin");
}
