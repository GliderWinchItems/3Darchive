/* cableplug.scad
   POD #3 plug for load-cell cable strain relief
   04/08/2017
*/

$fn = 50;

include <../library_deh/deh_shapes.scad>

/* Plug goes in bottom of pod2_tronics.scad */
pg_wid = 21.5;	
pg_len = 19.5;
pg_depth = 23;

module plug()
{
  cube([pg_wid, pg_len, pg_depth], center = false);
}

/* Cutout in plug for capturing cable */
cc_dia = 5.5;	// Cable diameter

module cable_cutout()
{
  translate([2,4,-.5])
    rotate([-22,0,0])
      rotate([0,0,180])
        rounded_bar(cc_dia,17,40);
  

}

module total()
{
   difference()
   {
      plug();

      cable_cutout();

   }

  
}


total();
