/* scad/fairlead/stand.scad
 * Encoder support stand for fairlead
 * Date of latest: 20170830
 */

include <../library_deh/deh_shapes.scad>

bb_sq = (3.75 * 25.4);	// Square bearing block size

/* Base plate */
bp_wid = 22;	// Width of base plate foot around bearing block
bp_sq = bb_sq + 2*bp_wid;	//  Side length
bp_in = bb_sq + 3;	//  Bearing block cutout length
bp_thick = 4;	// Base plate thickness
bp_rad = 3;	// Nice looking radius on corner

$fn = 50;

module base_plate()
{
   difference()
   {
        rounded_rectangle(bp_sq, bp_sq, bp_thick, bp_rad);
       
        rounded_rectangle(bp_in, bp_in, bp_thick, bp_rad);
   }
}

pt_theta = 40;	// Angle of bend in posts (deg)
bd_ofs = 30;	// Radius for rotate extrude of bend

vp_dia = 26;	// Vertical Post main diameter
vp_ht = 6;	// Vertical post height
sc_x = 0.6;	// Scale x--squish cylinder to ellipse
sc_y = 1.0;	// Scale y--width 

ofs_x = bp_sq/2 - vp_dia/2; // Position post over base
vp_r = (vp_dia * sc_x)/2;
vp_ofs_x = ofs_x-bd_ofs + vp_r;

module vert_post(ht)
{
 
   translate([vp_ofs_x+bd_ofs,0,0])
    scale([sc_x, sc_y, 1.0])
     cylinder(d = vp_dia, h = ht, center=false);
}

module bend_post(theta)
{
 rotate([90,0,0])
  rotate_extrude(angle = theta, convexity = 10)
   translate([bd_ofs,0])
    scale([sc_x,sc_y])
     circle(r = vp_dia/2);
}
module total_post()
{
  translate([-vp_r/2,0,0])
  {
    vert_post(vp_ht);

    translate([vp_ofs_x,0,0])
     translate([0,0,vp_ht])
      bend_post(pt_theta);

    slant_post();
  }
}

module total_posts()
{
    total_post(vp_ht);
    rotate([0,0, 90]) total_post(vp_ht);
    rotate([0,0,-90]) total_post(vp_ht);
    rotate([0,0,180]) total_post(vp_ht);
}

tf_sq = 110;
tf_ofs_z = 36;
module top_surface()
{
   translate([-tf_sq/2,-tf_sq/2,tf_ofs_z])
     cube([tf_sq,tf_sq,100],center=false);
}

module slant_post()
{
  difference()
  {
     translate([vp_ofs_x,0,vp_ht])
      rotate([0,-pt_theta,0])
       translate([bd_ofs,0,0])
        scale([sc_x, sc_y, 1.0])
         cylinder(d = vp_dia, h = 40, center=false);

     top_surface();
  }
}

module total()
{
   difference()
   {
     union()
     {
       base_plate();
       total_posts();
     }
     union()
     {
     }
   }
}
total();
