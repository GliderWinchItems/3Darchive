/* File: pwrX2plt.scad
 * Power unit: diode and MOV mount plate
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

plt3_len = 52+2.5;
plt3_wid = 52;

plt3_crn_thx = 7.0;
plt3_crn_wid = 8.0*1.4;
plt3_crn_len =  8.0*1.4;

j = 0.5;

module corner_post(dx,dy,theta)
{
/* ***** wedge *****
 * l = length
 * w = width
 * h = height/thickness
 * wedge(l, w, h)
*/
	translate([dx,dy,plt3_crn_thx])
		rotate([0,90,theta])
			wedge(plt3_crn_thx,plt3_crn_wid,plt3_crn_len);

}
module corner_posts()
{
	ofx = (plt3_len-j)/2 - plt3_crn_len;
	ofy = (plt3_wid-j)/2;

	corner_post(-ofx-plt3_crn_len, ofy-plt3_crn_wid,0);
	corner_post(-ofx,-ofy, 90);

	corner_post( ofx, ofy,-90);
	corner_post( ofx+plt3_crn_len,-ofy+plt3_crn_wid,180);

}
plt3_hole_d = 2.8;
module corner_posts_holes()
{
	ofs = 3;
	ofx = plt3_len/2 - ofs;
	ofy = plt3_wid/2 - ofs;
	d1 = plt3_hole_d;
	translate([ ofx, ofy, 0]) cylinder(d=d1,h=50,center=true);
	translate([-ofx, ofy, 0]) cylinder(d=d1,h=50,center=true);
	translate([ ofx,-ofy, 0]) cylinder(d=d1,h=50,center=true);
	translate([-ofx,-ofy, 0]) cylinder(d=d1,h=50,center=true);

}
module block_holes()
{
	ofs = 4;
	ofx = plt3_len/2 - ofs;
	ofy = plt3_wid/2 - ofs;
	d1 = 3.5;
	translate([ ofx,   0, 0]) cylinder(d=d1,h=50,center=true);
	translate([-ofx,   0, 0]) cylinder(d=d1,h=50,center=true);
	translate([   0,-ofy, 0]) cylinder(d=d1,h=50,center=true);
	translate([   0, ofy, 0]) cylinder(d=d1,h=50,center=true);	

}

module d_plate2()
{

	difference()
	{
		union()
		{
			thx1 = 3;
			ofz1 = thx1/2;
			translate([0,0,ofz1])
				cube([plt3_len-j,plt3_wid-j,thx1],center=true);
		}

		union()
		{
			k = 8.0*2;	// Edge ridge width
			len2 = plt3_len - k - j;
			wid2 = plt3_wid - k - j;
echo ("len2",len2,"wid2",wid2);
echo ("plt3_len",plt3_len,"plt3_wid",plt3_wid);
		   cube([len2,wid2,50],center=true);
		}
	}	
}
module total()
{
	difference()
	{
		union()
		{
			d_plate2();
			corner_posts();
		}

		union()
		{
			corner_posts_holes();
			block_holes();
		}
	}	
}
total();

