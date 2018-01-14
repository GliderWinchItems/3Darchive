/* scad/fairlead/fadaptM5.scad
 * Magnet stud to flex coupling w M5 magnet
 * Date of latest: 20171130
 */

include <fairlead_common.scad>
include <../library_deh/deh_shapes.scad>
include <fairlead_common.scad>

$fn = 50;

/* Select stud magnet */
magx_thick            = mag25_thick;	       // Magnet thickness (base to shell top)
magx_shell_flat_dia   = mag25_shell_flat_dia;// Dia of flat of magent
magx_stud_dia         = mag25_stud_dia;        // Dia of mounting magnet studs
magx_stud_len         = mag25_stud_len;        // Height of stud from magnet back
magx_washer_thick     = mag25_washer_thick;    // Thickness of washer
magx_nut_thick        = mag25_nut_thick;       // M5 Nut for stud thickness
magx_nut_hex_peak     = mag25_nut_hex_peak;    // M5 nut across peaks (also dia of nut)
magx_washer_dia       = mag25_washer_dia;      // Washer diameter of washer for magnet stud
magx_washer_dia_extra = mag25_washer_dia_extra;// Washer slop

flex_id = 6 - 0.1;	// Coupler hole diameter (nominal - tolerance)
flex_len = 10;	// Length shaft that fits into coupler

mm_xtra = 4;	// Wider diameter than washer


mm_ht12 = mm_xtra;
mm_ht23 = 8;//magx_stud_len - magx_nut_thick+.3 -  magx_washer_thick - mm_ht12 + 3;
mm_ht34 = 3;
mm_ht45 = flex_len;
mm_ht56 = 2;


mm_dia1 = magx_washer_dia;
mm_dia2 = magx_washer_dia + mm_xtra;
mm_dia3 = magx_nut_hex_peak + 4;
mm_dia4 = flex_id;
mm_dia5 = flex_id;
mm_dia6 = flex_id - 3;

ss_dia1 = magx_stud_dia + 0.5;
ss_nut_dia = magx_nut_hex_peak + 0.6;

ss_stud_base_dia = 4.3; // Where stud meets shell
ss_stud_base_ht = .6;



/* Put small splines on shaft that goes into flexible tubing
 * dia = diameter of solid shaft
 * len = length of solid shaft
 */
spl_l = mm_ht45;
spl_w = 1.0;
spl_h = 1.0;


module splined_shaft(dia,len)
{

   cylinder(d = dia, h = len, center=false);

/* Elminate spline for coupler version  
   // 0.2 embeds it slightly to avoid non-manifold error
   translate([dia/2 - 0.2,0,0])
    wedge_isoceles(spl_l, spl_w, spl_h);
*/
}

module post()
{

   cylinder(d1 = mm_dia2+4, d2 = mm_dia2, h = mm_ht12, center=false);

   translate([0,0,mm_ht12])
     cylinder(d1 = mm_dia2, d2 = mm_dia3, h = mm_ht23, center=false);

   translate([0,0,mm_ht12+mm_ht23])
     cylinder(d1 = mm_dia3, d2 = mm_dia4, h = mm_ht34, center=false);
   
   // shaft that inserts into flexible tubing
nspline = 9;
     for (i = [0 : 360/nspline : 360])
      rotate([0,0,i])
       translate([0,0,mm_ht12+mm_ht23+mm_ht34])
         splined_shaft(mm_dia4,mm_ht45);

   // Chamfer for inserting into tube
   translate([0,0,mm_ht12+mm_ht23+mm_ht34+mm_ht45])
     cylinder(d1 = mm_dia5, d2 = mm_dia6, h = mm_ht56, center=false);


}

module holes()
{
  // Stud
  cylinder(d = ss_dia1, h = magx_stud_len + 3, center=false);

  // Washer
  translate([0,0,mm_ht12])
    cylinder(d = magx_washer_dia + 0.7, h = magx_washer_thick + .4, center=false);

  // Nut
  translate([0,0,mm_ht12+magx_washer_thick])
    cylinder(d = ss_nut_dia + 0.5, h = magx_nut_thick + 0.5, center= false, $fn = 6);

  // Stud base (has a slightly larger dia boss)
  cylinder(d = ss_stud_base_dia, h = ss_stud_base_ht, center=false);

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
}
total();
