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

 $fn=50;

bplt_thx = 3;
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
ux = 4; uy = 10;
ofx = bplt_len/2 - ux;
ofy = bplt_wid/2 - uy;
  translate([ ofx, ofy, 0])cylinder(d=d,h=h,center=true);
  translate([-ofx, ofy, 0])cylinder(d=d,h=h,center=true);
  translate([ ofx,-ofy, 0])cylinder(d=d,h=h,center=true);
  translate([-ofx,-ofy, 0])cylinder(d=d,h=h,center=true);

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
			translate([0,0,0]) cap_mtg_holes();

			/* Plate-to-enclosure mounting holes*/
			plt_mtg_holes();
		}
	}
}
rlen = 8;
rwid = 20;
rht  = 10;
module bot_wire_clamp(dx,dy)
{
 translate([dx,dy,bplt_thx])
 {
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
			len = 5; wid = 12; ht = 14;
			ofz = rht + 3;
			translate([-6,0,ofz])
				rotate([90,0,90])
					rounded_rectangle(len,wid,ht,2);

			/* Holes for power cable clamp */
			dia = 2.8;
			ofx1 = 0;
			ofy1 = 7;
			translate([ofx1, ofy1,0])cylinder(d=dia,h=50,center=true);
			translate([ofx1,-ofy1,0])cylinder(d=dia,h=50,center=true);

		}
	}	
 }
}

module total()
{
	difference()
	{
		union()
		{
			bot_plate();
			bot_wire_clamp(40,0);
		}
		union()
		{
		}
	}	
}
total();


