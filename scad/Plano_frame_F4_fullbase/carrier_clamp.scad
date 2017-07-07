/* File: carrier_clamp.scad
 * Plano box with Discovery F4: carrier clamp above carrier
 * Author: deh
 * Latest edit: 201700705
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>

jj = 0.5;	// Minor y direction adjustment
sid_wid = 2.5;  // Width of side rails
sid_len = 15;   // Length of side rails
sid_rail_y  = pc_y - pod_post_q - dis_len - jj;
sid_rail_y2 = pc_y - pod_post_q - dis_len + 65 - jj;

dis_post_y = 10;
dis_post_ht = 3;

     ofs = 3;

 $fn=100;


module clamp(len)
{
   c_ht1 = 5.5;//3;
   c_w1 = 3;
   c_w2 = 7;
   c_z2 = 0 + c_ht1;
   c_y = -c_w1;

   translate([0,-c_w1,0])
     cube([len,c_w1,c_ht1-.01],false);

   // Overhang
   translate([0,c_y,c_z2-.02])
     cube([len,c_w2,3],false);

}
module clamps()
{
  len = 5;
  ofs = -1;
  translate([-15,ofs,dis_post_ht])
   clamp(len);
   
  translate([ 15-len,ofs,dis_post_ht])
   clamp(len);

}

 module dis_post()
 {
    difference()
     {
       union()
       {
         translate([ 0,-dis_post_y,  0])
            cube([dis_post_y, dis_post_y, dis_post_ht],false);
       }
       union()
       {
            translate([dis_post_y/2, -dis_post_y/2, -.01])
                cylinder(h = dis_post_ht+.01, d = screw_dia_s440, center = false);
       }
       
     }      
 }
ee = 15;     

module pod_4posts()
 {
     ofs = 3;
     translate([-dis_wid/2-ofs, 0, 0])
       dis_post();
     
     translate([dis_wid/2-dis_post_y+ofs, 0, 0])
       dis_post();

 }
 
tbr_len = 32;
tbr_ht = 5;
tbr_wid = 5;
 module c_bar()
 {
     translate([-dis_wid/2+ofs+1.5,-tbr_wid,0])
       cube([dis_wid - dis_post_y-1,tbr_wid, dis_post_ht],false);
      
 }

module base()
{
   difference()
    {
        union()
        {
            pod_4posts();
            c_bar(); 
            clamps();           
        }
        union()
        {
        }
    }
}
base();
