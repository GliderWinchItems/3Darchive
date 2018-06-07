/* File: airxplugS.scad
 * Plug for air-conditioner drain--Solid
 * Author: deh
 * Latest edit: 20180603
 * 
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=100;

plg_ht = 20;
plg_d1 = 9;
plg_d2 = 12.0;
tub_d1 = 5.0;
tub_d2 = 4.0;
tub_ht = 30;
hole_dia = 4.5;

module plug_tube()
{
	difference()
	{
		union()
		{
			cylinder(d1=plg_d1,d2=plg_d2,h=plg_ht,center=false);

			translate([0,0,plg_ht])
				cylinder(d1=tub_d1,d2=tub_d2,h=tub_ht,center=false);
		}
		union()
		{
//			cylinder(d=hole_dia,h=100,center=false);
		}
	}
}
plug_tube();
