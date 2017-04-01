/* pod-insert2.scad
   POD #2 spacer ring
   - Spacer between electronics insert and endbell
   - Slit allows passing cables to inside of ring
     when inserting into bottle.

   03/31/2017
*/

include <../library_deh/deh_shapes.scad>

dia_od = (105); // diameter (inside of bottle)

thick_sides = 5;

$fn = 200;

/* Height of insert to accommodate cables between
   electronics insert and endbell bottom */
side_ht = 11;	// Height of insert

/* chamfer to make insertion easy */
chfm_ht = 4;
chfm_wid = 3;
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
    translate([dia_od/2-2*thick_sides,0,-0.01])
        cube([2*thick_sides+4,0.5,side_ht+.02],center=false);
   }
  }
}


module total()
{
   difference()
   {
      union()
      {
         insert();
      }
      union()
      {
         pc_board();	// PC board pocket  
         battery();     // Battery pocket
         rotate([0,0,-45])
           cable_gps_cutout(); // GPS cable groove
         cable_lc_cutout();    // Load-cell cable hole
      }
   }
}
total();


