/* File: 001/tesseract.scad -- A bit of silliness.
 * Author: c. wells
 * Date made: 20160819.2300
 * Last edit: 20160920.2317
 */

/* tesseract.scad file dimensions are in inches,
 * tesseract.stl file dimensions are in millimeters
 */
function i2m(i) = i * 25.4; // Inches to millimeters

// Global parameters
//
outside_l = i2m(1.500);     // Outside length
inside_l = outside_l / 2;   // inside length
edge_t = i2m(0.150);        // Bar thickness

module centered_cube(sizes) {
    cube(size = sizes, center = true);
}

module cube_frame(edge_l, edge_t) {
    ll = edge_l;
    ls = edge_l - 2.0 * edge_t;
    
    difference() {
        cube(size = ll, center = true);
        union() {
            centered_cube([ll, ls, ls]);
            centered_cube([ls, ll, ls]);
            centered_cube([ls, ls, ll]);
}   }   }

module diaganol(x_dir, theta) {   // Diaganol
    l1 = outside_l / 2;
    l2 = sqrt(2) * l1;
    l3 = sqrt(3) * l1;
    l3m = l3 - 2 * edge_t;

    rotate([theta, 0, 0])
        rotate([45, 0, 0])
            rotate([0, 0, atan(l2 / l1)])
                translate([x_dir * (l3 / 2), 0, 0])
                    centered_cube([l3m, edge_t, edge_t]);
} 

module tesseract() {
    in_l = inside_l - 2 * edge_t;
    
    difference() {
        union() {
            cube_frame(outside_l, edge_t);
            cube_frame(inside_l,  edge_t);
            diaganol(+1,   0); diaganol(-1,   0);
            diaganol(+1,  90); diaganol(-1,  90);
            diaganol(+1, 180); diaganol(-1, 180); 
            diaganol(+1, 270); diaganol(-1, 270);
        }
        union() {
            centered_cube([inside_l, in_l, in_l]);
            centered_cube([in_l, inside_l, in_l]);
            centered_cube([in_l, in_l, inside_l]);
        }
    }
    
    translate([-6, -outside_l / 2 + 1, outside_l / 2])
        scale([0.25, 0.25, 1.0])
            linear_extrude(height = 1, size = 5, center = true)
                text("CAW-001");
    
    translate([-7, +outside_l / 2 - 3, outside_l / 2])
        scale([0.25, 0.25, 1.0])
            linear_extrude(height = 1, size = 5, center = true)
                text("Tesseract");
}

module main() {
 //     rotate([45, 45, 0])     // Orientation
            tesseract();        // Render the whole tesseract
}

main();
