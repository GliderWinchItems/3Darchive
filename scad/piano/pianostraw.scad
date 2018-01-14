 /* File: pianostraw.scad
 * Vaccum adapter straws to vacuum between strangs
 * Author: deh
 * Latest edit: 20180113
 */
 
 $fn = 100;
 
 wall = 3;
 Q = 0.5;
vac_od1 = 33.9+Q;     // OD at mouth
vac_od2 = 34.7+Q;     // OD at further up

straw_dia = 6.5; // Diameter of polypropylene straw
straw_base = 5; // Thickness of straw header


string_space = 5.27; // Space between two groups-of-three strings
string_ht = 1.25*25.4; // Distance from top of string to top of sound board

 Q = -0.5;
vac_od1 = 33.9+Q;     // OD at mouth
vac_od2 = 34.7+Q;     // OD at further up


lng = 60;   // Length

ht1 = 30;
ht2 = 10;

 module vac_tube()
 {
     difference()
     {
        cylinder(d1 = vac_od2+wall, d2 = vac_od1+wall, h = ht1, center = false);
        cylinder(d1 = vac_od2,      d2 = vac_od1,      h = ht1, center = false);
     }  
 }

 module straw_hdr()
 {
     difference()
     {  // elliptical disc
        scale([1.20,0.4,1])
           cylinder(d = vac_od1+wall-.5, ht = straw_base, center=false);
         
         union()
         { // Straw holes 
             aa = 0;
             astep = straw_dia + 2;
             for(aa = [-astep*1-astep/2 : astep : astep*2])
             {
                translate([aa,0,-0.1])
                    cylinder(d = straw_dia, h = straw_base+5, center=false);
             }
         }
     }
 }
 
 /* 
 https://stackoverflow.com/questions/19527948/morph-circle-to-oval-in-openscad
 solid */
  Delta=0.01;
    module connector (height,radius,radius2,eccentricity) {
        hull() {
          linear_extrude(height=Delta)
             circle(r=radius);
          translate([0,0,height - Delta])   
             linear_extrude(height=Delta) 
                scale([1,eccentricity]) 
                   circle(r=radius2);
        }
      }
 /* 
 https://stackoverflow.com/questions/19527948/morph-circle-to-oval-in-openscad
 convert solid to tube */
module tube(height, radius, radius2, eccentricity=1, thickness) {
    difference() {
      minkowski() {
        connector(height,radius,radius2,eccentricity);
        cylinder(height=height,r=thickness);
      }
    translate([0,0,-(Delta+thickness)]) 
        connector(height + 2* (Delta +thickness) ,radius, radius2, eccentricity);
    }
  }

tht = 31;    // Height
  
module transition_hdr()
{      
    rad1 = (vac_od1-1)/2;
    rad2 = rad1*1.2;
   
translate([0,0,0])
      tube(tht, rad1 , rad2, 0.3, 2);
}

 
module total()
 {
	vac_tube();

    translate([0,0,ht1])
    { 
        translate([0,0,tht])
            straw_hdr(); // end piece with straw holes
        transition_hdr(); // circular to elllipse tube
    }
 }
 total();
