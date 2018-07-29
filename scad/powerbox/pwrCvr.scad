/* File: pwrCvr.scad
 * Power unit: Cover
 * Author: deh
 * Latest edit: 20180718
 * 
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/deh_shapes2.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

include <pwrEnc.scad>
include <pwrBotplt.scad>

cvr_thx = 1.5;   // Cover wall thickness
cvr_del = 2*cs_thx + 0.3; // Fits over base unit
cvr_len = cs_len + cvr_del; // Inside length
cvr_wid = cs_wid + cvr_del; // Inside width
cvr_rad = cs_rad + cs_thx;  // Radius of inside corner
cvr_ht  = 80;  // Inside ht to bottom of base it mounts on
cvr_ovr = 4;        // Overlap of sides over base unit
cvr_exp = 3;        // Height of thin sides to overlap lip
cvr_ht1 = cvr_ht - cvr_ovr;
cvr_lipthx = 1.25;     // Thickness of overlap 
cvr_screw_depth = 3;// Screw shank depth in cover

/* Previously defined in pwrEnc.scad
cs_extend = 30-6; 
cs_len = 110+cs_extend;   // Inside length (x) of case
cs_wid = 80;    // Inside width (y) of case
cs_rad = 5;     // Rounded corner radius
cs_dep = 13;    // Inside depth 
cs_thx = 3;     // Wall thickness
*/

$fn = 50;

// **** Id the part ***
module id(dx,dy,theta)
{
  font = "Liberation Sans:style=Bold Italic";
	translate([dx,dy,cvr_thx])
	{
	  rotate([0,0,theta])
	  {
		  linear_extrude(1.0)
	   	text("2018 07 18 V1",size = 3.5);
		}
  	}
}

module cvr_base()
{
/* Note: deh_shapes rounded rectangle is "rad" longer and wider than len and wid */
    tt = 2*cs_thx;
    ll = cs_len + tt;      // Outside length
    ww = cs_wid + tt;      // Outside width
	 hh = cvr_ht1 + cvr_thx; // Outside height
    rr = cs_rad; // Outside corner radius

    ll2 = cs_len;
    ww2 = cs_wid;
    zz2 = cvr_thx;

	ll3a = ll + cs_rad;
	ww3a = ww + cs_rad;
   ll3b = ll3a + cvr_thx*2;
	ww3b = ww3a + cvr_thx*2;
   hh3 = hh;

	ll4 = ll3b - cs_rad;
	ww4 = ww3b - cs_rad;
	zz4 = cvr_ovr;
   ofz4 = hh3 + cvr_exp;

   ll5 = cs_len - 20;
	ww5 = cs_wid - 20;

	ll6 = ll3b - cvr_lipthx - cs_rad;
	ww6 = ww3b - cvr_lipthx - cs_rad;
	ofz6 = ofz4;
    
    difference()
    {
        union()
        {   // Bottom to expansion level
				rounded_rectangle(ll,ww,hh3,rr);

				// Expansion of length and width
            translate([0,0,hh3-0.01])
            {

   				hull()
				   {
  					   linear_extrude(height=.01) 
						   rounded_rectangle_2D(ll3a,ww3a,rr);

  					   translate([0,0,cvr_exp]) 
						   linear_extrude(height=.01)	
							rounded_rectangle_2D(ll3b,ww3b,rr);
               }
				}

				// Outside overlap lip

            translate([0,0,ofz4]) // Cutout center of block
                rounded_rectangle(ll4, ww4,zz4,rr);
        }
        union()
        {	// Carve out the inside
 
            translate([0,0,zz2]) // Cutout center of block
                rounded_rectangle(ll2, ww2,200,rr);

				// Window in top (which is bottom as printed)
				hull()
				{
                rounded_rectangle(ll5, ww5,.01,rr);

					tx = cvr_thx+.1;
					translate([0,0,tx+.1])
                rounded_rectangle(ll5-tx, ww5-tx,.01,rr);						
				}

				// Overlap lip
				translate([0,0,ofz6])
                rounded_rectangle(ll6, ww6,200,rr);		

        }
    }
}
module rounded_rectangle_2D(len,wid,rad)
{
lx = len - 2*rad;
ly = wid - 2*rad;

// hull()
 {
   union()
   {
		square([lx,ly],center=true);
      translate([-lx/2,-ly/2]) circle(r=rad);
      translate([-lx/2, ly/2]) circle(r=rad);
      translate([ lx/2,-ly/2]) circle(r=rad);
      translate([ lx/2, ly/2]) circle(r=rad);
	}
 }
}
module corner_post2(a,theta)
{
	hh = cvr_ht1 + cvr_exp + cvr_thx ;
	
//corner_post(dia_p,screw_d,screw_z,ht);
	translate(a)
	rotate([0,0,theta])
		corner_post(6, 3.2, 100, hh);
}
module cvr_corner_posts()
{
	vx = cs_len/2 - 0;
	vy = cs_wid/2 - 0;

	corner_post2([ vx, vy, 0],-90);
	corner_post2([ vx,-vy, 0],180);
	corner_post2([-vx, vy, 0],  0);
	corner_post2([-vx,-vy, 0], 90);

}
cvr_screwhead_d = 5.5;	// Cover srew head diameter
module cvr_corner_posts_holes()
{
	vx = cs_len/2 - 0;
	vy = cs_wid/2 - 0;
	vh = cvr_ht1 - cvr_screw_depth;
	dd = cvr_screwhead_d;
	
	translate([ vx, vy, 0]) cylinder(d=dd, h=vh, center=false);
	translate([ vx,-vy, 0]) cylinder(d=dd, h=vh, center=false);
	translate([-vx, vy, 0]) cylinder(d=dd, h=vh, center=false);
	translate([-vx,-vy, 0]) cylinder(d=dd, h=vh, center=false);
}
cczz = cvr_ht - 10;	// Cable cutout adjust for height of sides

module total_cvr()
{
    difference()
	{
		union()
		{ 
			cvr_base();
			cvr_corner_posts();
			id(-15,-40, 0);

		}
		union()
		{
			cvr_corner_posts_holes();
			power_cable_cutout(cvr_exp+cczz);
			cable_cutout([cc_ofx,cc_ofy ,cc_ofz-0.5+cczz]);
			cable_cutout([cc_ofx,cc_ofy2,cc_ofz-0.5+cczz]);
		}
	}
}

translate([0,0,0])total_cvr(); // Cover
//translate([0,0,50]) rotate([180,0,0])total_cvr(); // Cover over base
//total(); // Main bottom parts for reference

