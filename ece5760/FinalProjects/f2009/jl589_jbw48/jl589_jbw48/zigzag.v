module zigzag(
   input clk, // control clock
   input enable, // enable signal
   output reg rden, // read enable
   output reg latch_dc, // tells the top level module to latch the DC value, for differential encoding
   output reg [11:0] rdaddress // read address sent to the memory module
   );
   
   reg [7:0] state; // current state of the system
   
   // Reads in the block in a zig-zag pattern
   // This makes it easier to find the End-Of-Block (EOB)
   always @(posedge clk) begin
      if (~enable) begin
         state <= 0;
         rden <= 0;
         latch_dc <= 0;
         rdaddress <= 0;
      end
      else begin
         case (state)
            // at each clock cycle, update the read address to the next in the zigzag
            0:  begin
                state <= 1;
                rden <= 1;
                rdaddress <= {4'h0, 8'h0};
                end
            1:  begin
                state <= 2;
                rdaddress <= {4'h0, 8'h1};
                latch_dc <= 1;
                end
            2:  begin
                state <= 3;
                rdaddress <= {4'h1, 8'h0};
                latch_dc <= 0;
                end
            3:  begin
                state <= 4;
                rdaddress <= {4'h2, 8'h0};
                end
            4:  begin
                state <= 5;
                rdaddress <= {4'h1, 8'h1};
                end
            5:  begin
                state <= 6;
                rdaddress <= {4'h0, 8'h2};
                end
            6:  begin
                state <= 7;
                rdaddress <= {4'h0, 8'h3};
                end
            7:  begin
                state <= 8;
                rdaddress <= {4'h1, 8'h2};
                end
            8:  begin
                state <= 9;
                rdaddress <= {4'h2, 8'h1};
                end
            9:  begin
                state <= 10;
                rdaddress <= {4'h3, 8'h0};
                end
            10: begin
                state <= 11;
                rdaddress <= {4'h4, 8'h0};
                end
            11: begin
                state <= 12;
                rdaddress <= {4'h3, 8'h1};
                end
            12: begin
                state <= 13;
                rdaddress <= {4'h2, 8'h2};
                end
            13: begin
                state <= 14;
                rdaddress <= {4'h1, 8'h3};
                end
            14: begin
                state <= 15;
                rdaddress <= {4'h0, 8'h4};
                end
            15: begin
                state <= 16;
                rdaddress <= {4'h0, 8'h5};
                end
            16: begin
                state <= 17;
                rdaddress <= {4'h1, 8'h4};
                end
            17: begin
                state <= 18;
                rdaddress <= {4'h2, 8'h3};
                end
            18: begin
                state <= 19;
                rdaddress <= {4'h3, 8'h2};
                end
            19: begin
                state <= 20;
                rdaddress <= {4'h4, 8'h1};
                end
            20: begin
                state <= 21;
                rdaddress <= {4'h5, 8'h0};
                end
            21: begin
                state <= 22;
                rdaddress <= {4'h6, 8'h0};
                end
            22: begin
                state <= 23;
                rdaddress <= {4'h5, 8'h1};
                end
            23: begin
                state <= 24;
                rdaddress <= {4'h4, 8'h2};
                end
            24: begin
                state <= 25;
                rdaddress <= {4'h3, 8'h3};
                end
            25: begin
                state <= 26;
                rdaddress <= {4'h2, 8'h4};
                end
            26: begin
                state <= 27;
                rdaddress <= {4'h1, 8'h5};
                end
            27: begin
                state <= 28;
                rdaddress <= {4'h0, 8'h6};
                end
            28: begin
                state <= 29;
                rdaddress <= {4'h0, 8'h7};
                end
            29: begin
                state <= 30;
                rdaddress <= {4'h1, 8'h6};
                end
            30: begin
                state <= 31;
                rdaddress <= {4'h2, 8'h5};
                end
            31: begin
                state <= 32;
                rdaddress <= {4'h3, 8'h4};
                end
            32: begin
                state <= 33;
                rdaddress <= {4'h4, 8'h3};
                end
            33: begin
                state <= 34;
                rdaddress <= {4'h5, 8'h2};
                end
            34: begin
                state <= 35;
                rdaddress <= {4'h6, 8'h1};
                end
            35: begin
                state <= 36;
                rdaddress <= {4'h7, 8'h0};
                end
            36: begin
                state <= 37;
                rdaddress <= {4'h7, 8'h1};
                end
            37: begin
                state <= 38;
                rdaddress <= {4'h6, 8'h2};
                end
            38: begin
                state <= 39;
                rdaddress <= {4'h5, 8'h3};
                end
            39: begin
                state <= 40;
                rdaddress <= {4'h4, 8'h4};
                end
            40: begin
                state <= 41;
                rdaddress <= {4'h3, 8'h5};
                end
            41: begin
                state <= 42;
                rdaddress <= {4'h2, 8'h6};
                end
            42: begin
                state <= 43;
                rdaddress <= {4'h1, 8'h7};
                end
            43: begin
                state <= 44;
                rdaddress <= {4'h2, 8'h7};
                end
            44: begin
                state <= 45;
                rdaddress <= {4'h3, 8'h6};
                end
            45: begin
                state <= 46;
                rdaddress <= {4'h4, 8'h5};
                end
            46: begin
                state <= 47;
                rdaddress <= {4'h5, 8'h4};
                end
            47: begin
                state <= 48;
                rdaddress <= {4'h6, 8'h3};
                end
            48: begin
                state <= 49;
                rdaddress <= {4'h7, 8'h2};
                end
            49: begin
                state <= 50;
                rdaddress <= {4'h7, 8'h3};
                end
            50: begin
                state <= 51;
                rdaddress <= {4'h6, 8'h4};
                end
            51: begin
                state <= 52;
                rdaddress <= {4'h5, 8'h5};
                end
            52: begin
                state <= 53;
                rdaddress <= {4'h4, 8'h6};
                end
            53: begin
                state <= 54;
                rdaddress <= {4'h3, 8'h7};
                end
            54: begin
                state <= 55;
                rdaddress <= {4'h4, 8'h7};
                end
            55: begin
                state <= 56;
                rdaddress <= {4'h5, 8'h6};
                end
            56: begin
                state <= 57;
                rdaddress <= {4'h6, 8'h5};
                end
            57: begin
                state <= 58;
                rdaddress <= {4'h7, 8'h4};
                end
            58: begin
                state <= 59;
                rdaddress <= {4'h7, 8'h5};
                end
            59: begin
                state <= 60;
                rdaddress <= {4'h6, 8'h6};
                end
            60: begin
                state <= 61;
                rdaddress <= {4'h5, 8'h7};
                end
            61: begin
                state <= 62;
                rdaddress <= {4'h6, 8'h7};
                end
            62: begin
                state <= 63;
                rdaddress <= {4'h7, 8'h6};
                end
            63: begin
                state <= 64;
                rdaddress <= {4'h7, 8'h7};
                end
            default: begin
                state <= 127;
                rden <= 0;
                latch_dc <= 0;
                rdaddress <= 0;
                end
         endcase
      end
   end
   
endmodule
   