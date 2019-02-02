`include "gpu_inst_controller.vh"
`include "image_decode_bmp.vh"

//`define DEBUG
`undef DEBUG
`include "debug.vh"

//FIXME I/O bit ranges.
module image_decode_bmp(
    input                            clk,
    input                            reset,
    //Function control interface.
    input                            pause,
    input                            start,
    output wire                      finished,
    //Memory interface.
    input                            data_valid,
    output wire                      ready,
    input [15:0]                     data,
    //Image output interface.
    output reg                       pixel_valid,
    output reg [`GPU_X_RANGE]        pos_x,
    output wire [`GPU_Y_RANGE]       pos_y,
    output reg [`INST_COLOR_R_RANGE] pixel_r,
    output reg [`INST_COLOR_G_RANGE] pixel_g,
    output reg [`INST_COLOR_B_RANGE] pixel_b);
   
   //Image information.
   //Note: The maximum image width is 2^11-1, whereas
   //      the display range may be smaller. This is
   //      to allow font loading support.
   `PRESERVE reg [10:0] width;
   `PRESERVE reg [`GPU_Y_RANGE] height;
   `PRESERVE reg [`BMP_DEPTH_RANGE] color_depth;
   `PRESERVE reg [15:0] palette_size;
   `PRESERVE reg [31:0] image_size;

   //Image y coordinate.
   wire [`GPU_Y_RANGE] y;
   assign y = height;
   assign pos_y = y;
   
   ////////////////////
   // Color Break-Outs
   ////////////////////

   //24-bit mode.
   `KEEP wire [7:0] color_0;
   `KEEP wire [7:0] color_1;
   assign color_0 = data[7:0];
   assign color_1 = data[15:8];

   /////////////////////////
   // Decode State Machine
   /////////////////////////

   //Line data must be 32-bit aligned. This is
   //the amount of padding required at the end
   //of each line, in bytes.
   //Note: This is currently for 24-bit depth only.
   `KEEP wire [1:0] padding;
   assign padding = width[1:0];

   //Decode state machine.
   `PRESERVE reg [`BMP_READ_TYPE_RANGE] read_type;
   `PRESERVE reg [`INST_COLOR_B_RANGE]  next_b;
   `PRESERVE reg [10:0]                 x;
   `PRESERVE reg [`BMP_STATE_RANGE]     state;
   always @(posedge clk) begin
      if(reset) begin
         state <= `BMP_STATE_IDLE;
         pixel_valid <= 1'b0;
      end
      else if(start) begin
         state <= `BMP_STATE_MAGIC_NUMBER;
         pixel_valid <= 1'b0;
      end
      else if(!ready) begin
         state <= state;
         pixel_valid <= pixel_valid;
      end
      else if(!data_valid) begin
         state <= state;
         pixel_valid <= 1'b0;
      end
      else begin
         case(state)
           `BMP_STATE_MAGIC_NUMBER: begin
              state <= data==`BMP_MAGIC_BM ?
                       `BMP_STATE_FILE_SIZE_0 :
                       `BMP_STATE_IDLE;
           end
           `BMP_STATE_FILE_SIZE_0: begin
              state <= `BMP_STATE_FILE_SIZE_1;
           end
           `BMP_STATE_FILE_SIZE_1: begin
              state <= `BMP_STATE_RES_0;
           end
           `BMP_STATE_RES_0: begin
              state <= `BMP_STATE_RES_1;
           end
           `BMP_STATE_RES_1: begin
              state <= `BMP_STATE_DATA_OFFSET_0;
           end
           `BMP_STATE_DATA_OFFSET_0: begin
              state <= `BMP_STATE_DATA_OFFSET_1;
           end
           `BMP_STATE_DATA_OFFSET_1: begin
              state <= `BMP_STATE_HEADER_SIZE_0;
           end
           `BMP_STATE_HEADER_SIZE_0: begin
              state <= data==`BMP_IH_SIZE_V3 ?
                       `BMP_STATE_HEADER_SIZE_1 :
                       `BMP_STATE_IDLE;
           end
           `BMP_STATE_HEADER_SIZE_1: begin
              state <= `BMP_STATE_PIXEL_WIDTH_0;
           end
           `BMP_STATE_PIXEL_WIDTH_0: begin
              state <= `BMP_STATE_PIXEL_WIDTH_1;

              //Note: Maximum image size may be larger than
              //      the screen dimensions.
              width <= data[10:0];
           end
           `BMP_STATE_PIXEL_WIDTH_1: begin
              state <= `BMP_STATE_PIXEL_HEIGHT_0;
           end
           `BMP_STATE_PIXEL_HEIGHT_0: begin
              state <= `BMP_STATE_PIXEL_HEIGHT_1;

              //Note: Maximum image size is restricted
              //      to screen dimensions.
              height <= data[`GPU_Y_RANGE];
           end
           `BMP_STATE_PIXEL_HEIGHT_1: begin
              state <= `BMP_STATE_COLOR_PLANES;
           end
           `BMP_STATE_COLOR_PLANES: begin
              state <= `BMP_STATE_COLOR_DEPTH;
           end
           `BMP_STATE_COLOR_DEPTH: begin
              state <= `BMP_STATE_COMPRESSION_0;

              case(data[6:0])
                7'd1: color_depth <= `BMP_DEPTH_1;
                7'd4: color_depth <= `BMP_DEPTH_4;
                7'd8: color_depth <= `BMP_DEPTH_8;
                7'd24: color_depth <= `BMP_DEPTH_24;
                7'd32: color_depth <= `BMP_DEPTH_32;
              endcase
           end
           `BMP_STATE_COMPRESSION_0: begin
              state <= `BMP_STATE_COMPRESSION_1;
           end
           `BMP_STATE_COMPRESSION_1: begin
              state <= `BMP_STATE_IMAGE_SIZE_0;
           end
           `BMP_STATE_IMAGE_SIZE_0: begin
              state <= `BMP_STATE_IMAGE_SIZE_1;

              image_size[15:0] <= data;
           end
           `BMP_STATE_IMAGE_SIZE_1: begin
              state <= `BMP_STATE_HRES_0;

              image_size[31:16] <= data;
           end
           `BMP_STATE_HRES_0: begin
              state <= `BMP_STATE_HRES_1;
           end
           `BMP_STATE_HRES_1: begin
              state <= `BMP_STATE_VRES_0;
           end
           `BMP_STATE_VRES_0: begin
              state <= `BMP_STATE_VRES_1;
           end
           `BMP_STATE_VRES_1: begin
              state <= `BMP_STATE_PALETTE_SIZE_0;
           end
           `BMP_STATE_PALETTE_SIZE_0: begin
              state <= `BMP_STATE_PALETTE_SIZE_1;
              
              palette_size <= data;
           end
           `BMP_STATE_PALETTE_SIZE_1: begin
              state <= `BMP_STATE_IMPORTANT_COLORS_0;
           end
           `BMP_STATE_IMPORTANT_COLORS_0: begin
              state <= `BMP_STATE_IMPORTANT_COLORS_1;
           end
           `BMP_STATE_IMPORTANT_COLORS_1: begin
              state <= palette_size==16'd0 ?
                       `BMP_STATE_IMAGE :
                       `BMP_STATE_PALETTE;

              x <= 11'd0;
              read_type <= `BMP_READ_TYPE_BG;
              pixel_valid <= 1'b0;
           end
           `BMP_STATE_PALETTE: begin
              state <= `BMP_STATE_IMAGE;

              //FIXME Decode color palette.
           end
           //Decode image data, based on color depth.
           //Note: Colors are stored in BGR format.
           `BMP_STATE_IMAGE: begin
              state <= image_size<=32'd2 ? `BMP_STATE_IDLE :
                       x==(width-11'd1) && y==`GPU_Y_WIDTH'd0 ? `BMP_STATE_DISCARD_END :
                       `BMP_STATE_IMAGE;

              image_size <= image_size-32'd2;

              if(color_depth==`BMP_DEPTH_24) begin
                 if(read_type==`BMP_READ_TYPE_BG) begin
                    pixel_b <= color_0[`BMP_24_B_RANGE];
                    pixel_g <= color_1[`BMP_24_G_RANGE];
                    
                    pixel_valid <= 1'b0;

                    height <= x==11'd0 ? height-`GPU_Y_WIDTH'd1 : height;
                    
                    read_type <= `BMP_READ_TYPE_RB;
                 end
                 else if(read_type==`BMP_READ_TYPE_RB) begin
                    pixel_r <= color_0[`BMP_24_R_RANGE];
                    next_b <= color_1[`BMP_24_B_RANGE];
                    
                    pixel_valid <= 1'b1;

                    x <= x==(width-11'd1) ?
                         11'd0 :
                         x+11'd1;

                    pos_x <= x[`GPU_X_RANGE];
                    
                    read_type <= x!=(width-11'd1) ? `BMP_READ_TYPE_GR :
                                 padding>2'd1 ? `BMP_READ_TYPE_DISCARD :
                                 `BMP_READ_TYPE_BG;
                 end
                 else if(read_type==`BMP_READ_TYPE_GR) begin
                    pixel_b <= next_b;
                    pixel_g <= color_0[`BMP_24_G_RANGE];
                    pixel_r <= color_1[`BMP_24_R_RANGE];
                    
                    pixel_valid <= 1'b1;

                    x <= x==(width-11'd1) ?
                         11'd0 :
                         x+11'd1;

                    pos_x <= x[`GPU_X_RANGE];
                    
                    read_type <= x==(width-11'd1) && padding>2'd1 ?
                                 `BMP_READ_TYPE_DISCARD :
                                 `BMP_READ_TYPE_BG;
                 end
                 else if(read_type==`BMP_READ_TYPE_DISCARD) begin
                    pixel_valid <= 1'b0;
                    read_type <= `BMP_READ_TYPE_BG;
                 end
              end // if (color_depth==`BMP_DEPTH_24)
           end
           `BMP_STATE_DISCARD_END: begin
              state <= image_size<=32'd2 ?
                       `BMP_STATE_IDLE :
                       `BMP_STATE_DISCARD_END;

              pixel_valid <= 1'b0;
              
              image_size <= image_size-32'd2;
           end
           default: begin
              state <= `BMP_STATE_IDLE;
              pixel_valid <= 1'b0;
           end
         endcase
      end
   end // always @ (posedge clk)

   //Assert ready signal to DMA whenever decoding an
   //image and not paused by memory access.
   assign ready = state!=`BMP_STATE_IDLE &&
                  (!pause || state==`BMP_STATE_DISCARD_END);

   //Assert finished when state machine returns to idle.
   assign finished = state==`BMP_STATE_IDLE;
   
endmodule