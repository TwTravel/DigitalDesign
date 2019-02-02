/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Lab 3                                               *
 * Mandelbrot Set                                               *
 ****************************************************************/

`define NIOS_COMM_VALID      31
`define NIOS_COMM_OP         30:27
`define NIOS_COMM_HEAD       31:27
`define NIOS_COMM_DATA       26:0
`define NIOS_OP_SEND_R_MIN   4'b0000
`define NIOS_OP_SEND_I_MIN   4'b0001
`define NIOS_OP_SEND_R_STEP  4'b0010
`define NIOS_OP_SEND_I_STEP  4'b0011
`define NIOS_OP_SEND_X_MIN   4'b0100
`define NIOS_OP_SEND_Y_MIN   4'b0101
`define NIOS_OP_SEND_X_MAX   4'b0110
`define NIOS_OP_SEND_Y_MAX   4'b0111
`define NIOS_OP_REQ_R_MIN    4'b1000
`define NIOS_OP_REQ_I_MIN    4'b1001
`define NIOS_OP_REQ_R_STEP   4'b1010
`define NIOS_OP_REQ_I_STEP   4'b1011

`define F_SIGN               26
`define F_EXP                25:18
`define F_FRAC               17:0

`define JH_ST_EMPTY          3'd0
`define JH_ST_MUL_RR         3'd1
`define JH_ST_MUL_IR         3'd2
`define JH_ST_MUL_II         3'd3
`define JH_ST_ADD_I          3'd4
`define JH_ST_ADD_R          3'd5
`define JH_ST_TRANS          3'd6
`define JH_ST_DONE           3'd7

`define CLK_MANDEL_CPS       32'd24999999
`define NUM_JOB_HANDLERS     16 // Max 32