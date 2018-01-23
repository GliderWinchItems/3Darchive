/*
file: ridged_screw_hole.scad
2018 01 18
*/
/*
All results are translated so that inside edges of the ridges are aligned with the axis, so a 
square or rectangle will have the corner centered on the x,y origin.

Modules----
module ridged_rectangle(xlen,ylen,zlen,rht,rwdy)
module corner_ridged_rectangle(xlen,ylen,zlen,rht,rwdx,rwdy)
module corner_ridged_square(slen,zlen,rht,rwds)
module corner_ridged_square_w_screw(slen,zlen,rht,rwds,scd1,scd2,sch,scofx,scofy)
module corner_ridged_rectangle_w_screw(xlen,ylen,zlen,rht,rwdx,rwdy,scd1,scd2,sch,scofx,scofy)
module ridged_rectangular_w_clip(xlen,ylen,zlen,rht,rwdy,clen)
*/

include <deh_shapes.scad>

/*  ***** ridged_rectangle *****
* xlen = x axis direction length
* ylen = y axis direction length
* zlen = z axis, height to ledge
* rht  = ridge thickness
* rwdy = ridge width, y direction
* NOTE: to convert from right orientation use
* mirror([1,0,0]) for left orientation
*/
module ridged_rectangle(xlen,ylen,zlen,rht,rwdy)
{
	corner_ridged_rectangle(xlen,ylen,zlen,rht,0,rwdy);
}

/*  ***** corner_ridged_rectangle *****
* xlen = x axis direction length
* ylen = y axis direction length
* zlen = z axis, height to ledge
* rht  = ridge thickness
* rwdx = ridge width, x direction
* rwdy = ridge width, y direction
*/
module corner_ridged_rectangle(xlen,ylen,zlen,rht,rwdx,rwdy)
{
    cx = rwdx; cy = -rwdy;
    translate([-cx,cy,0])
    {
        difference()
        {
            union()
            {
                zht1 = (zlen+rht);
                cube([xlen,ylen,zht1],center=false);
            }
            union()
            {
                zht2 = rht+0.1;
                translate([rwdx,rwdy,zlen])
                    cube([xlen,ylen,zht2],center=false);
            }
        }
    }        
}

/*  ***** corner_ridged_square_w_screw *****
* slen = length x & y axis directions
* zlen = z axis, height to ledge
* rht  = ridge thickness
* rwds = ridge width, x & y directions
*/
module corner_ridged_square(slen,zlen,rht,rwds)
{
    corner_ridged_rectangle(slen,slen,zlen,rht,rwds,rwds);
}

/*  ***** corner_ridged_square_w_screw *****
* slen = length x & y axis directions
* zlen = z axis, height to ledge
* rht  = ridge thickness
* rwds = ridge width, x & y directions
* scd1 = screw diameter at top
* scd2 = screw diameter at bottom of screw
* sch  = screw hole height
* scofx = screw hole center offset from inside ridge corner, x
* scofy = screw hole center offset from inside ridge corner, y
*/
        //corner_ridged_square_w_screw(  10,  5, 1.5,  4,  3.2,  1.2,  3,  -1.4,  -1.4  ); // test
module corner_ridged_square_w_screw(slen,zlen,rht,rwds,scd1,scd2,sch,scofx,scofy)
{
    difference()
    {
        corner_ridged_square(slen,zlen,rht,rwds);
        
        translate([0,0,zlen-sch+rht+.01])
            ridge_screw_hole_square(slen,rwds,rwds,scd1,scd2,sch,scofx,scofy);
    }
}

/*  ***** corner_ridged_rectangle_w_screw *****
* xlen = x axis direction length
* ylen = y axis direction length
* zlen = z axis, height to ledge
* rht  = ridge thickness
* rwdx = ridge width, x directions
* rwdy = ridge width, y directions
* scd1 = screw diameter at top
* scd2 = screw diameter at bottom of screw
* sch  = screw hole height
* scofx = screw hole center offset from inside ridge corner, x
* scofy = screw hole center offset from inside ridge corner, y
*/
//translate([20,0,0])
//                                xlen ylen zlen rht dx dy   scd1 scd2  sch  scofx scofy
//corner_ridged_rectangle_w_screw(6,  12,    5, 1.5, 5, 4,    3.2, 2.2,   4,  -1.5,  -2.0); // Test right
//translate([-6,0,0])
//corner_ridged_rectangle_w_screw(6,  12,    5, 1.5, -3, 4,    3.2, 2.2,   4,  -1.5+6,  -2.0); // Test left
module corner_ridged_rectangle_w_screw(xlen,ylen,zlen,rht,rwdx,rwdy,scd1,scd2,sch,scofx,scofy)
{
    difference()
    {
        corner_ridged_rectangle(xlen,ylen,zlen,rht,rwdx,rwdy);
        
        translate([0,0,zlen-sch+rht+.01])
            ridge_screw_hole_rectangle(xlen,ylen,rwdx,rwdy,scd1,scd2,sch,scofx,scofy);
    }
}
/*
* xlen = x axis direction length
* ylen = y axis direction length
* rwdx = ridge width, x directions
* rwdy = ridge width, y directions
* scd1 = screw diameter at top
* scd2 = screw diameter at bottom of screw
* sch  = screw hole height
* scofx = screw hole center offset, x
* scofy = screw hole center offset, y
*/
module ridge_screw_hole_rectangle(xlen,ylen,rwdx,rwdy,scd1,scd2,sch,scofx,scofy)
{
    hx =  scofx;
    hy =   scofy;
//echo("R","rwdx",rwdx,"rwdy",rwdy);
//echo("R","scofx",scofx,"scofy",scofy,"hy",hy,"hx",hx);
    translate([hx,hy,0])
        cylinder(d1=scd2,d2=scd1,h=sch,center=false,$fn=25);    
}

module ridge_screw_hole_square(slen,rwdx,rwdy,scd1,scd2,sch,scofx,scofy)
{
    ridge_screw_hole_rectangle(slen,slen,rwdx,rwdy,scd1,scd2,sch,scofx,scofy);
}

/*
pst_ldg = 6 + bfthick;	// Height of pc board ledge from bottom
pst_wid = 3;	// Width of post
pcb_thick = 2.0;	// Thickness of pcb
clip_ht = 3;
pst_w2 = 1;	// Width where pcb contacts edge
*/

/*  ***** ridged_rectangular_w_clip *****
* xlen = x axis direction length
* ylen = y axis direction length
* zlen = z axis, height to ledge
* rht  = height of ridge (pcb thickness)
* rwdy = ridge width, y direction
* clen = clip length
* Orientation: ridge runs in y-axis direction 
* Note: ledge with is (xlen - rwdy)
*/
//         ridged_rectangular_w_clip(  3,  15,   5, 1.5, 1,   3 );	// Test
module ridged_rectangular_w_clip(xlen,ylen,zlen,rht,rwdy,clen)
{
	corner_ridged_rectangle(xlen,ylen,zlen,rht,rwdy,0);

	// Clip overhang
	cofsx = clen - rwdy;	// Offsets for wedge
 	cofsy = ylen;
	cofsz = zlen+rht+clen - rwdy;
	translate([cofsx,cofsy,cofsz])
		rotate([0,180,0])
		rotate([0,0,-90])
		wedge(ylen,clen,clen);

}
