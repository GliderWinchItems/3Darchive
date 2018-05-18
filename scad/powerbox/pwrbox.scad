/* File: pwrbox.scad
 * Box and fittings for CAN power box
 * Author: deh
 * Latest edit: 20180516
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=100;

/*{
	difference()
	{
		union()
		{

		}
		union()
		{

		}
	}
}
*/ 

cap_d = 26;	// Capacitor diameter
cap_len = 30;
cap_end = 2;
cap_bot = 5;
cap_sid = 5;


module capmt()
{
cap_x = cap_end*2 + cap_len;
cap_y = cap_d + cap_sid*2;
cap_z = cap_bot + cap_d/2;
ofz = cap_bot+cap_d/2;

	difference()
	{
		union()
		{
            // Main block
            translate([0,0,cap_z/2])
                cube ([cap_x,cap_y,cap_z],center=true);
		}
		union()
		{
            // Cap well
            translate([0,0,ofz])
                rotate([0,90,0])
                    cylinder(d=cap_d,h=cap_len,center=true);
            
            // Wires at end of cap
            translate([0,0,ofz])
                rotate([0,90,0])
                    cylinder(d=3,h=100,center=true);
            
            // Reduce waste
            wx = cap_x - 12;
            wy = 100;;
            wz = 100;
            ofz1 = wz/2 + cap_bot -2;
            translate([0,0,15])
                cube ([wx,wy,cap_z],center=true);
            
            wz1 = cap_d + 6;
            translate([0,0,0])
                cube ([wx,wz1,cap_z],center=true);            
		}
	}
}
module capclamp()
{
cap_x = cap_end*2 + cap_len;
cap_y = cap_d + cap_sid*2;
cap_z = cap_bot + cap_d/2;
ofz = cap_bot+cap_d/2;

 translate([0,0,0])
  //rotate([180,0,0])

	difference()
	{
		union()
		{
            // Main block
            translate([0,0,cap_z/2])
                cube ([cap_x,cap_y,cap_z],center=true);
		}
		union()
		{
            // Cap well
            translate([0,0,ofz])
                rotate([0,90,0])
                    cylinder(d=cap_d,h=cap_len,center=true);
            
            // Wires at end of cap
            translate([0,0,ofz])
                rotate([0,90,0])
                    cylinder(d=3,h=100,center=true);
            
            // Reduce waste
            wx = cap_x - 12;
            wy = 100;;
            wz = 100;
            ofz1 = wz/2 + cap_bot -2;
            translate([0,0,55])
                cube ([wx,wy,100],center=true);
            
            wz1 = cap_d + 6;
            translate([0,0,0])
                cube ([wx,wz1,100],center=true);            
		}
	}
}


module total()
{
	difference()
	{
		union()
		{
			capmt();
			translate([0,50,0]) capclamp();
		}
		union()
		{

		}
	}
}
total();
