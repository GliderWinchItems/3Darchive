/* POD endbell
*/

dia_od = (105); // diameter (inside of bottle)

width_centerrim = 10;
width_centerbar = 14;


thick_bottom = 3;
thick_sides = 2.8;
height_sides = 10;
$fn = 100;

module base()
{
    render()
    {
    difference()
    {
    cylinder(h = thick_bottom,
       d = (dia_od-2*thick_sides),
       center = false);
    cylinder(h = thick_bottom,
       d = (dia_od  - 2*thick_sides - 2* width_centerrim),
       center = false);
    }
}
}

module chamfer()
{
     // Sides with chamfer at bottom edge
    difference()
     {
        cylinder(h = thick_bottom, 
           r1 = (dia_od - thick_sides)/2, 
           r2 = dia_od/2, 
           center = false);
        cylinder(h = thick_bottom, 
           d = (dia_od - 2*thick_sides), 
           center = false);
     }
 }

/* ridge for a grip point for removing endbell */
rid_wid = 5;
rid_len = 15;
rid_thick = 3;

module ridge()
{
//   translate([0,0,height_sides])
//     cube([rid_wid,rid_len,rid_thick],center = false);   
  difference()
  {
   translate([0,0,height_sides]) 
     cylinder(d = dia_od, h = rid_thick, center = false);
   translate([-dia_od/2+8,-dia_od/2,height_sides]) 
     cube([dia_od,dia_od,rid_thick], center = false);
  }
}

module ring()
{
     // Sides
     translate([0,0,thick_bottom])
        difference()
        {  
           cylinder(h = height_sides, 
              d = (dia_od),
              center = false);
           cylinder(h = height_sides, 
              d = (dia_od - 2* thick_sides),
              center = false);
        }
     
    chamfer();
     
     // Inside fillet
     difference()
     {
        translate([0,0,thick_bottom])
           cylinder(h = thick_bottom,
              d = (dia_od - 2*thick_sides),
              center = false);
        translate([0,0,thick_bottom])
          cylinder(h = thick_bottom, 
              r1 = (dia_od - 4*thick_sides)/2, 
              r2 = (dia_od - 2*thick_sides)/2, 
              center = false);
     }
}
module crossbar()
{
    render()
    {
       difference()
       {
          // Cross bar at base
         translate([-(dia_od - 2*thick_sides)/2,-width_centerbar/2,0])
            cube([dia_od - 2*thick_sides,width_centerbar,thick_bottom],false);    
         chamfer();
       }
    }
}

module main()
{
    base();
   ring();
   crossbar();
 
}
main();
