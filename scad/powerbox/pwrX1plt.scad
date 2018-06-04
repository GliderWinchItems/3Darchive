/* File: pwrX1plt.scad
 * Power unit: switcher plates
 * Author: deh
 * Latest edit: 20180603
 * 
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/deh_shapes2.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=50;

plt1_len = 52;
plt1_wid = 52;
plt1_thx = 1.5; 		// End plate thickness
plt1_rad = 2;
plt1_tab_ovr = 8;		// Tab overlap depth on sides
plt1_tab_thx = 2;		// Width/thickness of overlap tab


u = 0.5;	// 
swx_len = 50.2 + u;	// Switcher pcb length
swx_wid = 46.2 + u;	// Switcher pcb width
swx_thx = 1.5 + 0.3;	// Switcher pcb thickness
swx_bot_thx = 4.0;	// Space below pcb

module plate1()
{
	difference()
	{
		union()
		{
			/* ***** rounded_rectangle ******
rounded_rectangle(l,w,h,rad);
l = length (x direction)
w = width (y direction)
h = thickness (z direction)
rad = radius of corners
reference = center of rectangle x,y, bottom
*/
len1 = plt1_len + 2*plt1_tab_thx;
wid1 = plt1_wid;
thx1 = plt1_thx + plt1_tab_ovr + swx_bot_thx + swx_thx;

			rounded_rectangle(len1,wid1,thx1,plt1_rad);

		}

		union()
		{
			k = 1.5;	// Edge ridge width
			len2 = swx_len - k;
			wid2 = swx_wid - k;
		   cube([len2,wid2,50],center=true);

			ofz3 = 50/2 + plt1_thx/2;
			translate([0,0,ofz3])
				cube([swx_len,swx_wid,50],center=true);

			ofz4 = 50/2 + swx_bot_thx + swx_thx + plt1_thx;
			len4 = plt1_len + 0.3;
			translate([0,0,ofz4])
				cube([len4,90,50],center=true);
		}
	}	
}
module plate2()
{
	difference()
	{
		union()
		{
			
			thx1 = swx_bot_thx;
			ofz1 = thx1/2;
			translate([0,0,ofz1])
				cube([swx_len,swx_wid,thx1],center=true);
		}

		union()
		{
			k = 1.5;	// Edge ridge width
			len2 = swx_len - k;
			wid2 = swx_wid - k;
		   cube([len2,wid2,50],center=true);
		}
	}	
}
plate1();

translate([80,0,0]) plate2();
