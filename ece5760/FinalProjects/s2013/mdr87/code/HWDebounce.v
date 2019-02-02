module HWDebounce(
	input clk,
	input [5:0] PlayerInput,
	output reg [5:0] DebouncedInput,
	output [1:0] debug
);

wire DebounceClk;
reg [1:0] state;
// State definitions
parameter NoPush = 2'b0;
parameter MaybePush = 2'b01;
parameter Pushed = 2'b10;
parameter MaybeNoPush = 2'b11;

assign debug = state;

reg [20:0] count;	// register used to count number of clock cycles for debounce
/* clk running at 53.703 MHz -> period = ~1.8621 x 10^-8 s
 * approximately 20-30 ms needed for proper debounce
 * 30ms / 1.8621 x 10^-8 s = ~1611090 counts
 * 11 followed by 19 0's is 1572864 -> ~29.3 ms */


reg [2:0] button;
/* 0 = Fire/Select
 * 1 = Rotate
 * 2 = Down
 * 3 = Right
 * 4 = Up
 * 5 = Left
 * 6 = None
 */

// Divide the input clock down
always @(posedge clk)
begin
	count <= count + 1;
end
assign DebounceClk = count[20];
 
initial
begin
	state = NoPush;
	button = 3'd6;
	count = 21'b0;
	DebouncedInput = 6'b0;
end

always @(posedge DebounceClk)
begin	
	case (state)		
		NoPush:
		begin
			if(PlayerInput[0])		// if Fire/Select button is pressed
			begin
				button <= 3'd0;
				state <= MaybePush;
			end
			else if(PlayerInput[1]) // if Rotate button is pressed
			begin
				button <= 3'd1;
				state <= MaybePush;
			end
			else if(PlayerInput[2])	// if Down button is pressed
			begin
				button <= 3'd2;
				state <= MaybePush;
			end
			else if(PlayerInput[3])	// if Right button is pressed
			begin
				button <= 3'd3;
				state <= MaybePush;
			end
			else if(PlayerInput[4])	// if Up button is pressed
			begin
				button <= 3'd4;
				state <= MaybePush;
			end
			else if(PlayerInput[5])	// if Left button is pressed
			begin
				button <= 3'd5;
				state <= MaybePush;
			end
		end
		
		MaybePush:
		begin
			if(PlayerInput[button])
			begin
				state <= Pushed;
				DebouncedInput[button] <= 1'b1;
			end
			else state <= NoPush;
		end
		
		Pushed:
		begin
			if(!PlayerInput[button])
			begin
				state <= MaybeNoPush;
			end
		end
		
		//MaybeNoPush:
		default:
		begin
			if(PlayerInput[button])
			begin
				state <= Pushed;
			end
			else
			begin
				state <= NoPush;
				DebouncedInput[button] <= 1'b0;
			end
		end
	
	endcase
end
	
endmodule
