/* File: F4g_cap.scad
 * Hold-down cap for Plano_F4gate.scad
 * Author: deh
 * Latest edit: 20180123
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=100;

big = 10;	// Big z in direction 

bb_wid = 11;
bb_len = 70.25;
bb_cut = 6.5;
bb_hole = 64.5;    // Hole spacing
bb_thk  = 2;    // Thickness
st_wid = 16;
cc_y = 60;

ux = 12;
uy = bb_wid+4;
uz = 8;

module base_bar()
{
    translate([0,0,bb_thk/2])
        cube([bb_len,bb_wid,bb_thk], center= true);
    
    translate([0,bb_wid/2,st_wid/2])
        cube([bb_len,bb_thk,st_wid],center=true);
}
module cut_outs()
{
    wy = 1;
    // Holes for screws
    translate([bb_hole/2,wy,0])
        cylinder(d=3.2,h=5,center=false);

    translate([-bb_hole/2,wy,0])
        cylinder(d=3.2,h=5,center=false);
    
    // Offset from board
    translate([0,-10+bb_cut,5])
        cube([cc_y,10,10],center=true);
    
    // Center cutout for USB cable
    translate([0,0,uz/2])
        cube([ux,uy,uz],center=true);
    
}

module F4gtotal()
{
    difference()
    {
        base_bar();
        cut_outs();
    }
    
}
//F4gtotal();
