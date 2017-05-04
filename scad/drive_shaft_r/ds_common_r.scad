/* ds_common.scad
 * Codewheel for drive shaft
 * common measurements
 * Date: 20170427
 */


shaft_dia = 3.00 * 25.4; // Drive shaft diameter
shaft_ledge = 1.125 * 25.4; // Shaft to mnt ledge

fot_depth = 12;	// depth of photocell
fot_wid = 10;	// Width of pair of photodetectors
fot_tol = 2;


rim_rad = shaft_dia/2 + 
          shaft_ledge + 
          fot_depth + 
          fot_tol + 
          mag_thick;
rim_dia = rim_rad*2;

rim_wid = 1;
rim_thick = 2.0;

hub_thick1 = 4;		// Encoder hub disc thickness
hub_thick2 = 6;		// Shaft collar thickness
hub_len    = (2.375 - .375) * 25.4; // Shaft-wise length
hub_wt_ofs = (1.25  - .375) * 25.4; // Balance weight offset
hub_wt_dia = 45 - 18; 	// Balance cutout
hub_disc_dia = shaft_dia + 30;
hub_tab_thick = 6;	// Tab thickness for bolting halves

hub_washer_dia = mag20_washer_dia + 1.0;

seg_dia_inner = hub_disc_dia;
seg_dia_outer = rim_dia;
seg_thick = rim_thick;	// Thickness of segments

nsegs = 20;	// Number of segments

ht_screw_dia = 3.3;	//  Screw, bolting halves together
ht_ofs_z1 = hub_thick1 + 5;
ht_ofs_z2 = hub_len/2;
ht_ofs_z3 = hub_len - ht_ofs_z1;
ht_ofs_x =  hub_thick2/4 + (hub_disc_dia-shaft_dia)/4;

