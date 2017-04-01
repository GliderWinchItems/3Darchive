/* pod-insert3.scad
   POD #2 electronics holders:  GPS spacer
   03/15/2017
*/
include <../library_deh/deh_shapes.scad>

dia_od = (105); // diameter (inside of bottle)

thick_sides = 12;

$fn = 200;

side_ht = 18;	// Height of insert

chfm_ht = 8;
chfm_wid = 2;
module chamfer()
{
     // Sides with chamfer at bottom edge
//    difference()
     {
        cylinder(h = chfm_ht, 
           r1 = dia_od/2-chfm_wid, 
           r2 = dia_od/2, 
           center = false);
     }
 }

module insert()
{

  difference()
  {
   union()
    {
      translate([0,0,chfm_ht])
        cylinder(d = dia_od, h = side_ht-chfm_ht, center = false);
      chamfer();
    }
   union()
   {
      translate([0,0,-0.01])
        cylinder(d = dia_od-2*thick_sides, h = side_ht+10, center = false);
   }
  }
}

module total()
{
    insert();
}

total();


