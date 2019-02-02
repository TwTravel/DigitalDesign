 module ref_digital_PLL (DDS_sync_output,		//phase + frequency square wave from DDS
						reference_sync_wave,	//ref signal after zero-crossing detect
						CLOCK_in,
						DDS_feedback_out[29:0],
						locked,
						comparator_out_pos,
						comparator_out_neg
						);

input	DDS_sync_output;
input	reference_sync_wave;
input	CLOCK_in;

output	[29:0]	DDS_feedback_out;
output	locked;
output	comparator_out_pos;
output	comparator_out_neg;

wire	locked;

reg		comparator_out_pos;
reg		comparator_out_neg;

reg		neg_temp1;
reg		pos_temp1;
reg		neg_temp2;
reg		pos_temp2;

reg		[29:0]	DDS_feedback_out_1;
wire	[29:0]	DDS_feedback_out;
reg		[29:0]	pos_gain;
reg		[29:0]	neg_gain;

assign	DDS_feedback_out = DDS_feedback_out_1 + pos_gain - neg_gain + 30'b1000000;	//output is integral portion + direct gain portions

wire	reset;

wire	[29:0]	neg_val;
wire	[29:0]	plus_val;
wire	[29:0]	gain;


assign	neg_val  =  30'b100000;	//was 40'b10000000000;		//set integral and gain constants.  
assign	plus_val =  30'b100000;
assign	gain	 =  {8'b0, 1'b1, 21'b0};

assign	reset = DDS_sync_output && reference_sync_wave;               	

wire	deglitch_out_pos = pos_temp1;				//additional registers for deglighing issues
wire	deglitch_out_neg = neg_temp1;

  //old and simple "loop filter"
always @ (posedge CLOCK_in)							//adjust proportional and integrator values each clock cycle
begin
	
	neg_temp1 <= comparator_out_neg;
	pos_temp1 <= comparator_out_pos;	
	 
	if(deglitch_out_neg && ~deglitch_out_pos)		
		DDS_feedback_out_1[29:0] <= DDS_feedback_out_1[29:0] - neg_val;
	else if(deglitch_out_pos && ~deglitch_out_neg)
		DDS_feedback_out_1[29:0] <= DDS_feedback_out_1[29:0] + plus_val;		
		
	if(pos_temp1)
	begin
		neg_gain <= 30'b0;
		pos_gain <= gain;
	end
	else if(neg_temp1)
	begin
		pos_gain <= 30'b0;
		neg_gain <= gain;
	end
	else
	begin
		neg_gain <= 30'b0;
		pos_gain <= 30'b0;
	end
		
end



/* this was usefull for tuning the loop parameters, but is overly complicated 
parameter signed b1_2 = {18'b001111111111111000}; //decay time of lots of time steps.(a bit slow)
parameter signed a0_2 = {18'b000000000000000111}; 

reg		signed	[17:0]	signal2_in;
reg		signed	[17:0]	signal2_out;
reg		signed	[17:0]	signal2_out_old;
wire	signed	[35:0] 	filter2_mult_out = a0_2*signal2_in + b1_2*signal2_out_old;

always @ (posedge CLOCK_in)
begin
	
	//neg_temp1 <= comparator_out_neg;
	//pos_temp1 <= comparator_out_pos;
	
	if(pos_temp1)
	begin
		signal2_in <= {3'b001, 15'b0};
		neg_gain <= 32'b0;
		pos_gain <= {8'b0, 1'b1, 23'b0};
	end
	else if(neg_temp1)
	begin
		signal2_in <= {3'b101, 15'b0};
		pos_gain <= 32'b0;
		neg_gain <= {8'b0, 1'b1, 23'b0};
	end
	else
	begin
		signal2_in <= {18'b0};
		neg_gain <= 32'b0;
		pos_gain <= 32'b0;
	end
	
	signal2_out <= {filter2_mult_out[35],filter2_mult_out[32:16]};		//take mult out, convert back to 18 bits
	signal2_out_old <= signal2_out;
end		
*/

//lock detection logic
reg	[31:0]	ref_period_counter;	
reg	[31:0]	DDS_period_counter;
reg	[31:0]	ref_period;	
reg	[31:0]	DDS_period;
reg			previous_ref_state;
reg			previous_DDS_state;
reg			ref_count_done;
reg			DDS_count_done;

reg	[9:0]	lock_counter;
reg			local_lock_signal;

	
always @ (posedge CLOCK_in)
begin
	previous_ref_state <= reference_sync_wave;
	previous_DDS_state <= DDS_sync_output;
	
	if(reference_sync_wave && ~previous_ref_state && ref_count_done && DDS_count_done)			//if reference pulse goes high, begin count
	begin
		ref_count_done <= 1'b0;
		DDS_count_done <= 1'b0;
		ref_period_counter <= 32'b0;
		DDS_period_counter <= 32'b0;	
	end
	
	else 
	begin
		ref_period_counter <= ref_period_counter + 32'b1;
		DDS_period_counter <= DDS_period_counter + 32'b1;
		
		if(previous_ref_state && ~reference_sync_wave && ~ref_count_done)		//if ref pulse goes low, record time
		begin
			ref_period <= ref_period_counter;
			ref_count_done <=1'b1;
		end
		
		if(previous_DDS_state && ~DDS_sync_output && ~DDS_count_done)			//if DDS pulse low, record
		begin
			DDS_period <= DDS_period_counter;
			DDS_count_done <=1'b1;
		end
	end
	
	
	if((DDS_period > (3 * (ref_period >> 2))) && ((DDS_period) < (5 * (ref_period >> 2))))		//if DDS period is within +/- 25% of ref period, turn on local lock signal
		local_lock_signal <= 1'b1;
	else
		local_lock_signal <= 1'b0;		
end

assign	locked = lock_counter[7];

always @ (posedge reference_sync_wave)
begin
	if(~local_lock_signal)					//if no lock signal, clear lock counter
		lock_counter <=	10'b0;
	else
		if(~lock_counter[7])				//if counter has reached 2^8, signal is considered locked.
			lock_counter <= lock_counter + 1'b1;
end


always @ (posedge DDS_sync_output or posedge reset)		//phase comparator flip flops
begin
	if(reset)
		comparator_out_neg <= 0;
	else
		comparator_out_neg <= 1;
end

always @ (posedge reference_sync_wave or posedge reset)
begin
	if(reset)
		comparator_out_pos <= 0;
	else
		comparator_out_pos <= 1;
end



						
endmodule
