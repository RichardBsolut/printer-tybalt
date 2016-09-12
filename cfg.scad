use <./lib/bearing.scad>

PX = 250;
PY = 290;
PZ = 250;

PROFILE_SIZE = 20;
PROFILE_CUT = 4.3;
PROFILE_CUTD = 6.35;
/*
  PROFILE 
    |<--PROFILE_SIZE->|
        PROFILE_CUT
           |<->|
     _____       _____   –
    /     )     (     \  | PROFILE_CUTD
    |    /_______\    |  _

*/


PROFILE_PLAY = 0.2;
PROFILE_SCREW = 3;
R_PLAY = 0.3;

WALL = 4;
ZBUFF = 0.2;

XY_SPACE = 20;
XY_ROD_SPACE = 18.5;
CARRIAGE_ROD_SPACE = XY_ROD_SPACE - (0.5/2);
XY_ROD = 6;
XY_PULLEY = 12; //20 theeth
XY_BEARING = 626;
XY_BEARING_MIN_WALL = 1.8;


XY_CARRIAGE_SPACE = 20;
XY_CARRIAGE_MAGNET = 4;
MAGNET_X = 11;
MAGNET_D = 4;
MAGNET_H = 2;


motorSize = 42.5; //38 for NEMA14, 45 for NEMA17
motorScrewSpacing = 31; //26 for NEMA14, 31 for NEMA17
motorH = 35.25;
motorPulley = 14;


HALL_X = 4.2 + 1;
HALL_Y = 3.1 + 0.25;
HALL_Z = 2.0 + 0.4;

//--- Calced
PROFILE = PROFILE_SIZE + PROFILE_PLAY*2;
PROF_S = PROFILE_SIZE; //shorthand
mScrewSpace = (motorSize-motorScrewSpacing) / 2; //Space from motorcorner to next screw hole



XY_BEAR_D = get_bearing_outer_diam(XY_BEARING);
XY_BEAR_R = XY_BEAR_D/2;
XY_BEAR_H = get_bearing_height(XY_BEARING);
XY_BEAR_MW = XY_BEARING_MIN_WALL; //short hand

XY_ROD_R = XY_ROD / 2;

X_BEARING_POS = XY_BEAR_D/2+XY_BEARING_MIN_WALL;
X_BEAR_POS = X_BEARING_POS;

BELT_GUID_R = XY_BEAR_D/2+mScrewSpace - XY_PULLEY/2;
BELT_GUID_D = BELT_GUID_R * 2;