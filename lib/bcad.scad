//--- copy from gdmutils

//////////////////////////////////////////////////////////////////////
// Transformations.
//////////////////////////////////////////////////////////////////////


// Moves/translates children.
//   x = X axis translation.
//   y = Y axis translation.
//   z = Z axis translation.
// Example:
//   move([10,20,30]) sphere(r=1);
//   move(y=10) sphere(r=1);
//   move(x=10, z=20) sphere(r=1);
module move(a=[0,0,0], x=0, y=0, z=0) {
    translate(a) translate([x,y,z]) children();
}


// Moves/translates children the given amount along the X axis.
// Example:
//   xmove(10) sphere(r=1);
module xmove(x=0) { translate([x,0,0]) children(); }


// Moves/translates children the given amount along the Y axis.
// Example:
//   ymove(10) sphere(r=1);
module ymove(y=0) { translate([0,y,0]) children(); }


// Moves/translates children the given amount along the Z axis.
// Example:
//   zmove(10) sphere(r=1);
module zmove(z=0) { translate([0,0,z]) children(); }


// Moves children left by the given amount in the -X direction.
// Example:
//   left(10) sphere(r=1);
module left(x=0) { translate([-x,0,0]) children(); }


// Moves children right by the given amount in the +X direction.
// Example:
//   right(10) sphere(r=1);
module right(x=0) { translate([x,0,0]) children(); }


// Moves children forward by x amount in the -Y direction.
// Example:
//   forward(10) sphere(r=1);
module forward(y=0) { translate([0,-y,0]) children(); }
module fwd(y=0) { translate([0,-y,0]) children(); }


// Moves children back by the given amount in the +Y direction.
// Example:
//   back(10) sphere(r=1);
module back(y=0) { translate([0,y,0]) children(); }


// Moves children down by the given amount in the -Z direction.
// Example:
//   down(10) sphere(r=1);
module down(z=0) { translate([0,0,-z]) children(); }


// Moves children up by the given amount in the +Z direction.
// Example:
//   up(10) sphere(r=1);
module up(z=0) { translate([0,0,z]) children(); }


// Rotates children around the Z axis by the given number of degrees.
// Example:
//   xrot(90) cylinder(h=10, r=2, center=true);
module xrot(a=0) { rotate([a, 0, 0]) children(); }


// Rotates children around the Y axis by the given number of degrees.
// Example:
//   yrot(90) cylinder(h=10, r=2, center=true);
module yrot(a=0) { rotate([0, a, 0]) children(); }


// Rotates children around the Z axis by the given number of degrees.
// Example:
//   zrot(90) cube(size=[9,1,4], center=true);
module zrot(a=0) { rotate([0, 0, a]) children(); }


// Scales children by the given factor in the X axis.
// Example:
//   xscale(3) sphere(r=100, center=true);
module xscale(x) {scale([x,0,0]) children();}


// Scales children by the given factor in the Y axis.
// Example:
//   yscale(3) sphere(r=100, center=true);
module yscale(y) {scale([0,y,0]) children();}


// Scales children by the given factor in the Z axis.
// Example:
//   zscale(3) sphere(r=100, center=true);
module zscale(z) {scale([0,0,z]) children();}


// Mirrors the children along the X axis, kind of like xscale(-1)
module xflip() mirror([1,0,0]) children();


// Mirrors the children along the Y axis, kind of like yscale(-1)
module yflip() mirror([0,1,0]) children();


// Mirrors the children along the Z axis, kind of like zscale(-1)
module zflip() mirror([0,0,1]) children();





// Evenly distributes n duplicate children along an XYZ line.
//   p1 = starting point of line.  (Default: [0,0,0])
//   p2 = ending point of line.  (Default: [10,0,0])
//   n = number of copies to distribute along the line. (Default: 2)
// Examples:
//   line_of(p1=[0,0,0], p2=[-10,15,20], n=5) cube(size=[3,1,1],center=true);
//
module line_of(p1=[0,0,0], p2=[10,0,0], n=2)
{
    delta = (p2 - p1) / (n-1);
    for (i = [0:n-1]) translate(p1+delta*i) children();
}
module spread(p1,p2,n=3) for (i=[0:n-1]) translate(p1+i*(p2-p1)/(n-1)) children();

// Spreads out n copies of the given children along the X axis.
//   spacing = spacing between copies. (Default: 1.0)
//   n = Number of copies to spread out. (Default: 2)
// Examples:
//   xspread(25) sphere(1);
//   xspread(25,3) sphere(1)
//   xspread(25, n=3) sphere(1)
//   xspread(spacing=20, n=4) sphere(1)
module xspread(spacing=1,n=2) for (i=[0:n-1]) right((i-(n-1)/2.0)*spacing) children();


// Spreads out n copies of the given children along the Y axis.
//   spacing = spacing between copies. (Default: 1.0)
//   n = Number of copies to spread out. (Default: 2)
// Examples:
//   yspread(25) sphere(1);
//   yspread(25,3) sphere(1)
//   yspread(25, n=3) sphere(1)
//   yspread(spacing=20, n=4) sphere(1)
module yspread(spacing=1,n=2) for (i=[0:n-1]) back((i-(n-1)/2.0)*spacing) children();


// Spreads out n copies of the given children along the Z axis.
//   spacing = spacing between copies. (Default: 1.0)
//   n = Number of copies to spread out. (Default: 2)
// Examples:
//   zspread(25) sphere(1);
//   zspread(25,3) sphere(1)
//   zspread(25, n=3) sphere(1)
//   zspread(spacing=20, n=4) sphere(1)
module zspread(spacing=1,n=2) for (i=[0:n-1]) up((i-(n-1)/2.0)*spacing) children();


//////////////////////////////////////////////////////////////////////
// Mutators.
//////////////////////////////////////////////////////////////////////


// Performs hull operations between consecutive pairs of children,
// then unions all of the hull results.
module chain_hull() {
    union() {
        if ($children == 1) {
            children();
        } else if ($children > 1) {
            for (i =[1:$children-1]) {
                hull() {
                    children(i-1);
                    children(i);
                }
            }
        }
    }
}

module hull_around() {
    if ($children == 1) {
        children();
    } else if ($children > 1) {
        for (i =[1:$children-1]) {
            hull() {
                children(0);
                children(i);
            }
        }
    }
}


//////////////////////////////////////////////////////////////////////
// Duplicators and Distributers.
//////////////////////////////////////////////////////////////////////

// Makes a copy of the children, mirrored across the given axes.
//   v = The normal vector of the plane to mirror across.
// Example:
//   mirror_copy([1,-1,0]) yrot(30) cylinder(h=10, r=1, center=true);
module mirror_copy(v=[0,0,1])
{
    union() {
        children();
        mirror(v) children();
    }
}
module xflip_copy() {children(); mirror([1,0,0]) children();}
module yflip_copy() {children(); mirror([0,1,0]) children();}
module zflip_copy() {children(); mirror([0,0,1]) children();}

module xrot_copy(a=0) {children(); xrot(a) children();}
module yrot_copy(a=0) {children(); yrot(a) children();}
module zrot_copy(a=0) {children(); zrot(a) children();}


// Given a number of euller angles, rotates copies of the given children to each of those angles.
// Example:
//   rot_copies(rots=[[0,0,0],[45,0,0],[0,45,120],[90,-45,270]])
//     translate([6,0,0]) cube(size=[9,1,4], center=true);
module rot_copies(rots=[[0,0,0]])
{
    for (rot = rots)
        rotate(rot)
            children();
}


// Given an array of angles, rotates copies of the children to each of those angles around the X axis.
//   rots = Optional array of angles, in degrees, to make copies at.
//   count = Optional number of evenly distributed copies, rotated around a circle.
//   offset = Angle offset in degrees, for use with count.
// Example:
//   xrot_copies(rots=[0,15,30,60,120,240]) translate([0,6,0]) cube(size=[4,9,1], center=true);
//   xrot_copies(count=6, offset=15) translate([0,6,0]) cube(size=[4,9,1], center=true);
module xrot_copies(rots=[0], offset=0, count=undef)
{
    if (count != undef) {
        for (i = [0 : count-1]) {
            a = (i / count) * 360.0;
            rotate([a+offset, 0, 0]) {
                children();
            }
        }
    } else {
        for (a = rots) {
            rotate([a+offset, 0, 0]) {
                children();
            }
        }
    }
}


// Given an array of angles, rotates copies of the children to each of those angles around the Y axis.
//   rots = Optional array of angles, in degrees, to make copies at.
//   count = Optional number of evenly distributed copies, rotated around a circle.
//   offset = Angle offset in degrees, for use with count.
// Example:
//   yrot_copies(rots=[0,15,30,60,120,240]) translate([6,0,0]) cube(size=[9,4,1], center=true);
//   yrot_copies(count=6, offset=15) translate([6,0,0]) cube(size=[9,4,1], center=true);
module yrot_copies(rots=[0], offset=0, count=undef)
{
    if (count != undef) {
        for (i = [0 : count-1]) {
            a = (i / count) * 360.0;
            rotate([0, a+offset, 0]) {
                children();
            }
        }
    } else {
        for (a = rots) {
            rotate([0, a+offset, 0]) {
                children();
            }
        }
    }
}


// Given an array of angles, rotates copies of the children to each of those angles around the Z axis.
//   rots = Optional array of angles, in degrees, to make copies at.
//   count = Optional number of evenly distributed copies, rotated around a circle.
//   offset = Angle offset in degrees, for use with count.
// Example:
//   zrot_copies(rots=[0,15,30,60,120,240]) translate([6,0,0]) cube(size=[9,1,4], center=true);
//   zrot_copies(count=6, offset=15) translate([6,0,0]) cube(size=[9,1,4], center=true);
module zrot_copies(rots=[0], offset=0, count=undef)
{
    if (count != undef) {
        for (i = [0 : count-1]) {
            a = (i / count) * 360.0;
            rotate([0, 0, a+offset]) {
                children();
            }
        }
    } else {
        for (a = rots) {
            rotate([0, 0, a+offset]) {
                children();
            }
        }
    }
}


module xring(n=2,r=0,rot=true) {if (n>0) for (i=[0:n-1]) {a=i*360/n; xrot(a) back(r) xrot(rot?0:-a) children();}}
module yring(n=2,r=0,rot=true) {if (n>0) for (i=[0:n-1]) {a=i*360/n; yrot(a) right(r) yrot(rot?0:-a) children();}}
module zring(n=2,r=0,rot=true) {if (n>0) for (i=[0:n-1]) {a=i*360/n; zrot(a) right(r) zrot(rot?0:-a) children();}}

// Makes a 3D grid of duplicate children.
//   xa = array or range of X-axis values to offset by. (Default: [0])
//   ya = array or range of Y-axis values to offset by. (Default: [0])
//   za = array or range of Z-axis values to offset by. (Default: [0])
//   count = Optional number of copies to have per axis. (Default: none)
//   spacing = spacing of copies per axis. Use with count. (Default: 0)
// Examples:
//   grid_of(xa=[0,2,3,5],ya=[3:5],za=[-4:2:6]) sphere(r=0.5,center=true);
//   grid_of(ya=[-6:3:6],za=[4,7]) sphere(r=1,center=true);
//   grid_of(count=3, spacing=10) sphere(r=1,center=true);
//   grid_of(count=[3, 1, 2], spacing=10) sphere(r=1,center=true);
//   grid_of(count=[3, 4], spacing=[10, 8]) sphere(r=1,center=true);
//   grid_of(count=[3, 4, 2], spacing=[10, 8, 5]) sphere(r=1,center=true, $fn=24);
module grid_of(xa=[0], ya=[0], za=[0], count=[], spacing=[])
{
    count = (len(count) == undef)? [count,1,1] :
            ((len(count) == 1)? [count[0], 1, 1] :
            ((len(count) == 2)? [count[0], count[1], 1] :
            ((len(count) == 3)? count : undef)));

    spacing = (len(spacing) == undef)? [spacing,spacing,spacing] :
            ((len(spacing) == 1)? [spacing[0], 0, 0] :
            ((len(spacing) == 2)? [spacing[0], spacing[1], 0] :
            ((len(spacing) == 3)? spacing : undef)));

    if (count != undef && spacing != undef) {
        for (x = [-(count[0]-1)/2 : (count[0]-1)/2 + 0.1]) {
            for (y = [-(count[1]-1)/2 : (count[1]-1)/2 + 0.1]) {
                for (z = [-(count[2]-1)/2 : (count[2]-1)/2 + 0.1]) {
                    translate([x*spacing[0], y*spacing[1], z*spacing[2]]) {
                        children();
                    }
                }
            }
        }
    } else {
        for (xoff = xa) {
            for (yoff = ya) {
                for (zoff = za) {
                    translate([xoff,yoff,zoff]) {
                        children();
                    }
                }
            }
        }
    }
}

// Makes a copy of the children, in all 4 corners in given size at given space.
// Example:
//   cube([10,20,2]);
//   #corners(size=[10,20], space=[2,2]) cylinder(d=2,h=5);
module corners(size, space) {
    move(x=space[0], y=space[1])
        children();
    move(x= size[0] - space[0], y=space[1])
        children();
    move(x= size[0] - space[0], y= size[1] - space[1])
        children();
    move(x= space[0], y= size[1] - space[1])
        children();
}




//////////////////////////////////////////////////////////////////////
// Compound Shapes.
//////////////////////////////////////////////////////////////////////

// Generates a support structur for an cylinder.
//   r = radius of supported cylinder.
//   h = height of support ring.
// Example:
//  cylinderSupport(r=5,h=3);

module cylinderSupport(r=5,h=2) {
    rotate_extrude() {
        right(r)
        difference() {
            square(h);
            move(x=h,y=h)
            circle(r = h);
        }
    }
}

// Generates a cube with cutted hexagons in it. Hexagons gets automated centered and counted.
//   size = size of the cube.
//   shell = minimal space between border and first hexagon.
//   india = radius of a single hexagon.
//   spacing = space between hexagons.
// Example:
//  hexPlate(size=[40,40,5], shell=3);

module hexPlate(size=[20,20,5], shell=2, india=5, spacing = 2) {
    xoff = india + spacing;
    xcnt = floor((size[0] - shell*2 ) / xoff)-1;
    xcenter = (size[0]/2) - ((xcnt*xoff)/2);

    yoff = sqrt(pow(xoff,2)-pow(xoff/2,2));
    ycnt = floor((size[1] - shell*2) / yoff) -1;
    ycenter = (size[1]/2) - ((ycnt*yoff)/2);

    difference() {
        cube(size);
        move(x=xcenter,y=ycenter,z=-1)
            for(y = [0:ycnt]) {
                for(x = [0:xcnt - y%2])
                    move(x=x*xoff +y%2*(xoff/2), y=y*yoff)
                    cylinder(r=india/2, h=size[2]+2,$fn=6);
            }
    }
}

// Makes an open rectangular strut with X-shaped cross-bracing, designed with 3D printing in mind.
//   h = height of strut wall.
//   l = length of strut wall.
//   thick = thickness of strut wall.
//   maxang = maximum overhang angle of cross-braces.
//   max_bridge = maximum bridging distance between cross-braces.
//   strut = the width of the cross-braces.
// Example:
//   sparse_strut(h=40, l=120, thick=4, maxang=30, strut=5, max_bridge=20);
//   sparse_strut(h=40, l=120, thick=4, maxang=50, strut=5, max_bridge=60);
module sparse_strut(h=50, l=100, thick=4, maxang=30, strut=5, max_bridge = 20)
{

    zoff = h/2 - strut/2;
    yoff = l/2 - strut/2;

    maxhyp = 1.5 * (max_bridge+strut)/2 / sin(maxang);
    maxz = 2 * maxhyp * cos(maxang);

    zreps = ceil(2*zoff/maxz);
    zstep = 2*zoff / zreps;

    hyp = zstep/2 / cos(maxang);
    maxy = min(2 * hyp * sin(maxang), max_bridge+strut);

    yreps = ceil(2*yoff/maxy);
    ystep = 2*yoff / yreps;

    ang = atan(ystep/zstep);
    len = zstep / cos(ang);

    union() {
        grid_of(za=[-zoff, zoff])
            cube(size=[thick, l, strut], center=true);
        grid_of(ya=[-yoff, yoff])
            cube(size=[thick, strut, h], center=true);
        grid_of(ya=[-yoff+ystep/2:ystep:yoff], za=[-zoff+zstep/2:zstep:zoff]) {
            xrot( ang) cube(size=[thick, strut, len], center=true);
            xrot(-ang) cube(size=[thick, strut, len], center=true);
        }
    }
}

// Makes a cube with rounded (filletted) vertical edges.
//   size = size of cube [X,Y,Z].  (Default: [1,1,1])
//   r = radius of edge/corner rounding.  (Default: 0.25)
// Examples:
//   rrect(size=[9,4,1], r=1, center=true);
//   rrect(size=[5,7,3], r=1, $fn=24);
module rrect(size=[1,1,1], r=0.25, center=false)
{
    $fn = ($fn==undef)?max(18,floor(180/asin(1/r)/2)*2):$fn;
    xoff=abs(size[0])/2-r;
    yoff=abs(size[1])/2-r;
    offset = center?[0,0,0]:size/2;
    translate(offset) {
        union(){
            grid_of([-xoff,xoff],[-yoff,yoff])
                cylinder(r=r,h=size[2],center=true,$fn=$fn);
            cube(size=[xoff*2,size[1],size[2]], center=true);
            cube(size=[size[0],yoff*2,size[2]], center=true);
        }
    }
}

module rrecth(size=[1,1,1], r=0.25, center=false) {
    translate(center?[0,0,0]:[0,size[1],0])
    xrot(90)
    rrect(size=[size[0],size[2],size[1]],r=r,center=center);
}


// Makes a cube with rounded (filletted) edges and corners.
//   size = size of cube [X,Y,Z].  (Default: [1,1,1])
//   r = radius of edge/corner rounding.  (Default: 0.25)
// Examples:
//   rcube(size=[9,4,1], r=0.333, center=true, $fn=24);
//   rcube(size=[5,7,3], r=1);
module rcube(size=[1,1,1], r=0.25, center=false)
{
	$fn = ($fn==undef)?max(18,floor(180/asin(1/r)/2)*2):$fn;
	xoff=abs(size[0])/2-r;
	yoff=abs(size[1])/2-r;
	zoff=abs(size[2])/2-r;
	offset = center?[0,0,0]:size/2;
	translate(offset) {
		union() {
			grid_of([-xoff,xoff],[-yoff,yoff],[-zoff,zoff])
				sphere(r=r,center=true,$fn=$fn);
			grid_of(xa=[-xoff,xoff],ya=[-yoff,yoff])
				cylinder(r=r,h=zoff*2,center=true,$fn=$fn);
			grid_of(xa=[-xoff,xoff],za=[-zoff,zoff])
				rotate([90,0,0])
					cylinder(r=r,h=yoff*2,center=true,$fn=$fn);
			grid_of(ya=[-yoff,yoff],za=[-zoff,zoff])
				rotate([90,0,0])
				rotate([0,90,0])
					cylinder(r=r,h=xoff*2,center=true,$fn=$fn);
			cube(size=[xoff*2,yoff*2,size[2]], center=true);
			cube(size=[xoff*2,size[1],zoff*2], center=true);
			cube(size=[size[0],yoff*2,zoff*2], center=true);
		}
	}
}

// Creates a cylinder with chamferred edges.
//   h = height of cylinder. (Default: 1.0)
//   r = radius of cylinder. (Default: 1.0)
//   chamfer = X axis inset of the edge chamfer. (Default: 0.25)
//   center = boolean.  If true, cylinder is centered. (Default: false)
//   top = boolean.  If true, chamfer the top edges. (Default: True)
//   bottom = boolean.  If true, chamfer the bottom edges. (Default: True)
// Example:
//   chamferred_cylinder(h=50, r=20, chamfer=5, angle=45, bottom=false, center=true);
module chamferred_cylinder(h=1, r=1, chamfer=0.25, angle=45, center=false, top=true, bottom=true)
{
	off = center? 0 : h/2;
	up(off) {
		difference() {
			cylinder(r=r, h=h, center=true);
			if (top) {
				translate([0, 0, h/2]) {
					rotate_extrude(convexity = 4) {
						translate([r, 0, 0]) {
							scale([1, tan(angle), 1]) {
								zrot(45) square(size=sqrt(2)*chamfer, center=true);
							}
						}
					}
				}
			}
			if (bottom) {
				translate([0, 0, -h/2]) {
					rotate_extrude(convexity = 4) {
						translate([r, 0, 0]) {
							scale([1, tan(angle), 1]) {
								zrot(45) square(size=sqrt(2)*chamfer, center=true);
							}
						}
					}
				}
			}
		}
	}
}

// Makes a cube with chamfered edges.
//   size = size of cube [X,Y,Z].  (Default: [1,1,1])
//   chamfer = chamfer inset along axis.  (Default: 0.25)
//Example:
//    chamfcube([10,10,10]);
module chamfcube(
        size=[1,1,1],
        chamfer=0.25,
        chamfaxes=[1,1,1],
        chamfcorners=false
) {
    ch_width = sqrt(2)*chamfer;
    ch_offset = 1;
    difference() {
        cube(size=size, center=true);
        for (xs = [-1,1]) {
            for (ys = [-1,1]) {
                if (chamfaxes[0] == 1) {
                    translate([0,xs*size[1]/2,ys*size[2]/2]) {
                        rotate(a=[45,0,0]) cube(size=[size[0]+0.1,ch_width,ch_width], center=true);
                    }
                }
                if (chamfaxes[1] == 1) {
                    translate([xs*size[0]/2,0,ys*size[2]/2]) {
                        rotate(a=[0,45,0]) cube(size=[ch_width,size[1]+0.1,ch_width], center=true);
                    }
                }
                if (chamfaxes[2] == 1) {
                    translate([xs*size[0]/2,ys*size[1]/2],0) {
                        rotate(a=[0,0,45]) cube(size=[ch_width,ch_width,size[2]+0.1], center=true);
                    }
                }
                if (chamfcorners) {
                    for (zs = [-1,1]) {
                        translate([xs*size[0]/2,ys*size[1]/2,zs*size[2]/2]) {
                            scale([chamfer,chamfer,chamfer]) {
                                polyhedron(
                                    points=[
                                        [0,-1,-1], [0,-1,1], [0,1,1], [0,1,-1],
                                        [-1,0,-1], [-1,0,1], [1,0,1], [1,0,-1],
                                        [-1,-1,0], [-1,1,0], [1,1,0], [1,-1,0]
                                    ],
                                    faces=[
                                        [ 8,  4,  9,  5],
                                        [ 9,  3, 10,  2],
                                        [10,  7, 11,  6],
                                        [11,  0,  8,  1],
                                        [ 0,  7,  3,  4],
                                        [ 1,  5,  2,  6],

                                        [ 1,  8,  5],
                                        [ 5,  9,  2],
                                        [ 2, 10,  6],
                                        [ 6, 11,  1],

                                        [ 0,  4,  8],
                                        [ 4,  3,  9],
                                        [ 3,  7, 10],
                                        [ 7,  0, 11],
                                    ]
                                );
                            }
                        }
                    }
                }
            }
        }
    }
}

// Makes a hollow tube with the given inner size and wall thickness.
// Warning: thats NOT the GDMUtils version all radius are inner sizes
//   h = height of tube. (Default: 1)
//   r = Outer radius of tube.  (Default: 1)
//   r1 = Outer radius of bottom of tube.  (Default: value of r)
//   r2 = Outer radius of top of tube.  (Default: value of r)
//   wall = horizontal thickness of tube wall. (Default 0.5)
// Example:
//   tube(h=3, r=4, wall=1, center=true);
//   tube(h=6, r=4, wall=2, $fn=6);
//   tube(h=3, r1=5, r2=7, wall=2, center=true);
module tube(h=1, r=1, r1=undef, r2=undef, wall=0.5, center=false)
{
    r1 = (r1==undef)? r : r1;
    r2 = (r2==undef)? r : r2;
    difference() {
        cylinder(h=h, r1=r1+wall*2, r2=r2+wall*2, center=center);
        down(1)
            cylinder(h=h+2, r1=r1, r2=r2, center=center);
    }
}


module tube2(h=1, r=1, wall=0.5)
{
    difference() {
        cylinder(h=h, r=r);
        down(1)
            cylinder(h=h+2, r=r-wall*2);
    }
}


// Creates a torus with a given outer radius and inner radius.
//   or = outer radius of the torus.
//   ir = inside radius of the torus.
// Example:
//   torus(or=30, ir=20, $fa=1, $fs=1);
module torus(or=1, ir=0.5)
{
    rotate_extrude(convexity = 4)
        translate([(or-ir)/2+ir, 0, 0])
            circle(r = (or-ir)/2);
}


// Makes a teardrop shape in the XZ plane. Useful for 3D printable holes.
//   r = radius of circular part of teardrop.  (Default: 1)
//   h = thickness of teardrop. (Default: 1)
// Example:
//   teardrop(r=3, h=2, ang=30);
module teardrop(r=1, h=1, ang=45, $fn=undef, xoff=undef, yoff=undef)
{
    $fn = ($fn==undef)?max(12,floor(180/asin(1/r)/2)*2):$fn;
    xrot(90) union() {
        translate([ 0, r*sin(ang), 0]) {
            scale([1, 1/tan(ang), 1]) {
                difference() {
                    zrot(45) {
                        cube(size=[2*r*cos(ang)/sqrt(2)+(xoff==undef?0:xoff), 2*r*cos(ang)/sqrt(2)+(yoff==undef?0:yoff), h], center=true);
                    }
                    translate([0, -r/2, 0]) {
                        cube(size=[2*r, r, h+1], center=true);
                    }
                }
            }
        }
        cylinder(h=h, r=r, center=true);
    }
}


// Makes a rectangular strut with the top side narrowing in a triangle.
// The shape created may be likened to an extruded home plate from baseball.
// This is useful for constructing parts that minimize the need to support
// overhangs.
//   w = Width (thickness) of the strut.
//   l = Length of the strut.
//   wall = height of rectangular portion of the strut.
//   ang = angle that the trianglar side will converge at.
// Example:
//   narrowing_strut(w=10, l=100, wall=5, ang=30);
module narrowing_strut(w=10, l=100, wall=5, ang=30)
{
    union() {
        translate([0, 0, wall/2])
            cube(size=[w, l, wall], center=true);
        difference() {
            translate([0, 0, wall])
                scale([1, 1, 1/tan(ang)]) yrot(45)
                    cube(size=[w/sqrt(2), l, w/sqrt(2)], center=true);
            translate([0, 0, -w+0.05])
                cube(size=[w+1, l+1, w*2], center=true);
        }
    }
}


// Makes a triangular wall with thick edges, which thins to a smaller width in
// the center, with angled supports to prevent critical overhangs.
//   h = height of wall.
//   l = length of wall.
//   thick = thickness of wall.
//   ang = maximum overhang angle of diagonal brace.
//   strut = the width of the diagonal brace.
//   wall = the thickness of the thinned portion of the wall.
//   diagonly = boolean, which denotes only the diagonal brace should be thick.
// Example:
//   thinning_triangle(h=50, l=100, thick=4, ang=30, strut=5, wall=2, diagonly=true);
module thinning_triangle(h=50, l=100, thick=5, ang=30, strut=5, wall=3, diagonly=false)
{
    dang = atan(h/l);
    dlen = h/sin(dang);
    difference() {
        union() {
            if (!diagonly) {
                translate([0, 0, -h/2])
                    narrowing_strut(w=thick, l=l, wall=strut, ang=ang);
                translate([0, -l/2, 0])
                    xrot(-90) narrowing_strut(w=thick, l=h-0.1, wall=strut, ang=ang);
            }
            intersection() {
                cube(size=[thick, l, h], center=true);
                xrot(-dang) yrot(180) {
                    narrowing_strut(w=thick, l=dlen*1.2, wall=strut, ang=ang);
                }
            }
            cube(size=[wall, l-0.1, h-0.1], center=true);
        }
        xrot(-dang) {
            translate([0, 0, h/2]) {
                cube(size=[thick+0.1, l*2, h], center=true);
            }
        }
    }
}

// Makes a triangular wall which thins to a smaller width in the center,
// with angled supports to prevent critical overhangs.  Basically an alias
// of thinning_triangle(), with diagonly=true.
//   h = height of wall.
//   l = length of wall.
//   thick = thickness of wall.
//   ang = maximum overhang angle of diagonal brace.
//   strut = the width of the diagonal brace.
//   wall = the thickness of the thinned portion of the wall.
// Example:
//   thinning_brace(h=50, l=100, thick=4, ang=30, strut=5, wall=2);
module thinning_brace(h=50, l=100, thick=5, ang=30, strut=5, wall=3)
{
    thinning_triangle(h=h, l=l, thick=thick, ang=ang, strut=strut, wall=wall, diagonly=true);
}



//===== OLD STUFF

module m3nut(h=3, holeCut=0,screwCut=0,screwDown=0) {
    translate([0,0,h/2])
    hull() {
        rotate([0,0,60])
            cube([5.9,3.3,h],center=true);
        rotate([0,0,-60])
            cube([5.9,3.3,h],center=true);
    }

    if(holeCut) {
        translate([-5.9/2,0,0])
            cube([5.9,holeCut,3]);
    }
    if(screwCut) {
        down(screwDown)
        cylinder(r=1.6,h=screwCut);
    }
}

module m3NutScrew(h=10,nutH=2.5) {
    cylinder(r=1.6,h=h);
    translate([0,0,h])
    m3nut(nutH);
}

module m3NutHolder(s=10, cutted=true, center=true) {

    module m3NutHolderCenter() {
        difference() {
            translate([-s/2,-s/2,0]) {
                union(){
                    cuttedCube([s,s,4], 2.5, 2.5);
                    if(cutted != true)
                        cube([s,2.5,4]);
                }
            }
            translate([0,0,-s+2.5])
                rotate([0,0,30])
                    m3NutScrew();
        }
    }

    if(center == true) {
        m3NutHolderCenter();
    } else {
        translate([0,5,5])
            rotate([90,0,0])
                rotate([0,90,0])
                    m3NutHolderCenter();
    }
}

module uglyScrew(h=10,head=2) {
    off = head - 2;
    if(off>0) {
        cylinder(r=2.75,h=off);
        up(off-0.02) {
            cylinder(r=2.75,r2=1.6,h=2);
            cylinder(r=1.6,h=h);
        }
    } else {
        cylinder(r=2.75,r2=1.6,h=1.5);
        cylinder(r=1.6,h=h);
    }
}

module smoothCylinder(r,h,space=0.25) {
    cylinder(r=r,h=h);
    cylinder(r=r+space,r2=r/2,h=h-h/4);
    translate([0,0,h/4])
        cylinder(r2=r+space,r1=r/2,h=h-h/4);
}

module cuttedCube(cSize, cutx, cuty) {
    cX = cSize[0];
    cY = cSize[1];
    linear_extrude(height=cSize[2])
    polygon([
        [cutx,0],
        [cX-cutx,0], [cX,cuty],
        [cX,cY-cuty], [cX-cutx, cY],
        [cutx, cY], [0, cY-cuty],
        [0, cuty]
    ]);
}

module cylinderHull(size) {
    x = size[0];
    y = size[1];
    h = size[2];
    r = (x<y) ? (x/2) : (y/2);

    hull() {
        translate([r,r,0])
            cylinder(r=r,h=h);
        translate([x-r,y-r,0])
            cylinder(r=r,h=h);
    }
}


module doubleCube(s1, s2, z,center=false) {
    x1=s1[0];
    y1=s1[1];
    x2=s2[0];
    y2=s2[1];
    offx = (x1-x2)/2;
    offy = (y1-y2)/2;

    hull() {
        cube([x1,y1,0.00001],center=center);
        if(center) {
            up(z)
                cube([x2,y2,0.00001],center=center);
        } else {
            translate([offx,offy,z-0.00001])
                cube([x2,y2,0.00001]);
        }
    }
}

module donut(w,r){
    rotate_extrude()
    translate([w,0,0])
    circle(r=r);
}

module triangle(size){
    x = size[0];
    y = size[1];

    linear_extrude(height=size[2])
    polygon([
        [x, 0],
        [0, y],
        [0, 0]
    ]);
}















module fillet(r=1.0,steps=3,include=true) {
  if(include) for (k=[0:$children-1]) {
    children(k);
  }
  for (i=[0:$children-2] ) {
    for(j=[i+1:$children-1] ) {
    fillet_two(r=r,steps=steps) {
      children(i);
      children(j);
      intersection() {
        children(i);
        children(j);
      }
    }
    }
  }
}

module fillet_two(r=1.0,steps=3) {
  for(step=[1:steps]) {
    hull() {
      render() intersection() {
        children(0);
        offset_3d(r=r*step/steps) children(2);
      }
      render() intersection() {
        children(1);
        offset_3d(r=r*(steps-step+1)/steps) children(2);
      }
    }
  }
}

module offset_3d(r=1.0) {
  for(k=[0:$children-1]) minkowski() {
    children(k);
    sphere(r=r,$fn=8);
  }
}