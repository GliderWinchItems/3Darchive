/* File: airxplug.scad
 * Plug for air-conditioner drain
 * Author: deh
 * Latest edit: 20180601
 * 
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=100;


plg_ht = 20;
plg_d1 = 10.0;
plg_d2 = 12.8;
tub_d1 = 7.5;
tub_d2 = 6.0;
tub_ht = 19;
hole_dia = 4.5;

module plug_tube()
{
	difference()
	{
		union()
		{
			cylinder(d1=plg_d1,d2=plg_d2,h=plg_ht,center=false);

			translate([0,0,plg_ht])
				cylinder(d1=plg_d2,d2=tub_d1,h=3,center=false);

			translate([0,0,plg_ht])
				cylinder(d1=tub_d1,d2=tub_d2,h=tub_ht+3,center=false);

		}
		union()
		{
			cylinder(d=hole_dia,h=100,center=false);
		}
	}
}
plug_tube();
