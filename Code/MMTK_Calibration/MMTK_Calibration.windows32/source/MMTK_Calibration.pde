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
import javax.swing.JOptionPane;
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
float velocity = 0.0;
float position = 0.0;
float positionCorrected = 0.0;
float loadCell = 0.0;
int feedBack = 0;
int MMTKState = 7;
int eStop = 0;
int stall = 0;
int direction = 0;
float inputVolts = 12.0;

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


void settings() {
    size(screenSize[0], screenSize[1]);
}

void setup() 
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
      logFile.print(myString);
      logFile.print(serialPort.readStringUntil('\n'));
      XYplotCurrentSize = 0;
      maxForce = 0.0;
      maxDisplacment = 0.0;
      
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
