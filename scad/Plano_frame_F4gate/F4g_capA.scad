/* File: F4g_capA.scad
 * Hold-down cap for Plano_F4gate.scad
 * Author: deh
 * Latest edit: 20180123
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/deh_shapes2.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=100;

big = 10;	// Big z in direction 

bb_wid = 21;
bb_len = 70.25-3;
bb_cut = 6.5;
bb_hole = 63.3-1.5;    // Hole spacing
bb_thk  = 2;        // Thickness
st_wid = 15.5-4;
cc_y = 60-4.5;

ux = 12;
uy = bb_wid+4;
uz = 8;

module base_bar()
{
    translate([0,0,bb_thk/2])
        cube([bb_len,bb_wid,bb_thk], center= true);
    
    translate([0,bb_wid/2,st_wid/2])
        cube([bb_len,bb_thk,st_wid],center=true);

    // Stiffener
	translate([25,4.5,11.5])
       rotate([180,0,180])
		wedge(50, 6, 6);

}
module cut_outs()
{
    wy = 1+5;
    // Holes for screws
    translate([bb_hole/2,wy,0])
        cylinder(d=3.3,h=5,center=false);

    translate([-bb_hole/2,wy,0])
        cylinder(d=3.3,h=5,center=false);
    
    // Offset from board
    translate([0,-10+bb_cut,4])
        cube([cc_y,20,9],center=true);
    
    // Center cutout for USB cable
    translate([0,0,uz/2])
        cube([ux,uy,uz],center=true);
/*    
    // Wire cutouts
    translate([-15,10,st_wid])
        rotate([90,0,0])
            cylinder(d=10,h = 20,center=true);
            
    translate([ 15,10,st_wid])
        rotate([90,0,0])
            cylinder(d=10,h = 20,center=true);

	// CAN wires cutout
    translate([ 4.5,15,st_wid-3])
        rotate([90,0,0])
		    rounded_rectangle_hull(7,6,10,0,2);
*/
}

module F4gtotal()
{
    difference()
    {
        base_bar();
        cut_outs();
    }

    
}
F4gtotal();
