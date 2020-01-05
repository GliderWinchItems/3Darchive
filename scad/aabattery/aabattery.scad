/* File: aabattery.scad
 * AA battery dummy
 * Author: deh
 * Latest edit: 20200104
 */
 $fn = 80;

module bodyplus()
{
	difference()
	{   union()
        {
            translate([0,0,2])
            cylinder(d = 13.5, h=49.5-2, center=false);
            cylinder(d1=13.5-2,d2=13.5,h=2,center=false);
        }
		union()
		{
            translate([0,0,49.5 - 2.5])
			difference()
            {
				cylinder(d = 20, h=3, center=false);
				translate([0,0,-0.1])
				  cylinder(d = 5.2, h=6, center=false);
            }
            translate([0,0,49.6-40])
            cylinder(d = 3, h= 40,center=false);
            
            translate([-5.5,0,30])
            rotate([0,15,0])
            cylinder(d=3,h=90,center=true);
            
 		}
	}
}

module bodyminus()
{
	difference()
	{
		cylinder(d = 14.0, h=49.5, center=false);
		union()
		{
            translate([0,0,49.5 - 1.5])
			difference()
            {
				cylinder(d = 20, h=3, center=false);
				translate([0,0,-0.1])
				  cylinder(d = 9, h=6, center=false);
            }
            translate([0,0,49.6-40])
            cylinder(d = 3, h= 40,center=false);
            
            translate([-5.5,0,30])
            rotate([0,15,0])
            cylinder(d=3,h=90,center=true);
		}
	}
}
translate ([20,0,0])
bodyplus();

bodyminus();
