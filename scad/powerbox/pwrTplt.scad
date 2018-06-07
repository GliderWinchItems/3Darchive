/* File: pwrTplt.scad
 * Power unit: Top plate
 * Author: deh
 * Latest edit: 20180603
 * 
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/deh_shapes2.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=50;

tpl_len = 53.2;// Length (x)
tpl_wid = 54.3;	// Width (y)
tpl_thx = 3;	// Thickness (z)
tpl_sid = 8;	// Side bar thickness
tpl_rad = 2;	// Corner radius
tpl_ofs = 4;	// Offset of screw hole center from edge
tpl_dia = 3.4;	// Screw hole shank diameter

module top_plate()
{
	difference()
	{
/* ***** rounded_rectangle_hull ********************
 * wid  = width, x direction 
 * slen = length, y direction
 * ht   = height (or thickness if you prefer)
 * cut  = x & y direction of chamfer
 * rad  = z axis, radius of corner rounding
*/
	union()
	{
		rounded_rectangle_hull(tpl_len,tpl_wid,tpl_thx,0,tpl_rad);
	}

	union()
	{
		// Center punchout
		len1 = tpl_len - tpl_sid*2;
		wid1 = tpl_wid - tpl_sid*2;
		ofy1 = tpl_sid;
		translate([0,ofy1,0])
			rounded_rectangle_hull(len1,wid1,tpl_thx,0,tpl_rad);

		// Screw holes
		tpl_holes();
	}
	}
}
module tpl_hole(dx,dy)
{
	translate([dx,dy,0])
		cylinder(d=tpl_dia,h=50,center= false);
}
module tpl_holes()
{
	ofx = tpl_len/2 - tpl_ofs;
	ofy = tpl_wid - tpl_ofs;
	tpl_hole( ofx, ofy);
	tpl_hole(-ofx, ofy);
	tpl_hole( ofx,tpl_ofs);
	tpl_hole(-ofx,tpl_ofs);

}
tpl_pcb_thx = 6;	// Thickness of bar on top for pcb mt
module tpl_pcb_mt(dx,dy)
{
len = tpl_sid;
wid = tpl_sid;
ofx = dx - tpl_sid/2;
ofz = tpl_pcb_thx/2 + tpl_thx;
		translate([ofx,dy,ofz])
			cube([len,wid,tpl_pcb_thx],center = true);
}
module tpl_pcb_mts()
{
ofx = tpl_len/2;
ofy1 = tpl_wid - tpl_sid*2 + 2;
	tpl_pcb_mt( ofx, ofy1);
	tpl_pcb_mt(-ofx+tpl_sid, ofy1);
ofy2 = tpl_sid*2 - 2;
	tpl_pcb_mt( ofx, ofy2);
	tpl_pcb_mt(-ofx+tpl_sid, ofy2);
}
tpl_pcb_hole_d = 2.8;	// pcb mt hole diameter
module tpl_pcb_mts_hole(dx,dy)
{
	translate([dx,dy,0])
		cylinder(d=tpl_pcb_hole_d, h=100,center=false);
}
module tpl_pcb_mts_holes()
{
ofx1 = tpl_len/2 -tpl_sid/2;
ofy1 = tpl_wid/2 - 12.8;
	tpl_pcb_mts_hole( ofx1,ofy1);
	tpl_pcb_mts_hole(-ofx1,ofy1);
ofy2 = tpl_wid/2 + 12.8;
	tpl_pcb_mts_hole( ofx1,ofy2);
	tpl_pcb_mts_hole(-ofx1,ofy2);

}

module total()
{
	difference()
	{
		union()
		{
			top_plate();
			tpl_pcb_mts();
		}
		union()
		{
			tpl_pcb_mts_holes();

		}
	}
}
total();
