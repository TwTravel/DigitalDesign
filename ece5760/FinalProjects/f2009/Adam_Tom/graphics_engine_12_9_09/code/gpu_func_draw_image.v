`include "gpu_inst_controller.vh"

module gpu_func_draw_image(
    input                             clk,
    input                             reset,
    //Function control interface.
    input                             pause,
    input                             start,
    output wire                       finished,
    //Function parameter interface.
    input [`GPU_X_RANGE]              x1,
    input [`GPU_Y_RANGE]              y1,
    //BMP decoder interface.
    output wire                       bmp_pause,
    output wire                       bmp_start,
    input                             bmp_finished,
    input                             bmp_pixel_valid,
    input [`GPU_X_RANGE]              bmp_x,
    input [`GPU_Y_RANGE]              bmp_y,
    input [`INST_COLOR_R_RANGE]       bmp_r,
    input [`INST_COLOR_G_RANGE]       bmp_g,
    input [`INST_COLOR_B_RANGE]       bmp_b,
    //Output interface.
    output wire                       pixel_valid,
    output wire [`GPU_X_RANGE]        pos_x,
    output wire [`GPU_Y_RANGE]        pos_y,
    output wire [`INST_COLOR_R_RANGE] pixel_r,
    output wire [`INST_COLOR_G_RANGE] pixel_g,
    output wire [`INST_COLOR_B_RANGE] pixel_b);

   //BMP decoder.
   assign bmp_pause = pause;
   assign bmp_start = start;
   assign finished = bmp_finished;
   assign pixel_valid = bmp_pixel_valid;
   assign pos_x = x1 + bmp_x;
   assign pos_y = y1 + bmp_y;
   assign pixel_r = bmp_r;
   assign pixel_g = bmp_g;
   assign pixel_b = bmp_b;
   
endmodule