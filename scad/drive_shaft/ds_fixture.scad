/* ds_fixture.scad
 * Enclosure/mount for drive shaft
 * Interupt type sensor
 * Date: 20170501
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <../codewheel_fixture_h/cwH_common.scad>
include <ds_common.scad>

 $fn=50;

 // Thickness of base for washer recess
 mag_stud_z = (mag_washer_thick +mag_nut_thick);
 mag_wash_recess_z = mag_stud_len - mag_stud_z;    
 mag_wash_recess_dia = mag_washer_dia + mag_washer_dia_extra;

sm_slop = 0.4;
sm_len_y = 18.55 + sm_slop;	// Length
sm_len_x = 10.0 + sm_slop;	// Width of pair
sm_hole_x = 16.0;	// Sensor mnt board hole, +/-
sm_hole_y = 8;	
sm_screw_dia = 3.3;
sm_brd_y = 26;	// Length of carrier board
sm_brd_x = 50;	

module sensor_mnt()
{
   translate([-sm_len_x/2, -sm_len_y/2, 0])
   cube([sm_len_x, sm_len_y, 20], center = false);
   
   translate([ sm_hole_x,sm_hole_y,0])
     cylinder(d = sm_screw_dia, h = 20, center = false);

   translate([-sm_hole_x,sm_hole_y,0])
     cylinder(d = sm_screw_dia, h = 20, center = false);
}

pcs_slop = 2;
pcs_len_x = shell_x + pcs_slop;
pcs_len_y = shell_y + 16 + pcs_slop;

module pc_shell()
{
   // Base plate
   translate([-pcs_len_x/2+.1,-pcs_len_y/2 + sm_brd_y/2,0])
      cube([pcs_len_x+.2,pcs_len_y+.1,base_thick], center = false);

   // Posts for screw mounting of pc board
   translate([-pcs_len_x/2,0,0])
      translate([pcps_ofs_x+pc_slop/2,pcps_ofs_y,base_thick]) 
         pc_posts4();
}

module pc_posts_pair()
{
   tubedeh(pcps_post_dia,pcps_screw_dia,pcps_post_ht);

   translate([0,-pcps_space_y,0])
      tubedeh(pcps_post_dia,pcps_screw_dia,pcps_post_ht);
}

module pc_posts4()
{
   pc_posts_pair();

   translate([pcps_space_x-0.5,0,0])
     pc_posts_pair();
}

pcs_mag_dia = mag_stud_dia + 0.5;// Magnet stud dia
pcs_mag_stud_len = mag_stud_len + 0.5;
pcs_mag_ofs_x = 22;	// Position of sensor end magnets
pcs_mag_ofs_y1 = 25; 	// Position of sensor end magnets
pcs_mag_ofs_y2 = -30;  	// Position of engine end magnet

mag_bot_thick = 1;	// thickness of bottom-to-washer
mag_post_dia = mag_washer_dia + 2;	// OD of magnet post
mag_post_ht = mag_stud_len + 1;	 // Height of mag post

po_hex_nut = mag_nut_hex_peak + 0.4; // Dia for hex nut pocket
po_hex_nut_ht = mag_nut_thick + .25; // Depth of pocket

module mag_mnt_post()
{
echo (mag_post_dia);
       cylinder(d = mag_post_dia, h = mag_post_ht, center = false);
}
module mag_mnt_post_hole()
{
   // Stud hole
   cylinder (d = pcs_mag_dia, h = pcs_mag_stud_len, center = false);

   // Washer pocket
   translate([0,0,mag_bot_thick])
     cylinder(d = mag_washer_dia, h = mag_washer_thick + .25, center = false);

   // Nut pocket
   translate([0,0,mag_bot_thick + mag_washer_thick - 0.1])
      linear_extrude(height = po_hex_nut_ht, center=false)
         circle(d = po_hex_nut, $fn=6);      
}
// Additions
module mag_mnt_posts()
{
   translate([0,pcs_mag_ofs_y2,0])
    mag_mnt_post();

   translate([pcs_mag_ofs_x,pcs_mag_ofs_y1,0])
    mag_mnt_post();

   translate([-pcs_mag_ofs_x,pcs_mag_ofs_y1,0])
    mag_mnt_post();
}
// Subtractions
module mag_mnt_holes()
{
   translate([0,pcs_mag_ofs_y2,0])
    mag_mnt_post_hole();

   translate([pcs_mag_ofs_x,pcs_mag_ofs_y1,0])
    mag_mnt_post_hole();

   translate([-pcs_mag_ofs_x,pcs_mag_ofs_y1,0])
    mag_mnt_post_hole();
   
}

module cable_cutout()
{
   // One telephone type cables
   translate([cc_ofs_x,cc_ofs_y,cc_ofs_z - cc_thick/2])
    rotate([0,90,90])
     rounded_rectangle(cc_thick,cc_wid,20,1.5);
}

module cover_mnt_tab()
{
      rotate([0,0,-90])
        eye_bar(cm_od,cm_id,cm_len,shell_ht - cov_ofs);
}

ds_len_x = pcs_len_x - pcs_slop;
ds_len_y = pcs_len_y - pcs_slop;
ds_ht = shell_ht;

module walls()
{
  translate([0,(sm_brd_y)/2,0])
  {
    difference()
    {
      rounded_rim(ds_len_x, ds_len_y, ds_ht, shell_rad, shell_wall);

      // Cable cutout for one telephone type cable
      translate([-35,ww4_ofs_y + 14,0])
        cable_cutout();
    }
  }
}

cm_ofs_y = -30;
cm1_ofs_x =  ww2_ofs_x - cm_len;
cm2_ofs_x = -ww2_ofs_x + cm_len - shell_wall;

module cover_mnt_tabs()
{
   translate([pcs_len_x/2+cm_len ,-cm_ofs_y,0])
     rotate([0,0,-90])
      cover_mnt_tab();

   translate([-pcs_len_x/2-cm_len ,-cm_ofs_y,0])
     rotate([0,0, 90])
      cover_mnt_tab();

   translate([0,-pcs_len_y/2 + 2*shell_wall,0])
     rotate([0,0,180])
      cover_mnt_tab();
}

smsb_z = 3.2;	// Height above bottom for sensor platform

module oneboard()
{
sm_ofs_y = (shell_y - 1 + pcs_slop)/2;
  difference()
  {
    union()
    {
       pc_shell();

       // Raised platform so sensor cross-bar is flush
       translate([-sm_brd_x/2,sm_ofs_y -sm_brd_y/2 ,0])
	   cube([sm_brd_x, sm_brd_y, smsb_z], center = false);

       mag_mnt_posts();
        
    }
    union()
    {
       // Cutout for reflective photosensors
//       ps_cutout();

       // Sensor cutout in bottom
       translate([0,sm_ofs_y,0])
          sensor_mnt();

       mag_mnt_holes();
    }
  }
}

module composite()
{

   {
          oneboard();
   }
     walls();
  
   cover_mnt_tabs();
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

      }
      union()
      {
//	 drain_hole();
      }
   }

}
total();

