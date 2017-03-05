/* pod-bottle_insert1.scad
   POD GPS puck insert for POD #1
   03/04/2017
*/

$fn = 200;

bot_dia = 105;


// Contour
ofs = 4.9;

x0 = 0;		y0 = 0;
x1 = 0;		y1 = 2.6+ofs;
x2 = 5;		y2 = 2.35+ofs;
x3 = 10;	y3 = 2.05+ofs;
x4 = 15;	y4 = 1.60+ofs;
x5 = 20;	y5 = 1.05+ofs;
x6 = 25;	y6 = 0.40+ofs;
x7 = 30.3;	y7 = 0+ofs;
x8 = 30.3;	y8 = 0;


module puck_dome()
{
  rotate_extrude(angle=360)
  {
   polygon(points = [
     [x0,y0],
     [x1,y1], 
     [x2,y2], 
     [x3,y3], 
     [x4,y4],
     [x5,y5], 
     [x6,y6], 
     [x7,y7], 
     [x8,y8]
               ]);
  }
}
ptop_ht = 8.8;
p_dia = 61;
module puck()
{
   translate([0,0,ptop_ht]) puck_dome();
   cylinder(d = p_dia, h = ptop_ht+.01, center = false);
}

base_ht = 19;
module base_ring()
{
   cylinder(d = bot_dia, h = base_ht, center = false);
}

module puck_wire()
{
  translate([26,-20,0])
   cube([15, 40, 8], center = false); 

}
module puck_cable()
{
   difference()
   {
      cylinder(d = bot_dia-8, h = ptop_ht+.01, center = false);
      cylinder(d = p_dia+4, h = ptop_ht+.01, center = false);
   }
}

module total()
{
  difference()
  {
     base_ring();
     union()
     {
        translate([0,0,-.01]) puck();
        puck_wire();
        translate([0,0,-.01]) puck_cable();
     }
  }

}
total();
