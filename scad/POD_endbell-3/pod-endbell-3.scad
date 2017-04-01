/* pod-endbell-1
   POD endbell insert for POD #1
   03/05/2017
*/

$fn = 200;

include <../library_deh/deh_shapes.scad>

dia_od = (106); // diameter (inside of bottle)

width_centerrim = 10;
width_centerbar = 14;


thick_bottom = 3;	// Bottom of endbell
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


led_dia = 5.1;	// Dia of hole for LED
sw_dia = 6.0;	// Dia of hole for sw access
module ledsw_holes()
{
   translate([25,0,0])
      cylinder(d = led_dia, h = thick_bottom, center = false);
   translate([25,21.2,0])
        cylinder(d =  sw_dia, h = thick_bottom, center = false);

   // Cutout for that little epoxied subboard 
   translate([18,-2,0])
     rotate([0,0,-15])
      cube([17,13, thick_bottom+.02],center = false);    

   // Cutout for that little epoxied subboard 
   translate([27,18,0])
     rotate([0,0,75])
      cube([20.5,9, thick_bottom+.02],center = false);      
  

}
// Odd shaped cutout for perf board that carries LED and sw
ledsw_screw_dia = 3;
ax1 = -15.8;	ay1 =    0;
ax2 = -13.5;	ay2 = 19.2;
ax3 =  -6.4;	ay3 = 20.9;
ax4 =  -4.5;	ay4 = 20.0;
ax5 =  -4.5;	ay5 =  3.0;
ax6 =  -6.9;	ay6 = -0.5;
ax7 =  -9.6;	ay7 = -4.0;
ax8 = -14.2;	ay8 = -4.0;

bx1 = -5.8;	by1 = -16.0;
bx2 = -6.0;	by2 =  -7.0;
bx3 = -2.9;	by3 =  -7.0;
bx4 =  4.0;	by4 = -10.2;
bx5 =  5.0;	by5 = -12.5;
bx6 =  4.2;	by6 = -19.8;
bx7 =    0;	by7 = -20.8;
bx8 = -3.9;	by8 = -20.0;

module ledsw_cutout()
{
 linear_extrude(thick_bottom+.02)
 {
    union()
    {
     polygon(points = [
     [ax1,ay1], 
     [ax2,ay2], 
     [ax3,ay3], 
     [ax4,ay4],
     [ax5,ay5], 
     [ax6,ay6], 
     [ax7,ay7], 
     [ax8,ay8], ] );
  
     polygon(points = [
     [bx1,by1], 
     [bx2,by2], 
     [bx3,by3], 
     [bx4,by4],
     [bx5,by5], 
     [bx6,by6], 
     [bx7,by7], 
     [bx8,by8], ] );
   }
  }
   cylinder(d = ledsw_screw_dia, h = thick_bottom+.02,center=false);
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
module pull_post()
{
   cylinder(d = 7, h = height_sides , center = false);
   translate([0,0,3+thick_bottom ])
     cylinder(d1 = 7, d2 = 12, h = 10 , center = false);


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
         pull_post();
      }
      union()
      {
         rotate([0,0,-10])
//             ledsw_holes();
           translate([30,10,-.01])
             ledsw_cutout();
         rotate([0,0,0])    
	     rj_cutouts();
      }
   }

   ring();
   
}
main();
