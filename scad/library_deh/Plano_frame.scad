/* File: Plano_frame.scad
 * Plano enclosure PC board fame
 * Author: deh
 * Latest edit: 201700701
 */

include <mag_mount.scad>

 $fn=100;
 
 // Inside dimensions of Plano box
 plano_len          = 152.5;   // flat-flat
 plano_wid          =  76.0;   // flat-flat

base_len = plano_len;
base_wid = plano_wid;
base_ht  = 3.2;		// Thickness of base plate
base_rnd = 10;	// Base plate corner rounding radius
 
 // Stud magnet relative postions.
 // Bottom magnet is on center-line and x,y reference is 0,0
 plano_mag_top_x  = 30.5;   // Top pair x +/- from center-line (C/L)
 plano_mag_top_y  = 138.69; // Top pair y from bottom magnet hole
 plano_mag_top_ofs = 8;    // Top mags to top edge of PC board max
 // Bottom mag distance from bottom of plano wall
 plano_mag_bot_ofs = plano_len - plano_mag_top_ofs - plano_mag_top_y;
 
 
 plano_offs_mag_y   = 4;    // Offset from edge for magnet hole
 plano_offs_mag_x   = 4;    // Offset from edge for magnet hole
 plano_ctr_y    = (plano_len/2);
 plano_ctr_x    = (plano_wid/2);
  
 plano_mag_stud = mag_stud_dia;  // Dia of mounting magnet studs (4-40)
 plano_mag_stud_len = mag_stud_len; // Height of stud from magnet back
 mag_washer_dia = 9.5;      // Diameter of washer for magnet stud
 mag_washer_thick = 1.1;    // Thickness of washer
 mag_washer_dia_extra = 1;  // Washer slop
 plano_web_thick = 2;   // Plano box thickness where stud is 
 mag_wash_recess_dia = mag_washer_dia + mag_washer_dia_extra;

 // Thickness of base for washer recess
 mag_stud_z = (mag_washer_thick +mag_nut_thick + plano_web_thick);
 mag_wash_recess_z = plano_mag_stud_len - mag_stud_z;    

 // Diameter of recess
 mag_wash_recess_dia = mag_washer_dia + mag_washer_dia_extra;

 // POD board
 pod_wid = 76.0;  // Overall width
 pod_len = 89.4;  // Overall length

// Discovery board
 dis_wid = 65.4;  // Overall width
 dis_len = 95.8;  // Overall length
 
// RJ45 connector on POD board
 RJ_offset=24.8; // Side of RJ45 jack from edge
 RJ_wid=15;      // Width of RJ 45 jack
 RJ_depth=14.5;  // Bottom of POD pc board edge to bottom/back of RJ45
 RJ_length=14;  // Front-Back length

// Cutout in base for RJ45 with plug
 RJ_slop = 4;
 RJ_plug_len = 14; // RJ plug protrudes beyond jack
 RJ_cutout_width = RJ_wid + RJ_slop;
 RJ_cutout_length = RJ_length + RJ_slop + RJ_plug_len;
 RJ_cutout_ofs = pod_wid/2 - (RJ_offset + RJ_wid);
 
 // CAN sub-board module
 sub_wid      = 33.75;  // Overall width
 sub_len      = 62.9;   // Overall lengh
 sub_mtg_wid  = 26.6;   // Between mounting holes, width
 sub_mtg_len  = 57.0;   // Between mounting holes, length 

 // Switcher module
 sw_wid =   20.3;   // Overall width
 sw_len =   41.2;   // Overall length
 sw_mtg_off_out_y   = 5.56; // Offset from edge "out" mounting hole 
 sw_mtg_off_out_x   = 2.7;  // Offset from edge "out" mounting hole 
 sw_mtg_off_in_y    = 3.1;  // Offset from edge "in" mounting hole
 sw_mtg_off_in_x    = 6.0;  // Offset from edge "in" mounting hole
 
 // RJ jack (load-cell jack)
 rj_grv =  4.0;  // Groove Depth 
 rj_ht  = 14.2;  // Groove Length
 rj_wid = 14.2;  // Groove Height
 
 // Post ridge
 p_ridge = 1.5; // Height of ridge to position PC board on post
 p_offset = 2;  // Offset of ridge from edge of post
 
 // Pod post
 pod_post_ht = (RJ_depth + 1);
 pod_post_y = 9;    // Length in "y" (long/length) box direction)
 pod_post_x = 6;    // Length in "x" (short/width) box direction)
 pod_post_q = 2.0;  // Width of ridge
 pod_post_s = 2.5;    // Screw hole dia
 pod_post_sd = 5;   // Screw hole depth

 // Pod board clip
 pcwide = 4;        // Width of clip post
 pcleng = 50;       // X axis direction length
 pc_y = base_len;   // y positioning

 iso_len   = 50.3;	// Length: two RJ 45 jacks parallel
 iso_wid   = 46.3;      // Width
 iso_thick = 1.6;	// PC board thickness
 iso_slop  = 0.1;	// Allowance for board variation
 iso_lip   = 1.2;	// Ledge width for board seating
 iso_ridge_ht = 1.55;	// Ridge ht for seat
 iso_ridge_wid= 1.5;	// Ridge width for seat
 iso_post_ht = 6.0;	// Height of lip above base

 iso_osd_y = iso_wid + iso_slop; // Board y
 iso_osd_x = iso_len + iso_slop; // Board x
 iso_side  = iso_lip + iso_ridge_wid;


