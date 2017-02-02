/* File: PODboardframe.scad
 * Author: deh
 * Latest edit: 2017012418.12
 */
 $fn=10;
 
 // Inside dimensions of Plano box
 plano_len          = 152.5;   // flat-flat
 plano_wid          =  75.7;   // flat-flat
 
 // Stud magnet relative postions.
 // Bottom magnet is on center-line and x,y reference is 0,0
 plano_mag_top_x  = 30.5;     // Top pair x +/- from center-line (C/L)
 plano_mag_top_y  = 138.69;   // Top pair y from bottom magnet hole
 plano_mag_top_ofs = 10;    // Top mags to top edge of PC board max
 
 plano_offs_mag_y   = 4;    // Offset from edge for magnet hole
 plano_offs_mag_x   = 4;    // Offset from edge for magnet hole
 plano_ctr_y    = (plano_len/2);
 plano_ctr_x    = (plano_wid/2);
 plano_mag_stud = 2.8;  // Dia of mounting magnet studs (4-40)
 
 // POD board
 pod_wid=76.5;  // Overall width
 pod_len=89.4;  // Overall length
 
 RJ_offset=24.8; // Side of RJ45 jack from edge
 RJ_wid=15;      // Width of RJ 45 jack
 RJ_depth=14.5;  // Bottom of POD pc board to bottom of RJ45
 RJ_length=14;  // Front-Back length
 
 // CAN sub-board module
 sub_wid      = 33.75;  // Overall width
 sub_len      = 62.9;   // Overall lengh
 sub_mtg_wid  = 26.6;   // Between mounting holes, width
 sub_mtg_len  = 57.0;   // Between mounting holes, length 
 
 // Switcher module
 sw_wid =   20.3;   // Overall width
 sw_len =   41.2;   // Overall length
 sw_mtg_off_out_y   = 5.56; // Offset from edge "out" mounting hole 
 sw_mtg_off_out_x   = 2.7;  // Offset from edge "out" mounting hole 
 sw_mtg_off_in_y    = 3.1;  // Offset from edge "in" mounting hole
 sw_mtg_off_in_x    = 6.0;  // Offset from edge "in" mounting hole
 
 // RJ jack
 rj_grv =  4.0;  // Groove Depth 
 rj_ht  = 14.2;  // Groove Length
 rj_wid = 14.2;  // Groove Height
 
 // Post ridge
 p_ridge = 1.5; // Height of ridge to position PC board on post
 p_offset = 2;  // Offset of ridge from edge of post
 
 // Pod post
 pod_post_ht = (RJ_depth + 1);
 pod_post_y = 9;    // Length in "y" (long/length) box direction)
 pod_post_x = 6;    // Length in "x" (short/width) box direction)
 pod_post_z = 1.55; // Height of ridge
 pod_post_q = 1.5;  // Width of ridge
 pod_post_s = 2;    // Screw hole dia
 pod_post_sd = 4;   // Screw hole depth
 
 // Web 
 web_thick  = 2.0;  // Thickness of the web between posts
 web_wid_x  = pod_post_x;    // Width of web
 web_wid_y  = pod_post_ht;   // Height of web
 
 // Some computed values
 pc_cornerx =  (pod_wid/2) + p_offset;  // PC board corner
 pc_cornery =      pod_len + p_offset;
 
// Post with recess for corner of POD board
 module pod_post()
 {
     difference()
     {
         union()
         {
            cube([pod_post_x, pod_post_y, pod_post_ht + p_ridge],false);
            cube([pod_post_y, pod_post_x, pod_post_ht + p_ridge],false);
         }
         union()
         {
            // Self tapping screw hole
            translate([1.5, 1.5, 14])
                cylinder(h = pod_post_sd, r1 = 0, r2 = pod_post_s, center = false);
            // Cut-out for corner of PC board
            translate([p_offset, p_offset, pod_post_ht])
                cube([ pod_post_x - p_offset, pod_post_y-p_offset, p_ridge],false);
            translate([p_offset, p_offset, pod_post_ht])
                cube([ pod_post_y - p_offset, pod_post_x-p_offset, p_ridge],false);
         }
     }        
 }

  module pod_4posts()
 {
//    translate ([-pc_cornerx,      0, 0]) rotate(  0) pod_post();
    //translate ([ pc_cornerx,      0, 0]) rotate( 90) pod_post();
    translate ([-pc_cornerx,pc_cornery, 0]) rotate(-90) pod_post();
    translate ([ pc_cornerx,pc_cornery, 0]) rotate(180) pod_post();

 }
 
 module web(length)
 {
     cube([length, web_thick, web_wid_y]);
     cube([length, web_wid_x, web_thick]);     
 }
 
 
 module frame_pod()
 {
     union()
     {
        pod_4posts();
/*        translate([-pc_cornerx,      0, 0])
            web(pc_cornerx * 2);
*/         
        translate([pc_cornerx, pc_cornery, 0])
            rotate(180)
                web(pc_cornerx * 2);
        translate([-pc_cornerx, pc_cornery, 0])
            rotate(-90)
                web(pc_cornery);
        translate([ pc_cornerx, 0, 0])
            rotate( 90)
                web(pc_cornery);
        translate([ pc_cornerx - RJ_offset, 0, 0])
            rotate( 0)
                web(RJ_offset);  
         translate([ -pc_cornerx , 0, 0])
            rotate( 0)
                web(pod_wid - RJ_offset - RJ_wid);
     


     }
 }

  module plano_mag_tabs()
 {
     mag_tab(); // Bottom mag, reference is 0,0,0
     
     translate([ (plano_mag_top_x + plano_wid/2),
                 plano_mag_top_y + plano_mag_top_x,
                0])
                mag_tab();
     translate([-(plano_mag_top_x + plano_wid/2),
                 plano_mag_top_y + plano_mag_top_x,
                0])
                mag_tab();
} 
 module mag_tab()
 {
     difference() // Tabs around magnet holes
     {
         cylinder(2, 5, 5, false);
         cylinder(3, plano_mag_stud/2,plano_mag_stud/2, false);
     }
 }
 module wedge_side(l, w, h)
 {
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
 }
 
 module mag_tab_end() // Tabs at top end
 {
     {   union()
         {
             difference()
             { 
                 union()
                 {
                    width_flat = 10;
                    wedge_side = 16;
                    translate([-width_flat/2,-15,0])
                    cube([width_flat,15,2],false);
                    cylinder(2, 5, 5, false);
                    translate([-width_flat/2+2,0,0])
                    rotate(180,0,0)wedge_side(2,wedge_side,pod_post_ht);
                    translate([ width_flat/2,0,0])
                    rotate(180,0,0)wedge_side(2,wedge_side,pod_post_ht);
                 }
                 cylinder(3, plano_mag_stud/2,plano_mag_stud/2, false);
             }
         }
     }
 }
 module mag_tab_1()
 {
         translate([ plano_mag_top_x,
                 plano_mag_top_y,
                0])
                rotate([0,0,-25])mag_tab_end();
         translate([-plano_mag_top_x,
                 plano_mag_top_y,
                0])
                rotate([0,0,25])mag_tab_end();
     
 }
module RJ45box()
 {
        rjy = RJ_length + web_thick;
        rotate(90) web(rjy);
        translate ([RJ_wid, rjy, 0]) 
            rotate(-90) web(rjy); 
        translate([0, RJ_length, 0]) web(RJ_wid+4); // Back
 }

module frame_w_RJ45box()
{
	translate([0,0,0])
            frame_pod();
        translate([0,0,0])RJ45box();  
 
         mag_tab_1();            

}
 

 module frame_total()
 {
	// Position frame near top of plano box
	frame_total_y = plano_mag_top_y + plano_mag_top_ofs - pc_cornery;
	translate([0,frame_total_y,0])
	   frame_w_RJ45box();
 }
 
 frame_total();
