module signal_generator	(frequency,				//40 bit output frequency in 24.16 format gives 15uHz resolution
								clock,			//100MHz  //
								sync_output,	//logic square wave out
								sigout_I,		//output both I and Q
								sigout_Q
								);			//selected signal out	

//modified to run on 10 fewer bits -> 50, not 60 bits of phaseacc, 30, not 40 bits of freq.
//timing delay was excessive and not reliable at 100MHz drive.  format of f is now 24.6.

input 	[30:0]	frequency;
input			clock;
								
output	[17:0]	sigout_I;								
output	[17:0]	sigout_Q;	
output			sync_output;							

wire	[17:0]	sigout_I;
wire	[17:0]	sigout_Q;

wire	[9:0]	phase_I;
wire	[9:0]	phase_Q;

wire			sync_output;

assign	phase_I = phaseacc[49:40];
assign	phase_Q = phaseacc[49:40] + 10'd256; 	//phase of Q is 90deg advanced from I
assign	sync_output = ~phaseacc[49];


sine_lookup_table_rom s1(
	phase_I[9:0],
	phase_Q[9:0],
	~clock,
	sigout_I[17:0],
	sigout_Q[17:0]);

	
//DDS variables
reg [49:0] 	phaseacc;
reg [49:0] 	phasestep;


always @ (posedge clock)
begin

	phasestep <= 175922 * frequency;			//fout = fclock * a / (# step per full cycle) * fin *2^16.     # steps is 2^60, f=100MHz => a = 175922.
											
	phaseacc <= phaseacc + phasestep;
end
	

endmodule