use <lib/bcad.scad>
use <lib/screw.scad>
use <lib/motor/17HD.scad>
include <./cfg.scad>
use <./vitamins.scad>

move(x=PX/2,y=PY/2)
    frameAssembly();    
move(y=PY,z=PZ)
    xAssembly();    
move(y=PY,z=PZ-PROFILE)
    topAssembly();
move(z=-PROFILE)
    printHeadAssembly();

move(x=PROFILE,y=PY/2,z=0)
zrot(-90)
    zAssembly();


    
module imp(name) {
    import( str("./output/",name) );
}


module extruder() {
    motorScrewOffset = (motorSize-motorScrewSpacing)/2;
    imp("extruda_holder.stl");
    move(z=-motorH+15) {
        17HD();
        move(z=motorH) {
            move(x=motorSize/2, y=motorSize/2)
                imp("extruda_base.stl");            
            move(x=motorSize-motorScrewOffset,y=motorScrewOffset,z=WALL)
                imp("extruda_idler.stl");
        }
    }
}


module frameAssembly() {  
    //Bottom rails
    yflip_copy()
    move(x=-PX/2, y=-PY/2)
    yrot(90)
        profile(PX);
    
    xflip_copy()
    move(x=-PX/2,y=-PY/2+PROFILE)
    xrot(-90)
        profile(PX);
    
    yflip_copy()
    xflip_copy()
    move(x=-PX/2+PROFILE,y=-PY/2+PROFILE)
    xrot(-90)
    profileCorner();  
    
    //Middle rails
    xflip_copy()
    yflip_copy()
    move(x=-PX/2,y=-PY/2) {
        profile(PX); 
        move(x=PROFILE,y=1)
            profileCorner();  
        move(x=PROFILE-1, y=PROFILE)
        zrot(90)
            profileCorner();  
    }
    
    //top rails
    move(z=PZ) {
        yflip_copy()
        move(x=-PX/2+PROFILE, y=-PY/2)
        yrot(90)
            profile(PX-PROFILE*2); 
        xflip_copy()
        move(x=-PX/2,y=-PY/2+PROFILE)
        xrot(-90)
            profile(PX);   
    }
}

//http://www.motedis.com/shop/Nutprofil-Zubehoer/Zubehoer-20-I-Typ-Nut-5/Winkel-20-I-Typ-Nut-5::732.html
module profileCorner() {
    SHELL= 2;
    color("Gainsboro")
    difference() {
        hull() {
            cube([18,18,SHELL]);
            cube([SHELL,18,18]);
        }
        move(x=SHELL,y=SHELL,z=SHELL)
            cube([18,18-SHELL*2,18]);
    }
}


module xAssembly() {
    move(x=motorSize+PROFILE,y=-motorH-WALL-20-PROFILE_SIZE,z=-motorSize/2)
    zrot(90) {
        imp("yMotorMount.stl");
        move(z=motorSize)
        yrot(90)
            17HD();
    }
}


module topAssembly() {       
    move(x=PROFILE, y=-motorSize-PROFILE,z=-motorSize-(XY_BEARING_MIN_WALL+XY_BEAR_D)*2)
    zrot(90) {
        imp("cornerMotor.stl");
        move(y=motorH+4)
        xrot(90)
            17HD();
    }
    
    move(z=-X_BEAR_POS-XY_SPACE-XY_BEAR_D/2-WALL) {
        move(x=PX-PROFILE,y=-PROFILE)
        zrot(-90)
            imp("corner_2x.stl");
        
        move(x=PROFILE,y=-PY+PROFILE)
        zrot(90)
            imp("corner_2x.stl");
        
        move(x=PX-PROFILE,y=-PY+PROFILE)
        zrot(90)
            imp("corner_flip.stl");
    }
}


module printHeadAssembly() {
    move(x=PROFILE, y=PROFILE+X_BEAR_POS, z=PZ-XY_SPACE-X_BEAR_POS)
        topRods(width=PY-PROFILE*2-X_BEAR_POS*2,length=PX-PROFILE*2);

    move(x=PX-PROFILE*2+X_BEAR_POS,y=PROFILE,z=PZ-X_BEAR_POS)
    zrot(90)
        topRods(width=PX-PROFILE*2-X_BEAR_POS*2,length=PY-PROFILE*2,carriageFilp=true);

    move(x=PX/2,y=PY/2-20, z=PZ-64)
    zrot(90) xrot(90)
        import("./kitten_parts/print_head.stl");
}

module topRods(length=PX-PROFILE*2, width=PY,carriageFilp=false) {
    CARRIAGE_LEN = 35;
    
    move(y=width/2) {   
        yflip_copy()
        move(y=-width/2)
        yrot(90) 
        {
            %cylinder(d=6,h=length);
            gt2pulley();
            move(z=length)
            zflip() gt2pulley();
            
            move(z=(length-CARRIAGE_LEN)/2)
            xrot(90) yrot(carriageFilp ? 0 : 180)
                imp("carriage.stl");
        }
    }
    
    //Belt
    color("black") 
    zflip_copy() {
        move(x=7,z=6) {
            cube([6,width,1]);
            move(x=length-22)
                cube([6,width,1]);
        }
    }
    
    move(y=width/2) {   
        move(y=-width/2)
        yrot(90) 
        {
            move(z=(length-CARRIAGE_LEN)/2)
            xrot(90) yrot(carriageFilp ? 0 : 180)
            move(y=CARRIAGE_LEN-6.8,x=CARRIAGE_ROD_SPACE,z=carriageFilp ? -width : 0)
                %cylinder(d=6,h=width);
        }
    }
    
}


module zAssembly(plate=10){    
    move(x=-(motorSize+6)/2,y=0, z=-PROFILE+WALL)
        imp("zmotorhold.stl");
    
    move(y=motorSize/2, z=motorH-PROFILE) {
        17HD(center=true);
        up(3) {
            coupler();
            color("gold") cylinder(d=8,h=165);
        }
    }    
    
    xflip_copy()
    move(x=50,y=-10) {
        imp("zhold.stl");
        %cylinder(d=10,h=PZ-PROFILE);        
        move(z=PZ-PROFILE)
            zflip() imp("zhold.stl");    
    }

    move(z=6+50+plate) {
        color("silver")
        move(z=-6,y=21.25)
            yflip()linear_extrude(height=6)
                import("./dxf/traegerplatte.dxf");
        
        //Print space
        %move(x=-180/2, y=21.25+10,z=10)
            cube([180,170,3]);
        
        color("silver")
        xflip_copy()
            move(x=50,y=-PROFILE/2) {
                LHICD10();   
                
                xflip_copy()
                move(x=29/2,z=-10)
                    cylinder(d=4,h=10);
            }
    }

    move(x=-50,y=-10,z=40)
        zflip() imp("zsensor.stl");    
}