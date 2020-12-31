// *************************
// ** UI Layout Constants **
// *************************

// Screen
int[] screenSize = {1080, 720};

// Generic Text Color
int textColor = color(0,0,0);

// MMTK Logo
int[] mmtkLogoOrigin = {0,0};
int[] mmtkLogoSize = {310,62};


int textIndicatorBackgroundColor = color(200,200,255);
int[] textIndicatorSize = {275,100};
int[] booleanIndicatorSize = {275,50};

// Position Indicator
int[] positionIndicatorOrigin = {800, 10};
int[] positionTextLocation = {positionIndicatorOrigin[0] + textIndicatorSize[0]/2, positionIndicatorOrigin[1] + 60};

// Force Indicator
int[] forceIndicatorOrigin = {800, 110};
int[] forceTextLocation = {forceIndicatorOrigin[0] + textIndicatorSize[0]/2, forceIndicatorOrigin[1] + 60};

// Velocity Indicator
int[] velocityIndicatorOrigin = {800, 210};
int[] velocityTextLocation = {velocityIndicatorOrigin[0] + textIndicatorSize[0]/2, velocityIndicatorOrigin[1] + 60};

// MMTK States
String[] MMTKstateEnum = {"Running", "Stopped", "Hold", "Jog Forward", "Jog Back", "Fast Jog Forward", "Fast Jog Back", " - "};
int[] stateIndicatorOrigin = {800, 310};
int[] stateTextLocation = {stateIndicatorOrigin[0] + textIndicatorSize[0]/2, stateIndicatorOrigin[1] + 60};

// eStop Indicator
int[] eStopIndicatorOrigin = {800, 410};
int eStopActiveColor = color(250,0,0);
int eStopInactiveColor = color(0,250,0);

// motor stall indicator
int[] stallIndicatorOrigin = {800, 460};
int stallActiveColor = color(250,0,0);
int stallInactiveColor = color(0,250,0);

// Button Indicators
int buttonActiveColor = color(120,255,120);
int buttonInactiveColor = color(255,120,120);
int buttonBorderColor = 10;
int[] buttonIndicatorSize = {55,55};

int [] buttonForwardOrigin = {800,650};
int [] buttonBackOrigin = {855,650};
int [] buttonTareOrigin = {910,650};
int [] buttonStartOrigin = {965,650};
int [] buttonAuxOrigin = {1020,650};
