use <../libs/bcad.scad>
include <./cfg.scad>
use <./vitamins.scad>
use <./lib/e3d_v6.scad>

DEBUG = true;
BEAR_D = 10;
BEAR_L = 35;
WALL = 3;
BOX_D = BEAR_D+WALL*2;

if(DEBUG) {
    move(y=-10/2)
    xrot(-90) {
        %cylinder(d=6,h=200,center=true);
        color("grey")
            cylinder(d=10,h=35+ZBUFF);
    }

    move(x=-10/2,z=CARRIAGE_ROD_SPACE)
    yrot(90) {
        %cylinder(d=6,h=200,center=true);
        color("grey")
            cylinder(d=10,h=35+ZBUFF);
    }
}


move(x=-BOX_D/2,y=-BOX_D/2) {
    printHead();
    move(x=13,y=3, z=-25+8)
        fan25();
}

move(x=BOX_D/2+3,y=BOX_D/2+3,z=CARRIAGE_ROD_SPACE+8)
    zflip()clamp();

module fan25() {
    color("silver") cube([25,10,25]);
}


module clamp() {
    centerPos = 16.2;
    
    difference() {
        union() { //Basecube
            difference() {
                cube([20.6,20.6,16.6]);  
                zrot(45)
                    up(20/2-1)cube([100,8,20],center=true);
            }
            move(x=centerPos/2,y=centerPos/2) 
                cylinder(d=20,h=16.6);        
        }
        
        zrot(45)
            move(z=9) cube([25,25,20],center=true);        
    
        //E3D Hold
        move(x=centerPos/2,y=centerPos/2) 
        {
            move(z=-1)
                cylinder(d=17,d2=16,h=1.4);
            cylinder(d=16,h=4.2);
            move(z=4.2-1)
                cylinder(d=16,d2=12,h=0.65+1);
            cylinder(d=12,h=9.8+1);
            move(z=9.8)
                cylinder(d=16,h=10);
        }
        
        //Cabel holder hole
        zrot(45)
        move(x=22.5,z=2)
        xrot(90)            
            cylinder(d=2,h=50,center=true);
        
        //Mounting screws
        zrot(-45) {
            xflip_copy()
            move(x=8,z=7, y=21)
            xrot(90)
                mainScrew(screwlen=25,head=20);
        }
        
        //Side cut off
        move(y=-1,x=-1,z=12.5) {
            cube([50,6.2,20]);
            cube([6.2,50,20]);
        }
        
        
        //Round Corners
        move(y=20.6,x=15,z=-1)
        zrot(180-45/2)
            cornerSupport(size=2,corner=4,h=20);        
        move(y=15,x=20.6,z=-1)
        zrot(180+45/2)
            cornerSupport(size=2,corner=4,h=20);
    }
}

module printHead() {
    printHeadBase();
}

module printHeadBase() {

    move(z=-BOX_D/2)
        difference() {
            cube([BOX_D,BEAR_L+WALL,BOX_D]);
            move(x=BOX_D/2,y=-1,z=BOX_D/2)
            xrot(-90) 
                bearingCut(h=40);
        }
        
        
    move(z=CARRIAGE_ROD_SPACE-BOX_D/2)
        difference() {    
            cube([37,BOX_D,BOX_D]);
            move(x=-1,y=BOX_D/2,z=BOX_D/2)
                yrot(90)zrot(-90) bearingCut(h=40);
        }

    move(z=BOX_D/2) {
        cube([BOX_D,BOX_D,CARRIAGE_ROD_SPACE-BOX_D]);
        
        hull() 
        {
            move(x=BOX_D-0.1,y=BOX_D)
                cube([0.1,BEAR_L+WALL-BOX_D,CARRIAGE_ROD_SPACE]);
            move(y=BOX_D) {
                cube([BOX_D,BEAR_L+WALL-BOX_D,0.1]);
                cube([BOX_D,0.1,CARRIAGE_ROD_SPACE]);
            }
        }
    }
}


module bearingCut(d=10,play=.1,off=0.4,h=30) {
    hull() {
        cylinder(d=d+play*2,h=h);
        move(x=-d*0.15, y=-d/2+off)
            cube([d*0.3,d,h]);
    }
}

/*
e3d_r = 11.15;
move(x=e3d_r+BEAR_D/2+WALL,y=e3d_r+BEAR_D/2+WALL,z=2+CARRIAGE_ROD_SPACE+BEAR_D/2+WALL)
    zflip()e3d(r=e3d_r);
*/
//move(y=1,x=0) xrot(-90)cylinder(d=10,h=20);
//move(y=-BOX_D/2)%move(x=38-8,z=-35.6)zrot(180)xrot(90)import("./kitten_parts/print_head.stl");
