/* shaft.scad
 * Coupling for motor to drive shaft
 * Date: 20170728
 * #### Be sure to use latest openscad! ####
 * #### or rotate_extrude will not work ####
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/mag_mount.scad>

$fn = 50;

cp_ht = 9;
cp_id = 2.9;
cp_od = 6;
cp_ht2 = 8;
cp_od2 = 4.6;

module splinetooth(ofs_x)
{
   sp_1 = .5; sp_2 = 1;
   az = atan( (sp_1/2)/sp_2 );
   ax = ofs_x - 1;
   translate([ax,0,0])
     rotate([0,0,-az])
        triangle(sp_1,sp_2,sp_2,cp_ht);
}

module splineteeth(x)
{
  nteeth = 6;
  step = 180/nteeth;
      for (i = [step/2 : 2*step : (360 - .01)])
      {
        rotate([0,0,i])
          splinetooth(x);   
      }  
}

module part()
{
    translate([0,0,cp_ht-.01])
    	cylinder(d=cp_od2,h=cp_ht2,center=false);
    
    translate([0,0,cp_ht-.01])
    	cylinder( d2=cp_od2, d1=cp_od, h=2, center=false);
    
      
	tubedeh(cp_od,cp_id,cp_ht);
    
    

}
part();
