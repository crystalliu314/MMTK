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
