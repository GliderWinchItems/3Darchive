/* enclose_cutout.scad
   Enclosure cutout for POD #3
   04/01/2017
*/

len_en = 164;	// Length of enclosure box

wid_bot = 84;	// Width across bottom
wid_mid = 86.5;	// Width at lid cover junction
ht_bot = 39;	// Height bottom to lid junction
ht_lid = 15.8;	// Height of lid	

module enclose_cutout(depth, slop)
{
x1 = 0;				y1 = 0;
x2 = -((wid_mid-wid_bot)/2 + slop);	y2 = ht_bot + slop;
x3 = x2;			y3 = ht_bot + ht_lid + slop;
x4 = x3+wid_mid+slop;			y4 = y3;
x5 = x4;			y5 = ht_bot + slop;
x6 = wid_bot+slop;			y6 = 0;

 translate([-wid_bot/2,-(ht_bot+ht_lid)/2-2.5/2,0])
 {
   linear_extrude(height = depth,center = false)
   {
      polygon(points = [
     [x1,y1], 
     [x2,y2], 
     [x3,y3], 
     [x4,y4],
     [x5,y5], 
     [x6,y6], 
               ]);
  }
 }
}
