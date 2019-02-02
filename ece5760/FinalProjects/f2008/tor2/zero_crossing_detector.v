module zero_crossing_detector	(sig_in[13:0], 		//signal in should be in 2's comp
								signal_clock,
								crossing_detect_out);
								
input	[13:0]	sig_in;					//for zero crossing, we probably only need to look at sign bit
input			signal_clock;			//but for now, let's use full signal
output			crossing_detect_out;

reg				crossing_detect_out;
reg		[13:0]	previous_sig_in;
reg				hysterisis_low;
reg				hysterisis_high;

parameter	signed hysterisis = 14'b100000000000;		//amount signal must deviate below or above zero to allow zero crossing to be valid

always @ (posedge signal_clock)
begin
	previous_sig_in[13:0] <= sig_in[13:0];
	
	if(previous_sig_in[13] && (~sig_in[13]) && hysterisis_low)		//if positive trans, out goes pos
	begin
		crossing_detect_out <= 1'b1;
		hysterisis_low <= 1'b0;
	end
		
	if((~previous_sig_in[13]) && (sig_in[13]) && hysterisis_high)		//if negitive, out is neg
	begin
		crossing_detect_out <= 1'b0;
		hysterisis_high <= 1'b0;
	end

	if(sig_in[13:0] > hysterisis)
		hysterisis_high <= 1'b1;
		
	if(sig_in[13:0] < -hysterisis)
		hysterisis_low <= 1'b1;
	
end



endmodule

