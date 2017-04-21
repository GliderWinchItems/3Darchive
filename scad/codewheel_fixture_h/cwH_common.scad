/* File: cwH_common.scad
 * Common dimensions for cwH parts
 * Author: deh
 * Latest edit: 20170417
 */

include <../library_deh/mag_mount.scad>

// Support posts (three in triangluar pattern)
sp_ht = 43;	// Height: plate-to-encoder disk c/l
sp_dia = 20;	// Post diameter
sp_x = 149; 	// Spacing in front-back direction
sp_y = 85;	// Spacing in top-bottom direction
sp_ht_tol = 12; // Height variation tolerance

// Magnets used: post mnts = mag_thick, encoder mnts = mag20_thick
sp_z = sp_ht - mag_thick + mag20_thick; // Height to print posts

// Photosensor cutout  
  ps_wid = 4.7;	// Width of photosensor
  ps_len = 6.5;	// Length of photosensor

// PC board dimensions
pc_slop = 4;
pcwid = 49.6 + pc_slop;	// Width of PC board
pclen = 83.0 + pc_slop;	// Length of PC board
pcthick = 1.7;	// Thickness of board

// Magnet positioning
 mag_spacing_y	= 52;	// Distance y +/- to magnets
 mag_spacing_x	= 45;	// Distance x: magnet to y-axis mag pair C/L
 mag_ofs = -45;		// Position triangular base under enclosure box
// Tabs for holding pc board cover down

 cm_od = 10;	// Diameter of cover mounting post
 cm_len = cm_od/2 + 4;
 cm_id = 2.6;	// Self-tapping screw hole diameter
 cm_wg = 5;	// Bottom wedge	

// Base
base_thick 	= 2.0;	// Thickness of base
base_rad	= 10;	// Radius around mags
base_x		= mag_spacing_x + 2*base_rad;
base_y		= mag_spacing_y + 2*base_rad;

shell_wall = 2;	// Enclosure wall thickness
shell_ht = 40;	;	// Enclosure wall height

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

tab_hole = mag_stud_dia + 0.3;	// Magnet stud hole in triangular base

// PC board mounting
 pcps_space_y = 25.4;  	// Distance between holes lengthwise
 pcps_space_x = 38.4;  	// Distance between holes across board 
 pcps_frm_top = 29.0;  	// Top hole from top of board
 pcps_frm_side = 6.3;	// side to hole
 pcps_post_dia = 7.0;	// Post diameter

 pcps_screw_dia = 2.6;	// Screw diameter
 pcps_screw_ht = 5;	// Screw thread length

 pcps_post_ht = 5+1;	// PC mounting post height
 pcps_ofs_y = pclen/2 - pcps_frm_top;
 pcps_ofs_x = shell_wall + pcps_frm_side;

// CAN bus cable cutout in wall
cc_wid = 6.5;		// Telephone type cable width
cc_thick = 10;	// Thickness
cc_frm_top =  3;	// Offset from top of side
cc_frm_side = 8;	// Offset from side
cc_sense_dia = 4;	// Sensor cable dia

 cc_ofs_z = shell_ht - cc_frm_top + cc_thick/2;
 cc_ofs_x = 20;
 cc_ofs_y = -25;

// Lightshield mounting
ls_post_dia = 4.5;		// Post diameter
ls_post_ht = 10;		// Height of post
ls_screw_dia = pcps_screw_dia;	// Self-tapping screw diameter
ls_screw_ht = ls_post_ht - 3;	// Depth of screw hole
ls_post_ofs_x = 17;		// Offset from C/L


