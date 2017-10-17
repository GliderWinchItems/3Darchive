/* encoder_plate.scad
 * Top plate for encoder
 * Date: 20171011
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <generator_common.scad>

$fn = 50;

vp_d = 6;   // Dia of vertical post
vp_h = 2.8; // Dia of hole for mounting screw
vp_sc_h = 10; // Depth of screw holeinclude <../library_deh/mag_mount.scad>

module topbase()
{
	m = vp_d*3 + enc_d;
	cylinder(d = m, h = tp_base,center=false);

}

vpost_ofs_x = vp_d + enc_d/2;

module vpost(dia)
{
    ofs_z = vp_ht - vp_sc_h;
    
    translate([vpost_ofs_x,0,0])
                    cylinder( d=dia, h=19, center=false);
}

module vposts(dia)
{
     for (i = [0+45 : 90 : 360+45])
     {
        rotate([0,0,i])
           vpost(dia);    
     }
     cylinder(d=20.5,h=10,center=false);
}

module emtg()
{
     for (i = [0 : 120 : 360])
     {
        rotate([0,0,i])
           translate([en_r,0,0])    
            cylinder(d = 3.5,h = 10, center=false);
     }  
}

module totalplate()
{
   difference()
   {
     union()
    {
      topbase();
    }
    union()
    {
       vposts(3.3);
       emtg();
    }
   }

}

