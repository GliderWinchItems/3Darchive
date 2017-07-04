/* File: carrier.scad
 * Plano box with Discovery F4: carrier above iso board
 * Author: deh
 * Latest edit: 201700703
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
     translate([-dis_wid/2-ofs, sid_rail_y, 0])
       dis_post();
     
     translate([dis_wid/2-dis_post_y+ofs, sid_rail_y, 0])
       dis_post();

     translate([-dis_wid/2-ofs, ee, 0])
       dis_post();

     translate([dis_wid/2-dis_post_y+ofs, ee, 0])
       dis_post();
 }
 
module t_bar(len, wid, ht, thick)
 {
     cube([len,wid,thick],false);
     
//     translate([0,wid/2 - thick/2,thick - .01])
//       cube([len,thick,ht],false);
 }
tbr_len = 32;
tbr_ht = 5;
tbr_wid = dis_post_y;
 module t_bars()
 {
     translate([dis_wid/2+ofs,ee-.01,0])
       rotate([0,0,90])
         t_bar ( tbr_len+.02, tbr_wid, tbr_ht,  dis_post_ht);
      
     translate([-dis_wid/2-ofs+tbr_wid,ee-.01,0])
       rotate([0,0,90])
         t_bar ( tbr_len+.02, tbr_wid, tbr_ht,  dis_post_ht);

     translate([-dis_wid/2+tbr_wid/2,20,0])
       cube([dis_wid-tbr_wid, 34, dis_post_ht],false);

     translate([-dis_wid/2-tbr_wid/2+ofs/2, 54, 0])
       cube([dis_wid+tbr_wid/2+ofs/2, 2, dis_post_ht],false);

 }
usb_wid = 14;	// Width of usb cutout
usb_len = 15;	// Length of usb cutout

module usb_cutout()
{
   translate([-usb_wid/2,45,0])
     cube([usb_wid,usb_len, 8],false);

}

rj_post_dia = 2.3; // Mounting post diameter
rj_wid = 11.6;	   // Distance between mounting posts
rj_ofs = 2.6;	   // offset for square cutout
rj_sq = 6.5;	   // cutout for wires
rj_ov_len = 12.4;
rj_ov_wid = 13;

module rj11_cutout()
{
   // Cutouts for mounting post holes
   translate([0,0,0])
     cylinder(d = rj_post_dia, h = dis_post_ht+.02, center = false);

   translate([rj_wid,0,0])
     cylinder(d = rj_post_dia, h = dis_post_ht+.02, center = false);

   // Cutout for wires to jack pins
   translate([rj_ofs, 0, 0])
    cube([rj_sq, rj_sq, dis_post_ht],false);

   // Recess for RJ11 body
   translate([-.3,-rj_ov_len/2,1.5])
    cube([rj_ov_len,rj_ov_wid,10],false);
}
module rj11_cutouts()
{
  translate([-22,35,0])
    rj11_cutout();

  translate([22 - rj_wid,35,0])
    rj11_cutout();

}

hdr_spc = (9*0.1*25.4);	// Space between holes in header brd
hdr_wid = 3;
hdr_len = 17;

module header_carrier()
{
   cylinder(d = screw_dia_s440_z, h = dis_post_ht, center = false);

   translate([hdr_spc, 0,0])
      cylinder(d = screw_dia_s440_z, h = dis_post_ht, center = false);

hdr_x = hdr_spc/2 - hdr_len/2;
   translate([hdr_x, -hdr_wid/2, 0])
      cube([hdr_len,hdr_wid,dis_post_ht],false);
}

hdr_ofs_x = -dis_wid/2-ofs+tbr_wid;

module header_carriers()
{
   translate([hdr_ofs_x-tbr_wid/2,20,0])
    rotate([0,0,90])
     header_carrier();
}
sc_dia = 4;	// Diameter for strain relief hole
module strain_cutout()
{
   cylinder(d = sc_dia, h = dis_post_ht+.01, center = false);

   translate([sc_dia+1, 0, 0])
     cylinder(d = sc_dia, h = dis_post_ht+.01, center = false);


}
module strain_cutouts()
{
   translate([14,48,0])
     strain_cutout();

   translate([-14-(sc_dia+1),48,0])
     strain_cutout();

   translate([-19-(sc_dia+1),44,0])
     rotate([0,0,90])
       strain_cutout();
}

module base()
{
   difference()
    {
        union()
        {
            pod_4posts();
            t_bars();            
        }
        union()
        {
            usb_cutout();
            rj11_cutouts();
            header_carriers();
            strain_cutouts();
        }
    }
}
base();
