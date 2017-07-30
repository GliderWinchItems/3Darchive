/* shaft_fix1.scad
 * Fixture for holding encoder over AC motor
 * Date: 20170728
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>

$fn = 50;

ac_d = 77.3;    // Diameter of AC motor
pst_d = 10.7+.3; // Diameter of hole for AC motor posts
psc_d = 66.7;   // Diameter of four screw holes on AC motor posts

enc_d = 38.5;   // Diameter of encoder body

ac_base = 3;

module ACposthole()
{
    translate([psc_d/2,0,0])
        cylinder(d=2.8,h=ac_base+.01,center=false);
}

module ACbase()
{
    difference()
    {
       cylinder(d=ac_d,h = ac_base, center = false);
       {
         for (i = [0 : 90 : 360])
         {
             rotate([0,0,i])
             ACposthole();    
         }
         cylinder(d=10,h=ac_base,center=false);
       }
    }
}

vp_d = 8;   // Dia of vertical post
vp_h = 2.8; // Dia of hole for mounting screw
vp_ht = 67; // Height of posts
vp_sc_h = 10; // Depth of screw hole

module vpost()
{
    ofs_x = vp_d + enc_d/2;
    ofs_z = vp_ht - vp_sc_h;
    
    translate([ofs_x,0,0])
    {   difference()
        {
            union()
            {
                cylinder (d = vp_d, h = vp_ht, center=false);
                translate([0,0,ac_base])
                    circular_outer_chamfer(vp_d+6, 3);
            }
            union()
            {
                translate([0, 0, ofs_z])
                    cylinder( d=vp_h, h=vp_sc_h, center=false);
            }
        }
    }
}

module vposts()
{
     for (i = [0+45 : 90 : 360+45])
     {
        rotate([0,0,i])
           vpost();    
     }
}
module total()
{
	ACbase();
    vposts();

}
total();
