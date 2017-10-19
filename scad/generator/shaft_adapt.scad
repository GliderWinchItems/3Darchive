/* scad/generator/shaft_adapt.scad
 * Magnet stud to flex coupline for encoder
 * Date of latest: 20171015
 * Skirt & post w magnet adapater
 */

include <generator_common.scad>
include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>

$fn = 50;

/* Select stud magnet */
magx_thick            = mag16_M4_thick;	          // Magnet thickness (base to shell top)
magx_shell_flat_dia   = mag16_M4_shell_flat_dia;  // Dia of flat of magnet
magx_shell_dia        = mag16_M4_shell_dia;	  // Dia of magnet shell
magx_stud_dia         = mag16_M4_stud_dia;        // Dia of mounting magnet studs
magx_stud_len         = mag16_M4_stud_len;        // Height of stud from magnet back
magx_washer_thick     = mag16_M4_washer_thick;    // Thickness of washer
magx_nut_thick        = mag16_M4_nut_thick;       // M5 Nut for stud thickness
magx_nut_hex_peak     = mag16_M4_nut_hex_peak;    // M5 nut across peaks (also dia of nut)
magx_washer_dia       = mag16_M4_washer_dia;      // Washer diameter of washer for magnet stud
magx_washer_dia_extra = mag16_M4_washer_dia_extra;// Washer slop

flex_id = 6;	// Inside diameter of flexible tube
flex_len = 8;	// Length adapter inserts into tubing



//mm_ht12 = magx_thick + 1;	// Skirt around magnet
mm_ht12 = 0;
mm_ht23 = mm_ht12 + 7;
mm_ht34 = 2;
mm_ht45 = flex_len;
mm_ht56 = 1;

/* Ring (skirt) goes around mag post part */
skirt_id = magx_shell_dia + 0.3;
skirt_od = eb_post_id - 0.4;
skirt_ht = mm_ht23 + mm_ht34 + 7;

mm_dia1 = skirt_id - 0.3;	// Fits inside skirt
mm_dia2 = skirt_id - 0.3;	// Fits inside skirt
mm_dia3 = skirt_id - 0.3;	// Fits inside skirt
mm_dia4 = flex_id;
mm_dia5 = flex_id;
mm_dia6 = flex_id - 2;


ss_dia1 = magx_stud_dia + 0.5;
ss_nut_dia = magx_nut_hex_peak + 0.6;

ss_stud_base_dia = 4.3; // Where stud meets shell
ss_stud_base_ht = .6;

module skirt()
{
   // Skirt around magnet
   difference()
   {
      cylinder(d = skirt_od, h = skirt_ht, center=false);
      cylinder(d1 = skirt_id, d2 = skirt_id - .4, h = skirt_ht, center=false);

   }

}


module post()
{
   translate([0,0,0])
     cylinder(d1 = mm_dia2, d2 = mm_dia3, h = mm_ht23, center=false);

   translate([0,0,mm_ht23])
     cylinder(d1 = mm_dia3, d2 = mm_dia4, h = mm_ht34, center=false);
   
   // shaft that inserts into flexible tubing
   translate([0,0,mm_ht23+mm_ht34])
     cylinder(d = flex_id, h = mm_ht45, center=false);


//     cylinder(d1 = mm_dia4, d2 = mm_dia5, h = mm_ht45, center=false, $fn = 12);

   // Chamfer for inserting into tube
   translate([0,0,mm_ht23+mm_ht34+mm_ht45])
     cylinder(d1 = mm_dia5, d2 = mm_dia6, h = mm_ht56, center=false);


}

module holes()
{
  // Stud
studbaseht = mm_ht12;
   translate([0,0,studbaseht])
     cylinder(d = ss_dia1, h = magx_stud_len + 2, center=false);

  // Stud base ridge
  translate([0,0,studbaseht])
    cylinder(d = 4.41, h = 0.55, center=false);

  // Washer
washerht = mm_ht12 + 3;	 	// Bottom of washer
  translate([0,0,washerht])
    cylinder(d = magx_washer_dia + 0.5, h = magx_washer_thick, center=false);

  // Nut
nutht = washerht + magx_washer_thick; // Top of washer, bottom of nut
  translate([0,0,nutht])
    cylinder(d = ss_nut_dia, h = magx_nut_thick, center= false, $fn = 6);
}


module total()
{
  difference()
  {
    union()
    {
      post();
    }
    union()
    {
      holes();
    }
  }
  translate([25,0,0])
    skirt();
}
total();
