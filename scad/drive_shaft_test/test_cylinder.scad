/* test_cylinder.scad
 * Test stand simulate drive shaft 
 * Date: 20170510
 */

include <test_common.scad>

$fn = 200;


module screw_hole()
{
  translate([tshaft_dia/2 - ms_wall - 1, 0,0])
   rotate([0,90,0])
    cylinder(d = screw_hole_dia, h = 20, center = false);
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

module drive_shaft()
{
  difference()
  {
     cylinder(d = tshaft_dia, h = tshaft_len, center = false);
     union()
    {
      cylinder(d = ms_shaft_dia, h = tshaft_len+1, center = false);

      translate([0,0,ms_shaft_len1])
         cylinder(d = ms_end_dia, h = tshaft_len+1, center = false);  

      translate([0,0,tshaft_len - ms_screw_hole_depth])
         screw_pattern();
    }
  }
}

drive_shaft();

