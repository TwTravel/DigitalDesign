module dct2d(clk, reset, rden, rdaddress, q, wren, data, wraddress);

   input clk, reset; // clock and reset for the module
   input signed [63:0] q; // data read from memory
   //input [3:0] currentX, currentY;
   output reg rden, wren; // read/write clock/enable signals for memory
   output reg [8:0] rdaddress, wraddress; // read/write addresses to memory
   output reg [63:0] data; // data to write to memory
   //output reg zz_enable; // used when you want to trigger the zig-zag unit once this module has finished running
   
   // pipelined results from the dct module
   wire signed [21:0] out0, out1, out2, out3, out4, out5, out6, out7; // outputs of the 1-D DCT module
   
   reg [3:0] currentBlock; // this would be used with the address register when trying to compress an entire frame rather than just two blocks
   reg [5:0] state;
   reg signed [21:0] first[0:7][0:7], second[0:7][0:7]; // intermediate results, after each set of DCTs
   reg signed [21:0] in0, in1, in2, in3, in4, in5, in6, in7; // sign extended inputs
   reg [7:0] result0, result1, result2, result3, result4, result5, result6, result7; // integer valued results of the 2-D DCT
   
   // 1-D fast DCT algorithm module
   dct_algorithm dct(clk, reset, 
      in0, in1, in2, in3, in4, in5, in6, in7, 
      out0, out1, out2, out3, out4, out5, out6, out7);
   
   always @(posedge clk) begin
      if (reset) begin
         state <= 0;
         
         rden <= 0; wren <= 0;
         rdaddress <= 0; wraddress <= 0;
         data <= 0;
         
         in0 <= 0; in1 <= 0; in2 <= 0; in3 <= 0;
         in4 <= 0; in5 <= 0; in6 <= 0; in7 <= 0;
         
         result0 <= 0; result1 <= 0; result2 <= 0; result3 <= 0;
         result4 <= 0; result5 <= 0; result6 <= 0; result7 <= 0;
         
         first[0][0] <= 0; first[0][1] <= 0; first[0][2] <= 0; first[0][3] <= 0; 
         first[0][4] <= 0; first[0][5] <= 0; first[0][6] <= 0; first[0][7] <= 0; 
         first[1][0] <= 0; first[1][1] <= 0; first[1][2] <= 0; first[1][3] <= 0; 
         first[1][4] <= 0; first[1][5] <= 0; first[1][6] <= 0; first[1][7] <= 0; 
         first[2][0] <= 0; first[2][1] <= 0; first[2][2] <= 0; first[2][3] <= 0; 
         first[2][4] <= 0; first[2][5] <= 0; first[2][6] <= 0; first[2][7] <= 0; 
         first[3][0] <= 0; first[3][1] <= 0; first[3][2] <= 0; first[3][3] <= 0; 
         first[3][4] <= 0; first[3][5] <= 0; first[3][6] <= 0; first[3][7] <= 0; 
         first[4][0] <= 0; first[4][1] <= 0; first[4][2] <= 0; first[4][3] <= 0; 
         first[4][4] <= 0; first[4][5] <= 0; first[4][6] <= 0; first[4][7] <= 0; 
         first[5][0] <= 0; first[5][1] <= 0; first[5][2] <= 0; first[5][3] <= 0; 
         first[5][4] <= 0; first[5][5] <= 0; first[5][6] <= 0; first[5][7] <= 0; 
         first[6][0] <= 0; first[6][1] <= 0; first[6][2] <= 0; first[6][3] <= 0; 
         first[6][4] <= 0; first[6][5] <= 0; first[6][6] <= 0; first[6][7] <= 0; 
         first[7][0] <= 0; first[7][1] <= 0; first[7][2] <= 0; first[7][3] <= 0; 
         first[7][4] <= 0; first[7][5] <= 0; first[7][6] <= 0; first[7][7] <= 0;
         
         second[0][0] <= 0; second[0][1] <= 0; second[0][2] <= 0; second[0][3] <= 0; 
         second[0][4] <= 0; second[0][5] <= 0; second[0][6] <= 0; second[0][7] <= 0; 
         second[1][0] <= 0; second[1][1] <= 0; second[1][2] <= 0; second[1][3] <= 0; 
         second[1][4] <= 0; second[1][5] <= 0; second[1][6] <= 0; second[1][7] <= 0; 
         second[2][0] <= 0; second[2][1] <= 0; second[2][2] <= 0; second[2][3] <= 0; 
         second[2][4] <= 0; second[2][5] <= 0; second[2][6] <= 0; second[2][7] <= 0; 
         second[3][0] <= 0; second[3][1] <= 0; second[3][2] <= 0; second[3][3] <= 0; 
         second[3][4] <= 0; second[3][5] <= 0; second[3][6] <= 0; second[3][7] <= 0; 
         second[4][0] <= 0; second[4][1] <= 0; second[4][2] <= 0; second[4][3] <= 0; 
         second[4][4] <= 0; second[4][5] <= 0; second[4][6] <= 0; second[4][7] <= 0; 
         second[5][0] <= 0; second[5][1] <= 0; second[5][2] <= 0; second[5][3] <= 0; 
         second[5][4] <= 0; second[5][5] <= 0; second[5][6] <= 0; second[5][7] <= 0; 
         second[6][0] <= 0; second[6][1] <= 0; second[6][2] <= 0; second[6][3] <= 0; 
         second[6][4] <= 0; second[6][5] <= 0; second[6][6] <= 0; second[6][7] <= 0; 
         second[7][0] <= 0; second[7][1] <= 0; second[7][2] <= 0; second[7][3] <= 0; 
         second[7][4] <= 0; second[7][5] <= 0; second[7][6] <= 0; second[7][7] <= 0;
      end
      else begin
         case (state) 
            0: begin 
               state <= 1; 
               // assert appropriate read signals, to be read a few cycles later
               rden <= 1;
               rdaddress <= {4'h0,5'h0};
               //currentBlock <= {currentY[2:0],currentX[3]};
               currentBlock <= 0;
               end
            1: begin 
               state <= 2; 
               rdaddress <= {4'h1,currentBlock,1'b0};
               end
            2: begin 
               state <= 3; 
               rdaddress <= {4'h2,currentBlock,1'b0};
               
               // Start DCTs on the rows of the first block,
               // by sign extending the inputs
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               end
            3: begin 
               state <= 4; 
               rdaddress <= {4'h3,currentBlock,1'b0};
                  
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               end
            4: begin 
               state <= 5; 
               rdaddress <= {4'h4,currentBlock,1'b0};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               end
            5: begin 
               state <= 6; 
               rdaddress <= {4'h5,currentBlock,1'b0};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               end
            6: begin 
               state <= 7; 
               rdaddress <= {4'h6,currentBlock,1'b0};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               end
            7: begin 
               state <= 8; 
               rdaddress <= {4'h7,currentBlock,1'b0};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               end
            8: begin 
               state <= 9; 
               rdaddress <= {4'h0,currentBlock,1'b1};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               end
            9: begin 
               state <= 10;
               rdaddress <= {4'h1,currentBlock,1'b1};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               end
            
            // ROW RESULTS, FIRST BLOCK
            10:   begin
               state <= 11;
               rdaddress <= {4'h2,currentBlock,1'b1};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               
               // store the results of the DCT into the register matrix
               first[0][0] <= out0;
               first[0][1] <= out1;
               first[0][2] <= out2;
               first[0][3] <= out3;
               first[0][4] <= out4;
               first[0][5] <= out5;
               first[0][6] <= out6;
               first[0][7] <= out7;
               end
            11:   begin
               state <= 12;
               rdaddress <= {4'h3,currentBlock,1'b1};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               
               first[1][0] <= out0;
               first[1][1] <= out1;
               first[1][2] <= out2;
               first[1][3] <= out3;
               first[1][4] <= out4;
               first[1][5] <= out5;
               first[1][6] <= out6;
               first[1][7] <= out7;
               end
            12:   begin
               state <= 13;
               rdaddress <= {4'h4,currentBlock,1'b1};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               
               first[2][0] <= out0;
               first[2][1] <= out1;
               first[2][2] <= out2;
               first[2][3] <= out3;
               first[2][4] <= out4;
               first[2][5] <= out5;
               first[2][6] <= out6;
               first[2][7] <= out7;
               end
            13:   begin
               state <= 14;
               rdaddress <= {4'h5,currentBlock,1'b1};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               
               first[3][0] <= out0;
               first[3][1] <= out1;
               first[3][2] <= out2;
               first[3][3] <= out3;
               first[3][4] <= out4;
               first[3][5] <= out5;
               first[3][6] <= out6;
               first[3][7] <= out7;
               end
            14:   begin
               state <= 15;
               rdaddress <= {4'h6,currentBlock,1'b1};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               
               first[4][0] <= out0;
               first[4][1] <= out1;
               first[4][2] <= out2;
               first[4][3] <= out3;
               first[4][4] <= out4;
               first[4][5] <= out5;
               first[4][6] <= out6;
               first[4][7] <= out7;
               end
            15:   begin
               state <= 16;
               rdaddress <= {4'h7,currentBlock,1'b1};
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               
               first[5][0] <= out0;
               first[5][1] <= out1;
               first[5][2] <= out2;
               first[5][3] <= out3;
               first[5][4] <= out4;
               first[5][5] <= out5;
               first[5][6] <= out6;
               first[5][7] <= out7;
               end
            16:   begin
               state <= 17;
               rden <= 0;
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               
               first[6][0] <= out0;
               first[6][1] <= out1;
               first[6][2] <= out2;
               first[6][3] <= out3;
               first[6][4] <= out4;
               first[6][5] <= out5;
               first[6][6] <= out6;
               first[6][7] <= out7;
               end
            17:   begin
               state <= 18;
               
               in0 <= {{6{q[7]}},q[7:0],8'b0};
               in1 <= {{6{q[15]}},q[15:8],8'b0};
               in2 <= {{6{q[23]}},q[23:16],8'b0};
               in3 <= {{6{q[31]}},q[31:24],8'b0};
               in4 <= {{6{q[39]}},q[39:32],8'b0};
               in5 <= {{6{q[47]}},q[47:40],8'b0};
               in6 <= {{6{q[55]}},q[55:48],8'b0};
               in7 <= {{6{q[63]}},q[63:56],8'b0};
               
               first[7][0] <= out0;
               first[7][1] <= out1;
               first[7][2] <= out2;
               first[7][3] <= out3;
               first[7][4] <= out4;
               first[7][5] <= out5;
               first[7][6] <= out6;
               first[7][7] <= out7;
               end
            
            // ROW RESULTS, SECOND BLOCK
            18:   begin
               state <= 19;
               
               // start DCT processing on columns of first block
               in0 <= first[0][0];
               in1 <= first[1][0];
               in2 <= first[2][0];
               in3 <= first[3][0];
               in4 <= first[4][0];
               in5 <= first[5][0];
               in6 <= first[6][0];
               in7 <= first[7][0];
               
               second[0][0] <= out0;
               second[0][1] <= out1;
               second[0][2] <= out2;
               second[0][3] <= out3;
               second[0][4] <= out4;
               second[0][5] <= out5;
               second[0][6] <= out6;
               second[0][7] <= out7;
               end
            19:   begin
               state <= 20;
               
               in0 <= first[0][1];
               in1 <= first[1][1];
               in2 <= first[2][1];
               in3 <= first[3][1];
               in4 <= first[4][1];
               in5 <= first[5][1];
               in6 <= first[6][1];
               in7 <= first[7][1];
               
               second[1][0] <= out0;
               second[1][1] <= out1;
               second[1][2] <= out2;
               second[1][3] <= out3;
               second[1][4] <= out4;
               second[1][5] <= out5;
               second[1][6] <= out6;
               second[1][7] <= out7;
               end
            20:   begin
               state <= 21;
               
               in0 <= first[0][2];
               in1 <= first[1][2];
               in2 <= first[2][2];
               in3 <= first[3][2];
               in4 <= first[4][2];
               in5 <= first[5][2];
               in6 <= first[6][2];
               in7 <= first[7][2];
               
               second[2][0] <= out0;
               second[2][1] <= out1;
               second[2][2] <= out2;
               second[2][3] <= out3;
               second[2][4] <= out4;
               second[2][5] <= out5;
               second[2][6] <= out6;
               second[2][7] <= out7;
               end
            21:   begin
               state <= 22;
               
               in0 <= first[0][3];
               in1 <= first[1][3];
               in2 <= first[2][3];
               in3 <= first[3][3];
               in4 <= first[4][3];
               in5 <= first[5][3];
               in6 <= first[6][3];
               in7 <= first[7][3];
               
               second[3][0] <= out0;
               second[3][1] <= out1;
               second[3][2] <= out2;
               second[3][3] <= out3;
               second[3][4] <= out4;
               second[3][5] <= out5;
               second[3][6] <= out6;
               second[3][7] <= out7;
               end
            22:   begin
               state <= 23;
               
               in0 <= first[0][4];
               in1 <= first[1][4];
               in2 <= first[2][4];
               in3 <= first[3][4];
               in4 <= first[4][4];
               in5 <= first[5][4];
               in6 <= first[6][4];
               in7 <= first[7][4];
               
               second[4][0] <= out0;
               second[4][1] <= out1;
               second[4][2] <= out2;
               second[4][3] <= out3;
               second[4][4] <= out4;
               second[4][5] <= out5;
               second[4][6] <= out6;
               second[4][7] <= out7;
               end
            23:   begin
               state <= 24;
               
               in0 <= first[0][5];
               in1 <= first[1][5];
               in2 <= first[2][5];
               in3 <= first[3][5];
               in4 <= first[4][5];
               in5 <= first[5][5];
               in6 <= first[6][5];
               in7 <= first[7][5];
               
               second[5][0] <= out0;
               second[5][1] <= out1;
               second[5][2] <= out2;
               second[5][3] <= out3;
               second[5][4] <= out4;
               second[5][5] <= out5;
               second[5][6] <= out6;
               second[5][7] <= out7;
               end
            24:   begin
               state <= 25;
               
               in0 <= first[0][6];
               in1 <= first[1][6];
               in2 <= first[2][6];
               in3 <= first[3][6];
               in4 <= first[4][6];
               in5 <= first[5][6];
               in6 <= first[6][6];
               in7 <= first[7][6];
               
               second[6][0] <= out0;
               second[6][1] <= out1;
               second[6][2] <= out2;
               second[6][3] <= out3;
               second[6][4] <= out4;
               second[6][5] <= out5;
               second[6][6] <= out6;
               second[6][7] <= out7;
               end
            25:   begin
               state <= 26;
               
               in0 <= first[0][7];
               in1 <= first[1][7];
               in2 <= first[2][7];
               in3 <= first[3][7];
               in4 <= first[4][7];
               in5 <= first[5][7];
               in6 <= first[6][7];
               in7 <= first[7][7];
               
               second[7][0] <= out0;
               second[7][1] <= out1;
               second[7][2] <= out2;
               second[7][3] <= out3;
               second[7][4] <= out4;
               second[7][5] <= out5;
               second[7][6] <= out6;
               second[7][7] <= out7;
               end
               
            // COLUMN RESULTS, FIRST BLOCK
            26:   begin
               state <= 27;

               // start DCT processing on columns of second block
               in0 <= second[0][0];
               in1 <= second[1][0];
               in2 <= second[2][0];
               in3 <= second[3][0];
               in4 <= second[4][0];
               in5 <= second[5][0];
               in6 <= second[6][0];
               in7 <= second[7][0];
               
               first[0][0] <= out0;
               first[1][0] <= out1;
               first[2][0] <= out2;
               first[3][0] <= out3;
               first[4][0] <= out4;
               first[5][0] <= out5;
               first[6][0] <= out6;
               first[7][0] <= out7;
               end
            27:   begin
               state <= 28;

               in0 <= second[0][1];
               in1 <= second[1][1];
               in2 <= second[2][1];
               in3 <= second[3][1];
               in4 <= second[4][1];
               in5 <= second[5][1];
               in6 <= second[6][1];
               in7 <= second[7][1];
               
               first[0][1] <= out0;
               first[1][1] <= out1;
               first[2][1] <= out2;
               first[3][1] <= out3;
               first[4][1] <= out4;
               first[5][1] <= out5;
               first[6][1] <= out6;
               first[7][1] <= out7;
               end
            28:   begin
               state <= 29;

               in0 <= second[0][2];
               in1 <= second[1][2];
               in2 <= second[2][2];
               in3 <= second[3][2];
               in4 <= second[4][2];
               in5 <= second[5][2];
               in6 <= second[6][2];
               in7 <= second[7][2];
               
               first[0][2] <= out0;
               first[1][2] <= out1;
               first[2][2] <= out2;
               first[3][2] <= out3;
               first[4][2] <= out4;
               first[5][2] <= out5;
               first[6][2] <= out6;
               first[7][2] <= out7;
               end
            29:   begin
               state <= 30;

               in0 <= second[0][3];
               in1 <= second[1][3];
               in2 <= second[2][3];
               in3 <= second[3][3];
               in4 <= second[4][3];
               in5 <= second[5][3];
               in6 <= second[6][3];
               in7 <= second[7][3];
               
               first[0][3] <= out0;
               first[1][3] <= out1;
               first[2][3] <= out2;
               first[3][3] <= out3;
               first[4][3] <= out4;
               first[5][3] <= out5;
               first[6][3] <= out6;
               first[7][3] <= out7;
               end
            30:   begin
               state <= 31;

               in0 <= second[0][4];
               in1 <= second[1][4];
               in2 <= second[2][4];
               in3 <= second[3][4];
               in4 <= second[4][4];
               in5 <= second[5][4];
               in6 <= second[6][4];
               in7 <= second[7][4];
               
               first[0][4] <= out0;
               first[1][4] <= out1;
               first[2][4] <= out2;
               first[3][4] <= out3;
               first[4][4] <= out4;
               first[5][4] <= out5;
               first[6][4] <= out6;
               first[7][4] <= out7;
               end
            31:   begin
               state <= 32;

               in0 <= second[0][5];
               in1 <= second[1][5];
               in2 <= second[2][5];
               in3 <= second[3][5];
               in4 <= second[4][5];
               in5 <= second[5][5];
               in6 <= second[6][5];
               in7 <= second[7][5];
               
               first[0][5] <= out0;
               first[1][5] <= out1;
               first[2][5] <= out2;
               first[3][5] <= out3;
               first[4][5] <= out4;
               first[5][5] <= out5;
               first[6][5] <= out6;
               first[7][5] <= out7;
               end
            32:   begin
               state <= 33;

               in0 <= second[0][6];
               in1 <= second[1][6];
               in2 <= second[2][6];
               in3 <= second[3][6];
               in4 <= second[4][6];
               in5 <= second[5][6];
               in6 <= second[6][6];
               in7 <= second[7][6];
               
               first[0][6] <= out0;
               first[1][6] <= out1;
               first[2][6] <= out2;
               first[3][6] <= out3;
               first[4][6] <= out4;
               first[5][6] <= out5;
               first[6][6] <= out6;
               first[7][6] <= out7;
               end
            33:   begin
               state <= 34;

               in0 <= second[0][7];
               in1 <= second[1][7];
               in2 <= second[2][7];
               in3 <= second[3][7];
               in4 <= second[4][7];
               in5 <= second[5][7];
               in6 <= second[6][7];
               in7 <= second[7][7];
               
               first[0][7] <= out0;
               first[1][7] <= out1;
               first[2][7] <= out2;
               first[3][7] <= out3;
               first[4][7] <= out4;
               first[5][7] <= out5;
               first[6][7] <= out6;
               first[7][7] <= out7;
               end
               
            // COLUMN RESULTS, SECOND BLOCK, QUANTIZATION, FIRST BLOCK
            34:   begin
               state <= 35;
               
               second[0][0] <= out0;
               second[1][0] <= out1;
               second[2][0] <= out2;
               second[3][0] <= out3;
               second[4][0] <= out4;
               second[5][0] <= out5;
               second[6][0] <= out6;
               second[7][0] <= out7;
               
               // get results. These operations are nothing more than grabbing the integer values of the
               // fixed point numbers after a bit shift
               result0 <= {first[0][0][21],first[0][0][21:15]} + {8'b1 & {7'b0, first[0][0][14]}};
               result1 <= {first[0][1][21],first[0][1][21:15]} + {8'b1 & {7'b0, first[0][1][14]}};
               result2 <= {first[0][2][21],first[0][2][21:15]} + {8'b1 & {7'b0, first[0][2][14]}};
               result3 <= {first[0][3][21],first[0][3][21:15]} + {8'b1 & {7'b0, first[0][3][14]}};
               result4 <= {{2{first[0][4][21]}},first[0][4][21:16]} + {8'b1 & {7'b0, first[0][4][15]}};
               result5 <= {{2{first[0][5][21]}},first[0][5][21:16]} + {8'b1 & {7'b0, first[0][5][15]}};
               result6 <= {{2{first[0][6][21]}},first[0][6][21:16]} + {8'b1 & {7'b0, first[0][6][15]}};
               result7 <= {first[0][7][21],first[0][7][21:15]} + {8'b1 & {7'b0, first[0][7][14]}};
               end
            35:   begin
               state <= 36;
               
               // begin writing the results into the second memory module
               wren <= 1;
               wraddress <= {4'h0,currentBlock,1'b0};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               second[0][1] <= out0;
               second[1][1] <= out1;
               second[2][1] <= out2;
               second[3][1] <= out3;
               second[4][1] <= out4;
               second[5][1] <= out5;
               second[6][1] <= out6;
               second[7][1] <= out7;
               
               result0 <= {first[1][0][21],first[1][0][21:15]} + {8'b1 & {7'b0, first[1][0][14]}};
               result1 <= {{2{first[1][1][21]}},first[1][1][21:16]} + {8'b1 & {7'b0, first[1][1][15]}};
               result2 <= {{2{first[1][2][21]}},first[1][2][21:16]} + {8'b1 & {7'b0, first[1][2][15]}};
               result3 <= {{2{first[1][3][21]}},first[1][3][21:16]} + {8'b1 & {7'b0, first[1][3][15]}};
               result4 <= {{2{first[1][4][21]}},first[1][4][21:16]} + {8'b1 & {7'b0, first[1][4][15]}};
               result5 <= {{2{first[1][5][21]}},first[1][5][21:16]} + {8'b1 & {7'b0, first[1][5][15]}};
               result6 <= {{2{first[1][6][21]}},first[1][6][21:16]} + {8'b1 & {7'b0, first[1][6][15]}};
               result7 <= {first[1][7][21],first[1][7][21:15]} + {8'b1 & {7'b0, first[1][7][14]}};
               end
            36:   begin
               state <= 37;
               wraddress <= {4'h1,currentBlock,1'b0};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               second[0][2] <= out0;
               second[1][2] <= out1;
               second[2][2] <= out2;
               second[3][2] <= out3;
               second[4][2] <= out4;
               second[5][2] <= out5;
               second[6][2] <= out6;
               second[7][2] <= out7;
               
               result0 <= {first[2][0][21],first[2][0][21:15]} + {8'b1 & {7'b0, first[2][0][14]}};
               result1 <= {{2{first[2][1][21]}},first[2][1][21:16]} + {8'b1 & {7'b0, first[2][1][15]}};
               result2 <= {{2{first[2][2][21]}},first[2][2][21:16]} + {8'b1 & {7'b0, first[2][2][15]}};
               result3 <= {{2{first[2][3][21]}},first[2][3][21:16]} + {8'b1 & {7'b0, first[2][3][15]}};
               result4 <= {{2{first[2][4][21]}},first[2][4][21:16]} + {8'b1 & {7'b0, first[2][4][15]}};
               result5 <= {{2{first[2][5][21]}},first[2][5][21:16]} + {8'b1 & {7'b0, first[2][5][15]}};
               result6 <= {{2{first[2][6][21]}},first[2][6][21:16]} + {8'b1 & {7'b0, first[2][6][15]}};
               result7 <= {first[2][7][21],first[2][7][21:15]} + {8'b1 & {7'b0, first[2][7][14]}};
               end
            37:   begin
               state <= 38;
               wraddress <= {4'h2,currentBlock,1'b0};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               second[0][3] <= out0;
               second[1][3] <= out1;
               second[2][3] <= out2;
               second[3][3] <= out3;
               second[4][3] <= out4;
               second[5][3] <= out5;
               second[6][3] <= out6;
               second[7][3] <= out7;
               
               result0 <= {first[3][0][21],first[3][0][21:15]} + {8'b1 & {7'b0, first[3][0][14]}};
               result1 <= {{2{first[3][1][21]}},first[3][1][21:16]} + {8'b1 & {7'b0, first[3][1][15]}};
               result2 <= {{2{first[3][2][21]}},first[3][2][21:16]} + {8'b1 & {7'b0, first[3][2][15]}};
               result3 <= {{2{first[3][3][21]}},first[3][3][21:16]} + {8'b1 & {7'b0, first[3][3][15]}};
               result4 <= {{2{first[3][4][21]}},first[3][4][21:16]} + {8'b1 & {7'b0, first[3][4][15]}};
               result5 <= {{2{first[3][5][21]}},first[3][5][21:16]} + {8'b1 & {7'b0, first[3][5][15]}};
               result6 <= {{2{first[3][6][21]}},first[3][6][21:16]} + {8'b1 & {7'b0, first[3][6][15]}};
               result7 <= {first[3][7][21],first[3][7][21:15]} + {8'b1 & {7'b0, first[3][7][14]}};
               end
            38:   begin
               state <= 39;
               wraddress <= {4'h3,currentBlock,1'b0};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               second[0][4] <= out0;
               second[1][4] <= out1;
               second[2][4] <= out2;
               second[3][4] <= out3;
               second[4][4] <= out4;
               second[5][4] <= out5;
               second[6][4] <= out6;
               second[7][4] <= out7;
               
               result0 <= {first[4][0][21],first[4][0][21:15]} + {8'b1 & {7'b0, first[4][0][14]}};
               result1 <= {{2{first[4][1][21]}},first[4][1][21:16]} + {8'b1 & {7'b0, first[4][1][15]}};
               result2 <= {{2{first[4][2][21]}},first[4][2][21:16]} + {8'b1 & {7'b0, first[4][2][15]}};
               result3 <= {{2{first[4][3][21]}},first[4][3][21:16]} + {8'b1 & {7'b0, first[4][3][15]}};
               result4 <= {{2{first[4][4][21]}},first[4][4][21:16]} + {8'b1 & {7'b0, first[4][4][15]}};
               result5 <= {{2{first[4][5][21]}},first[4][5][21:16]} + {8'b1 & {7'b0, first[4][5][15]}};
               result6 <= {{2{first[4][6][21]}},first[4][6][21:16]} + {8'b1 & {7'b0, first[4][6][15]}};
               result7 <= {first[4][7][21],first[4][7][21:15]} + {8'b1 & {7'b0, first[4][7][14]}};
               end
            39:   begin
               state <= 40;
               wraddress <= {4'h4,currentBlock,1'b0};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               second[0][5] <= out0;
               second[1][5] <= out1;
               second[2][5] <= out2;
               second[3][5] <= out3;
               second[4][5] <= out4;
               second[5][5] <= out5;
               second[6][5] <= out6;
               second[7][5] <= out7;
               
               result0 <= {first[5][0][21],first[5][0][21:15]} + {8'b1 & {7'b0, first[5][0][14]}};
               result1 <= {{2{first[5][1][21]}},first[5][1][21:16]} + {8'b1 & {7'b0, first[5][1][15]}};
               result2 <= {{2{first[5][2][21]}},first[5][2][21:16]} + {8'b1 & {7'b0, first[5][2][15]}};
               result3 <= {{2{first[5][3][21]}},first[5][3][21:16]} + {8'b1 & {7'b0, first[5][3][15]}};
               result4 <= {{2{first[5][4][21]}},first[5][4][21:16]} + {8'b1 & {7'b0, first[5][4][15]}};
               result5 <= {{2{first[5][5][21]}},first[5][5][21:16]} + {8'b1 & {7'b0, first[5][5][15]}};
               result6 <= {{2{first[5][6][21]}},first[5][6][21:16]} + {8'b1 & {7'b0, first[5][6][15]}};
               result7 <= {first[5][7][21],first[5][7][21:15]} + {8'b1 & {7'b0, first[5][7][14]}};
               end
            40:   begin
               state <= 41;
               wraddress <= {4'h5,currentBlock,1'b0};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               second[0][6] <= out0;
               second[1][6] <= out1;
               second[2][6] <= out2;
               second[3][6] <= out3;
               second[4][6] <= out4;
               second[5][6] <= out5;
               second[6][6] <= out6;
               second[7][6] <= out7;
               
               result0 <= {{2{first[6][0][21]}},first[6][0][21:16]} + {8'b1 & {7'b0, first[6][0][15]}};
               result1 <= {{2{first[6][1][21]}},first[6][1][21:16]} + {8'b1 & {7'b0, first[6][1][15]}};
               result2 <= {{2{first[6][2][21]}},first[6][2][21:16]} + {8'b1 & {7'b0, first[6][2][15]}};
               result3 <= {{2{first[6][3][21]}},first[6][3][21:16]} + {8'b1 & {7'b0, first[6][3][15]}};
               result4 <= {{2{first[6][4][21]}},first[6][4][21:16]} + {8'b1 & {7'b0, first[6][4][15]}};
               result5 <= {{2{first[6][5][21]}},first[6][5][21:16]} + {8'b1 & {7'b0, first[6][5][15]}};
               result6 <= {{2{first[6][6][21]}},first[6][6][21:16]} + {8'b1 & {7'b0, first[6][6][15]}};
               result7 <= {first[6][7][21],first[6][7][21:15]} + {8'b1 & {7'b0, first[6][7][14]}};
               end
            41:   begin
               state <= 42;
               wraddress <= {4'h6,currentBlock,1'b0};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               second[0][7] <= out0;
               second[1][7] <= out1;
               second[2][7] <= out2;
               second[3][7] <= out3;
               second[4][7] <= out4;
               second[5][7] <= out5;
               second[6][7] <= out6;
               second[7][7] <= out7;
               
               result0 <= {first[7][0][21],first[7][0][21:15]} + {8'b1 & {7'b0, first[7][0][14]}};
               result1 <= {{2{first[7][1][21]}},first[7][1][21:16]} + {8'b1 & {7'b0, first[7][1][15]}};
               result2 <= {{2{first[7][2][21]}},first[7][2][21:16]} + {8'b1 & {7'b0, first[7][2][15]}};
               result3 <= {{2{first[7][3][21]}},first[7][3][21:16]} + {8'b1 & {7'b0, first[7][3][15]}};
               result4 <= {{2{first[7][4][21]}},first[7][4][21:16]} + {8'b1 & {7'b0, first[7][4][15]}};
               result5 <= {{2{first[7][5][21]}},first[7][5][21:16]} + {8'b1 & {7'b0, first[7][5][15]}};
               result7 <= {first[7][6][21],first[7][6][21:15]} + {8'b1 & {7'b0, first[7][6][14]}};
               result7 <= first[7][7][21:14] + {8'b1 & {7'b0, first[7][7][13]}};
               end
               
            42:   begin
               state <= 43;
               wraddress <= {4'h7,currentBlock,1'b0};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               result0 <= {second[0][0][21],second[0][0][21:15]} + {8'b1 & {7'b0, second[0][0][14]}};
               result1 <= {second[0][1][21],second[0][1][21:15]} + {8'b1 & {7'b0, second[0][1][14]}};
               result2 <= {second[0][2][21],second[0][2][21:15]} + {8'b1 & {7'b0, second[0][2][14]}};
               result3 <= {second[0][3][21],second[0][3][21:15]} + {8'b1 & {7'b0, second[0][3][14]}};
               result4 <= {{2{second[0][4][21]}},second[0][4][21:16]} + {8'b1 & {7'b0, second[0][4][15]}};
               result5 <= {{2{second[0][5][21]}},second[0][5][21:16]} + {8'b1 & {7'b0, second[0][5][15]}};
               result6 <= {{2{second[0][6][21]}},second[0][6][21:16]} + {8'b1 & {7'b0, second[0][6][15]}};
               result7 <= {second[0][7][21],second[0][7][21:15]} + {8'b1 & {7'b0, second[0][7][14]}};
               end
            43:   begin
               state <= 44;
               wraddress <= {4'h0,currentBlock,1'b1};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               //prevDC <= {result0[7],result0};
               
               result0 <= {second[1][0][21],second[1][0][21:15]} + {8'b1 & {7'b0, second[1][0][14]}};
               result1 <= {{2{second[1][1][21]}},second[1][1][21:16]} + {8'b1 & {7'b0, second[1][1][15]}};
               result2 <= {{2{second[1][2][21]}},second[1][2][21:16]} + {8'b1 & {7'b0, second[1][2][15]}};
               result3 <= {{2{second[1][3][21]}},second[1][3][21:16]} + {8'b1 & {7'b0, second[1][3][15]}};
               result4 <= {{2{second[1][4][21]}},second[1][4][21:16]} + {8'b1 & {7'b0, second[1][4][15]}};
               result5 <= {{2{second[1][5][21]}},second[1][5][21:16]} + {8'b1 & {7'b0, second[1][5][15]}};
               result6 <= {{2{second[1][6][21]}},second[1][6][21:16]} + {8'b1 & {7'b0, second[1][6][15]}};
               result7 <= {second[1][7][21],second[1][7][21:15]} + {8'b1 & {7'b0, second[1][7][14]}};
               end
            44:   begin
               state <= 45;
               wraddress <= {4'h1,currentBlock,1'b1};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               result0 <= {second[2][0][21],second[2][0][21:15]} + {8'b1 & {7'b0, second[2][0][14]}};
               result1 <= {{2{second[2][1][21]}},second[2][1][21:16]} + {8'b1 & {7'b0, second[2][1][15]}};
               result2 <= {{2{second[2][2][21]}},second[2][2][21:16]} + {8'b1 & {7'b0, second[2][2][15]}};
               result3 <= {{2{second[2][3][21]}},second[2][3][21:16]} + {8'b1 & {7'b0, second[2][3][15]}};
               result4 <= {{2{second[2][4][21]}},second[2][4][21:16]} + {8'b1 & {7'b0, second[2][4][15]}};
               result5 <= {{2{second[2][5][21]}},second[2][5][21:16]} + {8'b1 & {7'b0, second[2][5][15]}};
               result6 <= {{2{second[2][6][21]}},second[2][6][21:16]} + {8'b1 & {7'b0, second[2][6][15]}};
               result7 <= {second[2][7][21],second[2][7][21:15]} + {8'b1 & {7'b0, second[2][7][14]}};
               end
            45:   begin
               state <= 46;
               wraddress <= {4'h2,currentBlock,1'b1};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               result0 <= {second[3][0][21],second[3][0][21:15]} + {8'b1 & {7'b0, second[3][0][14]}};
               result1 <= {{2{second[3][1][21]}},second[3][1][21:16]} + {8'b1 & {7'b0, second[3][1][15]}};
               result2 <= {{2{second[3][2][21]}},second[3][2][21:16]} + {8'b1 & {7'b0, second[3][2][15]}};
               result3 <= {{2{second[3][3][21]}},second[3][3][21:16]} + {8'b1 & {7'b0, second[3][3][15]}};
               result4 <= {{2{second[3][4][21]}},second[3][4][21:16]} + {8'b1 & {7'b0, second[3][4][15]}};
               result5 <= {{2{second[3][5][21]}},second[3][5][21:16]} + {8'b1 & {7'b0, second[3][5][15]}};
               result6 <= {{2{second[3][6][21]}},second[3][6][21:16]} + {8'b1 & {7'b0, second[3][6][15]}};
               result7 <= {second[3][7][21],second[3][7][21:15]} + {8'b1 & {7'b0, second[3][7][14]}};
               end
            46:   begin
               state <= 47;
               wraddress <= {4'h3,currentBlock,1'b1};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               result0 <= {second[4][0][21],second[4][0][21:15]} + {8'b1 & {7'b0, second[4][0][14]}};
               result1 <= {{2{second[4][1][21]}},second[4][1][21:16]} + {8'b1 & {7'b0, second[4][1][15]}};
               result2 <= {{2{second[4][2][21]}},second[4][2][21:16]} + {8'b1 & {7'b0, second[4][2][15]}};
               result3 <= {{2{second[4][3][21]}},second[4][3][21:16]} + {8'b1 & {7'b0, second[4][3][15]}};
               result4 <= {{2{second[4][4][21]}},second[4][4][21:16]} + {8'b1 & {7'b0, second[4][4][15]}};
               result5 <= {{2{second[4][5][21]}},second[4][5][21:16]} + {8'b1 & {7'b0, second[4][5][15]}};
               result6 <= {{2{second[4][6][21]}},second[4][6][21:16]} + {8'b1 & {7'b0, second[4][6][15]}};
               result7 <= {second[4][7][21],second[4][7][21:15]} + {8'b1 & {7'b0, second[4][7][14]}};
               end
            47:   begin
               state <= 48;
               wraddress <= {4'h4,currentBlock,1'b1};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               result0 <= {second[5][0][21],second[5][0][21:15]} + {8'b1 & {7'b0, second[5][0][14]}};
               result1 <= {{2{second[5][1][21]}},second[5][1][21:16]} + {8'b1 & {7'b0, second[5][1][15]}};
               result2 <= {{2{second[5][2][21]}},second[5][2][21:16]} + {8'b1 & {7'b0, second[5][2][15]}};
               result3 <= {{2{second[5][3][21]}},second[5][3][21:16]} + {8'b1 & {7'b0, second[5][3][15]}};
               result4 <= {{2{second[5][4][21]}},second[5][4][21:16]} + {8'b1 & {7'b0, second[5][4][15]}};
               result5 <= {{2{second[5][5][21]}},second[5][5][21:16]} + {8'b1 & {7'b0, second[5][5][15]}};
               result6 <= {{2{second[5][6][21]}},second[5][6][21:16]} + {8'b1 & {7'b0, second[5][6][15]}};
               result7 <= {second[5][7][21],second[5][7][21:15]} + {8'b1 & {7'b0, second[5][7][14]}};
               end
            48:   begin
               state <= 49;
               wraddress <= {4'h5,currentBlock,1'b1};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               result0 <= {{2{second[6][0][21]}},second[6][0][21:16]} + {8'b1 & {7'b0, second[6][0][15]}};
               result1 <= {{2{second[6][1][21]}},second[6][1][21:16]} + {8'b1 & {7'b0, second[6][1][15]}};
               result2 <= {{2{second[6][2][21]}},second[6][2][21:16]} + {8'b1 & {7'b0, second[6][2][15]}};
               result3 <= {{2{second[6][3][21]}},second[6][3][21:16]} + {8'b1 & {7'b0, second[6][3][15]}};
               result4 <= {{2{second[6][4][21]}},second[6][4][21:16]} + {8'b1 & {7'b0, second[6][4][15]}};
               result5 <= {{2{second[6][5][21]}},second[6][5][21:16]} + {8'b1 & {7'b0, second[6][5][15]}};
               result6 <= {{2{second[6][6][21]}},second[6][6][21:16]} + {8'b1 & {7'b0, second[6][6][15]}};
               result7 <= {second[6][7][21],second[6][7][21:15]} + {8'b1 & {7'b0, second[6][7][14]}};
               end
            49:   begin
               state <= 50;
               wraddress <= {4'h6,currentBlock,1'b1};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               
               result0 <= {second[7][0][21],second[7][0][21:15]} + {8'b1 & {7'b0, second[7][0][14]}};
               result1 <= {{2{second[7][1][21]}},second[7][1][21:16]} + {8'b1 & {7'b0, second[7][1][15]}};
               result2 <= {{2{second[7][2][21]}},second[7][2][21:16]} + {8'b1 & {7'b0, second[7][2][15]}};
               result3 <= {{2{second[7][3][21]}},second[7][3][21:16]} + {8'b1 & {7'b0, second[7][3][15]}};
               result4 <= {{2{second[7][4][21]}},second[7][4][21:16]} + {8'b1 & {7'b0, second[7][4][15]}};
               result5 <= {{2{second[7][5][21]}},second[7][5][21:16]} + {8'b1 & {7'b0, second[7][5][15]}};
               result7 <= {second[7][6][21],second[7][6][21:15]} + {8'b1 & {7'b0, second[7][6][14]}};
               result7 <= second[7][7][21:14] + {8'b1 & {7'b0, second[7][7][13]}};
               end
            50: begin
               state <= 51;
               wraddress <= {4'h7,currentBlock,1'b1};
               data <= {result7, result6, result5, result4, result3, result2, result1, result0};
               end
            default: begin 
               state <= 63;
               
               wren <= 0;
               rden <= 0;
               
               in0 <= 0; in1 <= 0; in2 <= 0; in3 <= 0;
               in4 <= 0; in5 <= 0; in6 <= 0; in7 <= 0;
               
               result0 <= 0; result1 <= 0; result2 <= 0; result3 <= 0; 
               result4 <= 0; result5 <= 0; result6 <= 0; result7 <= 0;
               end
         endcase
      end
   end

endmodule 