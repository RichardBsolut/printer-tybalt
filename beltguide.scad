use <./lib/bcad.scad>
include <./cfg.scad>

beltGuide();

module betlGuideRamp(d) {
    cylinder(d=d+2,d2=d+3, h=0.5);
    up(0.5) cylinder(d=d+3, h=1);
    up(1.5) cylinder(d=d+3,d2=d+.1, h=1);    
}

module beltGuide(d=18.5, noBearing=false) {
    difference() {
        union() {
            betlGuideRamp(d);
            up(2.5) cylinder(d=d,h=12-2.5-2.5);
            up(12) zflip() betlGuideRamp(d);
        }
        down(1)
            cylinder(d=11+0.3,h=20);
    }    
}
