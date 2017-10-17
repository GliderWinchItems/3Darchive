/* scad/fairlead/Dsleevet.scad
 * Sleeve for D shaft of encoder
 * Date of latest: 20170906
 */

include <fairlead_common.scad>
include <../library_deh/deh_shapes.scad>
include <fairlead_common.scad>

$fn = 50;

enc_del = .5;	// Thickness of shell

real_dia = enc_shaft_dia + 0.4; // Measured after-print dia

module sleeve()
{
  cylinder (d = real_dia + enc_del, h = enc_len_d, center = false);

}

big = 20;
module sleeve_cutout()
{
  difference()
  {
     cylinder(d = real_dia, h = enc_len_d, center = false);

     translate([real_dia/2  - (real_dia - enc_shaft_dflat),
          -real_dia/2,0])
       cube ([big, real_dia,enc_len_d], center=false);
  }
}

module total()
{
 difference()
 {
  sleeve();
  sleeve_cutout();
 }


}
total();
