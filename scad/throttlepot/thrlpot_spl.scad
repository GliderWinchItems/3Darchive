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
 ht_rg = 21;
 ht_ww = 2.5;
 ht_id  = ht_rg;
 ht_id1 = 16;
 
 pn_d = 12;     // Diameter holes to pin pieces together
 pn_b = 2.4;    // Pin bolt hole diameter
 
 dh_d = 6.0+.5;    // Pot shaft diameter
 dh_c = 4.46+.3;
 dh_x = dh_c-dh_d/2;

s_hole = 1.5;	// Diameter of hole for string
 
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
//            d_hole();
            cylinder(d=dh_d,h=20,center=false);
            
            // Holes to thread string through
            translate([-pn_d/2,0,0])
                cylinder(d=s_hole,h=20,center=true);
            
            rotate([0,0,-135])
              translate([-ht_id/2,0,0])
                cylinder(d=s_hole,h=20,center=true);  
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
//            cylinder(d=dh_d,h=20,center=false);
            d_hole();
            
            // Holes to thread string through
            translate([-pn_d/2,0,0])
                cylinder(d=s_hole,h=20,center=true);
            
              rotate([0,0,-135])
              translate([-ht_id/2,0,0])
                cylinder(d=s_hole,h=20,center=true);            
           
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
         {           translate([-pn_d/2,0,0])
                cylinder(d=s_hole,h=20,center=true);
            
                        rotate([0,0,-135])
              translate([-pn_d/2,0,0])
                cylinder(d=s_hole,h=20,center=true);  
            // Holes for bolts to hold spool pieces together
            for (i = [0 : 120 : (360 - .01)])
            {
                rotate([0,0,i])
                 translate([pn_d/2,0,0])
                    cylinder(d=pn_b,h=20,center=false);
            }
//            d_hole();
            cylinder(d=dh_d,h=20,center=false);
            
            // Holes to thread string through
            translate([-pn_d/2,0,0])
                cylinder(d=s_hole,h=20,center=true);
            
                        rotate([0,0,-135])
               translate([-ht_id/2,0,0])
                cylinder(d=s_hole,h=20,center=true);  
         }
     }
 }
 
  module plate()
 {
     difference()
     {
         union()
         {
            cylinder(d1=ht_od,d2=ht_od-ht_th,h=ht_th,center=false);          
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
            // Center punch-out
//            d_hole();
            cylinder(d=dh_d,h=20,center=false);
            
            // Holes to thread string through
            translate([-pn_d/2,,0,0])
                cylinder(d=s_hole,h=20,center=true);
            
            rotate([0,0,-135])
               translate([-ht_id/2,0,0])
                cylinder(d=s_hole,h=20,center=true);  
         }
     }
 }
 th_h = 4.5;    // Height of thimble
 th_w = 1;      // Wall thickness
 th_thx = 1;    // Thickness
 module thimble()
 {
    difference()
     {
         union()
         {
             cylinder(d=ht_id,h=ht_ww,center=false);
             
             cylinder(d=dh_d+th_w, h=th_h,center=false);
     
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
 
 module spacer(len)
 {
     sp_wall = 1.5; // Space wall thickness
     difference()
     {
         cylinder(d=dh_d+sp_wall,h=len,center=false);
         cylinder(d=dh_d,h=len,center=false);
     }
 }

module tiebar()
{
 translate([0,0,3/2])
 {
   translate([-3/2-1.0,0])
		cube([2,3,3],center=true);
	translate([3/2+1,0,0])
		cube([2,3,3],center=true);
	cube([6,2,2],center=true);
 }
}
  
 
 module total()
 {
     translate([ 0,0,0])  hat1();
     
     translate([30,0,0])  hat2();
     
     translate([0,30,0])  centr();
     
//     translate([30,30,0]) plate();

//     translate([30,60,ht_th]) rotate([180,0,0]) plate();
     
//     translate([ 0,60,0]) 
//     {
//         translate([0,0,ht_th])
//            thimble(); 
//         translate([0,0,ht_th])
//          rotate([180,0,0])
//         plate();
//     }
     
      translate([0,-20,0]) spacer(5);

	  translate([-20,0,0]) tiebar();
   	  translate([-20,8,0]) tiebar();

 }
 total();
 
