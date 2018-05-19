/* File: mod4pjack.scad
 * Jameco 2151560 4P4C jack mount
 * Author: deh
 * Latest edit: 20180516
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=25;

j_len  = 10.4;  // Length inside bottom ridge to backside
j_wid = 13.5;  // Width of jack
j_ht  =  9.0;   // Height of jack
j_rdg =  2.0;   // Rdige for cap to seat on wall
j_w_thx = 2;	 // Thickness of walls
j_b_thx = 4;      // Thickness of base jack sits upon 
j_cd = 2.9; 	// Cap self-tap screw hole dia
j_hd = 1.88 + 0.6;	// Jack indices hole dia
j_hx1 = 6.0;
j_hy1 = 1.8;
j_hx2 = 9.2;
j_hy2 = 2.7;
j_lenb = 2.5;
j_htb = j_b_thx - 1.3; // Handle small ridge under jack entrance


t_wid = 16;
t_len = 27;
t_thx = 2;

jp_len = 7;      // Cap post length (x)
jp_wid = 7;     // Cap post width (y)

 j_len1 = j_len + j_w_thx + jp_len;
 j_wid1 = j_wid + j_w_thx;

 ht1  = j_ht  + j_rdg + j_b_thx;

module jbase()
{

    
 ofx0 = j_len1/2 - j_lenb/2;
 ofy0 = j_wid1/2;

 translate([-ofx0,-ofy0,0])
 {
	difference()
    {
        union()
        {
            
            // Base plate for jack
            cube([j_len1,j_wid1,j_b_thx],center=false);
            
            // Back wall of 4P4C jack
            translate([j_len,0,0])
                cube([j_w_thx,j_wid1,ht1],center=false);
            
            // Top wall of 4P4C jack
            translate([-j_lenb,j_wid,0])
                cube([j_len1+j_lenb,j_w_thx,ht1],center=false);
            
            // Cap mount post
            ofx2 = j_len + j_w_thx;
            ofy2 = j_wid - jp_wid;
            translate([ofx2, ofy2, 0])
                cube([jp_len,jp_wid,ht1],center=false);

				// Support under small ridge under entrance
				translate([-j_lenb,0,0])
					cube([j_lenb+0.05,j_wid1,j_htb],center=false);

        }
        union()
        {
				// Jack index holes
            translate([j_len-j_hx1,j_wid-j_hy1,-.1])
                cylinder(d=j_hd, h=10,center=false);

            translate([j_hx2,j_hy2,-.1])
                cylinder(d=j_hd, h=10,center=false);

				// Cap screw hole
				ofx3 = j_len1 - jp_len/2;
				ofy3 = j_wid - jp_len/2;
				translate([ofx3,ofy3,-0.1])
        	   	cylinder(d=j_cd, h=20,center=false);
		}
    }  
 } 
}		

t_hole = 3.4;
t_hole_ofx = 3;
module tab_hole(dx,dy)
{
    translate([dx,dy,0])
        cylinder(d=t_hole,h=20,center=false);
}

jb_thx = 1.5;
jb_ht = 12.0;
j_ofx = 8;

module tbase()
{
	difference()
    {
        union()
        {
            // tab base that mounts to potentiometer bar
            cube([t_len,t_wid,t_thx],center=false);  
        }
        union()
        {
            // Holes to mount on potentiometer bar
            tab_hole(t_hole_ofx,t_wid-t_hole_ofx,0);
            tab_hole(t_len-t_hole_ofx,t_hole_ofx,0);
        }
    }
}

/* Cap to hole 4P4C jack */
jc_ovr = 2;						// Overlap at edges
jc_len = j_len1 + j_lenb + jc_ovr*2; // Overall length
jc_wid = j_wid +jc_ovr*2;	// Overall length
jc_ht  = 4;						// Overall thickness
jc_thx = jc_ht - j_rdg;		// Ridge thickness
jc_screw_d = 3.5;				// Screw hole

module jcap()
{
ofx0 = j_len1/2 - j_lenb/2;
ofy0 = j_wid1/2;


    difference()
    {
        union()
        {
            // "Base" (top) of cap
				translate([-jc_len/2,-jc_wid/2,0])
	            cube([jc_len,jc_wid,jc_ht],center=false);
        }
        union()
        {
				translate([-.25,-.25,ht1 + jc_thx])
					rotate([180,0,])
						jbase();

				translate([.25,.25,ht1 + jc_thx])
					rotate([180,0,])
						jbase();


				/* Punch a screw hole */
				ofx3 = j_len1 - jp_len/2 - ofx0;
				ofy3 = -j_wid/2 + jp_wid/2 + 1 ;
				translate([ofx3,ofy3,-0.1])
        	   	cylinder(d=jc_screw_d, h=20,center=false);


        }
    }
}

module total()
{
    difference()
    {
        union()
        {
            jbase();
        }
        union()
        {
 
        }
    }
}
total();
//translate([40,0,0]) jbase();
translate([0,50,0]) jcap();
