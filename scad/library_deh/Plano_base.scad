/* File: Plano_base.scad
 * Base for mounting pcb in Plano box
 * Author: deh
 * Latest edit: 20180123
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/deh_shapes2.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/discovery_posts.scad>
include <../library_deh/POD_posts.scad>

/*********************************************************
// Stud magnet relative postions.
 // Bottom magnet is on center-line and x,y reference is 0,0
 plano_mag_top_x  = 30.5;   // Top pair x +/- from center-line (C/L)
 plano_mag_top_y  = 138.69; // Top pair y from bottom magnet hole
 plano_mag_top_ofs = 8;    // Top mags to top edge of PC board max
 // Bottom mag distance from bottom of plano wall
 plano_mag_bot_ofs = plano_len - plano_mag_top_ofs - plano_mag_top_y;
 
 
 plano_offs_mag_y   = 4;    // Offset from edge for magnet hole
 plano_offs_mag_x   = 4;    // Offset from edge for magnet hole
 plano_ctr_y    = (plano_len/2);
 plano_ctr_x    = (plano_wid/2);
  
 plano_mag_stud = mag_stud_dia;  // Dia of mounting magnet studs (4-40)
 plano_mag_stud_len = mag_stud_len; // Height of stud from magnet back
 mag_washer_dia = 9.5;      // Diameter of washer for magnet stud
 mag_washer_thick = 1.1;    // Thickness of washer
 mag_washer_dia_extra = 1;  // Washer slop
 plano_web_thick = 2;   // Plano box thickness where stud is 
 mag_wash_recess_dia = mag_washer_dia + mag_washer_dia_extra;

 // Thickness of base for washer recess
 mag_stud_z = (mag_washer_thick +mag_nut_thick + plano_web_thick);
 mag_wash_recess_z = plano_mag_stud_len - mag_stud_z;    

 // Diameter of recess
 mag_wash_recess_dia = mag_washer_dia + mag_washer_dia_extra;
**************************************************************/
plano_wid_top = 83;	// Inside width at rim
plano_wid_bot = 81;	// Inside width near bottom before radius
pl_len = 157;	// Inside length of Plano box
pl_wid = plano_wid_bot;

pl_cc = base_rnd;	// Rounded corner dia: corner_cut
pl_sc = 4;			// Rounded inside bottom dia: side_cut

/* Mounting for bottom magnet */
mgp_ofs_yb = 9-1.5;	// Bottom-center mag y offset
mgp_del = 2.5;	// Raise and shorten to avoid sticking into chamfer


/* Mounting for top pair of magnets */
tm_ofs_x = 29;		// Offset from centerline
tm_ofs_y = 142+4.5;	// Offset from bottom

mgp_od = 10;	// Mag mount post outside diameter
mgp_ht = 8;		// Mag stud length
mgp_floor = 2;	// Thickness between box floor and washer bottom

/* 4-40 magnet stud */
mgp_wash_thk = washer_thick_4 + 0.5; // 4-40 Washer thickness
mgp_wash_dia = washer_od_4 + 0.5;	// 4-40 Washer OD
mgp_stud_dia = mag_stud_dia + 0.6; // Stud diameter
mgp_nut_pk   = nut_dia_440 + 0.6;	// Nut peak-peak
mgp_nut_thk  = nut_thick_440;

module mag_post_add(a,ht)
{
	translate(a)
	cylinder(d=mgp_od,h=ht,center=false);	
}

module mag_post_del(a)
{
 translate(a)
 {
	translate([0,0,-.05])	// Stud hole
		cylinder(d=mgp_stud_dia,h=mgp_ht+1,center=false);

	translate([0,0,mgp_floor]) // Washer
		cylinder(d=mgp_wash_dia,h=mgp_wash_thk,center=false);

	translate([0,0,mgp_floor+mgp_wash_thk]) // Hex nut
	  rotate([0,0,30])
		cylinder(d=mgp_nut_pk,h=mgp_nut_thk,center=false, $fn=6);
 }
}
module mag_posts_add()
{
	// Bottom center mag post
	mag_post_add([0,mgp_ofs_yb,mgp_del],mgp_ht-mgp_del);

	// Top mag (tm) posts
	mag_post_add([-tm_ofs_x,tm_ofs_y,0],mgp_ht);
	mag_post_add([ tm_ofs_x,tm_ofs_y,0],mgp_ht);	
}
mag_posts_add();

module mag_posts_del()
{
	// Bottom center mag post
	mag_post_del([0,mgp_ofs_yb,0]);

	// Top mag (tm) posts
	mag_post_del([-tm_ofs_x,tm_ofs_y,0]);
	mag_post_del([ tm_ofs_x,tm_ofs_y,0]);	
}

/* Additions 
 * thick = base thickness 
 */
module plano_base_add(thick)
{

echo("plano_base_add","pl_wid",pl_wid,"pl_len",pl_len,"thick",thick);
	rad = pl_cc-pl_sc;	
/* ***** composite_chamfered_rectangle **************
 * wid  = width, x direction 
 * slen = length, y direction
 * ht   = height (or thickness if you prefer)
 * cut  = x & y direction of chamfer
 * rad  = z axis, radius of corner rounding less cut
 * NOTE: this places a rounded rectangular cube on top
 *   of a rounded rectangle with a bottom chamfer,
 *   i.e. this is a "base" for a Plano box.
*/
	composite_chamfered_rectangle(pl_wid,pl_len,thick,pl_sc,rad);

	mag_posts_add();

}
/* Deletions (used in a final difference() */
module plano_base_del(thk)
{
	mag_posts_del();
}

module base_with_F4posts()
{
	thk = 5;	// Thickness
	difference()
	{
		union()
		{
			plano_base_add(thk+1);
				translate([-3.5,8,thk-0.01])
					discovery_posts_angled();	// Test
		}
		union()
		{
			plano_base_del(thk);
		}
	}
}
base_with_F4posts();

/*
module base_with_PODposts()
{
	thk = 5;	// Thickness
	difference()
	{
		union()
		{
			plano_base_add(thk+1);
				translate([-3.5,8,thk-0.01])
					POD_posts_angled();	// Test
		}
		union()
		{
			plano_base_del(thk);
		}
	}
}
//base_with_PODposts();
*/
