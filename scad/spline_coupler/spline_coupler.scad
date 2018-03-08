/* File: spline_coupler.scad
 * Coupler for splined shaft
 * Author: deh
 * Latest edit: 20180225
 */


 $fn=100;
 
 big = 50;  // Big number

iod = 25.0; // Shaft od (inside dia of coupler)
sp_wid = 1; // Spline tooth width
sp_dep = 1.5; // Spline tooth depth
number_teeth = 24;
sp_ht = 31.1-10.0-6.1; // Height of splined partion

cp_od = iod + 8; // Coupler outer dia
cp_ht = sp_ht + 15; // Height (length) of coupler

module spline_shaft()
{
    ofs_r = iod/2 - sp_dep;
    difference()
    {
        cylinder (d=iod, h = sp_ht, center=false);
        
        union()
        {
            step = 360/number_teeth;
            for (i = [step : step : (360 + .01)])
            {
                rotate([0,0,i])
                translate([-sp_wid/2,ofs_r,-0.05])
                    cube([sp_wid,big,big],center=false);    
            }
        }
    }
}

// difference a cylinder with the spline shaft
module coupler()
{
    difference()
    {
            union()
            {
                cylinder(d=cp_od, h=cp_ht, center=false);
            }
            union()
            {

                ofs_x = cp_ht-sp_ht+.01;
                translate([0,0,ofs_x])
                    spline_shaft();
            }  
    }
}

// Add a chamfer to the coupler
module coupler_chamfered()
{
    difference()
    {
        coupler();
        
        translate([0,0,cp_ht-4])
            cylinder(d1=iod-sp_dep*2,d2=cp_od+12 ,h=15,center=false);
    }
}

drv_wid = 13;	// Width of square socket drive

module total()
{
	difference()
	{
		coupler_chamfered();

		cube([drv_wid,drv_wid,big],center=true);
	}
} 
total();

