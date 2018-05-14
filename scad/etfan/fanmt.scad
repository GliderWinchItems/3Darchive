/* File: plno_gps.scad
 * Base for RTV'ing gps module and mounting in Plano enclosure
 * Author: deh
 * Latest edit: 20180512
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=30;

big = 50;	// Big z in direction 

fn_sq   = 200;    // Fan square outside dimension
fn_ofs_bolt = 10;  // Fan bolt hole center offset from edge
fn_bolt_d = 3.5;    // Fan bolt hole diameter
fn_blow_d = 190;    // Fan blowing hole
fn_mt_thx = 2;  // Fan mounting plate thickness

pl_ht  = 15;    // Plenum height
pl_ovr = 10;    // Plenum overlap lip
pl_thx = 2;     // Wall thickness
pl_screw_d = 3.4;   // Self-tap screw hole in overlap side dia
pl_screw_x = 80;    // Screw offset from center, x direction

hs_wid = (7 + 3/8) * 25.4;  // Width: heatsink outside dimension
hs_y = hs_wid + pl_thx*2;


module fan_hole(ofx,ofy)
{
    translate([ofx,ofy,0])
        cylinder(d=fn_bolt_d,h = big,center=false);
}


module base()
{
    difference()
    {
        union()
        {
            // Fan mounts on to surface
            translate([0,0,fn_mt_thx/2])
                cube([fn_sq,fn_sq,fn_mt_thx],center=true);
        
        }
        union()
        {
            // Center cutout for fan "blowing"
            cylinder(d=fn_blow_d,h=big,center=false);
            
 
        }
    }
}

module plenum()
{
    plz = pl_ovr + pl_ht + fn_mt_thx;
    ply = hs_y - pl_thx*2;
    plx = fn_sq - pl_thx*2;

    translate([0,0,fn_mt_thx]) 
    {
        difference()
        {
            union()
            {
                translate([0,0,plz/2])
                    cube([fn_sq,hs_y,plz],center=true);
            }
            union()
            {
                translate([0,0,plz/2])
                    cube([plx,ply,big],center=true);
                
                plz1 = pl_ht + fn_mt_thx;
                ply1 = hs_wid;
                plx1 = fn_sq+10;
                translate([pl_thx,0,big/2+plz1])
                    cube([plx1,ply1,big],center=true);
            }
        }
    }
}

module screw_hole(delx, delz)
{
    translate([delx, -fn_sq/2, delz])
        rotate([90,0,0])
            cylinder(d=pl_screw_d,h = 2*fn_sq+50,center=true);
}

module tie_hole(dely, delz)
{
    translate([-fn_sq/2, dely, delz])
        rotate([0,90,0])
            cylinder(d=pl_screw_d,h = 2*fn_sq+50,center=true);
}

module total()
{
    difference()
    {
        union()
        {   
            base();
            plenum();
        }
        union()
        {
            // Bolt holes for fan
            del = fn_sq/2 - fn_ofs_bolt;
            fan_hole( del , del);
            fan_hole(-del , del);
            fan_hole( del ,-del);
            fan_hole(-del ,-del);
            
            // Holes in overlap side to heatsink
            ofx1 = 70;
            ofz1 = 15;
            screw_hole( ofx1,ofz1);
            screw_hole(-ofx1,ofz1);
            
            // Holes to tie adjacent units together
            ofy2 = 80;
            ofz2 = 10;
            tie_hole( ofy2, ofz2);
            tie_hole(-ofy2, ofz2);
        }
    }
}

total();