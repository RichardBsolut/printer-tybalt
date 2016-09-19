use <./lib/bcad.scad>
use <./lib/screw.scad>
use <./lib/motor/17HD.scad>
include <./cfg.scad>
use <./vitamins.scad>

use <../libs/parts/OPB743.scad>

//$fn=50;
//zRodHold3();
//zMotorMount();
//zMagnetMount();
//zAssembly();

zEndStop2();

module test() {
    move(y=-38,x=30,z=20)
    yrot(90) xrot(90)
        OPB743();
    
    xrot(90)
    import("./kitten_parts/print_head.stl");
}


module zEndStop2(h=8, bottomCable=true) {

    
    SHELL=2;
    SHELL2 = SHELL*2;
    PLAY = 0.25;
    BOX_SIZE = 8.5 + PLAY*2;
  
    move(x=(10+R_PLAY)/2+R_PLAY, y=-BOX_SIZE/2+(bottomCable ? 2 : 0))
        cube([BOX_SIZE,BOX_SIZE-2,1]);
    difference() {
        union() {
            //Basic clamp
            cylinder(d=10+SHELL*2+R_PLAY,h=h);
            move(x=-12, y=-(10+SHELL)/2)
                cube([12,10+SHELL*1.5,h]);
            move(x=10/2-SHELL2/2,y=-(BOX_SIZE+SHELL2) /2)
                rrect([BOX_SIZE+SHELL2,BOX_SIZE+SHELL2,h],r=1);
        }
        //Leg Cap        
        move(z=-1) {
            cylinder(d=10+R_PLAY,h=h+2);
            move(x=-10,z=h/2+1)
                cube([20,7,h+2],center=true);            
        }
        //Leg screw
        move(x=-10/2-3, y=-10,z=h/2)
        xrot(-90) {
            mainScrew(screwlen=20);
            move(z=10+SHELL*2.5)
                m3Nut(hole=false,play=0.2);
        }
        //Endstop
        move(x=0,y=-(BOX_SIZE)/2,z=-1)
            cube([BOX_SIZE+10/2,BOX_SIZE,h+2]);
    }    
}

module zEndStop(h=8, bottomCable=true) {    
    SHELL=2;
    SHELL2 = SHELL*2;
    PLAY = 0.25;
    BOX_SIZE = 8.5 + PLAY*2;
   
    //move(y=-8.5/2,x=10/2,z=1) endstopSwitch();  
   
    move(x=(10+R_PLAY)/2+R_PLAY, y=-BOX_SIZE/2+(bottomCable ? 2 : 0))
        cube([BOX_SIZE,BOX_SIZE-2,1]);
    difference() {
        union() {
            //Basic clamp
            cylinder(d=10+SHELL*2+R_PLAY,h=h);
            move(x=-12, y=-(10+SHELL)/2)
                cube([12,10+SHELL,h]);
            move(x=10/2-SHELL2/2,y=-(BOX_SIZE+SHELL2) /2)
                rrect([BOX_SIZE+SHELL2,BOX_SIZE+SHELL2,h],r=1);
        }
        //Leg Cap        
        move(z=-1) {
            cylinder(d=10+R_PLAY,h=h+2);
            move(x=-10,z=h/2+1)
                cube([20,7,h+2],center=true);            
        }
        //Leg screw
        move(x=-10/2-3, y=-10,z=h/2)
        xrot(-90)
            mainScrew(screwlen=20);
        //Endstop
        move(x=0,y=-(BOX_SIZE)/2,z=-1)
            cube([BOX_SIZE+10/2,BOX_SIZE,h+2]);
    }
}

module zSensor(h=8) {
    SHELL=2;
    SCREW_OFFSET = 29/2;
    
    SENSOR_Y = 4+R_PLAY;
    SENSOR_X = 3+R_PLAY;
    SENSOR_Z = 1.5+R_PLAY;
   
    difference() {
        union() {
            //Basic clamp
            hull() {
                move(x=-SCREW_OFFSET, z=(SENSOR_Z+SHELL)/2) {
                    rrect([SENSOR_X+SHELL,SENSOR_Y+SHELL,SENSOR_Z+SHELL],center=true,r=SHELL/2);
                }        
                cylinder(d=10+SHELL*2+R_PLAY,h=h);
            }
            move(y=-(10+SHELL)/2)
                cube([12,10+SHELL,h]);
        }
        
        move(z=-1) {
            cylinder(d=10+R_PLAY,h=h+2);
            //Leg Cap
            move(x=10,z=h/2+1)
                cube([20,7,h+2],center=true);            
        }
        //Leg screw
        move(x=10/2+3, y=-10,z=h/2)
        xrot(-90)
            mainScrew(screwlen=20);
        //Sensor Cutoff
        move(z=.5)
        union() {
            hull() {
                move(x=-SCREW_OFFSET, z=SENSOR_Z/2)
                    cube([SENSOR_X,SENSOR_Y,SENSOR_Z],center=true); 
                move(x=-10/2,z=(SENSOR_Z*2)/2)
                    cube([SENSOR_X,SENSOR_Y*1.8,SENSOR_Z*2],center=true); 
            }
            move(x=-10/2+0.5,z=(h+2)/2)
                rrect([SENSOR_X+2,SENSOR_Y*2,h+2],center=true,r=SHELL/2); 
        }
    }
}


module zAssembly(withProfile=true) {
    if(withProfile) {
        move(x=-250/2,y=-20)
        yrot(90)
            profile(h=250);
    }
    move(x=-(motorSize+6)/2, z=-20+3)
        zMotorMount();
    
    move(y=motorSize/2, z=motorH-PROFILE) {
        17HD(center=true);
        up(3) {
            coupler();
            color("gold") cylinder(d=8,h=165);
        }
    }
    
    xflip_copy()
    move(x=50,y=-10) {
        zRodHold3();    
        %cylinder(d=10,h=230);        
        move(z=230)
            zflip() zRodHold3();    
    }

    %move(z=6+50) {
        move(z=-6,y=21.25)
            yflip()linear_extrude(height=6)
                import("./dxf/traegerplatte.dxf");
        
        //Print space
        move(x=-180/2, y=21.25+10,z=10)
            cube([180,170,3]);
        
        xflip_copy()
            move(x=50,y=-PROFILE/2) {
                LHICD10();   
                
                xflip_copy()
                move(x=29/2,z=-10)
                    cylinder(d=4,h=10);
            }
    }

    move(x=-50,y=-10,z=40)
        zflip() zSensor();
}

module zMagnetMount() {
    difference() {
        fillet(r=3) 
        {
            hull() {
                cylinder(d=25,h=6.5);
                cylinder(d=19,h=8);
            }
            hull() {
                move(x=5,y=-18/2)
                    cube([10,18,6.5]);
                move(x=5,y=-8/2)
                    cube([10,8,8]);
            }
            move(x=-23/2,z=8-3)
                cylinder(d=5.2+R_PLAY,h=3);
        }
    
        //Magnet
        move(x=-23/2,z=8-2)
            cylinder(d=4+R_PLAY,h=20);
        //Bearing
        move(z=-1)  cylinder(d=20,h=6.5);
        move(z=5) cylinder(d=20,d2=17,h=4.5);
        
        move(y=-8/2,z=-1) //Space
            cube([20,8,10]);
        
        move(x=11.5,z=3.25,y=10) //screw
        xrot(90) {
            mainScrew(head=10,screwlen=20,forTap=true);
            up(19) zrot(90) m3Nut(hole=false,play=0.25);
        }
    }
}

module zRodHold3() {
    h = motorH-20;
    difference() {
        union() { //Baseshape
            hull() {
                cylinder(d=16,h=h);
                cylinder(d=20,h=5);
            }
            move(z=5/2)
                rrect([15.5*2,20,5],r=4,center=true);
        }
        //Shaft
        down(1)
            cylinder(d=10+R_PLAY*2,h=h+2);
        
        //Hold screws
        xflip_copy()
        move(x=-15.5/2-6/2, z=5+0.5)
        zflip()
            mainScrew(head=20);
    
    }
}

module zMotorMount(
    extraH=0 //If your screw is to long, add some extra mm here
) {
    difference() {
        union() {
            cube([3,motorSize,motorH+extraH]);
            move(x=motorSize+3)
                cube([3,motorSize,motorH+extraH]);
            move(x=3,z=motorH-3) 
                motorSuspension(h=3+extraH, yspace=3);
            
            move(z=20,y=-3)
                cube([motorSize+6,3, motorH-20+extraH]);
            
            move(x=motorSize/2 - 12/2+3) {
                hull() {
                    move(z=20,y=-3,x=-6)
                        cube([12 + 12,3,motorH-20]);
                    /*move(z=20,y=-20)
                        cube([12,20,3]);*/
                    move(z=20,y=-10,x=6)
                        cylinder(d=15,h=3);
                }
            }
            
            move(x=motorSize+6) {
                hull() {
                    cube([10,5,20]);
                    cube([0.1,10,motorH]);
                }
            }
        }
        
        //TopScrew
        move(x=motorSize/2+3, y=-10,z=20)
        move(z=2+3)
            zflip()
                mainScrew(head=20);
        //Side screw
        move(x=motorSize+6+5, y=2+3, z=10)
        xrot(90)
            mainScrew(head=20);
        
        //Save plaste
        move(x=motorSize*1.5, y=motorSize+ZBUFF,z=-ZBUFF)
        yrot(-90)yflip()
            triangle([motorH-3,motorSize-5,motorSize*2]);
        move(x=-1,y=-1,z=-1) {
            cube([motorSize*2,motorSize,5]);
            hull() {
                move(y=motorSize)
                    cube([10,10,motorH-3]);
                cube([10,10,15]);
            }
        }
        
        //Smooth
        move(x=-ZBUFF) {
            //Back
            move(y=-3-ZBUFF) {
                cornerSupport(h=50,size=3,corner=4);
                move(x=motorSize+6-3+ZBUFF*2)
                cornerSupport(h=50,size=3,corner=3);
            }
            //Front
            move(y=motorSize-5+ZBUFF) {
                cornerSupport(h=50,size=5,corner=1);
                move(x=motorSize+ZBUFF*2+1)
                    cornerSupport(h=50,size=5,corner=2);
            }
        }
    }
}