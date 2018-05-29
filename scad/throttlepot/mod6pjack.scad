/* File: mod6pjack.scad
 * 6P6C jack with flying leads mount
 * Author: deh
 * Latest edit: 20180521
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=50;

j6_len  = 13.7;		// Jack overall length
j6_wid  = 14.8;		// Jack overall width
j6_wall = 2;			// Side wall thickness/width
j6_ht   = 14.2;		// Height from base floor

j6_indent_wid = 12.3;	// Width at side indentations
j6_idx1 = 2.5+0.5; 	// width (x) of first land
j6_idx2 = 4.0-0.5;
j6_idx3 = 3.5+0.5;
j6_idx4 = 3.5;
j6_idx5 = 3.5;

module j6sidewall()
{
len = j6_len;
wid = j6_wid + j6_wall * 2;
wid1 = j6_wid + 0.5;	// Add tolerance

wid2 = j6_indent_wid + .5;	// Add tolerance
ofy = (wid - wid2)/2;

	translate([-len/2,-wid/2,0])
	{
		difference()
		{
			union()
			{
				translate([0,0,0])
					cube([len,wid,j6_ht],center=false);

				translate([-j6_wall,0,0])
					cube([j6_wall,wid,j6_ht],center=false);
			}
			union()
			{
				// Side slots for jack
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

				// Cutout in back wall for wires
				len3 = j6_wall;
				wid3 = 7.5;
				ht3  = 3;
				ofx3 = len3;
				ofy3 = wid3/2 + j6_wall;
				translate([-ofx3,ofy3,0])
					cube([len3,wid3,j6_ht],center=false);

echo("x0 x1 x2 x3",x0, x1,x2,x3);
				

			}
		}
	}
}
/* Post for cap plate */
j6pst_d1 = 6;		// Post diameter
j6pst_d2 = 2.8;	// Self-tap screw hole
j6pst_len = 3.0;		// eye-bar length

module j6post(dx,dy,theta)
{
	translate([dx,dy,0])
		rotate([0,0,theta])
			eye_bar(j6pst_d1, j6pst_d2,j6pst_len,j6_ht);
}

j6psts_ofy = j6_wid/2 + j6_wall + j6pst_d1/2 - 1;

module j6posts()
{
ofx = 0;

	j6post(ofx,-j6psts_ofy, 90);
	j6post(ofx, j6psts_ofy,-90);
}

/* Bottom plate with cutout for nub under jack and wires */
j6flr_b_wid = 30;		// Floor base width
j6flr_b_len = 26;		// Floor base length
j6flr_b_thx = 4;		// Florr base thickness
j6flr_h_wid = 8.8  + 0.6;	// Floor hole width
j6flr_h_len = 10.3 + 0.6;	// Floor hole length
j6flr_w_len	= 10;		// Floor wire length
j6flr_w_wid = 7.1;	// Floor wire width

module j6floor()
{
ofx  = j6flr_b_len/2 - j6_len/2;
ofx1 = j6_len/2 - j6flr_h_len/2;
ofx2 = j6_len/2 + j6flr_w_len/2;
ofx3 = ofx2 + 10;
thx3 = 1.5;	// Thickness of bridge gap

//	translate([-ofx,0,0])
	{
		difference()
		{
			translate([-ofx,0,-j6flr_b_thx/2])		
				cube([j6flr_b_len,j6flr_b_wid,j6flr_b_thx],center=true);

			union()
			{
				// Large cutout underjack
				translate([-ofx1,0,0])
					cube([j6flr_h_len,j6flr_h_wid,50],center=true);

				// Smaller cutout for wires
				translate([-ofx2,0,0])
					cube([j6flr_w_len,j6flr_w_wid,50],center=true);

				// Bridge with wires under floor
				translate([-ofx2-50/2,0,-50/2-j6flr_b_thx+thx3])
					cube([50,j6flr_w_wid,50],center= true);

				// Bring cap mount holes through to bottom
				translate([0,j6psts_ofy,0])
					cylinder(d=j6pst_d2,h=50,center=true);

				translate([0,-j6psts_ofy,0])
					cylinder(d=j6pst_d2,h=50,center=true);			
			}
		}
	}
}

/* Cap plate */
j6cap_thx = 3;		// Cap thickness
j6cap_d2 = 3.5;	// Screw shank diameter


module j6cap_ear(dx,dy,theta)
{
	translate([dx,dy,0])
		rotate([0,0,theta])
			eye_bar(j6pst_d1,j6cap_d2,j6pst_len,j6cap_thx);
}

module j6cap_ears()
{
ofx = 0;

	j6cap_ear(ofx,-j6psts_ofy, 90);
	j6cap_ear(ofx, j6psts_ofy,-90);
}

module j6cap()
{
len = j6_len + j6_wall;
wid = j6_wid + 2*j6_wall;
ofx = len/2 + j6_wall/2;

 translate([0,0,0])
 {
	difference()
	{
		union()
		{
			 translate([-ofx,-wid/2,0])
				cube([len,wid,j6cap_thx],center=false);

			j6cap_ears();
		}

		union()
		{
		}
	}
 }
}

module total()
{
	j6sidewall();
	j6floor();
	j6posts();
}
translate([0,0,j6flr_b_thx])
	total();

translate([30,0,0])
	j6cap();

// Position cap over jack mount for visual check
//translate([0,0,j6_ht + j6flr_b_thx + 1]) j6cap();

