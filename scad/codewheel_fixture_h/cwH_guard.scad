/* File: cwH_guard.scad
 * Guard plate for photocell/codewheel protection
 * Reflective photosensors version, (H = horizontal over top)
 * Author: deh
 * Latest edit: 20170417
 */
  
  $fn = 300;
include <cwH_common.scad>
include <../library_deh/deh_shapes.scad>

  ps_wid = 4.7;	// Width of photosensor
  ps_len = 6.5;	// Length of photosensor

 pl_x = 40;
 pl_y = 50;
 pl_thick = 2;

  ps_ht = pl_thick + 1;

 cy_dia = 100;	// Diameter of "bump"
 cy_bump_ht = 4; // Height of bump over plate bottom surface
 cy_ofs_z = cy_dia/2 - cy_bump_ht;
 cy_wid = 5;	// Width of one bump
 

module plate()
{
   cube ([pl_x,pl_y,pl_thick]);
}

module bump()
{
  translate ([0,0,-cy_ofs_z])
  rotate([0,90,0])
    cylinder(d=cy_dia, h = cy_wid, center = false);
}

module bumps()
{

  difference()
  {
    union()
    {
      translate([0,pl_y/2,0])
        bump();

      translate([ps_len*2+1,pl_y/2,0])
        bump();
    }
    union()
    {
      translate([0, -cy_dia/2, -cy_dia])
         cube([cy_dia*2, cy_dia*2, cy_dia],center = false);
    }
  }
}

module photocell_cutout()
{
      translate([cy_wid+1,pl_y/2-ps_wid,-1])
         cube([ps_len,ps_wid*2,5],center=false);

}

aa_ofs_x = pl_x/2 - (ps_len+1)/2 - cy_wid;

module oneside()
{
   difference()
   {
     union()
     {
       plate();
       translate([aa_ofs_x,0,0])
          bumps();
     }
     union()
     {
       translate([aa_ofs_x,0,0])
          photocell_cutout();
     }
   }
}

tw_sep = 36.8;	// Separation distance of windows
tw_screw_dia = 3.3;	// Screw hole dia
tw_ofs_x = pl_x - 3;
tw_head_dia = 5.8;	// Screw head dia+
tw_head_depth = 1.5;	// Head recess
tw_ofs_z = pl_thick - tw_head_depth;

wg_len = 77;
wg_wid = 30;
wg_ofs_x1 = -37;
wg_ofs_x2 = 37 + 3;
wg_ofs_y1 = 55;


module total()
{  
   difference()
   { // Two sides
     union()
     {
       translate([0,-pl_y/2,0])
         oneside();

       translate([-tw_ofs_x,-pl_y/2,0])
         oneside();

       translate([wg_ofs_x1,-wg_ofs_y1,0])
         wedge(wg_len,wg_wid,pl_thick);

       translate([wg_ofs_x2,wg_ofs_y1,0])
        rotate([0,0,180])
         wedge(wg_len,wg_wid,pl_thick);
     }
     union()
     { // Mounting screw holes
	translate([0,ls_post_ofs_x,0])
          cylinder(d = tw_screw_dia, h = 20, center=true);

	translate([0,-ls_post_ofs_x,0])
          cylinder(d = tw_screw_dia, h = 20, center=true);

       // Recess for screw head
	translate([0,ls_post_ofs_x,tw_ofs_z])
          cylinder(d = tw_head_dia, h = 20, center=false);

	translate([0,-ls_post_ofs_x,tw_ofs_z])
          cylinder(d = tw_head_dia, h = 20, center=false);
     }
   }
}
total();
