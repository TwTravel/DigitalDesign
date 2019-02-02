`include "disp_controller.vh"

module disp_controller(
    input                            clk,
    input                            reset,
    //Hardware interface.
    output wire                      disp_drawing,
    output wire [`DISP_X_RANGE]      pos_x,
    output wire [`DISP_Y_RANGE]      pos_y,
    input [`DISP_COLOR_R_RANGE]      r_in,
    input [`DISP_COLOR_G_RANGE]      g_in,
    input [`DISP_COLOR_B_RANGE]      b_in,
    //Display interface.
    output reg                       disp_hs_n,
    output reg                       disp_vs_n,
    output wire                      disp_blank_n,
    output wire                      disp_sync,
    output reg [`DISP_COLOR_R_RANGE] disp_r,
    output reg [`DISP_COLOR_G_RANGE] disp_g,
    output reg [`DISP_COLOR_B_RANGE] disp_b);

   //Generate horizontal sync.
   reg [`DISP_H_COUNTER_RANGE] h_counter;
   always @(posedge clk) begin
      h_counter <= reset ? `DISP_H_COUNTER_WIDTH'h0 :
                   h_counter==`DISP_H_MAX_COUNT ? `DISP_H_COUNTER_WIDTH'h0 :
                   h_counter+`DISP_H_COUNTER_WIDTH'h1;

      //H-sync is low during sync, and high otherwise.
      //Data is drawn from count 0 to DISP_H_DATA-1.
      disp_hs_n <= h_counter<`DISP_H_SYNC_START ||
                   h_counter>=`DISP_H_SYNC_END;

      //Setup next pixel color values.
      disp_r <= r_in;
      disp_g <= g_in;
      disp_b <= b_in;
   end

   //Next X-axis pixel position is lower bits of h_counter.
   assign pos_x = h_counter[`DISP_X_RANGE];

   //Update V-sync at the end of each line.
   wire v_sync_update;
   assign v_sync_update = h_counter==`DISP_H_MAX_COUNT;

   //Generate vertical sync.
   reg [`DISP_V_COUNTER_RANGE] v_counter;
   always @(posedge clk) begin
      v_counter <= reset ? `DISP_V_COUNTER_WIDTH'h0 :
                   !v_sync_update ? v_counter :
                   v_counter==`DISP_V_MAX_COUNT ? `DISP_V_COUNTER_WIDTH'h0 :
                   v_counter+`DISP_V_COUNTER_WIDTH'h1;

      //V-sync is low during sync, and high otherwise.
      //Data is drawn from count 0 to DISP_V_DATA-1.
      disp_vs_n <= v_counter<`DISP_V_SYNC_START ||
                   v_counter>=`DISP_V_SYNC_END;
   end

   //Next Y-axis pixel position is lower bits of v_counter.
   assign pos_y = v_counter[`DISP_Y_RANGE];

   //Inform hardware when drawing pixel data.
   assign disp_drawing = h_counter<`DISP_H_COUNTER_WIDTH'd`DISP_H_DATA &&
                         v_counter<`DISP_V_COUNTER_WIDTH'd`DISP_V_DATA;

   //Setup display signals. Note that disp_blank_n is active
   //low, and goes high when the display is drawing.
   assign disp_sync = 1'b0;
   assign disp_blank_n = disp_hs_n & disp_vs_n;
   
endmodule