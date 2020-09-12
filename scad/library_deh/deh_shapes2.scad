/* **** deh_shapes2.scad *****
   * Library of useful shapes: chamfers
   * 20180126
*/
//include <../library_deh/deh_shapes.scad>

/* ***** chamfered_corner **********************
 * cx, cy form triangle for bottom chamfer
 * rad = z axis radius for corner
*/ 
module chamfered_corner(cx,cy,rad)
{
    rotate_extrude(angle=90)
        translate([rad,0,0])
            polygon(points=[[0,0],[0,cy],[cx,cy]]);    
}
/* ***** chamfered_rectangle *******************
 * wid  = width, x direction 
 * slen = length, y direction
 * cut  = x & y direction of chamfer
 * rad  = z axis, radius of corner rounding
*/
module chamfered_rectangle(wid,slen,cut,rad)
{
    ofs = cut+rad;
  hull()
  {  
    translate([-wid/2+ofs,ofs,0])
      rotate([0,0,180])
        chamfered_corner(cut,cut,rad);

    translate([ wid/2-ofs,ofs,0])
      rotate([0,0,-90])
        chamfered_corner(cut,cut,rad);

    translate([-wid/2+ofs,slen-ofs,0])
      rotate([0,0,90])
        chamfered_corner(cut,cut,rad);
    
    translate([ wid/2-ofs,slen-ofs,0])
      rotate([0,0,0])
        chamfered_corner(cut,cut,rad);
  } 
}
/* ***** rounded_rectangle_hull ********************
 * wid  = width, x direction 
 * slen = length, y direction
 * ht   = height (or thickness if you prefer)
 * cut  = x & y direction of chamfer
 * rad  = z axis, radius of corner rounding
*/
module rounded_rectangle_hull(wid,slen,ht,cut,rad)
{
 hull()
 {    
    translate([-wid/2+rad,rad,0])
        cylinder(r=rad,h=ht,center=false);

   translate([ wid/2-rad,rad,0])
        cylinder(r=rad,h=ht,center=false);

    translate([-wid/2+rad,slen-rad,0])
        cylinder(r=rad,h=ht,center=false);
    
    translate([ wid/2-rad,slen-rad,0])
        cylinder(r=rad,h=ht,center=false);
 }
}
module half_rounded_rectangle_hull(wid,slen,ht,cut,rad)
{
    ofs= rad;
 hull()
 {    
    translate([-wid/2+ofs,ofs,0])
        cylinder(r=ofs,h=ht,center=false);

    translate([ wid/2-ofs,ofs,0])
        cylinder(r=ofs,h=ht,center=false);

    translate([-wid/2+0.05,slen-0.05,0])
        cylinder(r=0.05,h=ht,center=false);
    
    translate([ wid/2-0.05,slen-0.05,0])
        cylinder(r=0.05,h=ht,center=false);
 }
}

/* ***** composite_chamfered_rectangle **************
 * wid  = width, x direction 
 * slen = length, y direction
 * ht   = height (or thickness if you prefer)
 * cut  = x & y direction of chamfer
 * rad  = z axis, radius of corner rounding less cut
 * NOTE: this places a rounded rectangular cube on top
 *   of a rounded rectangle with a bottom chamfer,
 *   i.e. this is a "base" for a Plano box.
*/
module composite_chamfered_rectangle(wid,slen,ht,cut,rad)
{
echo("composite_chamfered_rectangle","cut",cut,"ht",ht,"rad",rad);    
    chamfered_rectangle(wid,slen,cut,rad);

    translate([0,0,cut])
        rounded_rectangle_hull(wid,slen,ht-cut,cut,rad+cut);
}
//composite_chamfered_rectangle(66,86,5,4,3); // test this module

/* ***** dual_fillet ******************************
 * d  = distance between inside of wedges (x)
 * l  = length (z)
 * w  = width of fillet (x)
 * h  = height of fillet (y)
 */
module dual_fillet(d,l,w,h)
{
	q = d/2;
	  linear_extrude(height = l)
  polygon(points = [[-q,0],[-q,-h],[-q-w,0]]);

	  linear_extrude(height = l)
  polygon(points = [[q,0],[q,-h],[q+w,0]]);
}
/* ***** chamfered_rounded_slot(d,l,t,w,h)
 * d = diameter of rounded end and width of slot (x)
 * l = length (z)
 * t = depth of slot (y) from top to bottom center of circle
 * w = width of fillet at top (x)
 * h = height of fillet (y)
*/
module chamfered_rounded_slot(d,l,t,w,h)
{
	dual_fillet(d,l,w,h);

	    // Rounded end
	translate([0,-t,0])
    cylinder(d = d, h = l, center = false, $fn = 50);

    // Bar
    translate([-d/2, -t, 0])
       cube([d, t, l],false);
}
//chamfered_rounded_slot(4,10,5,1,2); // test
