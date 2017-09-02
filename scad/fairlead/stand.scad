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
   {   // Ties posts together at base
        rounded_rectangle(bp_sq, bp_sq, bp_thick, bp_rad);
       // Cutout: surrounds bearing block
        rounded_rectangle(bp_in, bp_in, bp_thick, bp_rad);
   }
}

/* Short vertical section clears bearing block square base */
module vert_post(ht)
{
 
   translate([vp_ofs_x+bd_ofs,0,0]) // Center on base outer band
    scale([sc_x, sc_y, 1.0])  // Elliptical cross-section
     cylinder(d = vp_dia, h = ht, center=false);
}

/* Bend posts inward */
module bend_post(theta)
{
 rotate([90,0,0])
  rotate_extrude(angle = theta, convexity = 10)
   translate([bd_ofs,0])
    scale([sc_x,sc_y])
     circle(r = vp_dia/2);
}
/* Composite: vertical | bend | slanted & flat-topped */
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

/* Four posted support for encoder */
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
         cylinder(d = vp_dia, h = 90, center=false);

     top_surface();
  }
}
/* Holes and embedded nuts & washers to hold top_piece to stand posts */
module top_bolt()
{
   // Bolt threads
   translate([0,0,-tb_thread_ofs_z + 0.05]) // Threads go down from top surface
     cylinder(d = tb_dia, h = tb_thread_ofs_z, center=false);

   // Washer
   translate([0,0,-tb_washer_ofs_z]) // 
     cylinder(d = tb_washer_dia, h = tb_washer_thick, center=false);

   // Nut
   translate([0,0,-tb_nut_ofs_z])
     cylinder(d = tb_nut_dia, h = tb_nut_thick, center=false, $fn = 6);

}
module top_bolts()
{
   for (i = [0 : 90 : 360])
   {
     rotate([0,0,i])
       translate([tb_ofs_x,0,tf_ofs_z])
         top_bolt();
   }
}

/* This piece goes on top of the posts */
/* Encoder plate with mounts on top of this. */
module top_piece()
{
    ww = ep_sq * 2;
    difference()
    {
        union()  // Start with square plate
        {
          translate([0,0,ep_thick/2])
            rotate([0,0,45])
             cube([ep_sq,ep_sq,ep_thick],center=true);
        }
        union() // cutouts
        {
          // Large center hole
          translate([0,0,-1])  
           cylinder(d = en_r_dia, h = 50, center = true);

          // Semi-circular mainly to save plastic
          for (i = [0+45 : 90 : 360+45])
          {
            rotate([0,0,i])
             translate([65,0,-1]) 
              cylinder(d = 66, h = 50, center = true);
          }

          // Cut the tips of the square off, roughly flush with post
          difference()
          {
            translate([0,0,ep_thick/2])
              cube([ww,ww,ep_thick],center=true);

            translate([0,0,ep_thick/2])
              cube([ep_sq,ep_sq,ep_thick],center=true);            
          }

          // Large holes for encoder plate mtg
	  rotate([0,0,45])
            vposts(5);	

          for (i = [0 : 90 : 360])
          {
            rotate([0,0,i])
             translate([tb_ofs_x,0,0])
               cylinder(d = tb_dia, h = ep_thick, center=false);
          }
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
       top_bolts();
     }
   }

translate([0,0,30])
{
// Temporary for visualization
translate([0,0,90-13])
  top_piece();

// Encoder plate, temporary
translate([0,0,100])
 rotate([0,0,45])
  totalplate();   
}

}
total();
