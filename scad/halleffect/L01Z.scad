/* File: L01Z.scad
 * Box for holding Tamura L01Z current sensor w cable
 * Author: deh
 * Latest edit: 20180708
 */

include <../library_deh/deh_shapes.scad>

 $fn=50;

he_len = 38;
he_wid = 27;
he_ht  = 12+6+4;
wn_len = 15;
wn_wid = 8;
wn_ofx = he_len - wn_len - 9;
wn_ofy = 9.5;
pn_wid = 4;
pn_len = 5;
pn_ofx = 38-14.5-12.8+3;

sh_wall = 2;  //  Shell wall thickness
sh_bot  = 2;  // Bottom thickness
sh_len  = he_len + 2*sh_wall; // Outside length
sh_wid  = he_wid + 2*sh_wall + pn_wid; // Outside width
sh_ht   = he_ht + sh_bot;     // Height including base

cb_ht  = 12+3; // 


module shell()
{
	difference()
	{
		union()
		{
 			// Main shell block
			cube([sh_len,sh_wid,sh_ht],center=false);
		}
		union()
		{
			// Tamura fits inside
			len1 = he_len + 2;
			wid1 = he_wid + 2;
         ht1  = 50;
         ofx1 = sh_wall -1;
         ofy1 = sh_wall - 1 + pn_wid;
         ofz1 = sh_bot + he_ht - 4;
			translate([ofx1,ofy1,sh_bot])
			   cube([len1,wid1,ht1],center=false);

			// Cable area
         len2 = len1;
         wid2 = pn_wid;
         ofx2 = ofx1;
			ofy2 = sh_wall;
         ofz2 = cb_ht;
			translate([ofx2,ofy2,ofz2])
			   cube([len2,wid2,ht1],center=false);

			// current wire window
			len3 = wn_len;
			wid3 = wn_wid;
         ht1  = 50;
         ofx3 = sh_wall + wn_ofx ;
         ofy3 = sh_wall + wn_ofy;
			translate([ofx3,ofy3, 0])
			   cube([len3,wid3,ht1],center=false);
		}
	}
}

shell();
