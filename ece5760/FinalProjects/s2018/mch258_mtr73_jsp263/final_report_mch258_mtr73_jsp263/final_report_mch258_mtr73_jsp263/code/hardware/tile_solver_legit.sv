`ifndef _tile_solver_legit_v_
`define _tile_solver_legit_v_

`include "solver.v"

module tile_solver_legit #(
    parameter TILE_WIDTH_BITS   = 5,
    parameter LIMB_INDEX_BITS   = 6,
    parameter LIMB_SIZE_BITS    = 27,
    parameter DIVERGENCE_RADIUS = 4
) (
    input clock,
    input reset,

    input [31:0] in_data,
    input        in_valid,
    output reg   in_ready,

    // Assert in_end_of_stream after the input packet has been provided.
    // The next cycle must have in_valid = 0 (no data moves)
    input        in_end_of_stream,

    output reg [31:0] out_addr,
    output reg [15:0] out_data,
    output reg        out_valid,
    input             out_ready
);

// Solver instance
reg                       solver_wr_real_en;
reg                       solver_wr_imag_en;
reg [LIMB_INDEX_BITS-1:0] solver_wr_index;
reg [LIMB_SIZE_BITS-1:0]  solver_real_data;
reg [LIMB_SIZE_BITS-1:0]  solver_imag_data;

reg                       solver_wr_num_limbs_en;
reg [LIMB_INDEX_BITS-1:0] solver_num_limbs_data;

reg                       solver_wr_iter_lim_en;
reg [15:0]                solver_iter_lim_data;

reg                       solver_start;


reg                       next_solver_wr_real_en;
reg                       next_solver_wr_imag_en;
reg [LIMB_INDEX_BITS-1:0] next_solver_wr_index;
reg [LIMB_SIZE_BITS-1:0]  next_solver_real_data;
reg [LIMB_SIZE_BITS-1:0]  next_solver_imag_data;

reg                       next_solver_wr_num_limbs_en;
reg [LIMB_INDEX_BITS-1:0] next_solver_num_limbs_data;

reg                       next_solver_wr_iter_lim_en;
reg [15:0]                next_solver_iter_lim_data;

reg                       next_solver_start;

always @(posedge clock) begin
    solver_wr_real_en <= next_solver_wr_real_en;
    solver_wr_imag_en <= next_solver_wr_imag_en;
    solver_wr_index <= next_solver_wr_index;
    solver_real_data <= next_solver_real_data;
    solver_imag_data <= next_solver_imag_data;

    solver_wr_num_limbs_en <= next_solver_wr_num_limbs_en;
    solver_num_limbs_data <= next_solver_num_limbs_data;

    solver_wr_iter_lim_en <= next_solver_wr_iter_lim_en;
    solver_iter_lim_data <= next_solver_iter_lim_data;

    solver_start <= next_solver_start;
end


wire        solver_out_ready;
wire [15:0] solver_iterations;

solver #(
    LIMB_INDEX_BITS,
    LIMB_SIZE_BITS,
    DIVERGENCE_RADIUS
) solv (
    .clock(clock),
    .reset(reset),

    .wr_real_en(solver_wr_real_en),
    .wr_imag_en(solver_wr_imag_en),
    .wr_index(solver_wr_index),
    .real_data(solver_real_data),
    .imag_data(solver_imag_data),
    .wr_num_limbs_en(solver_wr_num_limbs_en),
    .num_limbs_data(solver_num_limbs_data),
    .wr_iter_lim_en(solver_wr_iter_lim_en),
    .iter_lim_data(solver_iter_lim_data),

    .start(solver_start),

    .out_ready(solver_out_ready),
    .iterations(solver_iterations)
);

// Read/write logic
`define ST_READ_INPUT       3'd0
`define ST_WAIT_CYCLE       3'd1
`define ST_SOLVING_PIXEL    3'd2
`define ST_WRITE_OUTPUT     3'd3
`define ST_SET_LIMB_1       3'd4
`define ST_SET_LIMB_2       3'd5

reg [2:0] state;
reg [2:0] next_state;

reg [31:0] addr;
reg [31:0] next_addr;

reg [31:0] iterator_shift;
reg [31:0] next_iterator_shift;

reg [TILE_WIDTH_BITS * 2 - 1 : 0] iterator;
reg [TILE_WIDTH_BITS * 2 - 1 : 0] next_iterator;

reg [LIMB_INDEX_BITS-1 : 0] num_limbs;
reg [LIMB_INDEX_BITS-1 : 0] next_num_limbs;

reg [LIMB_SIZE_BITS * 2 - 1 : 0] lowest_limbs_re;
reg [LIMB_SIZE_BITS * 2 - 1 : 0] next_lowest_limbs_re;
reg [LIMB_SIZE_BITS * 2 - 1 : 0] lowest_limbs_im;
reg [LIMB_SIZE_BITS * 2 - 1 : 0] next_lowest_limbs_im;

always @(posedge clock) begin
    if (reset) begin
        state <= `ST_READ_INPUT;
        addr <= 0;
        iterator_shift <= 0;
        iterator <= 0;
        num_limbs <= 0;
        lowest_limbs_re <= 0;
        lowest_limbs_im <= 0;
    end else begin
        state <= next_state;
        addr <= next_addr;
        iterator_shift <= next_iterator_shift;
        iterator <= next_iterator;
        num_limbs <= next_num_limbs;
        lowest_limbs_re <= next_lowest_limbs_re;
        lowest_limbs_im <= next_lowest_limbs_im;
    end
end

// ST_READ_INPUT variables
wire [2:0]    in_data_type;
wire [31:0]   in_data_decoded;

assign in_data_type = in_data[31:29];
assign in_data_decoded = {3'd0, in_data[28:0]};

reg [LIMB_INDEX_BITS-1:0] re_write_index;
reg [LIMB_INDEX_BITS-1:0] next_re_write_index;

reg [LIMB_INDEX_BITS-1:0] im_write_index;
reg [LIMB_INDEX_BITS-1:0] next_im_write_index;

always @(posedge clock) begin
    if (reset) begin
        re_write_index <= 0;
        im_write_index <= 0;
    end else begin
        re_write_index <= next_re_write_index;
        im_write_index <= next_im_write_index;
    end
end

// ST_WRITE_OUTPUT
reg [15:0] saved_iterations;
reg [15:0] next_saved_iterations;

always @(posedge clock) begin
    if (reset) begin
        saved_iterations <= 0;
    end else begin
        saved_iterations <= next_saved_iterations;
    end
end

// ST_SET_LIMB
wire [TILE_WIDTH_BITS-1 : 0] x_for_pixel;
wire [TILE_WIDTH_BITS-1 : 0] y_for_pixel;
assign x_for_pixel = iterator[TILE_WIDTH_BITS - 1 : 0];
assign y_for_pixel = iterator[TILE_WIDTH_BITS * 2 - 1 : TILE_WIDTH_BITS];

wire [LIMB_SIZE_BITS * 2 - 1 : 0] lowest_limbs_re_for_pixel;
wire [LIMB_SIZE_BITS * 2 - 1 : 0] lowest_limbs_im_for_pixel;
assign lowest_limbs_re_for_pixel = lowest_limbs_re | ({ /*(LIMB_SIZE_BITS * 2)*/{1'b0}, x_for_pixel} << iterator_shift);
assign lowest_limbs_im_for_pixel = lowest_limbs_im | ({ /*(LIMB_SIZE_BITS * 2)*/{4{1'b0}}, y_for_pixel} << iterator_shift);

// The logic
always @(*) begin
    // Set defaults
    next_state = state;
    next_addr = addr;
    next_iterator_shift = iterator_shift;
    next_iterator = iterator;
    next_num_limbs = num_limbs;

    next_lowest_limbs_re = lowest_limbs_re;
    next_lowest_limbs_im = lowest_limbs_im;

    in_ready = 0;

    out_addr = 0;
    out_data = 0;
    out_valid = 0;

    // Solver
    next_solver_wr_real_en = 0;
    next_solver_wr_imag_en = 0;
    next_solver_wr_index   = 0;
    next_solver_real_data  = in_data_decoded;
    next_solver_imag_data  = in_data_decoded;

    next_solver_wr_num_limbs_en = 0;
    next_solver_num_limbs_data = in_data_decoded;

    next_solver_wr_iter_lim_en = 0;
    next_solver_iter_lim_data = in_data_decoded;

    next_solver_start = 0;

    // ST_READ_INPUT
    next_re_write_index = 0;
    next_im_write_index = 0;

    // ST_WRITE_OUTPUT
    next_saved_iterations = saved_iterations;

    /////////////////////////////// State machine //////////////////////////////

    // ST_READ_INPUT
    if (state == `ST_READ_INPUT) begin
        in_ready = 1;

        next_iterator = 0;

        next_re_write_index = re_write_index;
        next_im_write_index = im_write_index;

        if (in_valid) begin
            // Set tile output address
            if (in_data_type == 3'd0) begin
                next_addr = in_data_decoded;
            end
            // Set number of limbs
            else if (in_data_type == 3'd1) begin
                next_solver_wr_num_limbs_en = 1;
                next_solver_num_limbs_data = in_data_decoded;
                next_num_limbs = in_data_decoded;
            end
            // Write a limb of c_real.
            else if (in_data_type == 3'd2) begin
                next_re_write_index = re_write_index + 1;
                next_solver_wr_index = re_write_index;
                next_solver_wr_real_en = 1;

                next_lowest_limbs_re = {
                    lowest_limbs_re[LIMB_SIZE_BITS - 1 : 0],
                    in_data_decoded[LIMB_SIZE_BITS - 1 : 0]
                };
            end
            // Write a limb of c_imag.
            else if (in_data_type == 3'd3) begin
                next_im_write_index = im_write_index + 1;
                next_solver_wr_index = im_write_index;
                next_solver_wr_imag_en = 1;

                next_lowest_limbs_im = {
                    lowest_limbs_im[LIMB_SIZE_BITS - 1 : 0],
                    in_data_decoded[LIMB_SIZE_BITS - 1 : 0]
                };
            end
            // Write the maximum number of iterations
            else if (in_data_type == 3'd4) begin
                next_solver_wr_iter_lim_en = 1;
                next_solver_iter_lim_data = in_data_decoded;
            end
            // Write the number of bits, from the right hand edge of the last
            // limb, to offset the x/y value of the iteration from.
            else if (in_data_type == 3'd5) begin
                next_iterator_shift = in_data_decoded;
            end


            // Start the solver
            if (in_end_of_stream) begin
                next_state = `ST_WAIT_CYCLE;
                next_solver_start = 1;
            end
        end
    end

    // ST_WAIT_CYCLE
    if (state == `ST_WAIT_CYCLE) begin
        // We wait a cycle for the solver to get the restart signal,
        // because otherwise the solver might still have out_ready
        // asserted from last time
        next_state = `ST_SOLVING_PIXEL;
    end

    // ST_SOLVING_PIXEL
    if (state == `ST_SOLVING_PIXEL) begin
        if (solver_out_ready) begin
            next_state = `ST_WRITE_OUTPUT;
            next_saved_iterations = solver_iterations;
        end
    end

    // ST_WRITE_OUTPUT
    if (state == `ST_WRITE_OUTPUT) begin
        //$display("iterations: %d", saved_iterations);

        out_addr = addr + 2 * iterator;
        out_data = saved_iterations;
        out_valid = 1;

        if (out_ready) begin
            if (iterator == '1) begin
                // We've iterated through all the pixels
                next_state = `ST_READ_INPUT;
            end else begin
                // Calculate the next pixel
                next_iterator = iterator + 1;
                next_state = `ST_SET_LIMB_1;
            end
        end
    end

    // ST_SET_LIMB_1
    if (state == `ST_SET_LIMB_1) begin
        next_solver_real_data = lowest_limbs_re_for_pixel[LIMB_SIZE_BITS * 2 - 1 : LIMB_SIZE_BITS];
        next_solver_imag_data = lowest_limbs_im_for_pixel[LIMB_SIZE_BITS * 2 - 1 : LIMB_SIZE_BITS];

        next_solver_wr_real_en = 1;
        next_solver_wr_imag_en = 1;

        next_solver_wr_index = num_limbs - 2;

        next_state = `ST_SET_LIMB_2;
    end

    // ST_SET_LIMB_2
    if (state == `ST_SET_LIMB_2) begin
        next_solver_real_data = lowest_limbs_re_for_pixel[LIMB_SIZE_BITS - 1 : 0];
        next_solver_imag_data = lowest_limbs_im_for_pixel[LIMB_SIZE_BITS - 1 : 0];

        next_solver_wr_real_en = 1;
        next_solver_wr_imag_en = 1;

        next_solver_wr_index = num_limbs - 1;

        next_solver_start = 1;
        next_state = `ST_WAIT_CYCLE; //`ST_START_SOLVER;
    end

    // ST_START_SOLVER
    /*if (state == `ST_START_SOLVER) begin
        next_state = `ST_WAIT_CYCLE;
    end*/
end

endmodule

`endif
