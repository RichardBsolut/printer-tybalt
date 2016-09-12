use <./lib/bcad.scad>
use <./lib/screw.scad>
include <./cfg.scad>
use <./vitamins.scad>


ymotorMount();
//cornerMotor();
//yflip() cornerLT(); //2x and one yflip't

/*
%move(z=-39,y=100,x=-42) cornerMotor();
move(x=-100) {
    move(y=100) cornerLT();
    yflip() cornerLT();
}
zrot(180) cornerLT();
*/


module cornerLT() {
    h = X_BEAR_POS+XY_SPACE+XY_BEAR_D/2+WALL;
    w = XY_BEAR_D*1.5+WALL;

    difference() {
        union() {
            move(x=-PROFILE_SIZE,y=-w)
                cornerUpper(w,h);
            move(x=w)
                zrot(90) cornerLower(w,h);
            move(y=-WALL*1.5)
                cornerSupport(size=WALL*1.5,h=h);
        }
        move(y=-X_BEAR_POS,x=-XY_BEAR_H-1.5,z=h-X_BEAR_POS)
        yrot(90) bearingCut();

        move(y=XY_BEAR_H+1.5, x=X_BEAR_POS,z=h-X_BEAR_POS-XY_SPACE)
        xrot(90) bearingCut();

        //Screws left
        move(x=-PROFILE_SIZE/2) {
            move(y=-WALL,z=h*0.25)
                xrot(-90) wallScrewCut();
            move(y=-w*0.8,z=h-WALL)
                wallScrewCut();
        }
        //Screws right
        move(y=PROFILE_SIZE/2) {
            move(x=WALL,z=h*.65)
                yrot(-90) wallScrewCut();
            move(x=w*0.75,z=h-WALL)
                wallScrewCut();
        }
    }
}


module hallBox() {
    HOLD_W = 4;
    
    hull() {
        move(x=-HOLD_W/2)
            cube([HALL_X+HOLD_W,HALL_Y+HOLD_W/1.5,0.1]);
        move(x=-HOLD_W/4)
            cube([HALL_X+HOLD_W/2,HALL_Y+HOLD_W/4,HALL_Z+1]);
    }
}

module hallCut3() {
    move(y=-ZBUFF,z=-ZBUFF)
        cube([HALL_X,HALL_Y+ZBUFF,HALL_Z+ZBUFF]);
    move(x=HALL_X+0.2,z=-(WALL+1+HALL_Z*2)/2+HALL_Z)
        scale([1,1.8,1])
        yrot(-90)zrot(-90)
        intersection() {
            difference() {
                cylinder(d=WALL+1+HALL_Z*2,h=HALL_X+0.4);
                move(x=-0.8,z=-1,y=-0.3)
                cylinder(d=WALL+1+1,h=HALL_X+2);
            }
            cube([10,10,10]);
        }

}

module bearingCut() {
    cylinder(d=XY_BEAR_D+R_PLAY,h=200);
    cylinder(d=XY_ROD +R_PLAY*2 ,h=200,center=true);
}

module wallScrewCut(h=20) {
    down(2)
        mainScrew(head=2);
    down(h+1)
        cylinder(d=6.5,d2=5.9, h=h);
}

module cornerThinningWall(h, l) {
    zrot(90)
    move(x=-WALL/2, y=l/2-l, z=h/2)
    thinning_triangle(h=h, l=l, thick=WALL, ang=30, strut=WALL/2, wall=WALL/2,diagonly=true);
}


module drop(d=10,h=10,t=1) {
    hull() {
        move(y=d/2+t)
            cylinder(d=1,h=h);
        cylinder(d=d,h=h);
    }
}


module motorHold() {
    difference() {
        motorSuspension();
        move(x=-(motorSize -motorScrewSpacing),
             y=-(motorSize -motorScrewSpacing), z=-1)
            cube(motorSize);
    }
}

module cornerSimple(w,h,isLeft=false,noWall=false) {
    //Base walls
    move(z=h-WALL) cube([PROFILE_SIZE,w,WALL]);
    move(y=w-WALL) cube([PROFILE_SIZE,WALL,h]);
                //move(x=l-20-WALL, y=WALL/2, z=20+WALL)
    //Rounded corner
    move(x=PROFILE_SIZE-WALL/2+(isLeft?WALL/2:0),
        y=w-PROFILE_SIZE-WALL,
        z=h-PROFILE_SIZE-WALL)
    yrot(-90)
    cornerSupport(size=PROFILE_SIZE,h=PROFILE_SIZE-WALL/2,corner=2);

    if(noWall!=true) {
        move(x=(isLeft?0:PROFILE_SIZE-WALL),y=w-WALL)
        xrot(90) zrot(90)
        cornerThinningWall(w-WALL,h-WALL);
    }
}

module cornerMotorBase() {
    //gt2pulleyWithBelt

    cornerH = motorSize+(XY_BEARING_MIN_WALL+XY_BEAR_D)*2;
    cornerW = 35;

    move(y=WALL)
        xrot(90)
            motorHold();

    bearW = XY_BEAR_D+XY_BEAR_MW*2;
    h = (XY_BEARING_MIN_WALL+XY_BEAR_D)*2;
    supportH = PROFILE_SIZE/2+WALL*1.5; //XY_BEAR_H+1+5;

    move(y=PROFILE_SIZE, z=motorSize)
    zrot(-90)  {
        cornerSimple(motorSize,h,noWall=true);
        right(PROFILE_SIZE-WALL)
            cube([WALL,motorSize,h]);

        move(x=PROFILE_SIZE-supportH,y=motorSize-X_BEAR_POS,z=X_BEAR_POS)
        yrot(90)zrot(90+5)
            drop(d=bearW+WALL, h=supportH,t=X_BEAR_POS+WALL);

    }

}

module cornerUpper(w,h) {
    bearW = XY_BEAR_D+XY_BEAR_MW*2;
    csize = XY_BEAR_D/2;
    bearWDpeth = PROFILE_SIZE/2;

    intersection() {
        union() {
            cornerSimple(w,h);
            move(x=PROFILE_SIZE, y=w-bearW/2,z=h-bearW/2)
                yrot(-90)
                    cylinder(d2=bearW,d=bearW+WALL*1.25, h=XY_BEAR_H+WALL);
        }
        cube([w,w,h]);
    }
}


module cornerLower(w,h) {
    bearW = XY_BEAR_D+XY_BEAR_MW*2;
    csize = XY_BEAR_D/2;
    bearWDpeth = PROFILE_SIZE/2;

    intersection() {
        union() {
            cornerSimple(w,h,isLeft=true,noWall=true);

            move(y=w-X_BEAR_POS,z=h-X_BEAR_POS-XY_SPACE)
            yrot(90)
            cylinder(d2=bearW,d=bearW+WALL*2, h=XY_BEAR_H+WALL);

            move(y=w,z=h)
            move(z=-(w+bearW*5))
            xrot(90) zrot(90)
                cornerThinningWall(bearW+XY_BEAR_D/2,w+bearW*5);

        }
        union() {
            hull() {
                move(z=h-WALL)
                    cube([PROFILE_SIZE,w,WALL]);
                difference() {
                    move(y=w-X_BEAR_POS,z=h-X_BEAR_POS-XY_SPACE)
                    yrot(90)
                        cylinder(d=bearW+WALL, h=PROFILE_SIZE);
                    move(y=w)
                        cube([PROFILE_SIZE+2,50,h]);
                }
            }
            move(y=w-bearW/2)
            cube([PROFILE_SIZE,bearW/2,bearW/2]);
        }
    }
}


module cornerMotor() {
    cornerH = motorSize+(XY_BEARING_MIN_WALL+XY_BEAR_D)*2;

    difference() {
        union() {
            cornerMotorBase();
            move(x=motorSize+PROFILE_SIZE,y=-40)
                xflip() cornerUpper(40,cornerH);

            move(x=motorSize)
                zrot(180) triangle([WALL,WALL,cornerH]);
            
            move(x=motorSize+HALL_Z,
                y=-X_BEAR_POS+HALL_X/2-XY_PULLEY/2-WALL-XY_CARRIAGE_MAGNET*1.5,
                z=cornerH-HALL_Y-X_BEAR_POS-XY_PULLEY/2+1.5)  {
            
                zrot(-90) xrot(90)
                move(x=-HALL_X/2,y=-HALL_Y/1.5)
                    hallBox();
            }

            move(x=motorSize-XY_BEAR_D-X_BEAR_POS,
                y=HALL_Y/2,
                z=cornerH-X_BEAR_POS-XY_SPACE+XY_PULLEY-4) {
                    xrot(90)
                    move(x=-HALL_X/2,y=-HALL_Y/1.5)
                        hallBox();
            }
        }

        //Lower axis
        move(y=XY_BEAR_H+1.5+7-WALL, x=motorSize-X_BEAR_POS,z=cornerH-X_BEAR_POS-XY_SPACE)
        xrot(90) bearingCut();

        move(x=motorSize+XY_BEAR_H+1.5,y=-X_BEAR_POS,z=cornerH-X_BEAR_POS)
        yrot(-90) bearingCut();


        /*move(x=motorSize+HALL_Y/2+1,
            y=-X_BEAR_POS+HALL_X/2-XY_PULLEY/2-WALL-XY_CARRIAGE_MAGNET,
            z=cornerH-HALL_Y-X_BEAR_POS-XY_PULLEY/2)
        zrot(-90) xrot(90)
        hallCut();*/


        /*move(x=motorSize+WALL-HALL_Z,
            y=-X_BEAR_POS+HALL_X/2-XY_PULLEY/2-WALL-XY_CARRIAGE_MAGNET,
            z=cornerH-HALL_Y-X_BEAR_POS-XY_PULLEY/2)
        zrot(-90) xrot(90)
        hallCut2();  */
        
        
        move(x=motorSize+HALL_Z,
            y=-X_BEAR_POS+HALL_X/2-XY_PULLEY/2-WALL-XY_CARRIAGE_MAGNET*1.5,
            z=cornerH-HALL_Y-X_BEAR_POS-XY_PULLEY/2+1.5)  {
        
            zrot(-90) xrot(90)
            move(x=-HALL_X/2,y=-HALL_Y/1.5)
                //hallBox();
                hallCut3();
        }
        
            /*
            move(x=10/2,y=2,z=HALL_Y)
            move(x=-HALL_X/2,z=(HALL_Y+(4/1.5))/2 )
            xrot(-90)
                hallBox();*/

        /*move(
            x=motorSize-XY_BEAR_D-X_BEAR_POS,
            y=HALL_Y/2,
            z=cornerH-X_BEAR_POS-XY_SPACE+XY_PULLEY-4)
        xrot(90) hallCut2();*/
            
        move(x=motorSize-XY_BEAR_D-X_BEAR_POS,
            y=HALL_Y/2,
            z=cornerH-X_BEAR_POS-XY_SPACE+XY_PULLEY-4) {
        
            zrot(0) xrot(90)
            move(x=-HALL_X/2,y=-HALL_Y/1.5)
                hallCut3();
        }




        //Overlapping walls
        move(x=motorSize)
            cube([20,20,cornerH]);
        move(y=WALL)
        cube([motorSize,motorH,motorSize]);

        //Screws
        move(x=motorSize+PROFILE_SIZE/2) {
            move(y=-WALL,z=cornerH*0.2)
                xrot(-90) wallScrewCut();
            move(y=-WALL,z=cornerH*0.65)
                xrot(-90) wallScrewCut();
            move(y=-40*0.8,z=cornerH-WALL)
                wallScrewCut();
        }
        //Screws right
        move(y=PROFILE_SIZE/2) {
            move(x=motorSize-WALL,z=cornerH*.80)
                yrot(90) wallScrewCut();
            move(x=motorSize*0.2,z=cornerH-WALL)
                wallScrewCut();
        }
        //Motor screws
        move(x=motorSize-mScrewSpace, y=-2,z=mScrewSpace)
        xrot(-90) mainScrew(headlen=2);
        move(x=motorSize-mScrewSpace, y=-2,z=motorSize-mScrewSpace)
        xrot(-90) mainScrew(headlen=2);

        //Cable
        move(x=motorSize,z=motorSize,y=-6)
        {
            move(x=-2.4,z=-HALL_X/2)
                rrect([2.4,6+WALL,HALL_X],r=.4);
            xrot(-90) cylinder(d=4,h=50);
            
            zrot(-20)
            move(y=-0.2,z=-HALL_X/2)
                rrect([6+WALL,2.8,HALL_X],r=.4);
        }
        /*move(x=motorSize,z=motorSize,y=-5)
        xrot(-90)
        cylinder(d=4,h=50);
        move(x=motorSize+WALL,z=motorSize,y=-5)
        yrot(-90)
        cylinder(d=4,h=WALL*2+5);*/
        
    }

    //Debug shows
    
    /*
    %union() {
        move(x=motorSize-X_BEAR_POS, y=7-XY_BEAR_D/2+2, z=cornerH-X_BEAR_POS-XY_SPACE)
        xrot(90)
        union() {
            //XY_CARRIAGE_MAGNET
            //move(z=56)zrot(90) xrot(-90) xyEndCenter();
            gt2pulleyWithBelt();
        }

        move(x=motorSize,y=-X_BEAR_POS,z=cornerH-X_BEAR_POS)
        xrot(-90)yrot(-90) {
            //move(z=56)zrot(90) xrot(-90) xyEndCenter();

            gt2pulleyWithBelt();
        }

        echo("X_BEAR_POS/");
        echo(X_BEAR_POS/2);
        move(x=mScrewSpace,y=-X_BEAR_POS/2,z=motorSize-mScrewSpace)
        xrot(90)
        beltGuid(BELT_GUID_D);

        move(y=motorH+WALL)
        xrot(90)
        17HDPulley();
    }*/
}



module ymotorMountBase(pulleySpace=20) {
    zOff = -X_BEAR_POS+BELT_GUID_R;
    sWallH = motorSize- PROF_S+zOff-WALL; //Support Wall Height

    move(x=WALL, z=zOff)
    yrot(-90) motorSuspension();
    //Base horz wall
    move(z=PROFILE_SIZE) cube([WALL+pulleySpace+PROFILE_SIZE,motorSize+PROFILE_SIZE,WALL]);

    move(x=WALL*1.5,y=motorSize,z=PROF_S+WALL)
    yrot(-90)
    triangle([sWallH,PROF_S,WALL*1.5]);

    move(x=WALL, z=PROF_S+WALL) {
        zrot(-90) yrot(-90)
            triangle([sWallH,PROF_S+pulleySpace,WALL*2]);

        move(y=motorSize-WALL*2)
        zrot(-90) yrot(-90)
            triangle([sWallH,PROF_S+pulleySpace,WALL*2.5]);

        //Lower supports
        move(z=-WALL)
        zflip() {
            move(y=motorSize-WALL*2)
            zrot(-90) yrot(-90)
                triangle([sWallH,pulleySpace,WALL*2]);

            move(z=pulleySpace/2)
            xrot(-90)
                cornerSupport(size=pulleySpace/2,h=WALL*2);
        }
    }


}

module ymotorMount(pulleySpace=20) {
    zOff = -X_BEAR_POS+BELT_GUID_R;
    sWallH = motorSize- PROF_S+zOff-WALL; //Support Wall Height

    move(x=motorH) {
        difference() {
            ymotorMountBase(pulleySpace);
            move(x=WALL,y=WALL,z=PROF_S+WALL)
                rcube([pulleySpace+PROF_S,motorSize-WALL*2,motorSize],r=WALL);

            move(x=WALL,y=WALL,z=zOff)
                rcube([pulleySpace+PROF_S,motorSize-WALL*2,
                    motorSize/2+0.5],r=WALL);

            move(x=WALL-ZBUFF,y=motorSize-ZBUFF,z=PROF_S+WALL)
                rcube([pulleySpace+PROF_S,motorSize-WALL*2,motorSize],r=WALL);

            move(x=-1,y=motorSize/2,z=motorSize/2+zOff)
            yrot(90)
            union(){
                motorSuspensionCut(h=WALL);
                zflip() zring(n=4)
                    move(x=motorScrewSpacing/2, y=motorScrewSpacing/2,z=-9+2)
                        mainScrew(head=20);
                
                move(x=motorScrewSpacing/2, y=-motorScrewSpacing/2, z=-9+2)
                    cylinder(d=5+R_PLAY,h=20);
            }

            //Pulley cut out
            move(z=motorSize/2-WALL)
            hull() {
                move(x=pulleySpace+WALL/2,y=motorSize*0.3)
                cylinder(d=WALL,h=WALL*2);
                move(x=pulleySpace+WALL/2,y=motorSize*0.7)
                cylinder(d=WALL,h=WALL*2);

                move(x=WALL*1.5,y=mScrewSpace+WALL/1.5)
                cylinder(d=WALL,h=WALL*2);
                move(x=WALL*1.5,y=motorSize- mScrewSpace-WALL/1.5)
                cylinder(d=WALL,h=WALL*2);
            }


            //Mounting screws
            move(x=pulleySpace+PROF_S/2+WALL, y=10, z=8+PROF_S)
            zflip() mainScrew();
            move(x=pulleySpace+PROF_S/2+WALL, y=motorSize-10, z=8+PROF_S)
            zflip() mainScrew();

            move(x=pulleySpace/2, y=motorSize+PROF_S/2, z=8+PROF_S)
            zflip() mainScrew();

            move(x=pulleySpace+PROF_S/2+WALL, y=motorSize+PROF_S/2, z=8+PROF_S)
            zflip() cylinder(d=5,h=10);


            //Round up
            move(x=-1) {
                move(y=-ZBUFF, z=zOff+WALL-ZBUFF)
                yrot(90)cornerSupport(size=WALL,h=50,corner=3);

                move(y=-ZBUFF, z=zOff+motorSize+ZBUFF)
                yrot(90)cornerSupport(size=WALL,h=50,corner=4);

                move(y=motorSize-WALL+ZBUFF, z=zOff+WALL-ZBUFF)
                yrot(90)cornerSupport(size=WALL,h=50,corner=2);
            }
        }
    }

    /*
    %move(x=0, z=motorSize+zOff)
    yrot(90)
    union(){
        17HDPulley();
        move(x=motorSize-mScrewSpace,y=mScrewSpace,z=motorH+7) {
            beltGuid(BELT_GUID_D);
        }
    }

    //debug helps
    %union() {
        move(x=motorH+pulleySpace+WALL, y=50)
        xrot(90) profile(h=100);
        move(y=motorSize, z=20)
        yrot(90) profile(h=100);
    }*/
}