use <./lib/bcad.scad>
use <./lib/screw.scad>


//Based on src=http://www.thingiverse.com/thing:225188
//thumbWheel(size=3);
module thumbWheel(
    size = 3,  //Metric nut size 
    r=12,      //Radius of wheel
    rWall=0.5,  //Platic between nut and wall
    clear=0.1,
    grip=30,
    grip_gap=1.8,
    grip_depth=0.6,
    grip_angle=55
) {
    module GripPatter() {
        for (angle=[-grip_angle,grip_angle]) {
            hull(){
                rotate([angle,0,0]) 
                    cube([grip_depth*2,0.1,h*2],center=true);
                rotate([angle,0,0]) 
                    translate([1,0,0]) 
                        cube([1,grip_gap,h*2],center=true);
            }
        }
    }
    
    h = get_metric_nut_thickness(size) + rWall + clear;
    
    difference() {
        cylinder(d=r*2,h=h);
        move(z=-1) {
            metric_nut(size=size, hole=false, play=clear*2,hPlay=1+clear);
            cylinder(d=size+clear*2,h=h+2);
        }
        for (i=[0:grip])
            rotate([0,0,360/grip*i]) 
            translate([r+0.5-grip_depth,0,h/2]) 
                GripPatter();
    }   
}


module sandpaperHolder(d=9,h=60) {
    difference() {
        cylinder(d=d,h=h);
        #move(y=-(1.5/2), z=-1)
            cube([10,1.5,h+2]);
    }
}

//If you have to cut a screw in the right length
//viceJaws to protect the threads
module viceJaw(lX=25,lY=20,w=4,h=20,d=3) {
    difference() {
        union() {
            cube([w,lY,h]);
            cube([lX,w,h]);
        }
        move(x=lX/2,y=-d/6, z=-1)
            cylinder(d=d,h=h+2,$fn=4);
    }
    
}

module messuhr() { //dial gauge
    color("silver") {
        move(y=53/2+20,z=15/2)
        xrot(90)
            cylinder(d=8,h=20);
        cylinder(d=53,h=15);
        move(z=15)
            cylinder(d=58,h=8);
    }
}