use <./lib/bcad.scad>
use <./lib/screw.scad>
use <./lib/motor/17HD.scad>
include <./cfg.scad>


module endstopSwitch(center=false) {
    translate(center ? [-8.5/2,-8.5/2,0] : [0,0,0]) {
        color("silver")
            cube([8.5,8.5,8.5]);
        color("grey")
        move(x=8.5/2-4/2, y=8.5/2-4/2, z=8.5)
            cube([4,4,5.5]);
    }
}

module coupler() {
    color("silver")
        cylinder(d=19,h=25);
}

module filamentSpool() {
    color("DimGray")
    difference() {
        union() {
            cylinder(d=195,h=5);
            cylinder(d=90,h=80);
            move(z=75)
                cylinder(d=195,h=5);
        }
        move(z=-1)
            cylinder(d=40,h=82);
    }
}


//http://www.reichelt.de/TLE-4905L/3/index.html?ARTICLE=25717
module TLE4905L() {
    color("DimGray")
        cube([3,4,1.5]);
    color("Silver")
    move(x=1,z=0.2) {
        move(y=0.2)
            cube([15, 0.45, 0.3]);
        move(y=4/2-0.45/2)
            cube([15, 0.45, 0.3]);
        move(y=4-0.45-0.2)
            cube([15, 0.45, 0.3]);
    }
}


//http://www.pollin.de/shop/dt/OTc4ODQ2OTk-/Stromversorgung/Netzgeraete/Festspannungs_Netzgeraete/Schaltnetzteil_MEANWELL_RS_50_12_12_V_4_2_A.html
module powerSupply() {
    color("lightgrey")
        cube([99,97,36]);
}



//http://www.misumi-europe.com/de/e-catalog/vona2/detail/110300026970/?HissuCode=LHICD10&PNSearch=LHICD10&searchFlow=results2products
module LHICD10() {
    difference() {
        move(z=-6)
        union() {
            cylinder(d=19,h=47);
            move(z=6)
                intersection() {
                    cylinder(d=40,h=6);
                    move(z=10/2)
                        cube([50,19+6,10],center=true);
                }
        }
        move(z=-6-1) {
            //Screws
            xflip_copy()
            move(x=29/2) {
                cylinder(d=4,h=20);
                move(z=6+1+6-4.1)
                    cylinder(d=7.5,h=20);
            }

            //Hole
            cylinder(d=10,h=47+2);
        }
    }
}



module LS_6116_6() {
    xDiff = 68.2-50;
    cube([50,90,17.8]);

    move(x=50,y=90/2-45/2)
        cube([xDiff,45,17.8]);
}




module mainScrew(screwlen=9,forTap=false,head=2,headw=0) {
    up(2-head)
    cylinder(d=5.9+headw,h=head);
    if(forTap) {
        cylinder(d=get_metric_corehole_size(3),h=screwlen+2);
    } else
        cylinder(d=3,h=screwlen+2);
}

module profile(h=200) {
    color("silver") {
        difference() {
            cube([PROFILE_SIZE,PROFILE_SIZE,h]);
        }
    }
    color("black") {
        down(0.01)
            cube([PROFILE_SIZE+.01,PROFILE_SIZE+.01,2]);
        up(h-2+.01)
            cube([PROFILE_SIZE+.01,PROFILE_SIZE+.01,2]);
    }
}

module realProfile(h=50) {
    color("silver")
    difference() {
        cube([20,20,h],center=true);
        zring(n=4)
        move(x=10-6.5,y=-5/2,z=-(h+2)/2)
            cube([7.5,5,h+2]);
    }
}


module cornerProfile(size=50) {
    profile(size);
    up(size-PROFILE_SIZE) {
        xrot(90)profile(size);
        yrot(-90)profile(size);
    }
}


module gt2pulley(teeth=20) {
    color("silver",0.8) {
        if(teeth == 20) {
            cylinder(d=12,h=16);
            cylinder(d=16,h=7);
            up(16)
                cylinder(d=16,h=1);
        } else
        if(teeth == 16) {
            cylinder(d=14,h=5);
            up(5)
                cylinder(d=10,h=7.5);
            up(5+7.5)
                cylinder(d=14,h=15.5-7.5-5);

        }
    }
}

module gt2idle() {
    color("silver") {
        difference() {
            union() {
                cylinder(d=18,h=1);
                up(1)
                    cylinder(d=12,h=7);
                up(8)
                    cylinder(d=18,h=1);
            }
            down(1)
                cylinder(d=5,h=11);
        }
    }
}


module gt2pulleyWithBelt(teeth=20,rodH=50,beltH=200,pulleyH=0) {
    color("silver")
        cylinder(d=6,h=rodH);
    up(pulleyH) {
        gt2pulley();
        up(8)
        color("black")
        yflip_copy()
            move(x=-beltH+2,y=-(XY_PULLEY+1)/2) cube([beltH,1,6]);
    }
}

module 17HDPulley(teeth=20, center=false, pulleySpace = 0) {
    if(center) {
        17HD(center=true);
        up(3+pulleySpace)
            %gt2pulley(teeth=teeth);
    } else {
        17HD();
        move(x=42/2,y=42/2,z=34+3+pulleySpace)
            %gt2pulley(teeth=teeth);
    }
}




module motorSuspensionCut(h=8, yspace=0, xspace=0) {
    cylinder(d=motorScrewSpacing, h=h+2);

    //zring(n=4)
    yflip_copy()
    xflip_copy()
    move(x=motorScrewSpacing/2, y=motorScrewSpacing/2) {
        hull() {
            xflip_copy()
            yflip_copy()
            move(x=-xspace/2, y=-yspace/2)
                cylinder(d=3,h=h+2);
        }
    }
}

module motorSuspension(r=2.5,h=WALL, yspace=0, xspace=0) {
    difference() {
        cube([motorSize,motorSize,h]);
        move(x=motorSize/2, y=motorSize/2, z=-1)
            motorSuspensionCut(h+2,yspace=yspace, xspace=xspace);
    }
}


//--------- Compound object
module cornerSupportTranslate(corner=1,size=5) {
    if(corner==1)
        right(size) children();
    else if(corner==2)
        children();
    else if(corner==3)
        back(size) children();
    else if(corner==4)
        right(size)back(size) children();
}

module cornerSupport(size=5,corner=1,h=10,center=false) {
    translate(center ? [0,0,-h/2] : [0,0,0])
    difference() {
        cube([size,size,h]);
        down(1) {
            cornerSupportTranslate(corner=corner,size=size)
                cylinder(d=size*2,h=h+2);
        }
    }
}