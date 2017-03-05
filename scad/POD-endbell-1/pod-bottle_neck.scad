/* pod-bottle_neck.scad
   POD neck insert for POD #1
   03/04/2017
*/

$fn = 100;

bot_dia = 105;


// Contour
nofs = bot_dia/2 - 45;

y1   = 0;   x1  = 	45.0+nofs;
y2   = 5;   x2  = 	44.0+nofs;
y3   = 10;   x3  = 	43.0+nofs;
y4   = 15;   x4  = 	41.3+nofs;
y5   = 20;   x5  = 	39.3+nofs;
y6   = 25;   x6  = 	36.7+nofs;
y7   = 30;   x7  = 	34.1+nofs;
y8   = 35;   x8  = 	30.5+nofs;
y9   = 40;   x9  = 	27.0+nofs;
y10  = 45;   x10 = 	22.7+nofs;
y11  = 50;  x11 = 	18.3+nofs;
y12  = 55;  x12 = 	12.5+nofs;
//y13  = 60;  x13 = 	6.0+nofs;
//y14  = 65;  x14 = 	1.8+nofs;
//y15  = 65;  x15 =        0+nofs;
y16  = 0;   x16 =        0+nofs+12.5;

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
//     [x13,y13], 
//     [x14,y14],
//     [x15,y15],
     [x16,y16]
               ]);
  }
}

module total()
{
  shell();
}
total();
