/* Block to home motor holder
*  File: test_mtr_stand.scad
 * Author: deh
 * Latest edit: 20170510
 * v1 add small wire hole
 * v2 add post/wedge for center hole
*/
include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <../drive_shaft/ds_common.scad>
include <test_common.scad>

$fn = 100;

//
mb_thick = 4;
mb_y = base_x;
mb_x = base_x + 2 * mb_thick + 8;
mb_z = ctr_line_ht + base_y/2 + 9;

tab_rad = 15;
tab_hole = 3.3;
tab_len = 10;

// **** Id the part ***
module id()
{
 translate([-10,20,0])
 {
  font = "Liberation Sans:style=Bold Italic";
    translate([0, 6, mb_thick]) 
      linear_extrude(0.5)
        text("test_mtr_stand",size = 3);

    translate([0,0, mb_thick]) 
      linear_extrude(0.5)
        text("2017 05 11 v2",size = 3);
 }
}

mot_dia = 27.6;
mot_len = 40;
mot_lead_clear = 12;
mot_shft_dia = 4.8;

mt_ht = mot_len + mot_lead_clear;
mt_thick = 2;
mt_chamfer = 1;
mt_ch_ht = 4;
mt_cutout = 6.5;
mt_space_ht = mot_lead_clear;
mt_space_thick = 3;
mt_space_len = 5;




mt1x = mot_dia/2;		mt1y = 0;
mt2x = mot_dia/2 + mt_thick;	mt2y = 0;
mt3x = mot_dia/2 + mt_thick;	mt3y = mt_ht;
mt4x = mot_dia/2 + mt_thick - mt_chamfer; mt4y = mt_ht;
mt5x = mot_dia/2;		mt5y = mt_ht - mt_ch_ht;



module mtr_block()
{
  translate([-mb_x/2,0,])
  {
    // Base
    cube([mb_x, mb_y, mb_thick], center = false);

    // Sides
    translate([0,0,mb_thick])
      wedge(mb_thick,mb_y,mb_z);

    translate([mb_x - mb_thick,0,mb_thick])
      wedge(mb_thick,mb_y,mb_z);
  }

  // Mounting tabs
  mnt_tabs();
}

module mnt_tabs()
{
  translate([-mb_x/2 - tab_len + 0.1,mb_y - tab_rad/2,0])
     eye_bar(tab_rad, tab_hole,tab_len, mb_thick);

   translate([mb_x/2 + tab_len - 0.1,mb_y - tab_rad/2,0])
    rotate([0,0,180])
     eye_bar(tab_rad, tab_hole,tab_len, mb_thick);

   translate([0,0 - tab_len,0])
    rotate([0,0,90])
     eye_bar(tab_rad, tab_hole,tab_len, mb_thick);

   translate([mb_x/2,mb_y,mb_thick - .05])
    rotate([90,0,0])
     fillet(4, tab_rad);

   translate([-mb_x/2,mb_y - tab_rad,mb_thick - .05])
    rotate([0,0,180])
    rotate([90,0,0])
     fillet(4, tab_rad);
}

module front_plate()
{
  translate([-mb_x/2,mb_y - mb_thick, 0])
   cube([mb_x,mb_thick,ctr_line_ht + base_y/2], center = false);

  translate([5,mb_y-mb_thick-20,ctr_line_ht])
   rotate([0,180,0])
    wedge(10,20,20);

  translate([-5,mb_y-mb_thick-20,ctr_line_ht])
    cube([10,20,3],center=false);
}

module clip_top()
{
   translate([-mb_x/2 - 1, mb_y-mb_thick - 1,ctr_line_ht + base_y/2])
     cube([mb_x+10, mb_thick+5,mb_z]);

}

module base($fn=50)
{
    cube([base_x, base_y, base_thick]);
}

sh_dia = 3.3;	// Screw hole diameter
sh_ofs = 4;	// Offset from edge

module screw_holes()
{
 translate([0,mb_y+1,ctr_line_ht - base_x/2])
 rotate([90,0,0])
 {
  translate([-base_x/2,0,0])
  {
   translate([sh_ofs,sh_ofs,0])
    cylinder(d = sh_dia, h = 10, center = false);

   translate([base_x - sh_ofs,sh_ofs,0])
    cylinder(d = sh_dia, h = 10, center = false);

   translate([sh_ofs,base_y - sh_ofs,0])
    cylinder(d = sh_dia, h = 10, center = false);

   translate([base_x - sh_ofs,base_y - sh_ofs,0])
    cylinder(d = sh_dia, h = 10, center = false);

   // Rod/shaft in center supports non-motor end
   translate([base_x/2,base_y/2,0])
    cylinder(d = me_rod_dia, h = 40, center = false);
   
  }
 }
}

module total()
{

   difference()
   {
     union()
     {
       mtr_block();  
       front_plate();
       id();

     }
     union()
     {
        screw_holes();   
        clip_top();

     }
   }
}

total();
