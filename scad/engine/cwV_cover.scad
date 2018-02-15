/* File: cwV_cover.scad
 * Cover for PC board box with vertical position orientation
 * Author: deh
 * Latest edit: 20180213
 */

include <../library_deh/deh_shapes.scad>

 $fn=50;

// PC board dimensions
pc_slop = 4;
pcwid = 49.6 + pc_slop;	// Width of PC board
pclen = 83.0 + pc_slop;	// Length of PC board
pcthick = 1.7;	// Thickness of board

module wedge(l, w, h)
 {
   polyhedron(
      points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
       faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]] );
 }

module tube(d1,d2,ht)
{
   difference()
   {
     cylinder(d = d1, h = ht, center = false);
     cylinder(d = d2, h = ht + .001, center = false);
   }
}
module mag_mnt_bar(d1, d2, len, ht)
{
   difference()
   {
     union()
     {
        cylinder(d = d1, h = ht, center = false);
        translate([-len, -d1/2, 0])
           cube([len, d1, ht]);
     }
       cylinder(d = d2, h = ht + .001, center = false);
   }
    
}
// Tabs for holding pc board cover down
bt_wid = 10;
bt_hole_dia = 3.2;  // Screw hold dia
bt_thick = 3;	// Thickness
bt_len = 10;	// Length
bt_w_ht = 6;	// Stiffner height

module brd_tab()
{
   mag_mnt_bar(bt_wid, bt_hole_dia, bt_len - shell_wall, bt_thick);
   translate([0 ,(bt_wid/2 - bt_thick),bt_thick])
      rotate([0,0,90])
         wedge(bt_thick,bt_len-3,bt_w_ht);
   translate([0 ,-(bt_wid/2),bt_thick])
      rotate([0,0,90])
         wedge(bt_thick,bt_len-3,bt_w_ht);
}
base_thick 	= 2.0;	// Thickness of base
base_rad	= 10;	// Radius around mags

shell_wall = 2;		// Cover wall thickness
shell_ht = 10.5;	;	// Cover side height
shell_gap = 1;		// Cover gap between enclosure walls and cover

shell_x = pcwid + 4*shell_wall + 2*shell_gap;
shell_y = pclen + 4*shell_wall + 2*shell_gap;

tab_ofs = shell_wall + shell_gap;

shell_iofs = 5;
shell_ix = pcwid-shell_iofs;  // Inner ridge location
shell_iy = pclen-shell_iofs;
shell_ih = 1.5;	// Height of inner ridge
shell_iw = 1; 	// Width of inner ridge
shell_iix = shell_ix - 2*shell_iw;
shell_iiy = shell_iy - 2*shell_iw;
shell_or_x1 = shell_gap + 2*shell_wall + shell_iofs/2;
shell_or_x2 = shell_or_x1 + shell_iw;

cc_wid = 6.5;		// Telephone type cable width
cc_thick = 2.25;	// Thickness
cc_frm_top = 3;		// Offset from top of side
cc_frm_side = 19;	// Offset from side
cc_sense_dia = 4;	// Sensor cable dia
cc_z = cc_thick + cc_frm_top;



module pc_shell()
{

   // Cover top
   translate([0,-shell_y/2,0])
   cube([shell_x,shell_y,base_thick],false);

   // Ridge for O-ring type sealing
   difference()
   {
      translate([shell_or_x1,-shell_iy/2,base_thick])
         cube([shell_ix,shell_iy,shell_ih],false);
      translate([shell_or_x2,-shell_iiy/2,base_thick])
         cube([shell_iix,shell_iiy,shell_ih],false);

   }

   // Wall: +y end
   translate([0, shell_y/2 - shell_wall,base_thick])
     cube([shell_x, shell_wall, shell_ht]);

   // Wall: -y end 
   translate([0, -shell_y/2,base_thick])
     cube([shell_x, shell_wall, shell_ht]);

   // Wall: x=0 side

      translate([0, -shell_y/2, base_thick])
        cube([shell_wall, shell_y, shell_ht]);


   // Wall: +x side
   difference()
   {
      translate([shell_x - shell_wall, -shell_y/2, base_thick])
        cube([shell_wall, shell_y, shell_ht]);

    // Cable cutout
      translate([shell_x - shell_wall-1, (shell_y/2 - cc_frm_side - cc_wid) , shell_ht - cc_z])
        cube([shell_wall + 2,cc_wid, 10],false);
   }
 
   // Tabs for mounting top cover

   translate([shell_x/2,-(shell_y/2 + cm_len - 0.05),0])
     rotate([0,0,180])
	cover_mnt_tab();

   translate([shell_x/2, (shell_y/2 + cm_len - 0.05),0])
     rotate([0,0,0])
	cover_mnt_tab();

}
module rounded_bar_end(l, w, h)
{
        cylinder(d = w, h = h, center = false);
        translate([-l, -w/2, 0])
           cube([l, w, h],false);
}
module rounded_rectangle(lo,wo,h,rad)
{
 translate([-rad/2,rad/2,0])
 {
  l = lo - rad; w = wo - rad;
  lr = l - 2*rad; wr = w - 2*rad;
   translate([-l,0,0])
     cube([l,w,h],false);

   ww = w; ll = l;
   translate([0,0,0])
     rounded_bar_end(ll,rad,h);
   translate([0,ww,0])
     rotate([0,0,90])
        rounded_bar_end(ww,rad,h);
   translate([-ll,0,0])
     rotate([0,0,-90])
        rounded_bar_end(ww,rad,h);
   translate([-ll,ww,0])
     rotate([0,0,180])
        rounded_bar_end(ll,rad,h);
 }
}
// Window 
module window()
{
  translate([43,-35,0])
     rounded_rectangle(30,50, base_thick+3,6);    

//  translate([15,-35,0])
//         cube([30,50,base_thick+3],false);    

//translate([-50,0,0])
//     rounded_rectangle(30,15, base_thick+3, 3);    
}

// Tabs for holding pc board cover down

 cm_od = 10;	// Diameter of cover mounting post
 cm_len = cm_od/2 + 0;
 cm_id = 2.6;	// Self-tapping screw hole diameter
 cm_wg = 5;	// Bottom wedge	
 cm_screw_head_dia = 9; // Screw head/washer diameter
 cm_recess = 8.5; 
cov_ofs = 0;  // Tab top distance below top edge of board

module cover_mnt_tab()
{
  difference()
  {
    union()
    {
      rotate([0,0,-90])
        eye_bar(cm_od,cm_id,cm_len,shell_ht + base_thick);

      translate([cm_len+(cm_od*(3/4)),-cm_len,shell_ht + base_thick])
        rotate([-90,0,0])
          rotate([0,0,90])
            wedge(shell_ht + base_thick,cm_len+cm_od/2,cm_len+cm_od/2-0.5);

      translate([-(cm_len + (cm_od*(3/4))),-cm_len,0])
        rotate([0,0,-90])
          rotate([0,-90,0])
            wedge(shell_ht + base_thick,cm_len+cm_od/2,cm_len+cm_od/2-0.5);
    }
    union()
    {
      translate([-cm_od/2-20,-cm_od/2-3,0])
        wedge(cm_od+80,cm_od+10,cm_od/2+10);

      translate([0,0,0])
       cylinder(d=cm_screw_head_dia, h = cm_recess, center=false);
    }
  }
}

module total()
{
   difference()
   {
      pc_shell();
        window();
   }
}
total();
