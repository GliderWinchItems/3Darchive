/* File: thrlpot.scad
 * Enclosure for throttle potentiometer
 * Author: deh
 * Latest edit: 20180514
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=50;

cs_len = 130;     // Inside length (x) of case
cs_wid = 40;    // Inside width (y) of case
cs_rad = 5;     // Rounded corner radius
cs_dep = 35;    // Inside depth 
cs_thx = 3;     // Wall thickness

ptpost_wid = 15;    // Pot bar post width (y)
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

/* Both pot mount posts at each end */
px = -cs_len/2 - cs_rad/2 + ptpost_len/2;
py = cs_wid/2 - ptpost_bar_y;

module ptposts()
{
    ptpost( px, py, cs_thx);
    ptpost(-ptpost_len/2, py, cs_thx);
}

/* Bar to hold potentiometer */

br_len = cs_len + cs_rad;
br_thx = 3; // Pot mounting bar thickness
br_pot_d = 7.0; // Pot hole diameter
br_hx = -cs_len/2 + 25; // Locate pot hole on bar
br_tab_ofx = 7.5;	// Indexing tab offset from center of shaft
br_tab_x = 2.0;	// Indexing tab x
br_tab_y = 2.5;	// Indexing tab y

// Rectangular cutouts for pot anti-rotate tab
module potindex(rot)
{
	rotate([0,0,rot])
       translate([br_tab_ofx,0,0])
			cube([br_tab_x,br_tab_y,20],center=true);
}

module potbar()
{
    difference()
    {
        translate([-br_len/2,-py/2,br_thx/2]) // Pot mounting bar
            cube([br_len/2,py,br_thx],center=false);
        
        union()
        {
            // Holes in bar at both ends to mount bar on enclosure
				brx = br_len/2 - ptpost_len/2;
            translate([-brx,0,0])
                cylinder(d1=ptpost_screw_d1,d2=ptpost_screw_d2,h=ptpost_screw_z,center=false);

            translate([-ptpost_len/2,0,0])
                cylinder(d1=ptpost_screw_d1,d2=ptpost_screw_d2,h=ptpost_screw_z,center=false);
            
            // Pot mounting on bar
            translate([br_hx,0,0])
				{
                cylinder(d=br_pot_d, h=20, center=false); // Main shaft

					 potindex(  0); // Anti-rotate tab cutouts
					 potindex( 90);
					 potindex(-90);
					 potindex(180);
				}
        }
    }  
}

/* Mounting holes in side for Bowden tube */
bw_z = 20;	// Height from enclosure floor
bw_y = 10;	// Width offset (y) from centerline
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
sg_h1 = 16;		// Post Height bottom portion
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
				cover_posts(); // Cover posts
		}
		union()
		{
			bowden(); // Holes for Bowden fitting
		}
	}
}
/* Enclosure */
total();

/* Potentiometer bar */
translate([0,100,-cs_thx/2])
  potbar();

/* Bowden tube fixture */
translate([0,60,0])
	bowden_fitting();
