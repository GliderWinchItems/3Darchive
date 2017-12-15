/* scad/fairlead/stand.scad
 * Encoder support stand for fairlead
 * Date of latest: 20170830
 *
 * 2017 09 10 v1: M4 stud, 6-23 post, 4-40 encoder plate 
 * 2017 12 09 v2: Added spacer to go under encoder plate
 */

include <fairlead_common.scad>
include <encoder_plate.scad>

$fn = 50;

// **** Id the part ***
module id()
{
 id_x = vp_dia;
 id_y = bp_sq/2 - 1;
 {
  font = "Liberation Sans:style=Bold Italic";
  translate([id_x - 6,-id_y, bp_thick]) 
  linear_extrude(2)
   text("fairlead/stand",size = 5);

 translate([-id_x - 31,-id_y, bp_thick]) 
  linear_extrude(2)
   text("2017 12 09 v2",size = 5);
 }
}

module base_plate()
{
   difference()
   {
echo ("bp_sq", bp_sq);   
     union()
     { // Ties posts together at base
        rounded_rectangle(bp_sq, bp_sq, bp_thick, bp_rad);

       // Vertical stiffner
        translate([0,0,bp_thick])
         rounded_rectangle(bp_vsq, bp_vsq, bp_ht, bp_rad);
        
     }
     union()
     {
echo ("bp_in",bp_in);
       // Cutout: surrounds bearing block
        rounded_rectangle(bp_in, bp_in, bp_thick, bp_rad);

       // Vertical stiffner cutout
        translate([0,0,bp_thick])
         rounded_rectangle(bp_vsqm, bp_vsqm, bp_ht, bp_rad);
     }
   }
}

/* Short vertical section clears bearing block square base */
module vert_post(ht)
{
echo("ht",ht);
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
/* Single post composite of three pieces--
  vertical | bend | slanted & flat-topped */
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

/* Slanted part of a post with top sliced flat */
module slant_post()
{
  difference()
  {
     translate([vp_ofs_x,0,vp_ht])
      rotate([0,-pt_theta,0])    // Tilt the same as the bend
       translate([bd_ofs,0,0])
        scale([sc_x, sc_y, 1.0]) // Elliptical cross section
         cylinder(d = vp_dia, h = 90, center=false);

     top_surface(); // Flat top 
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
     cylinder(d = tb_washer_dia + .65, h = tb_washer_thick + 0.4, center=false);

   // Nut
   translate([0,0,-tb_nut_ofs_z])
     cylinder(d = tb_nut_dia + .65, h = tb_nut_thick + 0.4, center=false, $fn = 6);

}
/* Bolt holes w nut & washer for top of stand posts */
module top_bolts()
{
   for (i = [0 : 90 : 360])
   {
     rotate([0,0,i])
       translate([tb_ofs_x,0,tf_ofs_z])
         top_bolt();
   }
}
/* Base magnet */
module base_magnet()
{
   // Stud hole
   hole_ht = magbx_stud_len + 4; 
/*
echo ();
echo("hole",hole_ht);
echo("magbx_stud_len",magbx_stud_len);
echo("bp_thick",bp_thick);
echo("magbx_washer_thick",magbx_washer_thick);
echo("magbx_nut_thick",magbx_nut_thick);
*/
   cylinder(d = magbx_stud_dia + 0.2, h = hole_ht, center=false);

   // Washer
   translate([0,0,bx_washer_ofs_z]) // 
     cylinder(d = magbx_washer_dia + 0.4, h = magbx_washer_thick + 0.35, center=false);

   // Nut
   translate([0,0,bx_nut_ofs_z])
     cylinder(d = magbx_nut_hex_peak + 0.6, h = magbx_nut_thick + 0.3, center=false, $fn = 6);
}
module base_magnets()
{
   for (i = [0 : 90 : 360])
   {
     rotate([0,0,i])
       translate([vp_ofs_x+bd_ofs-vp_r/2,0,0])
         base_magnet();
   }
}

/* This piece goes on top of the posts */
/* Encoder plate with mounts on top of this. */
module top_piece_nut_washer()
{
echo ("te_ofs_washer_z",te_ofs_washer_z);
echo ("te_ofs_nut_z",te_ofs_nut_z);
   // Bolt hole
   cylinder(d = te_dia, h = ep_thick+5, center=false);
/* Insertion of washer & nut requires thicker piece
   // Washer
   translate([0,0,te_ofs_washer_z]) // 
     cylinder(d = te_washer_dia + 0.4, h = te_washer_thick + 0.4, center=false);

   // Nut
   translate([0,0,te_ofs_nut_z])
     cylinder(d = te_nut_dia + 0.65, h = te_nut_thick + 0.4, center=false, $fn = 6);   
*/
}
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
          for (i = [0 : 90 : 360])
          {
            rotate([0,0,i])
             translate([vp_d + enc_d/2,0,0])
               top_piece_nut_washer();
          }

          for (i = [0 : 90 : 360])
          {
            rotate([0,0,i])
             translate([tb_ofs_x,0,0])
               cylinder(d = tb_dia, h = ep_thick, center=false);
          }
        }
    } 
}

module TOPVIZUALIZE(SW)
{
  if (SW)
  {
   translate([0,0,30])
   {
     // Temporary for visualization
     translate([0,0,80]) // Height above stand post tops
      top_piece();

     // Encoder plate, temporary
     translate([0,0,100]) // Height above stand post tops
      rotate([0,0,45])
       totalplate();   
   }
  }
}
/* Switches for printing and visualization */
PRINTSTAND = false;//true;
PRINTTOP_PIECE = true;//false;
PRINTENCODERPLATE = true;//false;
PRINTTPSPACER = false; //true;

module total()
{
 if (PRINTTPSPACER)
 {
   translate([0,-120,0])
     totalplatespacer();
 }

 if (PRINTSTAND)
 {
   difference()
   {
     union()
     {
       base_plate();
       total_posts();
       id();
     }
     union()
     {
       top_bolts();
       base_magnets();
     }
   }
// #### Place plates on top for visualization ####
   TOPVIZUALIZE(false);  
 }
   if (PRINTENCODERPLATE)
   {
     translate([0,89,0])
       totalplate();   
   }
   if (PRINTTOP_PIECE)
   {
     translate([0,0,0])
       top_piece();
   }
//top_piece_nut_washer();
}
total();
