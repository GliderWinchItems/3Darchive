/*
/* File: cwV_fixture.scad
 * Photocell sensor magnet mount for sheave codewheel
 * Reflective photosensors version, (V = vertical)
 * Author: deh
 * Latest edit: 20170408
 */

 $fn=20;

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



// Magnet mounts
 mag_thick = 4.82;	    // Magnet thickness (base to shell top)
 mag_shell_dia = 16.0;	    // Magnet shell OD
 mag_stud_dia = 2.8;        // Dia of mounting magnet studs (4-40)
 mag_stud_len = 7.95;       // Height of stud from magnet back
 mag_washer_thick = 1.1;    // Thickness of washer
 mag_nut_thick = 2.4;       // Nut for stud thickness
 mag_washer_dia = 9.5;      // Diameter of washer for magnet stud
 mag_washer_dia_extra = 2;  // Washer slop
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
base_thick 	= 4.0;	// Thickness of base
base_rad	= 10;	// Radius around mags
base_x		= mag_spacing_x + 2*base_rad;
base_y		= mag_spacing_y + 2*base_rad;

shell_wall = 2;	// Enclosure wall thickness
shell_ht = 25 + 5;	;	// Enclosure wall height

shell_x = pcwid + 2*shell_wall;
shell_y = pclen + 2*shell_wall;

module pc_shell()
{

   // Base plate
   translate([0,-shell_y/2,0])
   cube([shell_x,shell_y,base_thick],false);

   // Wall: +y end
   translate([0, shell_y/2 - shell_wall,base_thick])
     cube([shell_x, shell_wall, shell_ht]);
//     rotate([0,0,-90])
//     rounded_rect_ridge(shell_wall, shell_x, shell_ht);

   // Wall: -y end 
   difference()
   {
      translate([0, -shell_y/2,base_thick])
        cube([shell_x, shell_wall, shell_ht]);
      translate([0, -shell_y/2,base_thick])
 	cable_cutout();
   }

   // Wall: x=0 side
   translate([0, -shell_y/2, base_thick])
   {
     cube([shell_wall, shell_y, shell_ht]);
//       round_ridge(shell_wall,shell_y, shell_ht);
   }

   // Wall: +x side
   translate([shell_x - shell_wall, -shell_y/2, base_thick])
     cube([shell_wall, shell_y, shell_ht]);

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


 // Photo interruptor - Sharp GP1A57HRJ00F
 ph_slot_ht = 10;  // Width of sloth for encoder wheel
 ph_body_width = 5;// Width of body
 ph_body_ht = 18.6;// Height of body
 ph_slot_y = 3;    // Base to beginning of slot
 ph_slot_x = 15.2; // Base to end of slot

 // Bearing and shaft
 bs_ht = 43;	// Height of end of sheave shaft above fairlead base
 
 // Encoder wheel position
 ew_edge_thick = 1.6;
 ew_ht = 11.5;	// base of magnet to top of encoder wheel

 // Encoder wheel centerline from base of fixture
 ew_top_z = (bs_ht + ew_ht) - (mag_thick + ew_edge_thick/2);

 // Slotted panel for mounting photointerrupter carrier
 mp_thick = 4;	// Thickness of upright mounting panel
 mp_len = 30;	// Upright panel length
 mt_adj = 5;	// +/- up/down adjustment
 

 // Position of panel with respect to base
 mp_ofs_x = mag_spacing_x + mm_bar_wid/2 - mp_thick;

// Upright panel height
 mp_ht = ew_top_z + ph_body_ht/2 + mt_adj;

// Slotted panel
 sp_wid1 = 5;
 sp_slot = 3.5;
 sp_wid2 = 5;
 sp_cutout = 2 * (ph_body_width + 4);
 sp_ofs_y = sp_wid1 + sp_wid2 + sp_slot + sp_cutout/2;

module slotted_panel()
{
   cube([mp_thick, sp_wid1, mp_ht], false);
   translate([0,sp_wid1 + sp_slot, 0], false)
      cube([mp_thick, sp_wid2, mp_ht], false);


}

module fillet_qtr_circle(fq_rad,fq_ht)
{
   difference()
   {
      union()
      {
         translate([0,-fq_rad,0])
           cube([fq_rad,2*fq_rad,fq_ht],false);
      }
      union()
      {
         translate([0,0,-0.001])
           cylinder(d = fq_rad*2,h = fq_ht+.002, center = false);
         translate([-fq_rad,-fq_rad,-.001])
           cube([fq_rad+.002,2*fq_rad+.002,fq_ht+.002],false);
         translate([-fq_rad-.001,-fq_rad-.001,-.001])
           cube([2*fq_rad+.002,fq_rad+.002,fq_ht+.002],false);
      }
   }

}


// CAN bus cable cutout in wall
cc_wid = 6.5;		// Telephone type cable width
cc_thick = 2.25;	// Thickness
cc_frm_top = 3;		// Offset from top of side
cc_frm_side = 8;	// Offset from side
cc_sense_dia = 4;	// Sensor cable dia

cc_ofs_z = cc_thick*2 + cc_frm_top;

module cable_cutout()
{
   // Two telephone type cables
   translate([cc_frm_side,-.01,shell_ht-cc_ofs_z])
     cube([cc_wid, shell_wall+.02 ,cc_ofs_z],false);

   // Sensor wires
   translate([cc_frm_side+cc_wid/2, shell_wall+.02,shell_ht-cc_ofs_z])
     rotate([90,0,0])
       cylinder(d = cc_sense_dia,h = shell_wall+.05, center = false);

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

module total()
{
   translate([mag_ofs,0,0])
     mag_mts();
   rotate([0,-90,0])
      translate([3+base_thick,0,0])
        pc_shell();


}

total();


