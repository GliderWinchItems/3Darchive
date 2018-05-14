/* File: plno_se.scad
 * Frame for mounting sensor board on Plano box
 * Author: deh
 * Latest edit: 20180512
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=30;

big = 10;	// Big z in direction 

hs_len = 25.5;    // X direction board hole distance
hs_wid = 38;   // Y direction board hole distance
hs_post_d = 6.5; // Board post diameter
hs_ht = 4;      // Post height


hs_d1 = 2.9;    // Hole diameter for self-tap screw

module post(ofx,ofy)
{
    translate([ofx,ofy,0])
    {
        difference()
        {
            cylinder(d=hs_post_d,h=hs_ht,center=false);
            cylinder(d=hs_d1,h=hs_ht,center=false);
        }
    }
}

module posthole(ofx,ofy)
{
    translate([ofx,ofy,0])
       cylinder(d=hs_d1,h=hs_ht,center=false);
}

module posts()
{
    post(     0,      0);
    post(     0,hs_wid);
    post(hs_len,      0);
    post(hs_len,hs_wid);
    
}

ppofs_y = 11;	// Offset of Plano post
ppy = hs_wid + ppofs_y;

module pposts()
{
    post(     0,     ppy);
    post(hs_len,     ppy);
    post(hs_len,    -ppofs_y);
    post(     0,    -ppofs_y);
}

wb_thx = 3.0;   // Web thickness
wb_ht = 2;      // Web height

/* ofx, ofy specify center of bar */

module web(len,ofx,ofy,theta)
{
    lenx = len - 2*hs_d1;
    rfy = ofy * sin(theta);
    rfx = ofx * cos(theta);
    translate([ofx,ofy,0])
        rotate([0,0,theta])
            translate([-lenx/2,-wb_thx/2,0])
                cube([lenx,wb_thx,wb_ht], center=false);
}

module webplate()
{
	kx = hs_len + hs_post_d;
	ky = hs_wid + hs_post_d + ppofs_y*2;
	translate([-hs_post_d/2,-ppofs_y-hs_post_d/2,0])
		cube([kx,ky,1.5],center = false);


}

module webs()
{
    
    web(hs_len, hs_len/2,        0, 0);
    web(hs_len, hs_len/2,   hs_wid, 0);
    web(hs_wid,        0, hs_wid/2,90);    
    web(hs_wid,   hs_len, hs_wid/2,90);
	
	wbdia = sqrt(hs_len*hs_len + hs_wid*hs_wid);
	theta1 = atan(hs_wid/hs_len);
	 web(wbdia, hs_len/2, hs_wid/2, theta1);
}

module pwebs()
{
    web(ppofs_y,       0, hs_wid+ppofs_y/2,90);
    web(ppofs_y,       0,       -ppofs_y/2,90);

    web(ppofs_y, hs_len, hs_wid+ppofs_y/2,90);
    web(ppofs_y, hs_len,       -ppofs_y/2,90);

    web(hs_len, hs_len/2, hs_wid+ppofs_y, 0);
    web(hs_len, hs_len/2,       -ppofs_y, 0);

	ppdiag = sqrt(ppofs_y*ppofs_y + hs_len*hs_len);
	theta2 = atan(ppofs_y/hs_len);
	 web(ppdiag, hs_len/2, hs_wid+ppofs_y/2, theta2);
	 web(ppdiag, hs_len/2,       -ppofs_y/2, theta2);

}

module postholes()
{
    posthole(     0,      0);
    posthole(     0,hs_wid);
    posthole(hs_len,      0);
    posthole(hs_len,hs_wid);

    posthole(     0,     ppy);
    posthole(hs_len,     ppy);
    posthole(hs_len,    -ppofs_y);
    posthole(     0,    -ppofs_y);

}


module total()
{
	difference()
	{ 
		union()
		{
			posts();
		   pposts();
    		webs();
	 		pwebs();
	 		webplate();
		}
		union()
		{
			postholes();
		}
	}
}
total();
