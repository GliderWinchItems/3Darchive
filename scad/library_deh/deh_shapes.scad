/* **** deh_shapes.scad *****
   * Library of useful shapes
   * 20170512
*/


/*  ***** tubedeh *****
d1 = outside diameter
d2 = inside diameter
ht = height
reference is center of tube, bottom
*/
module tubedeh(d1,d2,ht)
{
   difference()
   {
     cylinder(d = d1, h = ht, center = false);
     cylinder(d = d2, h = ht + .001, center = false);
   }
}
/* ***** rounded_bar *****
 * rectangular bar with rounded end
bar with one end rounded
rounded_bar(d, l, h)
d = diameter of rounded end, and width of bar
l = length of bar from center of rounded end to end
h = thickness (height) of bar
reference is center of rounded end, bottom
*/
module rounded_bar(d, l, h)
{
    // Rounded end
    cylinder(d = d, h = h, center = false);
    // Bar
    translate([0, -d/2, 0])
       cube([l, d, h],false);
}
/* ***** eyebar *****
 * rounded bar with hole in rounded end
d1 = outside diameter of rounded end, and width of bar
d2 = diameter of hole in end of bar
*/
module eye_bar(d1, d2, len, ht)
{
   difference()
   {   
      rounded_bar(d1,len,ht);
      cylinder(d = d2, h = ht + .001, center = false);
   }
}
/* ***** rounded_rectangle ******
rounded_rectangle(l,w,h,rad);
l = length (x direction)
w = width (y direction)
h = thickness (z direction)
rad = radius of corners
reference = center of rectangle x,y, bottom
*/
module rounded_rectangle(l,w,h,rad)
{
  translate([-(l-rad)/2,-(w-rad)/2,0])
  {
    // Four rounded edges
    translate([0,0,0])
      rounded_bar(rad*2,l-rad,h);
    translate([l-rad,0,0])
      rotate([0,0,90])
      rounded_bar(rad*2,w-rad,h);
    translate([l-rad,w-rad,0])
      rotate([0,0,180])
      rounded_bar(rad*2,l-rad,h);
    translate([0,w-rad,0])
      rotate([0,0,-90])
      rounded_bar(rad*2,w-rad,h);
    // Fill in center
    translate([0,0,0])
      cube([l-rad + .01,w-rad + .01,h],false);
  }
}

/* ***** rounded rim *****
module rounded_rim(l,w,h,rad,tk);
l = length (inside, x direction)
w = width (inside, y direction)
h = thickness (z direction)
rad = radius of corners
tk = thickness of rim wall
*/
module rounded_rim(l,w,h,rad,tk)
{
  difference()
  {
    rounded_rectangle(l+2*tk,w+2*tk,h,rad);
    rounded_rectangle(l, w, h, rad);
  }
}

/* ***** wedge *****
l = length
w = width
h = height/thickness
*/
 module wedge(l, w, h)
 {
   polyhedron(
      points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
       faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]] );
 }
/* ***** rounded_triangle *****
 * l1 = side 1
 * l2 = side 2
 * l3 = side 3
 * h  = height/thickness
 * rad = radius of rounded corners
 */
module rounded_triangle(l1,l2,l3,h,rad)
{
  // Compute rotation angles
  al3 = acos((l1*l1 + l2*l2 - l3*l3)/(2 * l1 * l2));
  al1 = acos((l2*l2 + l3*l3 - l1*l1)/(2 * l2 * l3));
  al2 = acos((l3*l3 + l1*l1 - l2*l2)/(2 * l3 * l1));
  // Setup bars for edges
  translate([0,0,0])
    rotate([0,0,0])
      rounded_bar(rad,l3,h);
  translate([l3,0,0])
    rotate([0,0,180-al2])
      rounded_bar(rad,l1,h);
  rotate([0,0,al1])
    translate([l2,0,0])
      rotate([0,0,180])
        rounded_bar(rad,l2,h);
  // Fill in center
    triangle(l1,l2,l3,h);
}
/* ***** triangle *****
 * l1 = side 1
 * l2 = side 2
 * l3 = side 3
 * h  = height/thickness
 */
module triangle(l1,l2,l3,h)
{
  // Compute rotation angle
  al1 = acos((l2*l2 + l3*l3 - l1*l1)/(2 * l2 * l3));
  
  linear_extrude(height = h)
  polygon(points = [[0,0],[l3,0],[l2*cos(al1),l2*sin(al1)]]);
}
/* ***** chamfered hole *****
 * Punch hole with chamfer on one end
 * d1 = main hole diameter
 * d2 = hole diameter at chamfered end
 * ht1 = height of whole hole
 * ht2 = depth of  chamfer
*/
module chamfered_hole(d1,d2,ht1,ht2)
{
   rotate_extrude(convexity = 10)
     polygon(points = [[0,0],[d1/2,0],[d1/2,ht1-ht2],[d2/2,ht1],[0,ht1]]);

}

/* ***** fillet *****
 * r = radius of fillet
 * l = length of fillet
 fillet (r,l);
*/
module fillet(r,l)
{
   difference()
   {
     union()
     {
       cube([2*r,2*r,l]);
     }
     union()
     {
       translate ([r,r,0])
           cylinder(d = 2*r + 0.1, h = l, center = false);
       translate([r,0,0])
           cube([r,2*r,l],center = false);
       translate([0,r,0])
           cube([2*r,r,l],center = false);
     }
   }
}
/* ***** circular chamfer *****
 * d = outer diameter
 * rad = chamfer radius
 * circular_chamfer(d, rad);
*/
module circular_chamfer(d, rad)
{
  ofs = (d/2 - rad);
  rotate_extrude()
  translate([ofs,0])
   difference()
   {
     union()
     {
       square(size = [rad, rad]);
     }
     union()
     {
       translate ([0,rad ])
           circle(d = 2*rad + 0.1);
     }
   }
}
module circular_inner_chamfer(d, rad)
{
  circular_chamfer(d, rad);
} 

/* ***** circular chamfer *****
 * d = inner diameter
 * rad = chamfer radius
 * circular_chamfer(d, rad);
*/
module circular_outer_chamfer(d, rad)
{
  ofs = (d/2 - rad);
  rotate_extrude()
  translate([ofs,0])
   difference()
   {
     union()
     {
       square(size = [rad, rad]);
     }
     union()
     {
       translate ([rad,rad ])
           circle(d = 2*rad + 0.1);
     }
   }
}
