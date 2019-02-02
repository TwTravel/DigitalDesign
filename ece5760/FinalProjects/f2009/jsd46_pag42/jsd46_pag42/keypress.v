module keypress(	input wire scan_ready,
					input wire [7:0] scan_code,
					output reg next_key,
					output wire [8:0] char);

parameter released = 0, key_pressed = 1, releasing = 2;

reg [1:0] state;
reg [7:0] key;

//map serial stream to key. A through Z correspond to 1 through 26
assign char =	(key == 8'h1C) ? 9'd1 : 
		(key == 8'h32) ? 9'd2 :
		(key == 8'h21) ? 9'd3 :
		(key == 8'h23) ? 9'd4 :
		(key == 8'h24) ? 9'd5 :
		(key == 8'h2B) ? 9'd6 :
		(key == 8'h34) ? 9'd7 :
		(key == 8'h33) ? 9'd8 :
		(key == 8'h43) ? 9'd9 :
		(key == 8'h3B) ? 9'd10 :
		(key == 8'h42) ? 9'd11 :
		(key == 8'h4B) ? 9'd12 :
		(key == 8'h3A) ? 9'd13 :
		(key == 8'h31) ? 9'd14 :
		(key == 8'h44) ? 9'd15 :
		(key == 8'h4D) ? 9'd16 :
		(key == 8'h15) ? 9'd17 :
		(key == 8'h2D) ? 9'd18 :
		(key == 8'h1B) ? 9'd19 :
		(key == 8'h2C) ? 9'd20 :
		(key == 8'h3C) ? 9'd21 :
		(key == 8'h2A) ? 9'd22 :
		(key == 8'h1D) ? 9'd23 :
		(key == 8'h22) ? 9'd24 :
		(key == 8'h35) ? 9'd25 :
		(key == 8'h1A) ? 9'd26 : 0;

//state machine to detect when a key has been pressed
always @(posedge scan_ready)
begin
	case (state)
		released:
		begin
			key <= scan_code;
			next_key <= 1;
			state <= key_pressed;
		end
		
		key_pressed:
		begin
			if (scan_code == key)
			begin
				next_key <= ~next_key;
			end
			else
			begin
				next_key <= 0;
				state <= releasing;
			end
		end
		
		releasing:
		begin
			state <= released;
		end
		
		default:
		begin
			state <= released;
		end
	endcase
end

endmodule
