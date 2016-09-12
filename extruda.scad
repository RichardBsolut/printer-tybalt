include <./cfg.scad>
use <./lib/bcad.scad>
use <./lib/motor/17HD.scad>
use <./vitamins.scad>

//cfg
gad=54;    // Diameter Gehäuserundung
frd=22;    // Diameter "Flanschring"
t=16+1;      // Materialstärke (Dicke) der Basisplatte

kf1=0.25;  // Korrekturfaktor (in mm!)
kf3=0.40;  // Korrekturfaktor M3 Bohrung (in mm!)
gap=0.5;   // Korrekturfaktor Abstandsdeffinition

//Hobbed Pulley cfg
HP_D = 12; // Diameter außen
HP_H = 13;
HP_HD = 3;  //Hobbed deepth
HP_HT = 11; //Hobbed center from bottom

motorLift=15;

//Bearing
BEARING_D = 22;
BEARING_H = 7;

//Calced
HP_R = HP_D / 2;
FILA_X = (HP_D-HP_HD/2)/2 + 0.2;
FILA_Z = HP_HT;

//$fn=50;
//holder2();
//base();
//idler();
//plug();
//fullExtruda();



module plug() {
    cylinder(d=12,h=1.5);
    cylinder(d=8-R_PLAY,h=14.25);
}

module hobbedPulley() {
    difference() {
        cylinder(d=HP_D,h=HP_H);
        move(z=HP_HT)
            rotate_extrude(convexity=10)
            move(x=HP_D/2)
                circle(d=HP_HD);
    }
}


module fullExtruda() {
    17HD(center=true);
    move(z=1) {
        color("lightgrey") hobbedPulley();
        move(x=FILA_X, z= FILA_Z)
            fakefilament();
    }

    base();

    move(x=BEARING_D/2+HP_D/2,z=FILA_Z-BEARING_H/2)
        bearing();

    move(x=motorScrewSpacing/2,y=-motorScrewSpacing/2,z=FILA_Z-12/2)
        idler(h=12);

    move(x=-PROFILE,y=-motorSize/2, z=-motorLift)
        holder2();

}



module holder2() {
    difference() {
        union() {
            holderA();
            move(x=-3-2,y=motorSize,z=3)
            xrot(90)
                cornerSupport(h=motorSize,corner=3,size=2);
        }
        move(x=-20/2-12/2)
        move(z=3,y=-1)
            rrecth([12,motorSize+2,7],r=1.5);

        move(x=-50,z=-50) {
            move(y=-100)
                cube([100,100,100]);
            move(y=motorSize)
                cube([100,100,100]);
        }
    }
}

module holderA() {
    move(z=motorLift)
    difference() {
        motorSuspension(h=4);
        move(z=-ZBUFF,y=mScrewSpace*2,x=mScrewSpace*2)
            cube([50,50,50]);
    }

    move(x=-20.2) {
        difference() {
            cube([20,motorSize,3]);
            move(x=10,y=mScrewSpace+2,z=-1)
                cylinder(d=3.5,h=10);
            move(x=10,y=motorSize-mScrewSpace-2,z=-1)
                cylinder(d=3.5,h=10);
        }
        move(x=20-3)
            cube([3,motorSize,19]);
    }


    line_of(p1=[0,0,0],p2=[0,motorSize-mScrewSpace/2,0],n=4)
    move(x=-3,z=3+9)
    union() {
        yrot(180)
        xrot(-90)
            triangle([17,16-9,mScrewSpace/2]);

        move(x=-17.2,z=-9)
            cube([17,mScrewSpace/2,9]);

        move(z=-9,y=-2,x=-2)
            cornerSupport(h=16,size=2,corner=2);
        move(z=-9,y=mScrewSpace/2,x=-2)
            cornerSupport(h=16,size=2,corner=3);
    }

    move(x=-1,z=15)
        cube([2,motorSize,4]);
}






module holder() {
    move(z=motorLift)
    difference() {
        motorSuspension(h=4);
        move(z=-ZBUFF,y=mScrewSpace*2,x=mScrewSpace*2)
            cube([50,50,50]);
    }

    move(x=-20.2) {
        difference() {
            cube([20,motorSize,3]);
            move(x=10,y=mScrewSpace+2,z=-1)
                cylinder(d=3.5,h=10);
            move(x=10,y=motorSize-mScrewSpace-2,z=-1)
                cylinder(d=3.5,h=10);
        }
        move(x=20-3)
            cube([3,motorSize,19]);
    }


    line_of(p1=[0,0,0],p2=[0,motorSize-mScrewSpace/2,0],n=4)

    move(x=-3,z=3)
    yrot(180)
    xrot(-90)
    triangle([17,16,mScrewSpace/2]);

    move(x=-1,z=15)
    cube([2,motorSize,4]);
}


module spannfederCut() {
    hull() {
        cylinder(30,d=3.25+kf3);
        move(y=8.5)
            cylinder(30,d=3.25+kf3);
    }
    hull() {
        cylinder(3.5,d=6.5);
        move(y=8.5)
            cylinder(1.5,d=6.5);
    }
}

module base() {
    difference() {
        baseBase();
        move(x=-50,y=-50,z=-1)
            cube([100,100,5]);
    }
}

module baseBase() {
    difference() {
        intersection() {
            move(x=-motorSize/2,y=-motorSize/2)
                cube([motorSize,motorSize,t]);
            down(1)
                cylinder(d=gad,h=t+2);
        }

        // Befestigungsbohrungen M3
        //zring(n=4)
        yflip_copy()
        move(x=-motorSize/2+mScrewSpace,
             y=motorSize/2-mScrewSpace,
             z=-1) {
            cylinder(d=3+kf3,h=t+2);
            move(z=t+2-1-1)
                cylinder(d=7,h=t+2);
        }

        move(x=motorSize/2-mScrewSpace,
             y=-motorSize/2+mScrewSpace,
             z=-1)
            cylinder(d=3+kf3,h=t+2);


        //Aussparrungen
        move(z=-1) {
            cylinder(d=HP_D+gap, h=t+2); //Pulley
            //Kegel oben
            move(z=HP_HT)
                cylinder(d1=HP_D+gap*4,d2=frd+gap*2,h=20);
            //Kegel unten
            cylinder(d1=frd+gap*2,d2=HP_D+gap*4,h=HP_HT);
        }

        // Aussparrung (öffnung) in der Front des       Extruderblocks (Breite "Flanschring")
        move(x=FILA_X+(BEARING_D+gap*2)/2, z=-1) {
            hull() {
                cylinder(d=BEARING_D+gap*2,h=t+2);
                move(x=BEARING_D/2)
                    cylinder(d=BEARING_D+gap*2,h=t+2);
            }
        }

        // Aussparrung PTFE Tube
        move(x=FILA_X,z=FILA_Z+1)
        xrot(90)
            cylinder(d=4,h=100,center=true);

        // Aussparrung PTFE Tube holder
        move(x=FILA_X,z=FILA_Z+1,y=10+motorSize/2-6)
        xrot(90)
            cylinder(d=5.7+R_PLAY,h=10);

        // Aussparrung idler
        up(4) {
            move(x=10,y=-motorSize/2-10)
                cube([30,40,t]);
            move(x=14,y=0)
                cube([30,30,t]);
        }


        move(z=4+12/2,y=motorSize/2-5,x=motorSize/2-13.5+1.5)
        yrot(90)
            spannfederCut();
    }
}



idh=15;      // Höhe des Idlers
diai=8;      // Diameter der Aussenrundung am Drehpunkt

module idler(h=idh,diai=diai) {
    difference() {
        union() {//Grundform
            hull() {
                cylinder(d=diai+1,h=h);
                move(x=7,y=50)
                    cylinder(d=diai/2,h=h);
                move(x=7,y=2)
                    cylinder(d=diai/2,h=h);
            }
            hull(){
                translate([2,0,0])cylinder(d=diai/2,h=h);
                translate([7,2,0])cylinder(d=diai/2,h=h);
                translate([2,36.25,0])cylinder(d=diai/2,h=h);
                translate([7,50,0])cylinder(d=diai/2,h=h);
            }
            // Erweiterung / Verstärkung im Lagerbereich
            move(x=-0.5,y=motorScrewSpacing/2)
                cylinder(d=BEARING_D-4,h=h);
        }

        // Bohrung für die Achse des Hebels
        move(z=-1) {
            cylinder(d=3+kf3,h=h+2);
            move(z=h-1)
                cylinder(d=6.8,h=h+2);
        }

        // Aussparrung für Kugellagers
        move(x=-0.5, y=motorScrewSpacing/2,z=(h-(BEARING_H+1))/2) {
            cylinder(d=BEARING_D+2,h=BEARING_H+1);
            down(BEARING_H/2+ZBUFF)
                cylinder(d=8+kf1,h=h+2);
            down(BEARING_H/2+ZBUFF+0.5)
                cylinder(d=14,h=2);
        }

        // Einarbeitung einer "Griffmulde"
        move(x=0,y=43,z=3)
            rrect([5,10,h-6],r=diai/4);

        // Ausschnitt für die Federschraube mit Feder und U-Scheiben
        move(y=motorScrewSpacing, z=h/2)
        yrot(90) {
            hull() {
                cylinder(d=4+kf3,h=30);
                move(y=6.5)
                    cylinder(d=4+kf3,h=30);
            }
            move(z=7.5)
            hull() {
                cylinder(d=10,h=30);
                move(y=6.5)
                    cylinder(d=10,h=30);
            }
        }
    }
    // Verstärkung im Bereich des Kugellagers (Dient gleichzeitig der Zetrierung des Lagers)
    difference(){
        // Grundform (2x Kegelstumpf)
        union(){
            translate([-0.5,motorScrewSpacing/2,(h-BEARING_H-1)/2])cylinder(0.35,d1=8+10,d2=8+5);
            translate([-0.5,motorScrewSpacing/2,(h-BEARING_H-1)/2+BEARING_H+1-0.35])cylinder(0.35,d1=8+5,d2=8+10);
            }
        // Ausschnitt für die Lagerwelle
        translate([-0.5,motorScrewSpacing/2,-ZBUFF])cylinder(h+1*2,d=8+kf1);
        }

}




module bearing() {
    color("silver")
        cylinder(d=BEARING_D,h=BEARING_H);
}

module fakefilament(dia=1.75,l=100){
    color("black",0.5)
    xrot(90)
        cylinder(d=dia,h=l*2,center=true);
}

module ptfe(d=4,h=20) {
    color("white",0.8)
    xrot(90)
        cylinder(d=d,h=h,center=true);
}