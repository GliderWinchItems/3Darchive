/* pod-endbell-1
   POD endbell insert for POD #1
   03/03/2017
*/

dia_od = (106); // diameter (inside of bottle)

width_centerrim = 10;
width_centerbar = 14;


thick_bottom = 3;	// Bottom of endbell
thick_sides = 2.8;	// Sides
height_sides = 15;	// Height of sides
$fn = 20;

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
led_dia = 5.1;	// Dia of hole for LED
sw_dia = 6.0;	// Dia of hole for sw access
module ledsw_holes()
{
   translate([25,0,0])
      cylinder(d = led_dia, h = thick_bottom, center = false);
   translate([25,21.2,0])
        cylinder(d =  sw_dia, h = thick_bottom, center = false);
}
module rj_cutouts()
{
   // RJ45
   translate([-30,10,0])
      cube([15,15,thick_bottom+.01],center = false);
   // RJ 11
   rotate([0,0,0])
   translate([-30,-25,0])
      cube([15,12.25,thick_bottom],center = false);
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


module main()
{
   difference()
   {
      union()
      {
         base();
//	 side_holes();
      }
      union()
      {
         rotate([0,0,-25])
             ledsw_holes();
         rotate([0,0,0])    
	     rj_cutouts();
//	 side_holes();

      }
   }



   ring();
   
}
main();
