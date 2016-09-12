use <./lib/bcad.scad>
include <./cfg.scad>
use <./vitamins.scad>

PLAY = 0.25;
hookLen = PROFILE_CUT + (PROFILE_SIZE-PROFILE_CUT)/2;
WALL=2;

$fn=50;
difference() {    
    fullClip(h=5);
    /*move(z=-1)
        scale([1,2,1])
            cylinder(d=WALL/2,h=10);*/
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
        rrect([hookLen+WALL,width,h],r=2);
        move(x=WALL,y=WALL,z=-1)
            rrect([hookLen-WALL,width-WALL*2,h+2],r=2);    
        
        move(x=hookLen+5,y=(width)/2,z=h/2)
        xrot(-gapDeg)
            cube([20,gap,h*4],center=true);
    }
}
