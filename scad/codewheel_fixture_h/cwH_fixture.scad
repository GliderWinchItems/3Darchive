/* File: cwH_fixture.scad
 * Photocell sensor magnet mount for sheave codewheel
 * Reflective photosensors version, (H = horizontal over top)
 * Author: deh
 * Latest edit: 20170420
 */

 $fn=50;

include <../library_deh/deh_shapes.scad>
include <cwH_common.scad>

// Magnet mount dimensions
include <../library_deh/mag_mount.scad>

 // Thickness of base for washer recess
 mag_stud_z = (mag_washer_thick +mag_nut_thick);
 mag_wash_recess_z = mag_stud_len - mag_stud_z;    
 mag_wash_recess_dia = mag_washer_dia + mag_washer_dia_extra;

module tube(d1,d2,ht)
{
   difference()
   {
     cylinder(d = d1, h = ht, center = false);
     cylinder(d = d2, h = ht + .001, center = false);
   }
}

module pc_shell()
{
   // Base plate
   translate([0,-shell_y/2,0])
      cube([shell_x,shell_y,base_thick],false);

   // Posts for screw mounting of pc board
   translate([pcps_ofs_x+pc_slop/2,pcps_ofs_y,base_thick]) 
      pc_posts4();
}

module pc_posts_pair()
{
   tube(pcps_post_dia,pcps_screw_dia,pcps_post_ht);

   translate([0,-pcps_space_y,0])
      tube(pcps_post_dia,pcps_screw_dia,pcps_post_ht);
}

module pc_posts4()
{
   pc_posts_pair();

   translate([pcps_space_x,0,0])
     pc_posts_pair();
}

module cable_cutout()
{
   // Two telephone type cables
   translate([cc_ofs_x,cc_ofs_y,cc_ofs_z])
    rotate([0,90,90])
     rounded_rectangle(cc_thick,cc_wid,20,1.5);
}

   // Cutout for reflective photosensors
module ps_cutout()
{
  ps_wid = 4.7;	// Width of photosensor
  ps_len = 6.5;	// Length of photosensor
  ps_ht = 50;	// Punch through everything with big number
  ps_space = 0;	// Spacing between (9.8 pc board layout)
  ps_ofs_y = 24;	// Offset from board edge to side of photosensor
  ps_ofs_x = 13;	// Offset from board edge to bottom of photosensor
  ps_ofs_xx = pcwid + shell_wall - ps_ofs_x -ps_len;
  ps_ofs_yy = pclen/2 - ps_wid - ps_ofs_y;
   translate([ps_ofs_xx,ps_ofs_yy,-20])
     cube([ps_len,ps_wid,ps_ht],center=false);

  ps_ofs_yyy = ps_ofs_yy - ps_space - ps_wid;
   translate([ps_ofs_xx,ps_ofs_yyy,-20])
     cube([ps_len,ps_wid,ps_ht],center=false);
}

module cover_mnt_tab()
{
      rotate([0,0,-90])
        eye_bar(cm_od,cm_id,cm_len,shell_ht - cov_ofs);
/*
      translate([cm_len+(cm_od*(3/4)),-cm_len,shell_ht - cov_ofs + 0.1])
        rotate([-90,0,0])
          rotate([0,0,90])
            wedge(shell_ht - cov_ofs,cm_len+cm_od/2,cm_len+cm_od/2-0.5);

      translate([-(cm_len + (cm_od*(3/4))),-cm_len,0])
        rotate([0,0,-90])
          rotate([0,-90,0])
            wedge(shell_ht - cov_ofs,cm_len+cm_od/2,cm_len+cm_od/2-0.5);
*/
}
/* ------------------------------------------------------------------- */
pt_screw_dia = 3.3;	// Self-tapping screw diameter
pt_rad_tab = 20;	// End mount radius
pt_thick = base_thick;	// Thickness of platform
pt_len_x = sp_x+base_rad*2;
pt_len_y = shell_x*2 - 19;

ww_delta = 1;
ww1_ofs_x = 100-42;
ww1_ofs_y = 0;
ww2_ofs_x = -45-24+7;
ww2_ofs_y = 0;
ww_len_y = pt_len_y+18;
ww3_ofs_x = -ww1_ofs_x - (shell_wall * 2);
ww3_ofs_y =  ww_len_y/2 - shell_wall + ww_delta;
ww4_ofs_x =  ww3_ofs_x;
ww4_ofs_y = -ww3_ofs_y - shell_wall;
ww_len_x = (ww1_ofs_x * 2) + (shell_wall * 3);

module walls()
{
  difference()
  {
    rounded_rim(ww_len_x, ww_len_y, shell_ht, 2, shell_wall);

    // Cable cutout for one telephone type cable
    translate([-70,ww4_ofs_y + 14,0])
      cable_cutout();
  }
}


module platform()
{
 difference()
 {
   union()
   {
      translate([0,0,0])
         rounded_rectangle(sp_x + 5,ww_len_y,base_thick,base_rad);
   }
   union()
   {
      translate([-sp_x/2,0,0])
        cylinder(d = pt_screw_dia, h = 20, center = false);   
   
      translate([sp_x/2,sp_y/2,0])
        cylinder(d = pt_screw_dia, h = 20, center = false);
      
      translate([sp_x/2,-sp_y/2,0])
        cylinder(d = pt_screw_dia, h = 20, center = false);

      // Cutout so as not to cover photocell cutout
      translate([-20, 15,-.1])
        cube([40,40,base_thick+2],center=false);

      translate([-20,-55,-.1])
        cube([40,40,base_thick+2],center=false);

   }
 }
}

cm_ofs_y = -30;
cm1_ofs_x =  ww2_ofs_x - cm_len;
cm2_ofs_x = -ww2_ofs_x + cm_len - shell_wall;

module cover_mnt_tabs()
{
   translate([cm1_ofs_x,cm_ofs_y,0])
     rotate([0,0,90])
      cover_mnt_tab();

   translate([cm1_ofs_x,-cm_ofs_y,0])
     rotate([0,0,90])
      cover_mnt_tab();

   translate([cm2_ofs_x + shell_wall,0,0])
     rotate([0,0,-90])
      cover_mnt_tab();
}

module oneboard()
{
  difference()
  {
    union()
    {
        pc_shell();
    }
    union()
    {
       // Cutout for reflective photosensors
       ps_cutout();

    }
  }
}

module composite()
{

   rotate([0,0,90])
   translate([-57.5,0,0]) 
   {
      translate([115.2-55,-15,0])
        rotate([0,0,0])
          oneboard();

      translate([55,14,0])
        rotate([0,0,180])
          oneboard();
   }

   translate([0,0,0])
      platform();

   walls();
   cover_mnt_tabs();
}

/* Add mounting for light shield attachment
   on underside. */
module lightshield_posts()
{
   translate([ls_post_ofs_x,0,0])
      cylinder(d = ls_post_dia, h = ls_post_ht, center = false);

   translate([-ls_post_ofs_x,0,0])
      cylinder(d = ls_post_dia, h = ls_post_ht, center = false);
}

module lightshield_screws()
{
   translate([ls_post_ofs_x,0,0])
     cylinder(d = ls_screw_dia, h = ls_screw_ht, center = false);

   translate([-ls_post_ofs_x,0,0])
     cylinder(d = ls_screw_dia, h = ls_screw_ht, center = false);
}

/* Add small drain hole if for some reason water gets in */
dn_dia = 1;
dn_ht = 100;
dn_ofs_x = -ww_len_x/2;
dn_ofs_y = -ww_len_y/2;

module drain_hole()
{
   translate([dn_ofs_x,dn_ofs_y,2.5])
     rotate([-45,45,0])
      cylinder(d = dn_dia, h = dn_ht, center= true);

}

module total()
{  
   difference()
   {
      union()
      {
         composite();
         lightshield_posts();
      }
      union()
      {
         lightshield_screws();
	 drain_hole();
      }
   }
}
total();

