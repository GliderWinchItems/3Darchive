/* pod_tronics.scad
   POD #2 electronics holders
   03/15/2017
*/
$fn = 400;

include <../library_deh/deh_shapes.scad>

dia_od = (105); // diameter (inside of bottle)

thick_bottom = 1;
thick_sides = 1;

chfm_ht = 4;
chfm_wid = 3;

slop = 1;
bat_len = 112.7+slop;
bat_ofs_z = 1;

pc_wid = 82.2+slop;	// Width of PC board
pc_len = 110;	// Length of PC board
pc_thick = 25+slop;	// Thickness allowance for wires etc.
pc_ofs_y = -22;
side_ht = bat_len +bat_ofs_z-chfm_ht-.01;	// Height
pc_ofs_z = side_ht+chfm_ht-pc_len;	// Offset from bottom of insert

echo (side_ht+chfm_ht);	// Echo overall length


/* Note: side height is adjusted so that the PC board box has
a minimal floor on the bottom (pc_ofs) and the top is flush
with the top of the insert.  The battery box z offset is set
so that the top of the battery box is flush with the top.
Beware: the chamfer height adds to the side_ht, hence the
offsets have the chamfer height subtracted from the z offset.
*/

module pc_board()
{
    translate([-pc_wid/2,pc_ofs_y,pc_ofs_z])
      cube([pc_wid,pc_thick,pc_len],center=false);

}
pc_bat_sep = 1.5;	// Separator foam between battery & PC boxes
bat_wid = 62.6+slop;
bat_thick = 30.7+pc_bat_sep+slop;
bat_ofs_y = pc_ofs_y+pc_thick-.01;

module battery()
{
    translate([-bat_wid/2-0.1,bat_ofs_y,bat_ofs_z])
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

module insert()
{
  translate([0,0,chfm_ht])
   cylinder(d = dia_od, h = side_ht, center = false);
   chamfer();
}


/* Slot for running gps cable down side */
cable_gps_dia = 12;
module cable_gps_cutout()
{
  translate([-pc_wid/2,pc_ofs_y,pc_ofs])
    rounded_bar(cable_gps_dia, cable_gps_dia, 110);
}

/* Hole in bottom for load-cell cable & GPS */
cable_lc_dia = 20; // Load-cell cable (at connector)
lc_wid = 5; //20;
lc_len = 40;
lc_ht = 150;
module cable_lc_cutout()
{
   translate([15,pc_ofs_y+5, -.01])
       cube([lc_len, lc_wid, lc_ht],center=false);
   translate([8,pc_ofs_y+10, -.01])
     cylinder(d = cable_lc_dia, h = 150, center = false);
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
/*         rotate([0,0,-45])
           cable_gps_cutout(); // GPS cable groove
*/
         cable_lc_cutout();    // Load-cell cable hole
      }
   }
}
total();


