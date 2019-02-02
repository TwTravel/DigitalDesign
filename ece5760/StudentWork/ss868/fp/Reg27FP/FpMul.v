/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Lab 3                                               *
 * Mandelbrot Set                                               *
 ****************************************************************/

`include "lab3_params.h"

// A combinational floating point multiplier.
module FpMul (
    input      [26:0] iA,    // First input
    input      [26:0] iB,    // Second input
    output     [26:0] oProd  // Product
);
    
    // Extract fields of A and B.
    wire        A_s;
    wire [7:0]  A_e;
    wire [17:0] A_f;
    wire        B_s;
    wire [7:0]  B_e;
    wire [17:0] B_f;
    assign A_s = iA[`F_SIGN];
    assign A_e = iA[`F_EXP];
    assign A_f = iA[`F_FRAC];
    assign B_s = iB[`F_SIGN];
    assign B_e = iB[`F_EXP];
    assign B_f = iB[`F_FRAC];
    
    // XOR sign bits to determine product sign.
    wire        oProd_s;
    assign oProd_s = A_s ^ B_s;
    
    // Multiply the fractions of A and B
    wire [35:0] pre_prod_frac;
    assign pre_prod_frac = A_f * B_f;
    
    // Add exponents of A and B
    wire [7:0]  pre_prod_exp;
    assign pre_prod_exp = A_e + B_e;
    
    // If top bit of product frac is 0, shift left one
    wire [7:0]  oProd_e;
    wire [17:0] oProd_f;
    assign oProd_e = pre_prod_frac[35] ? pre_prod_exp : (pre_prod_exp - 8'b1);
    assign oProd_f = pre_prod_frac[35] ? pre_prod_frac[35:18] : pre_prod_frac[34:17];
    
    // Detect underflow
    wire        underflow;
    assign underflow = A_e[7] & B_e[7] & ~oProd_e[7];
    
    // Detect zero conditions (either product frac doesn't start with 1, or underflow)
    assign oProd = ~oProd_f[17] ? 27'b0 :
                   underflow    ? 27'b0 :
                   {oProd_s, oProd_e, oProd_f};
    
endmodule
