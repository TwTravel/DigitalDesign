module bitstream_buffer(
   input clk, // control clock
   input enable, // enable signal
   input [3:0] size, // bit-length of VL code
   input [7:0] code, // variable-length code: translated pixel value
   input end_of_frame, // says whether the memory module has sent every pixel in the frame (image)
   output [15:0] next_transmit, // next in line to transmit
   output new_stream, // flag indicating a new set of 16 bits to transmit
   output done // output when the bitstream buffer has finished
   );
   
   wire [5:0] huffman_length; // length of the huffman code
   wire [15:0] huffman; // huffman code itself
   
   reg rEnable; // registered enable signal
   reg [6:0] zero_run; // count of preceding zeros
   
   reg [6:0] pixel_count; // count of how many pixels have been analyzed (more realistically, it's cycle counter, but it's used for the same purpose)
   
   reg [7:0] prev_code; // previous VL code (not the huffman)
   reg [3:0] prev_size; // length of previous VL code
   
   reg [63:0] new_chunk; // new chunk to be written to the bitstream
   // NOTE: LENGTH OF CHUNK IS ACTUALLY ONE LESS THAN THE LENGTH
   reg [4:0] length_of_new_chunk; // max bit to take from the new chunk
   
   // FIGURE OUT MAXIMUM SIZE OF BIT HISTORY: bit history may not need 64 bits, but kept it that high to be safe
   reg [63:0] bit_history; // misnomer, more of a bit buffer, which is getting ready to send to the transmitter
   reg [5:0] valid_bits_in_history; // number of valid bits (ones that represent actual values) in the bit_history register
   
   assign next_transmit = {bit_history[55:48],bit_history[63:56]}; // next 16-bit item to transmit over ethernet. LSByte is transmitted first
   assign new_stream = (valid_bits_in_history > 15 && enable) || // only transmit new stream if valid bits exceeds 16 so we have no extra bits
                       (valid_bits_in_history && end_of_frame && pixel_count == 7'd67); // unless its at the end of the image, then transmit everything
   assign done = (pixel_count == 7'd67); // done after analyzing 64 pixels
   
   // translates the run/size information into huffman coefficients
   translate_to_huffman t2huff(
      .clk(clk), // control clock
      .enable(enable & pixel_count != 66), // enable the module
      .dc(pixel_count == 0), // if we are analyzing the DC coefficient (happens when pixel_count is zero)
      .size(size), // input: size of the code
      .zero_run(zero_run), // input: zero run
      .huffman_length(huffman_length), // output: length of the huffman code
      .huffman(huffman) // output: huffman code
      );

   always @(posedge clk) begin
      rEnable <= enable; // latch the enable. Consider: need to have a second register to avoid metastable state from non-synchronous button input(?)
      if (~rEnable) begin // the one cycle latch ensures that the zero_run is correct
         zero_run <= 0;
         pixel_count <= 0;
         
         new_chunk <= 0;
         length_of_new_chunk <= 0;
         
         // if valid_bits_in_history is defined and is not zero, then we need to keep this value between blocks inside an image
         if (valid_bits_in_history) begin
            bit_history <= bit_history;
            valid_bits_in_history <= valid_bits_in_history;
         end
         else begin
            bit_history <= 0; // otherwise reset to zero
            valid_bits_in_history <= 0; // otherwise reset to zero
         end
         
         prev_size <= 1; // not set to zero so it will not be counted as part of the zero run
         prev_code <= 0;
      end
      
      // essentially a done state, which transmits bits if appropriate
      else if (pixel_count == 7'd67) begin
         if (valid_bits_in_history >= 16) begin // if more than 16 bits to transmit, transmit them
            valid_bits_in_history <= valid_bits_in_history - 6'd16;
            bit_history <= bit_history << 16;
         end
         else if (end_of_frame) begin // flush bits at end of frame
            valid_bits_in_history <= 0;
            bit_history <= 0;
         end
      end
      
      // append EOB after last pixel has been analyzed
      else if (pixel_count == 7'd66) begin
         pixel_count <= 7'd67;
         valid_bits_in_history <= valid_bits_in_history + 4;
         case (valid_bits_in_history) 
            0: begin
               bit_history[63:0] <= {4'b1010,60'b0};
               end
            1: begin
               bit_history[62:0] <= {4'b1010,59'b0};
               end
            2: begin
               bit_history[61:0] <= {4'b1010,58'b0};
               end
            3: begin
               bit_history[60:0] <= {4'b1010,57'b0};
               end
            4: begin
               bit_history[59:0] <= {4'b1010,56'b0};
               end
            5: begin
               bit_history[58:0] <= {4'b1010,55'b0};
               end
            6: begin
               bit_history[57:0] <= {4'b1010,54'b0};
               end
            7: begin
               bit_history[56:0] <= {4'b1010,53'b0};
               end
            8: begin
               bit_history[55:0] <= {4'b1010,52'b0};
               end
            9: begin
               bit_history[54:0] <= {4'b1010,51'b0};
               end
            10: begin
               bit_history[53:0] <= {4'b1010,50'b0};
               end
            11: begin
               bit_history[52:0] <= {4'b1010,49'b0};
               end
            12: begin
               bit_history[51:0] <= {4'b1010,48'b0};
               end
            13: begin
               bit_history[50:0] <= {4'b1010,47'b0};
               end
            14: begin
               bit_history[49:0] <= {4'b1010,46'b0};
               end
            15: begin
               bit_history[48:0] <= {4'b1010,45'b0};
               end
            16: begin
               bit_history <= {4'b1010,60'b0};
               end
            17: begin
               bit_history <= {bit_history[47],4'b1010,59'b0};
               end
            18: begin
               bit_history <= {bit_history[47:46],4'b1010,58'b0};
               end
            19: begin
               bit_history <= {bit_history[47:45],4'b1010,57'b0};
               end
            20: begin
               bit_history <= {bit_history[47:44],4'b1010,56'b0};
               end
            21: begin
               bit_history <= {bit_history[47:43],4'b1010,55'b0};
               end
            22: begin
               bit_history <= {bit_history[47:42],4'b1010,54'b0};
               end
            23: begin
               bit_history <= {bit_history[47:41],4'b1010,53'b0};
               end
            24: begin
               bit_history <= {bit_history[47:40],4'b1010,52'b0};
               end
            25: begin
               bit_history <= {bit_history[47:39],4'b1010,51'b0};
               end
            26: begin
               bit_history <= {bit_history[47:38],4'b1010,50'b0};
               end
            27: begin
               bit_history <= {bit_history[47:37],4'b1010,49'b0};
               end
            28: begin
               bit_history <= {bit_history[47:36],4'b1010,48'b0};
               end
            29: begin
               bit_history <= {bit_history[47:35],4'b1010,47'b0};
               end
            30: begin
               bit_history <= {bit_history[47:34],4'b1010,46'b0};
               end
            31: begin
               bit_history <= {bit_history[47:33],4'b1010,45'b0};
               end
            32: begin
               bit_history <= {bit_history[47:32],4'b1010,44'b0};
               end
            33: begin
               bit_history <= {bit_history[47:31],4'b1010,43'b0};
               end
            34: begin
               bit_history <= {bit_history[47:30],4'b1010,42'b0};
               end
            35: begin
               bit_history <= {bit_history[47:29],4'b1010,41'b0};
               end
            36: begin
               bit_history <= {bit_history[47:28],4'b1010,40'b0};
               end
            37: begin
               bit_history <= {bit_history[47:27],4'b1010,39'b0};
               end
            38: begin
               bit_history <= {bit_history[47:26],4'b1010,38'b0};
               end
            39: begin
               bit_history <= {bit_history[47:25],4'b1010,37'b0};
               end
            40: begin
               bit_history <= {bit_history[47:24],4'b1010,36'b0};
               end
            41: begin
               bit_history <= {bit_history[47:23],4'b1010,35'b0};
               end
            42: begin
               bit_history <= {bit_history[47:22],4'b1010,34'b0};
               end
            43: begin
               bit_history <= {bit_history[47:21],4'b1010,33'b0};
               end
            44: begin
               bit_history <= {bit_history[47:20],4'b1010,32'b0};
               end
            45: begin
               bit_history <= {bit_history[47:19],4'b1010,31'b0};
               end
            46: begin
               bit_history <= {bit_history[47:18],4'b1010,30'b0};
               end
            47: begin
               bit_history <= {bit_history[47:17],4'b1010,29'b0};
               end
            48: begin
               bit_history <= {bit_history[47:16],4'b1010,28'b0};
               end
            49: begin
               bit_history <= {bit_history[47:15],4'b1010,27'b0};
               end
            50: begin
               bit_history <= {bit_history[47:14],4'b1010,26'b0};
               end
            51: begin
               bit_history <= {bit_history[47:13],4'b1010,25'b0};
               end
            52: begin
               bit_history <= {bit_history[47:12],4'b1010,24'b0};
               end
            53: begin
               bit_history <= {bit_history[47:11],4'b1010,23'b0};
               end
            54: begin
               bit_history <= {bit_history[47:10],4'b1010,22'b0};
               end
            55: begin
               bit_history <= {bit_history[47:9],4'b1010,21'b0};
               end
            56: begin
               bit_history <= {bit_history[47:8],4'b1010,20'b0};
               end
            57: begin
               bit_history <= {bit_history[47:7],4'b1010,19'b0};
               end
            58: begin
               bit_history <= {bit_history[47:6],4'b1010,18'b0};
               end
            59: begin
               bit_history <= {bit_history[47:5],4'b1010,17'b0};
               end
            60: begin
               bit_history <= {bit_history[47:4],4'b1010,16'b0};
               end
            61: begin
               bit_history <= {bit_history[47:3],4'b1010,15'b0};
               end
            62: begin
               bit_history <= {bit_history[47:2],4'b1010,14'b0};
               end
            63: begin
               bit_history <= {bit_history[47:1],4'b1010,13'b0};
               end
         endcase
         if (valid_bits_in_history >= 16) begin
            // minus 16 from the transmit, plus 4 from the EOB
            valid_bits_in_history <= valid_bits_in_history - 6'd12; 
         end
      end
      
      else begin
         pixel_count <= pixel_count + 1;
         
         prev_size <= size;
         prev_code <= code;
         
         // length of new chunk to add to bit buffer
         length_of_new_chunk <= huffman_length + prev_size;
         
         // handles the zero_run length to send to the huffman translator
         case (size)
            0: begin
               if (pixel_count) begin
                  // adds two for ease of processing for >15 run lengths
                  if (zero_run[3:0] == 15) begin
                     zero_run <= zero_run + 4'd2;
                  end
                  // add one to the zero_run
                  else begin
                     zero_run <= zero_run + 4'b1;
                  end
               end
               end
            default: begin
               // when you see a non-zero value, 
               zero_run <= 0;
               end
         endcase
         
         // handles the output of the huffman translator 
         // updates a new chunk variable that will be added to our bitstream
         case (prev_size)
            0: begin
               // add huffman code regardless of whether DC is zero or not
               if (pixel_count == 1) begin // DC pixel
                  case(huffman_length)
                     01: begin
                        new_chunk <= {huffman[1:0],62'b0};
                        end
                     02: begin
                        new_chunk <= {huffman[2:0],61'b0};
                        end
                     03: begin
                        new_chunk <= {huffman[3:0],60'b0};
                        end
                     04: begin
                        new_chunk <= {huffman[4:0],59'b0};
                        end
                     05: begin
                        new_chunk <= {huffman[5:0],58'b0};
                        end
                     06: begin
                        new_chunk <= {huffman[6:0],57'b0};
                        end
                     07: begin
                        new_chunk <= {huffman[7:0],56'b0};
                        end
                     08: begin
                        new_chunk <= {huffman[8:0],55'b0};
                        end
                     09: begin
                        new_chunk <= {huffman[9:0],54'b0};
                        end
                     10: begin
                        new_chunk <= {huffman[10:0],53'b0};
                        end
                     11: begin
                        new_chunk <= {huffman[11:0],52'b0};
                        end
                     12: begin
                        new_chunk <= {huffman[12:0],51'b0};
                        end
                     13: begin
                        new_chunk <= {huffman[13:0],50'b0};
                        end
                     14: begin
                        new_chunk <= {huffman[14:0],49'b0};
                        end
                     15: begin
                        new_chunk <= {huffman[15:0],48'b0};
                        end
                  endcase
               end
               // if a non-zero code is coming up and we had a zero run, append the appropriate codes
               else if (size) begin
                  if (zero_run[6:4] == 0) begin
                     new_chunk <= 0;
                  end
                  else if (zero_run[6:4] == 1) begin
                     new_chunk <= {11'b11111111001,53'b0};
                  end
                  else if (zero_run[6:4] == 2) begin
                     new_chunk <= {22'b1111111100111111111001,42'b0};
                  end
                  else if (zero_run[6:4] == 3) begin
                     new_chunk <= {33'b111111110011111111100111111111001,31'b0};
                  end
                  else if (zero_run[6:4] == 4) begin
                     new_chunk <= {44'b11111111001111111110011111111100111111111001,20'b0};
                  end
               end
               else begin
                  new_chunk <= 0;
               end
               end
            1: begin
               case(huffman_length)
                  00: begin
                     new_chunk <= {huffman[0],prev_code[0],62'b0};
                     end
                  01: begin
                     new_chunk <= {huffman[1:0],prev_code[0],61'b0};
                     end
                  02: begin
                     new_chunk <= {huffman[2:0],prev_code[0],60'b0};
                     end
                  03: begin
                     new_chunk <= {huffman[3:0],prev_code[0],59'b0};
                     end
                  04: begin
                     new_chunk <= {huffman[4:0],prev_code[0],58'b0};
                     end
                  05: begin
                     new_chunk <= {huffman[5:0],prev_code[0],57'b0};
                     end
                  06: begin
                     new_chunk <= {huffman[6:0],prev_code[0],56'b0};
                     end
                  07: begin
                     new_chunk <= {huffman[7:0],prev_code[0],55'b0};
                     end
                  08: begin
                     new_chunk <= {huffman[8:0],prev_code[0],54'b0};
                     end
                  09: begin
                     new_chunk <= {huffman[9:0],prev_code[0],53'b0};
                     end
                  10: begin
                     new_chunk <= {huffman[10:0],prev_code[0],52'b0};
                     end
                  11: begin
                     new_chunk <= {huffman[11:0],prev_code[0],51'b0};
                     end
                  12: begin
                     new_chunk <= {huffman[12:0],prev_code[0],50'b0};
                     end
                  13: begin
                     new_chunk <= {huffman[13:0],prev_code[0],49'b0};
                     end
                  14: begin
                     new_chunk <= {huffman[14:0],prev_code[0],48'b0};
                     end
                  15: begin
                     new_chunk <= {huffman[15:0],prev_code[0],47'b0};
                     end
               endcase
               end
            2: begin
               case(huffman_length)
                  00: begin
                     new_chunk <= {huffman[0],prev_code[1:0],61'b0};
                     end
                  01: begin
                     new_chunk <= {huffman[1:0],prev_code[1:0],60'b0};
                     end
                  02: begin
                     new_chunk <= {huffman[2:0],prev_code[1:0],59'b0};
                     end
                  03: begin
                     new_chunk <= {huffman[3:0],prev_code[1:0],58'b0};
                     end
                  04: begin
                     new_chunk <= {huffman[4:0],prev_code[1:0],57'b0};
                     end
                  05: begin
                     new_chunk <= {huffman[5:0],prev_code[1:0],56'b0};
                     end
                  06: begin
                     new_chunk <= {huffman[6:0],prev_code[1:0],55'b0};
                     end
                  07: begin
                     new_chunk <= {huffman[7:0],prev_code[1:0],54'b0};
                     end
                  08: begin
                     new_chunk <= {huffman[8:0],prev_code[1:0],53'b0};
                     end
                  09: begin
                     new_chunk <= {huffman[9:0],prev_code[1:0],52'b0};
                     end
                  10: begin
                     new_chunk <= {huffman[10:0],prev_code[1:0],51'b0};
                     end
                  11: begin
                     new_chunk <= {huffman[11:0],prev_code[1:0],50'b0};
                     end
                  12: begin
                     new_chunk <= {huffman[12:0],prev_code[1:0],49'b0};
                     end
                  13: begin
                     new_chunk <= {huffman[13:0],prev_code[1:0],48'b0};
                     end
                  14: begin
                     new_chunk <= {huffman[14:0],prev_code[1:0],47'b0};
                     end
                  15: begin
                     new_chunk <= {huffman[15:0],prev_code[1:0],46'b0};
                     end
               endcase
               end
            3: begin
               case(huffman_length)
                  00: begin
                     new_chunk <= {huffman[0],prev_code[2:0],60'b0};
                     end
                  01: begin
                     new_chunk <= {huffman[1:0],prev_code[2:0],59'b0};
                     end
                  02: begin
                     new_chunk <= {huffman[2:0],prev_code[2:0],58'b0};
                     end
                  03: begin
                     new_chunk <= {huffman[3:0],prev_code[2:0],57'b0};
                     end
                  04: begin
                     new_chunk <= {huffman[4:0],prev_code[2:0],56'b0};
                     end
                  05: begin
                     new_chunk <= {huffman[5:0],prev_code[2:0],55'b0};
                     end
                  06: begin
                     new_chunk <= {huffman[6:0],prev_code[2:0],54'b0};
                     end
                  07: begin
                     new_chunk <= {huffman[7:0],prev_code[2:0],53'b0};
                     end
                  08: begin
                     new_chunk <= {huffman[8:0],prev_code[2:0],52'b0};
                     end
                  09: begin
                     new_chunk <= {huffman[9:0],prev_code[2:0],51'b0};
                     end
                  10: begin
                     new_chunk <= {huffman[10:0],prev_code[2:0],50'b0};
                     end
                  11: begin
                     new_chunk <= {huffman[11:0],prev_code[2:0],49'b0};
                     end
                  12: begin
                     new_chunk <= {huffman[12:0],prev_code[2:0],48'b0};
                     end
                  13: begin
                     new_chunk <= {huffman[13:0],prev_code[2:0],47'b0};
                     end
                  14: begin
                     new_chunk <= {huffman[14:0],prev_code[2:0],46'b0};
                     end
                  15: begin
                     new_chunk <= {huffman[15:0],prev_code[2:0],45'b0};
                     end
               endcase
               end
            4: begin
               case(huffman_length)
                  00: begin
                     new_chunk <= {huffman[0],prev_code[3:0],59'b0};
                     end
                  01: begin
                     new_chunk <= {huffman[1:0],prev_code[3:0],58'b0};
                     end
                  02: begin
                     new_chunk <= {huffman[2:0],prev_code[3:0],57'b0};
                     end
                  03: begin
                     new_chunk <= {huffman[3:0],prev_code[3:0],56'b0};
                     end
                  04: begin
                     new_chunk <= {huffman[4:0],prev_code[3:0],55'b0};
                     end
                  05: begin
                     new_chunk <= {huffman[5:0],prev_code[3:0],54'b0};
                     end
                  06: begin
                     new_chunk <= {huffman[6:0],prev_code[3:0],53'b0};
                     end
                  07: begin
                     new_chunk <= {huffman[7:0],prev_code[3:0],52'b0};
                     end
                  08: begin
                     new_chunk <= {huffman[8:0],prev_code[3:0],51'b0};
                     end
                  09: begin
                     new_chunk <= {huffman[9:0],prev_code[3:0],50'b0};
                     end
                  10: begin
                     new_chunk <= {huffman[10:0],prev_code[3:0],49'b0};
                     end
                  11: begin
                     new_chunk <= {huffman[11:0],prev_code[3:0],48'b0};
                     end
                  12: begin
                     new_chunk <= {huffman[12:0],prev_code[3:0],47'b0};
                     end
                  13: begin
                     new_chunk <= {huffman[13:0],prev_code[3:0],46'b0};
                     end
                  14: begin
                     new_chunk <= {huffman[14:0],prev_code[3:0],45'b0};
                     end
                  15: begin
                     new_chunk <= {huffman[15:0],prev_code[3:0],44'b0};
                     end
               endcase
               end
            5: begin
               case(huffman_length)
                  00: begin
                     new_chunk <= {huffman[0],prev_code[4:0],58'b0};
                     end
                  01: begin
                     new_chunk <= {huffman[1:0],prev_code[4:0],57'b0};
                     end
                  02: begin
                     new_chunk <= {huffman[2:0],prev_code[4:0],56'b0};
                     end
                  03: begin
                     new_chunk <= {huffman[3:0],prev_code[4:0],55'b0};
                     end
                  04: begin
                     new_chunk <= {huffman[4:0],prev_code[4:0],54'b0};
                     end
                  05: begin
                     new_chunk <= {huffman[5:0],prev_code[4:0],53'b0};
                     end
                  06: begin
                     new_chunk <= {huffman[6:0],prev_code[4:0],52'b0};
                     end
                  07: begin
                     new_chunk <= {huffman[7:0],prev_code[4:0],51'b0};
                     end
                  08: begin
                     new_chunk <= {huffman[8:0],prev_code[4:0],50'b0};
                     end
                  09: begin
                     new_chunk <= {huffman[9:0],prev_code[4:0],49'b0};
                     end
                  10: begin
                     new_chunk <= {huffman[10:0],prev_code[4:0],48'b0};
                     end
                  11: begin
                     new_chunk <= {huffman[11:0],prev_code[4:0],47'b0};
                     end
                  12: begin
                     new_chunk <= {huffman[12:0],prev_code[4:0],46'b0};
                     end
                  13: begin
                     new_chunk <= {huffman[13:0],prev_code[4:0],45'b0};
                     end
                  14: begin
                     new_chunk <= {huffman[14:0],prev_code[4:0],44'b0};
                     end
                  15: begin
                     new_chunk <= {huffman[15:0],prev_code[4:0],43'b0};
                     end
               endcase
               end
            6: begin
               case(huffman_length)
                  00: begin
                     new_chunk <= {huffman[0],prev_code[5:0],57'b0};
                     end
                  01: begin
                     new_chunk <= {huffman[1:0],prev_code[5:0],56'b0};
                     end
                  02: begin
                     new_chunk <= {huffman[2:0],prev_code[5:0],55'b0};
                     end
                  03: begin
                     new_chunk <= {huffman[3:0],prev_code[5:0],54'b0};
                     end
                  04: begin
                     new_chunk <= {huffman[4:0],prev_code[5:0],53'b0};
                     end
                  05: begin
                     new_chunk <= {huffman[5:0],prev_code[5:0],52'b0};
                     end
                  06: begin
                     new_chunk <= {huffman[6:0],prev_code[5:0],51'b0};
                     end
                  07: begin
                     new_chunk <= {huffman[7:0],prev_code[5:0],50'b0};
                     end
                  08: begin
                     new_chunk <= {huffman[8:0],prev_code[5:0],49'b0};
                     end
                  09: begin
                     new_chunk <= {huffman[9:0],prev_code[5:0],48'b0};
                     end
                  10: begin
                     new_chunk <= {huffman[10:0],prev_code[5:0],47'b0};
                     end
                  11: begin
                     new_chunk <= {huffman[11:0],prev_code[5:0],46'b0};
                     end
                  12: begin
                     new_chunk <= {huffman[12:0],prev_code[5:0],45'b0};
                     end
                  13: begin
                     new_chunk <= {huffman[13:0],prev_code[5:0],44'b0};
                     end
                  14: begin
                     new_chunk <= {huffman[14:0],prev_code[5:0],43'b0};
                     end
                  15: begin
                     new_chunk <= {huffman[15:0],prev_code[5:0],42'b0};
                     end
               endcase
               end
            7: begin
               case(huffman_length)
                  00: begin
                     new_chunk <= {huffman[0],prev_code[6:0],56'b0};
                     end
                  01: begin
                     new_chunk <= {huffman[1:0],prev_code[6:0],55'b0};
                     end
                  02: begin
                     new_chunk <= {huffman[2:0],prev_code[6:0],54'b0};
                     end
                  03: begin
                     new_chunk <= {huffman[3:0],prev_code[6:0],53'b0};
                     end
                  04: begin
                     new_chunk <= {huffman[4:0],prev_code[6:0],52'b0};
                     end
                  05: begin
                     new_chunk <= {huffman[5:0],prev_code[6:0],51'b0};
                     end
                  06: begin
                     new_chunk <= {huffman[6:0],prev_code[6:0],50'b0};
                     end
                  07: begin
                     new_chunk <= {huffman[7:0],prev_code[6:0],49'b0};
                     end
                  08: begin
                     new_chunk <= {huffman[8:0],prev_code[6:0],48'b0};
                     end
                  09: begin
                     new_chunk <= {huffman[9:0],prev_code[6:0],47'b0};
                     end
                  10: begin
                     new_chunk <= {huffman[10:0],prev_code[6:0],46'b0};
                     end
                  11: begin
                     new_chunk <= {huffman[11:0],prev_code[6:0],45'b0};
                     end
                  12: begin
                     new_chunk <= {huffman[12:0],prev_code[6:0],44'b0};
                     end
                  13: begin
                     new_chunk <= {huffman[13:0],prev_code[6:0],43'b0};
                     end
                  14: begin
                     new_chunk <= {huffman[14:0],prev_code[6:0],42'b0};
                     end
                  15: begin
                     new_chunk <= {huffman[15:0],prev_code[6:0],41'b0};
                     end
               endcase
               end
            8: begin
               case(huffman_length)
                  00: begin
                     new_chunk <= {huffman[0],prev_code[7:0],55'b0};
                     end
                  01: begin
                     new_chunk <= {huffman[1:0],prev_code[7:0],54'b0};
                     end
                  02: begin
                     new_chunk <= {huffman[2:0],prev_code[7:0],53'b0};
                     end
                  03: begin
                     new_chunk <= {huffman[3:0],prev_code[7:0],52'b0};
                     end
                  04: begin
                     new_chunk <= {huffman[4:0],prev_code[7:0],51'b0};
                     end
                  05: begin
                     new_chunk <= {huffman[5:0],prev_code[7:0],50'b0};
                     end
                  06: begin
                     new_chunk <= {huffman[6:0],prev_code[7:0],49'b0};
                     end
                  07: begin
                     new_chunk <= {huffman[7:0],prev_code[7:0],48'b0};
                     end
                  08: begin
                     new_chunk <= {huffman[8:0],prev_code[7:0],47'b0};
                     end
                  09: begin
                     new_chunk <= {huffman[9:0],prev_code[7:0],46'b0};
                     end
                  10: begin
                     new_chunk <= {huffman[10:0],prev_code[7:0],45'b0};
                     end
                  11: begin
                     new_chunk <= {huffman[11:0],prev_code[7:0],44'b0};
                     end
                  12: begin
                     new_chunk <= {huffman[12:0],prev_code[7:0],43'b0};
                     end
                  13: begin
                     new_chunk <= {huffman[13:0],prev_code[7:0],42'b0};
                     end
                  14: begin
                     new_chunk <= {huffman[14:0],prev_code[7:0],41'b0};
                     end
                  15: begin
                     new_chunk <= {huffman[15:0],prev_code[7:0],40'b0};
                     end
               endcase
               end
            default: begin
               new_chunk <= 0;
               end
         endcase
         
         // handles the organization of the bit history and transmission
         if (new_chunk || pixel_count == 2) begin // when pixel_count = 2, we are analyzing the DC component
            valid_bits_in_history <= (valid_bits_in_history >= 16) ?
               valid_bits_in_history + length_of_new_chunk - 6'd15 : 
               valid_bits_in_history + length_of_new_chunk + 6'b1;
         
            case (valid_bits_in_history) 
               0: begin
                  bit_history[63:0] <= new_chunk[63:0];
                  end
               1: begin
                  bit_history[62:0] <= new_chunk[63:1];
                  end
               2: begin
                  bit_history[61:0] <= new_chunk[63:2];
                  end
               3: begin
                  bit_history[60:0] <= new_chunk[63:3];
                  end
               4: begin
                  bit_history[59:0] <= new_chunk[63:4];
                  end
               5: begin
                  bit_history[58:0] <= new_chunk[63:5];
                  end
               6: begin
                  bit_history[57:0] <= new_chunk[63:6];
                  end
               7: begin
                  bit_history[56:0] <= new_chunk[63:7];
                  end
               8: begin
                  bit_history[55:0] <= new_chunk[63:8];
                  end
               9: begin
                  bit_history[54:0] <= new_chunk[63:9];
                  end
               10: begin
                  bit_history[53:0] <= new_chunk[63:10];
                  end
               11: begin
                  bit_history[52:0] <= new_chunk[63:11];
                  end
               12: begin
                  bit_history[51:0] <= new_chunk[63:12];
                  end
               13: begin
                  bit_history[50:0] <= new_chunk[63:13];
                  end
               14: begin
                  bit_history[49:0] <= new_chunk[63:14];
                  end
               15: begin
                  bit_history[48:0] <= new_chunk[63:15];
                  end
               16: begin
                  bit_history <= new_chunk;
                  end
               17: begin
                  bit_history <= {bit_history[47:47],new_chunk[63:1]};
                  end
               18: begin
                  bit_history <= {bit_history[47:46],new_chunk[63:2]};
                  end
               19: begin
                  bit_history <= {bit_history[47:45],new_chunk[63:3]};
                  end
               20: begin
                  bit_history <= {bit_history[47:44],new_chunk[63:4]};
                  end
               21: begin
                  bit_history <= {bit_history[47:43],new_chunk[63:5]};
                  end
               22: begin
                  bit_history <= {bit_history[47:42],new_chunk[63:6]};
                  end
               23: begin
                  bit_history <= {bit_history[47:41],new_chunk[63:7]};
                  end
               24: begin
                  bit_history <= {bit_history[47:40],new_chunk[63:8]};
                  end
               25: begin
                  bit_history <= {bit_history[47:39],new_chunk[63:9]};
                  end
               26: begin
                  bit_history <= {bit_history[47:38],new_chunk[63:10]};
                  end
               27: begin
                  bit_history <= {bit_history[47:37],new_chunk[63:11]};
                  end
               28: begin
                  bit_history <= {bit_history[47:36],new_chunk[63:12]};
                  end
               29: begin
                  bit_history <= {bit_history[47:35],new_chunk[63:13]};
                  end
               30: begin
                  bit_history <= {bit_history[47:34],new_chunk[63:14]};
                  end
               31: begin
                  bit_history <= {bit_history[47:33],new_chunk[63:15]};
                  end
               32: begin
                  bit_history <= {bit_history[47:32],new_chunk[63:16]};
                  end
               33: begin
                  bit_history <= {bit_history[47:31],new_chunk[63:17]};
                  end
               34: begin
                  bit_history <= {bit_history[47:30],new_chunk[63:18]};
                  end
               35: begin
                  bit_history <= {bit_history[47:29],new_chunk[63:19]};
                  end
               36: begin
                  bit_history <= {bit_history[47:28],new_chunk[63:20]};
                  end
               37: begin
                  bit_history <= {bit_history[47:27],new_chunk[63:21]};
                  end
               38: begin
                  bit_history <= {bit_history[47:26],new_chunk[63:22]};
                  end
               39: begin
                  bit_history <= {bit_history[47:25],new_chunk[63:23]};
                  end
               40: begin
                  bit_history <= {bit_history[47:24],new_chunk[63:24]};
                  end
               41: begin
                  bit_history <= {bit_history[47:23],new_chunk[63:25]};
                  end
               42: begin
                  bit_history <= {bit_history[47:22],new_chunk[63:26]};
                  end
               43: begin
                  bit_history <= {bit_history[47:21],new_chunk[63:27]};
                  end
               44: begin
                  bit_history <= {bit_history[47:20],new_chunk[63:28]};
                  end
               45: begin
                  bit_history <= {bit_history[47:19],new_chunk[63:29]};
                  end
               46: begin
                  bit_history <= {bit_history[47:18],new_chunk[63:30]};
                  end
               47: begin
                  bit_history <= {bit_history[47:17],new_chunk[63:31]};
                  end
               48: begin
                  bit_history <= {bit_history[47:16],new_chunk[63:32]};
                  end
               49: begin
                  bit_history <= {bit_history[47:15],new_chunk[63:33]};
                  end
               50: begin
                  bit_history <= {bit_history[47:14],new_chunk[63:34]};
                  end
               51: begin
                  bit_history <= {bit_history[47:13],new_chunk[63:35]};
                  end
               52: begin
                  bit_history <= {bit_history[47:12],new_chunk[63:36]};
                  end
               53: begin
                  bit_history <= {bit_history[47:11],new_chunk[63:37]};
                  end
               54: begin
                  bit_history <= {bit_history[47:10],new_chunk[63:38]};
                  end
               55: begin
                  bit_history <= {bit_history[47:9],new_chunk[63:39]};
                  end
               56: begin
                  bit_history <= {bit_history[47:8],new_chunk[63:40]};
                  end
               57: begin
                  bit_history <= {bit_history[47:7],new_chunk[63:41]};
                  end            endcase
         end
         else if (valid_bits_in_history >= 16) begin
            // even if no bits were added, we still have the chance to transmit 16 bits if possible
            valid_bits_in_history <= valid_bits_in_history - 6'd16;
            bit_history <= bit_history << 16;
         end
      end
   end
   
endmodule
   