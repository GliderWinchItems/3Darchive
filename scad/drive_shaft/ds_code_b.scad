/* ds_code_b.scad
 * Codewheel for drive shaft--"other half"
 * Date: 20170426
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <ds_common.scad>

$fn = 100;



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

//   rotate([0,0,step/2])
   {
      for (i = [0 : step : (180 - .01)])
      {
        rotate([0,0,i])
          segment();    
      }
   }
}



module screw_hole(z)
{
        translate([ht_ofs_x,-1,z])
         rotate([90,0,0])
          cylinder(d = ht_screw_dia, h = 50, center = true);

}

module hub_tab()
{
   difference()
   {
     cube([(hub_disc_dia-shaft_dia)/2,hub_tab_thick, hub_len],center = false);

     union()
     {
        screw_hole(ht_ofs_z1);
        screw_hole(ht_ofs_z2);
        screw_hole(ht_ofs_z3);
     }
   }
}


module hub_tabs()
{
   ofs_x = shaft_dia/2;
   translate([ofs_x,0,0])
	hub_tab();

   translate([-ofs_x,hub_tab_thick,0])
      rotate([0,0,180])
	hub_tab();

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

         // Hub tabs for bolting halves together
         hub_tabs();
      }
      union()
      {
         od2 = od +  seg_dia_inner;

         // Lop off bottom half of tubes
         translate([-od2/2,-od2,0])
            cube([od2,od2,10*od2],center = false);

      }
   }
}

module total()
{

   segments();
   hub();
}


total();
