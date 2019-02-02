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

VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),
							.inclk0(CLOCK_50),
							.c0(VGA_CTRL_CLK),
							.c1(AUD_CTRL_CLK),
							.c2(VGA_CLK)	);
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

// VGA color assignments
assign 	mVGA_R = (Rsel) ? {SRAM_DQ[15:14],8'b0} : {SRAM_DQ[7:6],8'b0};
assign 	mVGA_G = (Rsel) ? {SRAM_DQ[13:10],6'b0} : {SRAM_DQ[5:2],6'b0};
assign 	mVGA_B = (Rsel) ? {SRAM_DQ[9:8],8'b0} 	: {SRAM_DQ[1:0],8'b0};

// Reset assignment
assign 	reset = ~KEY[0];		//key0 is active low


//*** Spectrogram/Bar Graph Drawing ***//

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
wire [7:0]	FFT_out;			//output from the FFT

/*	Set of Frequency Bin Buffers up to 6 entries deep for smoother updating of SRAM	*/
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
		/*** FFT Sampling Accumulator ***/
		//Has a sample just been taken?
		if (s_flag) begin
			//decrement the accumulator & clear the flag
			samp_count <= samp_count + 32'b1 - samp_time;
			s_flag <= 0;
		end else if (KEY[3]) begin
			//increment the accumulator if not paused
			samp_count <= samp_count + 32'b1;
		end
		
		if ((~VGA_HS  | ~VGA_VS)& KEY[3]) begin
			//At the start of a vertical sync, copy over to SRAM from the buffer
			if (~VGA_VS & v_sync_start) begin
				//if there still exist samples in the buffer to be copied
				if (num_samps > 0) begin
					//the copying state machine
					if (copy_state <= 0) begin
						we <= 1;
						addr_reg <= {(10'd20 + offset),1'b0,(5'd31 - freq_copy),2'b0};
						copy_state <= 1;
						
						//address correct frequency bin in SRAM
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

						// Wait for ready signal prior to switching state.
						if (ready_1)
							state <= 1;
					end
				
				1:	begin	//Cycle through till 32 freqs have been taken from the FFT
						
						case (freq_addr)	//shift in the latest sample
							0:	begin
									if (num_samps == 0) begin
										freq_bin0[7:0] <= FFT_out;
									end else begin
										freq_bin0 <= freq_bin0 | (FFT_out << {num_samps,3'b0});
									end
								end
							1:	begin
									if (num_samps == 0) begin
										freq_bin1[7:0] <= FFT_out;
									end else begin
										freq_bin1 <= freq_bin1 | (FFT_out << {num_samps,3'b0});
									end
								end
							2:	begin
									if (num_samps == 0) begin
										freq_bin2[7:0] <= FFT_out;
									end else begin
										freq_bin2 <= freq_bin2 | (FFT_out << {num_samps,3'b0});
									end
								end
							3:	begin
									if (num_samps == 0) begin
										freq_bin3[7:0] <= FFT_out;
									end else begin
										freq_bin3 <= freq_bin3 | (FFT_out << {num_samps,3'b0});
									end
								end
							4:	begin
									if (num_samps == 0) begin
										freq_bin4[7:0] <= FFT_out;
									end else begin
										freq_bin4 <= freq_bin4 | (FFT_out << {num_samps,3'b0});
									end
								end
							5:	begin
									if (num_samps == 0) begin
										freq_bin5[7:0] <= FFT_out;
									end else begin
										freq_bin5 <= freq_bin5 | (FFT_out << {num_samps,3'b0});
									end
								end
							6:	begin
									if (num_samps == 0) begin
										freq_bin6[7:0] <= FFT_out;
									end else begin
										freq_bin6 <= freq_bin6 | (FFT_out << {num_samps,3'b0});
									end
								end
							7:	begin
									if (num_samps == 0) begin
										freq_bin7[7:0] <= FFT_out;
									end else begin
										freq_bin7 <= freq_bin7 | (FFT_out << {num_samps,3'b0});
									end
								end
							8:	begin
									if (num_samps == 0) begin
										freq_bin8[7:0] <= FFT_out;
									end else begin
										freq_bin8 <= freq_bin8 | (FFT_out << {num_samps,3'b0});
									end
								end
							9:	begin
									if (num_samps == 0) begin
										freq_bin9[7:0] <= FFT_out;
									end else begin
										freq_bin9 <= freq_bin9 | (FFT_out << {num_samps,3'b0});
									end
								end
							10:	begin
									if (num_samps == 0) begin
										freq_bin10[7:0] <= FFT_out;
									end else begin
										freq_bin10 <= freq_bin10 | (FFT_out << {num_samps,3'b0});
									end
								end
							11:	begin
									if (num_samps == 0) begin
										freq_bin11[7:0] <= FFT_out;
									end else begin
										freq_bin11 <= freq_bin11 | (FFT_out << {num_samps,3'b0});
									end
								end
							12:	begin
									if (num_samps == 0) begin
										freq_bin12[7:0] <= FFT_out;
									end else begin
										freq_bin12 <= freq_bin12 | (FFT_out << {num_samps,3'b0});
									end
								end
							13:	begin
									if (num_samps == 0) begin
										freq_bin13[7:0] <= FFT_out;
									end else begin
										freq_bin13 <= freq_bin13 | (FFT_out << {num_samps,3'b0});
									end
								end
							14:	begin
									if (num_samps == 0) begin
										freq_bin14[7:0] <= FFT_out;
									end else begin
										freq_bin14 <= freq_bin14 | (FFT_out << {num_samps,3'b0});
									end
								end
							15:	begin
									if (num_samps == 0) begin
										freq_bin15[7:0] <= FFT_out;
									end else begin
										freq_bin15 <= freq_bin15 | (FFT_out << {num_samps,3'b0});
									end
								end
							16:	begin
									if (num_samps == 0) begin
										freq_bin16[7:0] <= FFT_out;
									end else begin
										freq_bin16 <= freq_bin16 | (FFT_out << {num_samps,3'b0});
									end
								end
							17:	begin
									if (num_samps == 0) begin
										freq_bin17[7:0] <= FFT_out;
									end else begin
										freq_bin17 <= freq_bin17 | (FFT_out << {num_samps,3'b0});
									end
								end
							18:	begin
									if (num_samps == 0) begin
										freq_bin18[7:0] <= FFT_out;
									end else begin
										freq_bin18 <= freq_bin18 | (FFT_out << {num_samps,3'b0});
									end
								end
							19:	begin
									if (num_samps == 0) begin
										freq_bin19[7:0] <= FFT_out;
									end else begin
										freq_bin19 <= freq_bin19 | (FFT_out << {num_samps,3'b0});
									end
								end
							20:	begin
									if (num_samps == 0) begin
										freq_bin20[7:0] <= FFT_out;
									end else begin
										freq_bin20 <= freq_bin20 | (FFT_out << {num_samps,3'b0});
									end
								end
							21:	begin
									if (num_samps == 0) begin
										freq_bin21[7:0] <= FFT_out;
									end else begin
										freq_bin21 <= freq_bin21 | (FFT_out << {num_samps,3'b0});
									end
								end
							22:	begin
									if (num_samps == 0) begin
										freq_bin22[7:0] <= FFT_out;
									end else begin
										freq_bin22 <= freq_bin22 | (FFT_out << {num_samps,3'b0});
									end
								end
							23:	begin
									if (num_samps == 0) begin
										freq_bin23[7:0] <= FFT_out;
									end else begin
										freq_bin23 <= freq_bin23 | (FFT_out << {num_samps,3'b0});
									end
								end
							24:	begin
									if (num_samps == 0) begin
										freq_bin24[7:0] <= FFT_out;
									end else begin
										freq_bin24 <= freq_bin24 | (FFT_out << {num_samps,3'b0});
									end
								end
							25:	begin
									if (num_samps == 0) begin
										freq_bin25[7:0] <= FFT_out;
									end else begin
										freq_bin25 <= freq_bin25 | (FFT_out << {num_samps,3'b0});
									end
								end
							26:	begin
									if (num_samps == 0) begin
										freq_bin26[7:0] <= FFT_out;
									end else begin
										freq_bin26 <= freq_bin26 | (FFT_out << {num_samps,3'b0});
									end
								end
							27:	begin
									if (num_samps == 0) begin
										freq_bin27[7:0] <= FFT_out;
									end else begin
										freq_bin27 <= freq_bin27 | (FFT_out << {num_samps,3'b0});
									end
								end
							28:	begin
									if (num_samps == 0) begin
										freq_bin28[7:0] <= FFT_out;
									end else begin
										freq_bin28 <= freq_bin28 | (FFT_out << {num_samps,3'b0});
									end
								end
							29:	begin
									if (num_samps == 0) begin
										freq_bin29[7:0] <= FFT_out;
									end else begin
										freq_bin29 <= freq_bin29 | (FFT_out << {num_samps,3'b0});
									end
								end
							30:	begin
									if (num_samps == 0) begin
										freq_bin30[7:0] <= FFT_out;
									end else begin
										freq_bin30 <= freq_bin30 | (FFT_out << {num_samps,3'b0});
									end
								end
							31:	begin
									if (num_samps == 0) begin
										freq_bin31[7:0] <= FFT_out;
									end else begin
										freq_bin31 <= freq_bin31 | (FFT_out << {num_samps,3'b0});
									end
								end
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
				//If VGA is in the bar graph part of the screen
				if ((coord_x > 63)&(coord_x < 576)&(coord_y > 292)&(coord_y < 419)) begin
					//x address is part of Nth bar (0-31)
					//is coord_y above bar magnitude? address normally
					//else, address spectogram[offset - 1] - the most recent SRAM entry
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
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
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
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						2:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin2[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd116};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd116};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						3:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin3[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd112};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd224};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						4:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin4[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd108};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd216};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						5:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin5[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd104};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd208};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						6:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin6[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd100};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd200};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						7:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin7[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd96};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd192};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						8:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin8[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd92};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd184};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						9:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin9[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd88};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd176};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						10:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin10[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd84};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd168};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						11:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin11[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd80};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd160};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						12:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin12[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd76};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd152};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						13:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin13[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd72};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd144};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						14:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin14[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd68};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd136};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						15:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin15[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd64};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd128};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						16:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin16[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd60};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd120};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						17:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin17[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd56};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd112};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						18:	begin
								if (coord_y > (9'd419 - {2'b0,freq_bin18[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd52};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd104};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						19:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin19[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd48};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd96};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						20:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin20[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd44};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd88};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						21:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin21[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd40};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd80};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						22:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin22[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd36};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd72};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						23:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin23[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd32};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd64};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						24:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin24[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd28};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd56};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						25:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin25[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd24};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd48};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						26:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin26[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd20};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd40};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						27:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin27[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd16};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd32};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						28:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin28[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd12};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd24};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						29:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin29[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd8};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd16};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						30:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin30[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd4};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd8};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
						31:	begin
								if (coord_y >= (9'd419 - {2'b0,freq_bin31[7:1]})) begin
									if (offset > 0)begin
										addr_reg <= {(10'd19+offset),8'd0};
										Rsel <= 0;
									end else begin
										addr_reg <= {10'd619,8'd0};
									    Rsel <=0;
									end
								end else begin
									addr_reg <= {coord_x[9:0],coord_y[8:1]};
									Rsel <= coord_y[0];	
								end
							end
				default:	begin
								addr_reg <= {coord_x[9:0],coord_y[8:1]};
								Rsel <= coord_y[0];
							end
					endcase
				end else if	((coord_x < 20)|(coord_x > 619)|(coord_y > 255)) begin	//SRAM not in spectro or bars
					addr_reg <= {coord_x[9:0],coord_y[8:1]};
					Rsel <= coord_y[0];
				end else if ((coord_x + offset) < 620)begin	//SRAM in spectro - address using offset
					addr_reg <= {(coord_x[9:0]+offset),coord_y[8:3],2'b0};
					Rsel <= 0;
				end else begin //SRAM in spectro - wrap around using offset
					addr_reg <= {(coord_x[9:0]-(10'd600 - offset)),coord_y[8:3],2'b0};
					Rsel <=0;
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

wire	signed [15:0] adc_sample;

assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

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
							.iDDS_incr({10'b0, SW[11:3], 12'b0}));

// Choose remapping (default where SW[10] is off better
wire [5:0] decimation = SW[10]  ? {freq_addr[4], 1'b0, freq_addr[2], freq_addr[3], freq_addr[0], freq_addr[1]}
								: {freq_addr[1], freq_addr[0], freq_addr[3], freq_addr[2], 1'b0, freq_addr[4]};

wire fft_ready;
reg hold_0, hold_1;
reg ready_1, ready_0;

always @ (posedge CLOCK_50)
begin
	hold_0 <= hold;
	hold_1 <= hold_0;
end

always @ (posedge VGA_CTRL_CLK)
begin
	ready_0 <= fft_ready;
	ready_1 <= ready_0;
end

// SW[12] for windowing, SW[13] for mag/sqrt, SW[15:14] for , SW[17:16] for
fft64pt_seq slowfsly	  (reset,AUD_DACLRCK, adc_sample, CLOCK_50,
					  decimation,
					  hold_1, fft_ready, FFT_out, LEDR, SW);
endmodule