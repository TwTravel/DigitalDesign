`include "disp_controller.vh"
`include "gpu_inst_controller.vh"

//`define DEBUG
`undef DEBUG
`include "debug.vh"

`include "image_decode_bmp.vh"

module gpu(
    input                             clk_27,
    input                             reset,
    //Processor interface.
    input                             clk_cpu,
    input                             cpu_inst_valid,
    input [29:0]                      cpu_data_in,
    output                            cpu_bp,
    //DMA interface.
    input                             clk_dma,
    input                             dma_data_valid,
    output wire                       dma_ready,
    input [15:0]                      dma_data,
    //RAM interface.
    inout [15:0]                      ram_dq,
    output [17:0]                     ram_addr,
    output                            ram_ub_n,
    output                            ram_lb_n,
    output                            ram_we_n,
    //Display interface.
    output wire                       clk_disp,
    output wire                       disp_hs_n,
    output wire                       disp_vs_n,
    output wire                       disp_blank_n,
    output wire                       disp_sync,
    output wire [`DISP_COLOR_R_RANGE] disp_r,
    output wire [`DISP_COLOR_G_RANGE] disp_g,
    output wire [`DISP_COLOR_B_RANGE] disp_b,
    //Debug
    output wire                       cmd_active,
    input                             layer_en);

   //Generate display and system clocks from 27 MHz reference.
   //The system clock is twice the display clock.
   `KEEP wire clk_gpu;
   gpu_pll pll(.inclk0(clk_27),
               .c0(clk_disp),
               .c1(clk_gpu));

   //On reset force a clear.
   `KEEP wire reset_clear_start;
   `KEEP wire reset_clear_finished;
   `PRESERVE reg [1:0] reset_state;
   `PRESERVE reg reset_clear_layer;
   always @(posedge clk_gpu) begin
      if(reset) begin
         reset_state <= 2'd0;
         reset_clear_layer <= `GPU_LAYER_BG;
      end
      else begin
         case(reset_state)
           2'd0: begin
              reset_state <= reset_clear_start ? 2'd1 : 2'd0;
           end
           2'd1: begin
              reset_state <= reset_clear_start ? 2'd2 : 2'd1;
              reset_clear_layer <= reset_clear_finished ? `GPU_LAYER_FG : reset_clear_layer;
           end
           2'd2: begin
              reset_state <= reset_clear_finished ? 2'd3 : 2'd2;
           end
           default: reset_state <= 2'd3;
         endcase // case (reset_state)
      end
   end // always @ (posedge clk_gpu)

   `KEEP wire reset_clear_pending;
   assign reset_clear_pending = reset_state!=2'd3;

   //Assert reset instruction to controller to
   //force clears at startup.
   `KEEP wire [29:0] reset_inst;
   assign reset_inst[`INST_CMD_RANGE] = `CMD_CLEAR;
   assign reset_inst[0] = reset_clear_layer;

   //Pause all display hardware will display is drawing.
   //This does not take effect until after post-reset clear.
   `KEEP wire disp_drawing;
   wire func_draw_priority;
   assign disp_drawing = disp_blank_n && !func_draw_priority;

   wire disp_drawing_km1;
   delay disp_drawing_delay(.clk(clk_disp),
                            .reset(reset),
                            .in(disp_drawing),
                            .out(disp_drawing_km1));

   //Pause hardware for one additional cycle after
   //a display draw to allow memory setup.
   `KEEP wire gpu_pause;
   `KEEP wire fg_en_mismatch_pause;
   assign gpu_pause = disp_drawing || disp_drawing_km1 || (fg_en_mismatch_pause && layer==`GPU_LAYER_FG);

   //Incoming instruction FIFO.
   `KEEP wire read_next_inst;
   `KEEP wire [29:0] inst_data;
   `KEEP wire inst_fifo_empty;
   wire inst_fifo_full;
   `KEEP wire [6:0] inst_fifo_wr_count;
   gpu_inst_fifo inst_fifo(.aclr(reset),
                           .rdclk(clk_gpu),
                           .rdreq(read_next_inst),
                           .q(inst_data),
                           .rdempty(inst_fifo_empty),
                           .wrclk(clk_cpu),
                           .wrreq(cpu_inst_valid),
                           .data(cpu_data_in),
                           .wrusedw(inst_fifo_wr_count),
                           .wrfull(inst_fifo_full));

   assign cpu_bp = inst_fifo_full || reset_clear_pending;

   //Function start/stop/active signals.
   `KEEP wire func_draw_rect_start;
   `KEEP wire func_draw_rect_active;
   `KEEP wire func_draw_rect_finished;
   `KEEP wire func_draw_line_start;
   `KEEP wire func_draw_line_active;
   `KEEP wire func_draw_line_finished;
   `KEEP wire func_draw_image_start;
   `KEEP wire func_draw_image_active;
   `KEEP wire func_draw_image_finished;
   `KEEP wire func_load_font_start;
   `KEEP wire func_load_font_active;
   `KEEP wire func_load_font_finished;
   `KEEP wire func_draw_string_start;
   `KEEP wire func_draw_string_active;
   `KEEP wire func_draw_string_finished;
   wire function_active_n;
   
   assign cmd_active = ~function_active_n;

   //Instruction controller/decoder.
   wire read_next;
   wire layer;
   wire fg_en;
   wire pixel_clear;
   wire [`GPU_X_RANGE] x1;
   wire [`GPU_Y_RANGE] y1;
   wire [`GPU_X_RANGE] x2;
   wire [`GPU_Y_RANGE] y2;
   wire [`INST_COLOR_R_RANGE] color_r;
   wire [`INST_COLOR_G_RANGE] color_g;
   wire [`INST_COLOR_B_RANGE] color_b;
   gpu_inst_controller inst_controller(.clk(clk_gpu),
                                       .reset(reset),
                                       .inst_fifo_empty(inst_fifo_empty && !reset_clear_pending),
                                       .inst_data(reset_clear_pending ? reset_inst : inst_data),
                                       .read_inst(read_next),
                                       .layer(layer),
                                       .fg_en(fg_en),
                                       .x1(x1),
                                       .y1(y1),
                                       .x2(x2),
                                       .y2(y2),
                                       .r(color_r),
                                       .g(color_g),
                                       .b(color_b),
                                       .func_draw_priority(func_draw_priority),
                                       .pixel_clear(pixel_clear),
                                       .func_draw_rect_start(func_draw_rect_start),
                                       .func_draw_rect_active(func_draw_rect_active),
                                       .func_draw_rect_finished(func_draw_rect_finished),
                                       .func_draw_line_start(func_draw_line_start),
                                       .func_draw_line_active(func_draw_line_active),
                                       .func_draw_line_finished(func_draw_line_finished),
                                       .func_draw_image_start(func_draw_image_start),
                                       .func_draw_image_active(func_draw_image_active),
                                       .func_draw_image_finished(func_draw_image_finished),
                                       .func_load_font_start(func_load_font_start),
                                       .func_load_font_active(func_load_font_active),
                                       .func_load_font_finished(func_load_font_finished),
                                       .func_draw_string_start(func_draw_string_start),
                                       .func_draw_string_active(func_draw_string_active),
                                       .func_draw_string_finished(func_draw_string_finished),
                                       .func_active_n(function_active_n));

   assign read_next_inst = read_next && !reset_clear_pending;

   ////////////////////
   // DMA Data Buffer
   ////////////////////
   wire dma_fifo_full;
   `KEEP wire dma_fifo_empty;
   `KEEP wire dma_fifo_read;
   `KEEP wire [15:0] dma_fifo_data;
   gpu_dma_fifo dma_fifo(.aclr(reset),
                         .wrclk(clk_dma),
                         .wrreq(dma_data_valid),
                         .data(dma_data),
                         .wrfull(dma_fifo_full),
                         .rdclk(clk_gpu),
                         .rdempty(dma_fifo_empty),
                         .rdreq(dma_fifo_read),
                         .q(dma_fifo_data));
   assign dma_ready = ~dma_fifo_full || reset_clear_pending;

   wire func_draw_string_dma_ready;
   `KEEP wire bmp_dma_ready;
   assign dma_fifo_read = bmp_dma_ready ||
                          func_draw_string_dma_ready;

   ////////////////////
   // Image Decoders
   ////////////////////

   `KEEP wire bmp_pause;
   `KEEP wire bmp_start;
   `KEEP wire bmp_finished;
   `KEEP wire bmp_pixel_valid;
   `KEEP wire [`GPU_X_RANGE] bmp_pos_x;
   `KEEP wire [`GPU_Y_RANGE] bmp_pos_y;
   `KEEP wire [`INST_COLOR_R_RANGE] bmp_r;
   `KEEP wire [`INST_COLOR_G_RANGE] bmp_g;
   `KEEP wire [`INST_COLOR_B_RANGE] bmp_b;
   image_decode_bmp bmp_decode(.clk(clk_gpu),
                               .reset(reset),
                               .pause(bmp_pause),
                               .start(bmp_start),
                               .finished(bmp_finished),
                               .data_valid(~dma_fifo_empty),
                               .ready(bmp_dma_ready),
                               .data(dma_fifo_data),
                               .pixel_valid(bmp_pixel_valid),
                               .pos_x(bmp_pos_x),
                               .pos_y(bmp_pos_y),
                               .pixel_r(bmp_r),
                               .pixel_g(bmp_g),
                               .pixel_b(bmp_b));

   wire func_draw_image_bmp_start;
   wire func_draw_image_bmp_pause;
   wire func_load_font_bmp_start;
   wire func_load_font_bmp_pause;
   assign bmp_start = func_draw_image_bmp_start ||
                      func_load_font_bmp_start;
   assign bmp_pause = (func_draw_image_active && func_draw_image_bmp_pause) ||
                      (func_load_font_active && func_load_font_bmp_pause);

   ////////////////////
   // Drawing Functions
   ////////////////////

   //Draw rectangle function.
   wire func_draw_rect_pixel_valid;
   wire [`GPU_X_RANGE] func_draw_rect_pos_x;
   wire [`GPU_Y_RANGE] func_draw_rect_pos_y;
   wire [`INST_COLOR_R_RANGE] func_draw_rect_r;
   wire [`INST_COLOR_G_RANGE] func_draw_rect_g;
   wire [`INST_COLOR_B_RANGE] func_draw_rect_b;
   gpu_func_draw_rect func_draw_rect(.clk(clk_gpu),
                                     .reset(reset),
                                     .pause(gpu_pause),
                                     .start(reset_clear_start || func_draw_rect_start),
                                     .finished(func_draw_rect_finished),
                                     .x1(x1),
                                     .y1(y1),
                                     .x2(x2),
                                     .y2(y2),
                                     .r_in(color_r),
                                     .g_in(color_g),
                                     .b_in(color_b),
                                     .pixel_valid(func_draw_rect_pixel_valid),
                                     .pos_x(func_draw_rect_pos_x),
                                     .pos_y(func_draw_rect_pos_y),
                                     .pixel_r(func_draw_rect_r),
                                     .pixel_g(func_draw_rect_g),
                                     .pixel_b(func_draw_rect_b));
   assign reset_clear_start = func_draw_rect_start;
   assign reset_clear_finished = func_draw_rect_finished;

   //Draw line function.
   wire [`GPU_X_RANGE] func_draw_line_pos_x;
   wire [`GPU_Y_RANGE] func_draw_line_pos_y;
   wire [`INST_COLOR_R_RANGE] func_draw_line_r;
   wire [`INST_COLOR_G_RANGE] func_draw_line_g;
   wire [`INST_COLOR_B_RANGE] func_draw_line_b;
   gpu_func_draw_line func_draw_line(.clk(clk_gpu),
                                     .reset(reset),
                                     .pause(gpu_pause),
                                     .start(func_draw_line_start),
                                     .finished(func_draw_line_finished),
                                     .x1(x1),
                                     .y1(y1),
                                     .x2(x2),
                                     .y2(y2),
                                     .r_in(color_r),
                                     .g_in(color_g),
                                     .b_in(color_b),
                                     .pos_x(func_draw_line_pos_x),
                                     .pos_y(func_draw_line_pos_y),
                                     .pixel_r(func_draw_line_r),
                                     .pixel_g(func_draw_line_g),
                                     .pixel_b(func_draw_line_b));

   //Draw rectangle function.
   wire func_draw_image_pixel_valid;
   wire [`GPU_X_RANGE] func_draw_image_pos_x;
   wire [`GPU_Y_RANGE] func_draw_image_pos_y;
   wire [`INST_COLOR_R_RANGE] func_draw_image_r;
   wire [`INST_COLOR_G_RANGE] func_draw_image_g;
   wire [`INST_COLOR_B_RANGE] func_draw_image_b;
   gpu_func_draw_image func_draw_image(.clk(clk_gpu),
                                       .reset(reset),
                                       .pause(gpu_pause),
                                       .start(func_draw_image_start),
                                       .finished(func_draw_image_finished),
                                       .x1(x1),
                                       .y1(y1),
                                       .bmp_pause(func_draw_image_bmp_pause),
                                       .bmp_start(func_draw_image_bmp_start),
                                       .bmp_finished(bmp_finished),
                                       .bmp_pixel_valid(bmp_pixel_valid),
                                       .bmp_x(bmp_pos_x),
                                       .bmp_y(bmp_pos_y),
                                       .bmp_r(bmp_r),
                                       .bmp_g(bmp_g),
                                       .bmp_b(bmp_b),
                                       .pixel_valid(func_draw_image_pixel_valid),
                                       .pos_x(func_draw_image_pos_x),
                                       .pos_y(func_draw_image_pos_y),
                                       .pixel_r(func_draw_image_r),
                                       .pixel_g(func_draw_image_g),
                                       .pixel_b(func_draw_image_b));

   //Font load function.
   wire                draw_char_pause;
   wire                draw_char_start;
   wire                draw_char_finished;
   wire [7:0]          draw_char;
   wire [3:0]          draw_char_width;
   wire [3:0]          draw_char_height;
   wire                draw_char_pixel_valid;
   wire [`GPU_X_RANGE] draw_char_pos_x;
   wire [`GPU_Y_RANGE] draw_char_pos_y;
   wire                draw_char_en;
   gpu_func_load_font func_load_font(.clk(clk_gpu),
                                     .reset(reset),
                                     //Function control interface.
                                     .start(func_load_font_start),
                                     .finished(func_load_font_finished),
                                     //Function parameter interface.
                                     .x1(x1),
                                     .y1(y1),
                                     .r_in(color_r),
                                     .g_in(color_g),
                                     .b_in(color_b),
                                     //Image decoder interface.
                                     .img_pause(func_load_font_bmp_pause),
                                     .img_start(func_load_font_bmp_start),
                                     .img_finished(bmp_finished),
                                     .img_pixel_valid(bmp_pixel_valid),
                                     .img_x(bmp_pos_x),
                                     .img_y(bmp_pos_y),
                                     .img_r(bmp_r),
                                     .img_g(bmp_g),
                                     .img_b(bmp_b),
                                     //Font->display interface.
                                     .read_pause(draw_char_pause),
                                     .read_start(draw_char_start),
                                     .read_finished(draw_char_finished),
                                     .read_char(draw_char),
                                     .char_width(draw_char_width),
                                     .char_height(draw_char_height),
                                     .pixel_valid(draw_char_pixel_valid),
                                     .pos_x(draw_char_pos_x),
                                     .pos_y(draw_char_pos_y),
                                     .pixel_en(draw_char_en));

   //Draw string function.
   wire func_draw_string_pixel_valid;
   wire func_draw_string_pixel_en;
   wire [`GPU_X_RANGE] func_draw_string_pos_x;
   wire [`GPU_Y_RANGE] func_draw_string_pos_y;
   wire [`INST_COLOR_R_RANGE] func_draw_string_r;
   wire [`INST_COLOR_G_RANGE] func_draw_string_g;
   wire [`INST_COLOR_B_RANGE] func_draw_string_b;
   gpu_func_draw_string func_draw_string(.clk(clk_gpu),
                                         .reset(reset),
                                         //Function control interface.
                                         .pause(gpu_pause),
                                         .start(func_draw_string_start),
                                         .finished(func_draw_string_finished),
                                         //Function control interface.
                                         .x1(x1),
                                         .y1(y1),
                                         .r_in(color_r),
                                         .g_in(color_g),
                                         .b_in(color_b),
                                         //Memory interface.
                                         .data_valid(~dma_fifo_empty),
                                         .ready(func_draw_string_dma_ready),
                                         .data(dma_fifo_data),
                                         //Font memory interface.
                                         .char_pause(draw_char_pause),
                                         .char_start(draw_char_start),
                                         .char_finished(draw_char_finished),
                                         .char(draw_char),
                                         .char_width(draw_char_width),
                                         .char_height(draw_char_height),
                                         .char_pixel_valid(draw_char_pixel_valid),
                                         .char_pos_x(draw_char_pos_x),
                                         .char_pos_y(draw_char_pos_y),
                                         .char_pixel_en(draw_char_en),
                                         //Output interface.
                                         .pixel_valid(func_draw_string_pixel_valid),
                                         .pixel_en(func_draw_string_pixel_en),
                                         .pos_x(func_draw_string_pos_x),
                                         .pos_y(func_draw_string_pos_y),
                                         .pixel_r(func_draw_string_r),
                                         .pixel_g(func_draw_string_g),
                                         .pixel_b(func_draw_string_b));

   //Choose appropriate function's output. Pipe
   //function outputs one cycle for VGA timing.
   `PRESERVE reg func_pixel_valid;
   `PRESERVE reg [`GPU_X_RANGE] func_pos_x;
   `PRESERVE reg [`GPU_Y_RANGE] func_pos_y;
   always @(*) begin
      func_pixel_valid <= gpu_pause ? 1'b0 :
                          func_draw_rect_active ? func_draw_rect_pixel_valid :
                          func_draw_line_active ? ~function_active_n :
                          func_draw_image_active ? func_draw_image_pixel_valid :
                          func_draw_string_active ? func_draw_string_pixel_valid && func_draw_string_pixel_en:
                          1'b0;
      func_pos_x <= func_draw_rect_active ? func_draw_rect_pos_x :
                    func_draw_line_active ? func_draw_line_pos_x :
                    func_draw_image_active ? func_draw_image_pos_x :
                    func_draw_string_active ? func_draw_string_pos_x :
                    `GPU_X_WIDTH'h0;
      func_pos_y <= func_draw_rect_active ? func_draw_rect_pos_y :
                    func_draw_line_active ? func_draw_line_pos_y :
                    func_draw_image_active ? func_draw_image_pos_y :
                    func_draw_string_active ? func_draw_string_pos_y :
                    `GPU_Y_WIDTH'h0;
   end
   
   //Map function pixel positions to memory addresses.
   wire out_of_range;
   wire [17:0] pixel_addr;
   pixel_map pmap(.pos_x(func_pos_x),
                  .pos_y(func_pos_y),
                  .addr(pixel_addr),
                  .out_of_range(out_of_range));

   `PRESERVE reg [17:0] pixel_addr_km1;
   `PRESERVE reg [15:0] func_data;
   `PRESERVE reg        pixel_valid_n_km1;
   always @(posedge clk_gpu) begin
      if(reset) begin
         pixel_addr_km1 <= 18'd0;
         func_data <= 16'h0;
         pixel_valid_n_km1 <= 1'b1;
      end
      else if(!gpu_pause) begin
         pixel_addr_km1 <= layer==`GPU_LAYER_BG ?
                           pixel_addr :
                           pixel_addr+`GPU_FG_ADDR_OFFSET;

         func_data[`INST_COLOR_R_POS] <= func_draw_rect_active ? func_draw_rect_r :
                                        func_draw_line_active ? func_draw_line_r :
                                        func_draw_image_active ? func_draw_image_r :
                                        func_draw_string_active ? func_draw_string_r :
                                        `INST_COLOR_R_WIDTH'h0;
         func_data[`INST_COLOR_G_POS] <= func_draw_rect_active ? func_draw_rect_g :
                                        func_draw_line_active ? func_draw_line_g :
                                        func_draw_image_active ? func_draw_image_g :
                                        func_draw_string_active ? func_draw_string_g :
                                        `INST_COLOR_G_WIDTH'h0;
         func_data[`INST_COLOR_B_POS] <= func_draw_rect_active ? func_draw_rect_b :
                                        func_draw_line_active ? func_draw_line_b :
                                        func_draw_image_active ? func_draw_image_b :
                                        func_draw_string_active ? func_draw_string_b :
                                        `INST_COLOR_B_WIDTH'h0;

         pixel_valid_n_km1 <= ~(func_pixel_valid && !out_of_range);
      end
   end

   //Fetch/write foreground pixel enables from/to memory.
   //Note: The read address (display controllerpixel address)
   //      is incremented to pre-fetch the desired bit such
   //      that the display never waits.
   `KEEP wire       fg_pixel_en;
   gpu_fg_controller fg_control(.clk(clk_gpu),
                                .reset(reset),
                                //Pixel write interface.
                                .write(layer==`GPU_LAYER_FG && func_pixel_valid),
                                .wr_x(func_pos_x),
                                .wr_y(func_pos_y),
                                .enable(!pixel_clear),
                                //Pixel read interface.
                                .display_drawing(disp_drawing),
                                .rd_x(disp_pos_x-`DISP_X_LIMIT_LOW),
                                .rd_y(disp_pos_y-`DISP_Y_LIMIT_LOW),
                                .value(fg_pixel_en),
                                .mismatch_pause(fg_en_mismatch_pause));
   
   //Connect display controller.
   `KEEP wire disp_drawing_screen;
   `KEEP wire [`DISP_X_RANGE] disp_pos_x;
   `KEEP wire [`DISP_Y_RANGE] disp_pos_y;
   `KEEP wire [`DISP_COLOR_R_RANGE] r_in;
   `KEEP wire [`DISP_COLOR_G_RANGE] g_in;
   `KEEP wire [`DISP_COLOR_B_RANGE] b_in;
   disp_controller disp(.clk(clk_disp),
                        .reset(reset),
                        .disp_drawing(disp_drawing_screen),
                        .pos_x(disp_pos_x),
                        .pos_y(disp_pos_y),
                        .r_in(r_in),
                        .g_in(g_in),
                        .b_in(b_in),
                        .disp_hs_n(disp_hs_n),
                        .disp_vs_n(disp_vs_n),
                        .disp_blank_n(disp_blank_n),
                        .disp_sync(disp_sync),
                        .disp_r(disp_r),
                        .disp_g(disp_g),
                        .disp_b(disp_b));

   //Display position within displayable address update range.
   wire disp_out_of_range;
   assign disp_out_of_range = (disp_pos_x<`DISP_X_LIMIT_LOW || disp_pos_x>`DISP_X_LIMIT_HIGH) ||
                              (disp_pos_y<`DISP_Y_LIMIT_LOW || disp_pos_y>`DISP_Y_LIMIT_HIGH);

   //Generate memory address from display position.
   reg [17:0] disp_addr;
   reg [17:0] disp_fg_addr;
   always @(posedge clk_disp) begin
      disp_addr <= reset || ~disp_vs_n ? 18'd0 :
                   !disp_out_of_range && disp_drawing_screen ? disp_addr+18'd1 :
                   disp_addr;
      disp_fg_addr <= reset || ~disp_vs_n ? `GPU_FG_ADDR_OFFSET :
                      !disp_out_of_range && disp_drawing_screen ? disp_fg_addr+18'd1 :
                      disp_fg_addr;
   end
   
   assign ram_addr = disp_drawing && fg_pixel_en && fg_en && layer_en ? disp_fg_addr :
                     disp_drawing ? disp_addr :
                     pixel_addr_km1;

   //Read pixel values from RAM. Pad instruction color
   //values as necessary for display interface.
   assign r_in = func_draw_priority || disp_out_of_range ?
                 `DISP_COLOR_R_WIDTH'd0 :
                 {ram_dq[`INST_COLOR_R_POS],{(`DISP_COLOR_R_WIDTH-`INST_COLOR_R_WIDTH){1'b0}}};
   assign g_in = func_draw_priority || disp_out_of_range ?
                 `DISP_COLOR_G_WIDTH'd0 :
                 {ram_dq[`INST_COLOR_G_POS],{(`DISP_COLOR_G_WIDTH-`INST_COLOR_G_WIDTH){1'b0}}};
   assign b_in = func_draw_priority || disp_out_of_range ?
                 `DISP_COLOR_B_WIDTH'd0 :
                 {ram_dq[`INST_COLOR_B_POS],{(`DISP_COLOR_B_WIDTH-`INST_COLOR_B_WIDTH){1'b0}}};
   
   assign ram_dq = disp_drawing ? 16'hzzzz : func_data;
   assign ram_ub_n = 1'b0;
   assign ram_lb_n = 1'b0;
   assign ram_we_n = disp_drawing | pixel_valid_n_km1;

endmodule
