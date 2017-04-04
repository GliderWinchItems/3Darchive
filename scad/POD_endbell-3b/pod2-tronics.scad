/* pod3_tronics.scad
   POD #3 electronics holders
   04/03/2017
*/
include <../library_deh/deh_shapes.scad>

dia_od = (105); // diameter (inside of bottle)

$fn = 200;

pc_wid = 76.0;	// Width of PC board
pc_len = 88.8;	// Length of PC board
pc_thick = 20;	// Thickness allowance for wires etc.
pc_brd_thick = 1.7; 	// Thickness of pc board
pc_bot_grv = 3.0;	// PC brd groove depth bottom
pc_side_grv = 2.0;	// PC brd groove depth side

bat_wid = 36;	// Battery width
bat_len = 105;	// Battery length
bat_thick = 16;	// Battery thickness
bat_ofs = 3.5;

chfm_ht = 4;	// Chamfer (bottom) height
chfm_wid = 3;	// Chamfer width

side_ht = bat_len + chfm_ht - bat_ofs;	// Overall height

pc_ofs_y = -5;
pc_ofs_y2 = pc_ofs_y + 5;

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
    translate([-bat_wid/2-20,-23,(chfm_ht - bat_ofs)])
      cube([bat_wid,bat_thick,bat_len+10],center=false);
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
/*        cylinder(h = chfm_ht, 
          d = (dia_od - 2*chfm_wid), 
          center = false);
*/
     }
 }

/* Main insert sits on top of chamfer */
module insert()
{
  translate([0,0,chfm_ht])
   cylinder(d = dia_od, h = (side_ht - chfm_ht), center = false); 
   chamfer();
}


/* Slot for running gps cable down side */
cable_gps_dia = 12;
module cable_gps_cutout()
{
  translate([dia_od/2-cable_gps_dia/2,0,0])
    rounded_bar(cable_gps_dia, cable_gps_dia, 110);
}

/* Hole in bottom for load-cell cable */
cable_lc_dia = 20; // Load-cell cable (at connector)
module cable_lc_cutout()
{
   translate([pc_wid/2-10,pc_ofs_y+cable_lc_dia/2,0])
     cylinder(d = cable_lc_dia, h = 150, center = false);
}

/* RJ45 jack cutout */
rj_ofsw = 36;	// Offset from edge of pc board
rj_widx = 15;	// Width edgewise (x)
rj_leny = 13;	// Length (y)
rj_depth = 14.5;// Depth from bottom edge of board

module rj45()
{
   translate([
		-(pc_wid/2) + pc_side_grv+rj_ofsw,
		pc_ofs_y2-rj_leny,
		side_ht - rj_depth
      ])
      cube([rj_widx, rj_leny, rj_depth], center = false);
}
/* GPS and load-cell cable cutout */
gl_slotx = 32;	// Width of board
gl_sloty = 12;	// Thickness of slot
gl_dia = 20;	// Cable connector hole dia
module gpsslot()
{
// Thickness of slot/hole
gl_ht = side_ht - pc_len + pc_bot_grv + 1;

    translate([0,pc_ofs_y2+5,0])
    rotate([0,0,-15])
    {
       translate([-gl_slotx/2,-gl_sloty/2,0])
             cube([gl_slotx,gl_sloty,gl_ht],center=false);
       cylinder(d = gl_dia, h = gl_ht, center=false);
    }
}

/* gps pocket */
module gps_pocket()
{
   translate([20,0,0])
    rotate([0,0,45])
      cube([gl_slotx,gl_slotx,gl_sloty],center = false);
}

/* Pushbutton access hole */
pb_dia = 20;	// Diameter of access hole
pb_z = 7;	// Disatnce up from bottom edge of pc board
pb_edge = 32;	// Distance in from pc board edge

module pb_hole()
{
pb_ofsz = side_ht - pc_len + pb_z;
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
jt_len = 42;
jt_wid = 9;
jt_ht = 50;
jt_rad = 5;
jt_z = 65;
module ledjtag_cutout()
{
jt_x = pc_wid/2 - 9;
    translate ([jt_x,0,jt_z]) 
      rotate([0,90,90])
       rounded_rectangle(jt_len,jt_wid, jt_ht, jt_rad);
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
         pc_board();	// PC board pocket  
         battery();     // Battery pocket
 	 rj45();	// RJ45 jack pocket
         gpsslot();
	 pb_hole();	// Pushbutton access hole
	 ip_holes();	// Indexing holes for end cover
	 ledjtag_cutout();// LED and jtag access cutout
	 gps_pocket();
      }
   }
//translate ([150,0,0]) pb_hole();


}
total();


