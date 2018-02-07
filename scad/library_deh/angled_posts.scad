/* File: angled_posts.scad
 * PCB type posts where board mounts at angle
 * Author: deh
 * Latest edit: 20180125
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/ridged_screw_hole.scad>

/* Modules in this file
module angled_post_side_right(wid,slen,theta,ht1,rdg,ldg)
module angled_post_side_left(wid,slen,theta,ht1,rdg,ldg)
module angled_post_bottom(wid,len,theta,ht,rdg,ldg,clht,sigma)



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
//translate([50,0,0])
//angled_post_side_right(3,12,20,4,2,2);	// Test module

module angled_post_side_left(wid,slen,theta,ht1,rdg,ldg)
{
	mirror([1,0,0])
		angled_post_side_right(wid,slen,theta,ht1,rdg,ldg);

}
//angled_post_side_left(3,12,20,4,2,2);	// Test module

/* ***** angled_post_bottom ***********
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
//angled_post_bottom(4,8,25,5,2,2.5,4,20);  // Test

/* ***** angled_post_ridged_corner ***********
* xlen = x axis direction length
* ylen = y axis direction length
* zlen = z axis, height to ledge
* tpht = slant height of cocked top
* rht  = ridge thickness
* rwdx = ridge width, x directions
* rwdy = ridge width, y directions
* scd1 = screw diameter at top
* scd2 = screw diameter at bottom of screw
* sch  = screw hole height
* scofx = screw hole center offset from inside ridge corner, x
* scofy = screw hole center offset from inside ridge corner, y
 */
module angled_post_ridged_corner(xlen,ylen,theta,zlen,tpht,rht,rwdx,rwdy,scd1,scd2,sch,scofx,scofy) 
{
	// Find height of ledge corner after tilting
	ht1 = (ylen-rwdy) * sin(theta);
	ht2 = tpht * cos(theta);
	ht3 = zlen - ht1 - ht2;
echo("angled_post_ridged_corner:ht1,ht2,ht3",ht1,ht2,ht3);

	tx = rwdx;

	ty6 = tpht * sin(theta);
   ty7 = (ylen-rwdy) * cos(theta);
   ty8 = ty7 - ty6;

 translate([-tx,ty8,0])
 {
  difference()
  {
	union()
	{
	  translate([0,0,ht3])
     {
		// Top ridged part tilted
		rotate([-theta,0,0])
		translate([rwdx,rwdy-ylen,0])
		corner_ridged_rectangle        (xlen,ylen,tpht,rht,rwdx,rwdy);
//		corner_ridged_rectangle_w_screw(xlen,ylen,tpht,rht,rwdx,rwdy,scd1,scd2,sch,scofx,scofy);

		// Rounded wedge transition to vertical post
		translate([xlen,0,0.05])
  		rotate([90,0,-90])
  			rotate_extrude(angle=theta)
				square([ylen,xlen],center=false);
     }
		// Bottom post
		translate([0,-ylen,0])
			cube([xlen,ylen,ht3+.1],center=false);
   }
	{
	    hx =  rwdx + scofx;
	    hy = -(ylen-rwdy) - tpht*tan(theta) + scofy;
		 ht4 = zlen + rht - sch - (ylen-rwdy)*sin(theta);
	 	 rotate([-theta,0,0])
	    	translate([hx,hy,ht4])
	        cylinder(d1=scd2,d2=scd1,h=sch,center=false,$fn=25);   
	}
  } 
 }
}
//                       xlen,ylen,theta, zlen, tpht, rht,rwdx,rwdy,scd1,scd2,sch,scofx, scofy
//  angled_post_ridged_corner(6,   12,  30,    8,    2, 1.5,   5,   4, 3.2, 1.8,  6, -1.5, -2.0); // Test


