module reg32_avalon_interface(clock, resetn, write, writedata, read, readdata, byteenable, chipselect, Q);
	
	
	input clock, resetn;
	input read, write, chipselect;
	input [3:0] byteenable;
	input [31:0] writedata;
	output [31:0] readdata;
	output [31:0] Q;

	wire [31:0] to_reg, from_reg;

	assign to_reg = writedata;
	assign bbyteenable = (chipselect & write) ? byteenable : 4'b0;
	assign readdata = from_reg;
	assign Q = from_reg;

	reg32 U1 (.clk(clock), .reset_n(resetn), .D(to_reg), .byteenable(bbyteenable), .Q(from_reg));

endmodule

//=================================================================
module reg32 (clk, D, byteenable, reset_n, Q);

input reset_n, clk;
input [31:0] D;
input [3:0] byteenable;
output reg [31:0] Q;

always @(posedge clk or negedge reset_n)
begin 
	if(!reset_n)
		Q[31:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0100;
	else 
	  begin
		if(byteenable[3:0] == 4'b1111)
			Q[31:0] <= D[31:0];

		else if(byteenable[3:0] == 4'b0011)
			Q[15:0] <= D[15:0];

		else if(byteenable[3:0] == 4'b1100)
			Q[31:16] <= D[31:16];

		else if(byteenable[3:0] == 4'b0001)
			Q[7:0] <= D[7:0];

		else if(byteenable[3:0] == 4'b0010)
			Q[15:8] <= D[15:8];

		else if(byteenable[3:0] == 4'b0100)
			Q[23:16] <= D[23:16];

		else if(byteenable[3:0] == 4'b1000)
			Q[31:24] <= D[31:24];
		
		else
			Q <= D;

	  end
end