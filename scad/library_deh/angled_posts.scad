/* File: angled_posts.scad
 * PCB type posts where board mounts at angle
 * Author: deh
 * Latest edit: 20180125
 */

include <../library_deh/deh_shapes.scad>
/* ***** side_post_right ***********
 * wid = width (x direction)
 * slen = slant length
 * theta = angle
 * ht1 = height at shortest end at ledge
 * rdg = ridge height
 * ldg = pcb ledge width
 * NOTE: x,y (0,0) reference is lower end at inside ridge wall
 */
module side_post_right(wid,slen,theta,ht1,rdg,ldg)
{
	ht2 = slen * sin(theta);
	ht3 = ht1  + ht2 + rdg / cos(theta);
	x2  = slen * cos(theta);	// y direction length
	x5  = wid - ldg;

	translate([-x5,0,0])
	{
		difference()
		{
			cube([wid,x2,ht3],center=false);

			union()
			{
				// Top 
				ht4 = ht1 + rdg / cos(theta);
				translate([-0.1,0,ht4])
					rotate([theta,0,0])
						cube([wid+2,slen+.1,5],center=false);

				// Ledge
				y5 = slen + rdg*tan(theta);
				translate([x5,0,ht1])
					rotate([theta,0,0])
						cube([wid+2,y5,5],center=false);
			}
		}
	}

}

//side_post_right(3,12,20,4,2,2);	// Test module
side_post_left(3,12,20,4,2,2);	// Test module

module side_post_left(wid,slen,theta,ht1,rdg,ldg)
{
	mirror([1,0,0])
		side_post_right(wid,slen,theta,ht1,rdg,ldg);

}
