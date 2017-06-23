/* ds_fixture_r.scad
 * Enclosure/mount for drive shaft
 * Reflective type sensor
 * Date of latest: 20170507 v3
 * v2 = higher walls for CAN cable clearance
 * v3 = move mag mnts to position sensor further out
 * v4 = 16mm M3 or M4 stud provision, bigger mag post dia
 * v5 = minor adjustment to mag mnt post
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <../drive_shaft/ds_common.scad>
include <../drive_shaft/ds_fixture_common.scad>

 $fn=50;

/*
 * Define mag mount stud 
 * Comment in/out mag mount set
 * Do not forget ID text change.
 */

// 16mm with M3 stud
magx_shell_dia = mag_shell_dia;
magx_stud_len = mag_stud_len;
magx_stud_dia = mag_stud_dia;
magx_washer_dia = mag_washer_dia;
magx_washer_thick = mag_washer_thick;
magx_nut_hex_peak = mag_nut_hex_peak;
magx_nut_thick = mag_nut_thick;
echo ("mag M3 specified");

/*
// 16mm with M4 stud
magx_shell_dia = mag16_M4_shell_dia;
magx_stud_len = mag16_M4_stud_len;
magx_stud_dia = mag16_M4_stud_dia;
magx_washer_dia = mag16_M4_washer_dia;
magx_washer_thick = mag16_M4_washer_thick;
magx_nut_hex_peak = mag16_M4_nut_hex_peak;
magx_nut_thick = mag16_M4_nut_thick;
echo ("mag16_M4 specified");
*/

magx_stud_dia = mag_stud_dia;
echo (magx_stud_dia);

// **** Id the part ***
module id()
{
 {
  font = "Liberation Sans:style=Bold Italic";
  translate([10,-22, base_thick]) 
  linear_extrude(2)
   text("ds_fixture_r",size = 3);

 translate([10,-28, base_thick]) 
  linear_extrude(2)
   text("2017 05 18 v5  M4",size = 3);
 }
}

// Magnet mount dimensions
include <../library_deh/mag_mount.scad>


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

 
// Tabs for holding pc board cover down

 cm_od = 10;	// Diameter of cover mounting post
 cm_len = cm_od/2 + 4;
 cm_id = 2.6;	// Self-tapping screw hole diameter

// Base
base_thick 	= 2.0;	// Thickness of base
base_rad	= 10;	// Radius around mags
base_x		= mag_spacing_x + 2*base_rad;
base_y		= mag_spacing_y + 2*base_rad;

shell_wall = 2;	// Enclosure wall thickness
shell_ht = 35;	;	// Enclosure wall height

shell_x = pcwid + 2*shell_wall;
shell_y = pclen + 2*shell_wall;

tab_len = 10;
tab_dia = mag_shell_dia;
tab_thick = 4;
tab_overlap = 10;	// Overlap of tab bar with spacer plate
   cov_ofs = 8.5;  // Tab top distance below top edge of board

wh_dia = 13; // Wire hole diameter in triangular base

spacer_thick = 7;	// Spacer between magnet base and box
cover_depth = 11.5;	// Width/depth of cover lip over box

tab_hole = magx_stud_dia + 0.3;	// Magnet stud hole in triangular base

// Triangular mag-mount base
   eb_ofs_x = (shell_x + spacer_thick) + tab_thick;
   eb_ofs_y = (shell_y/2 + tab_len);
   eb_len = tab_len + tab_overlap;	// Length of end tabs
   eb_ofs_z = shell_ht - cover_depth + 25;
   eb_len2 = eb_ofs_z;	// Length of center/back tab

module pc_shell()
{
   // Base plate
   translate([shell_x/2,0,0])
      rounded_rectangle(shell_x,shell_y,base_thick,shell_rad);
/*module rounded_rim(l,w,h,rad,tk);
l = length (inside, x direction)
w = width (inside, y direction)
h = thickness (z direction)
rad = radius of corners
tk = thickness of rim wall
*/

   // Walls
   difference()
   {
      translate([shell_x/2,0,0])
        rounded_rim(shell_x,shell_y,shell_ht,shell_rad,shell_wall);

      translate([-shell_x/2 + 12, -20, base_thick - cc_thick/2])
       rotate([0,0,90])
 	cable_cutout();
   }
   
   // Posts for screw mounting of pc board
   translate([pcps_ofs_x+pc_slop/2,pcps_ofs_y,base_thick]) pc_posts4();
}


module pc_posts_pair()
{
   tubedeh(pcps_post_dia,pcps_screw_dia,pcps_post_ht);
   translate([0,-pcps_space_y,0])
      tubedeh(pcps_post_dia,pcps_screw_dia,pcps_post_ht);
}

module pc_posts4()
{
   pc_posts_pair();
   translate([pcps_space_x,0,0])
     pc_posts_pair();
}

module cable_cutout()
{
   // Two telephone type cables
   translate([cc_ofs_x,cc_ofs_y,cc_ofs_z])
    rotate([0,90,90])
     rounded_rectangle(cc_thick,cc_wid,20,1.5);
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

module cover_mnt_tab()
{
      rotate([0,0,-90])
        eye_bar(cm_od,cm_id,cm_len,shell_ht - cov_ofs);
}

module cover_mnt_tabs()
{
   translate([-cm_ofs_x1, shell_y/2 - cm_ofs_dy,0])
     rotate([0,0,90])
      cover_mnt_tab();

   translate([-cm_ofs_x1, -shell_y/2 + cm_ofs_dy,0])
     rotate([0,0, 90])
      cover_mnt_tab();

   translate([cm_ofs_x2,0,0])
     rotate([0,0,-90])
      cover_mnt_tab();
}

pcs_mag_dia = magx_stud_dia + 0.5; // Magnet stud dia
pcs_mag_stud_len = magx_stud_len + 0.5;
pcs_del = 8;	//  Adjustment of axle direction of mag mnts
pcs_mag_ofs_x =  -50 - pcs_del;	// Position of sensor end magnet
pcs_mag_ofs_x1 = -15 - pcs_del; 	// Position of sensor end magnet pair
pcs_mag_ofs_y1 = 25;  	// Position of engine end magnet pair

mag_bot_thick = 1;	// thickness of bottom-to-washer
mag_post_dia = magx_washer_dia + 4;	// OD of magnet post
mag_post_ht = magx_stud_len + 1;	 // Height of mag post

po_hex_nut = magx_nut_hex_peak + 0.4; // Dia for hex nut pocket
po_hex_nut_ht = magx_nut_thick + .25; // Depth of pocket

module mag_mnt_post()
{
       cylinder(d = mag_post_dia, h = mag_post_ht, center = false);
}
module mag_mnt_post_hole()
{
   // Stud hole
   cylinder (d = pcs_mag_dia, h = pcs_mag_stud_len, center = false);

   // Washer pocket
   translate([0,0,mag_bot_thick])
     cylinder(d = magx_washer_dia + 0.5, h = magx_washer_thick + .3, center = false);

   // Nut pocket
   translate([0,0,mag_bot_thick + magx_washer_thick - 0.1])
      linear_extrude(height = po_hex_nut_ht, center=false)
         circle(d = po_hex_nut, $fn=6);      
}
// Additions
module mag_mnt_posts()
{
   // This one is outside shell
   translate([pcs_mag_ofs_x,0,0])
    mag_mnt_post();

   // so, connect it to the shell
   translate([pcs_mag_ofs_x-.1 ,-mag_post_dia/2,0])
     cube([mag_post_dia+pcs_del-3,mag_post_dia,mag_post_ht],center = false);

   // These two are inside shell
   translate([pcs_mag_ofs_x1,pcs_mag_ofs_y1,0])
    mag_mnt_post();

   translate([pcs_mag_ofs_x1,-pcs_mag_ofs_y1,0])
    mag_mnt_post(); 
}
// Subtractions
module mag_mnt_holes()
{
   translate([pcs_mag_ofs_x,0,0])
    mag_mnt_post_hole();

   translate([pcs_mag_ofs_x1,pcs_mag_ofs_y1,0])
    mag_mnt_post_hole();

   translate([pcs_mag_ofs_x1,-pcs_mag_ofs_y1,0])
    mag_mnt_post_hole();
 
}
dh_dia1 = 0.4;  // Drain hole diameter
dh_dia2 = 8;
dh_ofs_y = -42.5;
dh_ofs_x = 55;

module drain_hole()
{
   translate([dh_ofs_x,dh_ofs_y,0])
     cylinder (d1 = dh_dia1, d2 = dh_dia2, h = base_thick, center = false);

}

module shell_complete()
{
  difference()
  {
    union()
    {
        pc_shell();
	cover_mnt_tabs();
        id();
    }
    union()
    {
       // Cutout for reflective photosensors
       ps_cutout();
       drain_hole();
    }
  }
}
/*
Position shell so that photodetector pair cutout centers
on [x,y] = [0,0].  That offsets the box rectangle with
respect to the mounting centerline.  The mag mount posts
align with the mounting centerline.
*/
module total()
{
  difference()
  {
    union()
    {
       translate([-39.35,-14.8,0])
         shell_complete();
    
       mag_mnt_posts();
    }
    union()
    {
      mag_mnt_holes();
    }
  }
}

total();

