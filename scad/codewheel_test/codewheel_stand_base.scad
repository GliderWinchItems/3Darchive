/* Base to raise height of test stand for encoder
*  File: codewheel_stand_base.scad
 * Author: deh
 * Latest edit: 201702241551\
*/

include <../library_deh/deh_shapes.scad>

$fn = 100;


// base 
base_thick = 55; // Height to raise fixture above mtg board
base_x = 80;
base_y = 35;

module base($fn=50)
{
  translate([0,-base_y/2,0])
    cube([base_x, base_y, base_thick]);
}
tab_x = 10; 	// tab length
tab_od = 18;  	// Outer dia of tab rounded end
tab_hole = 3.3;	// Dia of hole in tab

module tabs()
{
//   Tabs on base
     translate([-tab_x,0,0])
      rotate([0,0,0])
           eye_bar(tab_od, tab_hole, tab_x, 4);
     translate([base_x+tab_x-.01,0,0])
        rotate([0,0,180])
           eye_bar(tab_od, tab_hole, tab_x, 4);
  
}

// Holes in top for screws to attach fixture
corner_dia = 2.8;	// Corner hole dia
corner_depth = 25;	// Depth of hole
corner_ofs = 3;		// Offset from edges at corner

module corner_holes()
{
   translate([corner_ofs,base_y/2-corner_ofs,base_thick-corner_depth])
     cylinder(d = corner_dia, h = corner_depth, center = false);

   translate([corner_ofs,-base_y/2+corner_ofs,base_thick-corner_depth])
     cylinder(d = corner_dia, h = corner_depth, center = false);

   translate([base_x-corner_ofs,base_y/2-corner_ofs,base_thick-corner_depth])
     cylinder(d = corner_dia, h = corner_depth, center = false);

   translate([base_x-corner_ofs,-base_y/2+corner_ofs,base_thick-corner_depth])
     cylinder(d = corner_dia, h = corner_depth, center = false);

}
hlw_bot = 10;
hlw_ht = base_thick - hlw_bot;
hlw_wall = 6;

module hollow()
{
  translate([hlw_wall,-base_y/2+hlw_wall,hlw_bot])
     cube([base_x-(2*hlw_wall), base_y-(2*hlw_wall), base_thick]);
}
module total()
{
   difference()
   {
      base();     
      union()
      {
         corner_holes();
         hollow();
      }
   }

   tabs();
}

total();
