/* File: codewheel_sensor.scad
 * Carrier for PC board with photointerruptor sensors
 * Author: deh
 * Latest edit: 201702032031
 */

 $fn=50;

// PC board dimensions
pc_slop = 4;
pcwid = 49.6 + pc_slop;	// Width of PC board
pclen = 83.0 + pc_slop;	// Length of PC board
pcthick = 1.7;	// Thickness of board

// Photo interruptor - Sharp GP1A57HRJ00F
 ph_slot_ht = 10;  // Width of sloth for encoder wheel
 ph_body_width = 5;// Width of body
 ph_body_ht = 18.6;// Height of body
 ph_slot_y = 3;    // Base to beginning of slot
 ph_slot_x = 15.2; // Base to end of slot
 ph_lead_y = 15.2; // Spacing between pin groups
 ph_lead_x = 2.54; // Spacing between pins

// Slotted panel
 sp_wid1 = 5;
 sp_slot = 3.5;
 sp_wid2 = 5;
 sp_cutout = 2 * (ph_body_width + 4);
 sp_ofs_y = sp_wid1 + sp_wid2 + sp_slot + sp_cutout/2 - 0.2;

ca_thick = 1.5;	// Thickness of carrier
ca_ht = ph_body_ht + 10; // Height of carrier
ca_ae_ht = ca_thick + 3.5;
ca_cutout = sp_ofs_y*2 + 1;


module carrier()
{
   // Base
   cube([ca_cutout, ca_ht, ca_thick]);

   // Alignment edges
   translate([-ca_thick,0,0])
      cube([ca_thick, ca_ht, ca_ae_ht]);
   translate([ca_cutout,0,0])
      cube([ca_thick, ca_ht, ca_ae_ht]);
}
module screw_hole(dia)
{
    cylinder(d = dia, h = ca_thick + .001, center = false);

}
pu_screw = 3.2;     // Diameter of screw
pu_ofs_x = sp_wid1 + sp_cutout/2 + pu_screw/2;
pu_ofs_y1 = 3;
pu_ofs_y2 = ca_ht - 3;
pu_ofs_y3 = 6;  	// Cutout hole offset from bottom
pu_lead_hole = 5.5;	// Hole where leads come thru perf board
pu_selftap_dia = 2.8;	// Self-tapping screws for perf board
pu_selftap_y = (pu_ofs_y2-pu_ofs_y1)/2 + pu_ofs_y1;
pu_sensor_wid = 5;	// Width of sensor body

module center_cutout()
{
  translate([0,pu_ofs_y3,0])
       screw_hole(pu_lead_hole);
  translate([0,ph_lead_y + pu_ofs_y3,0])
       screw_hole(pu_lead_hole);
  translate([-pu_lead_hole/2,pu_ofs_y3,0])
       cube([pu_lead_hole,ph_lead_y,ca_thick],false);

}

module punch()
{
  // Four 4-40 screw holes
  translate([-pu_ofs_x,pu_ofs_y1,0])
       screw_hole(pu_screw); 
  translate([ pu_ofs_x,pu_ofs_y1,0])
       screw_hole(pu_screw); 
  translate([-pu_ofs_x,pu_ofs_y2,0])
       screw_hole(pu_screw); 
  translate([ pu_ofs_x,pu_ofs_y2,0])
       screw_hole(pu_screw); 

 // Center cutout
  translate([pu_sensor_wid/2,0,0])
    center_cutout();
  translate([-pu_sensor_wid/2,0,0])
    center_cutout();
  translate([-pu_lead_hole/2,pu_ofs_y3-pu_lead_hole/2,0])
    cube([pu_lead_hole,ph_lead_y+pu_lead_hole,ca_thick+.01],false);

// PC board self-tapping screws
  translate([-pu_ofs_x,pu_selftap_y,0])
       screw_hole(pu_selftap_dia); 
  translate([ pu_ofs_x,pu_selftap_y,0])
       screw_hole(pu_selftap_dia); 
}

module total();
{
    difference()
    {
       translate ([-ca_cutout/2,0,0])
          carrier();
       punch();
    }
    
}

total();
