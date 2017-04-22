/* File: cwH_spacer.scad
 * Spacers for shimming mounting
 * Reflective photosensors version, (H = horizontal over top)
 * Author: deh
 * Latest edit: 20170421
 */

include <cwH_common.scad>

 $fn=50;

screw_dia = 3.6;

module spacer(ht,txt)
{
  difference()
  {
   union()
   {
     cylinder(d = sp_dia, h = ht, center = false);
   }
   union()
   {
     cylinder(d= screw_dia, h = ht, center = false);

     translate([sp_dia/4 - 1,-2, ht - .5])
       linear_extrude(ht)
         text(txt, size = 4, font = "Ubuntu Condensed:style=Bold");
       
   }
  }
/*
  translate([sp_dia/2 - 1, 0,0])
     cube ([6,.5,.5],center = false);

  translate([0, sp_dia/2 - 1, 0])
     cube ([.5,6,.5],center = false);
*/
}

ss_ofs = sp_dia + 2;

module spacers(ht,txt)
{
   translate([ss_ofs * 0, 0,0])
     spacer(ht,txt);

   translate([ss_ofs * 1, 0,0])
     spacer(ht,txt);

   translate([ss_ofs * 2, 0,0])
     spacer(ht,txt);
/*
   translate([ss_ofs * 2.5, 0,0])
     linear_extrude(ht)
        text(txt, size = 4, font = "Ubuntu Condensed:style=Bold");
*/
   
}

module total()
{
   spacers(1,"1");
 translate([0,(sp_dia+1)*1,0])
   spacers(2,"2");
 translate([0,(sp_dia+1)*2,0])
   spacers(3,"3");
 translate([0,(sp_dia+1)*3,0])
   spacers(5,"5");
 translate([0,(sp_dia+1)*4,0])
   spacers(8,"8");

}
total();
