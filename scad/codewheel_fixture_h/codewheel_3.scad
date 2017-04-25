/* codewheel_3.scad
 * Codewheel for horizontal mounted encoders
 * Date: 20170421
 * codewheel_3
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>

$fn = 100;

rim_dia = 120;
rim_wid = 1;
rim_thick = 2.0;

hub_thick = 2;	//
hub_hole_dia = mag20_stud_dia; // Mounting hole
hub_disc_dia = 80;

hub_washer_dia = mag20_washer_dia + 1.0;

seg_dia_inner = hub_disc_dia;
seg_dia_outer = rim_dia;
seg_thick = rim_thick;	// Thickness of segments

nsegs = 16;	// Number of segments


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

   for (i = [0 : step : 360])
   {
     rotate([0,0,i])
       segment();    
   }
}

module total()
{
   // Hub disc
   tubedeh(hub_disc_dia,hub_hole_dia,hub_thick);

   // Encoder segments
   segments();

   // Rim
   tubedeh(rim_dia, (rim_dia - (rim_wid * 2)), rim_thick);
}


total();
