module DE2_Default
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_27,						//	27 MHz
		CLOCK_50,						//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[17:0]
		////////////////////////	LED		////////////////////////
		LEDG,							//	LED Green[8:0]
		LEDR,							//	LED Red[17:0]
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,						//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Address bus 18 Bits
		SRAM_UB_N,						//	SRAM High-byte Data Mask 
		SRAM_LB_N,						//	SRAM Low-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		I2C_SCLK,						//	I2C Clock
		////////////////////	VGA		////////////////////////////
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		////////////////	Audio CODEC		////////////////////////
		AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
		AUD_ADCDAT,						//	Audio CODEC ADC Data
		AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
		AUD_DACDAT,						//	Audio CODEC DAC Data
		AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
		AUD_XCK, 						//	Audio CODEC Chip Clock
		////////////////	TV Decoder		////////////////////////
		TD_RESET						//	TV Decoder Reset
		
	);

////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_27;				//	27 MHz
input			CLOCK_50;				//	50 MHz
input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	SW;						//	Toggle Switch[17:0]
////////////////////////////	LED		////////////////////////////
output	[8:0]	LEDG;					//	LED Green[8:0]
output	[17:0]	LEDR;					//	LED Red[17:0]
////////////////////////	SRAM Interface	////////////////////////
inout	[15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
output	[17:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
output			SRAM_UB_N;				//	SRAM High-byte Data Mask
output			SRAM_LB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_WE_N;				//	SRAM Write Enable
output			SRAM_CE_N;				//	SRAM Chip Enable
output			SRAM_OE_N;				//	SRAM Output Enable
////////////////////////	I2C		////////////////////////////////
inout			I2C_SDAT;				//	I2C Data
output			I2C_SCLK;				//	I2C Clock
////////////////////////	VGA			////////////////////////////
output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK;				//	VGA BLANK
output			VGA_SYNC;				//	VGA SYNC
output	[9:0]	VGA_R;   				//	VGA Red[9:0]
output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
////////////////////	Audio CODEC		////////////////////////////
output/*inout*/	AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			AUD_ADCDAT;				//	Audio CODEC ADC Data
inout			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT;				//	Audio CODEC DAC Data
inout			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK;				//	Audio CODEC Chip Clock
////////////////////	TV Devoder		////////////////////////////
output			TD_RESET;				//	TV Decoder Reset

wire			reset;					//reset CA & display
reg		[17:0]	addr_reg;				//SRAM address register
reg		[15:0]	data_reg;				//SRAM data register
reg				Rsel;					//select the left or right 'pixel' of SRAM
reg				we;						//SRAM write enable

reg				lock;					//VGA asserts control of SRAM
wire	[19:0]	mVGA_ADDR;				//VGA memory address
wire	[9:0]	mVGA_R,mVGA_G,mVGA_B;	//VGA red, green, blue inputs to VGA control
wire	[9:0]	coord_x,coord_y;		//screen x & y coordinates (640x480)
wire			VGA_CTRL_CLK;			//vga controller clock
wire			DLY_RST;				//reset delay
wire			AUD_CTRL_CLK;			//audio control clock

//27 MHz Clock enable
assign	TD_RESET	=	1'b1;	//	Allow 27 MHz input

// VGA Control Modules
VGA_Audio_PLL	p1 (.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK));

Reset_Delay r_dly (.iCLK(CLOCK_50),.oRESET(DLY_RST));

VGA_Controller my_vga_ctrl
(	//	Host Side
	.iCursor_RGB_EN(4'b0111),
	.iRed(mVGA_R),
	.iGreen(mVGA_G),
	.iBlue(mVGA_B),
	.oAddress(mVGA_ADDR),
	.oCoord_X(coord_x),
	.oCoord_Y(coord_y),
	
	//	VGA Side
	.oVGA_R(VGA_R),
	.oVGA_G(VGA_G),
	.oVGA_B(VGA_B),
	.oVGA_H_SYNC(VGA_HS),
	.oVGA_V_SYNC(VGA_VS),
	.oVGA_SYNC(VGA_SYNC),
	.oVGA_BLANK(VGA_BLANK),
	
	//	Control Signal
	.iCLK(VGA_CTRL_CLK),
	.iRST_N(DLY_RST)
);
						
// SRAM assignments
assign 	SRAM_ADDR = addr_reg;
assign 	SRAM_DQ = (we) ? 16'hzzzz : data_reg;	//SRAM data reg set to tristate if being read
assign 	SRAM_UB_N = 0;
assign 	SRAM_LB_N = 0;
assign 	SRAM_CE_N = 0;
assign 	SRAM_0E_N = 0;
assign 	SRAM_WE_N = we;	//Active Low Write Enable

// Reset assignment
assign 	reset = ~KEY[0];		//key0 is active low


//*** Spectrogram/Bar Graph Drawing Stuff ***//
//implement HSL -> RGB color for the range 0 to 255
wire [8:0]	bhue;	//t_B
reg [17:0] 	b_out;	//blue out
wire [8:0]	ghue;	//t_G
reg	[17:0]	g_out;	//green out
wire [8:0]	rhue;	//t_R
reg	[17:0]	r_out;	//red out
wire [8:0]	chue;

reg	[1:0]	hsl_pq;	//P and Q values

//generate t_C signals
assign chue = 8'hFF-SRAM_DQ[7:0];
assign bhue = (chue < 9'd120) ? ({1'b0,chue} + 9'd240):({1'b0,chue}-9'd120);
assign ghue = {1'b0,chue};
assign rhue = (chue > 9'd240) ? ({1'b0,chue} - 9'd240):({1'b0,chue}+9'd120);

always @ (posedge VGA_CTRL_CLK) begin
	
	if (hsl_pq[1] == 1) begin //draw white
		b_out <= 18'd255;
		g_out <= 18'd255;
		r_out <= 18'd255;
	end else if (hsl_pq == 2'b0) begin //draw black
		b_out <= 18'd0;
		g_out <= 18'd0;
		r_out <= 18'd0;
	end else begin	//generate 8 bit R G B values from t_C values
		if (bhue < 9'd60) begin
			b_out <= ((9'd17*bhue)>>2);
		end else if ((bhue >= 9'd60)&&(bhue < 9'd180)) begin
			b_out <= 18'd255;
		end else if ((bhue >= 9'd180)&&(bhue < 9'd240)) begin
			b_out <= (9'd17*(9'd240-bhue)>>2);
		end else begin
			b_out <= 18'd0;
		end
		
		if (ghue < 9'd60) begin
			g_out <= ((9'd17*ghue)>>2);
		end else if ((ghue >= 9'd60)&&(ghue < 9'd180)) begin
			g_out <= 18'd255;
		end else if ((ghue >= 9'd180)&&(ghue < 9'd240)) begin
			g_out <= (9'd17*(9'd240-ghue)>>2);
		end else begin
			g_out <= 18'd0;
		end
		
		if (rhue < 9'd60) begin
			r_out <= ((9'd17*rhue)>>2);
		end else if ((rhue >= 9'd60)&&(rhue < 9'd180)) begin
			r_out <= 18'd255;
		end else if ((rhue >= 9'd180)&&(rhue < 9'd240)) begin
			r_out <= (9'd17*(9'd240-rhue)>>2);
		end else begin
			r_out <= 18'd0;
		end
	end
end

//assign 8 bit RGB values
assign mVGA_B = {b_out[7:0],2'b0};
assign mVGA_G = {g_out[7:0],2'b0};
assign mVGA_R = {r_out[7:0],2'b0};


reg			v_sync_start;		//marks the first cycle of v_sync, may be removed later
reg	[9:0]	offset;				//horizontal circular buffer offset
reg [31:0]	samp_count;			//counter for timing even samples
reg	[2:0]	state;				//state variable for sample & draw states
reg 		copy_state;			//state for copying over freq bins to SRAM
reg			s_flag;				//flag that indicates a sample has been made - used by counter
reg			hold;				//signal to hold output of the FFT while it's being sampled
reg	[4:0]	freq_addr;			//address which point of the n point FFT to read
reg	[4:0]	freq_copy;			//which frequency bin is being copied from
reg [31:0]	samp_time;			//let's us set how often to sample the FFT
reg	[3:0]	num_samps;			//tracks the number of samples made

reg	FFT_ready;

always @ (posedge VGA_CTRL_CLK) begin	
	FFT_ready <= hold;
end

/*	Set of Frequency Bin Buffers up to 5 entries deep for smoother updating of SRAM	*/
reg	[47:0]	freq_bin0;
reg	[47:0]	freq_bin1;
reg	[47:0]	freq_bin2;
reg	[47:0]	freq_bin3;

reg	[47:0]	freq_bin4;
reg	[47:0]	freq_bin5;
reg	[47:0]	freq_bin6;
reg	[47:0]	freq_bin7;

reg	[47:0]	freq_bin8;
reg	[47:0]	freq_bin9;
reg	[47:0]	freq_bin10;
reg	[47:0]	freq_bin11;

reg	[47:0]	freq_bin12;
reg	[47:0]	freq_bin13;
reg	[47:0]	freq_bin14;
reg	[47:0]	freq_bin15;

reg	[47:0]	freq_bin16;
reg	[47:0]	freq_bin17;
reg	[47:0]	freq_bin18;
reg	[47:0]	freq_bin19;

reg	[47:0]	freq_bin20;
reg	[47:0]	freq_bin21;
reg	[47:0]	freq_bin22;
reg	[47:0]	freq_bin23;

reg	[47:0]	freq_bin24;
reg	[47:0]	freq_bin25;
reg	[47:0]	freq_bin26;
reg	[47:0]	freq_bin27;

reg	[47:0]	freq_bin28;
reg	[47:0]	freq_bin29;
reg	[47:0]	freq_bin30;
reg	[47:0]	freq_bin31;
/*	End of Frequency Bins */
		
		
//reset & VGA Pixel Blat + Line Drawer State Machine
always @ (posedge VGA_CTRL_CLK)
begin
	case (SW[2:0])	//Read Desired Screen Length in Time from Switches 2:0
		0:	begin
				samp_time <= 32'd84000;		//2 Seconds on Screen
			end
		1:	begin
				samp_time <= 32'd126000;	//3 Seconds on Screen
			end
		2:	begin
				samp_time <= 32'd168000;	//4 Seconds on Screen
			end
		3:	begin
				samp_time <= 32'd210000;	//5 Seconds on Screen
			end
		4:	begin
				samp_time <= 32'd252000;	//6 Seconds on Screen
			end
		5:	begin
				samp_time <= 32'd294000;	//7 Seconds on Screen
			end
		6:	begin
				samp_time <= 32'd336000;	//8 Seconds on Screen
			end
		7:	begin
				samp_time <= 32'd378000;	//9 Seconds on Screen
			end
	endcase

	if (reset) begin
		//blank the screen
		addr_reg <= {coord_x[9:0],coord_y[8 :1]};
		we <= 1'b0;
		//draw rainbow in spectrogram (left side, will scroll off)
		if (coord_x < 10'd256)
			data_reg <= {8'b0,coord_x[7:0]};
		else
			data_reg <= 16'h0000;
		Rsel <= 0;
		v_sync_start <= 1;
		offset <= 10'b0;
		samp_count <= 0;
		s_flag <= 0;
		state <= 3;
		num_samps <= 0;
		copy_state <= 0;
		freq_copy <= 0;
	end else begin	
		//Sample Timer Stuff - Timing for FFT sampling
		if (s_flag) begin
			samp_count <= samp_count + 32'b1 - samp_time;
			s_flag <= 0;
		end else if (KEY[3]) begin
			samp_count <= samp_count + 32'b1;
		end
		
		if ((~VGA_HS  | ~VGA_VS)& KEY[3]) begin
			//At the start of a vertical sync, copy over to SRAM from the buffer
			if (~VGA_VS & v_sync_start) begin
				if (num_samps > 0) begin
					//the copying state machine
					if (copy_state <= 0) begin
						we <= 1;
						addr_reg <= {(10'd20 + offset),1'b0,(5'd31 - freq_copy),2'b0};
						copy_state <= 1;
						
						case (freq_copy)
							0:	begin
									data_reg <= {8'b0,freq_bin0[7:0]};
									if (num_samps > 1) begin
										freq_bin0 <= freq_bin0 >> 8;
									end
								end
							1:	begin
									data_reg <= {8'b0,freq_bin1[7:0]};
									if (num_samps > 1) begin
										freq_bin1 <= freq_bin1 >> 8;
									end
								end
							2:	begin
									data_reg <= {8'b0,freq_bin2[7:0]};
									if (num_samps > 1) begin
										freq_bin2 <= freq_bin2 >> 8;
									end
								end
							3:	begin
									data_reg <= {8'b0,freq_bin3[7:0]};
									if (num_samps > 1) begin
										freq_bin3 <= freq_bin3 >> 8;
									end
								end
							4:	begin
									data_reg <= {8'b0,freq_bin4[7:0]};
									if (num_samps > 1) begin
										freq_bin4 <= freq_bin4 >> 8;
									end
								end
							5:	begin
									data_reg <= {8'b0,freq_bin5[7:0]};
									if (num_samps > 1) begin
										freq_bin5 <= freq_bin5 >> 8;
									end
								end
							6:	begin
									data_reg <= {8'b0,freq_bin6[7:0]};
									if (num_samps > 1) begin
										freq_bin6 <= freq_bin6 >> 8;
									end
								end
							7:	begin
									data_reg <= {8'b0,freq_bin7[7:0]};
									if (num_samps > 1) begin
										freq_bin7 <= freq_bin7 >> 8;
									end
								end
							8:	begin
									data_reg <= {8'b0,freq_bin8[7:0]};
									if (num_samps > 1) begin
										freq_bin8 <= freq_bin8 >> 8;
									end
								end
							9:	begin
									data_reg <= {8'b0,freq_bin9[7:0]};
									if (num_samps > 1) begin
										freq_bin9 <= freq_bin9 >> 8;
									end
								end
							10:	begin
									data_reg <= {8'b0,freq_bin10[7:0]};
									if (num_samps > 1) begin
										freq_bin10 <= freq_bin10 >> 8;
									end
								end
							11:	begin
									data_reg <= {8'b0,freq_bin11[7:0]};
									if (num_samps > 1) begin
										freq_bin11 <= freq_bin11 >> 8;
									end
								end
							12:	begin
									data_reg <= {8'b0,freq_bin12[7:0]};
									if (num_samps > 1) begin
										freq_bin12 <= freq_bin12 >> 8;
									end
								end
							13:	begin
									data_reg <= {8'b0,freq_bin13[7:0]};
									if (num_samps > 1) begin
										freq_bin13 <= freq_bin13 >> 8;
									end
								end
							14:	begin
									data_reg <= {8'b0,freq_bin14[7:0]};
									if (num_samps > 1) begin
										freq_bin14 <= freq_bin14 >> 8;
									end
								end
							15:	begin
									data_reg <= {8'b0,freq_bin15[7:0]};
									if (num_samps > 1) begin
										freq_bin15 <= freq_bin15 >> 8;
									end
								end
							16:	begin
									data_reg <= {8'b0,freq_bin16[7:0]};
									if (num_samps > 1) begin
										freq_bin16 <= freq_bin16 >> 8;
									end
								end
							17:	begin
									data_reg <= {8'b0,freq_bin17[7:0]};
									if (num_samps > 1) begin
										freq_bin17 <= freq_bin17 >> 8;
									end
								end
							18:	begin
									data_reg <= {8'b0,freq_bin18[7:0]};
									if (num_samps > 1) begin
										freq_bin18 <= freq_bin18 >> 8;
									end
								end
							19:	begin
									data_reg <= {8'b0,freq_bin19[7:0]};
									if (num_samps > 1) begin
										freq_bin19 <= freq_bin19 >> 8;
									end
								end
							20:	begin
									data_reg <= {8'b0,freq_bin20[7:0]};
									if (num_samps > 1) begin
										freq_bin20 <= freq_bin20 >> 8;
									end
								end
							21:	begin
									data_reg <= {8'b0,freq_bin21[7:0]};
									if (num_samps > 1) begin
										freq_bin21 <= freq_bin21 >> 8;
									end
								end
							22:	begin
									data_reg <= {8'b0,freq_bin22[7:0]};
									if (num_samps > 1) begin
										freq_bin22 <= freq_bin22 >> 8;
									end
								end
							23:	begin
									data_reg <= {8'b0,freq_bin23[7:0]};
									if (num_samps > 1) begin
										freq_bin23 <= freq_bin23 >> 8;
									end
								end
							24:	begin
									data_reg <= {8'b0,freq_bin24[7:0]};
									if (num_samps > 1) begin
										freq_bin24 <= freq_bin24 >> 8;
									end
								end
							25:	begin
									data_reg <= {8'b0,freq_bin25[7:0]};
									if (num_samps > 1) begin
										freq_bin25 <= freq_bin25 >> 8;
									end
								end
							26:	begin
									data_reg <= {8'b0,freq_bin26[7:0]};
									if (num_samps > 1) begin
										freq_bin26 <= freq_bin26 >> 8;
									end
								end
							27:	begin
									data_reg <= {8'b0,freq_bin27[7:0]};
									if (num_samps > 1) begin
										freq_bin27 <= freq_bin27 >> 8;
									end
								end
							28:	begin
									data_reg <= {8'b0,freq_bin28[7:0]};
									if (num_samps > 1) begin
										freq_bin28 <= freq_bin28 >> 8;
									end
								end
							29:	begin
									data_reg <= {8'b0,freq_bin29[7:0]};
									if (num_samps > 1) begin
										freq_bin29 <= freq_bin29 >> 8;
									end
								end
							30:	begin
									data_reg <= {8'b0,freq_bin30[7:0]};
									if (num_samps > 1) begin
										freq_bin30 <= freq_bin30 >> 8;
									end
								end
							31:	begin
									data_reg <= {8'b0,freq_bin31[7:0]};
									if (num_samps > 1) begin
										freq_bin31 <= freq_bin31 >> 8;
									end
								end
						endcase
						
					end else begin
						we <= 1'b0;
						copy_state <= 0;
						if (freq_copy == 31) begin
							num_samps <= num_samps - 1'b1;
							if (offset < 599) begin
								offset <= offset + 1'b1;
							end else begin
								offset <= 0;
							end
						end
						
						freq_copy <= freq_copy + 1'b1;
					end
							
				end else begin	//no more entries to copy
					v_sync_start <= 0;
				end
			end else begin	//the sampling state machine
				
				we <= 1;
				
				if (~VGA_HS & VGA_VS) begin	//reset v_sync_start
					v_sync_start <=1;
				end
				
				case (state)
				0: 	begin	//Should be initializing the sampling
						hold <= 1;
						freq_addr <= 0;
						state <= 1;
					end
				
				1:	begin	//Cycle through till 32 freqs have been taken from the FFT
						
						case (freq_addr)	//shift in the latest sample
							/*** MATLAB GENERATED CODE ***/
							0:	begin
								if (num_samps == 0) begin
									freq_bin0[7:0] <= filter0_amp;
								end else begin
									freq_bin0 <= freq_bin0 | (filter0_amp << {num_samps,3'b0});
								end
							end

							1:	begin
								if (num_samps == 0) begin
									freq_bin1[7:0] <= filter1_amp;
								end else begin
									freq_bin1 <= freq_bin1 | (filter1_amp << {num_samps,3'b0});
								end
							end

							2:	begin
								if (num_samps == 0) begin
									freq_bin2[7:0] <= filter2_amp;
								end else begin
									freq_bin2 <= freq_bin2 | (filter2_amp << {num_samps,3'b0});
								end
							end

							3:	begin
								if (num_samps == 0) begin
									freq_bin3[7:0] <= filter3_amp;
								end else begin
									freq_bin3 <= freq_bin3 | (filter3_amp << {num_samps,3'b0});
								end
							end

							4:	begin
								if (num_samps == 0) begin
									freq_bin4[7:0] <= filter4_amp;
								end else begin
									freq_bin4 <= freq_bin4 | (filter4_amp << {num_samps,3'b0});
								end
							end

							5:	begin
								if (num_samps == 0) begin
									freq_bin5[7:0] <= filter5_amp;
								end else begin
									freq_bin5 <= freq_bin5 | (filter5_amp << {num_samps,3'b0});
								end
							end

							6:	begin
								if (num_samps == 0) begin
									freq_bin6[7:0] <= filter6_amp;
								end else begin
									freq_bin6 <= freq_bin6 | (filter6_amp << {num_samps,3'b0});
								end
							end

							7:	begin
								if (num_samps == 0) begin
									freq_bin7[7:0] <= filter7_amp;
								end else begin
									freq_bin7 <= freq_bin7 | (filter7_amp << {num_samps,3'b0});
								end
							end

							8:	begin
								if (num_samps == 0) begin
									freq_bin8[7:0] <= filter8_amp;
								end else begin
									freq_bin8 <= freq_bin8 | (filter8_amp << {num_samps,3'b0});
								end
							end

							9:	begin
								if (num_samps == 0) begin
									freq_bin9[7:0] <= filter9_amp;
								end else begin
									freq_bin9 <= freq_bin9 | (filter9_amp << {num_samps,3'b0});
								end
							end

							10:	begin
								if (num_samps == 0) begin
									freq_bin10[7:0] <= filter10_amp;
								end else begin
									freq_bin10 <= freq_bin10 | (filter10_amp << {num_samps,3'b0});
								end
							end

							11:	begin
								if (num_samps == 0) begin
									freq_bin11[7:0] <= filter11_amp;
								end else begin
									freq_bin11 <= freq_bin11 | (filter11_amp << {num_samps,3'b0});
								end
							end

							12:	begin
								if (num_samps == 0) begin
									freq_bin12[7:0] <= filter12_amp;
								end else begin
									freq_bin12 <= freq_bin12 | (filter12_amp << {num_samps,3'b0});
								end
							end

							13:	begin
								if (num_samps == 0) begin
									freq_bin13[7:0] <= filter13_amp;
								end else begin
									freq_bin13 <= freq_bin13 | (filter13_amp << {num_samps,3'b0});
								end
							end

							14:	begin
								if (num_samps == 0) begin
									freq_bin14[7:0] <= filter14_amp;
								end else begin
									freq_bin14 <= freq_bin14 | (filter14_amp << {num_samps,3'b0});
								end
							end

							15:	begin
								if (num_samps == 0) begin
									freq_bin15[7:0] <= filter15_amp;
								end else begin
									freq_bin15 <= freq_bin15 | (filter15_amp << {num_samps,3'b0});
								end
							end

							16:	begin
								if (num_samps == 0) begin
									freq_bin16[7:0] <= filter16_amp;
								end else begin
									freq_bin16 <= freq_bin16 | (filter16_amp << {num_samps,3'b0});
								end
							end

							17:	begin
								if (num_samps == 0) begin
									freq_bin17[7:0] <= filter17_amp;
								end else begin
									freq_bin17 <= freq_bin17 | (filter17_amp << {num_samps,3'b0});
								end
							end

							18:	begin
								if (num_samps == 0) begin
									freq_bin18[7:0] <= filter18_amp;
								end else begin
									freq_bin18 <= freq_bin18 | (filter18_amp << {num_samps,3'b0});
								end
							end

							19:	begin
								if (num_samps == 0) begin
									freq_bin19[7:0] <= filter19_amp;
								end else begin
									freq_bin19 <= freq_bin19 | (filter19_amp << {num_samps,3'b0});
								end
							end

							20:	begin
								if (num_samps == 0) begin
									freq_bin20[7:0] <= filter20_amp;
								end else begin
									freq_bin20 <= freq_bin20 | (filter20_amp << {num_samps,3'b0});
								end
							end

							21:	begin
								if (num_samps == 0) begin
									freq_bin21[7:0] <= filter21_amp;
								end else begin
									freq_bin21 <= freq_bin21 | (filter21_amp << {num_samps,3'b0});
								end
							end

							22:	begin
								if (num_samps == 0) begin
									freq_bin22[7:0] <= filter22_amp;
								end else begin
									freq_bin22 <= freq_bin22 | (filter22_amp << {num_samps,3'b0});
								end
							end

							23:	begin
								if (num_samps == 0) begin
									freq_bin23[7:0] <= filter23_amp;
								end else begin
									freq_bin23 <= freq_bin23 | (filter23_amp << {num_samps,3'b0});
								end
							end

							24:	begin
								if (num_samps == 0) begin
									freq_bin24[7:0] <= filter24_amp;
								end else begin
									freq_bin24 <= freq_bin24 | (filter24_amp << {num_samps,3'b0});
								end
							end

							25:	begin
								if (num_samps == 0) begin
									freq_bin25[7:0] <= filter25_amp;
								end else begin
									freq_bin25 <= freq_bin25 | (filter25_amp << {num_samps,3'b0});
								end
							end

							26:	begin
								if (num_samps == 0) begin
									freq_bin26[7:0] <= filter26_amp;
								end else begin
									freq_bin26 <= freq_bin26 | (filter26_amp << {num_samps,3'b0});
								end
							end

							27:	begin
								if (num_samps == 0) begin
									freq_bin27[7:0] <= filter27_amp;
								end else begin
									freq_bin27 <= freq_bin27 | (filter27_amp << {num_samps,3'b0});
								end
							end

							28:	begin
								if (num_samps == 0) begin
									freq_bin28[7:0] <= filter28_amp;
								end else begin
									freq_bin28 <= freq_bin28 | (filter28_amp << {num_samps,3'b0});
								end
							end

							29:	begin
								if (num_samps == 0) begin
									freq_bin29[7:0] <= filter29_amp;
								end else begin
									freq_bin29 <= freq_bin29 | (filter29_amp << {num_samps,3'b0});
								end
							end

							30:	begin
								if (num_samps == 0) begin
									freq_bin30[7:0] <= filter30_amp;
								end else begin
									freq_bin30 <= freq_bin30 | (filter30_amp << {num_samps,3'b0});
								end
							end

							31:	begin
								if (num_samps == 0) begin
									freq_bin31[7:0] <= filter31_amp;
								end else begin
									freq_bin31 <= freq_bin31 | (filter31_amp << {num_samps,3'b0});
								end
							end
							/*** END MATLAB GENERATED CODE **/
						endcase
						
						if (freq_addr == 31) begin	//if last sample has been copied ...
							hold <= 0;
							state <= 3;
							num_samps <= num_samps + 1'b1;						
						end else begin
							//update freq_addr & go to address
							freq_addr <= freq_addr + 1'b1;
							state <= 2;
						end
					end
				
				2:	begin			
						//time to set up next read
						state <= 1;
					end
				
				3:	begin	//Should wait for time to take a new sample
						if (samp_count >= samp_time) begin
							state <= 0;
							s_flag <= 1;
						end
					end 
					
				endcase
			end																															
		end else begin
				/*** VGA READING SRAM ***/
				if ((coord_x > 63)&(coord_x < 576)&(coord_y > 292)&(coord_y < 419)) begin
					case ((coord_x - 64)>>4)
					0:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin0[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd124};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd124};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					1:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin1[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd120};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd120};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					2:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin2[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd116};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd116};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					3:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin3[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd112};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd112};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					4:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin4[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd108};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd108};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					5:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin5[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd104};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd104};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					6:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin6[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd100};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd100};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					7:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin7[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd96};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd96};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					8:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin8[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd92};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd92};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					9:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin9[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd88};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd88};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					10:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin10[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd84};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd84};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					11:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin11[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd80};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd80};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					12:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin12[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd76};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd76};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					13:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin13[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd72};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd72};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					14:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin14[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd68};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd68};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					15:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin15[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd64};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd64};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					16:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin16[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd60};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd60};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					17:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin17[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd56};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd56};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					18:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin18[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd52};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd52};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					19:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin19[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd48};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd48};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					20:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin20[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd44};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd44};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					21:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin21[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd40};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd40};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					22:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin22[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd36};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd36};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					23:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin23[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd32};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd32};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					24:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin24[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd28};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd28};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					25:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin25[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd24};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd24};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					26:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin26[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd20};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd20};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					27:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin27[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd16};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd16};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					28:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin28[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd12};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd12};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					29:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin29[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd8};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd8};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					30:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin30[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd4};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd4};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
					31:	begin
					        if (coord_y >= (9'd419 - {2'b0,freq_bin31[7:1]})) begin
					            if (offset > 0)begin
					                addr_reg <= {(10'd19+offset),8'd0};
					                Rsel <= 0;
					            end else begin
					                addr_reg <= {10'd619,8'd0};
					                Rsel <= 0;
					            end
					            hsl_pq <= 2'b01;
					        end else begin
					            addr_reg <= {coord_x[9:0],coord_y[8:1]};
					            Rsel <= coord_y[0];
					            hsl_pq <= 2'b00;
					        end
					     end
				default:	begin
								addr_reg <= {coord_x[9:0],coord_y[8:1]};
								Rsel <= coord_y[0];
							end
					endcase
				end else if	((coord_x < 20)|(coord_x > 619)|(coord_y > 255)) begin	//Address normally
					addr_reg <= {coord_x[9:0],coord_y[8:1]};
					Rsel <= coord_y[0];
					hsl_pq <= 2'b00;
				end else if ((coord_x + offset) < 620)begin	//In spectrogram - address + offset
					addr_reg <= {(coord_x[9:0]+offset),coord_y[8:3],2'b0};
					Rsel <= 0;
					hsl_pq <= 2'b01;
				end else begin	//In spectrogram - wrap around w/ offset
					addr_reg <= {(coord_x[9:0]-(10'd600 - offset)),coord_y[8:3],2'b0};
					Rsel <=0;
					hsl_pq <= 2'b01;
				end
				we <= 1'b1;
		end
	end
end	

///////////////////////////////
//                           //
//   Fast Fourier Transform  //
//                           //
///////////////////////////////
I2C_AV_Config 		u3	(	//	Host Side
							.iCLK(CLOCK_50),
							.iRST_N(KEY[0]),
							//	I2C Side
							.I2C_SCLK(I2C_SCLK),
							.I2C_SDAT(I2C_SDAT)	);

assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

wire	signed [15:0] adc_sample;

AUDIO_DAC 			u4	(	//	Audio Side
							.oAUD_BCK(AUD_BCLK),
							.oAUD_DATA(AUD_DACDAT),
							.oAUD_LRCK(AUD_DACLRCK),
							.iAUD_ADCDAT(AUD_ADCDAT),
							//	Control Signals
							.iSrc_Select(SW[17:16]),
				            .iCLK_18_4(AUD_CTRL_CLK),
							.iRST_N(DLY_RST),
							.oFFT_Signal(adc_sample),
							.iFFT_Control(SW[15:14]),
							.iDDS_incr({10'b0, SW[12:4], 12'b0}));




/// audio stuff /////////////////////////////////////////////////
// filter outputs
wire signed [15:0]  filter0_out, filter1_out, filter2_out, filter3_out,
					filter4_out, filter5_out, filter6_out, filter7_out,
					filter8_out, filter9_out, filter10_out, filter11_out,
					filter12_out, filter13_out, filter14_out, filter15_out,
					filter16_out, filter17_out, filter18_out, filter19_out,
					filter20_out, filter21_out, filter22_out, filter23_out,
					filter24_out, filter25_out, filter26_out, filter27_out,
					filter28_out, filter29_out, filter30_out, filter31_out;

wire signed [7:0]   filter0_amp, filter1_amp, filter2_amp, filter3_amp,
					filter4_amp, filter5_amp, filter6_amp, filter7_amp,
					filter8_amp, filter9_amp, filter10_amp, filter11_amp,
					filter12_amp, filter13_amp, filter14_amp, filter15_amp,
					filter16_amp, filter17_amp, filter18_amp, filter19_amp,
					filter20_amp, filter21_amp, filter22_amp, filter23_amp,
					filter24_amp, filter25_amp, filter26_amp, filter27_amp,
					filter28_amp, filter29_amp, filter30_amp, filter31_amp;

// get the average amp (always >+0)
average f0_amp(filter0_amp, filter0_out, 4'd8, AUD_DACLRCK,SW,reset);
average f1_amp(filter1_amp, filter1_out, 4'd8, AUD_DACLRCK,SW,reset);
average f2_amp(filter2_amp, filter2_out, 4'd8, AUD_DACLRCK,SW,reset);
average f3_amp(filter3_amp, filter3_out, 4'd8, AUD_DACLRCK,SW,reset);
average f4_amp(filter4_amp, filter4_out, 4'd8, AUD_DACLRCK,SW,reset);
average f5_amp(filter5_amp, filter5_out, 4'd8, AUD_DACLRCK,SW,reset);
average f6_amp(filter6_amp, filter6_out, 4'd8, AUD_DACLRCK,SW,reset);
average f7_amp(filter7_amp, filter7_out, 4'd8, AUD_DACLRCK,SW,reset);
average f8_amp(filter8_amp, filter8_out, 4'd8, AUD_DACLRCK,SW,reset);
average f9_amp(filter9_amp, filter9_out, 4'd8, AUD_DACLRCK,SW,reset);
average f10_amp(filter10_amp, filter10_out, 4'd8, AUD_DACLRCK,SW,reset);
average f11_amp(filter11_amp, filter11_out, 4'd8, AUD_DACLRCK,SW,reset);
average f12_amp(filter12_amp, filter12_out, 4'd8, AUD_DACLRCK,SW,reset);
average f13_amp(filter13_amp, filter13_out, 4'd8, AUD_DACLRCK,SW,reset);
average f14_amp(filter14_amp, filter14_out, 4'd8, AUD_DACLRCK,SW,reset);
average f15_amp(filter15_amp, filter15_out, 4'd8, AUD_DACLRCK,SW,reset);
average f16_amp(filter16_amp, filter16_out, 4'd8, AUD_DACLRCK,SW,reset);
average f17_amp(filter17_amp, filter17_out, 4'd8, AUD_DACLRCK,SW,reset);
average f18_amp(filter18_amp, filter18_out, 4'd8, AUD_DACLRCK,SW,reset);
average f19_amp(filter19_amp, filter19_out, 4'd8, AUD_DACLRCK,SW,reset);
average f20_amp(filter20_amp, filter20_out, 4'd8, AUD_DACLRCK,SW,reset);
average f21_amp(filter21_amp, filter21_out, 4'd8, AUD_DACLRCK,SW,reset);
average f22_amp(filter22_amp, filter22_out, 4'd8, AUD_DACLRCK,SW,reset);
average f23_amp(filter23_amp, filter23_out, 4'd8, AUD_DACLRCK,SW,reset);
average f24_amp(filter24_amp, filter24_out, 4'd8, AUD_DACLRCK,SW,reset);
average f25_amp(filter25_amp, filter25_out, 4'd8, AUD_DACLRCK,SW,reset);
average f26_amp(filter26_amp, filter26_out, 4'd8, AUD_DACLRCK,SW,reset);
average f27_amp(filter27_amp, filter27_out, 4'd8, AUD_DACLRCK,SW,reset);
average f28_amp(filter28_amp, filter28_out, 4'd8, AUD_DACLRCK,SW,reset);
average f29_amp(filter29_amp, filter29_out, 4'd8, AUD_DACLRCK,SW,reset);
average f30_amp(filter30_amp, filter30_out, 4'd8, AUD_DACLRCK,SW,reset);
average f31_amp(filter31_amp, filter31_out, 4'd8, AUD_DACLRCK,SW,reset);

/// Define filters //////////////////////////////////////////////
 
 
//Filter: cutoff=0.050000 
//Filter: cutoff=0.078125 
IIR4 filter0 (
     .audio_out (filter0_out), 
     .audio_in (adc_sample), 
     .scale (3'd3), 
     .b1 (18'h11B), 
     .b2 (18'h3FFEE), 
     .b3 (18'h3FDEF), 
     .b4 (18'h3FFEE), 
     .b5 (18'h11B), 
     .a2 (18'h681D), 
     .a3 (18'h37F29), 
     .a4 (18'h48A7), 
     .a5 (18'h3F00B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.078125 
//Filter: cutoff=0.106250 
IIR4 filter1 (
     .audio_out (filter1_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h236), 
     .b2 (18'h3FFDC), 
     .b3 (18'h3FBDC), 
     .b4 (18'h3FFDC), 
     .b5 (18'h236), 
     .a2 (18'hCBAB), 
     .a3 (18'h305D4), 
     .a4 (18'h8E20), 
     .a5 (18'h3E015), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.106250 
//Filter: cutoff=0.134375 
IIR4 filter2 (
     .audio_out (filter2_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h236), 
     .b2 (18'h3FFDD), 
     .b3 (18'h3FBDA), 
     .b4 (18'h3FFDD), 
     .b5 (18'h236), 
     .a2 (18'hC585), 
     .a3 (18'h30FB1), 
     .a4 (18'h89D5), 
     .a5 (18'h3E015), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.134375 
//Filter: cutoff=0.162500 
IIR4 filter3 (
     .audio_out (filter3_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h236), 
     .b2 (18'h3FFDF), 
     .b3 (18'h3FBD7), 
     .b4 (18'h3FFDF), 
     .b5 (18'h236), 
     .a2 (18'hBDD4), 
     .a3 (18'h31B9B), 
     .a4 (18'h8477), 
     .a5 (18'h3E015), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.162500 
//Filter: cutoff=0.190625 
IIR4 filter4 (
     .audio_out (filter4_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'h3FFF1), 
     .b3 (18'h3FDF3), 
     .b4 (18'h3FFF1), 
     .b5 (18'h116), 
     .a2 (18'hC490), 
     .a3 (18'h300BB), 
     .a4 (18'hA152), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.190625 
//Filter: cutoff=0.218750 
IIR4 filter5 (
     .audio_out (filter5_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'h3FFF2), 
     .b3 (18'h3FDF2), 
     .b4 (18'h3FFF2), 
     .b5 (18'h116), 
     .a2 (18'hB90C), 
     .a3 (18'h3120C), 
     .a4 (18'h97DF), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.218750 
//Filter: cutoff=0.246875 
IIR4 filter6 (
     .audio_out (filter6_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'h3FFF3), 
     .b3 (18'h3FDF0), 
     .b4 (18'h3FFF3), 
     .b5 (18'h116), 
     .a2 (18'hAC17), 
     .a3 (18'h32449), 
     .a4 (18'h8D3D), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.246875 
//Filter: cutoff=0.275000 
IIR4 filter7 (
     .audio_out (filter7_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'h3FFF4), 
     .b3 (18'h3FDEF), 
     .b4 (18'h3FFF4), 
     .b5 (18'h116), 
     .a2 (18'h9DCA), 
     .a3 (18'h336E0), 
     .a4 (18'h8180), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.275000 
//Filter: cutoff=0.303125 
IIR4 filter8 (
     .audio_out (filter8_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'h3FFF5), 
     .b3 (18'h3FDED), 
     .b4 (18'h3FFF5), 
     .b5 (18'h116), 
     .a2 (18'h8E43), 
     .a3 (18'h3493D), 
     .a4 (18'h74C1), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.303125 
//Filter: cutoff=0.331250 
IIR4 filter9 (
     .audio_out (filter9_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'h3FFF6), 
     .b3 (18'h3FDEB), 
     .b4 (18'h3FFF6), 
     .b5 (18'h116), 
     .a2 (18'h7D9F), 
     .a3 (18'h35ACE), 
     .a4 (18'h6719), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.331250 
//Filter: cutoff=0.359375 
IIR4 filter10 (
     .audio_out (filter10_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'h3FFF8), 
     .b3 (18'h3FDEA), 
     .b4 (18'h3FFF8), 
     .b5 (18'h116), 
     .a2 (18'h6C00), 
     .a3 (18'h36B07), 
     .a4 (18'h58A3), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.359375 
//Filter: cutoff=0.387500 
IIR4 filter11 (
     .audio_out (filter11_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'h3FFF9), 
     .b3 (18'h3FDE9), 
     .b4 (18'h3FFF9), 
     .b5 (18'h116), 
     .a2 (18'h5989), 
     .a3 (18'h37967), 
     .a4 (18'h497C), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.387500 
//Filter: cutoff=0.415625 
IIR4 filter12 (
     .audio_out (filter12_out), 
     .audio_in (adc_sample), 
     .scale (3'd1), 
     .b1 (18'h22D), 
     .b2 (18'h3FFF5), 
     .b3 (18'h3FBCF), 
     .b4 (18'h3FFF5), 
     .b5 (18'h22D), 
     .a2 (18'h8CBF), 
     .a3 (18'h30AF4), 
     .a4 (18'h7384), 
     .a5 (18'h3A96B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.415625 
//Filter: cutoff=0.443750 
IIR4 filter13 (
     .audio_out (filter13_out), 
     .audio_in (adc_sample), 
     .scale (3'd1), 
     .b1 (18'h22D), 
     .b2 (18'h3FFF8), 
     .b3 (18'h3FBCD), 
     .b4 (18'h3FFF8), 
     .b5 (18'h22D), 
     .a2 (18'h6553), 
     .a3 (18'h31DC2), 
     .a4 (18'h5329), 
     .a5 (18'h3A96B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.443750 
//Filter: cutoff=0.471875 
IIR4 filter14 (
     .audio_out (filter14_out), 
     .audio_in (adc_sample), 
     .scale (3'd1), 
     .b1 (18'h22D), 
     .b2 (18'h3FFFC), 
     .b3 (18'h3FBCC), 
     .b4 (18'h3FFFC), 
     .b5 (18'h22D), 
     .a2 (18'h3D1D), 
     .a3 (18'h32AA1), 
     .a4 (18'h3228), 
     .a5 (18'h3A96B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.471875 
//Filter: cutoff=0.500000 
IIR4 filter15 (
     .audio_out (filter15_out), 
     .audio_in (adc_sample), 
     .scale (3'd1), 
     .b1 (18'h22D), 
     .b2 (18'h3FFFF), 
     .b3 (18'h3FBCB), 
     .b4 (18'h3FFFF), 
     .b5 (18'h22D), 
     .a2 (18'h146C), 
     .a3 (18'h3312A), 
     .a4 (18'h10C3), 
     .a5 (18'h3A96B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.500000 
//Filter: cutoff=0.528125 
IIR4 filter16 (
     .audio_out (filter16_out), 
     .audio_in (adc_sample), 
     .scale (3'd1), 
     .b1 (18'h22D), 
     .b2 (18'h1), 
     .b3 (18'h3FBCB), 
     .b4 (18'h1), 
     .b5 (18'h22D), 
     .a2 (18'h3EB94), 
     .a3 (18'h3312A), 
     .a4 (18'h3EF3D), 
     .a5 (18'h3A96B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.528125 
//Filter: cutoff=0.556250 
IIR4 filter17 (
     .audio_out (filter17_out), 
     .audio_in (adc_sample), 
     .scale (3'd1), 
     .b1 (18'h22D), 
     .b2 (18'h4), 
     .b3 (18'h3FBCC), 
     .b4 (18'h4), 
     .b5 (18'h22D), 
     .a2 (18'h3C2E3), 
     .a3 (18'h32AA1), 
     .a4 (18'h3CDD8), 
     .a5 (18'h3A96B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.556250 
//Filter: cutoff=0.584375 
IIR4 filter18 (
     .audio_out (filter18_out), 
     .audio_in (adc_sample), 
     .scale (3'd1), 
     .b1 (18'h22D), 
     .b2 (18'h8), 
     .b3 (18'h3FBCD), 
     .b4 (18'h8), 
     .b5 (18'h22D), 
     .a2 (18'h39AAD), 
     .a3 (18'h31DC2), 
     .a4 (18'h3ACD7), 
     .a5 (18'h3A96B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.584375 
//Filter: cutoff=0.612500 
IIR4 filter19 (
     .audio_out (filter19_out), 
     .audio_in (adc_sample), 
     .scale (3'd1), 
     .b1 (18'h22D), 
     .b2 (18'hB), 
     .b3 (18'h3FBCF), 
     .b4 (18'hB), 
     .b5 (18'h22D), 
     .a2 (18'h37341), 
     .a3 (18'h30AF4), 
     .a4 (18'h38C7C), 
     .a5 (18'h3A96B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.612500 
//Filter: cutoff=0.640625 
IIR4 filter20 (
     .audio_out (filter20_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'h7), 
     .b3 (18'h3FDE9), 
     .b4 (18'h7), 
     .b5 (18'h116), 
     .a2 (18'h3A677), 
     .a3 (18'h37967), 
     .a4 (18'h3B684), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.640625 
//Filter: cutoff=0.668750 
IIR4 filter21 (
     .audio_out (filter21_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'h8), 
     .b3 (18'h3FDEA), 
     .b4 (18'h8), 
     .b5 (18'h116), 
     .a2 (18'h39400), 
     .a3 (18'h36B07), 
     .a4 (18'h3A75D), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.668750 
//Filter: cutoff=0.696875 
IIR4 filter22 (
     .audio_out (filter22_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'hA), 
     .b3 (18'h3FDEB), 
     .b4 (18'hA), 
     .b5 (18'h116), 
     .a2 (18'h38261), 
     .a3 (18'h35ACE), 
     .a4 (18'h398E7), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.696875 
//Filter: cutoff=0.725000 
IIR4 filter23 (
     .audio_out (filter23_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'hB), 
     .b3 (18'h3FDED), 
     .b4 (18'hB), 
     .b5 (18'h116), 
     .a2 (18'h371BD), 
     .a3 (18'h3493D), 
     .a4 (18'h38B3F), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.725000 
//Filter: cutoff=0.753125 
IIR4 filter24 (
     .audio_out (filter24_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'hC), 
     .b3 (18'h3FDEF), 
     .b4 (18'hC), 
     .b5 (18'h116), 
     .a2 (18'h36236), 
     .a3 (18'h336E0), 
     .a4 (18'h37E80), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.753125 
//Filter: cutoff=0.781250 
IIR4 filter25 (
     .audio_out (filter25_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'hD), 
     .b3 (18'h3FDF0), 
     .b4 (18'hD), 
     .b5 (18'h116), 
     .a2 (18'h353E9), 
     .a3 (18'h32449), 
     .a4 (18'h372C3), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.781250 
//Filter: cutoff=0.809375 
IIR4 filter26 (
     .audio_out (filter26_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'hE), 
     .b3 (18'h3FDF2), 
     .b4 (18'hE), 
     .b5 (18'h116), 
     .a2 (18'h346F4), 
     .a3 (18'h3120C), 
     .a4 (18'h36821), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.809375 
//Filter: cutoff=0.837500 
IIR4 filter27 (
     .audio_out (filter27_out), 
     .audio_in (adc_sample), 
     .scale (3'd2), 
     .b1 (18'h116), 
     .b2 (18'hF), 
     .b3 (18'h3FDF3), 
     .b4 (18'hF), 
     .b5 (18'h116), 
     .a2 (18'h33B70), 
     .a3 (18'h300BB), 
     .a4 (18'h35EAE), 
     .a5 (18'h3D4B6), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.837500 
//Filter: cutoff=0.865625 
IIR4 filter28 (
     .audio_out (filter28_out), 
     .audio_in (adc_sample), 
     .scale (3'd3), 
     .b1 (18'h8B), 
     .b2 (18'h8), 
     .b3 (18'h3FEFB), 
     .b4 (18'h8), 
     .b5 (18'h8B), 
     .a2 (18'h398BB), 
     .a3 (18'h37871), 
     .a4 (18'h3AB3F), 
     .a5 (18'h3EA5B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.865625 
//Filter: cutoff=0.893750 
IIR4 filter29 (
     .audio_out (filter29_out), 
     .audio_in (adc_sample), 
     .scale (3'd3), 
     .b1 (18'h8B), 
     .b2 (18'h8), 
     .b3 (18'h3FEFB), 
     .b4 (18'h8), 
     .b5 (18'h8B), 
     .a2 (18'h3948C), 
     .a3 (18'h3717E), 
     .a4 (18'h3A7D0), 
     .a5 (18'h3EA5B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.893750 
//Filter: cutoff=0.921875 
IIR4 filter30 (
     .audio_out (filter30_out), 
     .audio_in (adc_sample), 
     .scale (3'd3), 
     .b1 (18'h8B), 
     .b2 (18'h8), 
     .b3 (18'h3FEFC), 
     .b4 (18'h8), 
     .b5 (18'h8B), 
     .a2 (18'h39133), 
     .a3 (18'h36BBC), 
     .a4 (18'h3A511), 
     .a5 (18'h3EA5B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
 
//Filter: cutoff=0.921875 
//Filter: cutoff=0.950000 
IIR4 filter31 (
     .audio_out (filter31_out), 
     .audio_in (adc_sample), 
     .scale (3'd3), 
     .b1 (18'h8B), 
     .b2 (18'h9), 
     .b3 (18'h3FEFC), 
     .b4 (18'h9), 
     .b5 (18'h8B), 
     .a2 (18'h38EB8), 
     .a3 (18'h3675A), 
     .a4 (18'h3A307), 
     .a5 (18'h3EA5B), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 

endmodule



///////////////////////////////////////////////////////////////////
/// Fourth order IIR filter ///////////////////////////////////////
///////////////////////////////////////////////////////////////////
module IIR4 (audio_out, audio_in, 
			scale, 
			b1, b2, b3, b4, b5, 
			a2, a3, a4, a5, 
			state_clk, lr_clk, reset) ;
// The filter is a "Direct Form II Transposed"
// 
//    a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
//                          - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
// 
//    If a(1) is not equal to 1, FILTER normalizes the filter
//    coefficients by a(1). 
//
// one audio sample, 16 bit, 2's complement
output reg signed [15:0] audio_out ;
// one audio sample, 16 bit, 2's complement
input wire signed [15:0] audio_in ;
// shift factor for output
input wire [2:0] scale ;
// filter coefficients
input wire signed [17:0] b1, b2, b3, b4, b5, a2, a3, a4, a5 ;
input wire state_clk, lr_clk, reset ;

/// filter vars //////////////////////////////////////////////////
wire signed [17:0] f1_mac_new, f1_coeff_x_value ;
reg signed [17:0] f1_coeff, f1_mac_old, f1_value ;

// input to filter
reg signed [17:0] x_n ;
// input history x(n-1), x(n-2)
reg signed [17:0] x_n1, x_n2, x_n3, x_n4 ; 

// output history: y_n is the new filter output, BUT it is
// immediately stored in f1_y_n1 for the next loop through 
// the filter state machine
reg signed [17:0] f1_y_n1, f1_y_n2, f1_y_n3, f1_y_n4 ; 

// MAC operation
signed_mult f1_c_x_v (f1_coeff_x_value, f1_coeff, f1_value);
assign f1_mac_new = f1_mac_old + f1_coeff_x_value ;

// state variable 
reg [3:0] state ;
//oneshot gen to sync to audio clock
reg last_clk ; 
///////////////////////////////////////////////////////////////////

//Run the filter state machine FAST so that it completes in one 
//audio cycle
always @ (posedge state_clk) 
begin
	if (reset)
	begin
		state <= 4'd15 ; //turn off the state machine
		x_n <= 0;
		x_n1 <= 0;
		x_n2 <= 0;
		x_n3 <= 0;
		x_n4 <= 0;
		f1_y_n1 <= 0;	
		f1_y_n2 <= 0;
		f1_y_n3 <= 0;
		f1_y_n4 <= 0;
	end
	
	else begin
		case (state)
	
			1: 
			begin
				// set up b1*x(n)
				f1_mac_old <= 18'd0 ;
				f1_coeff <= b1 ;
				f1_value <= {audio_in, 2'b0} ;				
				//register input
				x_n <= {audio_in, 2'b0} ;				
				// next state
				state <= 4'd2;
			end
	
			2: 
			begin
				// set up b2*x(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b2 ;
				f1_value <= x_n1 ;				
				// next state
				state <= 4'd3;
			end
			
			3:
			begin
				// set up b3*x(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b3 ;
				f1_value <= x_n2 ;
				// next state
				state <= 4'd4;
			end
			
			4:
			begin
				// set up b4*x(n-3) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b4 ;
				f1_value <= x_n3 ;
				// next state
				state <= 4'd5;
			end
			
			5:
			begin
				// set up b5*x(n-4) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b5 ;
				f1_value <= x_n4 ;
				// next state
				state <= 4'd6;
			end
						
			6: 
			begin
				// set up -a2*y(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a2 ;
				f1_value <= f1_y_n1 ; 
				//next state 
				state <= 4'd7;
			end
			
			7: 
			begin
				// set up -a3*y(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a3 ;
				f1_value <= f1_y_n2 ; 				
				//next state 
				state <= 4'd8;
			end
			
			8: 
			begin
				// set up -a4*y(n-3) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a4 ;
				f1_value <= f1_y_n3 ; 				
				//next state 
				state <= 4'd9;
			end
			
			9: 
			begin
				// set up -a5*y(n-4) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a5 ;
				f1_value <= f1_y_n4 ; 				
				//next state 
				state <= 4'd10;
			end
			
			10: 
			begin
				// get the output 
				// and put it in the LAST output var
				// for the next pass thru the state machine
				//mult by four because of coeff scaling
				// to prevent overflow
				f1_y_n1 <= f1_mac_new<<scale ; 
				audio_out <= f1_y_n1[17:2] ;				
				// update output history
				f1_y_n2 <= f1_y_n1 ;
				f1_y_n3 <= f1_y_n2 ;
				f1_y_n4 <= f1_y_n3 ;				
				// update input history
				x_n1 <= x_n ;
				x_n2 <= x_n1 ;
				x_n3 <= x_n2 ;
				x_n4 <= x_n3 ;
				//next state 
				state <= 4'd15;
			end
			
			15:
			begin
				// wait for the audio clock and one-shot it
				if (lr_clk && last_clk==1)
				begin
					state <= 4'd1 ;
					last_clk <= 1'h0 ;
				end
				// reset the one-shot memory
				else if (~lr_clk && last_clk==0)
				begin
					last_clk <= 1'h1 ;				
				end	
			end
			
			default:
			begin
				// default state is end state
				state <= 4'd15 ;
			end
		endcase
	end
end	

endmodule

///////////////////////////////////////////////////
//// signed mult of 2.16 format 2'comp ////////////
///////////////////////////////////////////////////
module signed_mult (out, a, b);

	output 		[17:0]	out;
	input 	signed	[17:0] 	a;
	input 	signed	[17:0] 	b;
	
	wire	signed	[17:0]	out;
	wire 	signed	[35:0]	mult_out;

	assign mult_out = a * b;
	//assign out = mult_out[33:17];
	assign out = {mult_out[35], mult_out[32:16]};
endmodule
//////////////////////////////////////////////////


/////////////////////////////////////////////////////
//// Time weighted average amplitude (2'comp) ///////
/////////////////////////////////////////////////////
// dk_const    e-folding time of average			         
// 3			~8 samples
// 4			15 
// 5			32
// 6			64
// 7			128 -- 2.7 mSec at 48kHz
// 8			256 -- 5.3 mSec (useful for music/voice)
// 9			512 -- 10.5 mSec (useful for music/voice)
// 10			1024 -- 21 mSec (useful for music/voice)
// 11			2048 -- 42 mSec
module average (truncatedout, in, dk_const, clk, SW, reset);

	output reg signed [7:0] truncatedout;
	input wire signed [15:0] in ;
	input wire [3:0] dk_const ;
	input wire clk;
	input [17:0] SW;
	input wire reset;
	
	reg signed [15:0] out;
	wire signed  [17:0] new_out ;
	//first order lowpass of absolute value of input
	assign new_out = out - (out>>>dk_const) + ((in[15]?-in:in)>>>dk_const) ;
	always @(posedge clk)
	begin
		if (reset)
			out <= 0;
		else
		 	out <= new_out ;
	end
	
	always @ (SW or out)
	begin
		case (SW[8:6])
			0:	truncatedout = (out > 0) ? (out <  255)  ?  out[7:0] : 8'hFF
												: (out > -256)  ? -out[7:0] : 8'hFF;
			1:	truncatedout = (out > 0) ? (out <  511)  ?  out[8:1] : 8'hFF
												: (out > -512)  ? -out[8:1] : 8'hFF;
			2:	truncatedout = (out > 0) ? (out <  1023) ?  out[9:2] : 8'hFF
												: (out > -1024) ? -out[9:2] : 8'hFF;
			3:	truncatedout = (out > 0) ? (out <  2047) ?  out[10:3] : 8'hFF
												: (out > -2048) ? -out[10:3] : 8'hFF;
			4:	truncatedout = (out > 0) ? (out <  4095) ?  out[11:4] : 8'hFF
												: (out > -4096) ? -out[11:4] : 8'hFF;
			5:	truncatedout = (out > 0) ? (out <  8191) ?  out[12:5] : 8'hFF
												: (out > -8192) ? -out[12:5] : 8'hFF;
			6:	truncatedout = (out > 0) ? (out <  16383)?  out[13:6] : 8'hFF
												: (out > -16384)? -out[13:6] : 8'hFF;
			7:	truncatedout = (out > 0) ? (out <  32767)?  out[14:7] : 8'hFF
												: (out > -32768)? -out[14:7] : 8'hFF;
		endcase
	end

endmodule
//////////////////////////////////////////////////