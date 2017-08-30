/* gsolar.scad
 * Common dimensions for "those ancient" glass solar panels
 * Date of latest: 2017/08/27
 */

include <../../library_deh/deh_shapes.scad>

 $fn=50;

/* Panel diimensions */
gs_wid = 152.4 + 0;
gs_len = 152.4 + 0;
gs_thick = 2.2;

bs_edge = 6;
bs_wid = gs_wid + bs_edge;	// Outside
bs_len = gs_len + bs_edge;	// Outside
bs_ht = gs_thick + 3;		// Total ht

ir_edge = 0;
ir_wid = gs_wid - ir_edge;	// Inside
ir_len = gs_len - ir_edge;	// Inside
ir_ht  = bs_ht - gs_thick;


/* Wire */
wr_dia = 1.6 + .5;	// Dia of wire w insulation
wr_bare = 1.0;	// Approx dia of stripped wire


