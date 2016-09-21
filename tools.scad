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


module messUhr() {
    move(y=53/2+20,z=15/2)
    xrot(90)
        cylinder(d=8,h=20);
    cylinder(d=53,h=15);
    move(z=15)
        cylinder(d=58,h=8);
}


printHeadAssembly();
move(x=30,y=5)
zrot(-45)
zrot(-90)
move(z=53/2+20)xrot(-90)
color("silver")
    messUhr();