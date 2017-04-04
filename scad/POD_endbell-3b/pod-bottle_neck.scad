/* pod-bottle_neck.scad
   POD neck insert for POD #1
   03/04/2017
*/

$fn = 200;

bot_dia = 105;


// Contour
nofs = bot_dia/2 - 45;
lofs = 5;

//y1   = 0;   x1  = 	45.0+nofs;
y2   = 5-lofs;   x2  = 	44.0+nofs;
y3   = 10-lofs;   x3  = 	43.0+nofs;
y4   = 15-lofs;   x4  = 	41.3+nofs;
y5   = 20-lofs;   x5  = 	39.3+nofs;
y6   = 25-lofs;   x6  = 	36.7+nofs;
y7   = 30-lofs;   x7  = 	34.1+nofs;
y8   = 35-lofs;   x8  = 	30.5+nofs;
y9   = 40-lofs;   x9  = 	27.0+nofs;
y10  = 45-lofs;   x10 = 	22.7+nofs;
y11  = 50-lofs;  x11 = 	18.3+nofs;
y12  = 55-lofs;  x12 = 	12.5+nofs;
//y13  = 60;  x13 = 	6.0+nofs;
//y14  = 65;  x14 = 	1.8+nofs;
//y15  = 65;  x15 =        0+nofs;
y16  = 0;   x16 =        0+nofs+12.5;

module shell()
{
  rotate_extrude(angle=360)
  {
   polygon(points = [
//     [x1,y1], 
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

/* Hole in bottom for load-cell cable */
pc_wid = 77;	// Width of PC board
pc_ofs_y = -15;
cable_lc_dia = 16; // Load-cell cable (at connector)

module cable_lc_cutout()
{
   translate([pc_wid/2-5,pc_ofs_y+cable_lc_dia/2-.5,0])
     cylinder(d = cable_lc_dia, h = 150, center = false);
}
gps_dia2 = 70;  	// Dia for gps well
gps_dia1 = 80;  	// Dia for gps well
gps_thick = 28; // Depth of gps well
module gps_cutout()
{
   translate([0,0,0])
     cylinder(d1 = gps_dia1,d2 = gps_dia2, h = gps_thick, center=false);
}

module total()
{
  difference()
  {
     shell();
     union()
     {
        cable_lc_cutout();
        gps_cutout();
     }
  }
}
total();
