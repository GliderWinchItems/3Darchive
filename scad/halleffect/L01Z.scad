/* File: L01Z.scad
 * Box for holding Tamura L01Z current sensor w cable
 * Author: deh
 * Latest edit: 20180708
 */

include <../library_deh/deh_shapes.scad>

 $fn=50;

he_len = 37.5;
he_wid = 26+0.5;
he_ht  = 12+6+4;
wn_len = 15;
wn_wid = 8;
wn_ofx = he_len - wn_len - 9;
wn_ofy = 9.5;
pn_wid = 6;
pn_len = 5;
pn_ofx = 38-14.5-12.8+3;

sh_wall = 2;  //  Shell wall thickness
sh_bot  = 2;  // Bottom thickness
sh_len  = he_len + 2*sh_wall; // Outside length
sh_wid  = he_wid + 2*sh_wall + pn_wid; // Outside width
sh_ht   = he_ht + sh_bot;     // Height including base

mt1_ofx = 6+2;    // Mounting pin #1
mt1_ofz = 2.5;

mt2_ofx = 35.5+1; // Mounting pin #2
mt2_ofz = 15;

cb_ht  = 18; // 

tb_wid = 8;    // Tab width
tb_thx = 3;    // Tab thickness
tb_dia = 3.2;  // Tab screw hole dia

cp_ht = sh_ht - 4; // Side post height

module tab(a,theta)
{
pd = sh_ht/3;
  translate(a)
  {
   rotate([0,0,theta])
     rotate([0,-90,0])
     {
       difference()
       { union()
         {
           linear_extrude(height = tb_thx,center=false)
              polygon(points=[[0,0],[pd,tb_wid],[2*pd,tb_wid],[3*pd,0]]);
         }
         union()
         {
			  translate([1.5*pd,tb_wid/2,-.1])
			     cylinder(d=tb_dia,h=100,center=true);

            big = 50;
            translate([cp_ht, -0.1,-0.1])
              cube([big,big,big],center=false);
         }
       }
     }
  }
}
module side_post(dia_p,screw_d,screw_z,ht)
{
	rad = dia_p/2;

 translate([-rad-.05,-rad,0])
 {
	 eye_bar(dia_p, screw_d, dia_p/2, ht);

			
	translate([dia_p/2,dia_p/2-0.5,0]) rotate([0,0,90])
		fillet(rad,ht);

	translate([dia_p/2,-dia_p/2+0.05,0]) rotate([0,0,180])
		fillet(rad,ht);
 }
}
dia_pp = 6;
module side_post1(cx,cy,theta, ht)
{
	translate([cx,cy,0])
	 rotate([0,0,theta])
		side_post(dia_pp,2.8,12,ht);
}
module side_posts(ht)
{
	vx = sh_len   - 0;
	vy = sh_wid/2 - 0;

	side_post1( vx, vy,180, ht);
	side_post1(  0, vy,  0, ht);
}

// Telephone type cable cutout
module cable_cutout(a)
{
	translate(a) // Cutout center of block
		rotate([0,90,0])
		 rounded_rectangle(5,5,20,2);
}

module current_wire_window(b)
{
  translate(b)
  {
			// current wire window
			len3 = wn_len;
			wid3 = wn_wid;
         ht1  = 50;
         ofx3 = sh_wall + wn_ofx ;
         ofy3 = sh_wall + wn_ofy + pn_wid;
			translate([ofx3,ofy3, 0])
			   cube([len3,wid3,ht1],center=false);    
  }
}

module shell()
{
	difference()
	{
		union()
		{
 			// Main shell block
			cube([sh_len,sh_wid,sh_ht],center=false);

			// Magnet Mounting tabs
         tab([0.05,sh_wid,0],90);
         tab([sh_len,sh_wid-tb_thx,0],-90);

			// Cover mounting posts
			side_posts(cp_ht);
		}
		union()
		{
			// Tamura fits inside
			len1 = he_len + 0;
			wid1 = he_wid + 0;
         ht1  = 50;
         ofx1 = sh_wall - 0;
         ofy1 = sh_wall - 0 + pn_wid;
         ofz1 = sh_bot + he_ht - 4;
			translate([ofx1,ofy1,sh_bot])
			   cube([len1,wid1,ht1],center=false);

			// Cable area
         len2 = len1;
         wid2 = pn_wid;
         ofx2 = ofx1;
			ofy2 = sh_wall;
         ofz2 = cb_ht + sh_bot;
			translate([ofx2,ofy2,ofz2])
			   cube([len2,wid2,ht1],center=false);

			// current wire window
			current_wire_window([0,0,0]);

         // Slots for mounting pins
			dd = 1.5;
         ofz4 = sh_bot + mt1_ofz;
         translate([mt1_ofx,sh_wall,ofz4])
            cube([dd,pn_wid,ht1],center=false);

         ofz5 = sh_bot + mt2_ofz;
         translate([mt2_ofx,sh_wall,ofz5])
            cube([dd,pn_wid,ht1],center=false);

         // Cable cutout in side
         cable_cutout([sh_len-sh_wall-0.05,sh_wall+3.5,sh_ht+1.2]);

		}
	}
}


cv_wall = 2;
cv_len = sh_len + 2*cv_wall + .2;
cv_wid = sh_wid + 2*cv_wall + .2;
cv_rad = 1.5;
cv_ht  = cv_wall + he_ht - cp_ht;

module cover_base(ofz)
{
del = 0.2;
ofx1 = cv_len/2  - cv_wall;
ofy1 = cv_wid/2  - cv_wall;
  translate([ofx1,ofy1,ofz])
  {  


    difference()
    {
      union()
      {
        // Main block
        rounded_rectangle(cv_len,cv_wid,cv_ht,cv_rad);
		
        // Mounting posts
        translate([-ofx1,-ofy1,0])
          side_posts(cv_ht);

      }
      union()
      {
        // bottom shelf fits inside cover
        ht2 = cv_ht - cv_wall;
        ofz2 = 0;
        translate([0,0,ofz2])
          cube([sh_len+del,sh_wid+del,ht2],center=true);

			// current wire window
			current_wire_window([-ofx1,-ofy1,-ofz]);

         // Drill out cover mounting holes in Main block\
			dia = 3.2;
       	vx = sh_len   - ofx1 + dia_pp/2;
	      vy = sh_wid/2 - ofy1 + dia_pp/2;
         translate([vx,vy,0])
           cylinder(d=dia,h=50,center=true);

       	wx = -sh_len/2 - dia_pp/2;
	      wy = sh_wid/2 - ofy1 + dia_pp/2 - pn_wid;
        translate([wx,wy,0])
           cylinder(d=dia,h=50,center=true);

         // Cable cutout should match shell cutout
cable_cutout([sh_len/2-sh_wall,-cv_wid/2+cv_wall+5.5, -3.0]);

       
      }
    }
translate([cv_len/2 - 1, -cv_wid/2+cv_wall+1, 0])
  cube([0.5,9,3],center=false);

  }
}
shell();
//cover_base(25);

translate([60,0,0]) cover_base(0);

