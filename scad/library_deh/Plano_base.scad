/* File: Plano_base.scad
 * Base for mounting pcb in Plano box
 * Author: deh
 * Latest edit: 20180123
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/Plano_frame.scad>

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

pl_len = plano_len;
pl_wid = plano_wid;

pl_cc = base_rnd;	// Rounded corner dia: corner_cut
pl_sc = 4;			// Rounded inside bottom dia: side_cut

mgp_ofs_yb	= 9-1.5;	// Bottom-center mag y offset
mgp_ofs_ht	= 4;

mgp_od = 12;	// Mag mount post outside diameter
mgp_ht = 8;		// Mag stud length
mgp_floor = 2;	// Thickness between box floor and washer bottom

/* 4-40 magnet stud */
mgp_wash_thk = washer_thick_4 + 0.5; // 4-40 Washer thickness
mgp_wash_dia = washer_od_4 + 0.5;	// 4-40 Washer OD
mgp_stud_dia = mag_stud_dia + 0.6; // Stud diameter
mgp_nut_pk   = nut_dia_440 + 0.6;	// Nut peak-peak
mgp_nut_thk  = nut_thick_440;
module mag_post_add()
{
	cylinder(d=mgp_od,h=mgp_ht,center=false);	
}

module mag_post_del()
{
	translate([0,0,-.05])	// Stud hole
		cylinder(d=mgp_stud_dia,h=mgp_ht+1,center=false);

	translate([0,0,mgp_floor]) // Washer
		cylinder(d=mgp_wash_dia,h=mgp_wash_thk,center=false);

	translate([0,0,mgp_floor+mgp_wash_thk]) // Hex nut
		cylinder(d=mgp_nut_pk,h=mgp_nut_thk,center=false, $fn=6);

}
module mag_posts_add()
{

}
module mag_posts_del()
{

}

/* Additions 
 * thick = base thickness 
 */
module plano_base_add(thick)
{
	rounded_rectangle(pl_wid-pl_cc,pl_len-pl_cc,thick,pl_cc);
}

/* Deletions (used in a final 'difference()' */
module plano_base_del()
{

}
/* ***** chamfered_corner **********************
 * cx, cy form triangle for bottom chamfer
 * rad = z axis radius for corner
*/ 
module chamfered_corner(cx,cy,rad)
{
    rotate_extrude(angle=90)
        translate([rad,0,0])
            polygon(points=[[0,0],[0,cy],[cx,cy]]);    
}
/* ***** chamfered_rectangle *******************
 * wid  = width, x direction 
 * slen = length, y direction
 * cut  = x & y direction of chamfer
 * rad  = z axis, radius of corner rounding
*/
module chamfered_rectangle(wid,slen,cut,rad)
{
    ofs = cut+rad;
  hull()
  {  
    translate([-wid/2+ofs,ofs,0])
      rotate([0,0,180])
        chamfered_corner(cut,cut,rad);

    translate([ wid/2-ofs,ofs,0])
      rotate([0,0,-90])
        chamfered_corner(cut,cut,rad);

    translate([-wid/2+ofs,slen-ofs,0])
      rotate([0,0,90])
        chamfered_corner(cut,cut,rad);
    
    translate([ wid/2-ofs,slen-ofs,0])
      rotate([0,0,0])
        chamfered_corner(cut,cut,rad);
  } 
}
/* ***** rounded_rectangles2 ********************
 * wid  = width, x direction 
 * slen = length, y direction
 * ht   = height (or thickness if you prefer)
 * cut  = x & y direction of chamfer
 * rad  = z axis, radius of corner rounding
*/
module rounded_rectangles2(wid,slen,ht,cut,rad)
{
    ofs=rad+cut;
 hull()
 {    
    translate([-wid/2+ofs,ofs,0])
        cylinder(r=ofs,h=ht,center=false);

    translate([ wid/2-ofs,ofs,0])
        cylinder(r=ofs,h=ht,center=false);

    translate([-wid/2+ofs,slen-ofs,0])
        cylinder(r=ofs,h=ht,center=false);
    
    translate([ wid/2-ofs,slen-ofs,0])
        cylinder(r=ofs,h=ht,center=false);
 }
/* ***** composite_chamfered_rectangle **************
 * wid  = width, x direction 
 * slen = length, y direction
 * ht   = height (or thickness if you prefer)
 * cut  = x & y direction of chamfer
 * rad  = z axis, radius of corner rounding
 * NOTE: this places a rounded rectangular cube on top
 *   of a rounded rectangle with a bottom chamfer,
 *   i.e. this is a "base" for a Plano box.
*/
}
module composite_chamfered_rectangle(wid,slen,ht,cut,rad)
{
    chamfered_rectangle(wid,slen,cut,rad);
    
    translate([0,0,cut])
        rounded_rectangles2(wid,slen,ht-cut,cut,rad);
}
composite_chamfered_rectangle(66,86,5,4,3); // test this module

module test()
{
	thk = 5;	// Thickness
	difference()
	{
		plano_base_add(thk);
		plano_base_del(thk);
	}
}
//test();
