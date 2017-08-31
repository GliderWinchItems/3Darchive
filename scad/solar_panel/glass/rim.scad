/* scad/solar/panel/glass/rim.scad
 * Mounting rim for "those ancient" glass solar panels
 * Date of latest: 20170827
 */

include <../../library_deh/deh_shapes.scad>
include <gsolar_common.scad>


module rim()
{
   ir_ofs_z = (bs_ht - gs_thick);	
   difference()
   {
     translate([0,0,bs_ht/2])
       cube([bs_wid, bs_len, bs_ht], center=true);

     translate([-ir_wid/2,-ir_len/2,ir_ofs_z])
       cube([ir_wid,ir_len,ir_ht],center=false);
   }

}

module tab()
{
  ix = 50;
  for ( i = [-1 : 1 : 1])
  {
   translate([bs_wid/2+3,i*ix,0])
     rotate([0,0,180])
     eye_bar(12, 2.7, 5, bs_ht);
  }
}

module tabs()
{
   tab();

   translate([0,0,0])
     rotate([0,0,180])
       tab();

}

module cutout(rr)
{
   rounded_rectangle(rr,rr,10,6);
}

module cutouts()
{
   ir = 38;
   in = 1;
   ix = ir + 11;
   for ( i = [-in : 1 : in]  ) 
   {
       for ( j = [-1 : 1 : 1] )
       {
         translate([ i*ix, j*ix, 0])
           cutout(ir);
       }
   }
}

module wire_cutout()
{
   ofs_z = bs_ht - wr_dia;
   translate([bs_wid/2 - 1,-25,ofs_z])
     rotate([0,90,0])
       cylinder(d = wr_dia, h = 15, center = true);
    
   translate([bs_wid/2 - 6, -20,ofs_z+.9])
     rotate([100,0,0])
       cylinder(d = wr_bare+.5, h = 15, center = true);
    

}
module wire_cutouts()
{
    wire_cutout();
    
    translate([0,0,0])
     rotate([0,0,180])
      wire_cutout();
    
    
}

module total()
{
   difference()
   {
     union()    
     {
       rim();
       tabs();
     }
     union()
     {
       cutouts();
       wire_cutouts();
     }
   }
}

total();



