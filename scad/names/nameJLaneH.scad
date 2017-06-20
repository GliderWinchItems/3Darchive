
$fn = 150;
include <../library_deh/deh_shapes.scad>

 module names()
 {
    translate([10, 37, - .01]) 
    {
       linear_extrude(7)
         text("JLH", font = "Liberation Sans");
    }
    
    translate([15, 0, .8]) 
    {
      linear_extrude(8)
        text("Jordan Lane Haselwood", font = "Ubuntu Condensed:style=Bold");
    }
}
/* ***** eyebar *****
 * rounded bar with hole in rounded end
d1 = outside diameter of rounded end, and width of bar
d2 = diameter of hole in end of bar

module eye_bar(d1, d2, len, ht)
*/

 difference()
 {
    union()
    {
       translate([0,5,0])
           eye_bar(20,8,140,6);
       translate([0,42,0])
          eye_bar(20,8,40,6);
    }
   
    names();
}
