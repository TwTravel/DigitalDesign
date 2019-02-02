module	NTSC_disp_generator(Y[8:0],			//intensity in, 512 steps
							color[3:0],
							clock_in,		//clock in.  50MHz
							NTSC_signal_out[9:0],	//ntsc signal out to dac
							X_COORD[9:0],	//current displayed x coordinate
							Y_COORD[9:0],	//current displayed y coordinate
							sync_out);		//sync signals, both horiz and vert


parameter	y_res = 10'd240;		//visible y resolution.  all math is done in 10 bits
//x_res is set by timing and ~525

//wire	[9:0]	y_res;
//assign	y_res  = R[9:0];

input	[8:0]	Y;
input	[3:0]	color;

input			clock_in;	//must be 50Mhz for timing

output	[9:0]	NTSC_signal_out;
output	[9:0]	X_COORD;
output	[9:0]	Y_COORD;
output			sync_out;

//implement Y'UV color space from RGB data.  conversion matrix taken from: http://en.wikipedia.org/wiki/YUV.   This is not used for now.  It's not needed, and there was something screwy with the matrix multiplier.
//exact values are:  
//Y = .299*R + .587*G + .114*B
//U = -.14713*R - .28886*B + .436*G
//V = .615*R - .51499*G -.10001*B
/*  this isn't used for the simple 1 bit color scheme.  
parameter signed YR = 11'd153, YG = 11'd301, YB=11'd58;
parameter signed UR = 11'd75, UG = 11'd148, UB = 11'd223;
parameter signed VR = 11'd315, VG = 11'd264, VB = 11'd51;

wire	signed 	[10:0]	R_calc = {1'b0, R[9:0]};
wire	signed 	[10:0]	G_calc = {1'b0, G[9:0]};
wire	signed 	[10:0]	B_calc = {1'b0, B[9:0]};

//all values are given by val*2^9 => 20 bit fixed point in 1.19 format.  21'st bit should be sign.  
wire	signed	[21:0]	Y_calc = (YR * R_calc + YG * G_calc + YB * B_calc);	//20 bit fixed point gives ~.002 error.  
wire	signed	[21:0]	U_calc = (-UR * R_calc - UG * G_calc + UB * B_calc);				
wire	signed	[21:0]	V_calc = (VR * R_calc - VG * G_calc - VB * B_calc);

//wire	signed	[8:0]	Y = Y_calc[18:10];		//always positive, 9 bits	this isn't used now, only input is Y now.
wire	signed	[8:0]	U = {U_calc[21], U_calc[18:11]};	
wire	signed	[8:0]	V = {V_calc[21], V_calc[18:11]};	
*/

wire	signed	[9:0]	color_signal;
wire	signed	[9:0]	color_burst;		//burst is scaled U component only
wire	signed	[17:0]	color_signal_calc;

////////////color burst////////////
//wire	signed	[8:0]	test1 = d[8:0];
//wire	signed	[8:0]	test2 = d[17:9];
assign	color_burst[9:0] = {scaled_U[8], scaled_U[8:0]};  //need 10 bits signed to add to 10bit output signal
//assign	color_signal_calc = scaled_U * U + scaled_V * V;
assign	color_signal[9:0] = ((color[0] ? {scaled_U[8], scaled_U[8:0]} : 10'b0) + (color[1] ? {scaled_V[8], scaled_V[8:0]} : 10'b0)
						   -(color[2] ? {scaled_U[8], scaled_U[8:0]} : 10'b0) - (color[3] ? {scaled_V[8], scaled_V[8:0]} : 10'b0));  // : {color_signal_calc[17], color_signal_calc[15:7]}; 		//I have no idea if this is right, alas

reg				horiz_sync;
reg				vert_sync;
wire			sync_out; 

reg		[9:0]	X_COORD;
reg		[9:0]	Y_COORD;
reg		[9:0]	NTSC_Y_signal_out;
reg				burst_on;
reg				color_on;

wire	[9:0]	NTSC_signal_out = NTSC_Y_signal_out + (burst_on ? color_burst[9:0] : 10'b0) + (color_on ? color_signal[9:0] : 10'b0);	//signal is Y + burst + U + V;


reg		[9:0]	horiz_sweep_counter;  	//timeing counter in clock ticks(should by 100ns each)
reg		[9:0]	vert_line_number;
reg				interlace;

reg		[3:0]	clock_decimation_counter;
reg				clock_10;

assign 	sync_out = horiz_sync && vert_sync; 

wire	[8:0]	I;

assign	I = {1'b0, vert_line_number[6], horiz_sweep_counter[7], 1'b1, 5'b0};



always @ (posedge clock_in)				//generate timing clock from 50MHz input clock.  output should be a pulse every 100ns.  This is not super exact, but should be good enough.
begin
	if(clock_decimation_counter == 4'd4)
	begin
		clock_10 <= 1;
		clock_decimation_counter <= 0;
	end
	else
	begin
		clock_10 <= 0;
		clock_decimation_counter <= clock_decimation_counter + 4'b1;
	end
end

always @ (negedge clock_10)		//update output x, y coords after clocking in previous data, but long before next pixel is needed.  (give 90ns for external hardware to load new pixel -> lots o time!)
begin
	if((vert_line_number < y_res) && (vert_line_number) > 10'd17)	//first 17 rows are not visible.
		Y_COORD <= vert_line_number - 10'd17;		//generate y from deinterlaced line num
	else
		Y_COORD <= 10'd0;
	
	if((horiz_sweep_counter > 10'd93))
		X_COORD <= horiz_sweep_counter[9:0] - 10'd94;		//this gives a horizontal resolution of 526.  This seems decent and I can't really find a definite standard.
	else
		X_COORD <= 10'd0;
end

always @ (posedge clock_10)
begin
color_on <= 1'b0;	//color off for now
//increment horiz_sweep_counter each 0.1us to 63.5us for one line, then increment vert_line_number to max of 262 lines
	if(horiz_sweep_counter == 10'd634)		//total sweep time per line is 63.5us.
	begin
		horiz_sweep_counter <= 0;
		if(vert_line_number == y_res[9:0] + 10'd19)		//y_res actual lines +  20 vert sync
		begin
			vert_line_number <= 0;		
			//interlace <= ~interlace;
		end
		else
			vert_line_number <= vert_line_number + 10'b1;
	end
	else
		horiz_sweep_counter <= horiz_sweep_counter + 10'b1;
	
			
	if(horiz_sweep_counter <= 10'd46) 			//horiz sync pulse, first 4.7us.	
	begin	
		if((vert_line_number >= y_res + 10'd6) && (vert_line_number <= y_res + 10'd8))		//normal display area for first 248 lines and last 13 lines of vert sync, horiz sync is 0
			NTSC_Y_signal_out <= 10'd205;			//for vert sync, horiz sync signal is inverted = 40 units(or 0 depeding on convention)
		else 
			NTSC_Y_signal_out <= 10'd0;		
	end
		
	else if(horiz_sweep_counter <= 10'd57) 		//back porch.  
	begin
		if((vert_line_number >= y_res + 10'd6) && (vert_line_number <= y_res + 10'd8))
			NTSC_Y_signal_out <= 10'd0;
		else
			NTSC_Y_signal_out <= 10'd205;
	end
	
	else if(horiz_sweep_counter <= 10'd82) 		//color burst
	begin
		if((vert_line_number >= y_res + 10'd6) && (vert_line_number <= y_res + 10'd8))
			NTSC_Y_signal_out <= 10'd0;
		else
		begin
			NTSC_Y_signal_out <= 10'd205;	//color burst should be signed
			burst_on <= 1'b1;
		end
	end
	
	else if(horiz_sweep_counter <= 10'd93) 		//back porch. 
	begin
		burst_on <= 1'b0;
		if((vert_line_number >= y_res + 10'd6) && (vert_line_number <= y_res + 10'd8))
			NTSC_Y_signal_out <= 10'd0;
		else
			NTSC_Y_signal_out <= 10'd205;
	end
	
	else if(horiz_sweep_counter <= 10'd619)
	begin
		if(vert_line_number < y_res)					//if in normal display lines
		begin
			NTSC_Y_signal_out <= 10'd256 + Y;		//output Y is Yout + black level=50IRE
			color_on <= 1'b1;
		end
		else if((vert_line_number >= y_res + 10'd6) && (vert_line_number <= y_res + 10'd8))		//otherwise, for vertical refresh sync pulses, output 0=0IRE
			NTSC_Y_signal_out <= 10'd0;
		else
			NTSC_Y_signal_out <= 10'd205;			//otherwise, for vertical refresh, output zero, ie blacker than black=40IRE
	end
	
	else if(horiz_sweep_counter <= 10'd634)
	begin
		color_on <= 1'b0;
		if((vert_line_number >= y_res + 10'd6) && (vert_line_number <= y_res + 10'd8))
			NTSC_Y_signal_out <= 10'd0;
		else
			NTSC_Y_signal_out <= 10'd205;				//and on final count, horiz sweep counter resets to 0
	end
end

//new scheme:  max value out is +100IRE, min is -40IRE.  Any scaling to give correct voltage out is done outside of ntsc disp module.
//10 bits gives 7.314 per IRE.  
//black value(10IRE): 366
//blacker than black(0IRE): 293 
//range of ... wait, the color signal needs 20IRE headroom above max lum.  

//max luminosity signal is 140 units, porches are at 40, sync is at 0, color is sine wave of amp 40
//let's set luminoscity at 9 bits max  => 205 is 40, 717 is max total luminosity signal.  
// Color saturation max is sine wave amp of 40 IRE??  I really can't find somewhere that says, darn it!
// Y=.3*R + .59*G + .11*B
// U = .49*(B - Y) = 
// V = .88*(R - Y) = 
                      
//140 IRE = 1Vpp





parameter signed color_scaling = 9'd205;

wire	signed	[7:0]	sineout_U;			//I'm not actually using IQ color encoding, instead UV is as good + simplier
wire	signed	[7:0]	sineout_V;
wire	signed	[8:0]	sineout2_U = {sineout_U[7], sineout_U[7:0]};		//convert to 9 bit for math
wire	signed 	[8:0]	sineout2_V = {sineout_V[7], sineout_V[7:0]};		//this is annoyingly complicated, but required to infer signed multiplies properly.  
wire	signed	[15:0]	sineout3_U = sineout2_U * color_scaling;			//only need 16 bits since both values are <256
wire	signed	[15:0]	sineout3_V = sineout2_V * color_scaling;	

wire	signed	[8:0]	scaled_U = {sineout3_U[15], sineout3_U[15:8]};		//output is +/- 102(20IRE)
wire	signed 	[8:0]	scaled_V = {sineout3_V[15], sineout3_V[15:8]};


wire	[7:0]	phase_U;
wire	[7:0]	phase_V;


assign	phase_U = phaseacc[19:12];
assign	phase_V = phaseacc[19:12] + 8'd64; 	//phase of Q is 90deg advanced from I

low_res_2scomp_sine_lookup_table_rom s1(
	phase_U[7:0],
	phase_V[7:0],
	~clock_in,
	sineout_U[7:0],
	sineout_V[7:0]);

//DDS variables
reg [19:0] 	phaseacc;

always @ (posedge clock_in)
begin									//ntsc color subcarrier is at 4.5*455/572.  at 50MHz clock rate, this gives a phase step of 75068.5.
	phaseacc <= phaseacc + 20'd75069;
end
	

	
endmodule
							
							