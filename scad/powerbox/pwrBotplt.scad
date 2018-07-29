/* File: pwrBotplt.scad
 * Power unit: Bottom plate
 * Author: deh
 * Latest edit: 20180606
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

 $fn=50;

bplt_thx = 6;
bplt_len = 90;
bplt_wid = 75;

module cap_mtg_holes()
{
			/* Capacitor mounting block holes */
cap_d = 2.8;	// Hole in base for cap block mounting screws
			delx = 37;
			dely = 63;
	translate([ delx/2, dely/2,0]) cylinder(d=cap_d,h=50,center=true);
	translate([-delx/2, dely/2,0]) cylinder(d=cap_d,h=50,center=true);
	translate([ delx/2,-dely/2,0]) cylinder(d=cap_d,h=50,center=true);
	translate([-delx/2,-dely/2,0]) cylinder(d=cap_d,h=50,center=true);
				
}
module plt_mtg_holes()
{
d = 3.4; h = 50;
ux = 5; uy = 10;	// Offset from edge x & y
ofx = bplt_len/2 - ux;
ofy = bplt_wid/2 - uy;
  translate([ ofx, ofy, 0])cylinder(d=d,h=h,center=true);
  translate([-ofx, ofy, 0])cylinder(d=d,h=h,center=true);
  translate([ ofx,-ofy, 0])cylinder(d=d,h=h,center=true);
  translate([-ofx,-ofy, 0])cylinder(d=d,h=h,center=true);
  translate([-ofx,   0, 0])cylinder(d=d,h=h,center=true);

/* Skip embedded nuts & washers 
	plt_mtg_nut(-ofx,   0);
	plt_mtg_nut( ofx, ofy);
	plt_mtg_nut( ofx,-ofy);
*/
}	
module plt_mtg_nut(dx,dy)
{
 translate([dx,dy,0])
 {
 // Stud
  cylinder(d = ss_dia1, h = magx_stud_len + 3, center=false);

  // Washer
  translate([0,0,mm_ht12])
    cylinder(d = magx_washer_dia + 0.5, h = magx_washer_thick, center=false);

  // Nut
  translate([0,0,mm_ht12+magx_washer_thick])
    cylinder(d = ss_nut_dia, h = magx_nut_thick, center= false, $fn = 6);
 }
}

module bot_plate()
{
	difference()
	{
		union()
		{
			translate([0,0,bplt_thx/2])
				cube([bplt_len, bplt_wid, bplt_thx],center=true);
		}
		union()
		{
			/* Corner indents */
			dia1 = 8;
			ofx1 = bplt_len/2;
			ofy1 = bplt_wid/2;
			translate([-ofx1,-ofy1,0])cylinder(d=dia1,h=50,center=true);
			translate([ ofx1,-ofy1,0])cylinder(d=dia1,h=50,center=true);
			translate([-ofx1, ofy1,0])cylinder(d=dia1,h=50,center=true);
			translate([ ofx1, ofy1,0])cylinder(d=dia1,h=50,center=true);

			/* Capacitor mounting block holes */
			translate([  0,0,0]) cap_mtg_holes();
			translate([-12,0,0]) cap_mtg_holes();

			/* Plate-to-enclosure mounting holes*/
			plt_mtg_holes();
		}
	}
}
rlen = 9;
rht  = 10;
module bot_wire_clamp(dx,dy,rwid,cwid,chole,czd)
{
 translate([dx,dy,bplt_thx])
 {
  len = cwid;
	difference()
	{
		union()
		{
			translate([0,0,rht/2])
				cube([rlen,rwid,rht],center=true);
		}
		union()
		{
			/* cutout for power cable */
//			len = 6.5; 
			wid = 12; ht = 18;
			ofz = rht + 7-2.8 + czd;  // Set depth of cutout
			translate([-6,0,ofz])
				rotate([90,0,90])
					rounded_rectangle(len,wid,ht,2);

			/* Holes for power cable clamp */
			dia = 2.8;
			ofx1 = 0;
			ofy1 = chole;//ofy1 = 7;
			translate([ofx1, ofy1,0])cylinder(d=dia,h=50,center=true);
			translate([ofx1,-ofy1,0])cylinder(d=dia,h=50,center=true);
		}
	}	
 }
}
/* Top clamp bar to hold power cable */
kht  = 5;	// Height of top wire clamp bar

module top_wire_clamp(a, rwid)
{
translate(a)
 {
	difference()
	{
		union()
		{
			// Main clamp bar
			translate([0,0,kht/2])
				cube([rlen,rwid,kht],center=true);

			// Center wedge 
			translate([rlen/2,0,kht])
				rotate([0,-90,0])
					wedge_isoceles(rlen, 2, 2);
		}
		union()
		{
			/* cutout for power cable */

			/* Holes for power cable clamp */
			dia = 3.5;
			ofx1 = 0;
			ofy1 = 7;
			translate([ofx1, ofy1,0])cylinder(d=dia,h=50,center=true);
			translate([ofx1,-ofy1,0])cylinder(d=dia,h=50,center=true);
		}
	}	
 }
}
module top_side_wire_clamp(a, rwid)
{
translate(a)
 {
	difference()
	{
		union()
		{
			// Main clamp bar
			translate([0,0,kht/2])
				cube([rlen,rwid,kht],center=true);

			// Center wedge 
//			translate([rlen/2,0,kht])
//				rotate([0,-90,0])
//					wedge_isoceles(rlen, 2, 2);
		}
		union()
		{
			/* cutout for power cable */

			/* Holes for power cable clamp */
			dia = 3.2;
			ofx1 = 0;
			ofy1 = 5.5;
			translate([ofx1, ofy1,0])cylinder(d=dia,h=50,center=true);
			translate([ofx1,-ofy1,0])cylinder(d=dia,h=50,center=true);
		}
	}	
 }
}
bw_del = 2.5;
module total2()
{
	difference()
	{
		union()
		{
			bot_plate();
			bot_wire_clamp(40.05,         0,20,6.5,7.0, 0);
			bot_wire_clamp(40,-25-bw_del,15,5.0,5.5,-1.5);
			bot_wire_clamp(40, 25+bw_del,15,5.0,5.5, 1);
		}
		union()
		{
		}
	}	
}
//total2();
top_wire_clamp([20,0,0], 20);
top_side_wire_clamp([0,0,0], 15);
top_side_wire_clamp([-10,0,0], 15);


