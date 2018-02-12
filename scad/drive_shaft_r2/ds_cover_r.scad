/* File: cwH_cover.scad
 * Cover for PC board box ../drive_shat_r2/ds_fixture.scad
 * Author: deh
 * Latest edit: 20170428
 * V0 = 20150208 hack of earlier code
 */

include <../library_deh/deh_shapes.scad>
include <../drive_shaft/ds_fixture_common.scad>

 $fn=50;

oshell_x = shell_x + 2*shell_wall + 0.3;
oshell_y = shell_y + 2*shell_wall + 0.3;

wndw_x = 65;
wndw_y = 40;

module window()
{
	rotate([0,0,90])
      rounded_rectangle(wndw_x, wndw_y, 20, shell_rad);
      
	rotate([0,0,90])
      translate([0,0,win_r_z])
        rounded_rectangle(wndw_x+win_r, wndw_y+win_r, 20, shell_rad);       

}

cw_slop = 0.8;	// Slop is short for clearance

module walls()
{
  // Top, when installed, but bottom on scad
  difference()
  {
    rounded_rectangle(oshell_x, oshell_y, cvr_thick, shell_rad);
    union()
    {
      // Cutout for clear plastic windows
      translate([ 5,0,-.01])
       window();

    }
  }

  // Walls/rim of cover
  difference()
  {
    rounded_rim(oshell_x, oshell_y, cvr_wall, shell_rad, cvr_thick);
  }

  // Mounting tabs
	translate([-29,0,0])
    cover_mnt_tabs();
}
/*
module cover_mnt_tab()
{
      rotate([0,0,-90])
        eye_bar(cm_od,cm_id2,cm_len,shell_ht - cov_ofs);
}
*/
module cover_mnt_tabs()
{
   translate([-cm_ofs_x1, shell_y/2 - cm_ofs_dy,0])
     rotate([0,0,90])
      cover_mnt_tab();

   translate([-cm_ofs_x1, -shell_y/2 + cm_ofs_dy,0])
     rotate([0,0, 90])
      cover_mnt_tab();

   translate([cm_ofs_x2,0,0])
     rotate([0,0,-90])
      cover_mnt_tab();
}

module cover_mnt_tab()
{
      rotate([0,0,-90])
        eye_bar(cm_od,cm_id2,cm_len - (shell_wall + cw_slop) ,cvr_wall);
}

module total()
{
   walls();
//	cover_mnt_tabs();

}
total();
