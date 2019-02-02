module translate_to_huffman(
   input clk, // control clock
   input enable, // enable signal
   input dc, // says whether to use the DC table or the AC table
   input [3:0] size, // the size of the variable length code-word 
   input [6:0] zero_run, // the number of zeros preceding this non-zero value (if non-zero)
   output reg [5:0] huffman_length, // length-1 of the huffman coded word (highest valid bit)
   output reg [15:0] huffman // the huffman code itself
   );
   
   always @(posedge clk) begin
      if (~enable) begin
         huffman_length <= 0;
         huffman <= 0;
      end
      else if (dc) begin // DC has a different table because it doesn't take into account a zero-run
         case (size)
            0: begin
               huffman_length <= 6'd1;
               huffman <= 16'b00;
               end
            1: begin
               huffman_length <= 6'd2;
               huffman <= 16'b010;
               end
            2: begin
               huffman_length <= 6'd2;
               huffman <= 16'b011;
               end
            3: begin
               huffman_length <= 6'd2;
               huffman <= 16'b100;
               end
            4: begin
               huffman_length <= 6'd2;
               huffman <= 16'b101;
               end
            5: begin
               huffman_length <= 6'd2;
               huffman <= 16'b110;
               end
            6: begin
               huffman_length <= 6'd3;
               huffman <= 16'b1110;
               end
            7: begin
               huffman_length <= 6'd4;
               huffman <= 16'b11110;
               end
            8: begin
               huffman_length <= 6'd5;
               huffman <= 16'b111110;
               end
         endcase
      end
      // if a run-length greater than 15 occurred, we need to tack on special bits
      else if (zero_run[6:4] && size == 0) begin
         if (zero_run[6:4] == 1) begin
            huffman_length <= 6'd10;
         end
         else if (zero_run[6:4] == 2) begin
            huffman_length <= 6'd21;
         end
         else if (zero_run[6:4] == 3) begin
            huffman_length <= 6'd32;
         end
         else if (zero_run[6:4] == 4) begin
            huffman_length <= 6'd43;
         end
         huffman <= 16'b0;
      end
      // AC lookup table
      else begin
         // KNOWN BUG: THIS MODULE DOES NOT TAKE INTO ACCOUNT LENGTH 8 VL CODES
            case ({zero_run[3:0], size})
            ({4'd0, 4'h1}): begin
               // THIS IS A POSSIBLE BUG: THE HUFFMAN LENGTH SHOULD BE 0, NOT 1 FOR 0/0 AND 0/1.
                huffman_length <= 6'd1; 
                huffman <= 16'b0;
                end
            ({4'd0, 4'h2}): begin
                huffman_length <= 6'd1;
                huffman <= 16'b1;
                end
            ({4'd0, 4'h3}): begin
                huffman_length <= 6'd2;
                huffman <= 16'b100;
                end
            ({4'd0, 4'h4}): begin
                huffman_length <= 6'd3;
                huffman <= 16'b1011;
                end
            ({4'd0, 4'h5}): begin
                huffman_length <= 6'd4;
                huffman <= 16'b11010;
                end
            ({4'd0, 4'h6}): begin
                huffman_length <= 6'd6;
                huffman <= 16'b1111000;
                end
            ({4'd0, 4'h7}): begin
                huffman_length <= 6'd7;
                huffman <= 16'b11111000;
                end
            ({4'd1, 4'h1}): begin
                huffman_length <= 6'd3;
                huffman <= 16'b1100;
                end
            ({4'd1, 4'h2}): begin
                huffman_length <= 6'd4;
                huffman <= 16'b11011;
                end
            ({4'd1, 4'h3}): begin
                huffman_length <= 6'd6;
                huffman <= 16'b1111001;
                end
            ({4'd1, 4'h4}): begin
                huffman_length <= 6'd8;
                huffman <= 16'b111110110;
                end
            ({4'd1, 4'h5}): begin
                huffman_length <= 6'd10;
                huffman <= 16'b11111110110;
                end
            ({4'd1, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110000100;
                end
            ({4'd1, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110000101;
                end
            ({4'd2, 4'h1}): begin
                huffman_length <= 6'd4;
                huffman <= 16'b11100;
                end
            ({4'd2, 4'h2}): begin
                huffman_length <= 6'd7;
                huffman <= 16'b11111001;
                end
            ({4'd2, 4'h3}): begin
                huffman_length <= 6'd9;
                huffman <= 16'b1111110111;
                end
            ({4'd2, 4'h4}): begin
                huffman_length <= 6'd11;
                huffman <= 16'b111111110100;
                end
            ({4'd2, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110001001;
                end
            ({4'd2, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110001010;
                end
            ({4'd2, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110001011;
                end
            ({4'd3, 4'h1}): begin
                huffman_length <= 6'd5;
                huffman <= 16'b111010;
                end
            ({4'd3, 4'h2}): begin
                huffman_length <= 6'd8;
                huffman <= 16'b111110111;
                end
            ({4'd3, 4'h3}): begin
                huffman_length <= 6'd11;
                huffman <= 16'b111111110101;
                end
            ({4'd3, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110001111;
                end
            ({4'd3, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110010000;
                end
            ({4'd3, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110010001;
                end
            ({4'd3, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110010010;
                end
            ({4'd4, 4'h1}): begin
                huffman_length <= 6'd5;
                huffman <= 16'b111011;
                end
            ({4'd4, 4'h2}): begin
                huffman_length <= 6'd9;
                huffman <= 16'b1111111000;
                end
            ({4'd4, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110010110;
                end
            ({4'd4, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110010111;
                end
            ({4'd4, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110011000;
                end
            ({4'd4, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110011001;
                end
            ({4'd4, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110011010;
                end
            ({4'd5, 4'h1}): begin
                huffman_length <= 6'd6;
                huffman <= 16'b1111010;
                end
            ({4'd5, 4'h2}): begin
                huffman_length <= 6'd10;
                huffman <= 16'b11111110111;
                end
            ({4'd5, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110011110;
                end
            ({4'd5, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110011111;
                end
            ({4'd5, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110100000;
                end
            ({4'd5, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110100001;
                end
            ({4'd5, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110100010;
                end
            ({4'd6, 4'h1}): begin
                huffman_length <= 6'd6;
                huffman <= 16'b1111011;
                end
            ({4'd6, 4'h2}): begin
                huffman_length <= 6'd11;
                huffman <= 16'b111111110110;
                end
            ({4'd6, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110100110;
                end
            ({4'd6, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110100111;
                end
            ({4'd6, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110101000;
                end
            ({4'd6, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110101001;
                end
            ({4'd6, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110101010;
                end
            ({4'd7, 4'h1}): begin
                huffman_length <= 6'd7;
                huffman <= 16'b11111010;
                end
            ({4'd7, 4'h2}): begin
                huffman_length <= 6'd11;
                huffman <= 16'b111111110111;
                end
            ({4'd7, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110101110;
                end
            ({4'd7, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110101111;
                end
            ({4'd7, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110110000;
                end
            ({4'd7, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110110001;
                end
            ({4'd7, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110110010;
                end
            ({4'd8, 4'h1}): begin
                huffman_length <= 6'd8;
                huffman <= 16'b111111000;
                end
            ({4'd8, 4'h2}): begin
                huffman_length <= 6'd14;
                huffman <= 16'b111111111000000;
                end
            ({4'd8, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110110110;
                end
            ({4'd8, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110110111;
                end
            ({4'd8, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110111000;
                end
            ({4'd8, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110111001;
                end
            ({4'd8, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110111010;
                end
            ({4'd9, 4'h1}): begin
                huffman_length <= 6'd8;
                huffman <= 16'b111111001;
                end
            ({4'd9, 4'h2}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110111110;
                end
            ({4'd9, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111110111111;
                end
            ({4'd9, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111000000;
                end
            ({4'd9, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111000001;
                end
            ({4'd9, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111000010;
                end
            ({4'd9, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111000011;
                end
            ({4'd10, 4'h1}): begin
                huffman_length <= 6'd8;
                huffman <= 16'b111111010;
                end
            ({4'd10, 4'h2}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111000111;
                end
            ({4'd10, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111001000;
                end
            ({4'd10, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111001001;
                end
            ({4'd10, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111001010;
                end
            ({4'd10, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111001011;
                end
            ({4'd10, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111001100;
                end
            ({4'd11, 4'h1}): begin
                huffman_length <= 6'd9;
                huffman <= 16'b1111111001;
                end
            ({4'd11, 4'h2}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111010000;
                end
            ({4'd11, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111010001;
                end
            ({4'd11, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111010010;
                end
            ({4'd11, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111010011;
                end
            ({4'd11, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111010100;
                end
            ({4'd11, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111010101;
                end
            ({4'd12, 4'h1}): begin
                huffman_length <= 6'd9;
                huffman <= 16'b1111111010;
                end
            ({4'd12, 4'h2}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111011001;
                end
            ({4'd12, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111011010;
                end
            ({4'd12, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111011011;
                end
            ({4'd12, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111011100;
                end
            ({4'd12, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111011101;
                end
            ({4'd12, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111011110;
                end
            ({4'd13, 4'h1}): begin
                huffman_length <= 6'd10;
                huffman <= 16'b11111111000;
                end
            ({4'd13, 4'h2}): begin
                huffman_length <= 6'd10;
                huffman <= 16'b1111111111100010;
                end
            ({4'd13, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111100011;
                end
            ({4'd13, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111100100;
                end
            ({4'd13, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111100101;
                end
            ({4'd13, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111100110;
                end
            ({4'd13, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111100111;
                end
            ({4'd14, 4'h1}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111101011;
                end
            ({4'd14, 4'h2}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111101100;
                end
            ({4'd14, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111101101;
                end
            ({4'd14, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111101110;
                end
            ({4'd14, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111101111;
                end
            ({4'd14, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111110000;
                end
            ({4'd14, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111110001;
                end
            ({4'd15, 4'h0}): begin
                huffman_length <= 6'd10;
                huffman <= 16'b11111111001;
                end
            ({4'd15, 4'h1}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111110101;
                end
            ({4'd15, 4'h2}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111110110;
                end
            ({4'd15, 4'h3}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111110111;
                end
            ({4'd15, 4'h4}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111111000;
                end
            ({4'd15, 4'h5}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111111001;
                end
            ({4'd15, 4'h6}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111111010;
                end
            ({4'd15, 4'h7}): begin
                huffman_length <= 6'd15;
                huffman <= 16'b1111111111111011;
                end
            default: begin
                huffman_length <= 6'd0;
                huffman <= 16'b0;
               end
         endcase
      end
   end
   
endmodule
   