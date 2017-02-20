/* Funnel for filling kombucha bottles
*  File: komfun.scad
 * Author: deh
 * Latest edit: 201702121118
*/

$fn = 60;

// Thicknesses
lip = 4;
t1 = 1.5;
t2 = 1.5;

shrink = 1.03;	// Allowance for shrinkage

// radiuses
r1 = (95.8*shrink)/2;  // ID/2 for funnel
r1b= (89.8*shrink)/2;
r2 = (27.5-t1)/2; // ID/2 of bottle top
r3 = 4;
r4 = 41/2; // Bottle dia/2 at shoulder
r5 = 71/2; // Bottle main diameter

// Lengths
l1 = 76;  
l1a = 8;
l1b = 11;
l2 = 28;
l3 = 38;
l4 = 10;
l5 = 70;

// Polygon points for cross-section
x1  = r1;	y1  = 0;
x1a = r1;	y1a = l1a;
x1b = r1b;	y1b = l1a;
x1c = r1b;	y1c = l1a+l1b;
x2  = r2;	y2  = l1+l1a+l1b;
x3  = r3;	y3  = l1+l1a+l1b+l2;
x4  = r3+t1;	y4  = l1+l1a+l1b+l2;
x5  = r2+t1;	y5  = l1+l1a+l1b;
x6  = r4;	y6  = l1+l1a+l1b;
x7  = r4;	y7  = l1+l1a+l1b+l3;
x8  = r5;	y8  = l1+l1a+l1b+l3+l4;
x9  = r5;	y9  = l1+l1a+l1b+l3+l4+l5;
x10 = r5+t2;	y10 = l1+l1a+l1b+l3+l4+l5;
x11 = r5+t2;	y11 = l1+l1a+l1b+l3+l4;
x12 = r4+t2;	y12 = l1+l1a+l1b+l3;
x13 = r4+t2;	y13 = l1;
x14 = r1+lip;	y14 = 0;

module shell()
{
  rotate_extrude(angle=360)
  {
   polygon(points = [
     [x1,y1], 
     [x1a,y1a],
     [x1b,y1b],
     [x1c,y1c],
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
     [x14,y14] ]);
  }
}

module cutout()
{
   cw = 8;  	ch = 80;
   cx1 = 0;	cy1 = 0;
   cx2 = cw;	cy2 = 0;
   cx3 = cw;	cy3 = ch - cw/2;
   cx4 = cw/2;  cy4 = ch;
   cx5 = 0;	cy5 = ch - cw/2;
 translate([0,-20,l1+l3+l4 -10])
 {  
   rotate([90,0,0])
   {
     linear_extrude(height = 35, center = false)
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
