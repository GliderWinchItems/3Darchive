/* File: Plano_frame_F4_fullbase.scad
 * Plano box with Discovery F4 and CAN module
 * Author: deh
 * Latest edit: 201700701
 */

include <../library_deh/Plano_frame.scad>

 $fn=100;
 

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
            // Self tapping screw hole
            translate([l/2,w/2,.01])
                cylinder(h = isph,
                   r1 = 0, r2 = hole_dia/2, 
                   center = false);
         }
     }        

}

// iso mount for CAN w switcher PC board
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
        translate([21.5,(iso_wid - iso_side),0])
             cube([RJ_cutout_width + 4,
                   8 ,
                   iso_post_ht + iso_ridge_ht],
                   false);

      }
   }
}

// Post with recess for corner of POD board
 module pod_post()
 {
     difference()
     {
         union()
         {
            cube([pod_post_x, pod_post_y, pod_post_ht + p_ridge],false);
            cube([pod_post_y, pod_post_x, pod_post_ht + p_ridge],false);
         }
         union()
         {
 
            // Cut-out for corner of PC board
            translate([p_offset, p_offset, pod_post_ht])
                cube([ pod_post_x - p_offset, pod_post_y-p_offset, p_ridge],false);
            translate([p_offset, p_offset, pod_post_ht])
                cube([ pod_post_y - p_offset, pod_post_x-p_offset, p_ridge],false);
         }
     }        
 }

  module pod_4posts()
 {
   translate ([-pc_cornerx, pc_cornery, 0])
   {
     difference()
     {
       union()
       {
         pod_post();
         translate([ 0,-pod_post_y,  0])
            cube([pod_post_y, pod_post_y, pod_post_ht + p_ridge],false);
       }
       union()
       {
//$         translate([3,-10,0])rotate([0,0,90])wedge(30,5,10);
           // Self tapping screw hole
            translate([pod_post_y/2, -pod_post_y/2 + 1, 14])
                cylinder(h = pod_post_sd, r1 = 0, r2 = pod_post_s, center = false);
       }
       
     }
  }
   translate ([ pc_cornerx, pc_cornery, 0]) 
   {
     difference()
     {
       union()
       {
          rotate( 90) pod_post();
          translate([-pod_post_y,-pod_post_y,  0])
            cube([pod_post_y, pod_post_y + .01, pod_post_ht + p_ridge],false);
       }
       union()
       {
//$          translate([-3,10,0])rotate([0,0,-90])wedge(30,5,10);
           // Self tapping screw hole
            translate([-pod_post_y/2, -pod_post_y/2 + 1, 14])
                cylinder(h = pod_post_sd, r1 = 0, r2 = pod_post_s, center = false);
       }
     }
   }
//    translate ([-pc_cornerx,pc_cornery, 0]) rotate(-90) pod_post();
//    translate ([ pc_cornerx,pc_cornery, 0]) rotate(180) pod_post();
 }
 module wedge(l, w, h)
 {
       polyhedron(
          points=[[0,0,0],[l,0,0],[l,w,0],[0,w,0],[0,w,h],[l,w,h]],
          faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
          );
 }

// Clip to wedge board under
module pod_clip(pclen,pcwid)
{
   // Main support post
   cube([pclen,pcwid,pod_post_ht],false);

   // Ridge on top of support post
   translate([0,0,pod_post_ht])
      cube([pclen,pod_post_q, 1.6],false);

   // Overhang
   translate([pclen, 4 + 2, pod_post_ht + 1.6 + 3])
      rotate([0,90,180])
         wedge_trunc(6,2,3,1.65,pclen);
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
         pod_clip(pcleng, pcwide);
}

// Rounded corner
module rounded_corner(dia, height, width)
{
     translate([dia/2,0,0])
     {
        cylinder(h = height + .1,d = dia + .1, center = false);
        translate([0,-dia/2,-.01])cube([(dia/2+.01),(width + .01),(height + .01)],false);
     }
}

module mag_stud_hole(mhx, mhy)
{
   translate([mhx,mhy,0])
    {
        // Magnet stud hole
        cylinder(h = (base_ht + .1), d = plano_mag_stud, center = false);
        // Recess for washer and nut
        translate([0,0,mag_stud_z])
            cylinder(h = mag_wash_recess_z, d = mag_wash_recess_dia, center = false);
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
//  cube([base_wid,base_len,base_ht]);
/*
  // Rounded bottom edge: top x axis
  translate([base_wid/2,(base_len - base_ht/2),0])
      rotate([0,-90,0])
         rounded_corner(base_ht,base_wid - 2*base_ht, base_ht);
  // Rounded bottom edge: bottom x axis
  translate([base_wid/2,base_ht/2,0])
      rotate([0,-90,0])
         rounded_corner(base_ht,base_wid, base_ht);
  // Rounded bottom edge: side y axis
  translate([(base_wid - base_ht/2)/2,base_len,0])
      rotate([90,-90,0])
         rounded_corner(base_ht,base_len, base_ht);
  // Rounded bottom edge: side y axis
  translate([-((base_wid - base_ht/2)/2),base_len,0])
      rotate([90,-90,0])
         rounded_corner(base_ht,base_len, base_ht);
*/
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
  translate([-22,13.5,0])
    rect_rounded(44,39,base_ht + 0.1,6);
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
            translate([-5.3,135,base_ht+ 3 ])
         cube([10,30,60], false);

    // Header pins cutout in clip
            translate([-dis_wid/2 + 7,135,base_ht + 4 ])
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
         // Eye-ball in the translations of the following
//         translate([-25,5,0])
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
         stiffeners();
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

