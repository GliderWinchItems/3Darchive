/* File: pwr4cap.scad
 * Capacitor holder: 4 1500u 25v
 * Author: deh
 * Latest edit: 20180601
 * 
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=50;

end_len = 52;
end_wid = 52;
end_thx = 8; 		// End plate thickness
end_rad = 2;

cap_d1 = 22.5 + 0.5;	// Diameter of main body
cap_d2 = 14.4;		// Diameter of hole
cap_thx = 1;		// End hole thickness

module capseat(dx,dy)
{
	translate([dx,dy,cap_thx])
		cylinder(d=cap_d1,h=50,center=false);

	translate([dx,dy,-0.1])
		cylinder(d=cap_d2,h=50,center=false);
}
module capseats()
{
ofx = cap_d1/2 + 1;
ofy = cap_d1/2 + 1;
	capseat( ofx, ofy);
	capseat(-ofx, ofy);
	capseat( ofx,-ofy);
	capseat(-ofx,-ofy);
}

/* Mounting tabs */
tb_len = 12;
tb_wid = 15;
tb_thx = 3;
tb_rad = 2;
tb_dia = 3.5;	// Screw hole diameter

module tab(dx)
{

ofy = (end_wid+end_rad)/2 - tb_thx;
ofz = tb_wid/2 + tb_rad/2;

	translate([dx,-ofy,ofz])
	{
     rotate([90,0,0])
		difference()
		{
			union()
			{
   				rounded_rectangle(tb_len,tb_wid,tb_thx,tb_rad);
			}
			union()
			{
				ofx1 = tb_len/2 - tb_dia/2;
				ofy1 = tb_wid/2 - tb_dia/2;
				translate([-ofx1, -ofy1,-0.1])
					cylinder(d=tb_dia,h=50,center=false);

				translate([-ofx1,  ofy1,-0.1])
					cylinder(d=tb_dia,h=50,center=false);
			}
		}
	}
}

module tabs()
{
ofx = (end_len +end_rad)/2;
	tab(-ofx);
	mirror([1,0,0]) tab(-ofx);
}

module end_plate()
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
			rounded_rectangle(end_len,end_wid,end_thx,end_rad);

		}

		union()
		{
			capseats();
		}
	}	
}
end_plate();
tabs();
