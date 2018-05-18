/* File: mod4pjack.scad
 * Jameco 2151560 4P4C jack mount
 * Author: deh
 * Latest edit: 20180516
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=50;

j_wid = 14.0;
j_len = 10.5;
j_thx = 3;
j_hd = 1.88 + 0.3;	// Index hole dia
j_hx1 = 4.8;
j_hy1 = 12.4;
j_hx2 = 9.2;
j_hy2 = 2.7;

t_wid = 16;
t_len = 27;
t_thx = 2;

module jbase()
{
	difference()
    {
        union()
        {
            cube([j_len,j_wid,j_thx],center=false);
        }
        union()
        {
            translate([j_hx1,j_hy1,0])
                cylinder(d=j_hd, h =j_thx,center=false);

            translate([j_hx2,j_hy2,0])
                cylinder(d=j_hd, h =j_thx,center=false);
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

jp_len = 7;
jp_wid = 7;

module tbase()
{
	difference()
    {
        union()
        {
            // tab base that mounts to potentiometer bar
            cube([t_len,t_wid,t_thx],center=false);

            // Position 4P4C jack base on tab base
            translate([j_ofx,0,t_thx]) jbase();
            
            // Back wall of 4P4C jack
            ofx = j_ofx + j_len;
            translate([ofx,0,t_thx])
                cube([jb_thx,j_wid,jb_ht],center=false);
            
            // Top wall of 4P4C jack
            ofx1 = j_ofx;
            ofy1 = j_wid;
            translate([ofx1,ofy1,t_thx])
                cube([j_len+jb_thx,jb_thx,jb_ht],center=false);
            
            // Cap mount post
            ofx2 = ofx1 + j_len + jb_thx;
            ofy2 = ofy1 - jp_wid + jb_thx;
            translate([ofx2, ofy2, t_thx])
                cube([jp_len,jp_wid,jb_ht],center=false);
            
        }
        union()
        {
            // Holes to mount on potentiometer bar
            tab_hole(t_hole_ofx,t_wid-t_hole_ofx,0);
            tab_hole(t_len-t_hole_ofx,t_hole_ofx,0);
        }
    }

}
jc_len = jp_len + jb_thx + j_len +j_thx;
jc_wid = j_wid + jb_thx + jb_thx;
jc_ht = 4;
jc_thx = 2;

module jcap()
{
    difference()
    {
        union()
        {
            
            cube([jc_len,jc_wid,jc_ht],center=false);
        }
        union()
        {
            ofz = jb_ht + jb_thx + jc_thx;;
            translate([-jp_len,+t_wid,ofz])
            rotate([180,0,0])
                tbase();
            
            translate([15.5,4,0])
                cylinder(d=3.5,h=20,center=false);
        }
    }
}

module total()
{
    difference()
    {
        union()
        {
            tbase();
        }
        union()
        {
            ofx2 = j_ofx + j_len + jb_thx + jp_len/2;
            ofy2 = j_wid - jp_wid/2 + jb_thx;
            translate([ofx2,ofy2,jb_ht-10])
                cylinder(d=2.8,h=12,center=false);
        }
    }
}
total();

translate([0,50,0]) jcap();