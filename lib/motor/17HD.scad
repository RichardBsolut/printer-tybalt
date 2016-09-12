use <../bcad.scad>


/*module 17HD() {
    cube([42,42,35],center=true);
    up(35/2)
        cylinder(d=5,h=10);
}*/
//17HD(center=true);

module 17HD(center=false){
    if(center) {
        move(x=-42/2,y=-42/2,z=-35)
            nema(size = 42, height = 35, shaftd = 5.2);
    } else
        nema(size = 42, height = 35, shaftd = 5.2);
}

module nema(size = 42, height = 35, shaftd = 5.2) {
    difference() {
        //MotorBase
        union() {
            color("silver")
                hull()
                corners([size, size], [5,5])
                    cylinder(r=5,h=height);
            up(height/4)
            color("black")
                hull()
                corners([size, size], [5,5])
                    cylinder(r=5.01,h=height/2);
        }
        //Mount holes
        up(height)
        corners([size, size], [size-11/2,size-11/2])
            cylinder(r=1.5,h=10, center = true);
    }
    
    move(x=size/2,y=size/2, z=height) {
        color("silver") //shaft
            cylinder(d=shaftd,h=10);

        color("gray")
        up(0)
        difference() {
            cylinder(r=11,h=2);
            up(0.1)
            cylinder(r=9.05,h=2);
        }
    }
}