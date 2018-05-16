/* File: thrlpot_spl.scad
 * Spool for throttle pot
 * Author: deh
 * Latest edit: 20180514
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=100;
 
 ht_od = 26;
 ht_th =  1.5;
 ht_rg = 20;
 ht_ww = 2.5;
 ht_id  = ht_rg;
 ht_id1 = 16;
 
 pn_d = 12;     // Diameter holes to pin pieces together
 pn_b = 2.4;    // Pin bolt hole diameter
 
 dh_d = 6.0+.5;    // Pot shaft diameter
 dh_c = 4.46+.3;
 dh_x = dh_c-dh_d/2;
 
 module d_hole()
 {
     difference()
     {
         cylinder(d=dh_d,h=20,center=false);
         
         translate([dh_x,-dh_d,0])
            cube([10,20,20],center=false);
     }
     
 }
 
 module hat1()
 {
     difference()
     {
         union()
         {
            cylinder(d1=ht_od,d2=ht_od-ht_th,h=ht_th,center=false);
     
            translate([0,0,ht_th])
                cylinder(d=ht_id1,h=ht_ww,center=false);
         }
         union()
         {
            // Holes for bolts to hold spool pieces together
            for (i = [0 : 120 : (360 - .01)])
            {
                rotate([0,0,i])
                 translate([pn_d/2,0,0])
                    cylinder(d=pn_b,h=20,center=false);
            }
            d_hole();
         }
     }
 }
  module hat2()
 {
     difference()
     {
         union()
         {
            cylinder(d1=ht_od,d2=ht_od-ht_th,h=ht_th,center=false);
     
            translate([0,0,ht_th])
                cylinder(d=ht_id,h=ht_ww,center=false);
         }
         union()
         {
            // Holes for bolts to hold spool pieces together
            for (i = [0 : 120 : (360 - .01)])
            {
                rotate([0,0,i])
                 translate([pn_d/2,0,0])
                    cylinder(d=pn_b,h=20,center=false);
            }
            cylinder(d=dh_d,h=20,center=false);
         }
     }
 }
 module centr()
 {
     difference()
     {
         union()
         {
            translate([0,0,ht_th])
                cylinder(d1=ht_od,d2=ht_od-ht_th,h=ht_th,center=false);
     
                cylinder(d2=ht_od,d1=ht_od-ht_th,h=ht_th,center=false);
         }
         union()
         {
            // Holes for bolts to hold spool pieces together
            for (i = [0 : 120 : (360 - .01)])
            {
                rotate([0,0,i])
                 translate([pn_d/2,0,0])
                    cylinder(d=pn_b,h=20,center=false);
            }
//            d_hole();
            cylinder(d=dh_d,h=20,center=false);
         }
     }
 }
 
 module total()
 {
     hat1();
     
    translate([30,0,0])
        hat2();
     
     translate([0,30,0])
         centr();
     
 }
 total();
 