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

// If you want to debug the plotter without using a real serial port set this to true
boolean mockupSerial = true;

// Serial Setup
String serialPortName;
Serial serialPort;  // Create object from Serial class

// interface stuff
ControlP5 cp5;

// Settings for the plotter are saved in this file
JSONObject plotterConfigJSON;

// Plot Constants
int[] XYplotOrigin = {100, 170};
int[] XYplotSize = {400, 300};
int XYplotColor = color(20, 20, 200);

// Generate the plot
Graph XYplot = new Graph(XYplotOrigin[0], XYplotOrigin[1], XYplotSize[0], XYplotSize[1], XYplotColor);
float[][] XYplotData = new float[14][200];
float[] XYplotSampleNumbers = new float[200];
color[] graphColors = new color[6];

// helper for saving the executing path
String topSketchPath = "";

// Log File
PrintWriter logFile;

// MMTK logo image
PImage mmtkLogo;


void settings() {
    size(1080, 720);
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
  
  logFile.println("Started Log File:     " + logFileName);
  logFile.flush(); // Writes the remaining data to the file
  
  // settings save file
  topSketchPath = sketchPath();
  plotterConfigJSON = loadJSONObject(topSketchPath+"/plotter_config.json");
  
  surface.setTitle("Realtime plotter");

  // set line graph colors
  graphColors[0] = color(131, 255, 20);
  graphColors[1] = color(232, 158, 12);
  graphColors[2] = color(255, 0, 0);
  graphColors[3] = color(62, 12, 232);
  graphColors[4] = color(13, 255, 243);
  graphColors[5] = color(200, 46, 232);
  
  // settings save file
  topSketchPath = sketchPath();
  plotterConfigJSON = loadJSONObject(topSketchPath+"/plotter_config.json");

  // gui
  cp5 = new ControlP5(this);
  
  // init charts
  setChartSettings();
  // build x axis values for the line graph
  for (int i=0; i<XYplotData.length; i++) {
    for (int k=0; k<XYplotData[0].length; k++) {
      XYplotData[i][k] = 0;
      if (i==0)
        XYplotSampleNumbers[k] = k;
    }
  }
  
  
  // start serial communication
  //serialPortName = Serial.list()[0];
  if (!mockupSerial) {
    //String serialPortName = Serial.list()[3];
    serialPort = new Serial(this, serialPortName, 115200);
  }
  else
    serialPort = null;
    
    
  // build the gui
  int x = 170;
  int y = 60;
  cp5.addTextfield("lgMaxY").setPosition(x, y=y+130).setText(getPlotterConfigString("lgMaxY")).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMinY").setPosition(x, y=y+200).setText(getPlotterConfigString("lgMinY")).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMaxX").setPosition(x, y=y+130).setText(getPlotterConfigString("lgMaxY")).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMinX").setPosition(x, y=y+200).setText(getPlotterConfigString("lgMinY")).setWidth(40).setAutoClear(false);

  
  // Draw MMTK Logo image
  mmtkLogo = loadImage("/images/mmtk-logo.png");

}


// *******************************
// ** MAIN DRAW LOOP START HERE **
// *******************************


byte[] inBuffer = new byte[100]; // holds serial message
int i = 0; // loop variable

void draw()
{  
  
  setChartSettings();
  /* Read serial and update values */
  if (mockupSerial || serialPort.available() > 0) {
    String myString = "";
    if (!mockupSerial) {
      try {
        serialPort.readBytesUntil('\r', inBuffer);
      }
      catch (Exception e) {
      }
      myString = new String(inBuffer);
    }
    else {
      myString = mockupSerialFunction();
    }

    // Print out the data for debugging and logging
    // System.out.println(myString);
    // logFile.println(myString);

    // split the string at delimiter (space)
    String[] nums = split(myString, ' ');

    // System.out.println(XYplotData.length);

    // build the arrays for bar charts and line graphs
    for (i=0; i<nums.length; i++) {
      System.out.print(nums[i] + " ");
      
      // update line graph
      try {
        if (i<XYplotData.length) {
          for (int k=0; k<XYplotData[i].length-1; k++) {
            XYplotData[i][k] = XYplotData[i][k+1];
            
          }

          XYplotData[i][XYplotData[i].length-1] = float(nums[i]);
        }
        
              }
      catch (Exception e) {
      }
    }
    System.out.println("=");
  }
  
  // draw the bar chart
  background(200); 
  
  
  // Draw the MMTK Logo
  image(mmtkLogo, 0, 0, 300, 100);

  // draw the line graphs
  XYplot.DrawAxis();
  XYplot.GraphColor = graphColors[2];
  
  XYplot.DotXY(XYplotData[1], XYplotData[2]);
}

// *********************
// ** HELPER FUNCTIONS **
// **********************


// called each time the chart settings are changed by the user 
void setChartSettings() {
  XYplot.xLabel=" Displacment (mm) ";
  XYplot.yLabel=" Force (N) ";
  XYplot.Title="";  
  XYplot.xDiv=2;  
  XYplot.xMax=1000; 
  XYplot.xMin=-10;  
  XYplot.yMax=1000; 
  XYplot.yMin=-10;
}

// handle gui actions
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class) || theEvent.isAssignableFrom(Toggle.class) || theEvent.isAssignableFrom(Button.class)) {
    String parameter = theEvent.getName();
    String value = "";
    if (theEvent.isAssignableFrom(Textfield.class))
      value = theEvent.getStringValue();
    else if (theEvent.isAssignableFrom(Toggle.class) || theEvent.isAssignableFrom(Button.class))
      value = theEvent.getValue()+"";

    plotterConfigJSON.setString(parameter, value);
    saveJSONObject(plotterConfigJSON, topSketchPath+"/plotter_config.json");
  }
  setChartSettings();
}

// get gui settings from settings file
String getPlotterConfigString(String id) {
  String r = "";
  try {
    r = plotterConfigJSON.getString(id);
  } 
  catch (Exception e) {
    r = "";
  }
  return r;
}
