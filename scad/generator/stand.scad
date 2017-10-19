/* scad/generator/stand.scad
 * Encoder support stand for encoder on generator
 * Date of latest: 20171011
 *
 * V1 - 20171015 Adjusted dia's and len's
 */

include <generator_common.scad>
include <encoder_plate.scad>

$fn = 50;

// **** Id the part ***
module id()
{
 id_x = vp_dia;
 id_y = bp_sq/2 - 1;
 {
/*
  font = "Liberation Sans:style=Bold Italic";
  translate([0,gs_tube_od/2 - 1.5, 20]) 
  rotate([-90,0,0])
  linear_extrude(2)
   text("V1",size = 5);
*/

 rotate([0,0,95])
 translate([gs_tube_od/2 - 1,0, 48]) 
  rotate([0,90,0])
    linear_extrude(2)
      text("2017 10 11 V1",size = 5);
 }
}
gs_tube_dia = (gs_od-gs_id);
gs_tube_od = vpost_ofs_x*2 + 3;
gs_tube_id = vpost_ofs_x*2 - 3;

module rib()
{

 translate([vpost_ofs_x,0,bp_thick])
  cylinder(d = 6, h = gs_tube_len, center=false);
}

module ribs()
{
     for (i = [0+45 : 90 : 360+45])
     {
        rotate([0,0,i])
           rib();    
     }

}

/* Top encoder plate mounting holes */
module tp_holes()
{
   translate([0,0,-10])
   vposts(2.8); // Self tap 4-40 dia
}

/* Mounting holes: stand bottom flange to endbell */
module bf_holes()
{
    for (i = [0 : 120 : 360])
     {
        rotate([0,0,i])
           translate([gs_id/2 + 5,0,0])    
            cylinder(d = 3.5,h = 10, center=false);
     }  

}

module base_plate()
{
  difference()
  {
     union()
     {     
	// Base flange
        tubedeh(eb_max_dia, gs_id, gs_thick);

        // Vertical tube
        tubedeh(gs_tube_od, gs_tube_id, gs_thick + gs_tube_len);

	ribs();
     }
     union()
     {
        // Access cutout
        translate([-gs_od/2-4,-gs_access_wid/2,gs_thick+5])
           cube([gs_od+8,gs_access_wid, gs_tube_len+5],center=false);

  	// Bottom water drain cutout
        translate([-gs_drain_wid/2,-gs_od+8/2,gs_thick+5])
           cube([gs_drain_wid,gs_od, gs_tube_len+5],center=false);

	// Top encoder plate mounting holes
	translate([0,0,gs_thick + gs_tube_len])
 	   tp_holes();

	// Base to endbell mounting holes
	bf_holes();
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
     cylinder(d = tb_washer_dia, h = tb_washer_thick, center=false);

   // Nut
   translate([0,0,-tb_nut_ofs_z])
     cylinder(d = tb_nut_dia, h = tb_nut_thick, center=false, $fn = 6);

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

/* This piece goes on top of the posts */
/* Encoder plate with mounts on top of this. */
module top_piece_nut_washer()
{
echo ("te_ofs_washer_z",te_ofs_washer_z);
echo ("te_ofs_nut_z",te_ofs_nut_z);
   // Bolt hole
   cylinder(d = te_dia, h = ep_thick+5, center=false);

   // Washer
   translate([0,0,te_ofs_washer_z]) // 
     cylinder(d = te_washer_dia, h = te_washer_thick, center=false);

   // Nut
   translate([0,0,te_ofs_nut_z])
     cylinder(d = te_nut_dia, h = te_nut_thick, center=false, $fn = 6);   

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
PRINTSTAND = true;
PRINTENCODERPLATE = false;

module total()
{
 if (PRINTSTAND)
 {
   difference()
   {
     union()
     {
       base_plate();
       id();
     }
     union()
     {
       top_bolts();
     }
   }
// #### Place plates on top for visualization ####
   TOPVIZUALIZE(false);  
 }
   if (PRINTENCODERPLATE)
   {
     if (PRINTSTAND)
     {
	translate([0,0,50])
          totalplate();   
     }
     else
          totalplate();   
     }
}
total();
