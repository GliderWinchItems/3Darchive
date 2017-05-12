/* Pillars to support metal plate
*  File: pillars.scad.scad
 * Author: deh
 * Latest edit: 20170511
 * 
*/
include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <../drive_shaft/ds_common.scad>
include <test_common.scad>

$fn = 100;

pl_nscrews = 3;	// Number of screws
pl_screw1_dia = 2.6;	// Center self tap screw diameter
pl_screw1_depth = 10;	// Depth of selt-tap hole
pl_screw2_dia = 3.3; 	// Base screw hole diameter
pl_ht1 = 90;		// Pillar height (overall)
pl_dia1 = 15;		// Pillar diameter
pl_rim = 9;
pl_ht2 = 3;		// Base thickness
pl_screw_rad = pl_dia1/2 + pl_rim/2;
pl_dia2 = pl_dia1 + (pl_rim * 2);

module screw_holes(rad)
{
       step = 360/pl_nscrews;
       for (i = [0 : step : 360])
       {
        rotate([0,0,i])
          translate([rad,0,0])
           cylinder(d = pl_screw2_dia, h = pl_ht2+1, center = false);
       }  
}

module pillar_inner()
{
   difference()
   {
     union()
     {
        // Overall pillar
        cylinder(d = pl_dia1, h = pl_ht1, center = false);

        // Base
        cylinder(d = pl_dia2, h = pl_ht2, center = false);

        // Circular fillet on base
        ch_rad = 1.5;
        translate([0,0,pl_ht2])
          circular_outer_chamfer(pl_dia1+ch_rad*2,ch_rad);

     }
     union()
     {
        cylinder(d = pl_screw1_dia, h = pl_screw1_depth, center = false);

        screw_holes(pl_screw_rad); 

     }
   }
}

pl_wall = 2;
pl_idia = pl_dia1 + 0.5;
pl_odia = pl_idia + pl_wall*2;
pl_orad = pl_odia/2 + pl_rim/2;
pl_odia2 = pl_odia + pl_rim*2;

tb_ht = 40;
tb_wid = 12;
tb_thick = 4;
tb_screw_hole = 3.3;

sl_wid = 1.5;	// Slot width

// Clamp tab
module clamp_tab()
{
  difference()
  {
    union()
    {
      translate([pl_odia/2 - pl_wall ,-tb_thick, pl_ht1-tb_ht])
        cube([tb_wid, tb_thick*2, tb_ht], center = false);

      translate([pl_odia/2 - pl_wall,-tb_thick,pl_ht1-tb_ht - tb_wid])
       rotate([90,0,90])
        wedge(tb_thick*2,tb_wid,tb_wid);
    }
    union()
    {
       translate([pl_dia1/2+tb_wid/2 + 2, tb_thick*2,pl_ht1-6])
         rotate([90,0,0])
          cylinder(d = tb_screw_hole, h = 20, center = false);

       translate([pl_dia1/2+tb_wid/2 + 2, tb_thick*2,pl_ht1-34])
         rotate([90,0,0])
          cylinder(d = tb_screw_hole, h = 20, center = false);

    }
  }

}



module pillar_outer()
{
   difference()
   {
     union()
     {
        // Overall pillar
        tubedeh(pl_odia, pl_idia, pl_ht1);

        // Base
        cylinder(d = pl_odia2, h = pl_ht2, center = false);

        // Circular fillet on base
        ch_rad = 1.5;
        translate([0,0,pl_ht2])
          circular_outer_chamfer(pl_odia+ch_rad*2,ch_rad);

        clamp_tab();

     }
     union()
     {
        cylinder(d = pl_screw1_dia, h = pl_screw1_depth, center = false);

        screw_holes(pl_orad); 

        // Slot
        translate([2,-sl_wid/2,pl_ht2+3])
           cube([35,sl_wid,pl_ht1-pl_ht2]);

        

     }
   }
}

module total()
{
  pillar_outer();

  translate([50,0,0])
    pillar_inner();
}
total();

