/* pod2_tronics.scad
   (name is deceptive; should be '3')
   POD #3 electronics holders
   04/03/2017
*/
include <../library_deh/deh_shapes.scad>

dia_od = 105; // diameter (inside of bottle)

$fn = 200;

pc_wid = 76.0;	// Width of PC board
pc_len = 88.8;	// Length of PC board
pc_thick = 23;	// Thickness allowance for wires etc.
pc_brd_thick = 2.2; 	// Thickness of pc board
pc_bot_grv = 3.0;	// PC brd groove depth bottom
pc_side_grv = 1.5;	// PC brd groove depth side

bat_wid = 36;	// Battery width
bat_len = 105;	// Battery length
bat_thick = 16;	// Battery thickness
bat_ofs = 2;	// Battery offset from bottom
bat_xtra = 5;	// Extra on top end; battery recesses

chfm_ht = 4;	// Chamfer (bottom) height
chfm_wid = 3;	// Chamfer width

side_ht = bat_len + chfm_ht - bat_ofs + bat_xtra;	// Overall height
echo (side_ht);
pc_ofs_y = -5;
pc_ofs_y2 = pc_ofs_y + 8;

module pc_board()
{
echo (side_ht - pc_len + pc_bot_grv);
echo (side_ht - pc_len - 15);

  // Big cutout allows for wires
    translate([
       -(pc_wid/2) + pc_side_grv,
        pc_ofs_y,
        side_ht - pc_len + pc_bot_grv
        ])
      cube([
        pc_wid - 2 * pc_side_grv,
        pc_thick,
        pc_len - pc_bot_grv
        ],center=false);
  // Cutout for grooves on sides and bottom
    translate([
       -pc_wid/2,
        pc_ofs_y2,
        side_ht - pc_len
        ])
      cube([
        pc_wid,
        pc_brd_thick,
        pc_len
        ],center=false);
}

module battery()
{
    translate([-bat_wid/2-20,-23,bat_ofs])
      cube([bat_wid,bat_thick,bat_len+10],center=false);

/* ***** wedge *****
wedge(l, w, h)
l = length
w = width
h = height/thickness
*/
bt_wedge_x = bat_thick;
bt_wedge_y = 16;
bt_wedge_z = 6;
   translate([-bat_wid/2-20,-23+bt_wedge_y,side_ht-bt_wedge_y])
    rotate([-90,180,90])
      wedge(bt_wedge_x,bt_wedge_y,bt_wedge_z);

}

/* Stuff heavy battery leads into holes */
sf_dia = 12;
sf_depth = 80;
module bt_leadstuff()
{
   translate([-bat_wid/2-20,-31,side_ht-sf_depth + bat_xtra])
     cylinder(d = sf_dia, h = sf_depth, center = false);

   translate([-bat_wid/2-20,-31,side_ht])
     rotate([0,90,90])
       cylinder(d = sf_dia, h = 12, center = false);


   translate([-bat_wid/2-30,0,side_ht-sf_depth + bat_xtra])
     cylinder(d = sf_dia, h = sf_depth, center = false);

   translate([-bat_wid/2-30,0,side_ht])
     rotate([0,90,-50])
       cylinder(d = sf_dia, h = 18, center = false);

   // Cutout for battery-to-PC board wires
   translate([-bat_wid/2,0,side_ht])
      cube([20,15,15],center = true);

   // Circular wedge for battery wires
translate ([-5,5,side_ht-5]) 
 rotate([0,0,-50])
   difference()
   {
      cylinder(d = 100, h = 10, center = false);
      union()
      {
lm_wid = 100;
lm_thick = 30;
         cylinder(d = 50,  h = 10, center = false);
         translate([-lm_wid/2,-lm_thick,0])
            cube ([lm_wid,lm_wid,12], center = false);
      }
   }

}

module chamfer()
{
     // Sides with chamfer at bottom edge
//    difference()
     {
        cylinder(h = chfm_ht, 
           r1 = dia_od/2-chfm_wid, 
           r2 = dia_od/2, 
           center = false);
     }
 }

/* Main insert sits on top of chamfer */
module insert()
{
  translate([0,0,chfm_ht])
   cylinder(d = dia_od, h = (side_ht - chfm_ht), center = false); 
   chamfer();
}

/* Hole in bottom for load-cell cable */
cable_lc_dia = 20; // Load-cell cable (at connector)
module cable_lc_cutout()
{
   translate([pc_wid/2-10,pc_ofs_y+cable_lc_dia/2,0])
     cylinder(d = cable_lc_dia, h = 150, center = false);
}

/* RJ45 jack cutout */
rj_ofsw = 9;	// Offset from edge of pc board
rj_widx = 56;	// Width edgewise (x)
rj_leny = 14.0;	// Length (y)
rj_depth = 15.0;// Depth from bottom edge of board

module rj45()
{
   translate([
		-(pc_wid/2) + pc_side_grv+rj_ofsw,
		pc_ofs_y2-rj_leny,
		side_ht - rj_depth
      ])
      cube([rj_widx, rj_leny, rj_depth], center = false);
}

/* GPS and load-cell cable cutout 
Hole and slot allow gps module plus load-cell connected
to the bottom of the pc board to pass through the bottom
of the pc board pocket.
*/
gl_slotx = 33;	// Width of board
gl_sloty = 13;	// Thickness of slot
gl_dia = 23;	// Cable connector hole dia
module gpsslot()
{
// Thickness of slot/hole
gl_ht = side_ht - pc_len + pc_bot_grv + bat_xtra + 1;

/*
    translate([0,pc_ofs_y2+5,0])
    rotate([0,0,-15])
    {
       translate([-gl_slotx/2,-gl_sloty/2,0])
             cube([gl_slotx,gl_sloty,gl_ht],center=false);
       cylinder(d = gl_dia, h = gl_ht, center=false);
    }
*/  
    // Space at bottom of pc board for cable
    gl_wid2 = 50;  // Width smaller than pc board
    gl_ht2 = 50;
    translate([-gl_wid2/2,-pc_thick/2+5,-0.01])
      cube([gl_wid2,pc_thick,gl_ht2],center=false);

}

/* gps pocket */
module gps_pocket()
{
   translate([12,-4,0])
    rotate([0,0,45])
    {
      cube([gl_slotx,gl_slotx,gl_sloty],center = false);
      // Self tapping screw hole
      translate([gl_slotx-2.25, gl_slotx-2.25, gl_sloty])
        cylinder(d1 = 3, d2 = 1.5, h = 8, center = false);
    }
}

/* Pushbutton access hole */
pb_dia = 20;	// Diameter of access hole
pb_z = 7;	// Distance up from bottom edge of pc board
pb_edge = 32;	// Distance in from pc board edge

module pb_hole()
{
pb_ofsz = side_ht - pc_len + pb_z;
echo (124.0);
echo (pb_ofsz);
  translate([((pc_wid/2) - pb_edge),0,pb_ofsz])
  rotate([0,90,90])
    cylinder(d = pb_dia, h = 100, center = false);

}

/* Indexing plugs holes */
ip_dia = 15;
ip_depth = 15;
module ip_holes()
{
   translate([0,0,side_ht])
   {
	translate([25,-25,-ip_depth+.01])
	cylinder(d = ip_dia, h = ip_depth, center = false);
	translate([0,35,-ip_depth+.01])
	cylinder(d = ip_dia, h = ip_depth, center = false);
   }
}

/* LED and jtag access cutout */
jt_len = 60;
jt_wid = 9;
jt_ht = 50;
jt_rad = 5;
jt_z = side_ht-20;
module ledjtag_cutout()
{
jt_x = pc_wid/2 - 9;
    translate ([jt_x,0,jt_z]) 
      rotate([0,90,90])
       rounded_rectangle(jt_len,jt_wid, jt_ht, jt_rad);

    // Cutout for jtag plug/ribbon cable
    translate([18,25,jt_z])
      rotate([0,90,90])
       rounded_rectangle(43,25, 30, jt_rad);     
}

module total()
{
   difference()
   {
      union()
      {
         insert();
      }
      union()
      {
	 ip_holes();	// Indexing holes for end cover

	 translate([8,-1.0,0])
         {
          battery();     // Battery pocket
	  bt_leadstuff();
         }

         translate([7,2,0])
         {
          pc_board();	// PC board pocket  
 	  rj45();	// RJ45 jack pocket
          gpsslot();
	  pb_hole();	// Pushbutton access hole
	  ledjtag_cutout();// LED and jtag access cutout
	  gps_pocket();
         }
      }
   }


}
total();


