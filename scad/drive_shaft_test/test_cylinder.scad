/* test_cyliner.scad
 * Test stand simulate drive shaft 
 * Date: 20170509
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>
include <../drive_shaft/ds_common.scad>

$fn = 200;


shaft_len = 70;	// Length of cylinder

// Motor shaft
ms_len = 12.27;	//  Motor shaft length
ms_shaft_dia = 5  + 0.5; // Shaft diameter
ms_shaft_len1 = 6.2; // Narrow length
ms_washer = 20 + 6;
ms_od_dia = 32.8 + 20; // Diameter of motor holder tube
ms_od_len = 35;   // Length of above

ht = shaft_len - ms_od_len - ms_shaft_len1;
ms_ofs_z1 = ht;
ms_ofs_z2 = shaft_len - ms_od_len;

module drive_shaft()
{

  difference()
  {
     cylinder(d = shaft_dia - 1, h = shaft_len, center = false);
     union()
    {
      cylinder(d = ms_shaft_dia, h = shaft_len+1, center = false);

     
      cylinder(d = ms_washer, h = ht, center = false);

      translate([0,0,ms_ofs_z2])
        cylinder(d = ms_od_dia, h = 100, center = false);
    }
  }
}

drive_shaft();
