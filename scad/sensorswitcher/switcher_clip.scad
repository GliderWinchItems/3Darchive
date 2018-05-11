/* File: switcher_clip.scad
 * Clip for sensor board to hold dc-dc switcher module
 * Author: deh
 * Latest edit: 20180509
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=100;

big = 10;	// Big z in direction 

ba_len = 36;	// Base width
ba_wid = 14;
ba_thick = 2;
ba_tab1_wid = 9+2;
ba_tab2_wid = 8;
ba_cut1_len = ba_len - ba_tab1_wid - ba_tab2_wid;
ba_cut1_wid = 9;
echo ("ba_cut1_len", ba_cut1_len);

module base()
{
    ofs_x = 5;
    ofs_y = 6.5;
    ofs_x2 = ofs_x + 26;

 	difference()
	{
        union()
        {
            translate([-ba_len,0,0])
                cube([ba_len,ba_wid,ba_thick],center = false);
            
            translate([-58,0,0])
                cube([8,12,ba_thick],center=false);
        }

		union()
		{
            translate([-ba_tab1_wid-ba_cut1_len,0,0])
					cube([ba_cut1_len,ba_cut1_wid,5+ba_thick+.01],center=false);

			translate([-ofs_x,ofs_y,-0.01])
				cylinder(d=3.3,h=ba_thick+0.05,center=false);

			translate([-ofs_x2,ofs_y,-0.01])
				cylinder(d=3.3,h=ba_thick+0.05,center=false);
            
            translate([-48.6-ofs_x, 5.8, 0])
                cylinder(d= 2.8,h = ba_thick+.01,center=false);
		}
	}
}

/* Side wall that goes around LM2596 */
	cl_len = 10;	// X direction length of this clip
	cl_ct1 = 2.6;	// Inner space at LM2596 heatsink tab
	cl_ct2 = 5.85;	// Inner space at LM2595 body
	cl_th1 = 2; 	// Wall thickness inside face
	cl_th2 = 2;		// Wall thickness outside face
	cl_ht1 = 2.7;	// Height ridge at LM2596 heatsink tab
	cl_ht2 = 11.0;	// Height of inside face wall

cl_wid = cl_ct2 + cl_th1 + cl_th2;

module clip()
{
	

	difference()
	{
        union()
        {
            cube([cl_len, cl_wid,cl_ht2],center=false);
        }
            
		union()
		{
			translate([-.01,cl_th2,cl_ht1])
				cube([cl_len+.02,cl_ct2,big],center=false);

			translate([-.01,cl_th2,0])
				cube([cl_len+.02,cl_ct1,big],center=false);
		}
	}
}

module clipwedge()
{   
    translate([0,cl_wid,0])
        rotate([180,0,0])
            wedge(35, cl_wid, 5);

}


/* Back plate */
pb_len = 58;
pb_thick = 2;
pb_ht = 10;//25;

module backplate()
{
    ofs_x = pb_len;
    difference()
    {
		union()
		{
	       translate([-ofs_x,0,0])
   	        cube([pb_len,pb_thick,pb_ht],center=false);

			translate([-51 ,0,10])
  				clip();	

			translate([-pb_len,0,10])
		     clipwedge();	
                
           translate([-40,0,10])
              edgeseat(4,4);
                
           translate([-58,0,10])
              edgeseat(3,3);
                
           difference()
           {
              translate([-28,0,10])
                 edgeseat(5,5);
               
              translate([-28+2.2,3,10+2.5])
                rotate([90,0,0])
                   cylinder(d1=3.4,d2=2.0,h=6,center=true);
           }          
   		} 
        union()
        {
            translate([-ba_tab1_wid-ba_cut1_len,0,0])
					cube([ba_cut1_len,ba_cut1_wid,5+ba_thick+.01],center=false);
            
            translate([-50, 0,0])
                cube([13,pb_thick+.01, 6],center=false); 

        }
    }
}

es_thx = 1.8; // Thickness of switcher pc board
module edgeseat(len,ht)
{
    
    translate([0,0,0])
        cube([len,cl_th1,ht],center=false);
 
    translate([0,es_thx + pb_thick,0])
        cube([len,cl_th1,ht],center=false);   
}


module stiffner1()
{
	st_y = 2;
	st_z = 3;
	ofs_y = ba_wid - st_y;
	translate([-ba_len, ofs_y, ba_thick-0.01])
		cube([ba_len,st_y,st_z],center=false);
    
 
}

module plug()
{
    d_in = 8.6;
    difference()
    {
        union()
        {
            cylinder(d= d_in, h = 1.5, center= false);
            cylinder(d=d_in+2,h = 1, center= false);
        }
        union()
        {
            cylinder(d=3.4, h = big,center=false);
        }
    }
}

module total()
{
    difference()
    {
        union()
        {
            base();
            stiffner1();
            backplate();
        }
        union()
        {
 	
			cx = 10;
			translate([-ba_len-cx+2.5, 5, 0])
				cube([cx,30,ba_thick+5],center=false);

        }
   }
translate([10,0,0])
  plug();
}
total();

