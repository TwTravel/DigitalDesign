`include "gpu_inst_controller.vh"
`include "gpu_fg_controller.vh"

//`define DEBUG
`undef DEBUG
`include "debug.vh"

module gpu_fg_controller(
    input                clk,
    input                reset,
    //Pixel enable write interface.
    input                write,
    input [`GPU_X_RANGE] wr_x,
    input [`GPU_Y_RANGE] wr_y,
    input                enable,
    //Pixel enable read interface.
    input                display_drawing,
    input [`GPU_X_RANGE] rd_x,
    input [`GPU_Y_RANGE] rd_y,
    output wire          value,
    output wire          mismatch_pause);

   //Select appropriate x/y positions and generate
   //memory address from them.
   //Note: Read-side x value is increased to
   //      prefetch the read value for the display.
   `KEEP wire [`GPU_X_RANGE] sel_x;
   `KEEP wire [`GPU_Y_RANGE] sel_y;
   assign sel_x = display_drawing ? (rd_x+`GPU_X_WIDTH'd1) : wr_x;
   assign sel_y = display_drawing ? rd_y : wr_y;

   `KEEP wire [`GPU_FG_ADDR_RANGE] addr;
   assign addr = sel_y*`GPU_FG_WORDS_PER_ROW+sel_x[(`GPU_X_WIDTH-1):5];


   //Pause the display hardware whenever the current
   //state does not match the desired address. The
   //write will be completed the cycle after the state
   //is updated, but the hardware should not have changed
   //its values yet.
   assign mismatch_pause = addr!=current_addr;

   //Issue a read whenever the desired address doesn't
   //match that of the currently retrieved state.
   `KEEP wire issue_read;
   assign issue_read = addr!=current_addr;

   //A read result is available one cycle after issue.
   `KEEP wire read_available;
   delay read_delay(.clk(clk),
                    .reset(reset),
                    .in(issue_read && !read_available),
                    .out(read_available));

   //Delay write enable one cycle to allow
   //current state register to update.
   wire write_en;
   /*delay write_delay(.clk(clk),
                     .reset(reset),
                     .in(!display_drawing && write && !issue_read),
                     .out(write_en));*/
   assign write_en = !display_drawing && write && !issue_read;

   //The foreground enable state memory is
   //organized in 32b words, with one enable
   //bit per pixel.
   //Note: The state is bit-reversed (LSB first)
   //      to coincide with pixel direction.
   `KEEP wire [0:31] fg_ram_out;
   `PRESERVE reg [0:31] current_state;
   gpu_fg_en_ram #(.ADDR_WIDTH(`GPU_FG_ADDR_WIDTH),
                   .DEPTH(`GPU_FG_MEM_DEPTH))
     fg_en_ram(.clock(clk),
               .address(addr),
               .wren(write_en),
               .data(next_state),
               .q(fg_ram_out));

   //Select the appropriate bit, given
   //the bottom 5 bits of the x value.
   `KEEP wire [4:0] bit_select;
   assign bit_select = sel_x[4:0];

   //Update the currently retrieved address when
   //a read is returned from memory.
   reg [`GPU_FG_ADDR_RANGE] current_addr;
   always @(posedge clk) begin
      current_addr <= reset ? `GPU_FG_ADDR_WIDTH'd0 :
                      read_available ? addr :
                      current_addr;
   end

   wire [0:31] next_state;
   genvar i;
   generate
      for(i=0;i<32;i=i+1) begin : state_gen
         assign next_state[i] = bit_select==i ? enable : current_state[i];
      end
   endgenerate
   
   always @(posedge clk) begin
      current_state <= reset ? 1'b0 :
                          read_available ? fg_ram_out :
                          issue_read ? current_state :
                          !display_drawing && write ? next_state :
                          current_state;
   end

   assign value = current_state[rd_x[4:0]];
   //assign value = rd_x>=`GPU_X_WIDTH'd300 && rd_x<`GPU_X_WIDTH'd348 &&
   //               rd_y>=`GPU_Y_WIDTH'd81 && rd_y<`GPU_Y_WIDTH'd105;
   
endmodule