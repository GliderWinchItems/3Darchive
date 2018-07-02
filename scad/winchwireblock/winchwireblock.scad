/* File: winchwireblock.scad
 * Power cable wire junction separators
 * Author: deh
 * Latest edit: 20180701
 * 
 */


 $fn=50;

bl_wid = 25.4 * 2; 	// Overall Width of one block
bl_ht  = 25.4 * 3;	// Height
bl_len = 25.4 * 4;	// Length
bl_flr = 25.4 * 1.5;	// Bottom to floor of well
bl_w_wid = 25.4 * 1.25;	// Width of wire well




module base_block()
{
	difference()
	{
		union()
		{
			translate([0,0,bl_ht/2])
		     cube([bl_wid,bl_len,bl_ht],center=true);
		}
		union()
		{
			ofz =  bl_flr + 100;
			translate([0,0,ofz])
		     cube([bl_w_wid,200,200],center=true);
		}
	}
}

/* Holes for bolt, with hex nut and washer embedding */
bl_shank_dia = .375 * 25.4 + 2; // Shank dia plus slop
bl_nut_dia = 25.4 * 0.50 + 4;	  // Nut peak-peak dia
bl_nut_thx = 25.4 * 0.25 + 3;   // Nut thickness
wa_dia     = 25.4 * .75  + 4;   // Washer dia
wa_thx     = 25.4 * .125 + 3;   // Washer thickness
wa_wall    = 25.4 * .25  + 0;   // Thickness between floor and washer top


module holes()
{
	// Shank hole goes all the way through
	cylinder(d=bl_shank_dia,h=200,center=true);
  
	// Embed washer
	ofz = bl_flr - wa_wall - bl_nut_thx - wa_thx;
	translate([0,0,ofz])
		cylinder(d=wa_dia,h=wa_thx,center=false);

	// Embed nut 
	ofz1 = ofz + wa_thx;
	translate([0,0,ofz1])
		cylinder(d=bl_nut_dia,h=bl_nut_thx,center=false,$fn=6);

}


module total()
{
	difference()
	{
		union()
		{
			base_block();
		}
		union()
		{
			holes();
		}
	}
}

total();

