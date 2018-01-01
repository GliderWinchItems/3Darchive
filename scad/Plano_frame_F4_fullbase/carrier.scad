/* File: carrier.scad
 * Plano box with Discovery F4: carrier above iso board
 * Author: deh
 * Latest edit: 201700703
 * V1 - 2017 12 22 Reversed RJ11, angled w slot for wires
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

 $fn=50;

// **** Id the part ***
module id()
{
 {
  font = "Liberation Sans:style=Bold Italic";
 translate([-32,38, dis_post_ht]) 
  linear_extrude(1)
   text("V 1",size = 3);
 }
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
     // Side bars
     translate([dis_wid/2+ofs,ee-.01,0])
       rotate([0,0,90])
         t_bar ( tbr_len+.02, tbr_wid, tbr_ht,  dis_post_ht);
      
     translate([-dis_wid/2-ofs+tbr_wid,ee-.01,0])
       rotate([0,0,90])
         t_bar ( tbr_len+.02, tbr_wid, tbr_ht,  dis_post_ht);

     translate([-dis_wid/2+tbr_wid/2,10,0])
       cube([dis_wid-tbr_wid, 44, dis_post_ht],false);

     // Lip over Discovery board
     translate([-dis_wid/2-tbr_wid/2+ofs/2, 54, 0])
       cube([dis_wid+tbr_wid/2+ofs/2, 2, dis_post_ht],false);

 }
usb_wid = 14;	// Width of usb cutout
usb_len = 15;	// Length of usb cutout

/* Discovery board USB jack cutout */
module usb_cutout()
{
   translate([-usb_wid/2,49,0])
     cube([usb_wid,usb_len, 8],false);

}

/* RJ11 jacks for encoder plug */
rj_post_dia  = 2.6; // Mounting post diameter
rj_post_dia2 = 3.1; // Mounting post diameter
rj_wid = 11.6;	   // Distance between mounting posts
rj_ofs = 2.6;	   // offset for square cutout
rj_sq = 6.5;	   // cutout for wires
rj_ov_len = 13.2;
rj_ov_wid = 14;
rj_ofs_z = 1.5;	// Amount of base after recess

module rj11_cutout()
{
rotate([15,0,0])    
rotate([0,0,180])
{
   // Cutouts for mounting post holes
   translate([0,0,-1])
     cylinder(d = rj_post_dia, h = dis_post_ht+1.02, center = false);

   translate([rj_wid,0,-1])
     cylinder(d = rj_post_dia, h = dis_post_ht+1.02, center = false);

   // Cutout for wires to jack pins
   translate([rj_ofs, 0, -5])
    cube([rj_sq, rj_sq, dis_post_ht + 10],false);
    
   // Recess for RJ11 body
   translate([-.8,-rj_ov_len/2, rj_ofs_z])
    cube([rj_ov_len,rj_ov_wid,10],false);

   // Recess for RJ11 mount posts
    translate([0,0,rj_ofs_z])
     cylinder(d = rj_post_dia2, h = dis_post_ht+.02, center = false);

   translate([rj_wid,0,rj_ofs_z])
     cylinder(d = rj_post_dia2, h = dis_post_ht+.02, center = false);  
}
    // Rounded side of square cutout
    translate([-6,-2,-3])
      cylinder(d = 6.5, h = 10, center=false);

   // Cutout slot for wires
    translate([-6.5,0,-3])
      cube([1.5,8,8],center=false);


}
module rj11_cutouts()
{
  translate([-22,26,0.75])
  {
    rj11_cutout();
//    translate([-15,8,-1])
//      cube([10,1.5,8],center=false);
  }

  translate([45 - rj_wid,26,0.75])
  {
    rj11_cutout();
//   translate([-5,6.5,-1])
//      cube([10,1.5,8],center=false);
  }
}

/* 0.1" header perf board hole & mount */
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

/* Holes for wire strain relief */
sc_dia = 3;	// Diameter for strain relief hole
module strain_cutout()
{
   cylinder(d = sc_dia, h = dis_post_ht+.01, center = false);

   translate([sc_dia+1, 0, 0])
     cylinder(d = sc_dia, h = dis_post_ht+.01, center = false);


}
module strain_cutouts()
{
   translate([31,37,0])
    rotate([0,0,90])
     strain_cutout();

   translate([-31,36,0])
    rotate([0,0,90])
     strain_cutout();

}
can_wid = 32;
can_len = 20;
can_ofs = 3;
module can_cutout()
{
   translate([-can_wid/2+can_ofs,8-1,0])
     cube([can_wid,can_len,dis_post_ht],false);

}

module iso_cutouts()
{
  translate([-20,42,0])
    cylinder(d = 10, h = dis_post_ht, center = false);

  translate([ 13,39,0])
    cylinder(d = 10, h = dis_post_ht, center = false);

  translate([-4,30,0])
    cube([14,16,dis_post_ht],false);

  translate([-15.5,34,0])
    cube([12,16,dis_post_ht],false);

  // LED spy hole
//  translate([-16,24,0])
//   rounded_rectangle(2,10,dis_post_ht,1);
  
  // iso rectangle 
  translate([-19,28.5,0])
     cube([36.8,20,dis_post_ht+2],false);

  // Corners
//  translate([-25.5,2,0])
      //cube([20,15,dis_post_ht],false);
      
   // Resistors
   translate([-16,10,0])
     cube([4,15.5,10],center=false);

}
module stiffeners()
{
  translate([-19.0,27.2,dis_post_ht])
   cube([39,1.5,8],false);

  translate([-18,10,dis_post_ht])
   cube([1.5,18,6],false);

  translate([18.5,28,dis_post_ht])
   cube([1.5,18,6],false);
}

module base()
{
   difference()
    {
        union()
        {
            pod_4posts();
            t_bars();            
            stiffeners();
				id();
        }
        union()
        {
//            usb_cutout();
            rj11_cutouts();
//            header_carriers();
//            strain_cutouts();
            can_cutout();
            iso_cutouts();
        }
    }
}
base();
