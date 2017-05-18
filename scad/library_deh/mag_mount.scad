/* mag_mount.scad

 * ****** Stud magnets ******
16 mm 
http://www.kjmagnetics.com/proddetail.asp?prod=MM-C-16
    Dimensions:
        D=16mm (0.63")
        M=4mm (0.16") (M4 Coarse Male threaded stud)
        H=13mm (0.51")
        h=5mm (0.20")
    Material: NdFeB, Grade N38
    Plating/Coating: Ni-Cu-Ni (Nickel)
    Magnetization Direction: Axial (Poles on Flat Ends)
    Weight: 0.26 oz. (7.37 g)
    Pull Force: 12.1 lbs
    Surface Field: N/A
    Brmax: 12,600 Gauss
    BHmax: 38 MGOe
   $2.49
*/
// Measured dimensions -- 16 mm ** M3 ** stud (default)
 mag_thick = 4.82;	    // Magnet thickness (base to shell top)
 mag_shell_dia = 16.0;	    // Magnet shell OD
 mag_shell_flat_dia = 11;   // Dia of flat of magnet
 mag_stud_dia = 2.8;        // Dia of mounting magnet studs (4-40)
 mag_stud_len = 8.0;        // Height of stud from magnet back
 mag_washer_thick = 1.1;    // Thickness of washer
 mag_nut_thick = 2.4;       // Stud nut (M3) thickness
 mag_nut_hex_flat = 5.41;   // Nut across flats
 mag_nut_hex_peak = 6.20;   // Nut across peaks (also dia of nut)
 mag_washer_dia = 7.1; // 9.5;// Diameter of washer for magnet stud
 mag_washer_dia_extra = 2;  // Washer slop

// Measured dimensions 16 mm -- ** M4 ** stud
 mag16_M4_thick = 5.21;	     // Magnet thickness (base to shell top)
 mag16_M4_shell_dia = 16.0;	     // Magnet shell OD
 mag16_M4_shell_flat_dia = 11.7;  // Dia of flat of magnet
 mag16_M4_stud_dia = 3.64;        // Dia of mounting magnet studs (4-40)
 mag16_M4_stud_len = 8.18;        // Height of stud from magnet back
 mag16_M4_nut_thick = 2.98;       // Stud nut (M4) thickness
 mag16_M4_nut_hex_flat = 6.85;    // Nut across flats
 mag16_M4_nut_hex_peak = 7.89;    // Nut across peaks (also dia of nut)
 mag16_M4_washer_thick = 0.85;    // Thickness of washer
 mag16_M4_washer_dia = 8.68;      // Diameter of washer for magnet stud
 mag16_M4_washer_inner_dia = 5.3; // Washer hole diameter
 mag16_M4_washer_dia_extra = 0.5; // Washer slop


/*
http://www.kjmagnetics.com/proddetail.asp?prod=MM-C-20
    Dimensions:
        D=20mm (0.79")
        M=4mm (0.16") (M4 Coarse Male threaded stud)
        H=15mm (0.59")
        h=7mm (0.28")
    Material: NdFeB, Grade N38
    Plating/Coating: Ni-Cu-Ni (Nickel)
    Magnetization Direction: Axial (Poles on Flat Ends)
    Weight: 0.53 oz. (15.0 g)
    Pull Force: 28.7 lbs
    Surface Field: N/A
    Brmax: 12,600 Gauss
    BHmax: 38 MGOe

  $3.14
*/
 mag20_thick = 7.11;	    // Magnet thickness (base to shell top)
 mag20_shell_dia = 20.2;    // Magnet shell OD
 mag20_stud_dia = 3.75;     // Dia of mounting magnet stud at base
 mag20_stud_len = 7.75;       // Height of stud from magnet back
 mag20_washer_thick = 0.85;    // Thickness of washer
 mag20_nut_thick = 2.93;       // Nut for stud thickness
 mag20_washer_dia = 8.68;      // Diameter of washer for magnet stud
 mag20_washer_dia_extra = 2;  // Washer slop

/*
http://www.kjmagnetics.com/proddetail.asp?prod=MM-C-25

    Dimensions:
        D=25mm (0.98")
        M=5mm (0.20") (M5 Coarse Male threaded stud)
        H=17mm (0.67")
        h=8mm (0.32")
    Material: NdFeB, Grade N38
    Plating/Coating: Ni-Cu-Ni (Nickel)
    Magnetization Direction: Axial (Poles on Flat Ends)
    Weight: 0.92 oz. (26.1 g)
    Pull Force: 48.5 lbs
    Surface Field: N/A
    Brmax: 12,600 Gauss
    BHmax: 38 MGOe
  $4.20
*/
// 25 mm M5
 mag25_thick = 7.75;	      // Magnet thickness (base to shell top)
 mag25_shell_dia = 25.17;     // Magnet shell OD
 mag25_shell_flat_dia = 20;   // Dia of flat of magent
 mag25_stud_dia = 4.82;       // Dia of mounting magnet studs (4-40)
 mag25_stud_len = 9.3;        // Height of stud from magnet back
 mag25_washer_thick = 0.97;   // Thickness of washer
 mag25_nut_thick = 3.96;      // M5 Nut for stud thickness
 mag25_nut_hex_flat = 7.93;   // M5 nut across flats
 mag25_nut_hex_peak = 9.16;   // M5 nut across peaks (also dia of nut)
 mag25_washer_dia = 9.8;      // Washer diameter of washer for magnet stud
 mag25_washer_inner_dia = 5.3;// Washer hole diameter
 mag25_washer_dia_extra = 2;  // Washer slop

// Cylindrical magnets
mag_cyl_dia = 6.5; 
mag_cyl_ht = 5.05;


