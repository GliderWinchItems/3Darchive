 /* File: Plano_frame_F4gate.scad
 * Plano box with Discovery F4 gateway
 * Author: deh
 * Latest edit: 20180109
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>

 $fn=100;

big = 10;	// Big z in direction 

/* From Plano_frame.scad--
dis_wid = 65.4;  // Overall width
dis_len = 95.8;  // Overall length
base_len = plano_len;
base_wid = plano_wid;
*/
plano_len = 157;	// Inside length of Plano box
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

magxbottom_ofs_y = 9-1.5;	// Offset from bottom of tab
magxbottom_pstdia = 10;	// Eyebar (post) diameter
magxbottom_pstht = 6.3;	// Post height


corner_cut = 7;	// Rounded corner dia
side_cut = 4;	// Rounded inside bottom dia


// **** Id the part ***
module id()
{
 {
  font = "Liberation Sans:style=Bold Italic";
 translate([-75, 2, base_ht]) 
  linear_extrude(1.0)
   text("2018 01       09  V1",size = 4);
 }
}

module base()
{
			translate([-plano_wid_bot/2,0,0])
				cube([plano_wid_bot, bflen+2, bfthick],center=false);
}
/* Bevel lower edge to avoid radius at bottom edges of Plano */
module base_radx()
{
xc = (plano_wid_bot/2 - side_cut);
      // Corner notches
			translate([plano_wid_bot/2-corner_cut,0,0])    // Right corner
				rotate([0,-90,-90])
					wedge(bfthick, corner_cut, corner_cut);

			translate([-plano_wid_bot/2,corner_cut,0])    // Left corner
				rotate([0,-90,180])
					wedge(bfthick, corner_cut, corner_cut);

      // Bottom edge to avoid case radius at bottom
         translate([-xc-0.1,0,0])    // Left side
            rotate([0,0,90])
                wedge( bflen+100, side_cut, side_cut);

         translate([+xc+side_cut,side_cut,side_cut]) // Right side
            rotate([0,-90,0])
                rotate([0,0,90])
                    wedge( bflen+100, side_cut, side_cut);

         translate([-bflen/2,0,side_cut])    // Bottom edge
            rotate([-90,0,0])
                wedge( bflen, side_cut, side_cut);

         translate([bflen/2,plano_len,side_cut])    // Top edge
            rotate([ -90,0,180])
                wedge( bflen, side_cut, side_cut);

         translate([-bflen/2,plano_len,0])    // Trim off little end piece
				cube([bflen,2,10],center=false);
}

hdr_od = 56;
hdr_ln = 65;	// Length of header
hdr_of = 32.5;	// Offset from bottom edge of pcb
hdr_ht = 1;		// Base thickness under header
hdr_wid = 7;	// Header width (including tolerances)
hdr_spc = 46;	// Spacing of headers (inside dimension)
side_ofs = -5.5;	// Offset of board recess and posts from y axis centerline

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
hdr_wid2p = 4;

module hdr_2(xw)
{
	translate([xw, hdr_of2p, hdr_ht])
		cube([hdr_wid,hdr_ln2p,10],center= false);
}
/* Both 2 pin headers positioned */
module hdr_2s()
{
	hdr_2( (hdr_spc/2 - 0));
	hdr_2(-(hdr_spc/2 - 0)-hdr_wid);
}

big = 10;	// Big z in direction 
endrim = 4;
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

module pcb_post(len)
{
	pht = pst_ldg + clip_ht + pcb_thick;

	// Base->bottom edge of pcb, i.e. "ledge"
	cube([pst_wid,len,pst_ldg],center=false);

	// Ledge to start of 45 deg clip overhang
	translate([0,0,pst_ldg])
		cube([pst_w2,len,pcb_thick+clip_ht],center=false);

	// Clip overhang
	translate([clip_ht+pst_w2,len,pst_ldg+pcb_thick+clip_ht-0.5])
		rotate([0,180,0])
		rotate([0,0,-90])
		wedge(len,clip_ht,clip_ht);
}
module pcb_post_ridged(len)
{
rdg = 1;
 translate([0,-(pst_wid-rdg),0])
 {
	difference()
	{
		translate([-len/2,0,0])
			cube([len,pst_wid, pst_ldg + pcb_thick],center=false);
		translate([-len/2-.01,-rdg,pst_ldg])
			cube([len+.2,pst_wid,5],center=false);
	}
 }
}

/* Post for screw instead of overhang clip */
module screw_post(scp_x)
{
scp_y = 6;
 spy = scp_y - screw_hole/2 - 1;
 translate([0,-spy+(screw_hole/2)+0.6,0])
 {
	difference()
	{
		translate([-scp_x/2,0,0])
			cube([scp_x,scp_y,pst_ldg],center=false);
		translate([0,spy,0])
			cylinder(d=screw_hole,h = pst_ldg,center=false);
	}
 }
}

module pcb_posts()
{
	/* Side posts	*/
	len = 10;	// Length
	yofs = 15;	// Offset from bottom of base
	left = -dis_wid/2 - pst_w2;
	right = dis_wid/2 + pst_wid - pst_w2;
	// Left side
	translate([left,yofs,0])
		pcb_post(len);	

	// Right side
	translate([right,yofs+len,0])
	rotate([0,0,180])
		pcb_post(len);	

	/* Top post	*/
	wid = 5;	// Length (width, in this orientation)
	xofs = -14;
	xofs2 = 6;
	yofs2 = bflen + bfusb;

	/* Top right post */
	translate([xofs2,yofs2,0])
		pcb_post_ridged(wid);

	/* Top screw post */
	translate([xofs,yofs2,0])
		screw_post(8);

	/* Bottom left */
	lenbot = 5;	// Bottom post length
	xofs3 = -15+lenbot;
	translate([xofs3,0,0])
		rotate([0,0,90])
			pcb_post(lenbot);	

	/* Bottom right */
	xofs4 = 15+lenbot;
	translate([xofs4,0,0])
		rotate([0,0,90])
			pcb_post(lenbot);	


	translate([right,yofs2,0])
		rotate([0,0,0])
			ridged_screw_post(5);

}

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

module ftdi_post()
{
echo(ftd_tot_wid,"ftd_tot_wid");
	translate([0,0,bfthick])
	{
		difference()
		{
			union()
			{
				translate([0,0,0])
					cube([ftd_tot_wid, ftd_tot_len, ftd_tot_ht],center=false);
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
/* Washer with nut on top, insert cutouts 
wofs = offset from bottom to bottom of washer
*/

module washer_nut(wofs)
{
	cylinder(d=magx_stud_dia, h = 15, center=false);

	translate([0,0,wofs])
		cylinder(d=magx_washer_od, h=magx_washer_thick, center=false);	

	translate([0,0,wofs+magx_washer_thick])
rotate([0,0,360/12])
		cylinder(d=magx_nut_dia, h=magx_nut_thick, center=false, $fn = 6);	
}

/* Bottom center mag mount tab w hole */
washer_backing = 2;	// Amount of material from bottom to bottom of washer
wofs = 2;  // Z offset for bottom of washer

module mag_tab_bot()
{

	translate([0,magxbottom_ofs_y,0])	// Offset from bottom
	difference()
	{
/*
		rotate([0,0,-90])
			eye_bar(magxbottom_pstdia,
				magx_stud_dia,
				5,
				magxbottom_pstht);
*/
		cylinder(d=magxbottom_pstdia,h=magxbottom_pstht,center=false);

		union()
		{
			cylinder(d=magx_stud_dia,h=6,center=false);

			washer_nut(washer_backing);	// Washer & nut

      // Bottom edge to avoid case radius at bottom
xc = (plano_wid_bot/2 - side_cut);
         translate([-xc-0.1,0,0])    // Left side
            rotate([0,0,90])
                wedge( bflen+10, side_cut, side_cut);
		}
	}
}
/* Switching module frame */
swb_wid = 50.2 + 0; // pcb x
swb_ht  = 46.2 + 0; // pcb y 
swb_pcb = 1.6+.1;	  // pcb thickness
swb_ldg = 1.5;		  // pcb ledge width
swb_rdg = 1.5;		  // ridge around board
swb_eye_d = 2.1;	  // Eye-bar for screw/washer translation
swb_eye_r = 4;		  // Eye-bar radius
plano_sw_ofs = plano_len - ( (swb_ldg + swb_rdg)*2 + swb_ht) + 2;
echo ("plano_sw_ofs",plano_sw_ofs);

module switch_frame()
{
	difference()
	{
		ss = (swb_ldg + swb_rdg); // Ledge + ridge = wall thickness

		cx = swb_wid - swb_ldg*2; // Cutout center
		cy = swb_ht  - swb_ldg*2; // Cutout center
		rx = swb_wid + 0;     // pcb seat
		ry = swb_ht  + 0;     // pcb seat
		rz = bfthick - swb_pcb;   // pcb thickness
		rb = 10;	// big
		sx = rx + swb_rdg*2;		// Outside
		sy = ry + swb_rdg*2;		// Outside
		union()
		{
echo ("sx",sx,"sy",sy,"ss",ss);
			translate([-sx/2,0,0])
			cube([sx, sy, bfthick],center=false);

			// Posts for screw/washer to hold pcb
			yf = 20;	// Offset in y direction
			xf = screw_hole;//	Spacing of hole from wall edge
			xh = screw_hole;	// Screw hole
			xd = 9;		// Diameter of post
			translate([-sx/2-swb_eye_d,yf,0])	// Left side
				eye_bar(xd, xh,swb_eye_r, bfthick);

			translate([sx/2+swb_eye_d,yf,0])	// Right side
				rotate([0,0,180])
				eye_bar(xd, xh,swb_eye_r, bfthick);

		}
		union()
		{
echo ("cx",cx,"cy",cy);
echo ("rx",rx,"ry",ry);

			// Cutout in center
			translate([-cx/2,ss,-0.05])
			cube([cx, cy, bfthick+.1],center=false);
		
			// Ridge for seat of pcb			
			translate([-rx/2,swb_rdg,rz])
			cube([rx, ry, rb],center=false);
		}
	}
}
/* Fill in gap between pcb frame and switcher frame */
module sw_gap()
{
gap_wid = 66;
gap_len = 30;
	difference()
	{
			translate([-gap_wid/2,0,0])
		cube([gap_wid,gap_len,bfthick],center=false);

		swx = (swb_wid + swb_ldg + swb_rdg);
		translate([-swx/2,13,0])
			cube([swx,50,bfthick+.01],center=false);
	}
}
/* Mounting for top pair of magnets */
tm_ofs_x = 32;		// Offset from centerline
tm_ofs_y = 146;	// Offset from bottom

module top_mag(px,py,dl,gl, kl)
{	
	difference()
	{
		union()
		{
			jx = 10; jy = 12;
			translate([px-4.5+dl,py-6,0])
				cube([jx,jy,magxbottom_pstht],center=false);
		
			gx = 9; gy = 25;
			translate([(px + gl),py-3,bfthick/2])
				cube([gx,gy,bfthick],center=true);
		
			// Fill to edge (a messy hack)			
			xwid = 8.5; kx = px + kl ;
			ylen = 55; ky = py - 20;
			translate([kx,ky,bfthick/2])
				cube([xwid,ylen,bfthick],center=true);
		}
		union()
		{
			translate([px,py,-.01])
				cylinder(d=magx_stud_dia,h=10,center=false);

			translate([px,py,0])
				washer_nut(washer_backing);	// Washer & nut
		}
	}
}
module top_mags()
{
		top_mag(tm_ofs_x,tm_ofs_y,   0,-2, 4);	

		top_mag(-tm_ofs_x,tm_ofs_y,-.5, 2, -4);		


}
/* Ridged screw post */
module ridged_screw_post(len)
{
		union()
		{
//			translate([-len/2,0,0])
//				pcb_post_ridged(len);	
			translate([0,0,0])
//				rotate([0,0,-90])
					pcb_post_ridged(len);	
			
		}
}


module total()
{
	difference()
	{	union()
		{
			base();

			translate([ftd_ofs_x,40,0])
				ftdi_post();

			translate([side_ofs,0,0])
				pcb_posts();

			translate([0,plano_sw_ofs,0])
				switch_frame();

			translate([0,95,0])	
				sw_gap();

			top_mags();

		}
		union()
		{
			base_radx();

			translate([side_ofs,0,0])
				base_cutouts();

			// Bottom tab
			translate([0,magxbottom_ofs_y,0])	// Offset from bottom
				washer_nut(washer_backing);	// Washer & nut
		}
	}
mag_tab_bot();

translate([70,0,0])
	ridged_screw_post(5);
}

total();

