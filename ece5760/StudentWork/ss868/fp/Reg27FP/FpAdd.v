/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Lab 3                                               *
 * Mandelbrot Set                                               *
 ****************************************************************/

`include "lab3_params.h"

module FpAdd (
    input             iCLK,
    input      [26:0] iA,
    input      [26:0] iB,
    output     [26:0] oSum
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
    
    // Shift fractions of A and B so that they align.
    wire [8:0]  exp_diff_A;
    wire [8:0]  exp_diff_B;
    wire [7:0]  larger_exp;
    wire [36:0] A_f_shifted;
    wire [36:0] B_f_shifted;
    
    assign exp_diff_A = {B_e[7], B_e} - {A_e[7], A_e};
    assign exp_diff_B = {A_e[7], A_e} - {B_e[7], B_e};
    assign larger_exp = exp_diff_B[8] ? B_e : A_e;
    assign A_f_shifted = exp_diff_A[8]        ? {1'b0,  A_f, 18'b0} :
                         (exp_diff_A > 9'd35) ? 37'b0 :
                         ({1'b0, A_f, 18'b0} >> exp_diff_A);
    assign B_f_shifted = exp_diff_B[8]        ? {1'b0,  B_f, 18'b0} :
                         (exp_diff_B > 9'd35) ? 37'b0 :
                         ({1'b0, B_f, 18'b0} >> exp_diff_B);
    
    // Determine which of A, B is larger
    wire A_larger;
    assign A_larger = exp_diff_A[8] | (~exp_diff_B[8] & (A_f > B_f));
    
    // Calculate sum or difference of shifted fractions.
    wire [36:0] pre_sum;
    assign pre_sum = ((A_s^B_s) &  A_larger) ? A_f_shifted - B_f_shifted :
                     ((A_s^B_s) & ~A_larger) ? B_f_shifted - A_f_shifted :
                     A_f_shifted + B_f_shifted;
    
    // buffer midway results
    reg  [36:0] buf_pre_sum;
    reg  [7:0]  buf_larger_exp;
    reg         buf_A_f_zero;
    reg         buf_B_f_zero;
    reg  [26:0] buf_A;
    reg  [26:0] buf_B;
    reg         buf_oSum_s;
    always @(posedge iCLK) begin
        buf_pre_sum    <= pre_sum;
        buf_larger_exp <= larger_exp;
        buf_A_f_zero   <= (A_f == 18'b0);
        buf_B_f_zero   <= (B_f == 18'b0);
        buf_A          <= iA;
        buf_B          <= iB;
        buf_oSum_s     <= A_larger ? A_s : B_s;
    end
    
    // Convert to positive fraction and a sign bit.
    wire [36:0] pre_frac;
    assign pre_frac = buf_pre_sum;
    
    // Determine output fraction and exponent change with position of first 1.
    wire [17:0] oSum_f;
    wire [7:0]  shft_amt;
    assign shft_amt = pre_frac[36] ? 8'd0  : pre_frac[35] ? 8'd1  :
                      pre_frac[34] ? 8'd2  : pre_frac[33] ? 8'd3  :
                      pre_frac[32] ? 8'd4  : pre_frac[31] ? 8'd5  :
                      pre_frac[30] ? 8'd6  : pre_frac[29] ? 8'd7  :
                      pre_frac[28] ? 8'd8  : pre_frac[27] ? 8'd9  :
                      pre_frac[26] ? 8'd10 : pre_frac[25] ? 8'd11 :
                      pre_frac[24] ? 8'd12 : pre_frac[23] ? 8'd13 :
                      pre_frac[22] ? 8'd14 : pre_frac[21] ? 8'd15 :
                      pre_frac[20] ? 8'd16 : pre_frac[19] ? 8'd17 :
                      pre_frac[18] ? 8'd18 : pre_frac[17] ? 8'd19 :
                      pre_frac[16] ? 8'd20 : pre_frac[15] ? 8'd21 :
                      pre_frac[14] ? 8'd22 : pre_frac[13] ? 8'd23 :
                      pre_frac[12] ? 8'd24 : pre_frac[11] ? 8'd25 :
                      pre_frac[10] ? 8'd26 : pre_frac[9]  ? 8'd27 :
                      pre_frac[8]  ? 8'd28 : pre_frac[7]  ? 8'd29 :
                      pre_frac[6]  ? 8'd30 : pre_frac[5]  ? 8'd31 :
                      pre_frac[4]  ? 8'd32 : pre_frac[3]  ? 8'd33 :
                      pre_frac[2]  ? 8'd34 : pre_frac[1]  ? 8'd35 :
                      pre_frac[0]  ? 8'd36 : 8'd37;
    
    wire [53:0] pre_frac_shft;
    assign pre_frac_shft = {pre_frac, 17'b0} << shft_amt;
    assign oSum_f = pre_frac_shft[53:36];
    
    wire [7:0] oSum_e;
    assign oSum_e = buf_larger_exp - shft_amt + 8'b1;
    
    // Detect underflow
    wire underflow;
    assign underflow = ~oSum_e[7] && buf_larger_exp[7] && (shft_amt != 8'b0);
    
    assign oSum = buf_A_f_zero ? buf_B :
                  buf_B_f_zero ? buf_A :
                  (pre_frac == 38'b0) ? 27'b0 :
                  underflow ? 27'b0 :
                  {buf_oSum_s, oSum_e, oSum_f};
    
endmodule
