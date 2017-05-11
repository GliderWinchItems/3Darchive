/* test_cylinder_end.scad
 * Test stand simulate drive shaft, end piece
 * Date: 20170510
 */

include <test_common.scad>

$fn = 200;

module screw_hole()
{
  translate([tshaft_dia/2 - ms_wall, 0,0])
   rotate([0,90,0])
    cylinder(d = screw_self_dia, h = 20, center = false);
}

module screw_pattern()
{
      step = 360/nscrews;
      for (i = [0 : step : 360])
      {
        rotate([0,0,i])
          screw_hole();   
      }  
}

/* ***** circular chamfer *****
 * d = outer diameter
 * rad = chamfer radius
 * circular_chamfer(d, rad);
*/

module drive_shaft()
{
  difference()
  {
     union()
     {
       // Lip
       cylinder(d = tshaft_dia, h = ms_end_thick, center = false);

     // inside
     od = tshaft_dia - ms_wall;
     id = od - me_wall;
       translate([0,0,ms_end_thick])
        tubedeh(od,id,me_wall_ht);
    }
     union()
    {
      cylinder(d = me_rod_dia, h = 20, center = false);  

      translate([0,0,ms_screw_hole_depth + ms_end_thick])
         screw_pattern();

      translate([0,0,ms_end_thick + me_wall_ht - 0.1])
        rotate([0,180,0])
          circular_chamfer(tshaft_dia - ms_wall,2);

    }
  }

}
drive_shaft();

