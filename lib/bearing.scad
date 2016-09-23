use <./bcad.scad>


//////////////////////////////////////////////////////////////////////
// Flange Bearings.
//////////////////////////////////////////////////////////////////////
function get_lmkuu_width(size) = lookup(size, [ //K
        [  6.0,   22],
        [  8.1,   25], //the s version
        [  8.0,   25],
        [ 10.0,   30],
        [ 12.0,   32],
        [ 13.0,   34],
        [ 16.0,   37],
        [ 20.0,   42],
        [ 25.0,   50],
        [ 30.0,   58],
        [ 35.0,   64]
]);

function get_lmkuu_dim(size) = lookup(size, [ //D
        [  6.0,   12],
        [  8.1,   15], //S
        [  8.0,   15],
        [ 10.0,   19],
        [ 12.0,   21],
        [ 13.0,   23],
        [ 16.0,   28],
        [ 20.0,   32],
        [ 25.0,   40],
        [ 30.0,   45],
        [ 35.0,   52]
]);

function get_lmkuu_len(size) = lookup(size, [ //L
        [  6.0,   19],
        [  8.1,   17],//S
        [  8.0,   24],
        [ 10.0,   29],
        [ 12.0,   30],
        [ 13.0,   32],
        [ 16.0,   37],
        [ 20.0,   42],
        [ 25.0,   59],
        [ 30.0,   64],
        [ 35.0,   70]

]);

function get_lmkuu_pcd(size) = lookup(size, [ //P.C.D
        [  6.0,   20],
        [  8.1,   24],//S
        [  8.0,   24],
        [ 10.0,   29],
        [ 12.0,   32],
        [ 13.0,   33],
        [ 16.0,   38],
        [ 20.0,   43],
        [ 25.0,   51],
        [ 30.0,   60],
        [ 35.0,   97]
]);

function get_lmkuu_d1(size) = lookup(size, [ //D1
        [  6.0,   3.5],
        [  8.1,   3.5],//S
        [  8.0,   3.5],
        [ 10.0,   4.5],
        [ 12.0,   4.5],
        [ 13.0,   4.5],
        [ 16.0,   4.5],
        [ 20.0,   5.5],
        [ 25.0,   5.5],
        [ 30.0,   6.6],
        [ 35.0,   6.6]
]);

module LMKXUU(size=10) {
    w = get_lmkuu_width(size);

    difference() {
        union() {
            move(x=-w/2,y=-w/2)
                cube([w,w,6]);
            cylinder(d=get_lmkuu_dim(size),h=get_lmkuu_len(size));
        }
        down(1) {
            zring(n=4)
                zrot(-45)
                move(x=get_lmkuu_pcd(size)/2)
                cylinder(d=get_lmkuu_d1(size),h=50);

            cylinder(d=size,h=50);
        }
    }
}

//////////////////////////////////////////////////////////////////////
// Round Bearings.
//////////////////////////////////////////////////////////////////////
function get_bearing_inner_diam(size) = lookup(size, [
        [ 115.0,   5.0],//MR115
        [ 188.0,   6.3],
        [ 608.0,   8.0],
        [ 623.0,   3.0],
        [ 624.0,   4.0],
        [ 626.0,   6.0],
        [ 627.0,   7.0],
        [ 688.0,   8.0],
        [ 698.0,   8.0]
]);

function get_bearing_outer_diam(size) = lookup(size, [
        [ 115.0,  11.0],//MR115
        [ 188.0,  13.5],
        [ 608.0,  22.0],
        [ 623.0,  10.0],
        [ 624.0,  13.0],
        [ 626.0,  19.0],
        [ 627.0,  22.0],
        [ 688.0,  16.0],
        [ 698.0,  19.0]
    ]);

function get_bearing_height(size) = lookup(size, [
        [ 115.0,   4.0],//MR115
        [ 188.0,   5.0],
        [ 608.0,   7.0],
        [ 623.0,   4.0],
        [ 624.0,   5.0],
        [ 626.0,   6.0],
        [ 627.0,   7.0],
        [ 688.0,   4.0],
        [ 698.0,   6.0]
    ]);




module _bearRing(od, id, h, material, holeMaterial) {
    difference() {
        cylinder(d=od,h=h);
        translate([0,0,-1])
            cylinder(d=id,h=h+2);
    }
}

module bearing(size = 626, outline) {
    innerD = get_bearing_inner_diam(size);
    outerD = get_bearing_outer_diam(size);
    h = get_bearing_height(size);

    if(outline) {
        innerRim = innerD + (outerD - innerD) * 0.2;
        outerRim = outerD - (outerD - innerD) * 0.2;
        midSink = h * 0.1;
        translate([0,0,midSink])
            _bearRing(outerRim,innerRim,h-midSink*2);
        color([0.65, 0.67, 0.72])
            _bearRing(innerRim, innerD, h);
        color([0.65, 0.67, 0.72])
            _bearRing(outerD, outerRim, h);
    } else {
        color([0.65, 0.67, 0.72])
            _bearRing(outerD, innerD, h);
    }
}

bearing(size=115,outline=true);






//////////////////////////////////////////////////////////////////////
// Linear Bearings.
//////////////////////////////////////////////////////////////////////
function get_lmXuu_bearing_diam(size) = lookup(size, [
        [  4.0,   8.0],
        [  5.0,  10.0],
        [  6.0,  12.0],
        [  8.0,  15.0],
        [ 10.0,  19.0],
        [ 12.0,  21.0],
        [ 13.0,  23.0],
        [ 16.0,  28.0],
        [ 20.0,  32.0],
        [ 25.0,  40.0],
        [ 30.0,  45.0],
        [ 35.0,  52.0],
        [ 40.0,  60.0],
        [ 50.0,  80.0],
        [ 60.0,  90.0],
        [ 80.0, 120.0],
        [100.0, 150.0]
    ]);

function get_lmXuu_bearing_length(size) = lookup(size, [
        [  4.0,  12.0],
        [  5.0,  15.0],
        [  6.0,  19.0],
        [  8.0,  24.0],
        [ 10.0,  29.0],
        [ 12.0,  30.0],
        [ 13.0,  32.0],
        [ 16.0,  37.0],
        [ 20.0,  42.0],
        [ 25.0,  59.0],
        [ 30.0,  64.0],
        [ 35.0,  70.0],
        [ 40.0,  80.0],
        [ 50.0, 100.0],
        [ 60.0, 110.0],
        [ 80.0, 140.0],
        [100.0, 175.0]
    ]);


// Creates a model of a clamp to hold a given linear bearing cartridge.
//   d = Diameter of linear bearing. (Default: 15)
//   l = Length of linear bearing. (Default: 24)
//   tab = Clamp tab height. (Default: 7)
//   tabwall = Clamp Tab thickness. (Default: 5)
//   wall = Wall thickness of clamp housing. (Default: 3)
//   gap = Gap in clamp. (Default: 5)
//   screwsize = Size of screw to use to tighten clamp. (Default: 3)
module linear_bearing_housing(d=15,l=24,tab=7,gap=5,wall=3,tabwall=5,screwsize=3,clearance=0)
{
    od = d+2*wall;
    ogap = gap+2*tabwall;
    tabh = tab/2+od/2*sqrt(2)-ogap/2;
    translate([0,0,od/2]) difference() {
        union() {
            rotate([0,0,90])
                teardrop(r=od/2,h=l);
            translate([0,0,tabh])
                cube(size=[l,ogap,tab+0.05], center=true);
            translate([0,0,-od/4])
                cube(size=[l,od,od/2], center=true);
        }
        rotate([0,0,90])
            teardrop(r=d/2+clearance,h=l+0.05);
        translate([0,0,(d*sqrt(2)+tab)/2])
            cube(size=[l+0.05,gap,d+tab], center=true);
        translate([0,0,tabh]) {
            translate([0,-ogap/2+2-0.05,0])
                rotate([90,0,0])
                    screw(screwsize=screwsize*1.06, screwlen=ogap, headsize=screwsize*2, headlen=10);
            translate([0,ogap/2+0.05,0])
                rotate([90,0,0])
                    metric_nut(size=screwsize,hole=false);
        }
    }
}


module lmXuu_housing(size=8,tab=7,gap=5,wall=3,tabwall=5,screwsize=3,clearance=0)
{
    d = get_lmXuu_bearing_diam(size);
    l = get_lmXuu_bearing_length(size);
    linear_bearing_housing(d=d,l=l,tab=tab,gap=gap,wall=wall,tabwall=tabwall,screwsize=screwsize,clearance=clearance);
}


module lmXuu_zip(
    size = 6,
    length,
    wall = 3,
    clearance = 0,
    zipWidth = 3.5,
    zipHeight = 1.5,
    zipOffset = 2,
    zipCnt = 2
){
    linearBearingHolderZip(size=size,length=length,wall=wall,
        clearance=clearance,zipWidth=zipWidth,zipHeight=zipHeight,
        zipOffset = zipOffset, zipCnt=zipCnt);
}




//--Linear bearing
module groove(d1, d2, w) {
    difference() {
        cylinder(r=d1/2+1, h=w, center=true);
        cylinder(r=d2/2  , h=w, center=true);
    }
}

module lb(D_Int=8, D_Ext=15, D_1=14.3, L=24, W=1.1, B=17.5) {
chamf = D_Ext - D_1;
    difference() {
        hull() {
            cylinder(r=D_Ext/2, h=L-chamf, center=true);
            cylinder(r=D_1  /2, h=L      , center=true);
        }
        cylinder(r=D_Int/2, h=L+2    , center=true);
        translate([0, 0, B/2-W/2]) groove(D_Ext, D_1, W);
        translate([0, 0,-B/2+W/2]) groove(D_Ext, D_1, W);
        translate([0, 0,     L/2]) groove(D_Ext-(D_Ext-D_Int)/2, 1, W);
        translate([0, 0,    -L/2]) groove(D_Ext-(D_Ext-D_Int)/2, 1, W);
    }
}



module LM8UU() {
    lb(D_Int=8, D_Ext=15, D_1=14.3, L=24, W=1.1, B=17.5);
}

module LMXUU(size) {
    diam = get_lmXuu_bearing_diam(size);
    leng = get_lmXuu_bearing_length(size);
    lb(D_Int=size, D_Ext=diam, D_1=diam-0.7, L=leng, W=1.1, B=leng-6.5);
}




//linearBearingHolderZip(zipCnt=1);

module linearBearingHolderZipCut(
    size = 6,
    wall = 3,
    zipWidth = 3.5,
    zipHeight = 1.5,
    zipOffset = 2,
) {
    bearingD = get_lmXuu_bearing_diam(size);
    bearingR = bearingD / 2;

    up((bearingR+wall)/2)
        yrot(90)
        right(zipOffset) {
            difference () {
                cylinder(r=bearingR + wall, h=zipWidth,center=true);
                cylinder(r=bearingR + wall - zipHeight, h=zipWidth+1,center=true);
            }
            yflip_copy()
                move(y=bearingR+wall-zipHeight/2+0.5)
                    cube([wall*2,zipHeight+1,zipWidth], center=true);
        }
}

module linearBearingHolderZip(
    size = 6,
    length,
    wall = 3,
    clearance = 0,
    zipWidth = 3.5,
    zipHeight = 1.5,
    zipOffset = 2,
    zipCnt = 2
) {
    bearingD = get_lmXuu_bearing_diam(size);
    bearingR = bearingD / 2;
    bearingLen = (length==undef)?get_lmXuu_bearing_length(size):length;

    h = bearingD/2 + wall;

    up(h/2)
    difference() {
        cube([bearingLen, bearingD + wall*2, h],center=true);
        //Bearing
        up((bearingR+wall)/2)
            yrot(90)
                cylinder(d=bearingD+clearance,h=bearingLen+10, center=true);


        //Zips
        xspread(bearingLen/zipCnt,n=zipCnt)
            linearBearingHolderZipCut(size=size, wall=wall,
                zipOffset=zipOffset,zipWidth=zipWidth,zipHeight=zipHeight);
    }
}

module linearBearingHolder(bearing=8, screw=3, wall=3, nutWall=2, clearance=0.5, useNut=1, nutCount=1,length) {
    // main body dimensions
    bearingRodD = bearing;
    bearingD = get_lmXuu_bearing_diam(bearing); //LM8UU
    bearingLen = (length==undef)?get_lmXuu_bearing_length(bearing):length;
    //Screw nut M3
    screwThreadDiaISO = 3;
    screwHeadDiaISO = 5.5;
    nutWrenchSizeISO = 5.5;

    //Calc all we need
    bodyWidth = bearingD + (2*wall);
    bodyHeight = bodyWidth;
    bodyLen = bearingLen;

    screwBushingSpace = 1;
    screwThreadDia = screwThreadDiaISO + clearance;
    screwElevation = bearingD + wall + (screwThreadDia/2) +screwBushingSpace;
    screwHeadD = screwHeadDiaISO + clearance;
    nutWrenchSize = nutWrenchSizeISO + clearance;

    gapWidth = bearingRodD +2;

    nutSpacing = bodyLen / nutCount;

    difference() {
        union() {
            //Body
            up(bodyHeight/4)
                cube([bodyWidth,bodyLen,bodyHeight/2], center=true);
            up((bearingD/2) +wall)
                xrot(90)
                    cylinder(r=(bearingD/2)+wall, h=bearingLen, center=true);

            if(useNut) {
                //Gap support
                xflip_copy()
                    move(x=-(gapWidth/2)-wall,y=-(bodyLen/2), z=bodyHeight/2)
                        cube([wall, bearingLen, (bearingD/2)+screwBushingSpace+screwThreadDia/2]);

                yspread(spacing=nutSpacing, n=nutCount) {
                // Screw hole surround
                xflip_copy()
                move(x=-gapWidth/2,z=screwElevation)
                    yrot(-90)
                        cylinder(r=(screwHeadD/2)+nutWall,h=(bodyWidth-gapWidth)/2, $fn=20);

                //Nut and screw support
                xflip_copy()
                    move(x=gapWidth/2+(bodyWidth-gapWidth)/4, z=screwElevation/2)
                        cube([(bodyWidth-gapWidth)/2, nutWrenchSize+nutWall*2,screwElevation],center=true);
                }
            }
        }

        //bushing hole
        up(bearingD/2+wall)
            xrot(90)
                cylinder(r=bearingD/2, h=bearingLen+1,center=true);

        //top gap
        move(x=-gapWidth/2,y=-bodyLen/2-1,z=bodyHeight/2)
            cube([gapWidth,bodyLen+2,bodyHeight]);

        if(useNut) {
            //screw hole
            yspread(spacing=nutSpacing, n=nutCount) {
                up(screwElevation)
                    yrot(90)
                        cylinder(r=screwThreadDia/2,h=bodyWidth+2, center=true);
                //nut trap
                move(x=gapWidth/2+wall, z=screwElevation)
                    yrot(90)
                        cylinder(r=nutWrenchSize/2, h=bodyWidth/2-gapWidth/2-wall+1,$fn=6);

                //Screw head hole
                move(x=-gapWidth/2-wall, z=screwElevation)
                    yrot(-90)
                        cylinder(r=screwHeadD/2,h=bodyWidth/2-gapWidth/2-wall+1);
            }
        }
    }
}


module LMXUUClamp(
    size = 8,
    thickness = 2.4,
    clearance = 0,
    gap = 3,
    length)
{
    diam  = get_lmXuu_bearing_diam(size);
    h = (length==undef)?get_lmXuu_bearing_length(size):length;

    difference() {
        cylinder(d=diam+thickness*2,h=h);
        down(1) {
            cylinder(d=diam+clearance, h=h+2);
            move(y=-gap/2)
                cube([diam+20,gap,h+2]);
        }
    }
}