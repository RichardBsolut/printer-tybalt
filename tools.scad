use <./lib/bcad.scad>


module sandpaperHolder(d=9,h=60) {
    difference() {
        cylinder(d=d,h=h);
        #move(y=-(1.5/2), z=-1)
            cube([10,1.5,h+2]);
    }

}
//$fn=50;
sandpaperHolder();