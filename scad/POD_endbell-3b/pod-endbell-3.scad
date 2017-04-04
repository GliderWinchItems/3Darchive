/* pod-endbell-1
   POD endbell insert for POD #1
   03/05/2017
*/

$fn = 200;

include <../library_deh/deh_shapes.scad>

dia_od = (106); // diameter (inside of bottle)

width_centerrim = 10;
width_centerbar = 14;


thick_bottom = 5;	// Bottom of endbell
thick_sides = 2.8;	// Sides
height_sides = 15;	// Height of sides


module base()
{
//    difference()
    {
    cylinder(h = thick_bottom,
       d = (dia_od-2*thick_sides),
       center = false);
//    cylinder(h = thick_bottom,
//       d = (dia_od  - 2*thick_sides - 2* width_centerrim),
//       center = false);
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
module ring()
{
     // Sides
     translate([0,0,thick_bottom])
        difference()
        {  
           cylinder(h = height_sides, 
              d = (dia_od),
              center = false);
         union()
         {
           cylinder(h = height_sides, 
              d = (dia_od - 2* thick_sides),
              center = false);
 	   side_holes();
         }

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

module side_hole()
{
      translate([dia_od/2-thick_sides*2,0,height_sides/2])
      rotate([90,0,90])
        cylinder(d = 3.0, h = thick_sides*8, center = true);
}
module side_holes()
{
   for (a = [0:72:359])
   {
      rotate([0,0,a])
       translate([0,0,0])
         side_hole();
   }

}
/* Indexing plugs holes */
ip_dia = 15;
ip_depth = 3.5;
module ip_holes()
{
   translate([0,0,side_ht])
   {
	translate([25,-25,0])
	cylinder(d = ip_dia, h = ip_depth, center = false);
	translate([0,35,0])
	cylinder(d = ip_dia, h = ip_depth, center = false);

   }

}

module main()
{
   difference()
   {
      union()
      {
         base();
	 ridge();
         rotate([0,0,180-36])
           ridge();
         rotate([0,0,180+36])
           ridge();
      }
      union()
      {
           translate([10,-6,0])
             cylinder(d = 25, h = 40, center = false);
	   ip_holes();

      }
   }

   ring();
   
}
main();
