/* Washers for holding board edges
 * File: cap_strip.scad
 * Author: deh
 * Latest edit: 201701292040
*/

$fn = 50;

screw_dia = 2.78;	// Dia of threads
screw_dia_head = 4.8;	// Dia of screw (pan) head
strip_thick = 1.75;
strip_width = 9;
strip_space = 46;	// Spacing between mounting holes
strip_1stofs= 5.5;	// 1st hole offset
strip_postwid= 5.1;	// Post width
strip_length= strip_space + strip_1stofs + strip_postwid;
stiff_len = 39;
stiff_wid = 4.5;
stiff_thick = 2.5;

module strip()
{
   difference()
   {
      union()
      {
         cube([strip_width, strip_length, strip_thick], false);
         translate([4.2,
                   strip_1stofs + strip_postwid/2 + 0.5,
                   0])
           rotate([0,90,0])
             cube([stiff_wid,stiff_len,stiff_thick], false);
         translate([ -9, 
                     strip_space + strip_1stofs  - strip_postwid/2 - 4.2,
                     0])
             cube([10.5, strip_width, strip_thick], false);
      }

      union()
      {
         translate([6.0, strip_1stofs, -0.01])
           cylinder(d = screw_dia, h = strip_thick + .02, center=false);
         translate([6.0, strip_space + strip_1stofs, -0.01])
           cylinder(d = screw_dia, h = strip_thick + .02, center=false);
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

         translate([4.2,
                   strip_1stofs + strip_postwid/2 + 0.5,
                   stiff_wid])
           rotate([0,90,0])
             cube([stiff_wid,stiff_len,stiff_thick], false);

         translate([ -9, 
                     strip_space + strip_1stofs  - strip_postwid/2 - 4.2,
                     -strip_thick])
             cube([10.5, strip_width, strip_thick], false);
      }

      union()
      {
         translate([6.0, strip_1stofs, -0.01])
           cylinder(d = screw_dia, h = strip_thick + .02, center=false);
         translate([6.0, strip_space + strip_1stofs, -0.01])
           cylinder(d = screw_dia, h = strip_thick + .02, center=false);
      }
   }


}

module strips()
{
   translate([10,0,0])
     rotate([0,180,0])strip();
   translate([-2,42,0])
     rotate([0,0,180])strip2();
}

strips();
