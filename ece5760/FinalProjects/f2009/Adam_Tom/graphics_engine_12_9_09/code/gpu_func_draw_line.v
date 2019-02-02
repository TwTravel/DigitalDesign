//drawLine function module.  Implementation based on the example code provided
//by Bruce Land: http://instruct1.cit.cornell.edu/courses/ee476/video/videoGCC/3D/video_144x150_16MHz_3D_GCC644.c.

`include "gpu_inst_controller.vh"
`include "draw_line.vh"
`include "disp_controller.vh"

//`define DEBUG
`undef DEBUG
`include "debug.vh"


// Additional defines (for clarity only)
/*
`define LOOPCOUNTER_WIDTH `GPU_MAX_WIDTH
`define LOOPCOUNTER_RANGE `GPU_MAX_RANGE
`define ERROR_WIDTH `GPU_MAX_WIDTH+1
`define ERROR_RANGE `GPU_MAX_WIDTH:0
*/
module gpu_func_draw_line(
    input                             clk,
    input                             reset,
    //Function control interface.
    input                             pause,
    input                             start,
    output reg                        finished,
    //Function parameter interface.
    input [`GPU_X_RANGE]             x1,
    input [`GPU_Y_RANGE]             y1,
    input [`GPU_X_RANGE]             x2,
    input [`GPU_Y_RANGE]             y2,
    input [`INST_COLOR_R_RANGE]       r_in,
    input [`INST_COLOR_G_RANGE]       g_in,
    input [`INST_COLOR_B_RANGE]       b_in,
    //Output interface.
    output reg [`GPU_X_RANGE]        pos_x,
    output reg [`GPU_Y_RANGE]        pos_y,
    output wire [`INST_COLOR_R_RANGE] pixel_r,
    output wire [`INST_COLOR_G_RANGE] pixel_g,
    output wire [`INST_COLOR_B_RANGE] pixel_b

//    output wire                       xchange,

);

    `PRESERVE reg [`ERROR_RANGE] error; //Error of last pixel placement

    /* Since all pixels that will be "visited" by (pos_x,pos_y) will be drawn
    * to the input color, we can just hardwire the color inputs directly to
    * the color outputs. */
    assign pixel_r = r_in;
    assign pixel_g = g_in;
    assign pixel_b = b_in;

    /* Calculate sign and magnitude of dx and dy */
    wire [`GPU_MAX_RANGE]        dx_mag_prechange; // |dx| before switching due to octant
    wire [`GPU_MAX_RANGE]        dy_mag_prechange; // |dy| before switching due to octant
    `KEEP wire [`GPU_MAX_RANGE]        dx_mag;           // |dx| after switch
    `KEEP wire [`GPU_MAX_RANGE]        dy_mag;           // |dy| after switch
    `KEEP wire signed [`GPU_MAX_RANGE] dx_sign;
    `KEEP wire signed [`GPU_MAX_RANGE] dy_sign;

    /* Flag a swap between dx and dy
    0 if dy <= dx, 1 if dy > dx */
    `KEEP wire                 xchange;

    /* Take absolute values of dx and dy */
    assign dx_mag_prechange = (x2 < x1)  ? x1 - x2 :
                              (x2 == x1) ? `GPU_X_WIDTH'b0 :
                                           x2 - x1;

    assign dy_mag_prechange = (y2 < y1)  ? y1 - y2 :
                              (y2 == y1) ? `GPU_Y_WIDTH'b0 :
                                           y2 - y1;

    /* Swap |dx| and |dy| if |dy|>|dx| */                                       
    assign dx_mag = (dy_mag_prechange > dx_mag_prechange) ? dy_mag_prechange : 
                                                            dx_mag_prechange;

    assign dy_mag = (dy_mag_prechange > dx_mag_prechange) ? dx_mag_prechange :
                                                            dy_mag_prechange;

    /* Assign signs of dx and dy */
    assign dx_sign = (x2 < x1)  ? -`GPU_MAX_WIDTH'd1 :
                     (x2 == x1) ? `GPU_MAX_WIDTH'd0  :
                                  `GPU_MAX_WIDTH'd1;
    
    assign dy_sign = (y2 < y1)  ? -`GPU_MAX_WIDTH'd1 :
                     (y2 == y1) ? `GPU_MAX_WIDTH'd0  :
                                  `GPU_MAX_WIDTH'd1;
    
    assign xchange = dy_mag_prechange > dx_mag_prechange;

    /* Declare loop registers */

    reg [`LOOPCOUNTER_RANGE] loopcounter;  //Loop counter
//    `PRESERVE reg signed [`ERROR_RANGE] error; //Error of last pixel placement

    /* Iterate */
    always @ (posedge clk) begin
        
        loopcounter <= reset ? `LOOPCOUNTER_WIDTH'b0 : 
                       start ? dx_mag + `LOOPCOUNTER_WIDTH'b1 :
                       pause ? loopcounter :
                       (loopcounter != `LOOPCOUNTER_WIDTH'b0) ? loopcounter - `LOOPCOUNTER_WIDTH'b1 :
                                                                loopcounter;

        finished <= reset ? 1'b0 :
                    start ? 1'b0 :
                    pause ? 1'b0 :
                    (loopcounter <= `LOOPCOUNTER_WIDTH'd2) ? 1'b1 :
                    finished;
        
        pos_x <= start ? x1 :
                 pause ? pos_x :
                 finished ? pos_x :
                 (~error[`ERROR_WIDTH-1] && xchange == 1'b1) ? pos_x + dx_sign :
                 (xchange != 1'b1) ? pos_x + dx_sign :
                                     pos_x;
                 
        pos_y <= start ? y1 :
                 pause ? pos_y :
                 finished ? pos_y :
                 (~error[`ERROR_WIDTH-1] && xchange != 1'b1) ? pos_y + dy_sign :
                 (xchange == 1'b1) ? pos_y + dy_sign :
                                     pos_y;

        error <= start ? (dy_mag << 1) - dx_mag :
                 pause ? error :
                 finished ? error :
                 //(error >= `ERROR_WIDTH'h0) ? error + (dy_mag << 1) - (dx_mag << 1):
                 //                             error + (dy_mag << 1);
                 (~error[`ERROR_WIDTH-1]) ? error + (dy_mag << 1) - (dx_mag << 1):
                                          error + (dy_mag << 1);
    end
endmodule

