/* File: mod6pjack.scad
 * 6P6C jack with flying leads mount
 * Author: deh
 * Latest edit: 20180521
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=25;

j6_len  = 13.7;		// Jack overall length
j6_wid  = 14.8;		// Jack overall width
j6_wall = 2;			// Side wall thickness/width
j6_ht   = 14.2;		// Height from base floor

j6_indent_wid = 12.3;	// Width at side indentations
j6_idx1 = 2.5; 	// width (x) of first land
j6_idx2 = 4.0;
j6_idx3 = 3.5;
j6_idx4 = 3.5;
j6_idx5 = 3.5;

module j6sidewall()
{
len = j6_len;
wid = j6_wid + j6_wall * 2;
wid1 = j6_wid + 0.5;	// Add tolerance

wid2 = j6_indent_wid + .5;	// Add tolerance
ofy = (wid - wid2)/2;

	{
		difference()
		{
			union()
			{
				translate([0,0,0])
					cube([len,wid,j6_ht],center=false);
			}
			union()
			{
				translate([0,j6_wall,0])
					cube([j6_idx1,wid1,j6_ht],center=false);

				x0 = j6_idx1;
				translate([x0,ofy,0])
					cube([j6_idx2,wid2,j6_ht],center=false);

				x1 = x0 + j6_idx2;
				translate([x1,j6_wall,0])
					cube([j6_idx3,wid1,j6_ht],center=false);

				x2 = x1 + j6_idx3;
				translate([x2,ofy,0])
					cube([j6_idx4,wid2,j6_ht],center=false);

				x3 = x2 + j6_idx4;
				translate([x3,ofy,0])
					cube([j6_idx5,wid2,j6_ht],center=false);

echo("x0 x1 x2 x3",x0, x1,x2,x3);
				

			}
		}
	}
}

j6sidewall();

/* Uncomment to print separately */
//translate([0,0,0]) jbase();
//translate([0,30,0]) jcap();
