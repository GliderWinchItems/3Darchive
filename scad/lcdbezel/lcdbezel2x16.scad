/* File: lcdbezel.scad
 * LCD 2x16
 * Author: deh
 * Latest edit: 20200423
 */
 
 $fn = 40;
 
 /* Type of mounting. */
 botmnt = false; // false = Mount lcd to top piece
 //botmnt = true;  // true  = Mount lcd to bottom box
 
 /* Reference: origin to bottom-left corner of pcb */
 
 /* LCD module */
 brdlen   = 80.4;     // Overall pcb length
 brdwid   = 36.0;     // Overall pcb width
 brdholeoffset = 2.2; // Mounting holes from pcb edge
 brdholedia    = 3.0; // Mounting hole diameter
 brdthick = 1.6;      // pcb thickness
 
 dspoff_x = 4.2;    // Display offset x
 dspoff_y = 6.0;    // Display offset y
 dsplen   = 71.2;   // Display length
 dspwid   = 24.1;   // Display width
 dspthick = (8.5-brdthick);   // Display thickness
 dspdepth = 13;     // Top of pcb to floor below
 
 dsptab_y = 18.5;   // tab on right side of display
 dsptab_x = 4.2;
 dsptab_z = (5.0-brdthick);
 dsptab_off_y = 8.2;
 
 pinlen   = 43;     // hdr pins length (x)
 pinwid   = 4.5;    // hdr pins width (y)
 pinoff_x = 6.2;      // hdr pins offset (x)
 pinht    = 4.5;      // hdr pins height above pcb
 pinoff_y = 31.4;   // hdr pins offset (y)
 
 conlen   = 16;     // Connector w cable length (x)
 conwid   = 10.6;   // Connector width
 conoff_y = 21;     // Connector offset (y)
 
 /* Bottom box */
 bbxwall  = 3;     // Thickness of walls
 bbxflr   = 2;     // Thickness of floor
 bbxrad   = 3;     // Radius of outside corners
 bbxht    = 15;    // Height (outside)
 
 /* Pin protrusion spacer. */
 ppsthick = 3;     // Thickness of space
 
 /* Top bezel */
 tbzthick = dspthick - ppsthick;

/* Bottom box */ 
bbxlen = brdlen + conlen + 2*bbxwall;
bbxwid = brdwid + 2*bbxwall;
bbxoff_x = -conlen;
bbxoff_y = -bbxwall;

module rounded_bar(d, l, h)
{
    // Rounded end
    cylinder(d = d, h = h, center = false);
    // Bar
    translate([0, -d/2, 0])
       cube([l, d, h],false);
}
module eye_bar(d1, d2, len, ht)
{
   difference()
   {   
      rounded_bar(d1,len,ht);
      cylinder(d = d2, h = ht + .001, center = false);
   }
}
psto_dia = 8;   // Post outside diameter
module post_outside(a,z,holedia)
{
    translate(a)
    {
        difference()
        {
            union()
            {
                eye_bar(psto_dia,holedia,psto_dia*.5,z);
                translate([0,psto_dia*.5,0])
                
                cube([psto_dia*.5,psto_dia*.5,z],center=false);
            }
            union()
                translate([0,psto_dia,0])
                cylinder(d = psto_dia,h = z+.01, center=false);
            {
            }
        }
    }
}
/* bframe: basic outline with mounting tabs */
// zht: height bottom to top
module bframe(zht,holedia)
{
    translate([bbxoff_x,bbxoff_y,0])
    {
        difference()
        {
            union()
            {
                cube([bbxlen,bbxwid,zht-.01],center=false);
                
                // Four corner posts
                translate([bbxwall+bbxlen,bbxwid+bbxwall-psto_dia+1,0])
                  rotate([0,0,180])
                    post_outside([0,0,0],zht,holedia);
                
                translate([bbxlen+bbxwall,psto_dia-bbxwall-1,0])
                   mirror([1,0,0])
                    post_outside([0,0,0],zht,holedia);

                translate([-bbxwall,bbxwid-psto_dia*.5,0])
                   mirror([1,0,0])
                    rotate([0,0,180])
                    post_outside([0,0,0],zht,holedia);
                
                post_outside([-bbxwall,psto_dia*.5,0],zht,holedia);
            }
            union()
            {
 
            }
        }
    }
}
//
module boxmnttab(a,r)
{
    translate(a)
     rotate(r)
      eye_bar(8, 3.5, 9, 4);
}
    
module bottombox(wht,hdia)
{
    difference()
    {
       union()
        {
            bframe(wht,hdia);
            
            // Mounting tabs
            boxmnttab([bbxoff_x-4, bbxwid*0.5,0],[0,0,0]);
            boxmnttab([bbxoff_x+bbxlen+4, bbxwid*0.5,0],[0,0,180]);
        }
        union()
        {
            translate([bbxoff_x+bbxwall,-.5,bbxflr])
              cube([bbxlen-2*bbxwall,bbxwid-2*bbxwall+1,wht-bbxflr],center=false);
            
            // Cable exit--left side
            translate([bbxoff_x-8,conoff_y+1,wht-5])
             cube([15,8,15],center=false);
            
            // Cable exit--bottom, under plug
            translate([bbxoff_x+bbxwall+1,conoff_y+1,-0.01])
             cube([4,12,15],center=false);
            
            // Cable exit--bottom, near middle
            translate([25,conoff_y-2,-0.01])
             cube([15,15,15],center=false);
            
        }
    }
}
bzldia  = 6;
bzlhole = 2.8;

module bezelpost(a,wht)
{
bzht = wht - brdthick;  
    translate(a)
    {
        difference()
        {
            cylinder(d=bzldia,h=bzht,center=false);
            cylinder(d=bzlhole,h=bzht+.01,center=false);
        }
    }
}
// Post with no screw
module bezelpostns(a,wht)
{
bzht = wht - brdthick;  
    translate(a)
    {
        difference()
        {
            cylinder(d=bzldia,h=bzht,center=false);
        }
    }
}

/* Bottom box with LCD pcb posts */
module bottomboxwposts(wht,dia)
{
bh = brdholeoffset;
    union()
    {
        bottombox(wht,dia);
      if (botmnt)
      {
/* To screw LCD to bottom box         */
        bezelpost([       bh,       bh,0],wht);
        bezelpost([brdlen-bh-1,       bh,0],wht);
        bezelpost([       bh,brdwid-bh-1.5,0],wht);
        bezelpost([brdlen-bh-1,brdwid-bh-1.5,0],wht);
      }
      else
      {
/* To screw LCD to top, or just capture        */
        bezelpostns([bh, bh+13,0],wht);
        bezelpostns([brdlen-bh-23,brdwid-bh-1.5,0],wht);
        bezelpostns([brdlen-bh-10,       bh,0],wht);
      }
    }   
}
// Screw head indentation
module bezelindent(a)
{
    translate(a)
    {
        cylinder(d=6,h=2.5,center=false);
    }
}
// No indentation: Screw to top, instead of screw head indentation
module bezelindentns(a,wht)
{
    translate(a)
    {
        cylinder(d=2.8,h=wht-0.5,center=false);
    }    
}

module topbezel(wht,hdia)
{
    difference()
    {
        union()
        {
            bframe(wht,hdia);
        }
        union()
        {
 /* Cutout for LCD display 
 dspoff_x = 1.0;    // Display offset x
 dspoff_y = 10.4;   // Display offset y
 dsplen   = 97.1;   // Display length
 dspwid   = 39.7;   // Display width
 dspthick = 10.0;   // Display thickness
 dspdepth = 13;     // Top of pcb to floor below
 */
            translate([dspoff_x,dspoff_y,-0.01])
              cube([dsplen,dspwid,wht+0.2],center=false);

/* PCB header pins indentation. 
 pinlen   = 43;     // hdr pins length (x)
 pinwid   = 4.5;    // hdr pins width (y)
 pinoff_x = 7;      // hdr pins offset (x)
 pinht    = 5;      // hdr pins height above pcb
 pinoff_y = 55.2;   // hdr pins offset (y)          
*/          translate([pinoff_x,pinoff_y,0])  
              cube([pinlen,pinwid,pinht],center=false);

/* PCB Screw head indentations. */
    bh = brdholeoffset;          

    if (botmnt)
    {
        bezelindent([       bh,       bh,0]);
        bezelindent([brdlen-bh-1,       bh,0]);
        bezelindent([       bh,brdwid-bh-1.5,0]);
        bezelindent([brdlen-bh-1,brdwid-bh-1.5,0]);
    }
    else
    {
        
       bezelindentns([          bh,       bh    ,0],wht);
        bezelindentns([brdlen-bh-1,       bh    ,0],wht);
        bezelindentns([         bh,brdwid-bh-1.5,0],wht);
        bezelindentns([brdlen-bh-1,brdwid-bh-1.5,0],wht);
    }
         
/* Tab on right side of display. 
 dsptab_y = 18.5;   // tab on right side of display
 dsptab_x = 4.2;
 dsptab_z = (5.0-brdthick);
 dsptab_off_y = 8.2;*/
        translate([dsplen+dspoff_x,dsptab_off_y,0])
          cube([dsptab_x,dsptab_y,dsptab_z],center=false);
        
        }
    }   
}

bottomboxwposts(14,2.8);

translate([0,0,25]) topbezel(6,3.5);

