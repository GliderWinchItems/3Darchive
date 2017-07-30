/* shaft_fix1p.scad
 * Top plate for ixture for holding encoder over AC motor
 * Date: 20170729
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

tp_base = 2;




vp_d = 8;   // Dia of vertical post
vp_h = 2.8; // Dia of hole for mounting screw
vp_ht = 3; // Height of posts
vp_sc_h = 10; // Depth of screw hole

module topbase()
{
	m = (vp_d*1) + enc_d;
	rounded_rectangle(m,m,tp_base,vp_d/2);

}

module vpost()
{
    ofs_x = vp_d + enc_d/2;
    ofs_z = vp_ht - vp_sc_h;
    
    translate([ofs_x,0,0])
                    cylinder( d=3.3, h=10, center=false);
}

module vposts()
{
     for (i = [0+45 : 90 : 360+45])
     {
        rotate([0,0,i])
           vpost();    
     }
     cylinder(d=20.5,h=10,center=false);
}

en_r = 15.1; // Encoder mtg hole radius

module emtg()
{
     for (i = [0 : 120 : 360])
     {
        rotate([0,0,i])
           translate([en_r,0,0])    
            cylinder(d = 3.5,h = 10, center=false);
     }
        
}

module total()
{
   difference()
   {
     union()
    {
      topbase();
    }
    union()
    {
       vposts();
       emtg();
    }
   }

}
total();
