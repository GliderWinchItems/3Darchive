/* generator_common.scad
 * Common dimensions for fairlead stand and plates
 * Date: 20171011
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <../library_deh/fasteners.scad>



/* Armature shaft */
ar_shaft_dia = 0.625 * 25.4; // Armature shaft diameter
ar_shaft_len = 31.75;	// Aramature shaft length:slip ring to bolt top

/* Bolt on end of armature shaft dimensions */
bl_flats = 12.54;	// Flat-flat
bl_peaks = 14.03;	// Peak-peak

bp_thick = 4;	      // Base plate thickness
vp_ht = 17;
vp_dia = 26;	// Vertical Post main diameter
bb_sq = (3.75 * 25.4);// Square bearing block size
tb_ofs_x = 39;	// Offset to place top_piece bolt over post center
tf_ofs_z = 0;//zheight; // ### Slice top of posts ###

/* Endbell dimensions */
eb_tp = 13.8;		// Endbell surface to top of post
eb_tp_ts = 8.0;		// Endbell post top to top of 16mm mag stud
eb_tp_tb = 5.8;		// Endbell post top to top of bolt
eb_post_id = 19.9;	// Endbell post inside dia
eb_post_od = 25.6;	// Endbell post outside dia
eb_max_dia = 27.8*2;//(1 + 3/32) * 25.4; // Endbell max dia for flat base


/* Generator stand base */
gs_id = eb_post_od + 0.5; // Encoder support Fits over End bell center post OD
gs_od = gs_id + 25;	// Base flange width
gs_thick = 4;		// Thickness of base
gs_tube_len = 41+10-6;	// Support tube length: endbell to top 
gs_tube_thick = 3;	// Support tube thickness
gs_access_wid = 15;	// Width of horizontal cutout
gs_drain_wid = 2;	// Width of moisture drain cutout

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
magx_shell_thick = mag25_thick;

/* Galvanized plate with double stick tape to fairlead side */
gal_thick = .41;       // 30 gauge galvanized sheet thickness
dbl_tape_thick = 1.13; // Double stick tape thickness

/* Encoder coupling */
tp_base = 3.01;	     // Thickness of encoder mounting plate
en_shaft_len = 17.5 - tp_base;  // Length encoder shaft protrudes beyond mtg plate
en_flex = 18;        // Length Flexible coupling: encoder-stud shaft
mag_adapt_len = 18;  // Length of mag stud-flexible coupling length


/* Encoder top plate piece, ties posts together */
ep_thick = 6;

/* Encoder top plate piece, ties posts together */
en_r_dia = 18.3*2; // top_plate hole for encoder plate

/* Top Bolt: bolt holes, nut & washer, to hold top_piece to stand */
tb_dia = screw_dia_s632+.5;	  // #6 bolt diameter at threads
tb_washer_thick = washer_thick_6; // Select washer from list
tb_nut_thick = nut_thick_632;     // Select nut from list
tb_nut_dia = nut_dia_632;         // Select nut pk-pk diameter from list
tb_washer_dia = washer_od_6;      // #6 washer diameter
tb_ht = 19;	// Length of threads (3/4")
tb_thread_ofs_z = tb_ht - ep_thick; // Length threads go below top surface
tb_washer_ofs_z = 2 + tb_washer_thick ;	// Depth below top surface of bottom of washer
tb_nut_ofs_z = tb_washer_ofs_z + tb_nut_thick; // Depth below surface

/* Top Piece embedded nut and washer for holding encoder plate. */
te_dia = screw_dia_s632+.5;	  // #6 bolt diameter at threads
te_washer_thick = washer_thick_6; // Select washer from list
te_nut_thick = nut_thick_632;     // Select nut from list
te_nut_dia = nut_dia_632;         // Select nut pk-pk diameter from list
te_washer_dia = washer_od_6;      // #6 washer diameter

te_ofs_nut_z = 0.5;
te_ofs_washer_z = te_nut_thick;

/* Encoder shaft */
enc_shaft_dia = 6;	// Encoder shaft diameter
enc_shaft_dflat = 5.5;	// D flat to other side dimensions
enc_d = 38.5;           // Diameter of encoder body
en_r = 15.1;            // Encoder mtg hole radius
enc_len_d = 10;         // Length of D flat on encoder shaft




