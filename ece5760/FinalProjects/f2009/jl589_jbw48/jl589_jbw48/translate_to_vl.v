module translate_to_vl(
   input clk, // control clock
   input enable, // enable signal
   input signed [8:0] value, // value to be translated
   output reg [3:0] size, // size of VL code word
   output reg [7:0] code // actual code word
   );
   
   always @(posedge clk) begin
      if (~enable) begin
         size <= 4'b0;
         code <= 8'hFF;
      end
      // simply a lookup table
      else begin
         case (value)
            255:  begin
               size <= 4'd8;
               code <= 8'b11111111;
               end
            254:  begin
               size <= 4'd8;
               code <= 8'b11111110;
               end
            253:  begin
               size <= 4'd8;
               code <= 8'b11111101;
               end
            252:  begin
               size <= 4'd8;
               code <= 8'b11111100;
               end
            251:  begin
               size <= 4'd8;
               code <= 8'b11111011;
               end
            250:  begin
               size <= 4'd8;
               code <= 8'b11111010;
               end
            249:  begin
               size <= 4'd8;
               code <= 8'b11111001;
               end
            248:  begin
               size <= 4'd8;
               code <= 8'b11111000;
               end
            247:  begin
               size <= 4'd8;
               code <= 8'b11110111;
               end
            246:  begin
               size <= 4'd8;
               code <= 8'b11110110;
               end
            245:  begin
               size <= 4'd8;
               code <= 8'b11110101;
               end
            244:  begin
               size <= 4'd8;
               code <= 8'b11110100;
               end
            243:  begin
               size <= 4'd8;
               code <= 8'b11110011;
               end
            242:  begin
               size <= 4'd8;
               code <= 8'b11110010;
               end
            241:  begin
               size <= 4'd8;
               code <= 8'b11110001;
               end
            240:  begin
               size <= 4'd8;
               code <= 8'b11110000;
               end
            239:  begin
               size <= 4'd8;
               code <= 8'b11101111;
               end
            238:  begin
               size <= 4'd8;
               code <= 8'b11101110;
               end
            237:  begin
               size <= 4'd8;
               code <= 8'b11101101;
               end
            236:  begin
               size <= 4'd8;
               code <= 8'b11101100;
               end
            235:  begin
               size <= 4'd8;
               code <= 8'b11101011;
               end
            234:  begin
               size <= 4'd8;
               code <= 8'b11101010;
               end
            233:  begin
               size <= 4'd8;
               code <= 8'b11101001;
               end
            232:  begin
               size <= 4'd8;
               code <= 8'b11101000;
               end
            231:  begin
               size <= 4'd8;
               code <= 8'b11100111;
               end
            230:  begin
               size <= 4'd8;
               code <= 8'b11100110;
               end
            229:  begin
               size <= 4'd8;
               code <= 8'b11100101;
               end
            228:  begin
               size <= 4'd8;
               code <= 8'b11100100;
               end
            227:  begin
               size <= 4'd8;
               code <= 8'b11100011;
               end
            226:  begin
               size <= 4'd8;
               code <= 8'b11100010;
               end
            225:  begin
               size <= 4'd8;
               code <= 8'b11100001;
               end
            224:  begin
               size <= 4'd8;
               code <= 8'b11100000;
               end
            223:  begin
               size <= 4'd8;
               code <= 8'b11011111;
               end
            222:  begin
               size <= 4'd8;
               code <= 8'b11011110;
               end
            221:  begin
               size <= 4'd8;
               code <= 8'b11011101;
               end
            220:  begin
               size <= 4'd8;
               code <= 8'b11011100;
               end
            219:  begin
               size <= 4'd8;
               code <= 8'b11011011;
               end
            218:  begin
               size <= 4'd8;
               code <= 8'b11011010;
               end
            217:  begin
               size <= 4'd8;
               code <= 8'b11011001;
               end
            216:  begin
               size <= 4'd8;
               code <= 8'b11011000;
               end
            215:  begin
               size <= 4'd8;
               code <= 8'b11010111;
               end
            214:  begin
               size <= 4'd8;
               code <= 8'b11010110;
               end
            213:  begin
               size <= 4'd8;
               code <= 8'b11010101;
               end
            212:  begin
               size <= 4'd8;
               code <= 8'b11010100;
               end
            211:  begin
               size <= 4'd8;
               code <= 8'b11010011;
               end
            210:  begin
               size <= 4'd8;
               code <= 8'b11010010;
               end
            209:  begin
               size <= 4'd8;
               code <= 8'b11010001;
               end
            208:  begin
               size <= 4'd8;
               code <= 8'b11010000;
               end
            207:  begin
               size <= 4'd8;
               code <= 8'b11001111;
               end
            206:  begin
               size <= 4'd8;
               code <= 8'b11001110;
               end
            205:  begin
               size <= 4'd8;
               code <= 8'b11001101;
               end
            204:  begin
               size <= 4'd8;
               code <= 8'b11001100;
               end
            203:  begin
               size <= 4'd8;
               code <= 8'b11001011;
               end
            202:  begin
               size <= 4'd8;
               code <= 8'b11001010;
               end
            201:  begin
               size <= 4'd8;
               code <= 8'b11001001;
               end
            200:  begin
               size <= 4'd8;
               code <= 8'b11001000;
               end
            199:  begin
               size <= 4'd8;
               code <= 8'b11000111;
               end
            198:  begin
               size <= 4'd8;
               code <= 8'b11000110;
               end
            197:  begin
               size <= 4'd8;
               code <= 8'b11000101;
               end
            196:  begin
               size <= 4'd8;
               code <= 8'b11000100;
               end
            195:  begin
               size <= 4'd8;
               code <= 8'b11000011;
               end
            194:  begin
               size <= 4'd8;
               code <= 8'b11000010;
               end
            193:  begin
               size <= 4'd8;
               code <= 8'b11000001;
               end
            192:  begin
               size <= 4'd8;
               code <= 8'b11000000;
               end
            191:  begin
               size <= 4'd8;
               code <= 8'b10111111;
               end
            190:  begin
               size <= 4'd8;
               code <= 8'b10111110;
               end
            189:  begin
               size <= 4'd8;
               code <= 8'b10111101;
               end
            188:  begin
               size <= 4'd8;
               code <= 8'b10111100;
               end
            187:  begin
               size <= 4'd8;
               code <= 8'b10111011;
               end
            186:  begin
               size <= 4'd8;
               code <= 8'b10111010;
               end
            185:  begin
               size <= 4'd8;
               code <= 8'b10111001;
               end
            184:  begin
               size <= 4'd8;
               code <= 8'b10111000;
               end
            183:  begin
               size <= 4'd8;
               code <= 8'b10110111;
               end
            182:  begin
               size <= 4'd8;
               code <= 8'b10110110;
               end
            181:  begin
               size <= 4'd8;
               code <= 8'b10110101;
               end
            180:  begin
               size <= 4'd8;
               code <= 8'b10110100;
               end
            179:  begin
               size <= 4'd8;
               code <= 8'b10110011;
               end
            178:  begin
               size <= 4'd8;
               code <= 8'b10110010;
               end
            177:  begin
               size <= 4'd8;
               code <= 8'b10110001;
               end
            176:  begin
               size <= 4'd8;
               code <= 8'b10110000;
               end
            175:  begin
               size <= 4'd8;
               code <= 8'b10101111;
               end
            174:  begin
               size <= 4'd8;
               code <= 8'b10101110;
               end
            173:  begin
               size <= 4'd8;
               code <= 8'b10101101;
               end
            172:  begin
               size <= 4'd8;
               code <= 8'b10101100;
               end
            171:  begin
               size <= 4'd8;
               code <= 8'b10101011;
               end
            170:  begin
               size <= 4'd8;
               code <= 8'b10101010;
               end
            169:  begin
               size <= 4'd8;
               code <= 8'b10101001;
               end
            168:  begin
               size <= 4'd8;
               code <= 8'b10101000;
               end
            167:  begin
               size <= 4'd8;
               code <= 8'b10100111;
               end
            166:  begin
               size <= 4'd8;
               code <= 8'b10100110;
               end
            165:  begin
               size <= 4'd8;
               code <= 8'b10100101;
               end
            164:  begin
               size <= 4'd8;
               code <= 8'b10100100;
               end
            163:  begin
               size <= 4'd8;
               code <= 8'b10100011;
               end
            162:  begin
               size <= 4'd8;
               code <= 8'b10100010;
               end
            161:  begin
               size <= 4'd8;
               code <= 8'b10100001;
               end
            160:  begin
               size <= 4'd8;
               code <= 8'b10100000;
               end
            159:  begin
               size <= 4'd8;
               code <= 8'b10011111;
               end
            158:  begin
               size <= 4'd8;
               code <= 8'b10011110;
               end
            157:  begin
               size <= 4'd8;
               code <= 8'b10011101;
               end
            156:  begin
               size <= 4'd8;
               code <= 8'b10011100;
               end
            155:  begin
               size <= 4'd8;
               code <= 8'b10011011;
               end
            154:  begin
               size <= 4'd8;
               code <= 8'b10011010;
               end
            153:  begin
               size <= 4'd8;
               code <= 8'b10011001;
               end
            152:  begin
               size <= 4'd8;
               code <= 8'b10011000;
               end
            151:  begin
               size <= 4'd8;
               code <= 8'b10010111;
               end
            150:  begin
               size <= 4'd8;
               code <= 8'b10010110;
               end
            149:  begin
               size <= 4'd8;
               code <= 8'b10010101;
               end
            148:  begin
               size <= 4'd8;
               code <= 8'b10010100;
               end
            147:  begin
               size <= 4'd8;
               code <= 8'b10010011;
               end
            146:  begin
               size <= 4'd8;
               code <= 8'b10010010;
               end
            145:  begin
               size <= 4'd8;
               code <= 8'b10010001;
               end
            144:  begin
               size <= 4'd8;
               code <= 8'b10010000;
               end
            143:  begin
               size <= 4'd8;
               code <= 8'b10001111;
               end
            142:  begin
               size <= 4'd8;
               code <= 8'b10001110;
               end
            141:  begin
               size <= 4'd8;
               code <= 8'b10001101;
               end
            140:  begin
               size <= 4'd8;
               code <= 8'b10001100;
               end
            139:  begin
               size <= 4'd8;
               code <= 8'b10001011;
               end
            138:  begin
               size <= 4'd8;
               code <= 8'b10001010;
               end
            137:  begin
               size <= 4'd8;
               code <= 8'b10001001;
               end
            136:  begin
               size <= 4'd8;
               code <= 8'b10001000;
               end
            135:  begin
               size <= 4'd8;
               code <= 8'b10000111;
               end
            134:  begin
               size <= 4'd8;
               code <= 8'b10000110;
               end
            133:  begin
               size <= 4'd8;
               code <= 8'b10000101;
               end
            132:  begin
               size <= 4'd8;
               code <= 8'b10000100;
               end
            131:  begin
               size <= 4'd8;
               code <= 8'b10000011;
               end
            130:  begin
               size <= 4'd8;
               code <= 8'b10000010;
               end
            129:  begin
               size <= 4'd8;
               code <= 8'b10000001;
               end
            128:  begin
               size <= 4'd8;
               code <= 8'b10000000;
               end
            127:  begin
               size <= 4'd7;
               code <= 8'b1111111;
               end
            126:  begin
               size <= 4'd7;
               code <= 8'b1111110;
               end
            125:  begin
               size <= 4'd7;
               code <= 8'b1111101;
               end
            124:  begin
               size <= 4'd7;
               code <= 8'b1111100;
               end
            123:  begin
               size <= 4'd7;
               code <= 8'b1111011;
               end
            122:  begin
               size <= 4'd7;
               code <= 8'b1111010;
               end
            121:  begin
               size <= 4'd7;
               code <= 8'b1111001;
               end
            120:  begin
               size <= 4'd7;
               code <= 8'b1111000;
               end
            119:  begin
               size <= 4'd7;
               code <= 8'b1110111;
               end
            118:  begin
               size <= 4'd7;
               code <= 8'b1110110;
               end
            117:  begin
               size <= 4'd7;
               code <= 8'b1110101;
               end
            116:  begin
               size <= 4'd7;
               code <= 8'b1110100;
               end
            115:  begin
               size <= 4'd7;
               code <= 8'b1110011;
               end
            114:  begin
               size <= 4'd7;
               code <= 8'b1110010;
               end
            113:  begin
               size <= 4'd7;
               code <= 8'b1110001;
               end
            112:  begin
               size <= 4'd7;
               code <= 8'b1110000;
               end
            111:  begin
               size <= 4'd7;
               code <= 8'b1101111;
               end
            110:  begin
               size <= 4'd7;
               code <= 8'b1101110;
               end
            109:  begin
               size <= 4'd7;
               code <= 8'b1101101;
               end
            108:  begin
               size <= 4'd7;
               code <= 8'b1101100;
               end
            107:  begin
               size <= 4'd7;
               code <= 8'b1101011;
               end
            106:  begin
               size <= 4'd7;
               code <= 8'b1101010;
               end
            105:  begin
               size <= 4'd7;
               code <= 8'b1101001;
               end
            104:  begin
               size <= 4'd7;
               code <= 8'b1101000;
               end
            103:  begin
               size <= 4'd7;
               code <= 8'b1100111;
               end
            102:  begin
               size <= 4'd7;
               code <= 8'b1100110;
               end
            101:  begin
               size <= 4'd7;
               code <= 8'b1100101;
               end
            100:  begin
               size <= 4'd7;
               code <= 8'b1100100;
               end
            99:   begin
               size <= 4'd7;
               code <= 8'b1100011;
               end
            98:   begin
               size <= 4'd7;
               code <= 8'b1100010;
               end
            97:   begin
               size <= 4'd7;
               code <= 8'b1100001;
               end
            96:   begin
               size <= 4'd7;
               code <= 8'b1100000;
               end
            95:   begin
               size <= 4'd7;
               code <= 8'b1011111;
               end
            94:   begin
               size <= 4'd7;
               code <= 8'b1011110;
               end
            93:   begin
               size <= 4'd7;
               code <= 8'b1011101;
               end
            92:   begin
               size <= 4'd7;
               code <= 8'b1011100;
               end
            91:   begin
               size <= 4'd7;
               code <= 8'b1011011;
               end
            90:   begin
               size <= 4'd7;
               code <= 8'b1011010;
               end
            89:   begin
               size <= 4'd7;
               code <= 8'b1011001;
               end
            88:   begin
               size <= 4'd7;
               code <= 8'b1011000;
               end
            87:   begin
               size <= 4'd7;
               code <= 8'b1010111;
               end
            86:   begin
               size <= 4'd7;
               code <= 8'b1010110;
               end
            85:   begin
               size <= 4'd7;
               code <= 8'b1010101;
               end
            84:   begin
               size <= 4'd7;
               code <= 8'b1010100;
               end
            83:   begin
               size <= 4'd7;
               code <= 8'b1010011;
               end
            82:   begin
               size <= 4'd7;
               code <= 8'b1010010;
               end
            81:   begin
               size <= 4'd7;
               code <= 8'b1010001;
               end
            80:   begin
               size <= 4'd7;
               code <= 8'b1010000;
               end
            79:   begin
               size <= 4'd7;
               code <= 8'b1001111;
               end
            78:   begin
               size <= 4'd7;
               code <= 8'b1001110;
               end
            77:   begin
               size <= 4'd7;
               code <= 8'b1001101;
               end
            76:   begin
               size <= 4'd7;
               code <= 8'b1001100;
               end
            75:   begin
               size <= 4'd7;
               code <= 8'b1001011;
               end
            74:   begin
               size <= 4'd7;
               code <= 8'b1001010;
               end
            73:   begin
               size <= 4'd7;
               code <= 8'b1001001;
               end
            72:   begin
               size <= 4'd7;
               code <= 8'b1001000;
               end
            71:   begin
               size <= 4'd7;
               code <= 8'b1000111;
               end
            70:   begin
               size <= 4'd7;
               code <= 8'b1000110;
               end
            69:   begin
               size <= 4'd7;
               code <= 8'b1000101;
               end
            68:   begin
               size <= 4'd7;
               code <= 8'b1000100;
               end
            67:   begin
               size <= 4'd7;
               code <= 8'b1000011;
               end
            66:   begin
               size <= 4'd7;
               code <= 8'b1000010;
               end
            65:   begin
               size <= 4'd7;
               code <= 8'b1000001;
               end
            64:   begin
               size <= 4'd7;
               code <= 8'b1000000;
               end
            63:   begin
               size <= 4'd6;
               code <= 8'b111111;
               end
            62:   begin
               size <= 4'd6;
               code <= 8'b111110;
               end
            61:   begin
               size <= 4'd6;
               code <= 8'b111101;
               end
            60:   begin
               size <= 4'd6;
               code <= 8'b111100;
               end
            59:   begin
               size <= 4'd6;
               code <= 8'b111011;
               end
            58:   begin
               size <= 4'd6;
               code <= 8'b111010;
               end
            57:   begin
               size <= 4'd6;
               code <= 8'b111001;
               end
            56:   begin
               size <= 4'd6;
               code <= 8'b111000;
               end
            55:   begin
               size <= 4'd6;
               code <= 8'b110111;
               end
            54:   begin
               size <= 4'd6;
               code <= 8'b110110;
               end
            53:   begin
               size <= 4'd6;
               code <= 8'b110101;
               end
            52:   begin
               size <= 4'd6;
               code <= 8'b110100;
               end
            51:   begin
               size <= 4'd6;
               code <= 8'b110011;
               end
            50:   begin
               size <= 4'd6;
               code <= 8'b110010;
               end
            49:   begin
               size <= 4'd6;
               code <= 8'b110001;
               end
            48:   begin
               size <= 4'd6;
               code <= 8'b110000;
               end
            47:   begin
               size <= 4'd6;
               code <= 8'b101111;
               end
            46:   begin
               size <= 4'd6;
               code <= 8'b101110;
               end
            45:   begin
               size <= 4'd6;
               code <= 8'b101101;
               end
            44:   begin
               size <= 4'd6;
               code <= 8'b101100;
               end
            43:   begin
               size <= 4'd6;
               code <= 8'b101011;
               end
            42:   begin
               size <= 4'd6;
               code <= 8'b101010;
               end
            41:   begin
               size <= 4'd6;
               code <= 8'b101001;
               end
            40:   begin
               size <= 4'd6;
               code <= 8'b101000;
               end
            39:   begin
               size <= 4'd6;
               code <= 8'b100111;
               end
            38:   begin
               size <= 4'd6;
               code <= 8'b100110;
               end
            37:   begin
               size <= 4'd6;
               code <= 8'b100101;
               end
            36:   begin
               size <= 4'd6;
               code <= 8'b100100;
               end
            35:   begin
               size <= 4'd6;
               code <= 8'b100011;
               end
            34:   begin
               size <= 4'd6;
               code <= 8'b100010;
               end
            33:   begin
               size <= 4'd6;
               code <= 8'b100001;
               end
            32:   begin
               size <= 4'd6;
               code <= 8'b100000;
               end
            31:   begin
               size <= 4'd5;
               code <= 8'b11111;
               end
            30:   begin
               size <= 4'd5;
               code <= 8'b11110;
               end
            29:   begin
               size <= 4'd5;
               code <= 8'b11101;
               end
            28:   begin
               size <= 4'd5;
               code <= 8'b11100;
               end
            27:   begin
               size <= 4'd5;
               code <= 8'b11011;
               end
            26:   begin
               size <= 4'd5;
               code <= 8'b11010;
               end
            25:   begin
               size <= 4'd5;
               code <= 8'b11001;
               end
            24:   begin
               size <= 4'd5;
               code <= 8'b11000;
               end
            23:   begin
               size <= 4'd5;
               code <= 8'b10111;
               end
            22:   begin
               size <= 4'd5;
               code <= 8'b10110;
               end
            21:   begin
               size <= 4'd5;
               code <= 8'b10101;
               end
            20:   begin
               size <= 4'd5;
               code <= 8'b10100;
               end
            19:   begin
               size <= 4'd5;
               code <= 8'b10011;
               end
            18:   begin
               size <= 4'd5;
               code <= 8'b10010;
               end
            17:   begin
               size <= 4'd5;
               code <= 8'b10001;
               end
            16:   begin
               size <= 4'd5;
               code <= 8'b10000;
               end
            15:   begin
               size <= 4'd4;
               code <= 8'b1111;
               end
            14:   begin
               size <= 4'd4;
               code <= 8'b1110;
               end
            13:   begin
               size <= 4'd4;
               code <= 8'b1101;
               end
            12:   begin
               size <= 4'd4;
               code <= 8'b1100;
               end
            11:   begin
               size <= 4'd4;
               code <= 8'b1011;
               end
            10:   begin
               size <= 4'd4;
               code <= 8'b1010;
               end
            9: begin
               size <= 4'd4;
               code <= 8'b1001;
               end
            8: begin
               size <= 4'd4;
               code <= 8'b1000;
               end
            7: begin
               size <= 4'd3;
               code <= 8'b111;
               end
            6: begin
               size <= 4'd3;
               code <= 8'b110;
               end
            5: begin
               size <= 4'd3;
               code <= 8'b101;
               end
            4: begin
               size <= 4'd3;
               code <= 8'b100;
               end
            3: begin
               size <= 4'd2;
               code <= 8'b11;
               end
            2: begin
               size <= 4'd2;
               code <= 8'b10;
               end
            1: begin
               size <= 4'd1;
               code <= 8'b1;
               end
            0:  begin
                size <= 4'b0;
                code <= 8'b0;
                end
            -1:   begin
               size <= 4'd1;
               code <= 8'b0;
               end
            -2:   begin
               size <= 4'd2;
               code <= 8'b01;
               end
            -3:   begin
               size <= 4'd2;
               code <= 8'b00;
               end
            -4:   begin
               size <= 4'd3;
               code <= 8'b011;
               end
            -5:   begin
               size <= 4'd3;
               code <= 8'b010;
               end
            -6:   begin
               size <= 4'd3;
               code <= 8'b001;
               end
            -7:   begin
               size <= 4'd3;
               code <= 8'b000;
               end
            -8:   begin
               size <= 4'd4;
               code <= 8'b0111;
               end
            -9:   begin
               size <= 4'd4;
               code <= 8'b0110;
               end
            -10:  begin
               size <= 4'd4;
               code <= 8'b0101;
               end
            -11:  begin
               size <= 4'd4;
               code <= 8'b0100;
               end
            -12:  begin
               size <= 4'd4;
               code <= 8'b0011;
               end
            -13:  begin
               size <= 4'd4;
               code <= 8'b0010;
               end
            -14:  begin
               size <= 4'd4;
               code <= 8'b0001;
               end
            -15:  begin
               size <= 4'd4;
               code <= 8'b0000;
               end
            -16:  begin
               size <= 4'd5;
               code <= 8'b01111;
               end
            -17:  begin
               size <= 4'd5;
               code <= 8'b01110;
               end
            -18:  begin
               size <= 4'd5;
               code <= 8'b01101;
               end
            -19:  begin
               size <= 4'd5;
               code <= 8'b01100;
               end
            -20:  begin
               size <= 4'd5;
               code <= 8'b01011;
               end
            -21:  begin
               size <= 4'd5;
               code <= 8'b01010;
               end
            -22:  begin
               size <= 4'd5;
               code <= 8'b01001;
               end
            -23:  begin
               size <= 4'd5;
               code <= 8'b01000;
               end
            -24:  begin
               size <= 4'd5;
               code <= 8'b00111;
               end
            -25:  begin
               size <= 4'd5;
               code <= 8'b00110;
               end
            -26:  begin
               size <= 4'd5;
               code <= 8'b00101;
               end
            -27:  begin
               size <= 4'd5;
               code <= 8'b00100;
               end
            -28:  begin
               size <= 4'd5;
               code <= 8'b00011;
               end
            -29:  begin
               size <= 4'd5;
               code <= 8'b00010;
               end
            -30:  begin
               size <= 4'd5;
               code <= 8'b00001;
               end
            -31:  begin
               size <= 4'd5;
               code <= 8'b00000;
               end
            -32:  begin
               size <= 4'd6;
               code <= 8'b011111;
               end
            -33:  begin
               size <= 4'd6;
               code <= 8'b011110;
               end
            -34:  begin
               size <= 4'd6;
               code <= 8'b011101;
               end
            -35:  begin
               size <= 4'd6;
               code <= 8'b011100;
               end
            -36:  begin
               size <= 4'd6;
               code <= 8'b011011;
               end
            -37:  begin
               size <= 4'd6;
               code <= 8'b011010;
               end
            -38:  begin
               size <= 4'd6;
               code <= 8'b011001;
               end
            -39:  begin
               size <= 4'd6;
               code <= 8'b011000;
               end
            -40:  begin
               size <= 4'd6;
               code <= 8'b010111;
               end
            -41:  begin
               size <= 4'd6;
               code <= 8'b010110;
               end
            -42:  begin
               size <= 4'd6;
               code <= 8'b010101;
               end
            -43:  begin
               size <= 4'd6;
               code <= 8'b010100;
               end
            -44:  begin
               size <= 4'd6;
               code <= 8'b010011;
               end
            -45:  begin
               size <= 4'd6;
               code <= 8'b010010;
               end
            -46:  begin
               size <= 4'd6;
               code <= 8'b010001;
               end
            -47:  begin
               size <= 4'd6;
               code <= 8'b010000;
               end
            -48:  begin
               size <= 4'd6;
               code <= 8'b001111;
               end
            -49:  begin
               size <= 4'd6;
               code <= 8'b001110;
               end
            -50:  begin
               size <= 4'd6;
               code <= 8'b001101;
               end
            -51:  begin
               size <= 4'd6;
               code <= 8'b001100;
               end
            -52:  begin
               size <= 4'd6;
               code <= 8'b001011;
               end
            -53:  begin
               size <= 4'd6;
               code <= 8'b001010;
               end
            -54:  begin
               size <= 4'd6;
               code <= 8'b001001;
               end
            -55:  begin
               size <= 4'd6;
               code <= 8'b001000;
               end
            -56:  begin
               size <= 4'd6;
               code <= 8'b000111;
               end
            -57:  begin
               size <= 4'd6;
               code <= 8'b000110;
               end
            -58:  begin
               size <= 4'd6;
               code <= 8'b000101;
               end
            -59:  begin
               size <= 4'd6;
               code <= 8'b000100;
               end
            -60:  begin
               size <= 4'd6;
               code <= 8'b000011;
               end
            -61:  begin
               size <= 4'd6;
               code <= 8'b000010;
               end
            -62:  begin
               size <= 4'd6;
               code <= 8'b000001;
               end
            -63:  begin
               size <= 4'd6;
               code <= 8'b000000;
               end
            -64:  begin
               size <= 4'd7;
               code <= 8'b0111111;
               end
            -65:  begin
               size <= 4'd7;
               code <= 8'b0111110;
               end
            -66:  begin
               size <= 4'd7;
               code <= 8'b0111101;
               end
            -67:  begin
               size <= 4'd7;
               code <= 8'b0111100;
               end
            -68:  begin
               size <= 4'd7;
               code <= 8'b0111011;
               end
            -69:  begin
               size <= 4'd7;
               code <= 8'b0111010;
               end
            -70:  begin
               size <= 4'd7;
               code <= 8'b0111001;
               end
            -71:  begin
               size <= 4'd7;
               code <= 8'b0111000;
               end
            -72:  begin
               size <= 4'd7;
               code <= 8'b0110111;
               end
            -73:  begin
               size <= 4'd7;
               code <= 8'b0110110;
               end
            -74:  begin
               size <= 4'd7;
               code <= 8'b0110101;
               end
            -75:  begin
               size <= 4'd7;
               code <= 8'b0110100;
               end
            -76:  begin
               size <= 4'd7;
               code <= 8'b0110011;
               end
            -77:  begin
               size <= 4'd7;
               code <= 8'b0110010;
               end
            -78:  begin
               size <= 4'd7;
               code <= 8'b0110001;
               end
            -79:  begin
               size <= 4'd7;
               code <= 8'b0110000;
               end
            -80:  begin
               size <= 4'd7;
               code <= 8'b0101111;
               end
            -81:  begin
               size <= 4'd7;
               code <= 8'b0101110;
               end
            -82:  begin
               size <= 4'd7;
               code <= 8'b0101101;
               end
            -83:  begin
               size <= 4'd7;
               code <= 8'b0101100;
               end
            -84:  begin
               size <= 4'd7;
               code <= 8'b0101011;
               end
            -85:  begin
               size <= 4'd7;
               code <= 8'b0101010;
               end
            -86:  begin
               size <= 4'd7;
               code <= 8'b0101001;
               end
            -87:  begin
               size <= 4'd7;
               code <= 8'b0101000;
               end
            -88:  begin
               size <= 4'd7;
               code <= 8'b0100111;
               end
            -89:  begin
               size <= 4'd7;
               code <= 8'b0100110;
               end
            -90:  begin
               size <= 4'd7;
               code <= 8'b0100101;
               end
            -91:  begin
               size <= 4'd7;
               code <= 8'b0100100;
               end
            -92:  begin
               size <= 4'd7;
               code <= 8'b0100011;
               end
            -93:  begin
               size <= 4'd7;
               code <= 8'b0100010;
               end
            -94:  begin
               size <= 4'd7;
               code <= 8'b0100001;
               end
            -95:  begin
               size <= 4'd7;
               code <= 8'b0100000;
               end
            -96:  begin
               size <= 4'd7;
               code <= 8'b0011111;
               end
            -97:  begin
               size <= 4'd7;
               code <= 8'b0011110;
               end
            -98:  begin
               size <= 4'd7;
               code <= 8'b0011101;
               end
            -99:  begin
               size <= 4'd7;
               code <= 8'b0011100;
               end
            -100: begin
               size <= 4'd7;
               code <= 8'b0011011;
               end
            -101: begin
               size <= 4'd7;
               code <= 8'b0011010;
               end
            -102: begin
               size <= 4'd7;
               code <= 8'b0011001;
               end
            -103: begin
               size <= 4'd7;
               code <= 8'b0011000;
               end
            -104: begin
               size <= 4'd7;
               code <= 8'b0010111;
               end
            -105: begin
               size <= 4'd7;
               code <= 8'b0010110;
               end
            -106: begin
               size <= 4'd7;
               code <= 8'b0010101;
               end
            -107: begin
               size <= 4'd7;
               code <= 8'b0010100;
               end
            -108: begin
               size <= 4'd7;
               code <= 8'b0010011;
               end
            -109: begin
               size <= 4'd7;
               code <= 8'b0010010;
               end
            -110: begin
               size <= 4'd7;
               code <= 8'b0010001;
               end
            -111: begin
               size <= 4'd7;
               code <= 8'b0010000;
               end
            -112: begin
               size <= 4'd7;
               code <= 8'b0001111;
               end
            -113: begin
               size <= 4'd7;
               code <= 8'b0001110;
               end
            -114: begin
               size <= 4'd7;
               code <= 8'b0001101;
               end
            -115: begin
               size <= 4'd7;
               code <= 8'b0001100;
               end
            -116: begin
               size <= 4'd7;
               code <= 8'b0001011;
               end
            -117: begin
               size <= 4'd7;
               code <= 8'b0001010;
               end
            -118: begin
               size <= 4'd7;
               code <= 8'b0001001;
               end
            -119: begin
               size <= 4'd7;
               code <= 8'b0001000;
               end
            -120: begin
               size <= 4'd7;
               code <= 8'b0000111;
               end
            -121: begin
               size <= 4'd7;
               code <= 8'b0000110;
               end
            -122: begin
               size <= 4'd7;
               code <= 8'b0000101;
               end
            -123: begin
               size <= 4'd7;
               code <= 8'b0000100;
               end
            -124: begin
               size <= 4'd7;
               code <= 8'b0000011;
               end
            -125: begin
               size <= 4'd7;
               code <= 8'b0000010;
               end
            -126: begin
               size <= 4'd7;
               code <= 8'b0000001;
               end
            -127: begin
               size <= 4'd7;
               code <= 8'b0000000;
               end
            -128: begin
               size <= 4'd8;
               code <= 8'b01111111;
               end
            -129: begin
               size <= 4'd8;
               code <= 8'b01111110;
               end
            -130: begin
               size <= 4'd8;
               code <= 8'b01111101;
               end
            -131: begin
               size <= 4'd8;
               code <= 8'b01111100;
               end
            -132: begin
               size <= 4'd8;
               code <= 8'b01111011;
               end
            -133: begin
               size <= 4'd8;
               code <= 8'b01111010;
               end
            -134: begin
               size <= 4'd8;
               code <= 8'b01111001;
               end
            -135: begin
               size <= 4'd8;
               code <= 8'b01111000;
               end
            -136: begin
               size <= 4'd8;
               code <= 8'b01110111;
               end
            -137: begin
               size <= 4'd8;
               code <= 8'b01110110;
               end
            -138: begin
               size <= 4'd8;
               code <= 8'b01110101;
               end
            -139: begin
               size <= 4'd8;
               code <= 8'b01110100;
               end
            -140: begin
               size <= 4'd8;
               code <= 8'b01110011;
               end
            -141: begin
               size <= 4'd8;
               code <= 8'b01110010;
               end
            -142: begin
               size <= 4'd8;
               code <= 8'b01110001;
               end
            -143: begin
               size <= 4'd8;
               code <= 8'b01110000;
               end
            -144: begin
               size <= 4'd8;
               code <= 8'b01101111;
               end
            -145: begin
               size <= 4'd8;
               code <= 8'b01101110;
               end
            -146: begin
               size <= 4'd8;
               code <= 8'b01101101;
               end
            -147: begin
               size <= 4'd8;
               code <= 8'b01101100;
               end
            -148: begin
               size <= 4'd8;
               code <= 8'b01101011;
               end
            -149: begin
               size <= 4'd8;
               code <= 8'b01101010;
               end
            -150: begin
               size <= 4'd8;
               code <= 8'b01101001;
               end
            -151: begin
               size <= 4'd8;
               code <= 8'b01101000;
               end
            -152: begin
               size <= 4'd8;
               code <= 8'b01100111;
               end
            -153: begin
               size <= 4'd8;
               code <= 8'b01100110;
               end
            -154: begin
               size <= 4'd8;
               code <= 8'b01100101;
               end
            -155: begin
               size <= 4'd8;
               code <= 8'b01100100;
               end
            -156: begin
               size <= 4'd8;
               code <= 8'b01100011;
               end
            -157: begin
               size <= 4'd8;
               code <= 8'b01100010;
               end
            -158: begin
               size <= 4'd8;
               code <= 8'b01100001;
               end
            -159: begin
               size <= 4'd8;
               code <= 8'b01100000;
               end
            -160: begin
               size <= 4'd8;
               code <= 8'b01011111;
               end
            -161: begin
               size <= 4'd8;
               code <= 8'b01011110;
               end
            -162: begin
               size <= 4'd8;
               code <= 8'b01011101;
               end
            -163: begin
               size <= 4'd8;
               code <= 8'b01011100;
               end
            -164: begin
               size <= 4'd8;
               code <= 8'b01011011;
               end
            -165: begin
               size <= 4'd8;
               code <= 8'b01011010;
               end
            -166: begin
               size <= 4'd8;
               code <= 8'b01011001;
               end
            -167: begin
               size <= 4'd8;
               code <= 8'b01011000;
               end
            -168: begin
               size <= 4'd8;
               code <= 8'b01010111;
               end
            -169: begin
               size <= 4'd8;
               code <= 8'b01010110;
               end
            -170: begin
               size <= 4'd8;
               code <= 8'b01010101;
               end
            -171: begin
               size <= 4'd8;
               code <= 8'b01010100;
               end
            -172: begin
               size <= 4'd8;
               code <= 8'b01010011;
               end
            -173: begin
               size <= 4'd8;
               code <= 8'b01010010;
               end
            -174: begin
               size <= 4'd8;
               code <= 8'b01010001;
               end
            -175: begin
               size <= 4'd8;
               code <= 8'b01010000;
               end
            -176: begin
               size <= 4'd8;
               code <= 8'b01001111;
               end
            -177: begin
               size <= 4'd8;
               code <= 8'b01001110;
               end
            -178: begin
               size <= 4'd8;
               code <= 8'b01001101;
               end
            -179: begin
               size <= 4'd8;
               code <= 8'b01001100;
               end
            -180: begin
               size <= 4'd8;
               code <= 8'b01001011;
               end
            -181: begin
               size <= 4'd8;
               code <= 8'b01001010;
               end
            -182: begin
               size <= 4'd8;
               code <= 8'b01001001;
               end
            -183: begin
               size <= 4'd8;
               code <= 8'b01001000;
               end
            -184: begin
               size <= 4'd8;
               code <= 8'b01000111;
               end
            -185: begin
               size <= 4'd8;
               code <= 8'b01000110;
               end
            -186: begin
               size <= 4'd8;
               code <= 8'b01000101;
               end
            -187: begin
               size <= 4'd8;
               code <= 8'b01000100;
               end
            -188: begin
               size <= 4'd8;
               code <= 8'b01000011;
               end
            -189: begin
               size <= 4'd8;
               code <= 8'b01000010;
               end
            -190: begin
               size <= 4'd8;
               code <= 8'b01000001;
               end
            -191: begin
               size <= 4'd8;
               code <= 8'b01000000;
               end
            -192: begin
               size <= 4'd8;
               code <= 8'b00111111;
               end
            -193: begin
               size <= 4'd8;
               code <= 8'b00111110;
               end
            -194: begin
               size <= 4'd8;
               code <= 8'b00111101;
               end
            -195: begin
               size <= 4'd8;
               code <= 8'b00111100;
               end
            -196: begin
               size <= 4'd8;
               code <= 8'b00111011;
               end
            -197: begin
               size <= 4'd8;
               code <= 8'b00111010;
               end
            -198: begin
               size <= 4'd8;
               code <= 8'b00111001;
               end
            -199: begin
               size <= 4'd8;
               code <= 8'b00111000;
               end
            -200: begin
               size <= 4'd8;
               code <= 8'b00110111;
               end
            -201: begin
               size <= 4'd8;
               code <= 8'b00110110;
               end
            -202: begin
               size <= 4'd8;
               code <= 8'b00110101;
               end
            -203: begin
               size <= 4'd8;
               code <= 8'b00110100;
               end
            -204: begin
               size <= 4'd8;
               code <= 8'b00110011;
               end
            -205: begin
               size <= 4'd8;
               code <= 8'b00110010;
               end
            -206: begin
               size <= 4'd8;
               code <= 8'b00110001;
               end
            -207: begin
               size <= 4'd8;
               code <= 8'b00110000;
               end
            -208: begin
               size <= 4'd8;
               code <= 8'b00101111;
               end
            -209: begin
               size <= 4'd8;
               code <= 8'b00101110;
               end
            -210: begin
               size <= 4'd8;
               code <= 8'b00101101;
               end
            -211: begin
               size <= 4'd8;
               code <= 8'b00101100;
               end
            -212: begin
               size <= 4'd8;
               code <= 8'b00101011;
               end
            -213: begin
               size <= 4'd8;
               code <= 8'b00101010;
               end
            -214: begin
               size <= 4'd8;
               code <= 8'b00101001;
               end
            -215: begin
               size <= 4'd8;
               code <= 8'b00101000;
               end
            -216: begin
               size <= 4'd8;
               code <= 8'b00100111;
               end
            -217: begin
               size <= 4'd8;
               code <= 8'b00100110;
               end
            -218: begin
               size <= 4'd8;
               code <= 8'b00100101;
               end
            -219: begin
               size <= 4'd8;
               code <= 8'b00100100;
               end
            -220: begin
               size <= 4'd8;
               code <= 8'b00100011;
               end
            -221: begin
               size <= 4'd8;
               code <= 8'b00100010;
               end
            -222: begin
               size <= 4'd8;
               code <= 8'b00100001;
               end
            -223: begin
               size <= 4'd8;
               code <= 8'b00100000;
               end
            -224: begin
               size <= 4'd8;
               code <= 8'b00011111;
               end
            -225: begin
               size <= 4'd8;
               code <= 8'b00011110;
               end
            -226: begin
               size <= 4'd8;
               code <= 8'b00011101;
               end
            -227: begin
               size <= 4'd8;
               code <= 8'b00011100;
               end
            -228: begin
               size <= 4'd8;
               code <= 8'b00011011;
               end
            -229: begin
               size <= 4'd8;
               code <= 8'b00011010;
               end
            -230: begin
               size <= 4'd8;
               code <= 8'b00011001;
               end
            -231: begin
               size <= 4'd8;
               code <= 8'b00011000;
               end
            -232: begin
               size <= 4'd8;
               code <= 8'b00010111;
               end
            -233: begin
               size <= 4'd8;
               code <= 8'b00010110;
               end
            -234: begin
               size <= 4'd8;
               code <= 8'b00010101;
               end
            -235: begin
               size <= 4'd8;
               code <= 8'b00010100;
               end
            -236: begin
               size <= 4'd8;
               code <= 8'b00010011;
               end
            -237: begin
               size <= 4'd8;
               code <= 8'b00010010;
               end
            -238: begin
               size <= 4'd8;
               code <= 8'b00010001;
               end
            -239: begin
               size <= 4'd8;
               code <= 8'b00010000;
               end
            -240: begin
               size <= 4'd8;
               code <= 8'b00001111;
               end
            -241: begin
               size <= 4'd8;
               code <= 8'b00001110;
               end
            -242: begin
               size <= 4'd8;
               code <= 8'b00001101;
               end
            -243: begin
               size <= 4'd8;
               code <= 8'b00001100;
               end
            -244: begin
               size <= 4'd8;
               code <= 8'b00001011;
               end
            -245: begin
               size <= 4'd8;
               code <= 8'b00001010;
               end
            -246: begin
               size <= 4'd8;
               code <= 8'b00001001;
               end
            -247: begin
               size <= 4'd8;
               code <= 8'b00001000;
               end
            -248: begin
               size <= 4'd8;
               code <= 8'b00000111;
               end
            -249: begin
               size <= 4'd8;
               code <= 8'b00000110;
               end
            -250: begin
               size <= 4'd8;
               code <= 8'b00000101;
               end
            -251: begin
               size <= 4'd8;
               code <= 8'b00000100;
               end
            -252: begin
               size <= 4'd8;
               code <= 8'b00000011;
               end
            -253: begin
               size <= 4'd8;
               code <= 8'b00000010;
               end
            -254: begin
               size <= 4'd8;
               code <= 8'b00000001;
               end
            -255: begin
               size <= 4'd8;
               code <= 8'b00000000;
               end
                
                
            /*-1:  begin
                size <= 4'd1;
                code <= 8'b0;
                end
            -2:      begin
                size <= 4'd2;
                code <= 8'b01;
                end
            -3:      begin
                size <= 4'd2;
                code <= 8'b00;
                end
            -4:      begin
                size <= 4'd3;
                code <= 8'b011;
                end
            -5:      begin
                size <= 4'd3;
                code <= 8'b010;
                end
            -6:      begin
                size <= 4'd3;
                code <= 8'b001;
                end
            -7:      begin
                size <= 4'd3;
                code <= 8'b000;
                end
            -8:      begin
                size <= 4'd4;
                code <= 8'b0111;
                end
            -9:      begin
                size <= 4'd4;
                code <= 8'b0110;
                end
            -10:  begin
                size <= 4'd4;
                code <= 8'b0101;
                end
            -11:  begin
                size <= 4'd4;
                code <= 8'b0100;
                end
            -12:  begin
                size <= 4'd4;
                code <= 8'b0011;
                end
            -13:  begin
                size <= 4'd4;
                code <= 8'b0010;
                end
            -14:  begin
                size <= 4'd4;
                code <= 8'b0001;
                end
            -15:  begin
                size <= 4'd4;
                code <= 8'b0000;
                end
            -16:  begin
                size <= 4'd5;
                code <= 8'b01111;
                end
            -17:  begin
                size <= 4'd5;
                code <= 8'b01110;
                end
            -18:  begin
                size <= 4'd5;
                code <= 8'b01101;
                end
            -19:  begin
                size <= 4'd5;
                code <= 8'b01100;
                end
            -20:  begin
                size <= 4'd5;
                code <= 8'b01011;
                end
            -21:  begin
                size <= 4'd5;
                code <= 8'b01010;
                end
            -22:  begin
                size <= 4'd5;
                code <= 8'b01001;
                end
            -23:  begin
                size <= 4'd5;
                code <= 8'b01000;
                end
            -24:  begin
                size <= 4'd5;
                code <= 8'b00111;
                end
            -25:  begin
                size <= 4'd5;
                code <= 8'b00110;
                end
            -26:  begin
                size <= 4'd5;
                code <= 8'b00101;
                end
            -27:  begin
                size <= 4'd5;
                code <= 8'b00100;
                end
            -28:  begin
                size <= 4'd5;
                code <= 8'b00011;
                end
            -29:  begin
                size <= 4'd5;
                code <= 8'b00010;
                end
            -30:  begin
                size <= 4'd5;
                code <= 8'b00001;
                end
            -31:  begin
                size <= 4'd5;
                code <= 8'b00000;
                end
            -32:  begin
                size <= 4'd6;
                code <= 8'b011111;
                end
            -33:  begin
                size <= 4'd6;
                code <= 8'b011110;
                end
            -34:  begin
                size <= 4'd6;
                code <= 8'b011101;
                end
            -35:  begin
                size <= 4'd6;
                code <= 8'b011100;
                end
            -36:  begin
                size <= 4'd6;
                code <= 8'b011011;
                end
            -37:  begin
                size <= 4'd6;
                code <= 8'b011010;
                end
            -38:  begin
                size <= 4'd6;
                code <= 8'b011001;
                end
            -39:  begin
                size <= 4'd6;
                code <= 8'b011000;
                end
            -40:  begin
                size <= 4'd6;
                code <= 8'b010111;
                end
            -41:  begin
                size <= 4'd6;
                code <= 8'b010110;
                end
            -42:  begin
                size <= 4'd6;
                code <= 8'b010101;
                end
            -43:  begin
                size <= 4'd6;
                code <= 8'b010100;
                end
            -44:  begin
                size <= 4'd6;
                code <= 8'b010011;
                end
            -45:  begin
                size <= 4'd6;
                code <= 8'b010010;
                end
            -46:  begin
                size <= 4'd6;
                code <= 8'b010001;
                end
            -47:  begin
                size <= 4'd6;
                code <= 8'b010000;
                end
            -48:  begin
                size <= 4'd6;
                code <= 8'b001111;
                end
            -49:  begin
                size <= 4'd6;
                code <= 8'b001110;
                end
            -50:  begin
                size <= 4'd6;
                code <= 8'b001101;
                end
            -51:  begin
                size <= 4'd6;
                code <= 8'b001100;
                end
            -52:  begin
                size <= 4'd6;
                code <= 8'b001011;
                end
            -53:  begin
                size <= 4'd6;
                code <= 8'b001010;
                end
            -54:  begin
                size <= 4'd6;
                code <= 8'b001001;
                end
            -55:  begin
                size <= 4'd6;
                code <= 8'b001000;
                end
            -56:  begin
                size <= 4'd6;
                code <= 8'b000111;
                end
            -57:  begin
                size <= 4'd6;
                code <= 8'b000110;
                end
            -58:  begin
                size <= 4'd6;
                code <= 8'b000101;
                end
            -59:  begin
                size <= 4'd6;
                code <= 8'b000100;
                end
            -60:  begin
                size <= 4'd6;
                code <= 8'b000011;
                end
            -61:  begin
                size <= 4'd6;
                code <= 8'b000010;
                end
            -62:  begin
                size <= 4'd6;
                code <= 8'b000001;
                end
            -63:  begin
                size <= 4'd6;
                code <= 8'b000000;
                end
            -64:  begin
                size <= 4'd7;
                code <= 8'b0111111;
                end
            -65:  begin
                size <= 4'd7;
                code <= 8'b0111110;
                end
            -66:  begin
                size <= 4'd7;
                code <= 8'b0111101;
                end
            -67:  begin
                size <= 4'd7;
                code <= 8'b0111100;
                end
            -68:  begin
                size <= 4'd7;
                code <= 8'b0111011;
                end
            -69:  begin
                size <= 4'd7;
                code <= 8'b0111010;
                end
            -70:  begin
                size <= 4'd7;
                code <= 8'b0111001;
                end
            -71:  begin
                size <= 4'd7;
                code <= 8'b0111000;
                end
            -72:  begin
                size <= 4'd7;
                code <= 8'b0110111;
                end
            -73:  begin
                size <= 4'd7;
                code <= 8'b0110110;
                end
            -74:  begin
                size <= 4'd7;
                code <= 8'b0110101;
                end
            -75:  begin
                size <= 4'd7;
                code <= 8'b0110100;
                end
            -76:  begin
                size <= 4'd7;
                code <= 8'b0110011;
                end
            -77:  begin
                size <= 4'd7;
                code <= 8'b0110010;
                end
            -78:  begin
                size <= 4'd7;
                code <= 8'b0110001;
                end
            -79:  begin
                size <= 4'd7;
                code <= 8'b0110000;
                end
            -80:  begin
                size <= 4'd7;
                code <= 8'b0101111;
                end
            -81:  begin
                size <= 4'd7;
                code <= 8'b0101110;
                end
            -82:  begin
                size <= 4'd7;
                code <= 8'b0101101;
                end
            -83:  begin
                size <= 4'd7;
                code <= 8'b0101100;
                end
            -84:  begin
                size <= 4'd7;
                code <= 8'b0101011;
                end
            -85:  begin
                size <= 4'd7;
                code <= 8'b0101010;
                end
            -86:  begin
                size <= 4'd7;
                code <= 8'b0101001;
                end
            -87:  begin
                size <= 4'd7;
                code <= 8'b0101000;
                end
            -88:  begin
                size <= 4'd7;
                code <= 8'b0100111;
                end
            -89:  begin
                size <= 4'd7;
                code <= 8'b0100110;
                end
            -90:  begin
                size <= 4'd7;
                code <= 8'b0100101;
                end
            -91:  begin
                size <= 4'd7;
                code <= 8'b0100100;
                end
            -92:  begin
                size <= 4'd7;
                code <= 8'b0100011;
                end
            -93:  begin
                size <= 4'd7;
                code <= 8'b0100010;
                end
            -94:  begin
                size <= 4'd7;
                code <= 8'b0100001;
                end
            -95:  begin
                size <= 4'd7;
                code <= 8'b0100000;
                end
            -96:  begin
                size <= 4'd7;
                code <= 8'b0011111;
                end
            -97:  begin
                size <= 4'd7;
                code <= 8'b0011110;
                end
            -98:  begin
                size <= 4'd7;
                code <= 8'b0011101;
                end
            -99:  begin
                size <= 4'd7;
                code <= 8'b0011100;
                end
            -100:  begin
                size <= 4'd7;
                code <= 8'b0011011;
                end
            -101:  begin
                size <= 4'd7;
                code <= 8'b0011010;
                end
            -102:  begin
                size <= 4'd7;
                code <= 8'b0011001;
                end
            -103:  begin
                size <= 4'd7;
                code <= 8'b0011000;
                end
            -104:  begin
                size <= 4'd7;
                code <= 8'b0010111;
                end
            -105:  begin
                size <= 4'd7;
                code <= 8'b0010110;
                end
            -106:  begin
                size <= 4'd7;
                code <= 8'b0010101;
                end
            -107:  begin
                size <= 4'd7;
                code <= 8'b0010100;
                end
            -108:  begin
                size <= 4'd7;
                code <= 8'b0010011;
                end
            -109:  begin
                size <= 4'd7;
                code <= 8'b0010010;
                end
            -110:  begin
                size <= 4'd7;
                code <= 8'b0010001;
                end
            -111:  begin
                size <= 4'd7;
                code <= 8'b0010000;
                end
            -112:  begin
                size <= 4'd7;
                code <= 8'b0001111;
                end
            -113:  begin
                size <= 4'd7;
                code <= 8'b0001110;
                end
            -114:  begin
                size <= 4'd7;
                code <= 8'b0001101;
                end
            -115:  begin
                size <= 4'd7;
                code <= 8'b0001100;
                end
            -116:  begin
                size <= 4'd7;
                code <= 8'b0001011;
                end
            -117:  begin
                size <= 4'd7;
                code <= 8'b0001010;
                end
            -118:  begin
                size <= 4'd7;
                code <= 8'b0001001;
                end
            -119:  begin
                size <= 4'd7;
                code <= 8'b0001000;
                end
            -120:  begin
                size <= 4'd7;
                code <= 8'b0000111;
                end
            -121:  begin
                size <= 4'd7;
                code <= 8'b0000110;
                end
            -122:  begin
                size <= 4'd7;
                code <= 8'b0000101;
                end
            -123:  begin
                size <= 4'd7;
                code <= 8'b0000100;
                end
            -124:  begin
                size <= 4'd7;
                code <= 8'b0000011;
                end
            -125:  begin
                size <= 4'd7;
                code <= 8'b0000010;
                end
            -126:  begin
                size <= 4'd7;
                code <= 8'b0000001;
                end
            -127:  begin
                size <= 4'd7;
                code <= 8'b0000000;
                end*/
         endcase
      end
   end
   
endmodule
   