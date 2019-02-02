`include "gpu_inst_controller.vh"

module gpu_func_draw_rect(
    input                             clk,
    input                             reset,
    //Function control interface.
    input                             pause,
    input                             start,
    output reg                        finished,
    //Function parameter interface.
    input [`GPU_X_RANGE]              x1,
    input [`GPU_Y_RANGE]              y1,
    input [`GPU_X_RANGE]              x2,
    input [`GPU_Y_RANGE]              y2,
    input [`INST_COLOR_R_RANGE]       r_in,
    input [`INST_COLOR_G_RANGE]       g_in,
    input [`INST_COLOR_B_RANGE]       b_in,
    //Output interface.
    output wire                       pixel_valid,
    output reg [`GPU_X_RANGE]         pos_x,
    output reg [`GPU_Y_RANGE]         pos_y,
    output wire [`INST_COLOR_R_RANGE] pixel_r,
    output wire [`INST_COLOR_G_RANGE] pixel_g,
    output wire [`INST_COLOR_B_RANGE] pixel_b);

   //Limit (X2,Y2).
   wire [`GPU_X_RANGE] max_x;
   assign max_x = x2>`GPU_X_MAX ? `GPU_X_MAX : x2;
   wire [`GPU_Y_RANGE] max_y;
   assign max_y = y2>`GPU_Y_MAX ? `GPU_Y_MAX : y2;

   assign pixel_valid = !finished && !reset;

   always @(posedge clk) begin
      finished <= reset ? 1'b1 :
                  start ? 1'b0 :
                  pause ? finished :
                  pos_x==max_x && pos_y==max_y ? 1'b1 :
                  finished;

      pos_x <= start ? x1 :
               pause ? pos_x :
               finished ? pos_x :
               pos_x==max_x ? x1 :
               pos_x+`GPU_X_WIDTH'h1;

      pos_y <= start ? y1 :
               pause ? pos_y :
               finished ? pos_y :
               pos_x!=max_x ? pos_y :
               pos_y+`GPU_Y_WIDTH'h1;
   end // always @ (posedge clk)

   assign pixel_r = r_in;
   assign pixel_g = g_in;
   assign pixel_b = b_in;
   
endmodule