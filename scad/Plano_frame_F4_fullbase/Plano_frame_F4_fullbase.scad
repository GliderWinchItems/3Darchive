 /* File: Plano_frame_F4_fullbase.scad
 * Plano box with Discovery F4 and CAN module
 * Author: deh
 * Latest edit: 201700701
 * V1 2017 12 30: Capture 4-40 nuts for magnet stud
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>

 $fn=100;

// **** Id the part ***
module id()
{
 {
  font = "Liberation Sans:style=Bold Italic";
 translate([-25, 2, base_ht]) 
  linear_extrude(1.0)
   text("2017 12       30  V1",size = 4);
 }
}
 

//iso_post_ht = 3;

RJ_cutout_y = pc_y - p_ridge - dis_len + RJ_length + RJ_slop - RJ_cutout_length;

// Position of corner posts
 pc_cornerx =  (dis_wid/2) + p_offset;  // PC board corner
 pc_cornery =      base_len - dis_len - pod_post_q - p_offset;

module corner_cut(ccradius, ccht)
{
   difference()
   {
      cube([ccradius*2,ccradius*2,ccht],false);
      union()
      {
         translate([ccradius,ccradius,0])
            cylinder(d = ccradius*2, h = ccht, center = false);
         translate([ccradius,0,0])
            cube([ccradius+.01,ccradius*2+.01,ccht],false);    
         translate([0,ccradius,0])
            cube([ccradius*2+.01,ccradius+.01,ccht],false);  
      }
   }
}

// Make rectangle with rounded corners
module rect_rounded(rrl,rrw,rrh,rrad)
{
// rrl - length in X direction
// rrw - length in y direction
// rrh - height
// rrad - radius of corner
// position of returned figure: rrl = 0; rrw = 0;
//
   translate([0,rrad,0])
      cube([rrl,
          rrw - 2*rrad,
          rrh], false);

   translate([rrad, 0, 0])
      cube([rrl - 2*rrad, rrad, rrh],false); 

   translate([rrad, rrw - rrad, 0])
      cube([rrl - 2*rrad, rrad, rrh],false); 

   translate([rrad,rrad,0])
      cylinder(d = rrad*2, h = rrh,center = false);

   translate([rrl - rrad,rrad,0])
      cylinder(d = rrad*2, h = rrh,center = false);

   translate([rrl - rrad, rrw -rrad,0])
      cylinder(d = rrad*2, h = rrh,center = false);

   translate([rrad, rrw -rrad,0])
      cylinder(d = rrad*2, h = rrh,center = false);
}

// Post with screw hole
module iso_post_s(l,w,isph,hole_dia,hole_depth)
{
     difference()
     {
         union()
         {  // Post block
            cube([l,w,isph],false);
         }
         union()
         {
            // Self tapping screw holeinclude

            translate([l/2,w/2,.01])
                cylinder(h = isph, r1 = 0, r2 = hole_dia/2, 
                   center = false);
         }
     }        
}

// iso mount for CAN w switcher PC boardRJ_slop
module iso_post()
{

   // base of seat
   difference()
   { 
      // Outside dimensioned block
      cube([iso_osd_x + 2*iso_ridge_wid,
            iso_osd_y + 2*iso_ridge_wid,
            iso_post_ht + iso_ridge_ht],
            false);
      union()
      {
         // Center punched all-the-way
         translate ([(iso_lip + iso_ridge_wid),
                     (iso_lip + iso_ridge_wid),
                      -.01])
            cube([iso_osd_x - 2*iso_lip,
                  iso_osd_y - 2*iso_lip,
                  iso_post_ht + iso_ridge_ht + .02],
                  false);
         // Ridge/seat recessed
         translate ([iso_ridge_wid,
                     iso_ridge_wid,
                      iso_post_ht])

            cube([(iso_osd_x),
                  (iso_osd_y),
                   iso_ridge_ht],
                   false);

        // Cutouts that will be below this iso frame
        translate([10,0,0])
             cube([iso_osd_x - 25,
                   iso_side + 1.1,
                   iso_post_ht + iso_ridge_ht],
                   false);

        translate([iso_osd_x-9,(iso_wid - iso_side),0])
             cube([12,
                   8 ,
                   iso_post_ht + iso_ridge_ht],
                   false);

        translate([0,(iso_wid - iso_side),0])
             cube([12,
                   8 ,
                   iso_post_ht + iso_ridge_ht],
                   false);

      }
   }

}

// Post with recess for corner of POD board
dis_post_y = 10;
dis_post_ht = pod_post_ht - 3;
 module dis_post()
 {
    difference()
     {
       union()
       {
         translate([ 0,-dis_post_y,  0])
            cube([dis_post_y, dis_post_y, dis_post_ht + p_ridge],false);
       }
       union()
       {
            translate([dis_post_y/2, -dis_post_y/2, -0.01])
                cylinder(h = 20, d = screw_dia_s440_z, center = false);
       }
       
     }      
 }
jj = 0.5;	// Minor y direction adjustment
sid_wid = 2.5;  // Width of side rails
sid_len = 15;   // Length of side rails
sid_rail_y  = pc_y - pod_post_q - dis_len - jj;
sid_rail_y2 = pc_y - pod_post_q - dis_len + 65 - jj;

module side_rail(a, r, len, ht1, ht2)
{
   translate(a)
   {
     rotate(r)
     { 
       // Seat
       translate([-sid_wid,0,0])
         cube([sid_wid, len, ht1], false);

       // Ridge
         cube([sid_wid, len, ht2], false);
     }
   }
}

module side_rails()
{
   h1 = dis_post_ht;	// Height of seat
   h2 = h1 + p_ridge; // Height with ridge
   r0 = [0,0,0];
   r1 = [0,0,180];

   side_rail([-dis_wid/2, sid_rail_y  + sid_len-.01, 0],r1,sid_len,h1,h2);
   side_rail([-dis_wid/2, sid_rail_y2 + sid_len-.01, 0],r1,sid_len,h1,h2);

   side_rail([ dis_wid/2, sid_rail_y , 0],r0,sid_len,h1,h2);
   side_rail([ dis_wid/2, sid_rail_y2, 0],r0,sid_len,h1,h2);
}
angle = atan((9.6)/82.2);

// Basic side rail shape: wedge on rectangle
module side_rail_shape(len, ht1, ht2, thick)
{
  ax1 =  0;	ay1 =    0;
  ax2 =  0;	ay2 =  ht1;
  ax3 =  len;	ay3 =  ht2;
  ax4 =  len;	ay4 =    0;
rotate([0,0,-90]) 
rotate([90,0,0])
 linear_extrude(thick)
 {
     polygon(points = [
     [ax1,ay1], 
     [ax2,ay2], 
     [ax3,ay3], 
     [ax4,ay4]
              ] );
  }
}
/* Side rail: right & left
   len = length
   wid = width
   ht = height of short end (not inluding lip/ridge)
   angle = pre-defined slope (degrees)
   p_ridge = pre-defined lip (ridge)
   Reference: junction of inside and outside & short end 
*/
module side_rail_r(len,wid,ht,cut_len)
{
   ht2 = ht + len * sin(angle);
   difference()
   {
      union()
      {
        translate([wid,0,0])
          side_rail_shape(len,ht,ht2,wid);

       side_rail_shape(len,ht+p_ridge,ht2+p_ridge,wid);
      }
      union()
      { // Cutout in middle
         translate([-wid, -len/2 - cut_len/2, 1.5])
           cube([2*wid,cut_len, ht2+p_ridge+.01],false);
      }
     }
}

// Side rail: left
module side_rail_l(len,wid,ht,cut_len)
{
   ht2 = ht + len * sin(angle);
   difference()
   {
      union()
      {
        side_rail_shape(len,ht,ht2,wid);

        translate([wid,0,0])
          side_rail_shape(len,ht+p_ridge,ht2+p_ridge,wid);
      }
      union()
      { // Cutout in middle
         translate([-wid, -len/2 - cut_len/2, 1.5])
           cube([2*wid,cut_len, ht2+p_ridge+.01],false);
      }
   }
}
// Both side rails 
module side_rails_angle()
{
   ra_y = pc_y -15;
   ra_x = dis_wid/2;
   ht1 = 10; 	// Height of short end
   cut = 50;	// Length of cutout
echo(ra_y);
   translate([ ra_x,ra_y,base_ht])
     side_rail_l(76,sid_wid,ht1, cut);

   translate([-ra_x,ra_y,base_ht])
     side_rail_r(76,sid_wid,ht1, cut);
}

  module pod_4posts()
 {
     ofs = 3;
     translate([-dis_wid/2-ofs, sid_rail_y, 0])
       dis_post();
     
     translate([dis_wid/2-dis_post_y+ofs, sid_rail_y, 0])
       dis_post();

ee = 15;     
     translate([-dis_wid/2-ofs, ee, 0])
       dis_post();

     translate([dis_wid/2-dis_post_y+ofs, ee, 0])
       dis_post();
        
     
     /*
   translate ([-pc_cornerx, pc_cornery, 0])
   {
 
  }
   translate ([ pc_cornerx, pc_cornery, 0]) 
   {
     difference()
     {
       union()
       {
          rotate( 90) pod_post();
          translate([-pod_post_y,-pod_post_y,  0])
            cube([pod_post_y, pod_post_y, dis_post_ht + p_ridge],false);
       }
       union()
       {
            translate([-pod_post_y/2, -pod_post_y/2 + 1, 14])
                cylinder(h = pod_post_sd, r1 = 0, r2 = pod_post_s, center = false);
       }
     }
   }
//    translate ([-pc_cornerx,pc_cornery, 0]) rotate(-90) pod_post();
//    translate ([ pc_cornerx,pc_cornery, 0]) rotate(180) pod_post();
*/
 }
 module wedge(l, w, h)
 {
       polyhedron(
          points=[[0,0,0],[l,0,0],[l,w,0],[0,w,0],[0,w,h],[l,w,h]],
          faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
          );
 }

// Clip to wedge board under
dis_post_q = pod_post_q;

module pod_clip(pclen,pcwid)
{
   // Main support post
   cube([pclen,pcwid,dis_post_ht],false);

   // Ridge on top of support post
   translate([0,0,dis_post_ht])
      cube([pclen,dis_post_q, 3],false);

   // Overhang
   translate([pclen, 4 + 2, dis_post_ht + 4.5])
      rotate([0,90,180])
         wedge_trunc(6,5,3,0.4,pclen);
}

// Truncated wedge type of polygon
module wedge_trunc(h1,h2,w1,w2,length)
// h1 = height
// h2 = height of end of wedge (h2 < h1)
// w1 = width of top
// w2 = width where bevel starts (w2 < w1)
{
linear_extrude(height = length, center = false, convexity = 10, twist = 0)
    polygon(points = [ [0,0],[0,h1],[w1,h1],[w1,h2],[w2,0] ] );

}

// Position clips (note plural clip*s*) for pod board
module pod_clips()
{

   translate([pcleng/2, pc_y,0])
      rotate([0,0,180]) 
         pod_clip(pcleng, 3);
}
// Mounting Magnet stud post
module mag_stud_post(whx,why)
{
	translate([whx,why,0])
		cylinder(d= 10, h = 6, center=false);
}
// Mountin Magnet posts (plural)
module mag_stud_posts()
{
   mag_stud_post(0,plano_mag_bot_ofs);
   mag_stud_post((plano_mag_top_x),
                 (plano_mag_bot_ofs + plano_mag_top_y));
   mag_stud_post((-plano_mag_top_x),
                 (plano_mag_bot_ofs + plano_mag_top_y));
}
// Mounting Magnet stud hole
module mag_stud_hole(mhx, mhy)
{
   translate([mhx,mhy,0])
    {
       // Magnet stud hole
        cylinder(h = (base_ht + 8), d = 2.6 + 0.4, center = false);
       // Recess for 4-40 nut
        translate([0,0,2])
            cylinder(h = 2.5 + 0.6, d = 7.5 + .6, center = false, $fn=6);
    }
}

// Base plate w rounded corners
module base_plate()
{
  // Base rectangle
    translate([-base_wid/2,0,0])
      rect_rounded(base_wid,
                   base_len,  
                   base_ht,   
                   base_rnd); 
}

module mag_stud_holes()
{
   mag_stud_hole(0,plano_mag_bot_ofs);
   mag_stud_hole((plano_mag_top_x),
                 (plano_mag_bot_ofs + plano_mag_top_y));
   mag_stud_hole((-plano_mag_top_x),
                 (plano_mag_bot_ofs + plano_mag_top_y));
}

module RJ45_cutout()
{
   translate([RJ_cutout_ofs,RJ_cutout_y,0])
     cube([RJ_cutout_width,RJ_cutout_length,(base_ht + 0.1)],false);
}


module lightening_holes()
{
  // Cutouts under Discovery board
  translate([-28,65,0])
    rect_rounded(56,75,base_ht + 0.1,10);
    
//      translate([-27,61,0])
//    rect_rounded(55,20,base_ht + 0.1,7);

  // Cutout under CAN & switcher board
  translate([-23.7,10.9,0])
    cube([47,43.0,base_ht + 0.1],false);
}

module iso_cutout()
{
   translate([-36,11,0])
     cube([(iso_wid - iso_lip),(iso_len - iso_lip),(base_ht + 0.1)],false);
}

module pod_clip_jack_cutout()
{
    // Audio jack cutout in clip
        translate([8.3,135,base_ht+ 3 ])
         cube([10,30,60], false);
    
    // USB connector cutout in clip
            translate([-9,135,base_ht+ 3 ])
         cube([12,30,60], false);

    // Header pins cutout in clip
            translate([-dis_wid/2 + 2,135,base_ht + 4 ])
         cube([12,30,60], false);

    // Header pins cutout in clip
            translate([dis_wid/2 - 11,135,base_ht + 4])
         cube([11,30,60], false);

}

module stiffeners()
{
   translate([-base_wid/2 + 2, 56, 0])
     rotate([0,0,0])
	cube([2.0, 82.0, 8.0], false);

   translate([ base_wid/2 - 4, 56, 0])
     rotate([0,0,0])
	cube([2.0, 82.0, 8.0], false);
}



// Base plate with holes punched in it
module base_punched()
{
   difference()
   {
      union()
      {
         pod_clips();
         pod_4posts();
         base_plate();
mag_stud_posts();
id();
	      side_rails_angle();
       // Eye-ball in the translations of the following
         translate([-26.5,3,0])    
         {
           // Some local positioning
           iso_ytop = 46;  iso_xtop = 5;
           iso_xbot = iso_osd_x + 2.5;
           iso_y = (iso_osd_y + 2*iso_ridge_wid)/2;
           iso_blkl = 5;   iso_blkw = 5; iso_blkh = 6.5;

           translate([0,5,0]) /* Tweak position */
             iso_post();

	        translate([-iso_xtop,iso_y, 0])
             iso_post_s(iso_blkl+.1,
                 iso_blkw+.1,
                 iso_blkh + iso_ridge_ht - .75,
                 pod_post_s,pod_post_sd);

	        translate([iso_xbot,iso_y,0])
             iso_post_s(iso_blkl+.1,
                 iso_blkw+.1,
                 iso_blkh + iso_ridge_ht - .75,
                 pod_post_s, pod_post_sd);
         }
//         stiffeners();
      }
      union()
      {
         mag_stud_holes();
         lightening_holes();
         pod_clip_jack_cutout();
      }
   }
   

}

base_punched();

