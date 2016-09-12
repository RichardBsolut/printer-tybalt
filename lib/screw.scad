//////////////////////////////////////////////////////////////////////
// Screws, Bolts, and Nuts.
//////////////////////////////////////////////////////////////////////

function get_metric_bolt_head_size(size) = lookup(size, [
		[ 4.0,  7.0],
		[ 5.0,  8.0],
		[ 6.0, 10.0],
		[ 7.0, 11.0],
		[ 8.0, 13.0],
		[10.0, 16.0],
		[12.0, 18.0],
		[14.0, 21.0],
		[16.0, 24.0],
		[18.0, 27.0],
		[20.0, 30.0]
	]);


function get_metric_nut_size(size) = lookup(size, [
		[ 2.0,  4.0],
		[ 2.5,  5.0],
		[ 3.0,  5.5],
		[ 4.0,  7.0],
		[ 5.0,  8.0],
		[ 6.0, 10.0],
		[ 7.0, 11.0],
		[ 8.0, 13.0],
		[10.0, 17.0],
		[12.0, 19.0],
		[14.0, 22.0],
		[16.0, 24.0],
		[18.0, 27.0],
		[20.0, 30.0],
	]);


function get_metric_nut_thickness(size) = lookup(size, [
		[ 2.0,  1.6],
		[ 2.5,  2.0],
		[ 3.0,  2.4],
		[ 4.0,  3.2],
		[ 5.0,  4.0],
		[ 6.0,  5.0],
		[ 7.0,  5.5],
		[ 8.0,  6.5],
		[10.0,  8.0],
		[12.0, 10.0],
		[14.0, 11.0],
		[16.0, 13.0],
		[18.0, 15.0],
		[20.0, 16.0]
	]);


function get_metric_corehole_size(size) = lookup(size, [
		[ 2.0,  1.60],
		[ 2.5,  2.05],
		[ 3.0,  2.50],
		[ 4.0,  3.30],
		[ 5.0,  4.20],
		[ 6.0,  5.00],
		[ 8.0,  6.80],
		[10.0,  8.50],
		[12.0, 10.20],
		[16.0, 14.00],
		[20.0, 17.50]
	]);

// Makes a simple threadless screw, useful for making screwholes.
//   screwsize = diameter of threaded part of screw.
//   screwlen = length of threaded part of screw.
//   headsize = diameter of the screw head.
//   headlen = length of the screw head.
// Example:
//   screw(screwsize=3,screwlen=10,headsize=6,headlen=3);
module screw(screwsize=3,screwlen=10,headsize=6,headlen=3,$fn=undef,tolerance=0)
{
	$fn = ($fn==undef)?max(8,floor(180/asin(2/screwsize)/2)*2):$fn;
	translate([0,0,-(screwlen)/2])
		cylinder(r=screwsize/2+tolerance/2, h=screwlen+0.05, center=true, $fn=$fn);
	translate([0,0,(headlen)/2])
		cylinder(r=headsize/2+tolerance/2, h=headlen, center=true, $fn=$fn*2);
}


// Makes an unthreaded model of a standard nut for a standard metric screw.
//   size = standard metric screw size in mm. (Default: 3)
//   hole = include an unthreaded hole in the nut.  (Default: true)
// Example:
//   metric_nut(size=8, hole=true);
//   metric_nut(size=3, hole=false);
module metric_nut(size=3, hole=true, $fn=undef, center=false, play=0, hPlay=0)
{
	$fn = ($fn==undef)?max(8,floor(180/asin(2/size)/2)*2):$fn;
	radius = get_metric_nut_size(size)/2/cos(30);
	thick = get_metric_nut_thickness(size);
	offset = (center == true)? 0 : (thick+hPlay)/2;
	translate([0,0,offset]) difference() {
		cylinder(r=radius+play, h=thick+hPlay, center=true, $fn=6);
		if (hole == true)
			cylinder(r=size/2, h=thick+hPlay+0.5, center=true, $fn=$fn);
	}
}

module m3Screw(screwlen=10,headsize=6,headlen=3,$fn=undef) {
	screw(3, screwlen,headsize,headlen,$fn);
}

module m3Nut(hole=true, $fn=undef, center=false, play=0, hPlay = 0) {
	metric_nut(3, hole, $fn, center, play=play,hPlay=hPlay);
}