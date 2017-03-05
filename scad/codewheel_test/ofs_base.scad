/* Offset base 
*  File: ofs_base.scad
 * Author: deh
 * Latest edit: 201702072016
*/




include <../library_deh/deh_shapes.scad>



$fn = 100;

// PC board dimensions
pc_slop = 4;
pcwid = 49.6 + pc_slop;	// Width of PC board
pclen = 83.0 + pc_slop;	// Length of PC board
pcthick = 1.7;	// Thickness of board

 mag_spacing_y	= 42;		// Distance y +/- to magnets
 mag_spacing_x	= 69;		// Distance x: magnet to y-axis mag pair C/L

// Base
bbase_thick 	= 4.0;	// Thickness of base
bbase_rad	= 10;	// Radius around mags
bbase_x		= mag_spacing_x + 2*bbase_rad;
bbase_y		= mag_spacing_y + 2*bbase_rad;

shell_wall = 2;	// Enclosure wall thickness
shell_ht = 25 + 5;	;	// Enclosure wall height

shell_x = pcwid + 2*shell_wall;
shell_y = pclen + 2*shell_wall;


// Base plate
base_x = 82;    // Length
base_y = 85;    // Width
base_thick = 27.5;// Thickness
base_rad = 20;	// Radius of corners
bb = 5;

screw_dia = 2.7;
screw_len = 15;

module total()
{
  difference()
  {
   union()
   {
      rounded_triangle(
        base_x+bb,
        base_x+bb,
        base_y+bb,
        base_thick+bb,base_rad+bb);
//   Tabs on base
     translate([0,45,0])
        rotate([0,0,-32])
           eye_bar(18, 3.3, 20, 4);
     translate([92,45,0])
        rotate([0,0,180+32])
           eye_bar(18, 3.3, 20, 4);
   }
   union()
   {
     translate([bb/2,bb/6,base_thick])
        rounded_triangle(base_x,base_x,base_y,base_thick,base_rad);
     translate([bb/2+shell_y+15,6,base_thick])
        rotate([0,0,90])
           cube([shell_x+5,shell_y+60,base_thick],false);
     // Screw holes
     translate([bb/2,0,base_thick-screw_len])
       cylinder(d = screw_dia, h = screw_len, center = false);
     translate([42*2+bb/2,0,base_thick-screw_len])
       cylinder(d = screw_dia, h = screw_len, center = false);
     translate([(42*2+bb/2)/2,69,base_thick-screw_len])
       cylinder(d = screw_dia, h = screw_len, center = false);
   }
  }


}

total();
