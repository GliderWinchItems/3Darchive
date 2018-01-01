/* scad/yogurt/fanadapt.scad
 * Adapter for fan to slow cooker 
 * Date of latest: 20171231
 *
 */

include <../library_deh/deh_shapes.scad>

odsq = 60;	// Outside square dimension
holectr = 50;	// Hole-hole spacing
holedia = 4 + 0.6;	// Hole diameter
fandia = 58;	// Dia of fan opening
cookdia = 185;	// Slow cooker diameter

thick = 6;

$fn = 100;

module mounting_hole(mx,my)
{
	translate([mx,my,0])
		cylinder(d = holedia,h = 20, center=false);
}

module adapt()
{
	difference()
	{  union()
		{
			rounded_rectangle(odsq,odsq,thick,5);
//			cube([odsq,odsq, thick],center=true);
		}
		union()
		{
			// Fan opening
			cylinder(d=fandia, h = thick + 15, center=true);
			
			// Cooker case
			translate([0,0,-(cookdia/2 -  3)])
				rotate([0,90,0])
					cylinder(d = cookdia, h = odsq + 10, center=true);

			// Mounting holes
			mounting_hole( holectr/2, holectr/2);
			mounting_hole(-holectr/2,-holectr/2);
			mounting_hole( holectr/2,-holectr/2);
			mounting_hole(-holectr/2, holectr/2);
		}
	}
}

adapt();

