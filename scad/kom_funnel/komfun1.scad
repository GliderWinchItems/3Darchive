/* Funnel for filling kombucha bottles
*  File: komfun1.scad
 * Author: deh
 * Latest edit: 201702181222
*/

/*
Revised from 'komfun.scad'
*/

$fn = 60;

// Thicknesses
t = 1.5;

shrink = 1.01;	// Allowance for shrinkage

// radii
r1 = (95.8*shrink)/2;  	// ID/2 for seive
r2 = r1;		// Vertical under lip
r3 = 81/2;		// Step around rounded sieve
r4 = (27.5/2)-t; 	// ID/2 of bottle top
r5 = r4 - 4;		// ID/2 of funnel hole
r6 = 44/2;		// Bottle at shoulder
r7 = (69.5*shrink)/2;	// Main bottle


// Lengths

l1 = 8;
l2 = 12; 
l3 = 32;
l13 = l1+l2+l3;
l4 = 30;
l5 = 31;
l6 = 12;
l7 = 65;

// Polygon points for cross-section
x1  = r1;	y1  = 0;
x2  = r2;	y2  = l1; 
x3  = r3;	y3  = y2+l2;
x4  = r4;	y4  = y3+l3;
x5  = r5;	y5  = y4+l4;
x6  = x5+t;	y6  = y5;
x7  = x4+t;	y7  = y4;
x8  = r6;	y8  = y4;
x9  = r6;	y9  = y4+l5;
x10 = r7;	y10 = y9+l6;
x11 = x10;	y11 = y10+l7;
x12 = x10+t;	y12 = y11;
x13 = x10+t;	y13 = y10;
x14 = x9+t;	y14 = y9;

// intercept of outer surface with cone
dx = (l3);
dy = (y4-y3);
incy = (x14-x4) * (dy/dx);
y15 = y4-incy + 0.5;
x15 = x14;

x16 = x3+t;	y16 = y3;
x17 = x2+t;	y17 = y2;
x18 = x1+t;	y18 = 0;



module shell()
{
  rotate_extrude(angle=360)
  {
   polygon(points = [
     [x1,y1], 
     [x2,y2], 
     [x3,y3], 
     [x4,y4],
     [x5,y5], 
     [x6,y6], 
     [x7,y7], 
     [x8,y8], 
     [x9,y9], 
     [x10,y10], 
     [x11,y11], 
     [x12,y12], 
     [x13,y13], 
     [x14,y14],
     [x15,y15],
     [x16,y16],
     [x17,y17],
     [x18,y18],   ]);
  }
}

module cutout()
{
   cw = 8;  	ch = 102;
   cx1 = 0;	cy1 = 0;
   cx2 = cw;	cy2 = 0;
   cx3 = cw;	cy3 = ch - cw/2;
   cx4 = cw/2;  cy4 = ch;
   cx5 = 0;	cy5 = ch - cw/2;
 translate([0,-16,l1+l3+l4-20])
 {  
   rotate([90,0,0])
   {
     linear_extrude(height = 39, center = false)
     {
      polygon( points = [
       [cx1, cy1],
       [cx2, cy2],
       [cx3, cy3],
       [cx4, cy4],
       [cx5, cy5]  ]);
     }
   }
 }
}
module manycuts()
{
      for (a = [0:30:359])
      {
// echo (a);
        rotate([0,0,a])
         cutout();
      }
}

module total()
{  
   difference()
   {
      shell();
      manycuts();
//cutout();
   }
}

total();
