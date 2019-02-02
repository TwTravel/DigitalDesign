`include "gpu_inst_controller.vh"
`include "gpu_func_draw_string.vh"

module gpu_func_draw_string(
    input                             clk,
    input                             reset,
    //Function control interface.
    input                             pause,
    input                             start,
    output wire                       finished,
    //Function parameter interface.
    input [`GPU_X_RANGE]              x1,
    input [`GPU_Y_RANGE]              y1,
    input [`INST_COLOR_R_RANGE]       r_in,
    input [`INST_COLOR_G_RANGE]       g_in,
    input [`INST_COLOR_B_RANGE]       b_in,
    //Memory interface.
    input                             data_valid,
    output wire                       ready,
    input [15:0]                      data,
    //Font memory interface.
    output wire                       char_pause,
    output wire                       char_start,
    input                             char_finished,
    output wire [7:0]                 char,
    input [3:0]                       char_width,
    input [3:0]                       char_height,
    input                             char_pixel_valid,
    input [`GPU_X_RANGE]              char_pos_x,
    input [`GPU_Y_RANGE]              char_pos_y,
    input                             char_pixel_en,
    //Output interface.
    output wire                       pixel_valid,
    output wire                       pixel_en,
    output wire [`GPU_X_RANGE]        pos_x,
    output wire [`GPU_Y_RANGE]        pos_y,
    output wire [`INST_COLOR_R_RANGE] pixel_r,
    output wire [`INST_COLOR_G_RANGE] pixel_g,
    output wire [`INST_COLOR_B_RANGE] pixel_b);

   //Decode the 16b memory interface into 8b characters.
   reg [15:0] char_data;
   reg        char_select;
   assign char = char_select==1'b1 ? char_data[15:8] : char_data[7:0];

   //If the next character is NULL (0x00), the
   //string has finished.
   //Note: char_select denotes the CURRENT character, and so
   //      the next character is the OTHER position.
   wire string_complete;
   assign string_complete = (char_select==1'b0 && char_data[15:8]==8'h0) ||
                            (char_select==1'b1 && data_valid && data[7:0]==8'h0);

   //Start processing the next character when the
   //character is already in the buffer, or when
   //it becomes available from memory.
   wire start_next_char;
   assign start_next_char = char_select==1'b0 || data_valid;
   
   reg [`GPU_X_RANGE] x;
   reg [`GPU_Y_RANGE] y;
   reg [`STRING_STATE_RANGE] state;
   always @(posedge clk) begin
      if(reset) begin
         state <= `STRING_STATE_IDLE;
         char_select <= 1'b1;
         x <= `GPU_X_WIDTH'd0;
         y <= `GPU_Y_WIDTH'd0;
      end
      else begin
         case(state)
           `STRING_STATE_READ_NEXT: begin
              //Note: In this state, char_select represents the
              //      character that has just finished processing.
              
              //If the next character is NULL (0x00), the
              //string has finished. Otherwise, display the
              //next character.
              state <= string_complete ? `STRING_STATE_IDLE :
                       start_next_char ? `STRING_STATE_PROCESS_CHAR :
                       `STRING_STATE_READ_NEXT;

              //Switch to the next character in the buffer
              //as soon as possible.
              char_select <= start_next_char ?
                             ~char_select :
                             char_select;

              //Update character buffer when the second character
              //has been processed and memory data is available.
              char_data <= char_select==1'b1 && data_valid ? data : char_data;
           end
           `STRING_STATE_PROCESS_CHAR: begin
              //Only draw displayable characters (>=0x21='!' && <0x7F=DEL).
              state <= char>8'h20 && char<8'h7F ?
                       `STRING_STATE_DISP_CHAR :
                       `STRING_STATE_READ_NEXT;

              //Increment x position by one character for
              //displayable characters, including space.
              //Reset to X1 position on a carriage return.
              x <= char>=8'h20 ? x+(char_width+`GPU_X_WIDTH'd1) :
                   char==8'hA || char==8'hD ? x1-(char_width+`GPU_X_WIDTH'd1) :
                   x;

              //Go to next line on a carriage return.
              y <= char==8'hA ?
                   y+(char_height+`GPU_Y_WIDTH'd1) :
                   y;
           end // case: `STRING_STATE_PROCESS_CHAR
           `STRING_STATE_DISP_CHAR: begin
              state <= char_finished ?
                       `STRING_STATE_READ_NEXT :
                       `STRING_STATE_DISP_CHAR;
           end
           default: begin
              state <= start ?
                       `STRING_STATE_READ_NEXT :
                       `STRING_STATE_IDLE;
              char_select <= 1'b1;
              
              x <= x1-(char_width+`GPU_X_WIDTH'd1);
              y <= y1;
           end
         endcase
      end
   end // always @ (posedge clk)

   //Drive character read interface.
   assign char_pause = pause;
   assign char_start = state==`STRING_STATE_PROCESS_CHAR &&
                       char>8'h20;
   
   //Drive output interface.
   assign pixel_valid = state==`STRING_STATE_DISP_CHAR && char_pixel_valid;
   assign pixel_en = char_pixel_en;
   assign pos_x = x + char_pos_x;
   assign pos_y = y + char_pos_y;
   assign pixel_r = r_in;
   assign pixel_g = g_in;
   assign pixel_b = b_in;

   assign ready = state==`STRING_STATE_READ_NEXT && char_select==1'b1;
   assign finished = state==`STRING_STATE_IDLE;
   
endmodule