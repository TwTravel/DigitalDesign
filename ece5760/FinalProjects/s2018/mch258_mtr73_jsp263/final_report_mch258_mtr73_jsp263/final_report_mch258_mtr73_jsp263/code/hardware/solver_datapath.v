`ifndef _solver_datapath_v_
`define _solver_datapath_v_

`include "ram.v"

// Stages:
//   C - Control (Not part of the datapath)
//   R - Read / L - Load cre, cim from input
//   A - Abs
//   M - Multiply
//   X - Excexute: add and accumulate
//   W - Write

module solver_datapath #(
    parameter LIMB_INDEX_BITS = 6,
    parameter LIMB_SIZE_BITS = 27,
    parameter DIVERGENCE_RADIUS = 4
) (
    input clock, reset,

    input [LIMB_SIZE_BITS-1:0]  C_cre_limb,
    input [LIMB_SIZE_BITS-1:0]  C_cim_limb,


    //Load (L) control signals
    input C_cre_wr_en,
    input C_cim_wr_en,

    //Read (R) control signals
    input [LIMB_INDEX_BITS-1:0] C_c_limb_ind,
    input [LIMB_INDEX_BITS-1:0] C_zre_rd_ind,
    input [LIMB_INDEX_BITS-1:0] C_zim_rd_ind,

    //Abs (A) control signals
    input [1:0]                 C_zre_reg_sel,
    input [1:0]                 C_zim_reg_sel,
    input [1:0]                 C_zre_neg_sel,
    input [1:0]                 C_zim_neg_sel,
    input                       C_mov_CtoA,
    input                       C_mov_DtoB,

    //Execute (X) control signals
    input [2:0]                 C_zre_partial_sel,
    input [1:0]                 C_zim_partial_sel,
    input [1:0]                 C_zre_acc_sel,
    input [1:0]                 C_zim_acc_sel,

    //Write (W) control signals
    input                       C_clear_lsd,
    input                       C_zre_wr_en,
    input                       C_zim_wr_en,
    input [LIMB_INDEX_BITS-1:0] C_zre_wr_ind,
    input [LIMB_INDEX_BITS-1:0] C_zim_wr_ind,

    //Output
    output     W_zre_sign,
    output     W_zim_sign,
    output     W_diverged,
    output reg [LIMB_INDEX_BITS-1:0] W_zre_lsd,
    output reg [LIMB_INDEX_BITS-1:0] W_zim_lsd
);


// ---------- Read Stage (R) / Load Stage (L) ---------------------------------

//Control signals
reg                         L_cre_wr_en;
reg                         L_cim_wr_en;
reg  [LIMB_INDEX_BITS-1:0]  R_c_limb_ind;
reg  [LIMB_INDEX_BITS-1:0]  R_zre_rd_ind;
reg  [LIMB_INDEX_BITS-1:0]  R_zim_rd_ind;
reg  [1:0]                  R_zre_reg_sel;
reg  [1:0]                  R_zim_reg_sel;
reg  [1:0]                  R_zre_neg_sel;
reg  [1:0]                  R_zim_neg_sel;
reg                         R_mov_CtoA;
reg                         R_mov_DtoB;
reg  [2:0]                  R_zre_partial_sel;
reg  [1:0]                  R_zim_partial_sel;
reg  [1:0]                  R_zre_acc_sel;
reg  [1:0]                  R_zim_acc_sel;
reg                         R_clear_lsd;
reg                         R_zre_wr_en;
reg                         R_zim_wr_en;
reg  [LIMB_INDEX_BITS-1:0]  R_zre_wr_ind;
reg  [LIMB_INDEX_BITS-1:0]  R_zim_wr_ind;

//Datapath signals
reg  [LIMB_SIZE_BITS-1:0]   L_cre_limb;
reg  [LIMB_SIZE_BITS-1:0]   L_cim_limb;

localparam RAM_BITS = 1 << LIMB_INDEX_BITS;
reg  [LIMB_SIZE_BITS-1:0]   zre_ram [RAM_BITS-1:0];
reg  [LIMB_SIZE_BITS-1:0]   zim_ram [RAM_BITS-1:0];
reg  [LIMB_SIZE_BITS-1:0]   cre_ram [RAM_BITS-1:0];
reg  [LIMB_SIZE_BITS-1:0]   cim_ram [RAM_BITS-1:0];

always @(posedge clock) begin
    if (reset) begin
        //Control
        L_cre_wr_en       <= 0;
        L_cim_wr_en       <= 0;
        R_c_limb_ind      <= 0;
        R_zre_rd_ind      <= 0;
        R_zim_rd_ind      <= 0;
        R_zre_reg_sel     <= 0;
        R_zim_reg_sel     <= 0;
        R_zre_neg_sel     <= 0;
        R_zim_neg_sel     <= 0;
        R_mov_CtoA        <= 0;
        R_mov_DtoB        <= 0;
        R_zre_partial_sel <= 0;
        R_zim_partial_sel <= 0;
        R_zre_acc_sel     <= 0;
        R_zim_acc_sel     <= 0;
        R_clear_lsd       <= 0;
        R_zre_wr_en       <= 0;
        R_zim_wr_en       <= 0;
        R_zre_wr_ind      <= 0;
        R_zim_wr_ind      <= 0;

        //Datapath
        L_cre_limb <= 0;
        L_cim_limb <= 0;
    end else begin
        //Control
        L_cre_wr_en       <= C_cre_wr_en;
        L_cim_wr_en       <= C_cim_wr_en;
        R_c_limb_ind      <= C_c_limb_ind;
        R_zre_rd_ind      <= C_zre_rd_ind;
        R_zim_rd_ind      <= C_zim_rd_ind;
        R_zre_reg_sel     <= C_zre_reg_sel;
        R_zim_reg_sel     <= C_zim_reg_sel;
        R_zre_neg_sel     <= C_zre_neg_sel;
        R_zim_neg_sel     <= C_zim_neg_sel;
        R_mov_CtoA        <= C_mov_CtoA;
        R_mov_DtoB        <= C_mov_DtoB;
        R_zre_partial_sel <= C_zre_partial_sel;
        R_zim_partial_sel <= C_zim_partial_sel;
        R_zre_acc_sel     <= C_zre_acc_sel;
        R_zim_acc_sel     <= C_zim_acc_sel;
        R_clear_lsd       <= C_clear_lsd;
        R_zre_wr_en       <= C_zre_wr_en;
        R_zim_wr_en       <= C_zim_wr_en;
        R_zre_wr_ind      <= C_zre_wr_ind;
        R_zim_wr_ind      <= C_zim_wr_ind;

        //Datapath
        L_cre_limb <= C_cre_limb;
        L_cim_limb <= C_cim_limb;
    end
end


// ---------- Abs Stage (A) ---------------------------------------------------

//Control signals
reg  [1:0]                  A_zre_reg_sel;
reg  [1:0]                  A_zim_reg_sel;
reg  [1:0]                  A_zre_neg_sel;
reg  [1:0]                  A_zim_neg_sel;
reg                         A_mov_CtoA;
reg                         A_mov_DtoB;
reg  [2:0]                  A_zre_partial_sel;
reg  [1:0]                  A_zim_partial_sel;
reg  [1:0]                  A_zre_acc_sel;
reg  [1:0]                  A_zim_acc_sel;
reg                         A_clear_lsd;
reg                         A_zre_wr_en;
reg                         A_zim_wr_en;
reg  [LIMB_INDEX_BITS-1:0]  A_zre_wr_ind;
reg  [LIMB_INDEX_BITS-1:0]  A_zim_wr_ind;

//Datapath signals
reg  [LIMB_SIZE_BITS-1:0]   A_cre_limb;
reg  [LIMB_SIZE_BITS-1:0]   A_cim_limb;
reg  [LIMB_SIZE_BITS-1:0]   A_zre_limb;
reg  [LIMB_SIZE_BITS-1:0]   A_zim_limb;

reg  [LIMB_SIZE_BITS-1:0]   A_zre_limb_abs;
reg  [LIMB_SIZE_BITS-1:0]   A_zim_limb_abs;

reg  [LIMB_SIZE_BITS-1:0]   A_regA;
reg  [LIMB_SIZE_BITS-1:0]   A_regB;
reg  [LIMB_SIZE_BITS-1:0]   A_regC;
reg  [LIMB_SIZE_BITS-1:0]   A_regD;

always @* begin
    A_zre_limb_abs = A_zre_limb;
    A_zim_limb_abs = A_zim_limb;

    case (A_zre_neg_sel)
        0: A_zre_limb_abs = A_zre_limb;                                 // Don't negate
        1: A_zre_limb_abs = A_zre_limb ^ {LIMB_SIZE_BITS{1'b1}};        // Flip bits
        2: A_zre_limb_abs = (A_zre_limb ^ {LIMB_SIZE_BITS{1'b1}}) + 1;  // Flip bits and add one
        default: $display("[ERROR] A_zre_neg_sel has illegal value: %b", A_zre_neg_sel);
    endcase
    case (A_zim_neg_sel)
        0: A_zim_limb_abs = A_zim_limb;                                 // Don't negate
        1: A_zim_limb_abs = A_zim_limb ^ {LIMB_SIZE_BITS{1'b1}};        // Flip bits
        2: A_zim_limb_abs = (A_zim_limb ^ {LIMB_SIZE_BITS{1'b1}}) + 1;  // Flip bits and add one
        default: $display("[ERROR] A_zim_neg_sel has illegal value: %b", A_zim_neg_sel);
    endcase
end

always @(posedge clock) begin
    if (reset) begin
        //Control
        A_zre_reg_sel     <= 0;
        A_zim_reg_sel     <= 0;
        A_zre_neg_sel     <= 0;
        A_zim_neg_sel     <= 0;
        A_mov_CtoA        <= 0;
        A_mov_DtoB        <= 0;
        A_zre_partial_sel <= 0;
        A_zim_partial_sel <= 0;
        A_zre_acc_sel     <= 0;
        A_zim_acc_sel     <= 0;
        A_clear_lsd       <= 0;
        A_zre_wr_en       <= 0;
        A_zim_wr_en       <= 0;
        A_zre_wr_ind      <= 0;
        A_zim_wr_ind      <= 0;

        //Datapath
        A_regA     <= 0;
        A_regB     <= 0;
        A_regC     <= 0;
        A_regD     <= 0;
    end else begin
        //Control
        A_zre_reg_sel     <= R_zre_reg_sel;
        A_zim_reg_sel     <= R_zim_reg_sel;
        A_zre_neg_sel     <= R_zre_neg_sel;
        A_zim_neg_sel     <= R_zim_neg_sel;
        A_mov_CtoA        <= R_mov_CtoA;
        A_mov_DtoB        <= R_mov_DtoB;
        A_zre_partial_sel <= R_zre_partial_sel;
        A_zim_partial_sel <= R_zim_partial_sel;
        A_zre_acc_sel     <= R_zre_acc_sel;
        A_zim_acc_sel     <= R_zim_acc_sel;
        A_clear_lsd       <= R_clear_lsd;
        A_zre_wr_en       <= R_zre_wr_en;
        A_zim_wr_en       <= R_zim_wr_en;
        A_zre_wr_ind      <= R_zre_wr_ind;
        A_zim_wr_ind      <= R_zim_wr_ind;

        //Datapath
        if      (A_mov_CtoA)         A_regA <= A_regC;
        else if (A_zre_reg_sel == 0) A_regA <= A_zre_limb_abs;
        else if (A_zim_reg_sel == 0) A_regA <= A_zim_limb_abs;

        if      (A_mov_DtoB)         A_regB <= A_regD;
        else if (A_zre_reg_sel == 1) A_regB <= A_zre_limb_abs;
        else if (A_zim_reg_sel == 1) A_regB <= A_zim_limb_abs;

        if      (A_zre_reg_sel == 2) A_regC <= A_zre_limb_abs;
        else if (A_zim_reg_sel == 2) A_regC <= A_zim_limb_abs;

        if      (A_zre_reg_sel == 3) A_regD <= A_zre_limb_abs;
        else if (A_zim_reg_sel == 3) A_regD <= A_zim_limb_abs;
    end
end


// ---------- Multiply Stage (M) ----------------------------------------------

//Control signals
reg  [2:0]                  M_zre_partial_sel;
reg  [1:0]                  M_zim_partial_sel;
reg  [1:0]                  M_zre_acc_sel;
reg  [1:0]                  M_zim_acc_sel;
reg                         M_clear_lsd;
reg                         M_zre_wr_en;
reg                         M_zim_wr_en;
reg  [LIMB_INDEX_BITS-1:0]  M_zre_wr_ind;
reg  [LIMB_INDEX_BITS-1:0]  M_zim_wr_ind;

//Datapath signals
reg  [LIMB_SIZE_BITS-1:0]   M_cre_limb;
reg  [LIMB_SIZE_BITS-1:0]   M_cim_limb;
reg  [LIMB_SIZE_BITS-1:0]   M_zre_limb;
reg  [LIMB_SIZE_BITS-1:0]   M_zim_limb;

reg  [LIMB_SIZE_BITS-1:0]   M_m1_a;
reg  [LIMB_SIZE_BITS-1:0]   M_m1_b;
reg  [LIMB_SIZE_BITS-1:0]   M_m2_a;
reg  [LIMB_SIZE_BITS-1:0]   M_m2_b;

wire [(LIMB_SIZE_BITS<<1)-1:0] M_m1_out;
wire [(LIMB_SIZE_BITS<<1)-1:0] M_m2_out;

assign M_m1_out = M_m1_a * M_m1_b;
assign M_m2_out = M_m2_a * M_m2_b;

always @* begin
    M_m1_a = A_regA;
    M_m1_b = A_regB;

    M_m2_a = M_zre_limb;
    M_m2_b = M_zim_limb;
end

always @(posedge clock) begin
    if (reset) begin
        //Control
        M_zre_partial_sel <= 0;
        M_zim_partial_sel <= 0;
        M_zre_acc_sel     <= 0;
        M_zim_acc_sel     <= 0;
        M_clear_lsd       <= 0;
        M_zre_wr_en       <= 0;
        M_zim_wr_en       <= 0;
        M_zre_wr_ind      <= 0;
        M_zim_wr_ind      <= 0;

        //Datapath
        M_cre_limb <= 0;
        M_cim_limb <= 0;
        M_zre_limb <= 0;
        M_zim_limb <= 0;
    end else begin
        //Control
        M_zre_partial_sel <= A_zre_partial_sel;
        M_zim_partial_sel <= A_zim_partial_sel;
        M_zre_acc_sel     <= A_zre_acc_sel;
        M_zim_acc_sel     <= A_zim_acc_sel;
        M_clear_lsd       <= A_clear_lsd;
        M_zre_wr_en       <= A_zre_wr_en;
        M_zim_wr_en       <= A_zim_wr_en;
        M_zre_wr_ind      <= A_zre_wr_ind;
        M_zim_wr_ind      <= A_zim_wr_ind;

        //Datapath
        M_cre_limb <= A_cre_limb;
        M_cim_limb <= A_cim_limb;
        M_zre_limb <= A_zre_limb_abs;
        M_zim_limb <= A_zim_limb_abs;
    end
end


// ---------- Execute Stage (X) -----------------------------------------------

//Control signals
reg  [2:0]                  X_zre_partial_sel;
reg  [1:0]                  X_zim_partial_sel;
reg  [1:0]                  X_zre_acc_sel;
reg  [1:0]                  X_zim_acc_sel;
reg                         X_clear_lsd;
reg                         X_zre_wr_en;
reg                         X_zim_wr_en;
reg  [LIMB_INDEX_BITS-1:0]  X_zre_wr_ind;
reg  [LIMB_INDEX_BITS-1:0]  X_zim_wr_ind;

//Datapath signals
reg  [LIMB_SIZE_BITS-1:0]   X_cre_limb;
reg  [LIMB_SIZE_BITS-1:0]   X_cim_limb;

localparam ACCUMULATOR_BITS = (LIMB_SIZE_BITS << 1) + LIMB_INDEX_BITS;
reg  [ACCUMULATOR_BITS-1:0] X_m1_out;
reg  [ACCUMULATOR_BITS-1:0] X_m2_out;

reg  signed [ACCUMULATOR_BITS-1:0] X_zre_acc; //zre accumulator
reg  signed [ACCUMULATOR_BITS-1:0] X_zim_acc; //zim accumulator

reg  [ACCUMULATOR_BITS-1:0] X_zre_partial;
reg  [ACCUMULATOR_BITS-1:0] X_zim_partial;
reg  [ACCUMULATOR_BITS-1:0] X_zre_acc_next;
reg  [ACCUMULATOR_BITS-1:0] X_zim_acc_next;

wire [LIMB_SIZE_BITS-1:0]   X_zre_limb_out;
wire [LIMB_SIZE_BITS-1:0]   X_zim_limb_out;

reg  [ACCUMULATOR_BITS-1:0] X_diverge_acc;
reg  [ACCUMULATOR_BITS-1:0] X_diverge_partial;
reg  [ACCUMULATOR_BITS-1:0] X_diverge_acc_next;

assign X_zre_limb_out = X_zre_acc_next[LIMB_SIZE_BITS-1:0];
assign X_zim_limb_out = X_zim_acc_next[LIMB_SIZE_BITS-1:0];

always @* begin
    X_zre_partial = 0;
    X_zim_partial = 0;

    case (X_zre_partial_sel)
        1: X_zre_partial =  X_m1_out << 1;
        2: X_zre_partial = -X_m1_out << 1;
        3: X_zre_partial =  X_m1_out;
        4: X_zre_partial = -X_m1_out;
    endcase
    case (X_zim_partial_sel)
        1: X_zim_partial =  X_m2_out << 1;
        2: X_zim_partial = -X_m2_out << 1;
    endcase

    X_diverge_partial = 0;
    case (X_zre_partial_sel)
        1: X_diverge_partial = X_m1_out << 1;
        2: X_diverge_partial = X_m1_out << 1;
        3: X_diverge_partial = X_m1_out;
        4: X_diverge_partial = X_m1_out;
    endcase

    X_diverge_acc_next = X_diverge_acc;
    case (X_zre_acc_sel)
        0: X_diverge_acc_next = X_diverge_partial + X_diverge_acc;
        1: X_diverge_acc_next = X_diverge_partial + (X_diverge_acc >> LIMB_SIZE_BITS);
        2: X_diverge_acc_next = X_diverge_partial + 0;
        3: X_diverge_acc_next = X_diverge_acc;
    endcase

    X_zre_acc_next = X_zre_acc;
    X_zim_acc_next = X_zim_acc;

    case (X_zre_acc_sel)
        0: X_zre_acc_next = X_zre_partial + X_zre_acc;                                                  //Add partial into the accumulator
        1: X_zre_acc_next = X_zre_partial + $signed(X_zre_acc >>> LIMB_SIZE_BITS) + X_cre_limb;         //Shift accumulator to only store the carry and add partial and c
        2: X_zre_acc_next = X_zre_partial + 0;                                                          //Set accumulator to partial
        3: X_zre_acc_next = X_zre_acc;                                                                  //Do nothing
        default: $display("[ERROR] X_zre_acc_sel has illegal value: %b", X_zre_acc_sel);
    endcase
    case (X_zim_acc_sel)
        0: X_zim_acc_next = X_zim_partial + X_zim_acc;                                                  //Add partial into the accumulator
        1: X_zim_acc_next = X_zim_partial + $signed(X_zim_acc >>> LIMB_SIZE_BITS) + X_cim_limb;         //Shift accumulator to only store the carry and add partial and c
        2: X_zim_acc_next = X_zim_partial + 0;                                                          //Set accumulator to partial
        3: X_zim_acc_next = X_zim_acc;                                                                  //Do nothing
        default: $display("[ERROR] X_zim_acc_sel has illegal value: %b", X_zim_acc_sel);
    endcase

end

always @(posedge clock) begin
    if (reset) begin
        //Control
        X_zre_partial_sel <= 0;
        X_zim_partial_sel <= 0;
        X_zre_acc_sel     <= 0;
        X_zim_acc_sel     <= 0;
        X_clear_lsd       <= 0;
        X_zre_wr_en       <= 0;
        X_zim_wr_en       <= 0;
        X_zre_wr_ind      <= 0;
        X_zim_wr_ind      <= 0;

        //Datapath
        X_cre_limb      <= 0;
        X_cim_limb      <= 0;
        X_m1_out        <= 0;
        X_m2_out        <= 0;
        X_zre_acc       <= 0;
        X_zim_acc       <= 0;
        X_diverge_acc   <= 0;
    end else begin
        //Control
        X_zre_partial_sel <= M_zre_partial_sel;
        X_zim_partial_sel <= M_zim_partial_sel;
        X_zre_acc_sel     <= M_zre_acc_sel;
        X_zim_acc_sel     <= M_zim_acc_sel;
        X_clear_lsd       <= M_clear_lsd;
        X_zre_wr_en       <= M_zre_wr_en;
        X_zim_wr_en       <= M_zim_wr_en;
        X_zre_wr_ind      <= M_zre_wr_ind;
        X_zim_wr_ind      <= M_zim_wr_ind;

        //Datapath
        X_cre_limb      <= M_cre_limb;
        X_cim_limb      <= M_cim_limb;
        X_m1_out        <= M_m1_out;
        X_m2_out        <= M_m2_out;
        X_zre_acc       <= X_zre_acc_next;
        X_zim_acc       <= X_zim_acc_next;
        X_diverge_acc   <= X_diverge_acc_next;
    end
end


// ---------- Write Stage (W) -------------------------------------------------

//Control signals
reg                         W_clear_lsd;
reg                         W_zre_wr_en;
reg                         W_zim_wr_en;
reg  [LIMB_INDEX_BITS-1:0]  W_zre_wr_ind;
reg  [LIMB_INDEX_BITS-1:0]  W_zim_wr_ind;

//Datapath signals
reg  [LIMB_SIZE_BITS-1:0]   W_zre_limb;
reg  [LIMB_SIZE_BITS-1:0]   W_zim_limb;

assign W_diverged = X_diverge_acc >= DIVERGENCE_RADIUS;

assign W_zre_sign = W_zre_limb[LIMB_SIZE_BITS-1];
assign W_zim_sign = W_zim_limb[LIMB_SIZE_BITS-1];

always @(posedge clock) begin
    if (reset) begin
        //Control
        W_clear_lsd   <= 0;
        W_zre_wr_en   <= 0;
        W_zim_wr_en   <= 0;
        W_zre_wr_ind  <= 0;
        W_zim_wr_ind  <= 0;

        //Datapath
        W_zre_limb <= 0;
        W_zim_limb <= 0;
        W_zre_lsd  <= 0;
        W_zim_lsd  <= 0;
    end else begin
        //Control
        W_clear_lsd   <= X_clear_lsd;
        W_zre_wr_en   <= X_zre_wr_en;
        W_zim_wr_en   <= X_zim_wr_en;
        W_zre_wr_ind  <= X_zre_wr_ind;
        W_zim_wr_ind  <= X_zim_wr_ind;

        //Datapath
        W_zre_limb <= X_zre_limb_out;
        W_zim_limb <= X_zim_limb_out;

        if (W_clear_lsd) begin
            W_zre_lsd <= 0;
            W_zim_lsd <= 0;
        end else begin
            if (W_zre_wr_en && W_zre_limb != 0 && W_zre_wr_ind > W_zre_lsd) W_zre_lsd <= W_zre_wr_ind;
            if (W_zim_wr_en && W_zim_limb != 0 && W_zim_wr_ind > W_zim_lsd) W_zim_lsd <= W_zim_wr_ind;
        end

    end
end


// ---------- Ram Read and Write ----------------------------------------------

always @(posedge clock) begin
    //Read
    A_cre_limb <= cre_ram[R_c_limb_ind];
    A_cim_limb <= cim_ram[R_c_limb_ind];
    A_zre_limb <= zre_ram[R_zre_rd_ind];
    A_zim_limb <= zim_ram[R_zim_rd_ind];

    //Write
    if (L_cre_wr_en) cre_ram[R_c_limb_ind] <= L_cre_limb;
    if (L_cim_wr_en) cim_ram[R_c_limb_ind] <= L_cim_limb;
    if (W_zre_wr_en) zre_ram[W_zre_wr_ind] <= W_zre_limb;
    if (W_zim_wr_en) zim_ram[W_zim_wr_ind] <= W_zim_limb;
end

endmodule

`endif
