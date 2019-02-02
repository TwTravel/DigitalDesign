module exponential_decay_filter(signal_in, 
								signal_out,
								time_constant[35:0], //time constant is actually parameter equal to e^-1/d where d is number of samples time constant
								clock_in,
								reset);
							

input	signed	[35:0]	signal_in;
output	signed 	[35:0]	signal_out;
input	signed	[35:0]	time_constant;
input	clock_in;
input	reset;			//reset filter on reset high.

reg		signed	[35:0]	signal_out;
reg		signed	[35:0]	signal_out_old;

wire	signed	[71:0] 	multiply_out;

wire	signed	[35:0]	a0;
wire	signed	[35:0]	b1;

assign	b1 = {2'b01, 34'b0} - time_constant;  //{16'b0011111111000000, 20'b0};	//switch!!!! //  //1 - x
assign	a0 = time_constant;  //{10'b0, 10'b1111111111, 16'b0};  //	//time constant is in equal to x=1 - e^-1/d where d is number of samples decay time.  

assign	multiply_out = b1 * signal_out_old + a0 * signal_in;


always @ (negedge clock_in)
begin
	if(reset)							//a synchrous reset is nice when you're using long time constants and want fast step scanning of some parameter while measureing.  It's not implemented here.
	begin
		signal_out 		<= signal_in;
		signal_out_old 	<= signal_in;
	end

	else
	begin
		signal_out <= {multiply_out[71], multiply_out[68:34]};
		signal_out_old <= signal_out;
	end
end

endmodule		




