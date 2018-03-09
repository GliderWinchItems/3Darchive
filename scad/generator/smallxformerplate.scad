/* scad/generator/smallxformerplate.scad
 * Base plate for mounting small 120|12 transformers
 * Date of latest: 20180307
 *
 */

include <generator_common.scad>
include <../library_deh/fasteners.scad>

$fn = 50;

big = 20;	// Big number for drilling holes

kb_thick = 7;	// Thickness of plate
kb_len = 15+33+33+15;
kb_wid = 54+10;

// **** Id the part ***
module id()
{
 id_x = vp_dia;
 id_y = bp_sq/2 - 1;
 {
/*
  font = "Liberation Sans:style=Bold Italic";
  translate([0,gs_tube_od/2 - 1.5, 20]) 
  rotate([-90,0,0])
  linear_extrude(2)
   text("V1",size = 5);
*/

 rotate([0,0,95])
 translate([gs_tube_od/2 - 1,0, 48]) 
  rotate([0,90,0])
    linear_extrude(2)
      text("2017 10 11 V1",size = 5);
 }
}
xf_dia = 3.6;	// Bolt hole diameter
xf_edge = 5;
xf_t1 = 1.5;	// Thickness between top surface and washer

// Xformer bolt
module xfmr_bolt(a,b,c)
{
	translate([a,b,c])
	{
		kb_t_w = washer_thick_6 + 0.4;
		xf_h_washer = kb_thick - xf_t1 - kb_t_w; // Height offset
		kb_thk = nut_thick_632 + 0.5;	// thickess
		xf_h_nut = xf_h_washer - kb_thk;	// Height offset

			// Shaft
			cylinder(d=xf_dia,h=20,center=false);

			// Washer
			kb_wash = washer_od_6 + 0.5;
			translate([0,0,xf_h_washer])
				cylinder(d=kb_wash,h=kb_t_w,center=false);


			// Nut
			kb_nut = nut_dia_632 + 0.5;	// peak-peak 
			translate([0,0,xf_h_nut])
				cylinder(d=kb_nut,h=kb_thk,center=false,$fn=6);
	}
}

// One xfmr
xf_dia = 3.6;	// Bolt hole diameter
xf_edge = 5;
xf_hole_spacing = 45;

module xfmr_sub()
{
	xs_w = xf_hole_spacing;
	xfmr_bolt( xs_w/2,0,-.01);
	xfmr_bolt(-xs_w/2,0,-0.01);
}
xf_space = 33;	// Spacing between transformers

module xfmr_all_sub()
{
	translate([0,  0,0])
		xfmr_sub();

	translate([0,-33,0])
		xfmr_sub();

	translate([0, 33,0])
		xfmr_sub();
}

module mtg_holes_sub()
{
	mt_dia = 3.6;	// Mounting bolt dia
	ofs_x = kb_wid/2 - 1.5*mt_dia;
	ofs_y = kb_len/2 - 1.5*mt_dia;

	translate([ ofs_x, ofs_y,0])
		cylinder(d=mt_dia,h=big,center=false);

	translate([ ofs_x,-ofs_y,0])
		cylinder(d=mt_dia,h=big,center=false);

	translate([-ofs_x, ofs_y,0])
		cylinder(d=mt_dia,h=big,center=false);

	translate([-ofs_x,-ofs_y,0])
		cylinder(d=mt_dia,h=big,center=false);
}
// Grooves under xfmr
xf_wire_space = 15; // Spacing between wires 
xf_wire_wid = 3;	// Wire dia
xf_groove_len = 80;

module groove_sub()
{
	wid = xf_wire_wid + 1;
	ofs_x = xf_wire_space/2 - wid/2;
	ofs_z = kb_thick  - xf_wire_wid/2;
	ofs_y = -6;

	translate([ ofs_x,ofs_y,ofs_z])
		cube([wid,xf_groove_len,wid],center=true);

	translate([-ofs_x,ofs_y,ofs_z])
		cube([wid,xf_groove_len,wid],center=true);

	
		translate([ofs_x-5, 24,ofs_z])
			rotate([0,0, 18])
				cube([wid, 35,wid],center=true);

		translate([ofs_x-5, -4,ofs_z])
			rotate([0,0, 18])
				cube([wid, 35,wid],center=true);
}
// Post with slot in top
module kb_post2(a,r)
{
  translate(a)
  rotate(r)
  {
	difference()
	{
        dia = 7;
        ht = 8;
        depth = 6;
		translate([0,0,0])
			cylinder(d=dia,h=ht,center=false);

		slot = xf_wire_wid + 0.5;
		ofs_z = ht - depth/2;
		translate([0,0,ofs_z])
			cube([big,slot,depth],center=true);
	}
  }
}
// Post with hole
module kb_post(a,r)
{
  translate(a)
  rotate(r)
  {
	difference()
	{
        dia = 7;
        ht = 8;
        depth = 6;
		translate([0,0,0])
			cylinder(d=dia,h=ht,center=false);

		slot = xf_wire_wid + 0.5;
		ofs_z = ht - depth/2;
		translate([0,0,ofs_z])
			rotate([90,0,0])
			cylinder(d=slot,h=big,center=true);
	}
  }
}

module kb_posts()
{
    kb_post([ 19, kb_len/2-3.5,kb_thick-0.01],90);   // HV 

    kb_post([ 27, -16,kb_thick-0.01],45);   // HV 

    kb_post([ 19,-16,kb_thick-0.01],45); // LV
    kb_post([-19,-16,kb_thick-0.01],0); // LV
}

module kbplate()
{
	difference()
	{
		union()
		{
			translate([0,0,kb_thick/2])
				cube([kb_wid,kb_len,kb_thick],center=true);
            kb_posts();
		}
		union()
		{
			xfmr_all_sub();
			mtg_holes_sub();
			groove_sub();
		}


	}


}
kbplate();
