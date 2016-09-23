use <./lib/bcad.scad>

module printHeadAssembly() {
    zrot(90) xrot(90)
        import("./kitten_parts/print_head.stl");
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

viceJaw();


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

/*
printHeadAssembly();
move(x=30,y=5)
zrot(-45)
zrot(-90)
move(z=53/2+20)xrot(-90)
    messuhr();
*/