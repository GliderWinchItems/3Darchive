 /* File: Plano_frame_F4gateA.scad
 * Plano box with Discovery F4 gateway
*  A = Angled board for usb STLINK programming
 * Author: deh
 * Latest edit: 20180125
 * VA1 = Version Angled #1.
 * VA2 = Version Angled: move side posts lower; fixed length
 * VA3 = Minor tweaks: pcb wid & length, bot left post, overall len (scli3r scale 98.5)
 * vA4 = Top mags +4.5; switcher +0.5; (slic3r scale 99.0)
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>
include <../library_deh/Plano_base.scad>

include <F4g_capA.scad>

 $fn=100;

big = 10;	// Big z in direction 

/* From Plano_frame.scad--
dis_wid = 65.4;  // Overall width
dis_len = 95.8;  // Overall length
base_len = plano_len - 1.0;
base_wid = plano_wid;
*/
plano_len = 157-1;	// Inside length of Plano box
plano_wid_top = 83;	// Inside width at rim
plano_wid_bot = 81;	// Inside width near bottom before radius
plano_rad_bot = 6;	// Radius at bottom edges
plano_rad_end = 7;	// Radius (z axis) at inside corners
bflen = 97;		// Length of Discovery pcb
bfusb = 1.9;	// Amount jtag usb connector extends beyond board
bfthick = 5; 	// Base thickness

/* Mag stud mount */
magx_stud_dia     = screw_dia_s440 + .5;	// 
magx_nut_thick    = nut_thick_440  + .3;	// thickess
magx_nut_dia      = nut_dia_440    + .6;	// peak-peak
magx_washer_od    = washer_od_4    + .6;	// Washer diameter
magx_washer_thick = washer_thick_4 + .3;	// Washer thickness

screw_hole = screw_dia_sth620;

magxbottom_ofs_y = 9 - 1.5;	// Offset from bottom of tab
magxbottom_pstdia = 10;	// Eyebar (post) diameter
magxbottom_pstht = 6.3;	// Post height

frame_ofsy = 2;

scr_d1 = 3.1; 	// Self tap 4-40 screw OD at top
scr_d2 = 2.1;	// Self tap 4-40 screw OD at bottom
scr_ht = 8;	// Depth


corner_cut = 7;	// Rounded corner dia
side_cut = 4;	// Rounded inside bottom dia


// **** Id the part ***
module id()
{
 {
  font = "Liberation Sans:style=Bold Italic";
	yofs = 67;
 translate([38,yofs, bfthick]) 
  rotate([0,0,90])
  linear_extrude(1.0)
   text("Plano_F4gate",size = 3.0);

 translate([32,yofs, bfthick]) 
  rotate([0,0,90])
  linear_extrude(1.0)
   text("20180129  VA4",size = 3.0);
 }
}


hdr_od = 56;
hdr_ln = 65;	// Length of header
hdr_of = 32.5;	// Offset from bottom edge of pcb
hdr_ht = 1;		// Base thickness under header
hdr_wid = 7;	// Header width (including tolerances)
hdr_spc = 46;	// Spacing of headers (inside dimension)
side_ofs = -4.0;	// Offset of board recess and posts from y axis centerline
brd_ofs_y = 6;	// pcb offset in y direction from bottom

/* 2x25 50 pin header recess */
module hdr_50(xw)
{
echo (xw);
	translate([xw,hdr_of, hdr_ht])
		cube([hdr_wid,hdr_ln,10],center= false);
}
/* Both headers positioned */
hdr50off = hdr_spc/2;

module hdr_50s()
{
	hdr_50( (hdr_spc/2 - 1));
	hdr_50(-(hdr_spc/2 - 1)-hdr_wid);
}
/* 2 pin header recess */
hdr_ln2p = 6.2+23;	// Length of 2 pin header
hdr_of2p = 1.9+2;	// Offset from bottom edge of pcb
hdr_wid2p = 9;

module hdr_2(xw)
{
	translate([xw, hdr_of2p, hdr_ht])
		cube([hdr_wid2p,hdr_ln2p,10],center= false);
}
/* Both 2 pin headers positioned */
module hdr_2s()
{
	hdr_2( (hdr_spc/2 - 2));
	hdr_2(-(hdr_spc/2 - 2)-hdr_wid2p);
}

endrim = 6;
botofs = 1;
ctr_wid = hdr_spc - 6;

module base_cutouts()
{
	// Center 
	rad = 3;
	translate([0, bflen/2 + endrim-rad, -.1])
		rounded_rectangle(ctr_wid-2*rad,bflen-(endrim*2)-2*rad,big,rad);

	// 2x25 (50) Header pins
		hdr_50s();

	// 2 pin header
		hdr_2s();
}
pst_ldg = 6 + bfthick;	// Height of pc board ledge from bottom
pst_wid = 3;	// Width of post
pcb_thick = 2.0;	// Thickness of pcb
clip_ht = 3;
pst_w2 = 1;	// Width where pcb contacts edge



/* FTDI unit goes between pcb and case wall */
ftd_base_len = 35;	// Lenth of base part
ftd_post_len = 15;	// Length of tall part
ftd_slot_base = bfthick;// Offset from bottom of case
ftd_slot_wid = 2;		// Width of pcb

ftd_slot_wid2 = 3.0;	// Width at ahead of IC
ftd_slot_wid3 = 3.9;	// Width at IC
ftd_in_wid = 2.0;	// Inner wall width
ftd_tot_wid = ftd_slot_wid2+ftd_in_wid+1.5;	// Width total
ftd_tot_len = 20;
ftd_ic_len = 12;	// IC length
ftd_tot_ht = 18.6;
ftd_ofs_x = plano_wid_bot/2 - ftd_tot_wid;

module ftdi_post(xofs,yofs)
{
echo(ftd_tot_wid,"ftd_tot_wid");
	translate([xofs,yofs,bfthick])
	{
		difference()
		{
			union()
			{
				translate([0,0,0])
					cube([ftd_tot_wid, ftd_tot_len, ftd_tot_ht],center=false);

				translate([0.05,ftd_tot_len,-.05])
					rotate([0,-90,0])
					rotate([90.0,0])
			 			fillet (4,ftd_tot_len);	

			}
			union()
			{
				translate([ftd_in_wid,0,1])
					cube([ftd_slot_wid2,ftd_tot_len,ftd_tot_ht],center=false);
				ftx = ftd_in_wid - (ftd_slot_wid3 - ftd_slot_wid2);
				fty = ftd_tot_len - ftd_ic_len;
				translate([ftx,fty,4])
					cube([ftd_slot_wid3,ftd_ic_len,ftd_tot_ht],center=false);

			
			}
	 	}
	}
}
/* **** Switching module frame **** */
swb_wid = 50.2 + 0.5; // pcb x
swb_ht  = 46.2 + 0.5; // pcb y 
swb_z   = 5;	// switcher frame wall height
swb_pcb = 1.6+.1;	  // pcb thickness
swb_ldg = 1.5;		  // pcb ledge width
swb_rdg = 1.5;		  // ridge around board
swb_eye_d = 2.1;	  // Eye-bar for screw/washer translation
swb_eye_r = 4;		  // Eye-bar radius
swb_yf = 20;	// Tab offset in y direction
plano_sw_ofs = plano_len - ( (swb_ldg + swb_rdg)*2 + swb_ht) + 2;
echo ("plano_sw_ofs",plano_sw_ofs);

module switch_frame_add(xofs,yofs,zofs)
{
	translate([xofs,yofs,zofs])
	{
		ss = (swb_ldg + swb_rdg); // Ledge + ridge = wall thickness

		cx = swb_wid - swb_ldg*2; // Cutout center
		cy = swb_ht  - swb_ldg*2; // Cutout center
		rx = swb_wid + 0;     // pcb seat
		ry = swb_ht  + 0;     // pcb seat
		rz = swb_z - swb_pcb;   // pcb thickness
		rb = 10;	// big
		sx = rx + swb_rdg*2;		// Outside
		sy = ry + swb_rdg*2;		// Outside

echo ("sx",sx,"sy",sy,"ss",ss);
		translate([-sx/2,0,0])
		cube([sx, sy, swb_z],center=false);

		// Posts for screw/washer to hold pcb
		xf = screw_hole;//	Spacing of hole from wall edge
		xh = screw_hole;	// Screw hole
		xd = 9;		// Diameter of post
		translate([-sx/2-swb_eye_d,swb_yf,0])	// Left side
			eye_bar(xd, xh,swb_eye_r, swb_z);

		translate([sx/2+swb_eye_d,swb_yf,0])	// Right side
			rotate([0,0,180])
				eye_bar(xd, xh,swb_eye_r, swb_z);
	}
}

module switch_frame_del(xofs,yofs,zofs)
{
	translate([xofs,yofs,zofs])
	{
		ss = (swb_ldg + swb_rdg); // Ledge + ridge = wall thickness
		swb_yf = 20;	// Offset in y direction
		cx = swb_wid - swb_ldg*2; // Cutout center
		cy = swb_ht  - swb_ldg*2; // Cutout center
		rx = swb_wid + 0;     // pcb seat
		ry = swb_ht  + 0;     // pcb seat
		rz = swb_z - swb_pcb;   // pcb thickness
		rb = 10;	// big
		sx = rx + swb_rdg*2;		// Outside
		sy = ry + swb_rdg*2;		// Outside
echo ("cx",cx,"cy",cy);
echo ("rx",rx,"ry",ry);

		// Cutout in center
		translate([-cx/2,ss,-10])
		cube([cx, cy, 20],center=false);
		
		// Ridge for seat of pcb			
		translate([-rx/2,swb_rdg,rz])
		cube([rx, ry, rb],center=false);

		// Screw holes
		sw_screw_holes(sx);

		mirror([1,0,0])
			sw_screw_holes(sx);
	}	
}
/* Switcher tab screw holes */
module sw_screw_holes(sx)
{
		translate([sx/2+swb_eye_d,swb_yf,0])	// Right side
			cylinder(d1 = 3.2, d2 = 2.3, h = swb_z, center=false);
}

/* Offsets for switcher frame */
sw_ofs_y = 105;	// Switcher frame y axis offset
sw_ofs_z = 2;		// Switcher frame z axis offset

module total()
{
	difference()
	{
		union()
		{
			// Base with mag mount posts
			plano_base_add(bfthick);

			// PCB posts
			translate([side_ofs,brd_ofs_y,bfthick-0.01])
					discovery_posts_angled();	// Test

			// uart<->usb module post/clip
			ftdi_post(ftd_ofs_x,46);

			// Switch frame
			switch_frame_add(0,sw_ofs_y,sw_ofs_z);
		}
		union()
		{
			plano_base_del(bfthick);

			translate([side_ofs,brd_ofs_y-2,0])
					base_cutouts();

			// Switch frame
			switch_frame_del(0,sw_ofs_y,sw_ofs_z);

		}
	}
	id();
}
total();
// Test switcher frame
module xtest()	
{
	difference()
	{
			switch_frame_add(0,sw_ofs_y,sw_ofs_z);
			switch_frame_del(0,sw_ofs_y,sw_ofs_z);
	}
}
//xtest();

//F4gtotal();
