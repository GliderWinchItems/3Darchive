/* ds_code.scad
 * Codewheel for drive shaft
 * Date: 20170424
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>

$fn = 100;

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
hub_len = 2.0 * 25.4;	// Shaft-wise length
hub_wt_ofs = 1.25 * 25.4; // Balance weight offset
hub_wt_dia = 45 - 18; 	// Balance cutout
hub_disc_dia = shaft_dia + 26;

hub_washer_dia = mag20_washer_dia + 1.0;

seg_dia_inner = hub_disc_dia;
seg_dia_outer = rim_dia;
seg_thick = rim_thick;	// Thickness of segments

nsegs = 10;	// Number of segments

module segment()
{
   rotate_extrude(angle = 180/nsegs)
   {
     translate([seg_dia_inner/2,0,0])
       square([(seg_dia_outer - seg_dia_inner)/2,seg_thick], center = false);
   }
}
           
module segments()
{
   step = 360/nsegs;

   for (i = [0 : step : (180 - .01)])
   {
     rotate([0,0,i])
       segment();    
   }
}

module weight_cutout()
{
   translate([0,50,hub_wt_ofs])
      rotate([90,0,0])
         cylinder(d = hub_wt_dia, h = 50, center = true);


}

module hub()
{
   difference()
   {
      od = (shaft_dia+hub_thick2);
      union()
      {
         // Collar around shaft
         tubedeh(od,shaft_dia,hub_len);

         // Disc from shaft to segments
         tubedeh(seg_dia_inner+.01,od,hub_thick1);
      }
      union()
      {
         od2 = od +  seg_dia_inner;

         // Lop off bottom half of tubes
         translate([-od2/2,-od2,0])
            cube([od2,od2,10*od2],center = false);

         weight_cutout();
      }
   }
}

module total()
{

   segments();
   hub();
}


total();
