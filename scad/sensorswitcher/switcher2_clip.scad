/* File: switcher2_clip.scad
 * Clip for sensor board to hold dc-dc switcher module, flat mount

 * Author: deh
 * Latest edit: 20180509
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=100;

big = 10;	// Big z in direction 

fp_len = 41;	// switcher brd length
fp_wid = 20.2; // switcher brd width
fp_thx = 2;		// thickness of flat plate

fp_cr_sq = 3;	// Corner cutout square
fp_h1_y = 5.5;	// Mounting hole #1 y
fp_h1_x = 2.5;	// Mounting hole #1 x
fp_h_d  = 2.8;	// Self-tap screw hole dia
fp_h2_x = 35;	// Mounting hole #2 x
fp_h2_y = 17;	// Mounting hole #2 y

fp_ofs_z = 7-2.5;	// height flat plate raised

/* Corner counts for solder pads */
module corner(ofx,ofy,ofz)
{
	translate([ofx,ofy,ofz-.01])
		cube([fp_cr_sq,fp_cr_sq,big]);
}

/* Cutouts for solder bumps on bottom of switcher brd */
module cutout(ofx,ofy,len,wid)
{
	translate([ofx,ofy,-.01])
		cube([len,wid,fp_thx+.02],center=false);
}

/* Flat plate for switcher to mount upon */
module flat(ofs_z)
{
	translate([0,0,ofs_z])
	{
		difference()
		{
			cube([fp_len,fp_wid,fp_thx],center=false);

			union()
			{
				/* Corner cuts for wire/solderpads */
				corner(0,0,0);
				corner(fp_len - fp_cr_sq,0);
				corner(0,fp_wid - fp_cr_sq,0);
				corner(fp_len - fp_cr_sq,fp_wid - fp_cr_sq,0);

				/* Switcher mounting self-tap screw holes */
				translate([fp_h1_x,fp_h1_y,0])
					cylinder(d=fp_h_d,h=big,center=false);

				translate([fp_h2_x,fp_h2_y,0])
					cylinder(d=fp_h_d,h=big,center=false);

				/* Cutouts for solder bumps on bottom of switcher */
				cutout(2,9,3,7);
				cutout(12,1,9,4);
				cutout(35,5,3,8);

				/* cutout for brd xtal */
				cutout(11,2,11,5);
			}
		}
	}
}

bh_wid = 9;
bh_len = 10;
bh_h1_x = 7;
bh_h1_y = 6.5;
bh_h1_d = 2.8;
bh_h1_ht = 7;

/* Big Hole Post */
module bhpost(ofs_z)
{
	difference()
	{
		cube([bh_len,bh_wid,ofs_z],center=false);
		union()
		{


			corner(0,0,4);	// Cutout below sw brd pad

			translate([bh_h1_x,bh_h1_y,-0.01])
			cylinder(d= bh_h1_d,h = bh_h1_ht, center=false);
		}
	}
}

sp_len = 8;
sp_wid = 10;
sp_h1_x = 4;
sp_h1_y = 6;
sp_h1_d1 = 6.0;
sp_h1_d2 = 3.4;
sp_h1_z1 = 2.6;
sp_trans = 30 - sp_h1_x;


/* Small Hole Post */
module spost(ofs_x, ofs_z)
{
  translate([ofs_x,0,0])
  {
	difference()
	{
		cube([sp_len,sp_wid,fp_ofs_z+.01],center=false);
		
		union()
		{
		}
	}
  }
}
module plug()
{
    d_in = 8.6;
    difference()
    {
        union()
        {
            cylinder(d= d_in, h = 1.5, center= false);
            cylinder(d=d_in+2,h = 1, center= false);
        }
        union()
        {
            cylinder(d=3.4, h = big,center=false);
        }
    }
}

module total()
{
    difference()
    {
        union()
        {
				flat(fp_ofs_z);
				bhpost(fp_ofs_z);
				spost(sp_trans,fp_ofs_z);
        }
        union()
        {
			translate([sp_h1_x+sp_trans,sp_h1_y,sp_h1_z1])
				cylinder(d = sp_h1_d1,h = big, center=false);

			translate([sp_h1_x+sp_trans,sp_h1_y,-.01])
				cylinder(d = sp_h1_d2,h = big, center=false);
            
            translate([fp_h1_x,fp_h1_y,1.5]) // sw screw hole
				cylinder(d=fp_h_d,h=big,center=false);
        }


   }
}
total();

//   translate([-10,0,0])
//        plug();

	
