/* Washers for holding board edges
 * File: washers.scad
 * Author: deh
 * Latest edit: 201701291315
*/

$fn = 50;

screw_dia = 2.78;	// Dia of threads
screw_dia_head = 4.8;	// Dia of screw (pan) head
washer_thick = 1.75;
washer_dia = 6;

module washer(od,id,ht)
{
   difference()
   {
      cylinder(d = od, h = ht, center = false);
      cylinder(d = id, h = ht, center = false);
   }

}

module washer_sq(len,wid,ht,id)
{
ofs_x = screw_dia_head;
ofs_y = 2;
   difference()
   {
      cube([len,wid,ht],false);
      union()
      {
         translate([ofs_x, ofs_y,-.001])
            cylinder(d = id, h = ht + .002);
     
      }
   }
}

module round()
{
   for(x1 = [0:1:1],y1 = [0:1:1])
      translate([x1 * (washer_dia + 1), 
                y1 * (washer_dia + 1),
                 0])
         washer(washer_dia, screw_dia, washer_thick);

}

rect_len = 8;
rect_wid = 5;

module rectangle()
{
   for(x1 = [0:1:1],y1 = [0:1:1])
      translate([x1 * (rect_len + 1), 
                y1 * (rect_wid + 1),
                 0])
         washer_sq(rect_len,rect_wid,washer_thick,screw_dia);

}

module total()
{
   translate([0, 2 * (washer_dia + 2),0])
      round();
   rectangle();

//washer_sq(8,4,washer_thick);

}

total();
