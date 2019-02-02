// Radix-4 Butterfly DFT
// radix4dft.v
//
// ECE 576, Fall 2007 - Cornell University
//
// Revision History:
//
// v1.0		Adrian Wong		2007.11.9		Initial revision
// v1.1		Adrian Wong		2007.11.10		Optimized to reduce sum operations
// v1.2		Adrian Wong		2007.11.12		Included real and complex components
// v1.3		Adrian Wong		2007.11.13		MATLAB version verified
// v2.0		Adrian Wong		2007.11.14		Translated into Verilog code structure
// v2.1		Adrian Wong		2007.11.15		Revised for in place FFT
// v2.1		Adrian Wong		2007.11.18		Corrected for DIF


module radix4dft   (t1_r, t1_c,
					t2_r, t2_c,
					t3_r, t3_c,
					
					x0_r, x1_r, x2_r, x3_r,
					x0_c, x1_c, x2_c, x3_c,
					
					f0_r, f1_r, f2_r, f3_r,
					f0_c, f1_c, f2_c, f3_c
					);

// t1 through t3 represent twiddle factors to DFT
input	signed	[17:0] t1_r, t1_c, t2_r, t2_c, t3_r, t3_c;

// x0 through x3 represent input values to DFT
input	signed	[17:0] x0_r, x0_c, x1_r, x1_c, x2_r, x2_c, x3_r, x3_c;

// f0 through f3 represent rotated output values from DFT
output	signed	[17:0] f0_r, f0_c, f1_r, f1_c, f2_r, f2_c, f3_r, f3_c;

// DFT intermediate values
wire	signed	[19:0] a0_r, a0_c, a1_r, a1_c, a2_r, a2_c, a3_r, a3_c;
wire	signed	[19:0] y0_r, y0_c, y1_r, y1_c, y2_r, y2_c, y3_r, y3_c;
wire	signed	[19:0] z0_r, z0_c, z1_r, z1_c, z2_r, z2_c, z3_r, z3_c;

assign a0_r = {x0_r[17], x0_r[17], x0_r};
assign a1_r = {x1_r[17], x1_r[17], x1_r};
assign a2_r = {x2_r[17], x2_r[17], x2_r};
assign a3_r = {x3_r[17], x3_r[17], x3_r};

assign a0_c = {x0_c[17], x0_c[17], x0_c};
assign a1_c = {x1_c[17], x1_c[17], x1_c};
assign a2_c = {x2_c[17], x2_c[17], x2_c};
assign a3_c = {x3_c[17], x3_c[17], x3_c};


// First matrix multiply
assign y0_r = a0_r + a2_r;
assign y1_r = a0_r - a2_r;

assign y2_r = a1_r + a3_r;
assign y3_r = a1_r - a3_r;

assign y0_c = a0_c + a2_c;
assign y1_c = a0_c - a2_c;

assign y2_c = a1_c + a3_c;
assign y3_c = a1_c - a3_c;

// Second matrix multiply
assign z0_r = y0_r + y2_r;
assign z0_c = y0_c + y2_c;

assign z1_r = y1_r + y3_c;
assign z1_c = y1_c - y3_r;

assign z2_r = y0_r - y2_r;
assign z2_c = y0_c - y2_c;

assign z3_r = y1_r - y3_c;
assign z3_c = y1_c + y3_r;

// Third matrix multiply
//assign f0_r = z0_r[19:2]; // shift right to normalize
//assign f0_c = z0_c[19:2]; // shift right to normalize

signed_complex scmult0 (z0_r[19:2], z0_c[19:2], 18'h20000, 18'h0, f0_r, f0_c);
signed_complex scmult1 (z1_r[19:2], z1_c[19:2], t1_r, t1_c, f1_r, f1_c);
signed_complex scmult2 (z2_r[19:2], z2_c[19:2], t2_r, t2_c, f2_r, f2_c);
signed_complex scmult3 (z3_r[19:2], z3_c[19:2], t3_r, t3_c, f3_r, f3_c);

endmodule