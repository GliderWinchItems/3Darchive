/* fairlead_common.scad
 * Common dimensions for fairlead stand and plates
 * Date: 20170831
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>

/* Base plate */
bb_sq = (3.75 * 25.4);	// Square bearing block size

bp_wid = 22;	// Width of base plate foot around bearing block
bp_sq = bb_sq + 2*bp_wid;	//  Side length
bp_in = bb_sq + 3;	//  Bearing block cutout length
bp_thick = 4;	// Base plate thickness
bp_rad = 3;	// Nice looking radius on corner


pt_theta = 40;	// Angle of bend in posts (deg)
bd_ofs = 30;	// Radius for rotate extrude of bend

vp_dia = 26;	// Vertical Post main diameter
vp_ht = 6;	// Vertical post height
sc_x = 0.6;	// Scale x--squish cylinder to ellipse
sc_y = 1.0;	// Scale y--width 

ofs_x = bp_sq/2 - vp_dia/2; // Position post over base
vp_r = (vp_dia * sc_x)/2;
vp_ofs_x = ofs_x-bd_ofs + vp_r;

tf_sq = 110;
tf_ofs_z = 36;

ep_thick = 3;
ep_sq = tf_sq - 9;

en_r_dia = 18.3*2; // top_plate hole for encoder plate

/* Selections for mag mount */
// 16mm with M4 stud
mag_thick = mag16_M4_thick;
mag_stud_dia = mag16_M4_stud_dia;
mag_stud_len = mag16_M4_stud_len;
mag_nut_thick = mag16_M4_nut_thick;
mag_nut_hex_peak = mag16_M4_nut_hex_peak;
mag_washer_dia = mag16_M4_nut_hex_peak;
mag_washer_thick = mag16_M4_washer_thick;

/* Height from z=0 to flat surface on top of posts */


