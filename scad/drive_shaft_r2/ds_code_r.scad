/* ds_code_r.scad
 * Codewheel for drive shaft--reflective
 * Date: 20170506
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 * v2 = add chamfer to segments + disc cutout
 * v3 = increased diameter (foto_gap = 2;)
 * v4 = increased diameter (foto_gap = 0;)
 * v5 = add minimum gap rim (min_foto_gap = 0.5)
 * v6 = remove tabs, add hose clamp and splines (6/22/2017)
 * v7 = Open slot hose clamp
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
    translate([hub_disc_dia/2 - 6,0, hs_hub_thick1]) 
     rotate([0,0,90])
      linear_extrude(0.5)
        text("ds_code_r2",size = 3);

  rotate([0,0,90])
    translate([hub_disc_dia/2 - 2,0, hs_hub_thick1]) 
     rotate([0,0,90])
      linear_extrude(0.5)
        text("2017 06 18 V7",size = 3);
 }
}

module splinetooth(ofs_x)
{
   sp_1 = 4; sp_2 = 5;
   az = atan( (sp_1/2)/sp_2 );
   ax = ofs_x - 1;
   translate([ax,0,0])
     rotate([0,0,-az])
        triangle(sp_1,sp_2,sp_2,rhub_len);
}

module splineteeth(x)
{
  nteeth = 40;
  step = 180/nteeth;
      for (i = [step/2 : 2*step : (180 - .01)])
      {
        rotate([0,0,i])
          splinetooth(x);   
      }  
}

module hose_clamp(ofs_z)
{
   hs_dia = shaft_dia + hs_hub_thick2;
   translate([0,0,ofs_z])
	tubedeh(hs_dia+clmp_thick,(hs_dia-clmp_recess_depth),clmp_recess_wid);
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
       dia = 18;
       tb_ofs_x = hs_hub_thick2 + 4;
       tb_ofs_y = hub_tab_thick;
       tb_ofs_z = hs_hub_thick2 + 5;

       translate([tb_ofs_x, tb_ofs_y, tb_ofs_z])
        rotate([0,90,0])
         rotate([90,0,0]) 
           eye_bar(dia,ht_screw_dia,(dia/2),hub_tab_thick);
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
      od = (shaft_dia + hs_hub_thick2);
      union()
      {
         // Collar around shaft
         tubedeh(od,shaft_dia,rhub_len);

         // Disc from shaft to first step
         tubedeh(seg_dia_inner+.01,od,hs_hub_thick1);

         // Disc from first step to cup wall
         tubedeh(rrim_dia - 2, seg_dia_inner,hs_hub_thick1);

	 // Add small rim to assure minimum gap to photodetector
	 tubedeh(rrim_gap_dia, rrim_dia-0.1,rrim_gap_thick);

         // Hub tabs for bolting halves together
         hub_tabs();

	 // Fill any slop between hub ID and shaft
  	 splineteeth(shaft_dia/2);
      }
      union()
      {
         od2 = od +  seg_dia_inner;

         // Lop off bottom half of tubes
         translate([-od2/2,-od2,0])
            cube([od2,od2,10*od2],center = false);

         // Hole in side of hub for shaft counter-weight
         weight_cutout();
	
	 // Hose clamp recesses
	 hose_clamp(13);

	 hose_clamp(32);
      }
   }
}

  sc_y = (rrim_dia * 3.14159265)/(2*rnsegs);
  sc_x = rrim_ht + 2;
  sc_z = 20; // No top edge rim
  sc_ofs_x = rrim_rad - 8;
  sc_ofs_z = 0; // hs_hub_thick1;

module segment_cutout()
{
   rotate_extrude(angle = 225/nsegs)
   {
      translate([sc_ofs_x,0,0])
        square(size = [sc_z,sc_x]);
   }
}

module tapered_tube()
{
   tt_del = rrim_ht * sin(hs_tab_angle);
   tt_d1 = rrim_dia;
   tt_d2 = rrim_dia-rrim_thick1;

   difference()
   {
     union()
     {
        cylinder(d1 = tt_d1, d2 = tt_d2, h = rrim_ht, center=false);
     }
     union()
     {
	cylinder(d = rrim_dia-rrim_thick1 - 2, h = rrim_ht+.01, center=false);
     }
   }
}

cp_cmfr_rad = 5;  // Chamfer radius

module cup()
{

  difference()
  {
    od = (shaft_dia+hs_hub_thick1);
    union()
    {
       // Rim
//       tubedeh(rrim_dia, rrim_dia-rrim_thick1, rrim_ht);
       tapered_tube();
       // Chamfer to strengthen segments
       translate([0,0,hs_hub_thick1])
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

