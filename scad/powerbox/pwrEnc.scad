/* File: pwrEnc.scad
 * Power unit: Enclosure, bottom 
 * Author: deh
 * Latest edit: 20180607
 * 
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/deh_shapes2.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>



/* Selections for mag mount */
// 16mm with M4 stud
magx_thick = mag16_M4_thick;
magx_stud_dia = mag16_M4_stud_dia;
magx_stud_len = mag16_M4_stud_len;
magx_nut_thick = mag16_M4_nut_thick;
magx_nut_hex_peak = mag16_M4_nut_hex_peak;
magx_washer_dia = mag16_M4_nut_hex_peak;
magx_washer_thick = mag16_M4_washer_thick;

ss_dia1 = magx_stud_dia + 0.5;
ss_nut_dia = magx_nut_hex_peak + 0.6;
mm_ht12 = 2;	// Amount material below washer

 $fn=20;

cs_len = 120;   // Inside length (x) of case
cs_wid = 80;    // Inside width (y) of case
cs_rad = 5;     // Rounded corner radius
cs_dep = 17;    // Inside depth 
cs_thx = 3;     // Wall thickness

// **** Id the part ***
module id(dx,dy,theta)
{
  font = "Liberation Sans:style=Bold Italic";
	translate([dx,dy,cs_thx])
	{
	  rotate([0,0,theta])
	  {
		  linear_extrude(1.0)
	   	text("powwerbox 2018 06 07 V1",size = 3.5);
		}
  	}
}

/* Main enclosure */
module case()
{
    tt = 2*cs_thx;
    
    difference()
    {
        union()
        {   // Main solid block
            rounded_rectangle(cs_len+tt,cs_wid+tt,cs_dep+tt/2,cs_rad);
        }
        union()
        {	// Carve out the inside
            translate([0,0,cs_thx]) // Cutout center of block
                rounded_rectangle(cs_len,cs_wid,cs_dep,cs_rad);
        }
    }
}

/* Case mounting tab */
tb_od  = 18;   // outside diameter of rounded end, and width of bar
tb_hd  = 3.4;	// diameter of hole in end of bar
tb_len = 13;	// length of bar
tb_thx = 3;		// thickness/height of bar
tb_fr  = 5;		// Radius of tab fillet

module cstab(tx,ty, theta)
{
/* ***** eyebar *****
 * rounded bar with hole in rounded end
 * module eye_bar(d1, d2, len, ht)
d1 = outside diameter of rounded end, and width of bar
d2 = diameter of hole in end of bar
*/
	translate([tx,ty])
		rotate([0,0,theta])
		union()
		{
			// Tab
			eye_bar(tb_od, tb_hd, tb_len, tb_thx);

			// Fillet at base of tab
			ofx = tb_len - tb_fr/2;
			translate([ofx,-tb_od/2,tb_thx-.1])
				rotate([0,0,180])
				rotate([90,0,0])
				fillet(tb_fr,tb_od);
      }
}

module cstabs()
{
	csx = cs_len/2 + cs_thx +tb_len;
	csx1= cs_len/2 - cs_thx*2;
	csy = cs_wid/2 + cs_thx +tb_len - 0.5;
	ofy = 10;

//	cstab(-csx, ofy,  0);	// End tab
//	cstab( csx, ofy,180);	// End tab
	cstab(-csx1, csy,-90);	// Top right tab
	cstab( csx1, csy,-90);	// Top left tab
	cstab(    0,-csy, 90);	// Bottom center tab
}

module corner_post(dia_p,screw_d,screw_z,ht)
{
	rad = dia_p/2;

 translate([-rad-.05,-rad,0])
 {
	difference()
	{
		union()
		{
			cube([dia_p,dia_p,ht],center=false);
			
			translate([0,0,0]) rotate([0,0,-90])
				fillet(rad,ht);

			translate([dia_p,dia_p,0]) rotate([0,0,-90])
				fillet(rad,ht);
		}
		union()
		{	// Screw hole
			translate([rad,rad,ht-screw_z])
				cylinder(d=screw_d,h=screw_z,center=false);

			// Round corner of the above cube
			translate([dia_p-.05,-.05,0]) rotate([0,0,90])
				fillet(rad,ht);
		}
	}
 }
}
module corner_post1(cx,cy,theta)
{
	translate([cx,cy,0])
	rotate([0,0,theta])
		corner_post(6,2.8,12,cs_dep+cs_thx);
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


/* Cutout for telephone type cable */
cc_ofz = cs_dep + 2;
cc_ofy = 5;
cc_ofx = cs_len/2;
module cable_cutout1()
{
	cable_cutout([cc_ofx,cc_ofy,cc_ofz]);
}
module cable_cutout2()
{
	cable_cutout([-cc_ofx-8,cc_ofy,cc_ofz]);
}
module cable_cutout(a)
{
	translate(a) // Cutout center of block
		rotate([0,90,0])
		rounded_rectangle(5,5,20,2);
}

/* Total enclosure */
module total ()
{   
	difference()
	{
		union()
		{ 
            case();			// Overall case
				corner_posts();// Fancy corner posts
				cstabs();		// Case mounting tabs
				id(-cs_len/2,-20, 90);
		}
		union()
		{
			cable_cutout1();   // Telephone type cable cutout
			cable_cutout2();   // Telephone type cable cutout
		}
	}
}

/* Uncomment the following to render */
total(); // Enclosure


