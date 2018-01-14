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

plano_wid_top = 83;	// Inside width at rim
plano_wid_bot = 82;	// Inside width near bottom before radius
plano_rad_bot = 6;	// Radius at bottom edges
plano_rad_end = 7;	// Radius (z axis) at inside corners
bflen = 105;
bfthick = 5; 	// Base thickness

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
                wedge( bflen+10, side_cut, side_cut);

         translate([+xc+side_cut,side_cut,side_cut]) // Right side
            rotate([0,-90,0])
                rotate([0,0,90])
                    wedge( bflen, side_cut, side_cut);

         translate([-bflen/2,0,side_cut])    // Bottom edge
            rotate([-90,0,0])
                wedge( bflen, side_cut, side_cut);

         translate([bflen/2,159,side_cut])    // Top edge
            rotate([ -90,0,180])
                wedge( bflen, side_cut, side_cut);

         translate([-bflen/2,159,0])    // Trim off little end piece
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
hdr_ln2p = 6.2;	// Length of 2 pin header
hdr_of2p = 1.9;	// Offset from bottom edge of pcb

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
pst_ldg = 10 + bfthick;	// Height of pc board ledge from bottom
pst_wid = 3;	// Width of post
pcb_thick = 2.0;	// Thickness of pcb
clip_ht = 3;
pst_w2 = 1;	// Width where pcb contacts edge

module base_post(len)
{
	pht = pst_ldg + clip_ht + pcb_thick;

	// Base->bottom edge of pcb, i.e. "ledge"
	cube([pst_wid,len,pst_ldg],center=false);

	// Ledge to start of 45 deg clip overhang
	translate([0,0,pst_ldg])
		cube([pst_w2,len,pcb_thick+clip_ht],center=false);

	// Clip overhang
	translate([clip_ht+pst_w2,len,pst_ldg+pcb_thick+clip_ht])
		rotate([0,180,0])
		rotate([0,0,-90])
		wedge(len,clip_ht,clip_ht);
}

module base_posts()
{
	/* Side posts	*/
	len = 10;	// Length
	yofs = 15;	// Offset from bottom of base
	left = -dis_wid/2 -pst_wid + pst_w2;
	// Left side
	translate([left,yofs,0])
		base_post(len);	

	// Right side
	translate([-left,yofs+len,0])
	rotate([0,0,180])
		base_post(len);	

	/* End posts	*/
	wid = 5;	// Length (width, in this orientation)
	yofs2 = bflen + pst_wid - pst_w2;	// 
	translate([-12,yofs2,0])
	rotate([0,0,-90])
		base_post(wid);	
}

/* FTDI unit goes between pcb and case wall */
ftd_base_len = 35;	// Lenth of base part
ftd_post_len = 15;	// Length of tall part
ftd_slot_base = bfthick;// Offset from bottom of case
ftd_slot_wid = 2;		// Width of pcb

ftd_slot_wid2 = 3.5;	// Width at IC
ftd_in_wid = 1.5;	// Inner wall width
ftd_tot_wid = ftd_slot_wid2+ftd_in_wid+1.5;	// Width total
ftd_tot_len = 21;
ftd_tot_ht = 18.2;
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
			}
	 	}
	}
}
/* Bottom center mag mount tab w hole */
module mag_tab()
{
	translate([0,11,0])
		rotate([0,0,-90])
			eye_bar(8,3.2,6.5, bfthick);
}
/* Switching module frame */
swb_wid = 50.2+.4; // pcb x
swb_ht = 46.2+.4;	 // pcb y 
swb_pcb = 1.6+.1;	 // pcb thickness
swb_ldg = 1.5;		 // pcb ledge width
swb_rdg = 1.5;		 // ridge around board
cutout_wid = swb_wid - 3;
cutout_ht = swb_ht - 3;

module switch_frame()
{
	difference()
	{
		ss = (swb_ldg + swb_rdg); // Ledge + ridge = wall thickness
		sx = swb_wid + ss*2;		// Outside
		sy = swb_ht  + ss*2;		// Outside
		cx = swb_wid - 0; // Cutout center
		cy = swb_ht  - 0; // Cutout center
		rx = swb_wid + swb_ldg*2; // pcb seat
		ry = swb_ht  + swb_ldg*2; // pcb seat
		rz = bfthick - swb_pcb;   // pcb thickness
		rb = 10;	// big
		union()
		{
			translate([-sx/2,0,0])
			cube([sx, sy, bfthick],center=false);

			// Posts for screw/washer to hold pcb
			yf = 20;	// Offset in y direction
			xf = 3.2;//	Spacing of hole from wall edge
			xh = 3.2;	// Screw hole
			xd = 9;		// Diameter of post
			translate([-sx/2-2.3,yf,0])	// Left side
				eye_bar(xd, xh, 4, bfthick);

			translate([sx/2+2.3,yf,0])	// Right side
				rotate([0,0,180])
				eye_bar(xd, xh, 4, bfthick);

		}
		union()
		{
			// Cutout in center
			translate([-cx/2,ss,-0.05])
			cube([cx, cy, bfthick+.1],center=false);
		
			// Ridge for seat of pcb			
			translate([-rx/2,swb_rdg,rz])
			cube([rx, ry, rb],center=false);
		}
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
				base_posts();

//translate([100,0,0])
			translate([0,bflen+2,0])
				switch_frame();

		}
		union()
		{
			base_radx();

			translate([side_ofs,0,0])
				base_cutouts();
		}
	}
	mag_tab();
}

total();

