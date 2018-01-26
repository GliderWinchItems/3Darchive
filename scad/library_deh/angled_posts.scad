/* File: angled_posts.scad
 * PCB type posts where board mounts at angle
 * Author: deh
 * Latest edit: 20180125
 */

include <../library_deh/deh_shapes.scad>

/* Modules in this file
module angled_post_side_right(wid,slen,theta,ht1,rdg,ldg)
module angled_post_side_left(wid,slen,theta,ht1,rdg,ldg)


*/


/* ***** angled_post_side_right ***********
 * wid = width (x direction)
 * slen = slant length
 * theta = angle
 * ht1 = height at shortest end at ledge
 * rdg = ridge height
 * ldg = pcb ledge width
 * NOTE: x,y (0,0) reference is lower end at inside ridge wall
 */
module angled_post_side_right(wid,slen,theta,ht1,rdg,ldg)
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

//angled_post_side_right(3,12,20,4,2,2);	// Test module

module angled_post_side_left(wid,slen,theta,ht1,rdg,ldg)
{
	mirror([1,0,0])
		angled_post_side_right(wid,slen,theta,ht1,rdg,ldg);

}
//angled_post_side_left(3,12,20,4,2,2);	// Test module

/* ***** angled_post_side_bottom ***********
 * Angled notch is upward pointing
 * wid = width (x direction)
 * len = length (y direction)
 * theta = angle: pcb
 * ht  = height of ledge at bottom corner of pcb
 * rdg = pcb board thickness
 * ldg = pcb ledge width
 * clht= clip height (overhang vertical height)
 * sigma = added angle of upper overhang
 * NOTE: theta+sigma must be > 40 degrees w/o support structures
 * NOTE: x,y (0,0) reference is lower end at inside ridge wall
 */
module angled_post_bottom(wid,len,theta,ht,rdg,ldg,clht,sigma)
{
	x1 = wid - ldg;
	x2 = x1 - rdg * sin(theta);
	y4 = rdg * cos(theta);
	gamma = theta + sigma;
	yy = ldg * tan(theta);
	x3 = clht / tan(gamma);
	a = ht;

	translate([-x1,len,0])
	{
		difference()
		{
//			cube([wid,len,ht3],center=false);

			rotate([90,0,0])
			linear_extrude(height=len, center=false)
				polygon(points=[
					[0,0],
					[0,clht+a],
					[x3,clht+a],
					[x2,y4+a],
					[x1,0+a],
					[wid,yy+a],
					[wid,0]]);

			union()
			{
			}
		}
	}	
}
angled_post_bottom(4,8,25,5,2,2.5,4,20);


