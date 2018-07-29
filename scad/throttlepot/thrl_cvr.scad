/* File: thrl_cvr.scad
 * Cover for throttle pot enclosure
 * Author: deh
 * Latest edit: 20180719
 */

include <thrtlpot.scad>


 $fn=25;

/*
cs_len = 130;     // Inside length (x) of case
cs_wid = 35;    // Inside width (y) of case
cs_rad = 5;     // Rounded corner radius
cs_dep = 40;    // Inside depth 
cs_thx = 3;     // Wall thickness
*/

cv_thx = 2;		// Overall side wall thicknesses
cv_tpx = 3.2;		// Top thickness
cv_len = 2*cs_thx + cs_len + cv_thx*2; // Overall length (x)
cv_wid = 2*cs_thx + cs_wid + cv_thx*2; // Overall length (y)
cv_dep = 5 + cv_tpx;

module cover()
{
    tt = 2*cv_thx;
    
    difference()
    {
        union()
        {   // Main solid block
            rounded_rectangle(cv_len,cv_wid,cv_dep,cs_rad);
        }
        union()
        {	// Carve out the inside
            translate([0,0,cv_tpx]) // Cutout center of block
                rounded_rectangle(cv_len-tt,cv_wid-tt,cv_dep,cs_rad);

			// Window in top (which is bottom as printed)
			ll5 = cs_len - 10;
			ww5 = cs_wid - 10;
			hull()
			{
               rounded_rectangle(ll5, ww5,.01,cs_rad);

				tx = cv_tpx+.1;
				translate([0,0,tx+.1])
              rounded_rectangle(ll5-tx, ww5-tx,.01,cs_rad);						
			}
        }
    }
}

module corner_post(dia_p,screw_d,screw_z,ht)
{
	rad = dia_p/2;

screwhd_d1 = 5.5; // Flat head screw diameter at top
screwhd_d2 = 3.5; // Flat head screw diameter at shank
screwhd_h1 = 3;   // Height between d1 and d2 above

 translate([-rad-.05,-rad,0])
 {
	difference()
	{
		union()
		{
			translate([dia_p/2,dia_p/2,0])
			cylinder(d=dia_p,h=ht,center=false);

//			cube([dia_p,dia_p,ht],center=false);
			
//			translate([0,0,0]) rotate([0,0,-90])
//				fillet(rad,ht);

//			translate([dia_p,dia_p,0]) rotate([0,0,-90])
//				fillet(rad,ht);
		}
		union()
		{
	// Screw hole, body
			translate([rad,rad,0])
				cylinder(d=screw_d,h=screw_z,center=false);

			// Screw hole: cone for flat head
			translate([rad,rad,0])
				cylinder(d1=screwhd_d1,d2=screwhd_d2,h=screwhd_h1,center=false);

			// Round inside corner of the above cube
//			translate([dia_p-.05,-.05,0]) rotate([0,0,90])
//				fillet(rad,ht);


		}
	}
 }
}
module corner_post1(cx,cy,theta)
{
	translate([cx,cy,0])
	rotate([0,0,theta])
		corner_post(6,3.4,12,.1);
}
module corner_posth(a)
{
dia_p = 6;
rad = dia_p/2;
screwhd_d1 = 5.5; // Flat head screw diameter at top
screwhd_d2 = 3.4; // Flat head screw diameter at shank
screwhd_h1 = 3;   // Height between d1 and d2 above

  translate(a)
  {
 	translate([-rad-.05,-rad,0])
 	{
			translate([rad,rad,0])
				cylinder(d=screwhd_d2,h=50,center=false);

			// Screw hole: cone for flat head
			translate([rad,rad,0])
				cylinder(d1=screwhd_d1,d2=screwhd_d2,h=screwhd_h1,center=false);
	}
  }	
}
module corner_posts()
{
	vx = cs_len/2 - 0;
	vy = cs_wid/2 - 0;

	corner_post1( vx, vy,-90);
	corner_post1( vx,-vy,180);
	corner_post1(-vx, vy,  0);
	corner_post1(-vx,-vy, 90);
}
module corner_post_holes()
{
	vx = cs_len/2 - 0;
	vy = cs_wid/2 - 0;

	corner_posth([ vx, vy, 0]);
	corner_posth([ vx,-vy, 0]);
	corner_posth([-vx, vy, 0]);
	corner_posth([-vx,-vy, 0]);
}

module cv_total()
{
	difference()
	{
		union()
		{
			cover();
			corner_posts();
		}
		union()
		{
			corner_post_holes();
			cable_cutout(-cc_ofy,cv_tpx+4);   // Telephone type cable cutout
		}
	}
}
translate([0,75,0]) cv_total();
//translate([0,0,cs_dep+cs_thx+cv_tpx+8]) rotate([180,0,0]) cv_total();total();
