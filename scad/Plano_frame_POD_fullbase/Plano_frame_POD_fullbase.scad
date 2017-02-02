/* File: Plano_frame_POD_fullbase.scad
 * Full base plate with low density infill
 * Author: deh
 * Latest edit: 201701291316
 */
 $fn=100;
 
 // Inside dimensions of Plano box
 plano_len          = 152.5;   // flat-flat
 plano_wid          =  76.0;   // flat-flat

base_len = plano_len;
base_wid = plano_wid;
base_ht  = 3.2;		// Thickness of base plate
base_rnd = 10;	// Base plate corner rounding radius
 
 // Stud magnet relative postions.
 // Bottom magnet is on center-line and x,y reference is 0,0
 plano_mag_top_x  = 30.5;   // Top pair x +/- from center-line (C/L)
 plano_mag_top_y  = 138.69; // Top pair y from bottom magnet hole
 plano_mag_top_ofs = 8;    // Top mags to top edge of PC board max
 // Bottom mag distance from bottom of plano wall
 plano_mag_bot_ofs = plano_len - plano_mag_top_ofs - plano_mag_top_y;
 
 
 plano_offs_mag_y   = 4;    // Offset from edge for magnet hole
 plano_offs_mag_x   = 4;    // Offset from edge for magnet hole
 plano_ctr_y    = (plano_len/2);
 plano_ctr_x    = (plano_wid/2);
 
 
 plano_mag_stud = 2.8;  // Dia of mounting magnet studs (4-40)
 plano_mag_stud_len = 7.95; // Height of stud from magnet back
 mag_washer_dia = 9.5;      // Diameter of washer for magnet stud
 mag_washer_thick = 1.1;    // Thickness of washer
 mag_washer_dia_extra = 1;  // Washer slop
 mag_nut_thick = 2.4;       // Nut for stud thickness
 plano_web_thick = 2;   // Plano box thickness where stud is 
 mag_wash_recess_dia = mag_washer_dia + mag_washer_dia_extra;
 // Thickness of base for washer recess
 mag_stud_z = (mag_washer_thick +mag_nut_thick + plano_web_thick);
 mag_wash_recess_z = plano_mag_stud_len - mag_stud_z;    
 // Diameter of recess
 mag_wash_recess_dia = mag_washer_dia + mag_washer_dia_extra;
 // POD board
 pod_wid=76.5;  // Overall width
 pod_len=89.4;  // Overall length
 
// RJ45 connector on POD board
 RJ_offset=24.8; // Side of RJ45 jack from edge
 RJ_wid=15;      // Width of RJ 45 jack
 RJ_depth=14.5;  // Bottom of POD pc board edge to bottom/back of RJ45
 RJ_length=14;  // Front-Back length

// Cutout in base for RJ45 with plug
 RJ_slop = 4;
 RJ_plug_len = 14; // RJ plug protrudes beyond jack
 RJ_cutout_width = RJ_wid + RJ_slop;
 RJ_cutout_length = RJ_length + RJ_slop + RJ_plug_len;
 RJ_cutout_ofs = pod_wid/2 - (RJ_offset + RJ_wid);
 
 // CAN sub-board module
 sub_wid      = 33.75;  // Overall width
 sub_len      = 62.9;   // Overall lengh
 sub_mtg_wid  = 26.6;   // Between mounting holes, width
 sub_mtg_len  = 57.0;   // Between mounting holes, length 

 // Switcher module
 sw_wid =   20.3;   // Overall width
 sw_len =   41.2;   // Overall length
 sw_mtg_off_out_y   = 5.56; // Offset from edge "out" mounting hole 
 sw_mtg_off_out_x   = 2.7;  // Offset from edge "out" mounting hole 
 sw_mtg_off_in_y    = 3.1;  // Offset from edge "in" mounting hole
 sw_mtg_off_in_x    = 6.0;  // Offset from edge "in" mounting hole
 
 // RJ jack (load-cell jack)
 rj_grv =  4.0;  // Groove Depth 
 rj_ht  = 14.2;  // Groove Length
 rj_wid = 14.2;  // Groove Height
 
 // Post ridge
 p_ridge = 1.5; // Height of ridge to position PC board on post
 p_offset = 2;  // Offset of ridge from edge of post
 
 // Pod post
 pod_post_ht = (RJ_depth + 1);
 pod_post_y = 9;    // Length in "y" (long/length) box direction)
 pod_post_x = 6;    // Length in "x" (short/width) box direction)
 pod_post_q = 2.0;  // Width of ridge
 pod_post_s = 2.5;    // Screw hole dia
 pod_post_sd = 5;   // Screw hole depth

 // Pod board clip
 pcwide = 4;        // Width of clip post
 pcleng = 50;       // X axis direction length
 pc_y = base_len;   // y positioning

 iso_len   = 50.3;	// Length: two RJ 45 jacks parallel
 iso_wid   = 46.3;      // Width
 iso_thick = 1.6;	// PC board thickness
 iso_slop  = 0.1;	// Allowance for board variation
 iso_lip   = 1.2;	// Ledge width for board seating
 iso_ridge_ht = 1.55;	// Ridge ht for seat
 iso_ridge_wid= 1.5;	// Ridge width for seat
 iso_post_ht = 6.0;	// Height of lip above base

 iso_osd_y = iso_wid + iso_slop; // Board y
 iso_osd_x = iso_len + iso_slop; // Board x
 iso_side  = iso_lip + iso_ridge_wid;


RJ_cutout_y = pc_y - p_ridge - pod_len + RJ_length + RJ_slop - RJ_cutout_length;

// Position of corner posts
 pc_cornerx =  (pod_wid/2) + p_offset;  // PC board corner
 pc_cornery =      base_len - pod_len - pod_post_q - p_offset;

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
         translate([3,-10,0])rotate([0,0,90])wedge(30,5,10);
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
          translate([-3,10,0])rotate([0,0,-90])wedge(30,5,10);
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
  // Cutout under POD board
  translate([-23,85,0])
    rect_rounded(50,55,base_ht + 0.1,10);
  // Cutout under CAN & switcher board
  translate([-19.5,15,0])
    rect_rounded(44,39,base_ht + 0.1,6);
  // Cutout 
  translate([-27,61,0])
    rect_rounded(22,20,base_ht + 0.1,7);
  // Cutout 
/*
  translate([20,58,0])
    rect_rounded(9,24,base_ht + 0.1,4);
  // Cutout 
  translate([-36,10,0])
    rect_rounded(8,40,base_ht + 0.1,2);
  // Cutout 
  translate([30,10,0])
    rect_rounded(6,38,base_ht + 0.1,2);
*/
}

module iso_cutout()
{
   translate([-36,11,0])
     cube([(iso_wid - iso_lip),(iso_len - iso_lip),(base_ht + 0.1)],false);
}

module stiffeners()
{
   translate([-base_wid/2 + 4, 64, 0])
     rotate([0,0,-8])
	cube([2.0, 88.0, 8.0], false);

   translate([ base_wid/2 - 4, 68, 0])
     rotate([0,0,8])
	cube([2.0, 85.0, 8.0], false);


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
         translate([-25,5,0])
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
         RJ45_cutout();
         lightening_holes();
      }
   }
}

base_punched();

