/*
/* File: cwV_fixture.scad
 * Photocell sensor magnet mount for sheave codewheel
 * Reflective photosensors version, (V = vertical)
 * Author: deh
 * Latest edit: 20170408
 */

 $fn=100;

include <../library_deh/deh_shapes.scad>

 module wedge(l, w, h)
 {
   polyhedron(
      points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
       faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]] );
 }

// PC board dimensions
pc_slop = 4;
pcwid = 49.6 + pc_slop;	// Width of PC board
pclen = 83.0 + pc_slop;	// Length of PC board
pcthick = 1.7;	// Thickness of board

// Magnet mount dimensions
include <../library_deh/mag_mount.scad>

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

module pc_shell()
{

   // Base plate
   translate([0,-shell_y/2,0])
   cube([shell_x,shell_y,base_thick],false);

   // Wall: +y end
   translate([0, shell_y/2 - shell_wall,base_thick])
     cube([shell_x, shell_wall, shell_ht]);

   // Wall: -y end 
 //  difference()
//   {
      translate([0, -shell_y/2,base_thick])
        cube([shell_x, shell_wall, shell_ht]);
//      translate([shell_x - 12, -shell_y/2,base_thick])
// 	cable_cutout();
//   }

   // Wall: x=0 side
   translate([0, -shell_y/2, base_thick])
   {
     cube([shell_wall, shell_y, shell_ht]);
   }

   // Tab for mounting box to magnet base
/* ***** rounded_rectangle ******
l = length (x direction)
w = width (y direction)
h = thickness (z direction)
rad = radius of corners
reference = center of rectangle x,y, bottom 
*/
tab_thick = 2;

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
     // Mounting holes
     translate([shell_x-tab_thick-10, (shell_y+2*shell_tab)/2, 0])
        translate([0,-tab_rad,tab_rad]) tab_hole();

     translate([shell_x-tab_thick-10, -(shell_y+2*shell_tab)/2, 0])
        translate([0, tab_rad,tab_rad]) tab_hole();

     translate([shell_x-tab_thick-10, (shell_y+2*shell_tab)/2,shell_ht + base_thick])
        translate([0,-tab_rad,-tab_rad]) tab_hole();

     translate([shell_x-tab_thick-10,-(shell_y+2*shell_tab)/2,shell_ht + base_thick])
        translate([0, tab_rad,-tab_rad]) tab_hole();


   }
 }

   // Spacer between box and magnet base 
spacer_thick = 5;	// Spacer between magnet base and box
cover_depth = 11.5;	// Width/depth of cover lip over box
   translate([shell_x, -shell_y/2, 0])
   {
     cube([spacer_thick, shell_y, shell_ht-cover_depth]);
   }

   // Wall: +x side
   difference()
   {
      translate([shell_x - shell_wall, -shell_y/2, base_thick])
        cube([shell_wall, shell_y, shell_ht]);
      translate([shell_x - 12, -shell_y/2,base_thick])
       rotate([0,0,90])
 	cable_cutout();
   }

   // Posts for screw mounting of pc board
   translate([pcps_ofs_x+pc_slop/2,pcps_ofs_y,base_thick]) pc_posts4();

   // Tabs for mounting top cover
   translate([shell_x/2,-(shell_y/2 + bt_len - shell_wall),shell_ht - 7.5])
     rotate([0,180,90])
        brd_tab();
   translate([shell_x/2,(shell_y/2 + bt_len - shell_wall),shell_ht - 7.5])
     rotate([0,180,-90])
        brd_tab();

}

module tab_hole()
{
   rotate([0,90,0])
    cylinder(d=mag_stud_dia, h=40, center= false);
}


// PC board mounting
 pcps_space_y = 25.4;  	// Distance between holes lengthwise
 pcps_space_x = 38.4;  	// Distance between holes across board 
 pcps_frm_top = 29.0;  	// Top hole from top of board
 pcps_frm_side = 6.3;	// side to hole
 pcps_post_dia = 7.0;	// Post diameter

 pcps_screw_dia = 2.6;	// Screw diameter
 pcps_screw_ht = 5;	// Screw thread length

 pcps_post_ht = 5;
 pcps_ofs_y = pclen/2 - pcps_frm_top;
 pcps_ofs_x = shell_wall + pcps_frm_side;

module pc_posts_pair()
{
   tube(pcps_post_dia,pcps_screw_dia,pcps_post_ht);
   translate([0,-pcps_space_y,0])
      tube(pcps_post_dia,pcps_screw_dia,pcps_post_ht);
}

module pc_posts4()
{
   pc_posts_pair();
   translate([pcps_space_x,0,0])
     pc_posts_pair();
}

// CAN bus cable cutout in wall
cc_wid = 6.5;		// Telephone type cable width
cc_thick = 10;	// Thickness
cc_frm_top =  5;		// Offset from top of side
cc_frm_side = 8;	// Offset from side
cc_sense_dia = 4;	// Sensor cable dia



module cable_cutout()
{
 cc_ofs_z = shell_ht - cc_frm_top + cc_thick/2;
 cc_ofs_x = 20;
 cc_ofs_y = -25;
   // Two telephone type cables
   translate([cc_ofs_x,cc_ofs_y,cc_ofs_z])
    rotate([0,90,90])
     rounded_rectangle(cc_thick,cc_wid,20,1.5);


/*   // Sensor wires
   translate([cc_frm_side+cc_wid/2, shell_wall+.02,shell_ht-cc_ofs_z])
     rotate([90,0,0])
       cylinder(d = cc_sense_dia,h = shell_wall+.05, center = false);
*/
}

module round_ridge(dia,len,ht)
{
   translate([dia/2,dia/2,ht])
    rotate([-90,0,0])
    cylinder(d = dia, h = len - dia - 8,center = false);

}

module rounded_line_ridge(rad, len, ht)
{
   translate([0,rad,ht])
   { 
     rotate([-90,0,0])
     {
       difference()
       {
         translate([0, 0, -rad/2rad])
           minkowski()
           {
             sphere(rad);
             cylinder(h = len, 
                      r = rad*(1/16),
                      center = false);
           }
         translate([-rad*2,0,-rad])
           cube([rad*4, rad*2, len+2*rad],false);
       }
     }
   }
   translate([-rad,0,0])cube([rad*2,len+rad,ht]);
}

module rounded_rect_ridge(w,l,h)
{
   translate([-w/2,0,0])
      rounded_line_ridge(w/2,l-w,h);

}

   // Cutout for reflective photosensors
module ps_cutout()
{
  ps_wid = 4.7;	// Width of photosensor
  ps_len = 6.5;	// Length of photosensor
  ps_ht = 50;	// Punch through everything with big number
  ps_space = 0;	// Spacing between (9.8 pc board layout)
  ps_ofs_y = 24;	// Offset from board edge to side of photosensor
  ps_ofs_x = 13;	// Offset from board edge to bottom of photosensor
  ps_ofs_xx = pcwid + shell_wall - ps_ofs_x -ps_len;
  ps_ofs_yy = pclen/2 - ps_wid - ps_ofs_y;
   translate([ps_ofs_xx,ps_ofs_yy,-20])
     cube([ps_len,ps_wid,ps_ht],center=false);

  ps_ofs_yyy = ps_ofs_yy - ps_space - ps_wid;
   translate([ps_ofs_xx,ps_ofs_yyy,-20])
     cube([ps_len,ps_wid,ps_ht],center=false);

}

module total()
{
  difference()
  {
    union()
    {
      translate([0,0,0])
        pc_shell();
    }
    union()
    {
translate([0,0,0])
 ps_cutout();

    }
  }

}

total();


