 /* File: pianovac.scad
 * Vaccum adapter for brush to Shark
 * Author: deh
 * Latest edit: 20180113
 */
 
 $fn = 100;
 
 wall = 3;
 Q = -0.5;
vac_od1 = 33.9+Q;     // OD at mouth
vac_od2 = 34.7+Q;     // OD at further up

brsh_id1 = 31.2;    // ID at mout  
brsh_id2 = 30.6;    // ID further down

lng = 60;   // Length

ht1 = 30;
ht2 = 10;

 module vac_tube()
 {
     difference()
     {
        cylinder(d1 = vac_od2+wall, d2 = vac_od1+wall, h = ht1, center = false);
        cylinder(d1 = vac_od2,      d2 = vac_od1,       h = ht1, center = false);
     }  
 }
 module brsh_tube()
 {
     {
        difference()
        {  
            cylinder(d2 = brsh_id2     ,  d1 = brsh_id1,       h = ht1, center = false);
            cylinder(d2 = brsh_id2-wall,  d1 = brsh_id1-wall,  h = ht1, center = false);
        }  
    }
 }
 
 module transition()
 {
      difference()
     {
        cylinder(d1 = vac_od2+wall-Q, d2 = brsh_id2,      h = ht2, center = false);
        cylinder(d1 = vac_od2,      d2 = brsh_id2-wall, h = ht2, center = false);
     }    
 }

module total()
 {
    vac_tube();

     translate([0,0,ht1])     
        transition();

     translate([0,0,ht1+ht2])
        brsh_tube();
 }
 total();
