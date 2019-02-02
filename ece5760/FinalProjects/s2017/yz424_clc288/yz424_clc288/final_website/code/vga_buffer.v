/*********************************************************************************************************
Claire Chen and Mark Zhao
ECE 5760, Spring 2017

Attribution: Code taken from Altera documentation for Verilog inferred RAM
Page 774 - https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/hb/qts/qts_qii5v1.pdf

Description: Dual-port RAM inferred memory block
*********************************************************************************************************/

module vga_buffer(	// single clock dual-port RAM
	q,
	d,
	write_address,
	read_address,
	we, clk
);
	parameter DATA_WIDTH = 4;

	output reg [DATA_WIDTH-1:0] q;
	input [DATA_WIDTH-1:0] d;
	input [19:0] write_address;
	input [19:0] read_address;
	input we, clk;

	reg [DATA_WIDTH-1:0] mem [76799:0]; // 160x240
		
	always @ (posedge clk) begin
		if (we) begin
			mem[write_address] <= d;
		end
		q <= mem[read_address]; // q does not get d in this clock cycle
	end
	
endmodule
