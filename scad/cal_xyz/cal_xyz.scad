/* File: cal_xyz.scad
 * Calibration posts
 * Author: deh
 * Latest edit: 20180131
 */

len = 100;
wid = 4;
ht = 4;

// **** Id the part ***
module id()
{
 {
  font = "Liberation Sans:style=Bold Italic";
 translate([12,0.5, ht]) 
  rotate([0,0,0])
  linear_extrude(0.5)
   text("X",size = 3.0);

 translate([.5,12, ht]) 
  rotate([0,0,-90])
  linear_extrude(0.5)
   text("Y",size = 3.0);

 translate([-0.2,0.5, 12]) 
  rotate([0,90,0])
  linear_extrude(0.25)
   text("Z",size = 3.0);

 }
}

module total()
{
	cube([len,wid,ht],center=false);

	cube([wid,len,ht],center=false);

	cube([wid,ht,len],center=false);

id();
}
total();
