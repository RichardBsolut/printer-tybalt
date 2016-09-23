include <./cfg.scad>
use <./lib/bcad.scad>
use <./lib/motor/17HD.scad>
use <./lib/bearing.scad>
use <./vitamins.scad>

gap=0.5;   
clear=0.3;
WALL = 2;

//Hobbed Pulley
HPulleyD = 12;
HPulleyH = 14;
HPulleyHD = 3;  //Hobbed deepth
HPulleyHT = 12; //Hobbed center from bottom


IDLER_BEAR = 608;
HPulleyBear = 115;

//Calced
//HP_R = HP_D / 2;
FilamentX = (HPulleyD-HPulleyHD/2)/2 + 0.2;
FilamentZ = HPulleyHT;

IdlerH = get_bearing_height(IDLER_BEAR)+6;
IdlerSpacing = FilamentZ-IdlerH/2;


extruderAssembly();

module bearing2() {
    color("silver")
    cylinder(d=11,h=5);
}

module hobbedPulley() {
    difference() {
        cylinder(d=HPulleyD,h=HPulleyH);
        move(z=HPulleyHT)
            rotate_extrude(convexity=10)
            move(x=HPulleyD/2)
                circle(d=HPulleyHD);
    }
}

echo("motorScrewSpacing/2",motorScrewSpacing/2);
echo("-FilamentX-WALL",-FilamentX-WALL);

module extruderAssembly() {
    hobbedPulley();
    color("silver")
        cylinder(d=5,h=20);

    newBase();
    move(z=HPulleyH+1)
        bearing(HPulleyBear,outline=true);
    
    move(x=motorScrewSpacing/2,y=-motorScrewSpacing/2,z=IdlerSpacing) idler(h=IdlerH);
    move(x=FilamentX+get_bearing_outer_diam(IDLER_BEAR)/2-1.5,z=IdlerSpacing-1.5) {
        plug();
        move(z=1.5+IdlerH/2)
            bearing(IDLER_BEAR,center=true,outline=true);
    }
}


module plug() {
    cylinder(d=12,h=1.5);
    cylinder(d=8-R_PLAY,h=14.25);
}

module newBase() {    
    
    hBearH = get_bearing_height(HPulleyBear);    
    hBearD = get_bearing_outer_diam(HPulleyBear);    
    
    bearD = get_bearing_outer_diam(IDLER_BEAR);
    bearH = get_bearing_height(IDLER_BEAR);    
    fullH = HPulleyH+WALL;
    
    difference() {
        union() {            
            move(x=-FilamentX-8/2-WALL,y=-(HPulleyD+WALL*2)/2)
                cube([FilamentX+8/2+WALL,HPulleyD+WALL*2,HPulleyH+hBearH]);
            cylinder(d=HPulleyD+WALL*2,h=HPulleyH+hBearH);
            
            cylinder(d=HPulleyD+WALL*2,h=fullH);//Wall around hpulley
            hull() {            
                cylinder(d=HPulleyD+WALL*2,h=fullH);//Wall around hpulley
                rrect([14,motorSize/2,fullH]);
                
                move(x=-FilamentX-WALL,y=motorSize/2-(6+WALL)/2)
                    cylinder(d=6+WALL,h=fullH);
                move(x=-FilamentX-WALL,y=-motorScrewSpacing/2)
                    cylinder(d=6+WALL,h=fullH);
                move(x=motorScrewSpacing/2,y=-motorScrewSpacing/2)
                    cylinder(d=6+WALL,h=fullH);
            }
        }
        
        //Screws
        move(z=2+20-5) {//2 HeadClear + 20 ScrewLen - 5 Interscetion in body
            move(x=-FilamentX-WALL,y=motorSize/2-(6+WALL)/2)
            zflip()
                mainScrew(screwlen=20,head=5);
            move(x=-FilamentX-WALL,y=-motorScrewSpacing/2)
            zflip()
                mainScrew(screwlen=20,head=5);
            move(x=motorScrewSpacing/2,y=-motorScrewSpacing/2)
            zflip()
                mainScrew(screwlen=20,head=5);
        }
        
        // Aussparrung idler
        up(IdlerSpacing) {
            move(x=10,y=-motorSize/2-10)
                cube([30,40,fullH]);
        }
        
        move(z=-1) {                      
            cylinder(d=HPulleyD+2,h=HPulleyH+2);//Cut HobbedPulley                        
            cylinder(d=hBearD+0.3,h=hBearH+HPulleyH+WALL+2);
            move(y=-5/2)
                cube([motorSize,5,fullH+WALL+2]);
        }
        
        cylinder(d=5.2,h=100,center=true);//Cut M5Bolt
        
        
        // Aussparrung (öffnung) in der Front des       Extruderblocks (Breite "Flanschring")
        move(x=FilamentX+(bearD+gap*2)/2, z=-1) {
            hull() {
                cylinder(d=bearD+gap*2,h=fullH+WALL+2);
                move(x=bearD/2)
                    cylinder(d=bearD+gap*2,h=fullH+WALL+2);
            }
        }

    
        //Idler Bearing
        move(x=HPulleyHT/2+bearD/2, z=FilamentZ-bearH/2)
            bearing(size=IDLER_BEAR);
        
        // Aussparrung PTFE Tube
        move(x=FilamentX,z=FilamentZ)
        xrot(90)
            cylinder(d=4,h=100,center=true);

        //Aussparrung PTFE Tube Holder PC4-01 
        move(x=FilamentX,z=FilamentZ,y=motorSize/2-4.5)
        xrot(-90)
            cylinder(d=5.7+R_PLAY,h=4.5+1);
            
        move(x=14-4.5, z=FilamentZ,y=motorScrewSpacing/2)
        yrot(90)
            spannfederCut();

    }
}

module spannfederCut() {
    hull() {
        cylinder(30,d=3.25+clear);
        move(y=8.5)
            cylinder(30,d=3.25+clear);
    }
    hull() {
        cylinder(3.5,d=6.5);
        move(y=8.5)
            cylinder(1.5,d=6.5);
    }
}

module idler(h=12,diai=8) {
    //Bearing
    BEARING_D = get_bearing_outer_diam(IDLER_BEAR);
    BEARING_H = get_bearing_height(IDLER_BEAR);
    
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
            move(z=-IdlerSpacing+2+1+(+20-5))
            zflip()
                mainScrew(screwlen=20,head=5);
        }

        // Aussparrung für Kugellagers
        move(x=-0.5, y=motorScrewSpacing/2,z=(h-(BEARING_H+1))/2) {
            cylinder(d=BEARING_D+2,h=BEARING_H+1);
            down(BEARING_H/2+ZBUFF)
                cylinder(d=8+clear,h=h+2);
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
                cylinder(d=4+clear,h=30);
                move(y=6.5)
                    cylinder(d=4+clear,h=30);
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
        translate([-0.5,motorScrewSpacing/2,-ZBUFF])cylinder(h+1*2,d=8+clear);
        }
}
