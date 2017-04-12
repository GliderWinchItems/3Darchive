/*
/* File: cwV_base.scad
 * Mag-mount base for cwV_fixture.scad box
 * Author: deh
 * Latest edit: 20170409
 */

 $fn=20;

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>

// PC board dimensions
pc_slop = 4;
pcwid = 49.6 + pc_slop;	// Width of PC board
pclen = 83.0 + pc_slop;	// Length of PC board
pcthick = 1.7;	// Thickness of board

// Magnet positioning
 mag_spacing_y	= 52;	// Distance y +/- to magnets
 mag_spacing_x	= 45;	// Distance x: magnet to y-axis mag pair C/L
 mag_ofs = -45;		// Position triangular base under enclosure box

 // Thickness of base for washer recess
 mag_stud_z = (mag_washer_thick +mag_nut_thick);
 mag_wash_recess_z = mag_stud_len - mag_stud_z;    
 mag_wash_recess_dia = mag_washer_dia + mag_washer_dia_extra;

module tube(d1,d2,ht)
{
   difference()
   {
     cylinder(d = d1, h = ht, center = false);
     cylinder(d = d2, h = ht + .001, center = false);
   }
}
module mag_mnt_bar(d1, d2, len, ht)
{
   difference()
   {
     union()
     {
        cylinder(d = d1, h = ht, center = false);
        translate([-len, -d1/2, 0])
           cube([len, d1, ht]);
     }
       cylinder(d = d2, h = ht + .001, center = false);
   }
    
}
mm_bar_len = 55;  // Mag mount bar end length
mm_bar_wid = 12; // Mag mount bar width
mm_theta =  atan(mag_spacing_x/mag_spacing_y);    

module corner_bars(cb_rotate)
{
     rotate(cb_rotate,0,0)
        mag_mnt_bar(mm_bar_wid,mag_stud_dia, mm_bar_len +1, base_thick);
//echo (mm_theta);
}

module mag_mts()
{
   translate([0,0,0])
   {
     corner_bars(mm_theta + 90);
     corner_bars(-(mm_theta + 90));
   }
   translate([mag_spacing_x,mag_spacing_y,0])
   {
     corner_bars(90 - mm_theta);
     corner_bars(90);
   }
   translate([mag_spacing_x,-mag_spacing_y,0])
   {
     corner_bars(mm_theta + 270);
     corner_bars(-90);
   }
   // Fill in base
   translate([45,-45,0])
    rotate([0,0,90])
       triangle(60,60,90,base_thick);
}

// Tabs for holding pc board cover down
bt_wid = 18;
bt_hole_dia = 3.2;  // Screw hold dia
bt_thick = 4;	// Thickness
bt_len = 12;	// Length
bt_w_ht = 7;	// Stiffner height

module brd_tab()
{
   mag_mnt_bar(bt_wid, bt_hole_dia, bt_len, bt_thick);
   translate([-(bt_len - bt_len) ,(bt_wid/2 - bt_thick),bt_thick])
      rotate([0,0,90])
         wedge(bt_thick,bt_len,bt_w_ht);
   translate([-(bt_len - bt_len) ,-(bt_wid/2),bt_thick])
      rotate([0,0,90])
         wedge(bt_thick,bt_len,bt_w_ht);
}

// Base
base_thick 	= 2.0;	// Thickness of base
base_rad	= 10;	// Radius around mags
base_x		= mag_spacing_x + 2*base_rad;
base_y		= mag_spacing_y + 2*base_rad;

shell_wall = 2;	// Enclosure wall thickness
shell_ht = 25 + 5;	;	// Enclosure wall height

shell_x = pcwid + 2*shell_wall;
shell_y = pclen + 2*shell_wall;

shell_tab = 10;
tab_rad = 6;
tab_thick = 2;
spacer_thick = 5;	// Spacer between magnet base and box


module pc_shell()
{

 // Tab for mounting box to magnet base

 difference()
 {
   union()
   {
      // Full length plate
      translate([shell_x+spacer_thick, 0, shell_ht/2+base_thick/2])
       rotate([0,-90,0])
        rotate([0,0,90])
        rounded_rectangle((shell_y+2*shell_tab), shell_ht-2*base_thick,tab_thick,tab_rad);
   }
   union()
   {
     // Cutout for CAN cables 
     translate([50,-25,shell_ht+6])
       rotate([0,90,0])
         rounded_rectangle(15,15,25,4);

   }
 }
}

module tab_hole()
{
   rotate([0,90,0])
    cylinder(d=mag_stud_dia, h=40, center= false);
}

// Rear mag_mount
rm_len = 10;
rm_thick = 4;
rm_x1 = 15;
rm_dia = 10;

module rear_mag_mount()
{
/* ***** eyebar *****
 * rounded bar with hole in rounded end
 * d1 = outside diameter of rounded end, and width of bar
 *d2 = diameter of hole in end of bar
eye_bar(d1, d2, len, ht);
*/
   translate([-rm_x1,0,0])
     eye_bar(rm_dia,mag_stud_dia,rm_len,rm_thick);

/* ***** triangle *****
 * l1 = side 1
 * l2 = side 2
 * l3 = side 3
 * h  = height/thickness
module triangle(l1,l2,l3,h)
*/
echo(shell_y);
   translate([5,-shell_y/2,0])
    rotate([0,0,90])
     triangle(50,50,shell_y,rm_thick);
     
}

module total()
{
  difference()
  {
    union()
    {
      translate([0,0,shell_x+spacer_thick])
       rotate([0,90,0])
        pc_shell();
      rear_mag_mount();
    }
    union()
    {
translate([0,0,0])
 ps_cutout();

    }
  }
}

total();


