`include "gpu_inst_controller.vh"

//`define DEBUG
`undef DEBUG
`include "debug.vh"

module gpu_inst_controller(
    input                             clk,
    input                             reset,
    //Instruction interface.
    input                             inst_fifo_empty,
    input [29:0]                      inst_data,
    output wire                       read_inst,
    //Parameter output interface.
    output reg                        layer,
    output reg                        fg_en,
    output reg [`GPU_X_RANGE]         x1,
    output reg [`GPU_Y_RANGE]         y1,
    output reg [`GPU_X_RANGE]         x2,
    output reg [`GPU_Y_RANGE]         y2,
    output wire [`INST_COLOR_R_RANGE] r,
    output wire [`INST_COLOR_G_RANGE] g,
    output wire [`INST_COLOR_B_RANGE] b,
    //Display control interface.
    output reg                        func_active_n,
    output reg                        func_draw_priority,
    output reg                        pixel_clear,
    //Draw rectangle function.
    output reg                        func_draw_rect_start,
    output reg                        func_draw_rect_active,
    input                             func_draw_rect_finished,
    //Draw line function.
    output reg                        func_draw_line_start,
    output reg                        func_draw_line_active,
    input                             func_draw_line_finished,
    //Draw image function.
    output reg                        func_draw_image_start,
    output reg                        func_draw_image_active,
    input                             func_draw_image_finished,
    //Load font function.
    output reg                        func_load_font_start,
    output reg                        func_load_font_active,
    input                             func_load_font_finished,
    //Draw string function.
    output reg                        func_draw_string_start,
    output reg                        func_draw_string_active,
    input                             func_draw_string_finished);

   //Instruction fields.
   `KEEP wire [`INST_CMD_WIDTH-1:0] command;
   `KEEP wire [`INST_PARAM_WIDTH-1:0] param;
   assign command = inst_data[`INST_CMD_RANGE];
   assign param = inst_data[`INST_PARAM_RANGE];

   assign r = (command==`CMD_CLEAR || command==`CMD_CLEAR_RECT) ?
              `INST_COLOR_R_WIDTH'd0 :
              param[`INST_PARAM_COLOR_R_RANGE];
   assign g = (command==`CMD_CLEAR || command==`CMD_CLEAR_RECT) ?
              `INST_COLOR_G_WIDTH'd0 :
              param[`INST_PARAM_COLOR_G_RANGE];
   assign b = (command==`CMD_CLEAR || command==`CMD_CLEAR_RECT) ?
              `INST_COLOR_B_WIDTH'd0 :
              param[`INST_PARAM_COLOR_B_RANGE];
   
   //Flag active until selected function completes.
   wire func_start;
   reg func_finished;
   always @(posedge clk) begin
      func_active_n <= reset ? 1'b1 :
                       func_start ? 1'b0 :
                       func_finished ? 1'b1 :
                       func_active_n;
   end

   //Issue instruction start when there is
   //an instruction available and no instruction
   //is currently active.
   assign func_start = !reset && func_active_n && !inst_fifo_empty;

   //Delay function start signal to allow
   //registers to update before starting
   //function operations if necessary.
   wire func_start_km1;
   delay func_start_delay(.clk(clk),
                          .reset(reset),
                          .in(func_start),
                          .out(func_start_km1));

   //Assert appropriate function start signal.
   always @(*) begin
      func_draw_rect_start <= func_start_km1 &&
                              (command==`CMD_DRAW_RECT || command==`CMD_CLEAR || command==`CMD_CLEAR_RECT);
      func_draw_line_start <= func_start_km1 && command==`CMD_DRAW_LINE;
      func_draw_image_start <= func_start_km1 && command==`CMD_DRAW_IMAGE;
      func_load_font_start <= func_start_km1 && command==`CMD_LOAD_FONT;
      func_draw_string_start <= func_start_km1 && command==`CMD_DRAW_STRING;
   end

   //Assert appropriate function active signal.
   always @(*) begin
      func_draw_rect_active <= ~func_active_n && !func_start_km1 &&
                               (command==`CMD_DRAW_RECT || command==`CMD_CLEAR || command==`CMD_CLEAR_RECT);
      func_draw_line_active <= ~func_active_n && !func_start_km1 &&
                               command==`CMD_DRAW_LINE;
      func_draw_image_active <= ~func_active_n && !func_start_km1 &&
                                command==`CMD_DRAW_IMAGE;
      func_load_font_active <= ~func_active_n && !func_start_km1 &&
                               command==`CMD_LOAD_FONT;
      func_draw_string_active <= ~func_active_n && !func_start_km1 &&
                                 command==`CMD_DRAW_STRING;
   end

   //Decode function finished flags.
   always @(*) begin
      if(reset) begin
         func_finished <= 1'b0;
      end
      else if(func_active_n || func_start_km1) begin
         func_finished <= 1'b0;
      end
      else begin
         case(command)
           `CMD_NONE: func_finished <= 1'b1;
           `CMD_SET_XY1: func_finished <= 1'b1;
           `CMD_SET_XY2: func_finished <= 1'b1;
           `CMD_DRAW_RECT: func_finished <= func_draw_rect_finished;
           `CMD_DRAW_LINE: func_finished <= func_draw_line_finished;
           `CMD_DRAW_IMAGE: func_finished <= func_draw_image_finished;
           `CMD_CLEAR: func_finished <= func_draw_rect_finished;
           `CMD_CLEAR_RECT: func_finished <= func_draw_rect_finished;
           `CMD_SET_LAYER: func_finished <= 1'b1;
           `CMD_SHOW_FG: func_finished <= 1'b1;
           `CMD_LOAD_FONT: func_finished <= func_load_font_finished;
           `CMD_DRAW_STRING: func_finished <= func_draw_string_finished;
           default: func_finished <= 1'b1;
         endcase // case (command)
      end
   end // always @ (*)

   //Discard instruction from FIFO when completed.
   assign read_inst = func_finished;

   //Decode instruction.
   always @(posedge clk) begin
      if(reset) begin
         layer <= `GPU_LAYER_BG;
         fg_en <= 1'b1;
         pixel_clear <= 1'b0;
         
         x1 <= `GPU_X_WIDTH'h0;
         y1 <= `GPU_Y_WIDTH'h0;
         
         x2 <= `GPU_X_WIDTH'h0;
         y2 <= `GPU_Y_WIDTH'h0;
         
         func_draw_priority <= 1'b0;
      end
      else if(inst_fifo_empty) begin
         func_draw_priority <= 1'b0;
      end
      else begin
        case(command)
          `CMD_NONE: begin
             func_draw_priority <= 1'b0;
          end
          `CMD_SET_XY1: begin
             x1 <= inst_data[`INST_PARAM_X_RANGE];
             y1 <= inst_data[`INST_PARAM_Y_RANGE];
             func_draw_priority <= 1'b0;
          end
          `CMD_SET_XY2: begin
             x2 <= inst_data[`INST_PARAM_X_RANGE];
             y2 <= inst_data[`INST_PARAM_Y_RANGE];
             func_draw_priority <= 1'b0;
          end
          `CMD_DRAW_RECT: begin
             func_draw_priority <= 1'b0;
             pixel_clear <= 1'b0;
          end
          `CMD_DRAW_LINE: begin
             func_draw_priority <= 1'b0;
             pixel_clear <= 1'b0;
          end
          `CMD_DRAW_IMAGE: begin
             func_draw_priority <= inst_data[`INST_PARAM_PRIORITY];
             pixel_clear <= 1'b0;
          end
          `CMD_CLEAR: begin
             func_draw_priority <= inst_data[`INST_PARAM_PRIORITY];

             //Clear screen is issued by drawing an empty
             //rectangle to the whole screen.
             x1 <= `GPU_X_WIDTH'h0;
             y1 <= `GPU_Y_WIDTH'h0;
             x2 <= `GPU_X_MAX;
             y2 <= `GPU_Y_MAX;
             
             layer <= inst_data[`INST_PARAM_LAYER];
             pixel_clear <= 1'b1;
          end
          `CMD_CLEAR_RECT: begin
             func_draw_priority <= inst_data[`INST_PARAM_PRIORITY];
             
             layer <= inst_data[`INST_PARAM_LAYER];
             pixel_clear <= 1'b1;
          end
          `CMD_SET_LAYER: begin
             layer <= inst_data[`INST_PARAM_LAYER];
             func_draw_priority <= 1'b0;
          end
          `CMD_SHOW_FG: begin
             fg_en <= inst_data[`INST_PARAM_FG_EN];
             func_draw_priority <= 1'b0;
          end
          `CMD_LOAD_FONT: begin
             func_draw_priority <= 1'b0;
             pixel_clear <= 1'b0;
          end
          `CMD_DRAW_STRING: begin
             func_draw_priority <= 1'b0;
             pixel_clear <= 1'b0;
          end
          default: begin
             func_draw_priority <= 1'b0;
          end
        endcase // case (inst_data[`INST_CMD_RANGE])
      end
   end // always @ (posedge clk)
   
endmodule
