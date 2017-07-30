/* shaft1.scad
 * Coupling for motor to drive shaft--AC motor
 * Date: 20170728
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>

$fn = 60;

cp_ht = 20;
cp_id = 8;
cp_od = 10;
cp_ht2 = 8.3;
cp_od2 = 5;//4.6;
cp_ht3 = 4;
flt_x = 6.5;  // distance across flat
flt_d = 8.25;  // dia of shaft

module doubleflat(d,flt,h)
{
    difference()
    {
            cylinder(d=d,h=h,center=false);
       { 
            difference()
            {
                cylinder(d=d,h=h,center=false);
                union()
                {
                    translate([-d/2,-flt/2,0])
                    cube([d,flt,h],center=false);
                
                }
            }
        }
    }
}
module hose()
{
    $fn=6;
    translate([0,0,cp_ht-.1])
        cylinder(d=cp_od2,h=cp_ht2,center=false);
    
    
}

module part()
{
    difference()
    {
        cylinder(d=cp_od,h=cp_ht,center=false);
        doubleflat(flt_d,flt_x,cp_ht);
    }
    translate([0,0,cp_ht-.1])
        difference()
        {
            cylinder(d1=cp_od,           d2=cp_od2,h=cp_ht3,center=false);
            cylinder(d1=flt_d,            d2=  0,       h=cp_ht3-.3,center=false);
        }
        hose();

}
part();
