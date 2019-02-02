`timescale 1ns/1ns

module testbench();
	
	reg clk_50, reset;
	
	reg [31:0] index;
	wire signed [15:0]  testbench_out;
	
	//Initialize clocks and index
	initial begin
		clk_50 = 1'b0;
		//testbench_out = 15'd0 ;
	end
	
	//Toggle the clocks
	always begin
		#10
		clk_50  = !clk_50;
	end
	
	//Intialize and drive signals
	initial begin
		reset  = 1'b0;
		#10 
		reset  = 1'b1;
		#30
		reset  = 1'b0;
	end
	
wire [39:0] counter;

//Instantiation of Device Under Test
count_test DUT   (.clock(clk_50), 
					.reset(reset),
					.count_out(counter)
				);
	
endmodule

/////////////////
// test module //
/////////////////
module count_test(count_out, clock, reset);
//
output [39:0]	count_out;
input clock, reset;
wire [39:0] count_out ;
reg [39:0] count ;
//
assign count_out = count ;
always @(posedge clock) begin
	if (reset) begin
		count <= 0;
	end
	else begin
		count <= count + 40'd1 ;
	end
end
endmodule