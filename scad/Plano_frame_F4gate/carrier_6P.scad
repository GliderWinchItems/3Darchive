/* File: carrier_6P.scad
 * Plano box with Discovery F4: RJ-11 6_ carrier above switcher board
 * Author: deh
 * Latest edit: 20180204
 * V1 - Hacked from 2017 12 22 V1 carrier.scad
 * VA1 - 20170204: Hacked from Plano_fullbase, carrier_6P.scad
 *
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/deh_shapes2.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>


jj = 0.5;	// Minor y direction adjustment
sid_wid = 2.5;  // Width of side rails
sid_len = 15;   // Length of side rails
sid_rail_y  = pc_y - pod_post_q - dis_len - jj;
sid_rail_y2 = pc_y - pod_post_q - dis_len + 65 - jj;

dis_post_y = 10;
dis_post_ht = 3;

plano_wid_bot = 81;	// Inside width near bottom before radius
plano_rad_end = 7;	// Radius (z axis) at inside corners

crr_len = 46;
crr_rad = 4;	// Radius of mounting post

sqrt2 = sqrt(2);
crr_z1 = plano_rad_end*(sqrt2 -1);
crr_z2 = (crr_z1 + crr_rad);
crr_ofs_r = crr_z2/sqrt2;
echo("crr_z1",crr_z1);
echo("crr_z2",crr_z2);
echo("crr_ofs_r",crr_ofs_r);

     ofs = 3;

tweak1 = 5;	// Move old things further north (y)

 $fn=50;


//half_rounded_rectangle_hull(plano_wid_bot,crr_len,dis_post_ht,0,plano_rad_end);



// **** Id the part ***
module id()
{
 {
  font = "Liberation Sans:style=Bold Italic";
 translate([-30,2.5, dis_post_ht]) 
  linear_extrude(1)
   text("VA1",size = 2.5);
 }
}
module post_holes()
{
	ofs_x  = plano_wid_bot/2 - crr_ofs_r; 
	ofs_y1 = crr_ofs_r;
	ofs_y2 = crr_len - crr_ofs_r;  

	// Right bottom
	translate([ofs_x,ofs_y1,0])
		cylinder(d=3.2,h=6,center=false);

	// Left bottom
	translate([-ofs_x,ofs_y1,0])
		cylinder(d=3.2,h=6,center=false);

	// Right top
	translate([ofs_x,ofs_y2,0])
		cylinder(d=3.2,h=6,center=false);

	// Left top
	// Right top
	translate([-ofs_x,ofs_y2,0])
		cylinder(d=3.2,h=6,center=false);
}

module crr_base()
{
	difference()
	{
		// base rounded at pcb end, rounded at Plano end
half_rounded_rectangle_hull(plano_wid_bot,crr_len,dis_post_ht,0,plano_rad_end);

		post_holes();
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
     translate([-plano_wid_bot/2-ofs, sid_rail_y, 0])
       dis_post();
     
     translate([plano_wid_bot/2-dis_post_y+ofs, sid_rail_y, 0])
       dis_post();

     translate([-plano_wid_bot/2-ofs, ee, 0])
       dis_post();

     translate([plano_wid_bot/2-dis_post_y+ofs, ee, 0])
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
     translate([plano_wid_bot/2+ofs,ee-.01,0])
       rotate([0,0,90])
         t_bar ( tbr_len+.02, tbr_wid, tbr_ht,  dis_post_ht);
      
     translate([-plano_wid_bot/2-ofs+tbr_wid,ee-.01,0])
       rotate([0,0,90])
         t_bar ( tbr_len+.02, tbr_wid, tbr_ht,  dis_post_ht);

     translate([-plano_wid_bot/2+tbr_wid/2,10,0])
       cube([plano_wid_bot-tbr_wid, 44, dis_post_ht],false);

     // Lip over Discovery board
     translate([-plano_wid_bot/2-tbr_wid/2+ofs/2, 54, 0])
       cube([plano_wid_bot+tbr_wid/2+ofs/2, 2, dis_post_ht],false);

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
rj_post_dia  = 2.6 + 0.6; // Mounting post diameter
rj_post_dia2 = 3.8; // Mounting post diameter
rj_wid = 10;//11.6;	   // Distance between mounting posts
rj_ofs = 2.6;	   // offset for square cutout
rj_sq_x = 6.5;	   // cutout for wires
rj_sq_y = 11;	   // cutout for wires
rj_ov_len = 13.5;
rj_ov_wid = 18;//14;
rj_ofs_z = 1.5;	// Amount of base after recess

rj_tw = 1.0; // Tweak of post x

module rj11_platform()
{
	px = 16;
   py = 25;
	pz = 2;
	translate([-px/2-5.5,-py/2,dis_post_ht-1])
		cube([px,py,pz],center=false);

}
rjqq = 4;	// Tweak +/- x offset
rjyy = -8;	// Tweak y offset
module rj11_platforms()
{
  translate([-22-rjqq,30+rjyy,0.75])
  {
    rj11_platform();
  }

  translate([45+rjqq-rj_wid-1.6,30+rjyy,0.75])
  {
    rj11_platform();
  }
}

module rj11_cutout()
{
rotate([15,0,0])    
rotate([0,0,180])
{
   // Cutouts for mounting post holes
   translate([rj_tw,0,-5])
     cylinder(d = rj_post_dia, h = dis_post_ht+15, center = false);

   translate([rj_wid+rj_tw,0,-5])
     cylinder(d = rj_post_dia, h = dis_post_ht+15, center = false);

   // Cutout for wires transitioning from pins
   translate([rj_ofs+1, 0, -5])
    cube([rj_sq_x-2, rj_sq_y, dis_post_ht + 10],false);

   // Cutout for wires at jack pins 
   translate([rj_ofs-2, 5, -5])
    cube([rj_sq_x+4, rj_sq_y-4, dis_post_ht + 10],false);
    
   // Recess for RJ11 body
   translate([-.8,-rj_ov_len/2, rj_ofs_z])
    cube([rj_ov_len,rj_ov_wid,10],false);

   // Recess for RJ11 mount posts
    translate([0,0,rj_ofs_z])
     cylinder(d = rj_post_dia2, h = dis_post_ht+.02, center = false);

   translate([rj_wid+rj_tw,0,rj_ofs_z])
     cylinder(d = rj_post_dia2, h = dis_post_ht+.02, center = false);  
}
    // Rounded side of square cutout
    translate([-6,-2,-3])
      cylinder(d = 4.5, h = 10, center=false);

   // Cutout slot for wires
    translate([-6.5,0,-3])
      cube([1.3,15,8],center=false);

	// Wire hole at end of slot
	translate([-6.0,14,-3])
		cylinder(d=3.0,h = 15,center=false);
}
module rj11_cutouts()
{
  translate([-22-rjqq,30+rjyy,1.75])
  {
    rj11_cutout();
  }

  translate([45+rjqq-rj_wid-1.6,30+rjyy,1.75])
  {
    rj11_cutout();
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

hdr_ofs_x = -plano_wid_bot/2-ofs+tbr_wid;

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
can_len = 21;
can_ofs = 3;
module can_cutout()
{
   translate([-can_wid/2+can_ofs,8-1.5-tweak1,0])
     cube([can_wid,can_len,dis_post_ht],false);

}

module iso_cutouts()
{
  translate([-20,42,0])
    cylinder(d = 10, h = dis_post_ht+8, center = false);

  translate([ 13,39,0])
    cylinder(d = 10, h = dis_post_ht+8, center = false);

  translate([-4,30,0])
    cube([14,16,dis_post_ht],false);

  translate([-15.5,34,0])
    cube([12,16,dis_post_ht],false);

  // LED spy hole
//  translate([-16,24,0])
//   rounded_rectangle(2,10,dis_post_ht,1);
  
  // iso rectangle 
  translate([-24.0,28.5-1.0,-.01])
     cube([46,22,dis_post_ht+2],false);

  // Corners
//  translate([-25.5,2,0])
      //cube([20,15,dis_post_ht],false);
      
   // Resistors
   translate([-21.5,8,0])
     cube([10,18,10],center=false);

}
module stiffeners()
{
   twk2 = 5;
  translate([-18.5-twk2,27.2-1.2,dis_post_ht])
   cube([46,1.5,4],false);

  translate([-18-twk2,10-0.5,dis_post_ht])
   cube([1.5,18,4],false);

  translate([18.5+3.5,28-2.0,dis_post_ht])
   cube([1.5,18+1,4],false);
}

module crr_total()
{
   difference()
    {
        union()
        {
			crr_base();
//            pod_4posts();
			translate([0,-tweak1,0])
                stiffeners();
			id();
			rj11_platforms();
        }
        union()
        {
//            usb_cutout();
            rj11_cutouts();
//            header_carriers();
//            strain_cutouts();
            can_cutout();
				translate([0,-tweak1,0])
        	 		iso_cutouts();
        }
    }
}
//base();
//crr_base();
//crr_total();
