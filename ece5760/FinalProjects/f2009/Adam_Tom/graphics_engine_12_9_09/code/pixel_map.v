`include "gpu_inst_controller.vh"

module pixel_map(
    input [`GPU_X_RANGE] pos_x,
    input [`GPU_Y_RANGE] pos_y,
    output wire [17:0] addr,
    output wire        out_of_range);

   assign addr = pos_y*`GPU_Y_WIDTH'd`GPU_DISP_WIDTH+pos_x;

   assign out_of_range = pos_x>`GPU_X_MAX || pos_y>`GPU_Y_MAX;
   
endmodule