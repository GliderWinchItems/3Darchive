/* File: thrlpot.scad
 * Enclosure for throttle potentiometer
 * Author: deh
 * Latest edit: 20180514
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>
include <mod4pjack.scad>

 $fn=50;

cs_len = 130;     // Inside length (x) of case
cs_wid = 35;    // Inside width (y) of case
cs_rad = 5;     // Rounded corner radius
cs_dep = 40;    // Inside depth 
cs_thx = 3;     // Wall thickness

ptpost_wid = 18;    // Pot bar post width (y)
ptpost_len = 8;      // Pot bar post length (x)
ptpost_ht  = 11;     // Pot bar post height (z)
ptpost_screw_d1 = 3.1;     // Pot bar post screw hole diameter
ptpost_screw_d2 = 2.7;     // Pot bar post screw hole diameter
ptpost_screw_z = 6; // Pot post bar screw hole depth
ptpost_bar_y = 12;  // Pot post bar center line from top inside wall


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

/* Cover mounting posts */

cv_d = 6;	// Diameter of post
cv_h = cs_dep - 2;	// Height of post
cv_screw_d = 2.8;
cv_screw_h = 20;

module cover_post(cx,cy)
{
	translate([cx,cy,0])
	{
		difference()
		{
			cylinder(d=cv_d,h=cs_dep,center=false);

            cvz = (cv_h - cv_screw_h + 2);
			translate([0,0,cvz])
				cylinder(d=cv_screw_d,h=cv_screw_h, center=false);
		}
	}	
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

module cover_posts()
{
	cx = cs_len/2 - 1;
	cy = cs_wid/2 - 1;

	cover_post( cx, cy);
	cover_post( cx,-cy);
	cover_post(-cx, cy);
	cover_post(-cx,-cy);
}
    
/* Post to mount pot bar with screw hole */
module ptpost(dx, dy, dz)
{
    translate([(dx-ptpost_len/2), (dy-ptpost_wid/2), dz])
    {
        difference()
        {
				// Post
            cube([ptpost_len,ptpost_wid,ptpost_ht],center=false);
            
				// Self-tap screw hole in post
            translate([ptpost_len/2,ptpost_wid/2,ptpost_ht-ptpost_screw_z])
                cylinder(d1=ptpost_screw_d1,d2=ptpost_screw_d2,h=ptpost_screw_z,center=false);
        }   
    }   
}

/* Both pot mount posts */
py = 4;    //cs_wid/2 - ptpost_bar_y;
br_plen2 = 40;	// Position of middle mounting post hole
px2 = -cs_len/2 -cs_rad/2 + br_plen2;
px1 = -cs_len/2 -cs_rad/2 + ptpost_len/2;

module ptposts()
{
    ptpost( px1, py, cs_thx);
    ptpost( px2, py, cs_thx);
}

/* Bar to hold potentiometer */

br_len = 70;	// Overall length of pot mounting bar
br_thx = 3; // Pot mounting bar thickness
br_pot_d = 7.0;   // Pot hole diameter
br_hx = 22;       // Locate pot hole on bar
br_tab_ofx = 7.5;	// Indexing tab offset from center of shaft
br_tab_x = 2.0;	// Indexing rectangular tab hole x
br_tab_y = 2.5;	// Indexing rectangular tab hole y

// Rectangular cutouts for pot anti-rotate tab
module potindex(rot) // 'rot' rotation angle for tab
{
	rotate([0,0,rot])
       translate([br_tab_ofx,0,0])
			cube([br_tab_x,br_tab_y,20],center=true);
}

module potbar()
{
    difference()
    {
        translate([0,-ptpost_wid/2,br_thx/2]) // Pot mounting bar
            cube([br_len,ptpost_wid,br_thx],center=false);
        
        union()
        {
            // Holes in bar at both ends to mount bar on enclosure
				brx = ptpost_len/2;
            translate([brx,0,0])
                cylinder(d1=ptpost_screw_d1,d2=ptpost_screw_d2,h=ptpost_screw_z,center=false);

            translate([br_plen2,0,0])
                cylinder(d1=ptpost_screw_d1,d2=ptpost_screw_d2,h=ptpost_screw_z,center=false);
            
            // Pot mounting on bar
            translate([br_hx,0,0])
				{
                cylinder(d=br_pot_d, h=20, center=false); // Main shaft

					 potindex(  0); // Anti-rotate tab cutouts for 4 positions
//					 potindex( 90);
//					 potindex(-90);
					 potindex(180);
				}
        }
    }  
}

/* Mounting holes in side for Bowden tube */
bw_z = 30;	// Height from enclosure floor
bw_y = 8;	// Width offset (y) from centerline
bw_d = 3;	// Dia of string hole
bw_c = 4;	// Mounting screw circle dia
bw_screw_d = 2.8;	// Mounting screw hole diameter
bw_base_d = 16;	// Base OD
bw_base_thx = 2;	// Base thickness

module bowden_pat(dia,angl)
{		rotate(angl)
 			translate([bw_c,0,0])
				cylinder(d=dia,h=9,center=false);
}
// Bowder base hole pattern
module bowden_mt_pat()
{
		// Center hole
		cylinder(d=bw_d,h=40,center=false);

		// Mounting holes
		bowden_pat(bw_screw_d,   0);
		bowden_pat(bw_screw_d, 120);
		bowden_pat(bw_screw_d,-120);
}
// Punch holes in side of enclosure for Bowden tube fixture
module bowden()
{
	translate([-cs_len/2-10,-bw_y,bw_z])
		rotate([0,90,0])
			bowden_mt_pat();
}

/* Bowden tube fitting screws to side of enclosure */
bt_od = (1/8) * 25.4;	// OD of tube
bt_id = (1/16) * 25.4;		// ID
bt_d = bt_od +10;
bt_ht1 = 20;
bt_ht2 = 2;
bt_st_d = 2.8; // Self-tap screw dia
bt_w_ht = 10;	// Height for lock screw
bt_ww = 6;		// Thickness of lock screw block

module bowden_fitting()
{
	difference()
	{
		union()
		{
			cylinder(d=bw_base_d,h=bw_base_thx,center=false);
         
   		cylinder(d=bt_d,h=bt_ht1,center=false);

			translate([0,0,bt_w_ht])
				cube([bt_d,bt_d,bt_ww],center=true);
		}
		union()
		{		// Center hole for tubing
            cylinder(d=bt_od,h=50,center=false);	
            
				// Chamfer for inserting tubing
            translate([0,0,bt_ht1-bt_ht2])
                cylinder(d1=bt_od,d2=bt_od+2,h=bt_ht2,center=false);
            
            // Mounting holes 
            bowden_pat(bt_st_d,   0);
            bowden_pat(bt_st_d, 120);
            bowden_pat(bt_st_d,-120);

				// Lock screw on each side.  Slightly penetrate center
				bt_z1 = bt_w_ht;
				bt_y1 = bt_id/2 + bt_st_d/2 - .4;

				translate([0, bt_y1, bt_z1])
					rotate([0,90,0])
						cylinder(d=bt_st_d,h=20,center=true);

				translate([0, -bt_y1, bt_z1])
					rotate([0,90,0])
						cylinder(d=bt_st_d,h=20,center=true);
		}
	}
}

/* Spring post: has indentation near top */
sg_ofx = cs_len/2 - .75;	// Offset from inside wall
sg_ofy = -10;		// Offset y direction
sg_d1  = 7;		// Post main diameter
sg_d2  = 3.3;		// Post indent dia
sg_d3  = 4.5;
sg_d4  = 3.0;
sg_h1 = 19;		// Post Height bottom portion
sg_h2 = 2;
sg_h3	= 2;

module spring_post()
{
	translate([sg_ofx,sg_ofy, cs_thx])
	{
		cylinder(d=sg_d1, h=sg_h1, center=false); // Bottom part

		translate([0,0,sg_h1])
			cylinder(d1=sg_d1, d2=sg_d2,h=sg_h2, center=false); // Indent inward
		
		translate([0,0,sg_h1+sg_h2])
			cylinder(d1=sg_d2, d2=sg_d3,h=sg_h2, center=false); // Ident outward
		
		translate([0,0,sg_h1+sg_h2*2])	// Top chamfer
			cylinder(d1=sg_d3, d2 = sg_d4, h=sg_h3, center=false);

	}
}
/* Cutout for telephone type cable */
cc_ofz = cs_dep + 2;
cc_ofy = 5;
cc_ofx = cs_len/2;

module cable_cutout()
{
	translate([cc_ofx,cc_ofy,cc_ofz]) // Cutout center of block
		rotate([0,90,0])
		rounded_rectangle(5,5,20,2);


}

/* Potentiometer bar with 4P4C jack mount */

module potbar_w_jack()
{
	translate([0,0,-cs_thx/2]) potbar(0);

	translate([br_len-11.5,0,br_thx]) 
	  rotate([0,0,180])
   	 jbase();	// This is brought in with include mod4jack.scad
}

/* Total enclosure */
module total ()
{   
	difference()
	{
		union()
		{ 
            case();			// Overall case
            ptposts();  	// Potentiometer mounting posts
				spring_post(); // Tension spring post
//				cover_posts(); // Cover posts
				corner_posts();// Fancy corner posts
				cstabs();		// Case mounting tabs
		}
		union()
		{
			bowden();         // Holes for Bowden fitting
			cable_cutout();   // Telephone type cable cutout
		}
	}

}
/* Uncomment the following to render */
/* Enclosure */
total();

translate([0,100,0]) potbar_w_jack();

//translate([-cs_len/2 - cs_rad/2 ,py,13]) potbar_w_jack(); // Overlay view


/* Bowden tube fixture */
//translate([0,60,0]) bowden_fitting();

