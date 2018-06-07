/* File: sphoseadapt.scad
 * Sump Pump hose adaptor: flex hose to 1 1/4" PVC
 * Author: deh
 * Latest edit: 20180601
 * 
 */

include <../library_deh/deh_shapes.scad>
include <../library_deh/Plano_frame.scad>
include <../library_deh/fasteners.scad>
include <../library_deh/ridged_screw_hole.scad>

 $fn=100;

w = 2.5;          // Wall thickness
flx_d1 = 35.5;	 // Flex hose end goes inside flex hose
flx_d2 = 33.5;
flx_ht = 25;
pvc_d2 = 41.0+w;	// PVC end goes around outside of pvc pipe
pvc_d1 = 42.0+w;
pvc_ht = 25;
mid_ht = 6;

module trans()
{
mid = [0,0,pvc_ht];
mid2= [0,0,pvc_ht+mid_ht];
mid3= mid2 + [0,0,flx_ht];
	difference()
	{
		union()
		{
			cylinder(d1=pvc_d1,d2=pvc_d2,h=pvc_ht,center=false);
			translate(mid)	
				cylinder(d=pvc_d2,h=mid_ht,center=false);
			translate(mid2)
				cylinder(d1=pvc_d2,d2=flx_d1,h=flx_ht,center=false);
			translate(mid3)
				cylinder(d1=flx_d1,d2=flx_d2,h=flx_ht,center=false);
		}

		union()
		{
			cylinder(d1=pvc_d1-w,d2=pvc_d2-w,h=pvc_ht,center=false);
			translate(mid)
				cylinder(d=pvc_d2-w,h=mid_ht,center=false);
			translate(mid2)
				cylinder(d1=pvc_d2-w,d2=flx_d1-w,h=flx_ht,center=false);
			translate(mid3)
				cylinder(d1=flx_d1-w,d2=flx_d2-w,h=flx_ht,center=false);
		}
	}
}
trans();
