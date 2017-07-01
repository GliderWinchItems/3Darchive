/* Washers for holding board edges
 * File: cap_strip.scad
 * Author: deh
 * Latest edit: 201701292040
*/

$fn = 50;

screw_dia = 2.78;	// Dia of threads
screw_dia_head = 4.8;	// Dia of screw (pan) head
strip_thick = 1.75;
strip_width = 8.9;
strip_1stofs= 5.4;	// 1st hole offset
strip_length = 14;

wx = strip_width/2;

module strip()
{
   difference()
   {
      union()
      {
         cube([strip_width, strip_length, strip_thick], false);
      }

      union()
      {
         translate([wx, strip_1stofs, -0.01])
           cylinder(d = screw_dia, h = strip_thick + .02, center=false);
 /*        translate([wx, strip_space + strip_1stofs, -0.01])
           cylinder(d = screw_dia, h = strip_thick + .02, center=false);
*/
      }
   }


}


module strip2()
{
   difference()
   {
      union()
      {
         translate([0,0,-strip_thick])
            cube([strip_width, strip_length, strip_thick], false);

      }

      union()
      {
         translate([wx, strip_1stofs, -0.01])
           cylinder(d = screw_dia, h = strip_thick + .02, center=false);
         translate([wx, strip_space + strip_1stofs, -0.01])
           cylinder(d = screw_dia, h = strip_thick + .02, center=false);
      }
   }


}

module strips()
{
   translate([0,0,0])
     rotate([0,180,0])strip();

   translate([15,0,0])
     rotate([0,180,0])strip();

}

strips();
