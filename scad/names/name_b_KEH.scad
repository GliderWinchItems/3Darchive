

include <../library_deh/deh_shapes.scad>

 
 translate([10, 38, 3]) {
  linear_extrude(5)
   text("KEH", font = "Liberation Sans");
 }
 


 translate([15, 0, 2-.01]) {
  linear_extrude(5)
   text("Kendall Errin Haselwood", font = "Ubuntu Condensed:style=Bold");
 }
 
/* ***** eyebar *****
 * rounded bar with hole in rounded end
d1 = outside diameter of rounded end, and width of bar
d2 = diameter of hole in end of bar

module eye_bar(d1, d2, len, ht)
*/
  translate([0,5,0])
   eye_bar(20,8,140,3);

  translate([0,42,0])
   eye_bar(20,8,40,3);
