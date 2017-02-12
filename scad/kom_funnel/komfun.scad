/* Funnel for filling kombucha bottles
*  File: komfun.scad
 * Author: deh
 * Latest edit: 201702121118
*/

// Thicknesses
lip = 4;
t1 = 3;
t2 = 2;

// radiuses
r1 = 70;
r2 = 20;
r3 = 18;
r4 = r1+lip-t2;
r5 = 35;

// Lengths
l1 = 50;
l2 = 25;
l3 = 40;
l4 = 16;
l5 = 80;

// Polygon points for cross-section
x1  = r1;	y1  = 0;
x2  = r2;	y2  = l1;
x3  = r3;	y3  = l1+l2;
x4  = r3+t1;	y4  = l1+l2;
x5  = r2+t1;	y5  = l1;
x6  = r1+lip;	y6  = l1;
x7  = r4;	y7  = l1+l3;
x8  = r5;	y8  = l1+l3+l4;
x9  = r5;	y9  = l1+l3+l4+l5;
x10 = r5+t2;	y10 = l1+l3+l4+l5;
x11 = r5+t2;	y11 = l1+l3+l4;
x12 = r4+t2;	y12 = l1+l3;
x13 = r1+lip;	y13 = 0;

module shell()
{
  rotate_extrude(angle=360,convexity=10)
  {
   polygon(points = [
     [x1,y1], [x2,y2], [x3,y3], [x4,y4],
     [x5,y5], [x6,y6], [x7,y7], [x8,y8], [x9,y9], 
     [x10,y10], [x11,y11], 
     [x12,y12], [x13,y13] ]);
  }
}

shell();
