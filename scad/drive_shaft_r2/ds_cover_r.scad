/* File: cwH_cover.scad
 * Cover for PC board box cwH_fixture.scad
 * Author: deh
 * Latest edit: 20170428
 */

include <../library_deh/deh_shapes.scad>
include <../drive_shaft/ds_fixture_common.scad>

 $fn=50;



module window()
{
      rounded_rectangle(win_len_x, win_len_y, 20, shell_rad);
      
      translate([0,0,win_r_z])
        rounded_rectangle(win_len_x+win_r, win_len_y+win_r, 20, shell_rad);       

}

// Cover has to fit over cwH_fixture, so increase the dimensions
cw_slop = 0.8;	// Slop is short for clearance
cw_len_x = ww_len_x + (shell_wall*2) + cw_slop;
cw_len_y = ww_len_y + (shell_wall*2) + cw_slop;

module walls()
{
  // Top, when installed, but bottom on scad
  difference()
  {
    rounded_rectangle(cw_len_x, cw_len_y, cvr_thick, shell_rad);
    union()
    {
      // Cutouts for clear plastic windows
      translate([ 10,-35,-.01])
       window();

      translate([-10, 35,-.01])
       window();
    }
  }

  // Walls/rim of cover
  difference()
  {
    rounded_rim(cw_len_x, cw_len_y, cvr_wall, shell_rad, cvr_thick);

    // Cable cutout/notch for one telephone type cable
    translate([-(70-cc_ofs_x), 70-15, 10])
      cable_cutout();
  }

  // Mounting tabs
    cover_mnt_tabs();
}

module cable_cutout()
{
   // One telephone type cables
    rotate([0,90,90])
     rounded_rectangle(cc_thick,cc_wid,20,1.5);
}

module cover_mnt_tab()
{
      rotate([0,0,-90])
        eye_bar(cm_od,cm_id2,cm_len - (shell_wall + cw_slop) ,cvr_wall);
}
cm_ofs_y = -30;
cm1_ofs_x =  ww2_ofs_x - cm_len;
cm2_ofs_x = -ww2_ofs_x + cm_len - shell_wall;

module cover_mnt_tabs()
{
   translate([cm1_ofs_x,cm_ofs_y,0])
     rotate([0,0,90])
      cover_mnt_tab();

   translate([cm1_ofs_x,-cm_ofs_y,0])
     rotate([0,0,90])
      cover_mnt_tab();

   translate([cm2_ofs_x + shell_wall,0,0])
     rotate([0,0,-90])
      cover_mnt_tab();
}

module total()
{
   walls();
   difference()
   {

   }
}
total();
