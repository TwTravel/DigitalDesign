// Optimized Complex Multiplier
// optcomplexmult.v
//
// ECE 576, Fall 2007 - Cornell University
//
// Revision History:
//
// v0.9		Bruce Land		UNKNOWN			Signed 2.16 multiplier
// v1.0		Adrian Wong		2007.11.14		Complex multiplier
// v1.1		Adrian Wong		2007.11.14		Optimized multiplications
// v1.2		Adrian Wong		2007.11.15		Replaced with LPM_MULTs
// v1.3		Adrian Wong		2007.11.18		Verified in MATLAB

module signed_complex(A_R, A_C, B_R, B_C, D_R, D_C);

// D = A * B
input	signed	[17:0] A_R, A_C;
input	signed	[17:0] B_R, B_C;
output	signed	[17:0] D_R, D_C;

// NON-OPTIMIZED MULTIPLICATION
// = (A_R * B_R) - (A_C * B_C) + j ( (A_R * B_C) + (A_C * B_R) )
wire	signed	[17:0] result1, result2, result3, result4;
signed_mult rm1 (A_R, B_R, result1);
signed_mult rm2 (A_C, B_C, result2);
signed_mult rm3 (A_R, B_C, result3);
signed_mult rm4 (A_C, B_R, result4);

wire	signed	[18:0] prescale_R, prescale_C;

// assign prescale_R = {result1[17], result1} - {result2[17], result2};
// assign prescale_C = {result3[17], result3} + {result4[17], result4};

assign prescale_R = result1 - result2;
assign prescale_C = result3 + result4;

assign D_R = prescale_R[18:1];
assign D_C = prescale_C[18:1];

////////////////////////////////////////////////////
// OPTIMIZED MULTIPLICATION
// Original Operations: 4 Multiply, 2 Sum
// Optimial Operations: 3 Multiply, 5 Sum

// Optimization details at the end of the Verilog file

// F, G, and H are used for multiplier optimization
//wire	signed	[38:0] F, G, H;
// TODO: Need to deal with Extra bits and overflow?
//wire	signed	[20:0] K, L;
//wire	signed	[35:0] scale_D_R, scale_D_C;

// Three multiplication units
// ** signed_mult does not work.
//realmult rm1 ({A_R[19], A_R}, {B_R[17], B_R[17], B_R[17], B_R}, F);
//realmult rm2 ({A_C[19], A_C}, {B_C[17], B_C[17], B_C[17], B_C}, G);
//realmult rm3 (K, L, H);

// Five summation units
//assign K	= A_R + A_C;
//assign L	= B_R + B_C;

//assign scale_D_R = F - G;
//assign scale_D_C = H - F - G;

// Scale outputs by 1/sqrt(4) before storing.
//assign D_R	= {scale_D_R[35], scale_D_R[35], scale_D_R[35:20]};
//assign D_C	= {scale_D_C[35], scale_D_C[35], scale_D_C[35:20]};

//assign D_R = scale_D_R;
//assign D_C = scale_D_C;

endmodule


// COMPLEX MULTIPLICATION OPTIMIZATION

//   (A_R + jA_C) * (B_R + jB_C)
// = (A_R * B_R) - (A_C * B_C) + j ( (A_R * B_C) + (A_C * B_R) )
// = (A_R * B_R) - (A_C * B_C) + j ( (A_R + A_C) * (B_R + B_C) - (A_R * B_R) - (A_C * B_C) )

// Substitute F = A_R * B_R and G = A_C * B_C and H = (A_R + B_C) * (B_R + B_C)
// = F - G + j ( H - F - G )

// Real part is (F - G), complex part is (H - F - G).

/////////////////////////////////
// Bruce Land 2.18 Signed Mult //
/////////////////////////////////
module signed_mult (a, b, out);
	output 			[17:0]	out;
	input 	signed	[17:0] 	a;
	input 	signed	[17:0] 	b;
	wire	signed	[17:0]	out;
	wire 	signed	[35:0]	mult_out;

	assign mult_out = a * b;
	assign out = {mult_out[35], mult_out[32:16]};
endmodule