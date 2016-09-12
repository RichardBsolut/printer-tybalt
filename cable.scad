use <../libs/bcad.scad>
include <./cfg.scad>
use <./vitamins.scad>

PROFILE = 20;
PROFILE_CUT = 4.3;
PROFILE_CUTD = 6.35;
PLAY = 0.25;

hookLen = PROFILE_CUT + (PROFILE-PROFILE_CUT)/2;
WALL=2;
/*move(x=WALL,y=-20)
%move(x=0.1, y=10-0.1)
zrot(90)
import("./addons/cable/2020_90Grad_side-ring-litle.stl");*/

difference() {    
    fullClip();
    move(z=-1)
        scale([1,2,1])
            cylinder(d=WALL/2,h=10);
}
    
module fullClip(h=8,width=15,r=2,gap=2,gapDeg=20) {
    holder(h=h,r=r);
    clip(width=width,h=h,gap=gap,gapDeg=gapDeg);
}

    
module holder(intersect=0.8,deep = 2.1, h=8,r=2) {
    cube([hookLen+WALL,WALL,h]);
    translate([WALL,-hookLen,0]) {
        hull() {
            move(y=PROFILE_CUT-0.1-PLAY)
                cube([deep,0.1,h]);
            cube([intersect,0.1,h]);
        }

        move(x=hookLen,y=hookLen)
        zrot(90)
        xflip()
        hull() {
            move(y=PROFILE_CUT-0.1-PLAY)
                cube([deep,0.1,h]);
            cube([intersect,0.1,h]);
        }
        difference() {
            move(x=-WALL)
                rrect([hookLen+WALL,hookLen+WALL,h],r=r);
            move(y=-1,z=-1)
                cube([hookLen+1,hookLen+1,h+2]);
        }
    }
}    

module clip(width=10,h=8,gap=WALL,gapDeg=30) {
    difference() {
        rrect([hookLen+WALL,width,8],r=2);
        move(x=WALL,y=WALL,z=-1)
            rrect([hookLen-WALL,width-WALL*2,8+2],r=2);    
        
        move(x=hookLen+5,y=(width)/2,z=h/2)
        xrot(-gapDeg)
            cube([20,gap,h*4],center=true);
    }
}


module realProfile(h=50) {
    color("silver")
    difference() {
        cube([PROFILE,PROFILE,h],center=true);
        zring(n=4)
        move(x=PROFILE/2-PROFILE_CUTD,y=-PROFILE_CUT/2,z=-(h+2)/2)
            cube([PROFILE_CUTD,PROFILE_CUT,h+2]);
    }
}

module clamp4(h=8,deep=2.1) {
    hull() {
        move(y=WALL*2-0.1)
            cube([WALL+deep,0.1,h]);
        intersection() {
            move(x=WALL,y=WALL)
                cylinder(d=WALL*2,h=h);
            cube([WALL,WALL*2,h]);
        }
        move(x=WALL)
            cube([WALL/4,WALL*2,h]);
    }
}

module clamp5(h=8,deep=2.1) {
    hull() {
        move(y=WALL*2-0.1)
            cube([WALL+deep,0.1,h]);
        move(x=0)
            cube([WALL+WALL/4,WALL*2,h]);
    }
}

    
module clamp(h=8) {

    difference() {
        cube([WALL*2,WALL*2,h]);
        move(x=WALL*1.28,z=-1)
        zrot(-15)
            move(y=-5)
                cube([WALL+2.5,15,h+2]);
        
        difference() {
            move(x=-1,y=-1,z=-1)
                cube([WALL+1,WALL+1,h+2]);
            move(x=WALL,y=WALL,z=-2)
                cylinder(d=WALL*2,h=h+4);
        }

    }
}


module clamp2(h=8) {
    difference() {
        hull() {
            cube([WALL*1.28,WALL*2,h]);
            move(y=WALL*2-0.1)
                cube([WALL*1.8,0.1,h]);
        }
        difference() {
            move(x=-1,y=-1,z=-1)
                cube([WALL+1,WALL+1,h+2]);
            move(x=WALL,y=WALL,z=-2)
                cylinder(d=WALL*2,h=h+4);
        }
    }
}


module clamp3(h=8) {
    hull() {
        cube([0.1,WALL*1.8,h]);
        move(y=WALL*0.8) {
            cube([WALL*2,WALL,h]);    
        }
    }
}
/*
move(x=10,y=10.3)
    clamp3();
move(x=WALL*1.8,y=WALL*2)
zrot(-90)yflip()
clamp3();*/