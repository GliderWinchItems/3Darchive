/* File: cwV_fixture.scad
 * Photocell sensor magnet mount for sheave codewheel
 * Reflective photosensors version, (H = horizontal over top)
 * Author: deh
 * Latest edit: 20170417
 */

 $fn=50;

include <../library_deh/deh_shapes.scad>
include <cwH_common.scad>

 module wedge(l, w, h)
 {
   polyhedron(
      points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
       faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]] );
 }


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



// Triangular mag-mount base
   eb_ofs_x = (shell_x + spacer_thick) + tab_thick;
   eb_ofs_y = (shell_y/2 + tab_len);
   eb_len = tab_len + tab_overlap;	// Length of end tabs
   eb_ofs_z = shell_ht - cover_depth + 25;
   eb_len2 = eb_ofs_z;	// Length of center/back tab

module pc_shell()
{

   // Base plate
   translate([0,-shell_y/2,0])
   cube([shell_x,shell_y,base_thick],false);

   // Wall: +y end
   translate([0, shell_y/2 - shell_wall,base_thick])
     cube([shell_x, shell_wall, shell_ht]);

   // Wall: -y end 
   translate([0, -shell_y/2,base_thick])
     cube([shell_x, shell_wall, shell_ht]);

   // Wall: x=0 side
   translate([0, -shell_y/2, base_thick])
     cube([shell_wall, shell_y, shell_ht]);

   // Spacer between box and magnet base 
   translate([shell_x, -shell_y/2, 0])
   {
     cube([spacer_thick, shell_y, shell_ht-cover_depth]);
   }

   // Wall: +x side
   difference()
   {
      translate([shell_x - shell_wall, -shell_y/2, base_thick])
        cube([shell_wall, shell_y, shell_ht]);
      translate([shell_x - 12, -shell_y/2,base_thick])
       rotate([0,0,90])
 	cable_cutout();
   }
   
   // Posts for screw mounting of pc board
   translate([pcps_ofs_x+pc_slop/2,pcps_ofs_y,base_thick]) pc_posts4();

   // Tabs for mounting top cover
   translate([shell_x/2,(shell_y/2 + cm_len - shell_wall),0])
	cover_mnt_tab();

   translate([shell_x/2,-(shell_y/2 + cm_len - shell_wall),0])
      rotate([0,0,180])
	cover_mnt_tab();

   // Compute triangle sides
   tt_x = eb_ofs_z;
   tt_y = eb_ofs_y;
   tt_l = sqrt(tt_x*tt_x + tt_y*tt_y);
 translate([eb_ofs_x,eb_ofs_y,tab_dia/2])
 {
   rotate([0,90,-90])
     rotate([90,-90,0])
   {
     {
       // Triangular base with screw holes for magnets
       difference()
       {
         union()  // Triangular base, rounded ends
         {
           rounded_triangle(tt_l, tt_l, 2*tt_y, tab_thick, tab_dia);
         }
         union() // Punch holes for magnet studs
         {
           cylinder(d=tab_hole, h=40, center= false);

           translate([2*tt_y,0,0])
              cylinder(d=tab_hole, h=40, center= false);

           translate([tt_y,tt_x,0])
	     cylinder(d=tab_hole, h=40, center= false);
         }
       }
     }
   }
 }
 // Add fillet where base meets spacer
 fil_rad = 3;
  translate([eb_ofs_x-tab_thick,-shell_y/2,shell_ht-cover_depth])
   rotate([0,180,0])
   rotate([-90,0,0])
    fillet(fil_rad,shell_y);
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

module rounded_line_ridge(rad, len, ht)
{
   translate([0,rad,ht])
   { 
     rotate([-90,0,0])
     {
       difference()
       {
         translate([0, 0, -rad/2rad])
           minkowski()
           {
             sphere(rad);
             cylinder(h = len, 
                      r = rad*(1/16),
                      center = false);
           }
         translate([-rad*2,0,-rad])
           cube([rad*4, rad*2, len+2*rad],false);
       }
     }
   }
   translate([-rad,0,0])cube([rad*2,len+rad,ht]);
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
  difference()
  {
    union()
    {
      rotate([0,0,-90])
        eye_bar(cm_od,cm_id,cm_len,shell_ht - cov_ofs);

      translate([cm_len+(cm_od*(3/4)),-cm_len,shell_ht - cov_ofs])
        rotate([-90,0,0])
          rotate([0,0,90])
            wedge(shell_ht - cov_ofs,cm_len+cm_od/2,cm_len+cm_od/2-0.5);

      translate([-(cm_len + (cm_od*(3/4))),-cm_len,0])
        rotate([0,0,-90])
          rotate([0,-90,0])
            wedge(shell_ht - cov_ofs,cm_len+cm_od/2,cm_len+cm_od/2-0.5);
    }
    union()
    {
      translate([-cm_od/2-20,-cm_od/2-3,0])
        wedge(cm_od+80,cm_od+10,cm_od/2+10);
    }
  }
}

module total()
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

       // Hole in triangular base for CAN cables
       translate([eb_ofs_x - tab_thick - spacer_thick, -25, shell_ht - 2 ])
       rotate([0,90,0])
       cylinder(d = wh_dia, h = 20, center = false); 
    }
  }
}

total();

