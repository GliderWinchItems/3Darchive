/* codewheel_3.scad
 * Codewheel for horizontal mounted encoders
 * Date: 20170421
 * codewheel_3
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 * V1 = add raised rim to assure minimum foto gap
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <../drive_shaft/ds_common.scad>

$fn = 100;

rim_dia = 130;
rim_wid = 1;

hub_thick = 2;	//
hub_hole_dia = mag25_stud_dia + 0.3; // Mounting hole
hub_disc_dia = 70;

hub_washer_dia = mag25_washer_dia + 1.0;

seg_dia_inner = hub_disc_dia;
seg_dia_outer = rim_dia;
rs_seg_thick = 2;  // Thickness of segments

cw_rim_thick = rs_seg_thick + 0.5; // 0.7mm ideal photodetector gap

nsegs = 10;	// Number of segments

// **** Id the part ***
module id()
{
 translate([10,0,0])
 {
  font = "Liberation Sans:style=Bold Italic";
  rotate([0,0,90])
    translate([hub_disc_dia/2 - 8,0, rhub_thick1]) 
     rotate([0,0,90])
      linear_extrude(0.5)
        text("codewheel_3",size = 3);

  rotate([0,0,90])
    translate([hub_disc_dia/2 - 4,0, rhub_thick1]) 
     rotate([0,0,90])
      linear_extrude(0.5)
        text("2017 05 16 v1",size = 3);
 }
}


module segment()
{
   rotate_extrude(angle = 180/nsegs)
   {
     translate([seg_dia_inner/2,0,0])
       square([(seg_dia_outer - seg_dia_inner)/2,rs_seg_thick], center = false);
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
   tubedeh(rim_dia, (rim_dia - (rim_wid * 2)), cw_rim_thick);
echo (cw_rim_thick);
   id();
}


total();
