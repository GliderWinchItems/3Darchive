/* scad/fairlead/stand.scad
 * Encoder support stand for fairlead
 * Date of latest: 20170830
 */

include <fairlead_common.scad>
include <encoder_plate.scad>

$fn = 50;

module base_plate()
{
   difference()
   {
        rounded_rectangle(bp_sq, bp_sq, bp_thick, bp_rad);
       
        rounded_rectangle(bp_in, bp_in, bp_thick, bp_rad);
   }
}


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

/* Skim off tops of posts to make a flat surface */
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

/* This piece goes on top of the posts */
/* Encoder plate with mounts on top of this. */
module top_piece()
{
    ww = ep_sq * 2;
    difference()
    {
        translate([0,0,ep_thick/2])
         rotate([0,0,45])
          cube([ep_sq,ep_sq,ep_thick],center=true);

        union()
        {
          translate([0,0,-1])
           cylinder(d = en_r_dia, h = 50, center = true);

          for (i = [0+45 : 90 : 360+45])
          {
            rotate([0,0,i])
             translate([65,0,-1]) 
              cylinder(d = 66, h = 50, center = true);
          }

          difference()
          {
            translate([0,0,ep_thick/2])
              cube([ww,ww,ep_thick],center=true);
            union()
            {
              translate([0,0,ep_thick/2])
                cube([ep_sq,ep_sq,ep_thick],center=true);            
            }
          }
	  rotate([0,0,45])
            vposts(5);	
        }
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
    
translate([0,0,37+8])
  top_piece();


translate([0,0,60])
 rotate([0,0,45])
  totalplate();   

}
total();
