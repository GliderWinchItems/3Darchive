/* scad/solar/panel/glass/lid.scad
 * Top lid for "those ancient" glass solar panels
 * Date of latest: 20170828
 */

include <../../library_deh/deh_shapes.scad>
include <gsolar_common.scad>


module rim()
{
     translate([0,0,bs_ht/2])
       cube([bs_wid, bs_len, bs_ht], center=true);

}

module tab()
{
  ix = 50;
  for ( i = [-1 : 1 : 1])
  {
   translate([bs_wid/2+3,i*ix,0])
     rotate([0,0,180])
     eye_bar(12, 3.3, 5, bs_ht);
  }
}

module tabs()
{
   tab();

   translate([0,0,0])
     rotate([0,0,180])
       tab();

}

module cutout()
{
   rr = 0;
   translate([0,0,-.1])
     rounded_rectangle(ir_wid+rr,ir_len+rr,10,2);
}
module side_wedge()
{
   translate([-ir_wid/2+bs_edge-1.2,-(ir_wid+2)/2,0])
    rotate([0,0,90])
      wedge(ir_wid+2,bs_edge,bs_ht);    
    
}

module side_wedges()
{
  side_wedge();
    
  rotate([0,0,180])
    side_wedge();
    
  rotate([0,0,90])
    side_wedge();
    
  rotate([0,0,-90])
    side_wedge();


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
       cutout();
     }
   }
   side_wedges();

}

total();



