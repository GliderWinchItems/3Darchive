/* fairlead_common.scad
 * Common dimensions for fairlead stand and plates
 * Date: 20170831
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <../library_deh/fasteners.scad>

/* Bearing block */
bb_sq = (3.75 * 25.4);	   // Square bearing block size
bp_wid = 22;	   // Width of base plate foot around bearing block
bp_sq = bb_sq + 2*bp_wid; //  Side length
bp_in = bb_sq + 3; //  Bearing block cutout length
bp_thick = 4;	   // Base plate thickness
bp_rad = 3;	   // Nice looking radius on corner
bp_shafttop = 40;  // Fairlead plate to top of sheave shaft


pt_theta = 16;	// Angle of bend in posts (deg)
bd_ofs = 30;	// Radius for rotate extrude of bend

vp_dia = 26;	// Vertical Post main diameter
vp_ht = 6;	// Vertical post height
sc_x = 0.6;	// Scale x--squish cylinder to ellipse
sc_y = 1.0;	// Scale y--width 

ofs_x = bp_sq/2 - vp_dia/2; // Position post over base
vp_r = (vp_dia * sc_x)/2;   // x axis radius
vp_ofs_x = ofs_x-bd_ofs + vp_r; // Position adjusted for ellipse

/* Selections for mag mount */
// 16mm with M4 stud
magx_thick = mag16_M4_thick;
magx_stud_dia = mag16_M4_stud_dia;
magx_stud_len = mag16_M4_stud_len;
magx_nut_thick = mag16_M4_nut_thick;
magx_nut_hex_peak = mag16_M4_nut_hex_peak;
magx_washer_dia = mag16_M4_nut_hex_peak;
magx_washer_thick = mag16_M4_washer_thick;

/* Magnet at end of sheave shaft */
magx_shaft_thick = mag25_thick;

/* Galvanized plate with double stick tape to fairlead side */
gal_thick = .41;       // 30 gauge galvanized sheet thickness
dbl_tape_thick = 1.13; // Double stick tape thickness

/* Encoder coupling */
tp_base = 3.01;	    // Thickness of encoder mounting plate
en_shaft_len = 17.5 - tp_base;  // Length encoder shaft protrudes beyond mtg plate
en_flex = 8;        // Flexible coupling: encoder-stud shaft
mag_adapt_len = 18;    // Length of mag stud-flexible coupling length

/* fairlead plate to z = 0 of stand */
fp_ofs = gal_thick + dbl_tape_thick + mag_thick;
zbp_shafttop = bp_shafttop - fp_ofs;

/* Encoder top plate piece, ties posts together */
ep_thick = 4;

/* Total height from top of galvanized sheet to top of posts */
zheight = zbp_shafttop +  
          magx_shaft_thick +
          mag_adapt_len +
          en_flex + 
          en_shaft_len -
          ep_thick;
          
/* Height from z=0 to flat surface on top of posts */
del = (vp_dia * sc_x)/2;
x = vp_ofs_x;
tx = bd_ofs;
g = tx - tx* sin(pt_theta);
m2 = tx * sin(pt_theta);
m1 = zheight - m2 - vp_ht;
k = m1 * tan(pt_theta);
aa = x - g - k;
m1 = zheight - m2 - vp_ht;

echo (zheight);

tf_sq = 103;	// Top surface side of square
tf_ofs_z = zheight;

/* Encoder top plate piece, ties posts together */
ep_sq = tf_sq - 9;
en_r_dia = 18.3*2; // top_plate hole for encoder plate

/* Top Bolt: bolt holes, nut & washer, to hold top_piece to stand */
tb_dia = screw_dia_s632;	  // #6 bolt diameter at threads
tb_washer_thick = washer_thick_6; // Select washer from list
tb_nut_thick = nut_thick_632;     // Select nut from list
tb_nut_dia = nut_dia_632;         // Select nut pk-pk diameter from list
tb_washer_dia = washer_od_6;      // #6 washer diameter
tb_ht = 19;	// Length of threads (3/4")
tb_thread_ofs_z = tb_ht - ep_thick; // Length threads go below top surface
tb_washer_ofs_z = 2 + tb_washer_thick ;	// Depth below top surface of bottom of washer
tb_nut_ofs_z = tb_washer_ofs_z + tb_nut_thick; // Depth below surface

tb_ofs_x = 39;	// Offset to place top_piece bolt over post center



