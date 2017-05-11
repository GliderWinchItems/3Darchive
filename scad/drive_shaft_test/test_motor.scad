/* Motor holder for drive shaft simulation test
*  File: test_motor.scad
 * Author: deh
 * Latest edit: 20170509
*/
include <../library_deh/deh_shapes.scad>

$fn = 100;



mt1x = mot_dia/2;		mt1y = 0;
mt2x = mot_dia/2 + mt_thick;	mt2y = 0;
mt3x = mot_dia/2 + mt_thick;	mt3y = mt_ht;
mt4x = mot_dia/2 + mt_thick - mt_chamfer; mt4y = mt_ht;
mt5x = mot_dia/2;		mt5y = mt_ht - mt_ch_ht;

module mot_tube()
{
   mt_of = 3;
   // Tube with cutout (since rotate angle doesn't work)
   difference()
   {
      rotate_extrude(angle = 340, convexity = 10) 
          polygon([[mt1x,mt1y],[mt2x,mt2y],
                   [mt3x,mt3y],[mt4x,mt4y],
                   [mt5x,mt5y] ]);
      translate([mot_dia/2 - .5,-mt_cutout/2,0])
          cube([mt_thick+.5,mt_cutout, mt_ht],false);
   }
   // bottom spacers
   difference()
   {
       cylinder(r = mt2x, h = mt_space_ht, center = false);
       union()
       {
          cylinder(r = mt1x - mt_of,h = mt_space_ht, center = false);
          translate([mot_dia/2 -5,-mt_cutout/2-10,0])
             cube([10,mt_cutout+200, mt_ht],false);

       }
   }

}
// Pot mount tab
module pot_mnt()
{
pot_dia = 6.7;	// Pot shaft dia
pot_wid = 4;	// Pot mount thickness
pot_ht = 20;	// Pot mount tab sq
pot_tb_h = 2.7; // Pot indexing tab height
pot_tb_x = 8.7; // Pot indexing tab c/l from shaft c/l
  {
   difference()
   {
      translate([0,0,0])
        cube([pot_ht,pot_wid,pot_ht]);
      union()
      {
         translate([pot_ht/2,0,pot_ht/2+pot_dia/2])
           rotate([-90,0,0])
             cylinder(d = pot_dia, h = pot_wid +2, center = false);
         translate([pot_ht/2 + pot_dia,0,pot_ht/2+pot_dia/2+pot_tb_h/2])
           rotate([-90,0,0])
             cube([1.5,pot_tb_h,pot_wid+2],false);          
      }
   }
  }
}



module base($fn=50)
{
    cube([base_x, base_y, base_thick]);
}

sh_dia = 3.3;	// Screw hole diameter
sh_ofs = 4;	// Offset from edge

module screw_holes()
{
  translate([sh_ofs,sh_ofs,0])
   cylinder(d = sh_dia, h = 10, center = false);

  translate([base_x - sh_ofs,sh_ofs,0])
   cylinder(d = sh_dia, h = 10, center = false);

  translate([sh_ofs,base_y - sh_ofs,0])
   cylinder(d = sh_dia, h = 10, center = false);

  translate([base_x - sh_ofs,base_y - sh_ofs,0])
   cylinder(d = sh_dia, h = 10, center = false);

}

module total()
{
   difference()
   {
     union()
     {
       base();  

       translate([base_y/2,base_y/2,base_thick])
         mot_tube();
     }
     union()
     {
        screw_holes();   
     }
   }
//   translate([50,0,base_thick])
//      pot_mnt();

}

total();
