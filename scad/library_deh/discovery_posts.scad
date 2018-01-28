/* File: discovery_posts.scad
 * ST Discovery board mounting posts
 * Author: deh
 * Latest edit: 20180126test
 */


//include <../library_deh/deh_shapes.scad>
//include <../library_deh/deh_shapes2.scad>
include <../library_deh/angled_posts.scad>
include <../library_deh/ridged_screw_hole.scad>
//include <../library_deh/Plano_frame.scad>

/* Discovery board dimensions */
disc_wid = 65.9 + 0.5;  // Overall width
disc_len = 97.3 + 0.5;  // Overall length
disc_thick = 2.0;

brd_theta = 6.0;	// Slope of board
brd_ht = 8.0; // Height of low end bottom of board from bottom of post

/* ***** angled_post_bottom ***********
 * Angled notch is upward pointing
 * wid = width (x direction)
 * len = length (y direction)
 * theta = angle: pcb
 * ht  = height of ledge at bottom corner of pcb
 * rdg = pcb board thickness
 * ldg = pcb ledge width
 * clht= clip height (overhang vertical height)
 * sigma = added angle of upper overhang
 * NOTE: theta+sigma must be > 40 degrees w/o support structures
 * NOTE: x,y (0,0) reference is lower end at inside ridge wall
 */
/* **** Bottom post common dimensions ****** */
bot_wid = 4;
bot_rht = disc_thick;
bot_ldg = 1.5;
bot_rwdy = 2.0;
bot_clen = 4;
bot_sig = 50 - brd_theta;

bot_ofs_x = 8;	// Offset from centerline
bot_len = 8;

/* **** bottom_post******************
 * len = length in x direction
 * xofs = x axis offset of right side of post 
 */
module bottom_post(len,xofs)
{
    translate([xofs,0,0])
	rotate([0,0,90])
//angled_post_bottom(      4,   8,       25,     5,         2,    2.5,       4,      20);  // Test
//                      (wid, len,    theta,    ht,       rdg,    ldg,    clht,  sigma)
  angled_post_bottom(bot_wid, len,brd_theta,brd_ht,disc_thick,bot_ldg,bot_clen,bot_sig);
}

/* ***** angled_post_side_right ***********
 * wid = width (x direction)
 * slen = slant length
 * theta = angle
 * ht1 = height at shortest end at ledge
 * rdg = ridge height
 * ldg = pcb ledge width
 * NOTE: x,y (0,0) reference is lower end at inside ridge wall
 */

/* Common dimensions of side posts */
sid_wid = 4;
sid_rdg = 2;
sid_ldg = 2;

module side_post(len,yofs)
{
	sid_ht1 = brd_ht + yofs * sin(brd_theta);
	xofs = disc_wid/2;
	translate([-xofs,yofs,0])
angled_post_side_right(sid_wid,sid_slen,brd_theta,sid_ht1,sid_rdg,sid_ldg);
}

/* ***** angled_post_ridged_corner ***********
* xlen = x axis direction length
* ylen = y axis direction length
* zlen = z axis, height to ledge
* tpht = slant height of cocked top
* rht  = ridge thickness
* rwdx = ridge width, x directions
* rwdy = ridge width, y directions
* scd1 = screw diameter at top
* scd2 = screw diameter at bottom of screw
* sch  = screw hole height
* scofx = screw hole center offset from inside ridge corner, x
* scofy = screw hole center offset from inside ridge corner, y
 */

module top_corner_post()
{
	xofs = disc_wid/2;		// Position from bottom of board
	xlen = 6;	ylen = 12; 
	zlen = brd_ht + disc_len * sin(brd_theta);	// Height at top position
	tpht = 4;	rht = 2.0;	// Slant post height; ridge thickness
	rwdx = 3.75;	rwdy = 4;	// Ridge widths
	scd1 = 3.2;	scd2 = 2.2; sch = 4;	// Screw dimensions top dia, bot dia, depth
	scofx = -1.5; scofy = -2.0;	// Screw positioning from inside ridge corner

	translate([xofs,disc_len,0])
	rotate([0,0,180])
//                        xlen, ylen,theta,zlen,tpht, rht,rwdx,rwdy,scd1,scd2,sch,scofx,scofy
//                          (6,   12,  15,   8, 3.5,1.5,   5,   4, 3.2, 2.2,  4, -1.5, -2.0); // Test
angled_post_ridged_corner(xlen,ylen,brd_theta,zlen,tpht,rht,rwdx,rwdy,scd1,scd2,sch,scofx,scofy);
}

/* *** discovery_posts_angled ******
 * ht = height: bottom pcb edge to platform at low end
 * theta =	Angle (slope) of Discovery board
 * ysideofs = low end side pair: y offset
 * ysidelen = low end side pair: length
 * NOTE: x centered, y = 0 is bottom 
 */
/* Bottom pair of posts */
bot_ofs_x = 8;	// Offset from centerline
bot_len = 8;

/* Side pair of posts */
sid_slen = 10;
sid_yofs = 15;

module discovery_posts_angled()
{
	bottom_post(bot_len,-bot_ofs_x);       	// Bottom left
	bottom_post(bot_len, bot_ofs_x+bot_len);  // Bottom right

	side_post(sid_slen,sid_yofs);		// Left side
	mirror([1,0,0])
		side_post(sid_slen,sid_yofs);	// Right side

	top_corner_post();

	mirror([1,0,0])
		top_corner_post();
}
module post_test()
{
		discovery_posts_angled();	// Test
}
//post_test();
