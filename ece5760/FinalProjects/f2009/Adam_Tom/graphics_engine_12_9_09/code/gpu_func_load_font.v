`include "gpu_inst_controller.vh"
`include "gpu_func_load_font.vh"

module gpu_func_load_font(
    input                       clk,
    input                       reset,
    //Function control interface.
    input                       start,
    output wire                 finished,
    //Function parameter interface.
    input [`GPU_X_RANGE]        x1,
    input [`GPU_Y_RANGE]        y1,
    input [`INST_COLOR_R_RANGE] r_in,
    input [`INST_COLOR_G_RANGE] g_in,
    input [`INST_COLOR_B_RANGE] b_in,
    //Image decoder interface.
    output wire                 img_pause,
    output wire                 img_start,
    input                       img_finished,
    input                       img_pixel_valid,
    input [`GPU_X_RANGE]        img_x,
    input [`GPU_Y_RANGE]        img_y,
    input [`INST_COLOR_R_RANGE] img_r,
    input [`INST_COLOR_G_RANGE] img_g,
    input [`INST_COLOR_B_RANGE] img_b,
    //Font->display interface.
    input                       read_pause,
    input                       read_start,
    output wire                 read_finished,
    input [7:0]                 read_char,
    output reg [3:0]            char_width,
    output reg [3:0]            char_height,
    output wire                 pixel_valid,
    output wire [`GPU_X_RANGE]  pos_x,
    output wire [`GPU_Y_RANGE]  pos_y,
    output wire                 pixel_en);

   localparam NUM_CHARS = 94;
   localparam [7:0] MAX_CHAR = (NUM_CHARS-1);

   reg [11:0]  font_addr;
   reg         font_write;
   wire [7:0]  font_data_in;
   wire [7:0]  font_data_out;
   gpu_font_ram font_ram(.clock(clk),
	                 .address(font_addr),
	                 .wren(font_write),
	                 .data(font_data_in),
	                 .q(font_data_out));

   //Connect image decoder interface to
   //instruction controller.
   assign img_pause = 1'b0;
   assign img_start = start;

   //Offset character to be read, starting at
   //first displayable character (!=0x21).
   `KEEP wire [7:0] read_char_offset;
   assign read_char_offset = read_char-8'h21;

   //The last pixel value has been reached in
   //the current word if either position 7 has been
   //reached in the first word for >8 pixel fonts, or
   //the character width has been reached.
   reg [2:0] row_pos;
   reg       second_word_pending;
   wire      last_pos_reached;
   assign last_pos_reached = char_width[3] ? (second_word_pending ?
                                              row_pos==3'd7 :
                                              row_pos==(char_width-4'd8)) :
                             row_pos==char_width[2:0];

   //Prefetch the next word value from memory when
   //two pixels remain in the current word.
   wire prefetch_word;
   reg  second_prefetch_pending;
   assign prefetch_word = char_width[3] ? (second_prefetch_pending ?
                                           pos_x==4'd5 :
                                           pos_x==(char_width-4'd2)) :
                          pos_x==(char_width-4'd2);

   //Font loading has finished when the last pixel of the last
   //character has been loaded and written. Fonts are expected
   //to have 94 displayable ASCII characters.
   //Note: If the image has leftover pixels, they will not be
   //      read and might cause unforseen problems later.
   reg [6:0] char;
   reg [3:0] char_y;
   assign finished = last_pos_reached && !second_word_pending &&
                     char==MAX_CHAR && char_y==4'd0;

   reg [11:0] addr;
   reg [7:0] row_data;
   `PRESERVE reg [`FONT_STATE_RANGE] state;
   always @(posedge clk) begin
      if(reset) begin
         char_width <= 4'd0;
         char_height <= 4'd0;
         font_write <= 1'b0;
      end
      //Start character read/display.
      else if(read_start) begin
         //Issue read for first word for specified character.
         //FIXME The +4'd1 might fail for 16b fonts. Might need to
         //FIXME pad to 5 bits.
         font_addr <= read_char_offset[6:0]*(char_width[3] ? ({1'b0,char_height}+5'd1)<<1 : ({1'b0,char_height}+5'd1));
         font_write <= 1'b0;
         
         state <= `FONT_STATE_WAIT_FOR_FIRST_WORD;
      end // if (start)
      //Start font load.
      else if(start) begin
         char_width <= x1[3:0];
         char_height <= y1[3:0];
         
         addr <= {8'd0,y1[3:0]};
         font_write <= 1'b0;
         
         row_pos <= 3'd0;
         row_data <= 8'b0;
         char_y <= y1[3:0];
         char <= 7'd0;
         second_word_pending <= x1[3];
         
         state <= `FONT_STATE_WRITE;
      end // if (start)
      //Read/write character pixel values.
      else if(state!=`FONT_STATE_IDLE) begin
         case(state)
           //Wait for M4K address register load.
           `FONT_STATE_WAIT_FOR_FIRST_WORD: begin
              state <= `FONT_STATE_READ_FIRST_WORD;
           end
           //Read first prefetched word.
           `FONT_STATE_READ_FIRST_WORD: begin
              state <= `FONT_STATE_READ_WORD;

              row_data <= font_data_out;
              row_pos <= 3'd0;
              char_y <= 4'd0;
              second_word_pending <= char_width[3];
              second_prefetch_pending <= char_width[3];
           end
           `FONT_STATE_READ_WORD: begin
              if(!read_pause) begin
                 //Switch to idle state when the last pixel
                 //of the last word has been read.
                 state <= last_pos_reached && char_y==char_height ?
                          `FONT_STATE_IDLE :
                          `FONT_STATE_READ_WORD;
                 
                 //Prefetch the next word as necessary.
                 font_addr <= prefetch_word ? font_addr+12'd1 : font_addr;

                 //When the last position in the word has been
                 //reached, read the next (prefetched) word.
                 row_data <= last_pos_reached ? font_data_out : row_data;
                 
                 //Increment row position.
                 row_pos <= last_pos_reached ?
                            3'd0 :
                            row_pos+3'd1;

                 //Increment y position at the end of each row.
                 char_y <= last_pos_reached && (!char_width[3] || !second_word_pending) ?
                           char_y+4'd1 :
                           char_y;

                 second_prefetch_pending <= prefetch_word ?
                                            ~second_prefetch_pending & char_width[3] :
                                            second_prefetch_pending;

                 second_word_pending <= last_pos_reached ?
                                        ~second_word_pending & char_width[3] :
                                        second_word_pending;
              end
           end
           `FONT_STATE_WRITE: begin
              if(img_pixel_valid) begin
                 //Set pixel enable as long as color is not
                 //user-specified transparency color.
                 row_data[row_pos] <= img_r==r_in && img_g==g_in && img_b==b_in ? 1'b0 : 1'b1;
                 
                 //Increment row position.
                 row_pos <= last_pos_reached ?
                            3'd0 :
                            row_pos+3'd1;

                 //Go to idle state once last character has completed.
                 state <= finished ? `FONT_STATE_IDLE : `FONT_STATE_WRITE;
                 
                 //If last position reached, write data.
                 if(last_pos_reached) begin
                    font_write <= 1'b1;
                    
                    second_word_pending <= ~second_word_pending & char_width[3];
                    
                    //For fonts <=8 pixels wide, increment the memory address
                    //by character char_height on each write, until the last character
                    //has been reached, then repeat.
                    //For fonts <=16 pixels wide, write the first 8b word, then
                    //the second word (addr+1), then increment by 2*char_height.
                    addr <= second_word_pending ? addr+12'd1 :
                            char==MAX_CHAR ? {8'd0,(char_y-4'd1)} :
                            !char_width[3] ? addr+{7'd0,({1'b0,char_height}+5'd1)} :
                            addr+{6'd0,({1'b0,char_height}+5'd1),1'b0}-12'd1;
                    font_addr <= addr;

                    //Write one row of all characters, then go to the next row.
                    //Note: Because of the way images are stored in the BMP standard,
                    //      fonts are loaded from the bottom up.
                    char_y <= second_word_pending ? char_y :
                              char==MAX_CHAR ? char_y-4'd1 :
                              char_y;
                    
                    //Write one row of each character in sequence, then repeat.
                    char <= second_word_pending ? char :
                            char==MAX_CHAR ? 7'd0 :
                            char+7'd1;
                 end
                 else begin
                    font_write <= 1'b0;
                 end
              end // if (pixel_valid)
              else begin
                 font_write <= 1'b0;
              end
           end
           default: begin
              font_write <= 1'b0;
           end
         endcase
      end // if (state!=`FONT_STATE_IDLE)
      else begin
         font_write <= 1'b0;
      end
   end // always @ (posedge clk)

   //Send row data (pixel values) to memory.
   assign font_data_in = row_data;

   //Output current pixel position for display.
   assign pos_x = !char_width[3] || second_word_pending ?
                  {{(`GPU_X_WIDTH-3){1'b0}},row_pos} :
                  {{(`GPU_X_WIDTH-4){1'b0}},({1'b0,row_pos}+4'd8)};
   assign pos_y = {{(`GPU_X_WIDTH-4){1'b0}},char_y};

   //Assert read finished when in idle state.
   assign read_finished = state==`FONT_STATE_IDLE;

   //Return the current pixel value (enable). The pixel
   //value is valid once the state machine is in the read state.
   assign pixel_valid = state==`FONT_STATE_READ_WORD;
   assign pixel_en = row_data[row_pos];

endmodule