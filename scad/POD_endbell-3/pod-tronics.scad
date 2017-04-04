/* pod_tronics.scad
   POD #3 main enclosure
   04/02/2017
*/

$fn = 200;

include <enclose_cutout.scad>;
include <../library_deh/deh_shapes.scad>

dia_od = (105); // diameter (inside of bottle)

thick_bottom = 1;
thick_sides = 1;


chfm_ht = 4;
chfm_wid = 3;

extra = 1;	// Slop & shrinkage allowance

module chamfer()
{
     // Sides with chamfer at bottom edge
//    difference()
     {
        cylinder(h = chfm_ht, 
           r1 = dia_od/2-chfm_wid, 
           r2 = dia_od/2, 
           center = false);
/*        cylinder(h = chfm_ht, 
          d = (dia_od - 2*chfm_wid), 
          center = false);
*/
     }
 }
dia_hatch = 25;
dh_ht = 72;
dh_in = 38;
dh_x = wid_mid/2 - dh_in;
module side_hatch()
{
  translate([dh_x,70,dh_ht-neck_ofs])
   rotate([90,0,0])
    cylinder(d = dia_hatch, h = 60, center = false);

}
ld_ht = 110;
ld_in = 14;
dia_led = 30;
ld_x = wid_mid/2 - ld_in;

module led_port()
{
  translate([ld_x,70,ld_ht-neck_ofs])
   rotate([90,0,0])
    cylinder(d = dia_led, h = 60, center = false);


}

neck_ofs = 2;	// Enclosure goes into neck a bit

module en_cutout()
{
  translate([0,0,-.01])
   enclose_cutout(len_en-neck_ofs+10, extra);
}



side_ht = len_en-neck_ofs-chfm_ht+0.02;

module insert()
{
  translate([0,0,chfm_ht])
   cylinder(d = dia_od, h = side_ht, center = false);
   chamfer();
}

tr_thick = 3;
tr_ht = 13;
module top_ring_recess()
{

  translate([0,0,side_ht-tr_ht])
 {
     difference()
     {
        cylinder(d = dia_od, h = tr_ht, center = false);
        cylinder(d = dia_od-2*tr_thick, h = tr_ht, center = false);
     }
  }

}
module side_hole()
{
      translate([dia_od/2-tr_thick*2,0, side_ht-(tr_ht/2)] )
      rotate([90,0,90])
        cylinder(d = 2.0, h = 40, center = true);
}
module side_holes()
{
      rotate([0,0,   0]) side_hole();
      rotate([0,0,  60]) side_hole();
      rotate([0,0,  90]) side_hole();
      rotate([0,0, 120]) side_hole();
      rotate([0,0, 180]) side_hole();
      rotate([0,0, -60]) side_hole();
      rotate([0,0, -90]) side_hole();
      rotate([0,0,-120]) side_hole();

}



module total()
{
   difference()
   {
      union()
      {
         insert();
      }
      union()
      {
	en_cutout();
	side_hatch();
	led_port();
//  	top_ring_recess();
//        side_holes();
      }
   }
}
total();


