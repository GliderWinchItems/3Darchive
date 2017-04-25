/* bearing_block.scad
 * Mockup of a bearing block
 * Date: 20170421
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>

$fn = 100;


bb_ht = 40;		// Overall height
bb_thick = 0.5*25.4;	// Square thickness
bb_rad = .25*25.4;	// Radius of corners
bb_sq = 3.75 * 25.4 - bb_rad;	// Square dimension

bb1_dia = 2.5*25.4;	// Circular shape
bb1_ht = 27;	// And thickness

bb2_dia = 1.5*25.4;	// Top 
bb2_ht = bb1_ht + 10;

bb3_dia = 1.125*25.4;
bb3_ht = bb_ht - 6; 

bb4_dia = 1.0*25.4;	// Sheave shaft dia

bb_pocket_dia = mag_cyl_dia + .4; 
bb_pocket_ht = mag_cyl_ht + .4 + 20;

bb_center_hole_dia = mag20_stud_dia + 0.5;

tw_dia = 22.2 + 0.5;	// Top washer diameter
tw_thick = 2.2 + 0.65;	// Top washer thickness
tw_dia_in = 9.6 - 0.5; // Top washer hole
tw_depth = 2;	// Depth of washer below top surface

module base()
{
  pk_ofs_x  = bb_sq/2 - 5;
  pk_ofs_y  = bb_sq/2 - 5;
  pk_ofs_z = 0.6;

  difference()
  {
    rounded_rectangle(bb_sq,bb_sq,bb_thick,bb_rad);

    // Magnet inserts
    union()
    {
       translate([pk_ofs_x,pk_ofs_y,pk_ofs_z])
         cylinder(d = bb_pocket_dia,h = bb_pocket_ht, center=false);

       translate([-pk_ofs_x,-pk_ofs_y,pk_ofs_z])
         cylinder(d = bb_pocket_dia,h = bb_pocket_ht, center=false);

       translate([pk_ofs_x,-pk_ofs_y,pk_ofs_z])
         cylinder(d = bb_pocket_dia,h = bb_pocket_ht, center=false);

       translate([-pk_ofs_x,pk_ofs_y,pk_ofs_z])
         cylinder(d = bb_pocket_dia,h = bb_pocket_ht, center=false);
    }
  }

  cylinder(d = bb1_dia, h = bb1_ht, center = false);

  cylinder(d = bb2_dia, h = bb2_ht, center = false);
  
  cylinder(d = bb3_dia, h = bb3_ht, center = false);

  cylinder(d = bb4_dia, h = bb_ht, center = false);

}


module total()
{
   difference()
   {
      base();

      union()
      {
         cylinder(d = bb_center_hole_dia, h = bb_ht + 0.1, center = false);

         translate([0,0, (bb_ht-tw_thick-tw_depth)])
           cylinder(d = tw_dia, h = tw_thick, center=false);
      }
   }
echo (bb_ht-tw_thick-tw_depth);
echo (bb_ht-tw_depth);
}
total();
