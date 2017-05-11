/* test_common.scad
 * Test stand simulate drive shaft 
 * Common dimensions
 * Date: 20170510
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <../drive_shaft/ds_common.scad>



tshaft_len = 70;	// Length of cylinder
tshaft_dia = shaft_dia;

// Motor shaft
ms_len = 12.27;	//  Motor shaft length
ms_shaft_dia = 5; // Shaft diameter
ms_shaft_len1 = 6.2; // Narrow length
ms_washer = 20 + 6;
ms_od_dia = 32.8 + 20; // Diameter of motor holder tube
ms_od_len = 35;   // Length of above
ms_wall = 7;		// Wall thickness
ms_end_dia = shaft_dia - ms_wall;
ms_screw_hole_depth = 6;

screw_hole_dia = 3.0;
screw_self_dia = 2.6;
nscrews = 3; // Number of screws

// me = end piece
me_rod_dia = 1.7; 	// Hole dia for end piece
me_wall = 5;		// Wall thickness of end piece
me_wall_ht = 12;	// Height wall goes into cylinder
ms_end_thick = 2;	// Base plate thickness
me_hole_dia = 1.5;	// Center hole diameter

// Moto dimensions
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

// base plate
base_thick = 3;
base_x = 40;
base_y = 40;

// Stands
sn_gap = 16;	// Gap between bottom of encoder and mount board
ctr_line_ht = rrim_rad + sn_gap ; // Height of center line of drive shaft tube




