/* File: plno_gps.scad
 * Base for RTV'ing gps module and mounting in Plano enclosure
 * Author: deh
 * Latest edit: 20180512
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=50;

big = 10;	// Big z in direction 

pk_wid = 33;	// Inside y direction of pocket
pk_len = 10;	// Inside x direction of pocket
pk_ht  = 3;		// Inside depth of pocket
pk_thx = 2;		// Pocket wall thickness
pk_bot = 0.5;	// Thickness of bottom of pocket
pk_z   = pk_ht + pk_bot;
pk_x   = pk_len + 2*pk_thx;
pk_y   = pk_wid + 2*pk_thx;

bs_thx = 3; 	// Base thickness
bs_len = 25;	// Length x direction
bs_wid = pk_wid + 2 * pk_thx;
bs_hole1_x = 20;
bs_hole1_y = 5;
bs_hole2_x = 20;
bs_hole2_y = bs_wid - 5;
bs_hole1_d = 2.9;

module bs_hole(len,wid)
{
	translate([len,wid,0])
		cylinder(d=bs_hole1_d,h=big,center=false);
}

module base()
{
	difference()
	{
		union()
		{
			cube([bs_len,bs_wid,bs_thx],center=false);
			cube([pk_x,pk_y,pk_z],center=false);
		}

		union()
		{
			bs_hole(bs_hole1_x,bs_hole1_y);
			bs_hole(bs_hole2_x,bs_hole2_y);

			translate([pk_thx,pk_thx,pk_bot])
				cube([pk_len,pk_wid,big],center=false);

			translate([0,0,pk_z])
				cube([pk_x,pk_y,big],center=false);
		}
	}
}


module total()
{
    base();
}
total();
