/* File: tank_fitting.scad
 * Author: c. wells
 * Date made: 20160814.2300
 * Last edit: 20160816.1330
 */

function i2m(i) = i * 25.4; // Inches to millimeters

base_h  = i2m(0.1875);      // Base height
base_d  = i2m(1.2500);      // Base diameter

mounting_d = i2m(0.132);    // Mount hole inside diameter
mounting_r = i2m(0.390);    // Radius to center of mount hole

post_od = i2m(0.375);       // Post outside diameter
post_id = i2m(0.125);       // Post inside diameter
post_h  = i2m(1.250);       // Post height
post_er = i2m(0.100);       // Post edge rounding radius

barb_o  = i2m(0.250);       // Barb offset from top of post
barb_h  = i2m(0.050);       // Barb height
barb_w  = i2m(0.025);       // Barb width

ring_h  = i2m(0.100);       // Base ring height
ring_w  = i2m(0.100);       // Base ring width

$fn = 100;                  // Quantization count

// Modules for various parts
//
module base()
{
    cylinder(h = base_h, 
             d = base_d,
             center = false);
}

module post()
{
    union()
    {
        translate([0, 0, post_er])
            minkowski()
            {
                sphere(post_er);
                        cylinder(h = post_h - 2.0 * post_er, 
                                 r = post_od/2 - post_er,
                                 center = false);
            }
        
        translate([0, 0, post_h - barb_o - 1.0 * barb_h])
            cylinder(h = barb_h,
                     r1 = post_od/2 + barb_w,
                     r2 = post_od/2,
                     center = false);

        translate([0, 0, post_h - barb_o - 2.0 * barb_h])
            cylinder(h = barb_h,
                     r1 = post_od/2,
                     r2 = post_od/2 + barb_w,
                     center = false);

        translate([0, 0, base_h])
            cylinder(h = ring_h,
                     r1 = post_od/2 + ring_w/2,
                     r2 = post_od/2,
                     center = false);
    }
}

module center_hole()
{
    cylinder(h = post_h * 2.0,
             d = post_id, 
             center = true);
}

module mount_hole(angle)
{
    rotate(a = angle)
        translate([mounting_r, 0, 0])
            cylinder(h = i2m(100.0),
                     d = mounting_d, 
                     center = true);
}

// "main" construction
//
module main()
{
    union()
    {
        difference()
        {
            union()                 // Structure
            {
                base();
                post(post_od, post_h);
            }
            union()                 // Holes
            {
               center_hole(post_id);
               mount_hole(  0);
               mount_hole(120);
               mount_hole(240);
            }
         }
    }
}

main();                             // Create the entire gizmo
