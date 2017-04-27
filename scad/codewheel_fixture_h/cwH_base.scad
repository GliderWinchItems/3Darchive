/* File: cwH_base.scad
 * Photocell sensor magnet mount for sheave codewheel
 * Reflective photosensors version, (H = horizontal over top)
 * Author: deh
 * Latest edit: 20170417
 */

 $fn=50;

include <../library_deh/deh_shapes.scad>
include <cwH_common.scad>

po_bot_thick = mag_stud_len - mag_washer_thick - mag_nut_thick;
po_screw_dia = mag_stud_dia + 0.5; // Magnet stud hole (include slop)
po_inner_dia = mag_washer_dia + 2.5;
po_inner_ht = po_inner_dia + mag_washer_thick + mag_nut_thick + 1;
po_cutout = 8;	// Width of access-to-nut cutout
po_selftap_dia = 2.8;	// Self-tapping screw diameter
po_selftap_len = 15; 	// Hole depth for self-tappping screw
po_hex_nut = mag_nut_hex_peak + 0.4;
po_hex_nut_ht = mag_nut_thick + .5;

fc_protrude = 2;	// Photodetectors protrude below base
fc_gap = 3;		// Gap between photodetector and top of encoder disc

//po_ht = sp_ht + mag20_thick - mag_thick - fc_protrude - fc_gap;
po_ht = 49.3;	// Post height

module post()
{
echo (po_ht);
  difference()
  {
    union()
    {
       cylinder(d = sp_dia, h = po_ht, center = false);
    }
    union()
    {
       // Magnet stud hole
       cylinder (d = po_screw_dia, h = mag_stud_len + 4, center = false);

       // Top plate mounting self-tapping screw hole
       translate([0,0,po_ht - po_selftap_len + 0.01])
       cylinder (d = po_selftap_dia, h = po_selftap_len, center = false); 

       // Washer pocket
       translate([0,0,po_bot_thick])
         cylinder(d = mag_washer_dia, h = mag_washer_thick + .25, center = false);

       // Nut pocket
       translate([0,0,po_bot_thick + mag_washer_thick - 0.1])
          linear_extrude(height = mag_nut_thick + .25, center=false)
             circle(d = po_hex_nut, $fn=6);      
    }
  }
}

we_thick = 3;	// Thickness of web
we_len_1 = sp_x - sp_dia/2 + 1;
we_len_2 = sp_y - sp_dia/2;
//we_ht = po_ht - sp_ht_tol;	// Web height
we_ht = 20;	// Web height
we_wid = sp_dia;	// Width of bottom flat stiffener
we_rad = 10;		// Fillet radius

module frame()
{
   // Three main posts
   rotate([0,0,180])
     post();
   translate([sp_x, sp_y/2,0])
     post();
   translate([sp_x,-sp_y/2,0])
     post();

   // Web connecting posts
   translate([sp_dia/2 + we_len_1/2 - .1,0,we_ht/2])
     cube([we_len_1, we_thick, we_ht], center = true);
   translate([sp_x,0,we_ht/2])
     cube([we_thick, we_len_2 - sp_dia/2, we_ht], center = true);

  // T bar bottom stiffener
  translate([0,0,0])
    eye_bar(sp_dia, po_screw_dia, sp_x, we_thick);

  translate([sp_x,sp_y/2,0])
   rotate([0,0,-90])
    eye_bar(sp_dia, po_screw_dia, sp_y/2 + 0.1, we_thick);

  translate([sp_x,-sp_y/2,0])
   rotate([0,0, 90])
    eye_bar(sp_dia, po_screw_dia, sp_y/2, we_thick);

  // Fillets on bottom of web 
  translate([sp_x - we_wid/2 +.1,we_wid/2 - .1,0])
   rotate([0,0,90])  
     fillet (we_rad,we_thick);

  translate([sp_x - we_wid/2 +.1, -we_wid/2 + .1,0])
   rotate([0,0,180])  
     fillet (we_rad,we_thick);

  // Midpoint marker
  translate([sp_x/2,-(we_wid+1)/2,0])
   cube([0.5, we_wid+1,we_thick+0.5], center = false);

}

module total()
{
  difference()
  {
    union()
    {
       frame();
    }
    union()
    {
    }
  }
}
total();

