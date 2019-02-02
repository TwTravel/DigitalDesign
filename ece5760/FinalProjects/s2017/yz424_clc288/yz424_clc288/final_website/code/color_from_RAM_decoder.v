/*********************************************************************************************************
Claire Chen and Mark Zhao
ECE 5760, Spring 2017

Description: Decode 4 bit color from RAM into 16-bit color for VGA
Decoding scheme:
0x0 - black
0x1 - red
0x2 - green
0x3 - orange
0x4 - yellow
0x5 - purple
*********************************************************************************************************/

module color_from_RAM_decoder (
	color_from_RAM,
	decoded_color
);

input [3:0] color_from_RAM;
output [15:0] decoded_color;

reg [15:0] decoded_color;

always @ (*) begin
	case (color_from_RAM)
		4'h0: decoded_color = 16'h0000; //black
		4'h1: decoded_color = 16'hf801; //red
		4'h2: decoded_color = 16'h07e0; //green
		4'h3: decoded_color = 16'hfc01; //orange
		4'h4: decoded_color = 16'hffe0; //yellow
		4'h5: decoded_color = 16'h803f; //purple
		default: decoded_color = 16'h0000; //black
	endcase
end

endmodule