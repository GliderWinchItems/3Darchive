/* Code wheel: outer wheel w segments
 * Date: 20170414
 * cw_outer.scad
 */
 
include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>

 $fn = 200; // Quantization

 
 thick_center_hole = (4.0); // Thickness at center hole
 

 thick_1st_step = (2.4); // 
 dia_1st_step = (60.5);
 
 thick_seg = (1.5);   // Thickness at segments
 dia_seg = (50);    // Outer dia of segments
 dia_overall = (dia_seg + 3);
 thick_rim = (thick_seg + 1); // Rim slightly thicker
 
 timingHoles = 10;
 encoderDiameter = 40;
 
 outer_rim_dia = 80;  
 thick_outer_rim = thick_seg;
 width_outer_rim = 2.5;
 len_outer = 30;
 


module center_hole()
{
    cylinder(h = thick_center_hole, d = mag20_stud_dia, center = false);
}

module center_post()
{
    cylinder(h = thick_center_hole, d = mag20_shell_dia, center = false);
}

module first_step()
{ 
        cylinder(h = thick_1st_step, d = outer_rim_dia, center = false);
}

module outer_rim()
{   
    difference() 
    {
        cylinder(h = thick_outer_rim, d = outer_rim_dia, center = false);
        cylinder(h = thick_outer_rim, d = outer_rim_dia - width_outer_rim, center = false);
    }
}
co_bot_rim_ht = 1;	// Height of bottom edge of segments
co_rad = 3;	// radius of cutout corners
co_ht = len_outer - co_bot_rim_ht - thick_1st_step;

module cutout()
{
   co_ofs_x = outer_rim_dia/2 - width_outer_rim - 5;
   co_ofs_y = thick_1st_step+co_ht/2 -1 ;
   translate([co_ofs_x,0,co_ofs_y])
     rotate([90,0,90])
      rounded_rectangle(10,co_ht,10,co_rad);
//     cube([10,10,co_ht], center=false);
}

module manycuts()
{
      for (a = [0:30:359])
      {
// echo (a);
        rotate([0,0,a])
         cutout();
      }
}

module cup_side()
{
  cs_ofs_z =  outer_rim_dia - width_outer_rim - thick_1st_step;
  difference()
  {
    tubedeh(outer_rim_dia,cs_ofs_z,len_outer);
    manycuts();
  }

}

module main()
{
    difference()
    {
        union()
        {
            first_step();
	    cup_side();
        }
        union()
        {
           center_hole();
        }
    }
}
main();
