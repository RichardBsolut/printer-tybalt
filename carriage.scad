use <./lib/bcad.scad>
use <./lib/screw.scad>
use <./lib/motor/17HD.scad>
use <./lib/bearing.scad>
use <./lib/bushing.scad>
use <./lib/timing_belts.scad>
include <./cfg.scad>
use <./vitamins.scad>


CARRIAGE_LEN = 35;
CARRIAGE_WALL = 1.5;
CARRIAGE_PLAY = 0.5;
CLAMP_PLAY = 0.5;
CLAMP_PLAY_Z = 0.5;
BELT_WIDTH = 7;
BELT_HEIGHT = 1;
BELT_SPACE = 3;
BUSHING_D = 12.4;

CARRIAGE_INNER = BELT_WIDTH+CARRIAGE_PLAY;
CARRIAGE_WIDTH = CARRIAGE_INNER +CARRIAGE_WALL*2;

//MaxSpace = Center of moving rod + XY_SPACE + GT2PULLEY_D/2
MAX_SPACE = XY_SPACE + XY_PULLEY/2 - BELT_SPACE+1.5;
REAR_SPACE = XY_SPACE + XY_PULLEY/2 - BELT_SPACE;
//From rod center
BELT_LOWER = XY_SPACE - XY_PULLEY/2;


//$fn=50;
xyEndCenter();
//clamps();



//--DEBUG PRINTS
/*
%union() {
    xrot(-90) cylinder(d=6,h=50);

    #move(y=CARRIAGE_LEN-6.8,x=18.5)
    cylinder(d=6,h=50);

    move(x=XY_SPACE,y=50,z=-6)
        zrot(90) gt2pulleyWithBelt();

    move(x=BUSHING_D/2+clampS/2, z=CARRIAGE_WIDTH/2)
    xrot(-90)
        mainScrew(screwlen=30);

    move(x=BUSHING_D/2+clampS/2+9,y=-4, z=CARRIAGE_WIDTH/2)
    xrot(-90)
        mainScrew(screwlen=20);
}    */

module magentHold() {
    difference() {
        union() {
            cylinder(d=MAGNET_D+R_PLAY+1.2,h=MAGNET_H);
            cylinderSupport(r=(MAGNET_D+R_PLAY+1)/2,h=MAGNET_H);
        }
    }
}

module magnetSupport(around=1) {
    x = MAGNET_X+(MAGNET_D+CARRIAGE_WALL)/2;
    y = MAGNET_D+CARRIAGE_WALL;
    z = (BUSHING_D-CARRIAGE_WIDTH)/2;

    hull() {
        cube([x,y,z]);
        move(y=-around,z=z)
        cube([x+around,y+around*2,0.01]);
    }
}


module xyEnd() {

    difference() {
        union() { //Base figuar
            cube([MAX_SPACE-1,CARRIAGE_LEN,CARRIAGE_WIDTH]);

            magnetWall = (MAGNET_D+CARRIAGE_WALL)/2;
            move(x=0, y=CARRIAGE_LEN-XY_CARRIAGE_MAGNET-magnetWall,z=-(BUSHING_D-CARRIAGE_WIDTH)/2)
                magnetSupport();
         }


        move(x=BELT_LOWER,y=CARRIAGE_LEN, z=(BELT_WIDTH+CARRIAGE_PLAY)/2+CARRIAGE_WALL)
        zrot(-90)
        belt_len(profile = 0, belt_width = CARRIAGE_INNER, len = 10);

        move(x=BUSHING_D/2,y=-1,z=CARRIAGE_WALL)
            cube([BELT_LOWER-BUSHING_D/2,CARRIAGE_LEN+2, CARRIAGE_INNER]);

        move(x=BELT_LOWER-1,y=-1,z=CARRIAGE_WALL)
            cube([8+1,14.2+2,CARRIAGE_INNER]);

        move(x=BELT_LOWER,y=-1,z=CARRIAGE_WALL)
            cube([8,9,CARRIAGE_INNER]);


        move(x=BELT_LOWER+(REAR_SPACE-BELT_LOWER)/2,y=0, z=CARRIAGE_WIDTH/2)
        xrot(-90)
            mainScrew(screwlen=26,forTap=true);

        #move(y=CARRIAGE_LEN-6.8,x=CARRIAGE_ROD_SPACE,z=-1) {
            cylinder(d=6+R_PLAY+0.1,h=50);
            move(z=(CARRIAGE_WIDTH+1.5)/2) xrot(-90)
            {
                cylinder(d=2.5,h=6);
                up(z=6)
                    cylinder(d1=2.5,d2=6,h=2.5);
            }
        }

        move(y=-1,z=CARRIAGE_WIDTH/2)
        xrot(-90)
            cylinder(d=BUSHING_D,h=50);

        csize = 5;
        move(x=MAX_SPACE-csize+ZBUFF-0.5,y=CARRIAGE_LEN-csize+ZBUFF,z=-1)
            cornerSupport(size=csize ,h=50,corner=2);

        move(x=MAGNET_X, y=CARRIAGE_LEN-XY_CARRIAGE_MAGNET,z=-2-50)
            cylinder(d=4+R_PLAY,h=3+50);
    }

    //Bushing
    move(z=CARRIAGE_WIDTH/2)
    xrot(-90)
        bushing();
    //Ramps
    move(x=BUSHING_D/2,y=14.2)
        yflip() triangle([1,14.2,CARRIAGE_WIDTH]);
    move(x=BUSHING_D/2,y=14.2)
        cube([1,CARRIAGE_LEN-12.2-14.2,CARRIAGE_WIDTH]);
    move(x=BUSHING_D/2,y=CARRIAGE_LEN-12.2)
        triangle([1,12.2,CARRIAGE_WIDTH]);
}

module xyEndCenter() {
    move(z=-CARRIAGE_WIDTH/2)
        xyEnd();
}

module clamp1() {
    xspace = 1;

    x = BELT_LOWER-BUSHING_D/2 - CLAMP_PLAY;
    y = 11;
    z = CARRIAGE_INNER - CLAMP_PLAY - CLAMP_PLAY_Z;


    difference() {
        union() {
            hull() {
                cube([x-xspace ,1,z]);
                move(x=1,y=y-1)
                    cube([x-1-xspace,1,z]);
            }
        }

        move(x=x/2,y=-1,z=z/2)
            xrot(-90) cylinder(d=2.7,h=y+2);

        move(x=-1.5,y=-1,z=z/2-2/2)
            cube([2,10,2]);
    }
}

module clamp2() {
    x = BELT_LOWER-BUSHING_D/2 - CLAMP_PLAY;
    y = 12;
    z = CARRIAGE_INNER - CLAMP_PLAY - CLAMP_PLAY_Z;
    xspace = 0.5;

    difference() {
        union() {
            hull() {
                cube([x-xspace,1,z]);
                move(x=1,y=y-1)
                    cube([x-1-xspace,1,z]);
            }
        }

        move(x=x/2,y=-1,z=z/2)
            xrot(-90) cylinder(d=3,h=y+2);
    }
}

module clamp3() {
    x = 8-CLAMP_PLAY;
    y = 9;
    z = CARRIAGE_INNER - CLAMP_PLAY - CLAMP_PLAY_Z;
    xspace = 0.5;

    difference() {
        union() {
            hull() {
                cube([x-xspace,y,z]);
            }
        }

        move(x=x/2,y=-1,z=z/2)
            xrot(-90) cylinder(d=3,h=y+2);

        move(x=0.3,y=-1,z=(z+1)/2)
        yflip()zrot(-90)
            belt_len(profile = 0, belt_width = z+2, len = y+2);
    }
}

module clamps() {
    xrot(90)
        clamp1();
    move(x=8)xrot(90)
        clamp2();
    move(x=17)xrot(90)
        clamp3();
}

