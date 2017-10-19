/* scad/generator/shaft_adapthx.scad
 * Magnet stud to flex coupline for encoder
 * Date of latest: 20171018
 * Adaptor fits over hex bolt on end of armature shaft
 */

include <generator_common.scad>
include <../library_deh/deh_shapes.scad>

$fn = 100;


flex_id = 6;	// Inside diameter of flexible tube
flex_len = 8;	// Length adapter inserts into tubing

bl_ht = 6;	// Guess at it
bl_dia = bl_peaks + 0.4;

mm_ht12 = bl_ht + 6;
mm_ht23 = mm_ht12 + 7;
mm_ht34 = 2;
mm_ht45 = flex_len;
mm_ht56 = 1;


mm_dia1 = eb_post_id - 0.8;;	
mm_dia4 = flex_id;
mm_dia5 = flex_id;
mm_dia6 = flex_id - 2;


module post()
{
   // Inside endbell
   translate([0,0,0])
     cylinder(d = mm_dia1, h = mm_ht12, center=false);

   // Transition from inside endbell to small post
   translate([0,0,mm_ht12])
     cylinder(d1 = mm_dia1, d2 = mm_dia4, h = mm_ht34, center=false);
   
   // shaft that inserts into flexible tubing
   translate([0,0,mm_ht12+mm_ht34])
     cylinder(d = flex_id, h = mm_ht45, center=false);

   // Chamfer for inserting into tube
   translate([0,0,mm_ht12+mm_ht34+mm_ht45])
     cylinder(d1 = mm_dia5, d2 = mm_dia6, h = mm_ht56, center=false);
}

module holes()
{

  // Hex bolt head
    cylinder(d = bl_dia, h = bl_ht, center= false, $fn = 6);
}


module total()
{
  difference()
  {
    union()
    {
      post();
    }
    union()
    {
      holes();
    }
  }
}
total();
