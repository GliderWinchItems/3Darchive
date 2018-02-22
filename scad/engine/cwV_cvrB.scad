/* File: cwV_cvrB.scad
 * Cover for PC board box with vertical position orientation
 *       with inserted window and molded gasket
 * Author: deh
 * Latest edit: 20180220
 * VEB1 = 20180220 initial hack of cwV_cover.scad
 * VEB2 = 20180221 chamfered window, embedded id
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/deh_shapes2.scad>
include <../library_deh/fasteners.scad>

 $fn=50;

// **** Id the part ***
module id()
{
 {
	xtwk = -35; // Tweak x location
	ytwk = -5.0; // Tweak y location
	ztwk = 0;
  font = "Liberation Sans:style=Bold Italic";
  translate([xtwk,-ytwk, ztwk]) 
  linear_extrude(0.5)
   text("engine/cwV_cover",size = 3);

 translate([xtwk+40,-ytwk, ztwk]) 
  linear_extrude(0.5)
   text("2018 02 21 VEB 2",size = 3);
 }
}

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

// Faux gasket element: isoceles wedge
// l = length
module faux_gasket_el(l)
{
	fg_w = 0.3;	// Width at base
	fg_h = 0.7;	// Height
	translate([0,0,0])
	  rotate([180,0,0])
		 rotate([0,90,0])
		   wedge_isoceles(l,fg_w,fg_h);
}
module faux_gasket_rectangle(l,w)
{
	translate([0,0,0])
		faux_gasket_el(l);

	translate([0,w,0])
		faux_gasket_el(l);

	translate([0,0,0])
		rotate([0,0,90])
  		  faux_gasket_el(w);

	translate([l,0,0])
		rotate([0,0,90])
  		  faux_gasket_el(w);
}
module faux_gasket(l,w,del)
{
	faux_gasket_rectangle(l,w,0);

	translate([-del,-del,0])
	faux_gasket_rectangle(l+2*del,w+2*del,del);
}
module faux_gasket_position()
{
	gx = shell_wall+shell_wall+shell_gap;
	gy = -shell_y/2+2*shell_wall+shell_gap;
	gz = base_thick;
	translate([gx,gy,gz])
  	  faux_gasket(pcwid,pclen,1.0);
}

//faux_gasket(10,20,0.5);

base_thick 	= 3.0;	// Thickness of base
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
shell_ih = 2;	// Height of inner ridge
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

	// Slot chamfer and rounding
	ql = 10; 	// Arbitrary length
	qw = 1;		// Chamger width
	qh = 1.5;	// Chamfer depth
	qz = shell_ht + base_thick;	// Offset for chamfered_rounded_slot

    	// CAN cable cutout
      translate([shell_x - shell_wall-1, (shell_y/2 - cc_frm_side - cc_wid) , shell_ht - cc_z-1])
        cube([shell_wall + 2,cc_wid, 10],false);

    	// RPM sensor coax cable cutout
		twk_y = -2;
		rpm_y = 10+shell_wall+twk_y;	//
		rpm_wid = 3.2;	// Dia of coax
		rpm_dep = 6.5;	// Depth of slot
      translate([shell_x - shell_wall-1, (shell_y/2 - rpm_y - rpm_wid), qz] )
			rotate([90,0,90])
				chamfered_rounded_slot(rpm_wid,ql,rpm_dep,qw,qh);

    	// Temperature sensor cable cutout
		tem_y = 50+shell_wall+twk_y;
		tem_wid = 2.8; tem_dep = 7;
      translate([shell_x - shell_wall-1, (shell_y/2 - tem_y - tem_wid),qz])
			rotate([90,0,90])
				chamfered_rounded_slot(tem_wid,ql,tem_dep,qw,qh);

    	// Throttle sensor cable cutout
		thr_y = 70+shell_wall+twk_y;		// Position along wall	
		thr_wid = 3.0;	thr_dep = 7;
      translate([shell_x - shell_wall-1, (shell_y/2 - thr_y - thr_wid),qz])
			rotate([90,0,90])
				chamfered_rounded_slot(thr_wid,ql,thr_dep,qw,qh);
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

/* Window
 * l  = length (x)
 * w  = width (y)
 * h  = height overall (z)
 * hc = height chamfer
 * sw = slot width for insert
 * st = slot thickness for insert
 * r  = radius of window corners
 *
*/ 
module window(l,w,h,hc,sw,st,r)
{
	// Main inside cutout
	translate([-l/2,0,hc])
//     rounded_rectangle(l,w,h,r); 
		rounded_rectangle_hull(l,w,h,0,r);

	// Slot for insert
	translate([-l-sw,-sw,hc])
     cube([l+2*sw,w+2*sw,st],center=false);

	// Chamfered 
	translate([-l/2,w+hc,hc])
	  rotate([180.0,0])
		chamfered_rectangle(l+2*hc,w+2*hc,hc,r);   
}

// Tabs for holding pc board cover down
 cm_od = 10;	// Diameter of cover mounting post
 cm_len = cm_od/2 + 0;
 cm_id = screw_dia1_ss6+0.4;	// Self-tapping screw hole diameter
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
		union()
		{
	      pc_shell();
			faux_gasket_position();
		}
		union()
		{
			translate([51,-35,-0.05])
				window(38,70,8,1.0,5,0.5,6);

			translate([14,0,0])
			  rotate([0,0,90])
			    mirror([1,0,0])
					id();
		}
   }

}
total();
