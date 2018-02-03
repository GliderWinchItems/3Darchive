README.txt
02/02/2017

Plano_frame_F4gate

Frame for holding Discovery F4 board with switcher and 
uart-usb modules that fits in a Plano 3406 box

"A" suffix is for a sloped frame that allows plugging
the usb cable into the STLINK usb connector for 
programming without takeing the Discovery board out
of the frame.  

The "cap" is the part at the high end of the frame
that holds the Discovery board into the recesses.

The "A" version makes use of some routine in 
"../library_deh"

deh_shapes2.scad
  rounded rectangles using "hull"

Plano_base.scad
  A base plate with 
     rounded corners,
     chamfered bottom edge,
     magnet stud mount holes,
  With calls for 
    "add"
    "del"
       hollow out stud holes, washer, and nut

By calling "del" last any added components that would
affect the chamfer or stud holes/washers/nuts will be
overridden.

ridged_screw_holes
  Posts for holding the board.

angled_posts
  Posts that deal with the board being held at
and angle

  
