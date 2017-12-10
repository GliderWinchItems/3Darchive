/* encoder_plate.scad
 * Top plate for encoder
 * Date: 20170831
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <fairlead_common.scad>

$fn = 50;

ac_d = 77.3;    // Diameter of AC motor
pst_d = 10.7+.3; // Diameter of hole for AC motor posts
psc_d = 66.7;   // Diameter of four screw holes on AC motor posts

ac_base = 3;

vp_d = 8;   // Dia of vertical post
vp_h = 2.8; // Dia of hole for mounting screw
vp_sc_h = 10; // Depth of screw holeinclude <../library_deh/mag_mount.scad>

module topbase()
{
	m = (vp_d*1) + enc_d;
	rounded_rectangle(m,m,tp_base,vp_d/2);

}

module vpost(dia)
{
    ofs_x = vp_d + enc_d/2;
    ofs_z = vp_ht - vp_sc_h;
    
    translate([ofs_x,0,0])
                    cylinder( d=dia, h=20, center=false);
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
module totalplatespacer()
{
   difference()
   {
      union()
      { 
	m = (vp_d*1) + enc_d;
        thick = 5;
	rounded_rectangle(m,m,thick,vp_d/2);
      }
      union()
      {
        cylinder(r=20, h=tp_base, center=false);
       vposts(3.3);
       emtg();
      }
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

