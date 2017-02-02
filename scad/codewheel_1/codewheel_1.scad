/* Code wheel for fairlead sheave
 * Date: 20170116
 * codewheel_1
 */
 
 dia_center_hole = (2.8); // Center mounting hole
 thick_center_hole = (4.6); // Thickness at center hole
 dia_magtop = (14.0);  // Diameter flat of magnet top

 dia_taper = (30); // Diameter where taper ends
 nsegs = 6;  // Number of segments
 
 thick_1st_step = (2.4); // 
 dia_1st_step = (60.5);
 
 thick_seg = (1.5);   // Thickness at segments
 dia_seg = (50);    // Outer dia of segments
 dia_overall = (dia_seg + 3);
 thick_rim = (thick_seg + 1); // Rim slightly thicker
 
 timingHoles = 10;
 encoderDiameter = 40;
 
 outer_rim_dia = 80;  
 thick_outer_rim = thick_seg;
 width_outer_rim = 1;
 
 quant = 100;
 $fn = quant; // Quantization

module center_hole()
{
    cylinder(h = thick_center_hole, d = dia_center_hole, center = false);
}

module center_post()
{
    cylinder(h = thick_center_hole, d = dia_magtop, center = false);
}

module first_step()
{ 
        cylinder(h = thick_1st_step, d = dia_1st_step, center = false);
}

module segs()
{
    cylinder(h = thick_seg, d = dia_seg, center = false);
}

module outer_rim()
{   
    render()
    {
    difference() {
        cylinder(h = thick_outer_rim, d = outer_rim_dia, center = false);
        cylinder(h = thick_outer_rim, d = outer_rim_dia - width_outer_rim, center = false);
    }
}
}

module arc( height, depth, radius, degrees ) {
	// This dies a horible death if it's not rendered here 
	// -- sucks up all memory and spins out of control 
	render() {
		difference() {
			// Outer ring
			rotate_extrude($fn = quant)
				translate([radius - height, 0, 0])
					square([height,depth]);
		
			// Cut half off
			translate([0,-(radius+1),-.5]) 
				cube ([radius+1,(radius+1)*2,depth+1]);
		
			// Cover the other half as necessary
			rotate([0,0,180-degrees])
			translate([0,-(radius+1),-.5]) 
				cube ([radius+1,(radius+1)*2,depth+1]);	
		}
	}
}

	// Punch out timing holes	
//D_arc(w=thickness_of_arc, r=radius_of_arc, deg=degrees_of_arc_angle, fn=resolution, h=height_of_arc);
module timing_holes()
{
        for ( i = [0 : timingHoles-1] ) {
            rotate( i*(360/timingHoles), [0, 0, 1])
			arc( 10,  /* Height */
			thick_seg, /* Depth */
			encoderDiameter, /* Radius */
			degrees =180/timingHoles); /* Degrees */
	}
}            
            
module main()
{
    difference()
    {
        union()
        {
            center_post();
            first_step();
            segs();
            timing_holes();
            outer_rim();
        }
           center_hole();
        
        
    }
    
}
main();
