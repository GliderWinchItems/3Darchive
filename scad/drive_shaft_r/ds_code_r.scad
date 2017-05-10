/* ds_code.scad
 * Codewheel for drive shaft--reflective
 * Date: 20170506
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 * v2 = add chamfer to segments + disc cutout
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <../drive_shaft/ds_common.scad>

$fn = 200;

// **** Id the part ***
module id()
{
 translate([10,0,0])
 {
  font = "Liberation Sans:style=Bold Italic";
  rotate([0,0,90])
    translate([hub_disc_dia/2 - 6,0, rhub_thick1]) 
     rotate([0,0,90])
      linear_extrude(0.5)
        text("ds_code_r",size = 3);

  rotate([0,0,90])
    translate([hub_disc_dia/2 - 2,0, rhub_thick1]) 
     rotate([0,0,90])
      linear_extrude(0.5)
        text("2017 05 08 v2",size = 3);
 }
}

module weight_cutout()
{
   translate([0,50,rhub_wt_ofs])
      rotate([90,0,0])
         cylinder(d = hub_wt_dia, h = 50, center = true);
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
     cube([(hub_disc_dia-shaft_dia)/2,hub_tab_thick, rhub_len],center = false);

     union()
     {
        screw_hole(rht_ofs_z1);
        screw_hole(rht_ofs_z2);
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
/* ***** circular chamfer *****
 * d = outer diameter
 * rad = chamfer radius
 * circular_chamfer(d, rad);
*/
module circular_chamfer(d, rad)
{
  ofs = (d/2 - rad);
  rotate_extrude()
  translate([ofs,0])
   difference()
   {
     union()
     {
       square(size = [rad, rad]);
     }
     union()
     {
       translate ([0,rad])
           circle(d = 2*rad);
     }
   }

}

module hub()
{
echo (rhub_wt_ofs);
   difference()
   {
      od = (shaft_dia+hub_thick2);
      union()
      {
         // Collar around shaft
         tubedeh(od,shaft_dia,rhub_len);

         // Disc from shaft to first step
         tubedeh(seg_dia_inner+.01,od,hub_thick1);

         // Disc from first step to cup wall
         tubedeh(rrim_dia, seg_dia_inner,rhub_thick1);


         // Hub tabs for bolting halves together
         hub_tabs();
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

  sc_y = (rrim_dia * 3.14159265)/(2*rnsegs);
  sc_x = rrim_ht + 2;
  sc_z = 20; // No top edge rim
  sc_ofs_x = rrim_rad - 8;
  sc_ofs_z = 0; // rhub_thick1;

module segment_cutout()
{
   rotate_extrude(angle = 225/nsegs)
   {
      translate([sc_ofs_x,0,0])
        square(size = [sc_z,sc_x]);
   }
}

cp_cmfr_rad = 5;  // Chamfer radius

module cup()
{

  difference()
  {
    od = (shaft_dia+hub_thick1);
    union()
    {
       // Rim
       tubedeh(rrim_dia, rrim_dia-rrim_thick1, rrim_ht);

       // Chamfer to strengthen segments
       translate([0,0,rhub_thick1])
	 circular_chamfer(rrim_dia-rrim_thick1,cp_cmfr_rad);

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

module segment_cutouts()
{
  step = 180/rnsegs;
      for (i = [0 : 2*step : (180 - .01)])
      {
        rotate([0,0,i])
          segment_cutout();   
      }  
}

module total()
{
  difference()
  {
    union()
    {
      hub();
      cup();
      id();
    }
    union()
    {
      segment_cutouts();
    }
  }
}

total();

