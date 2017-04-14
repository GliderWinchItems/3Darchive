/* File: cwV_guard.scad
 * Guard plate for photocell/codewheel protection
 * Reflective photosensors version, (V = vertical)
 * Author: deh
 * Latest edit: 20170412
 */
  
  $fn = 300;

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

module total()
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

total();
