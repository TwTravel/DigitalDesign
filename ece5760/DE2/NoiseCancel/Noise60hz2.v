//
//
// --------------------------------------------------------------------
//
// Major Function: Implement LMS adaptive filter with 4 taps
// to cancel two spectal noise components for 60 Hz noise
// with 3rd harmonic distortion (line noise from electric mains)
// 
// Bruce Land, Cornell University, Oct 2007, BRL4@cornell.edu
//
// --------------------------------------------------------------------


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
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digit 0
		HEX1,							//	Seven Segment Digit 1
		HEX2,							//	Seven Segment Digit 2
		HEX3,							//	Seven Segment Digit 3
		HEX4,							//	Seven Segment Digit 4
		HEX5,							//	Seven Segment Digit 5
		HEX6,							//	Seven Segment Digit 6
		HEX7,							//	Seven Segment Digit 7
		////////////////////////	LED		////////////////////////
		LEDG,							//	LED Green[8:0]
		LEDR,							//	LED Red[17:0]
		////////////////////////	UART	////////////////////////
		UART_TXD,						//	UART Transmitter
		UART_RXD,						//	UART Receiver
		////////////////////////	IRDA	////////////////////////
		IRDA_TXD,						//	IRDA Transmitter
		IRDA_RXD,						//	IRDA Receiver
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,						//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
		DRAM_UDQM,						//	SDRAM High-byte Data Mask
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA_0,						//	SDRAM Bank Address 0
		DRAM_BA_1,						//	SDRAM Bank Address 0
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	Flash Interface		////////////////
		FL_DQ,							//	FLASH Data bus 8 Bits
		FL_ADDR,						//	FLASH Address bus 22 Bits
		FL_WE_N,						//	FLASH Write Enable
		FL_RST_N,						//	FLASH Reset
		FL_OE_N,						//	FLASH Output Enable
		FL_CE_N,						//	FLASH Chip Enable
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,						//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Address bus 18 Bits
		SRAM_UB_N,						//	SRAM High-byte Data Mask 
		SRAM_LB_N,						//	SRAM Low-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		////////////////////	ISP1362 Interface	////////////////
		OTG_DATA,						//	ISP1362 Data bus 16 Bits
		OTG_ADDR,						//	ISP1362 Address 2 Bits
		OTG_CS_N,						//	ISP1362 Chip Select
		OTG_RD_N,						//	ISP1362 Write
		OTG_WR_N,						//	ISP1362 Read
		OTG_RST_N,						//	ISP1362 Reset
		OTG_FSPEED,						//	USB Full Speed,	0 = Enable, Z = Disable
		OTG_LSPEED,						//	USB Low Speed, 	0 = Enable, Z = Disable
		OTG_INT0,						//	ISP1362 Interrupt 0
		OTG_INT1,						//	ISP1362 Interrupt 1
		OTG_DREQ0,						//	ISP1362 DMA Request 0
		OTG_DREQ1,						//	ISP1362 DMA Request 1
		OTG_DACK0_N,					//	ISP1362 DMA Acknowledge 0
		OTG_DACK1_N,					//	ISP1362 DMA Acknowledge 1
		////////////////////	LCD Module 16X2		////////////////
		LCD_ON,							//	LCD Power ON/OFF
		LCD_BLON,						//	LCD Back Light ON/OFF
		LCD_RW,							//	LCD Read/Write Select, 0 = Write, 1 = Read
		LCD_EN,							//	LCD Enable
		LCD_RS,							//	LCD Command/Data Select, 0 = Command, 1 = Data
		LCD_DATA,						//	LCD Data bus 8 bits
		////////////////////	SD_Card Interface	////////////////
		SD_DAT,							//	SD Card Data
		SD_DAT3,						//	SD Card Data 3
		SD_CMD,							//	SD Card Command Signal
		SD_CLK,							//	SD Card Clock
		////////////////////	USB JTAG link	////////////////////
		TDI,  							// CPLD -> FPGA (data in)
		TCK,  							// CPLD -> FPGA (clk)
		TCS,  							// CPLD -> FPGA (CS)
	    TDO,  							// FPGA -> CPLD (data out)
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		I2C_SCLK,						//	I2C Clock
		////////////////////	PS2		////////////////////////////
		PS2_DAT,						//	PS2 Data
		PS2_CLK,						//	PS2 Clock
		////////////////////	VGA		////////////////////////////
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		////////////	Ethernet Interface	////////////////////////
		ENET_DATA,						//	DM9000A DATA bus 16Bits
		ENET_CMD,						//	DM9000A Command/Data Select, 0 = Command, 1 = Data
		ENET_CS_N,						//	DM9000A Chip Select
		ENET_WR_N,						//	DM9000A Write
		ENET_RD_N,						//	DM9000A Read
		ENET_RST_N,						//	DM9000A Reset
		ENET_INT,						//	DM9000A Interrupt
		ENET_CLK,						//	DM9000A Clock 25 MHz
		////////////////	Audio CODEC		////////////////////////
		AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
		AUD_ADCDAT,						//	Audio CODEC ADC Data
		AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
		AUD_DACDAT,						//	Audio CODEC DAC Data
		AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
		AUD_XCK,						//	Audio CODEC Chip Clock
		////////////////	TV Decoder		////////////////////////
		TD_DATA,    					//	TV Decoder Data bus 8 bits
		TD_HS,							//	TV Decoder H_SYNC
		TD_VS,							//	TV Decoder V_SYNC
		TD_RESET,						//	TV Decoder Reset
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0
		GPIO_1							//	GPIO Connection 1
	);

////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_27;				//	27 MHz
input			CLOCK_50;				//	50 MHz
input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	SW;						//	Toggle Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
output	[6:0]	HEX4;					//	Seven Segment Digit 4
output	[6:0]	HEX5;					//	Seven Segment Digit 5
output	[6:0]	HEX6;					//	Seven Segment Digit 6
output	[6:0]	HEX7;					//	Seven Segment Digit 7
////////////////////////////	LED		////////////////////////////
output	[8:0]	LEDG;					//	LED Green[8:0]
output	[17:0]	LEDR;					//	LED Red[17:0]
////////////////////////////	UART	////////////////////////////
output			UART_TXD;				//	UART Transmitter
input			UART_RXD;				//	UART Receiver
////////////////////////////	IRDA	////////////////////////////
output			IRDA_TXD;				//	IRDA Transmitter
input			IRDA_RXD;				//	IRDA Receiver
///////////////////////		SDRAM Interface	////////////////////////
inout	[15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
output	[11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
output			DRAM_WE_N;				//	SDRAM Write Enable
output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
output			DRAM_CS_N;				//	SDRAM Chip Select
output			DRAM_BA_0;				//	SDRAM Bank Address 0
output			DRAM_BA_1;				//	SDRAM Bank Address 0
output			DRAM_CLK;				//	SDRAM Clock
output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////
inout	[7:0]	FL_DQ;					//	FLASH Data bus 8 Bits
output	[21:0]	FL_ADDR;				//	FLASH Address bus 22 Bits
output			FL_WE_N;				//	FLASH Write Enable
output			FL_RST_N;				//	FLASH Reset
output			FL_OE_N;				//	FLASH Output Enable
output			FL_CE_N;				//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
inout	[15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
output	[17:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
output			SRAM_UB_N;				//	SRAM High-byte Data Mask
output			SRAM_LB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_WE_N;				//	SRAM Write Enable
output			SRAM_CE_N;				//	SRAM Chip Enable
output			SRAM_OE_N;				//	SRAM Output Enable
////////////////////	ISP1362 Interface	////////////////////////
inout	[15:0]	OTG_DATA;				//	ISP1362 Data bus 16 Bits
output	[1:0]	OTG_ADDR;				//	ISP1362 Address 2 Bits
output			OTG_CS_N;				//	ISP1362 Chip Select
output			OTG_RD_N;				//	ISP1362 Write
output			OTG_WR_N;				//	ISP1362 Read
output			OTG_RST_N;				//	ISP1362 Reset
output			OTG_FSPEED;				//	USB Full Speed,	0 = Enable, Z = Disable
output			OTG_LSPEED;				//	USB Low Speed, 	0 = Enable, Z = Disable
input			OTG_INT0;				//	ISP1362 Interrupt 0
input			OTG_INT1;				//	ISP1362 Interrupt 1
input			OTG_DREQ0;				//	ISP1362 DMA Request 0
input			OTG_DREQ1;				//	ISP1362 DMA Request 1
output			OTG_DACK0_N;			//	ISP1362 DMA Acknowledge 0
output			OTG_DACK1_N;			//	ISP1362 DMA Acknowledge 1
////////////////////	LCD Module 16X2	////////////////////////////
inout	[7:0]	LCD_DATA;				//	LCD Data bus 8 bits
output			LCD_ON;					//	LCD Power ON/OFF
output			LCD_BLON;				//	LCD Back Light ON/OFF
output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
output			LCD_EN;					//	LCD Enable
output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
////////////////////	SD Card Interface	////////////////////////
inout			SD_DAT;					//	SD Card Data
inout			SD_DAT3;				//	SD Card Data 3
inout			SD_CMD;					//	SD Card Command Signal
output			SD_CLK;					//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
inout			I2C_SDAT;				//	I2C Data
output			I2C_SCLK;				//	I2C Clock
////////////////////////	PS2		////////////////////////////////
input		 	PS2_DAT;				//	PS2 Data
input			PS2_CLK;				//	PS2 Clock
////////////////////	USB JTAG link	////////////////////////////
input  			TDI;					// CPLD -> FPGA (data in)
input  			TCK;					// CPLD -> FPGA (clk)
input  			TCS;					// CPLD -> FPGA (CS)
output 			TDO;					// FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK;				//	VGA BLANK
output			VGA_SYNC;				//	VGA SYNC
output	[9:0]	VGA_R;   				//	VGA Red[9:0]
output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
////////////////	Ethernet Interface	////////////////////////////
inout	[15:0]	ENET_DATA;				//	DM9000A DATA bus 16Bits
output			ENET_CMD;				//	DM9000A Command/Data Select, 0 = Command, 1 = Data
output			ENET_CS_N;				//	DM9000A Chip Select
output			ENET_WR_N;				//	DM9000A Write
output			ENET_RD_N;				//	DM9000A Read
output			ENET_RST_N;				//	DM9000A Reset
input			ENET_INT;				//	DM9000A Interrupt
output			ENET_CLK;				//	DM9000A Clock 25 MHz
////////////////////	Audio CODEC		////////////////////////////
output			AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			AUD_ADCDAT;				//	Audio CODEC ADC Data
output			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT;				//	Audio CODEC DAC Data
output			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK;				//	Audio CODEC Chip Clock
////////////////////	TV Devoder		////////////////////////////
input	[7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
input			TD_HS;					//	TV Decoder H_SYNC
input			TD_VS;					//	TV Decoder V_SYNC
output			TD_RESET;				//	TV Decoder Reset
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1

//	LCD ON
assign	LCD_ON		=	1'b0;
assign	LCD_BLON	=	1'b0;

//	All inout port turn to tri-state
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ		=	8'hzz;
assign	SRAM_DQ		=	16'hzzzz;
assign	OTG_DATA	=	16'hzzzz;
assign	SD_DAT		=	1'bz;
assign	ENET_DATA	=	16'hzzzz;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;

wire	VGA_CTRL_CLK;
wire	AUD_CTRL_CLK;
wire	DLY_RST;

assign	TD_RESET	=	1'b1;	//	Allow 27 MHz
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);

I2C_AV_Config 		u3	(	//	Host Side
							.iCLK(CLOCK_50),
							.iRST_N(KEY[0]),
							//	I2C Side
							.I2C_SCLK(I2C_SCLK),
							.I2C_SDAT(I2C_SDAT)	);

AUDIO_DAC_ADC 			u4	(	//	Audio Side
							.oAUD_BCK(AUD_BCLK),
							.oAUD_DATA(AUD_DACDAT),
							.oAUD_LRCK(AUD_DACLRCK),
							.oAUD_inL(audio_inL), // audio data from ADC 
							.oAUD_inR(audio_inR), // audio data from ADC 
							.iAUD_ADCDAT(AUD_ADCDAT),
							.iAUD_extL(audio_outL), // audio data to DAC
							.iAUD_extR(audio_outR), // audio data to DAC
							//	Control Signals
							//.iSrc_Select(SW[17]),
				            .iCLK_18_4(AUD_CTRL_CLK),
							.iRST_N(DLY_RST)
							);

/// reset //////////////////////////////////////						
//state machine start up	
wire reset; 
// reset control
assign reset = ~KEY[0];
///////////////////////////////////////////////

// state variable 
reg [3:0] state ;
// debug readout
assign LEDG[3:0] = state;

//oneshot state var to sync to audio clock
reg last_clk ; 

// oneshot state var to lock out weight update until buffer is full
reg buffer_full ;

/// audio stuff /////////////////////////////////
// output to audio DAC
wire signed [15:0] audio_outL, audio_outR ;

// input from audio ADC
wire signed [15:0] audio_inL, audio_inR;	
// make some output
// original signal in R channel
// denoised signal in L channel
// audio seems to negate signal, so invert it
assign audio_outR = -audio_inR ;
assign audio_outL = -error_out[17:2];	

/// memorys for delay shifter /////////////////////////////////////////
// memory control for THREE different memories
// with different circular buffer lengths
reg we; //write enable--active high
wire [15:0] read_data2, read_data3, read_data4 ; 
reg [15:0]  write_data2, write_data3, write_data4 ;
reg [7:0]   addr_reg2, addr_reg3, addr_reg4 ;
//pointers into three circular buffers
reg [7:0] ptr_in2, ptr_out2, ptr_in3, ptr_out3, ptr_in4, ptr_out4 ; 
//make the phase shift register
ram_infer Delay2(read_data2, addr_reg2, write_data2, we, CLOCK_50);
ram_infer Delay3(read_data3, addr_reg3, write_data3, we, CLOCK_50);
ram_infer Delay4(read_data4, addr_reg4, write_data4, we, CLOCK_50);	
// debug readout
assign LEDR[7:0] = ptr_out2;	
//////////////////////////////////////////////////////////////////////


/// LMS /////////////////////////////////////////////////////////////
// LMS registers
// 4 weights, two frequencies
reg signed [17:0] w1, w2, w3, w4;
wire signed [17:0] new_w1, new_w2, new_w3, new_w4;
// 4 shfited inputs
reg signed [17:0] ref60, shifted2_ref60 , shifted3_ref60, shifted4_ref60 ;
// error output (main output)
wire signed [17:0] error_out ;
// four product terms
wire signed [17:0] w1_x_ref, w2_x_shifted2, w3_x_shifted3, w4_x_shifted4 ;
// mult for weight times ref and weight times phase-shifted ref
signed_mult w1xRef(w1_x_ref, w1, ref60);
signed_mult w2xRefShifted2(w2_x_shifted2, w2, shifted2_ref60) ;
signed_mult w2xRefShifted3(w3_x_shifted3, w3, shifted3_ref60) ;
signed_mult w2xRefShifted4(w4_x_shifted4, w4, shifted4_ref60) ;
//assume noisy signal is on right channel, ref on left channel
assign error_out = {audio_inR, 2'h0} - (w1_x_ref + w2_x_shifted2 + w3_x_shifted3 + w4_x_shifted4);
assign new_w1 = w1 + (((ref60[17])? -error_out : error_out)>>>10) ;
assign new_w2 = w2 + (((shifted2_ref60[17])? -error_out : error_out)>>>10) ;
assign new_w3 = w3 + (((shifted3_ref60[17])? -error_out : error_out)>>>10) ;
assign new_w4 = w4 + (((shifted4_ref60[17])? -error_out : error_out)>>>10) ;
//////////////////////////////////////////////////////////////////////

/// State machine ///////////////////////////////////////////////////
//Run the state machine FAST so that it completes in one 
//audio cycle
always @ (posedge CLOCK_50)
begin
	if (reset)
	begin
		ptr_out2 <= 8'h1 ; // beginning of shift register
		ptr_in2 <= 8'h0 ;
		ptr_out3 <= 8'h1 ; // beginning of shift register
		ptr_in3 <= 8'h0 ;
		ptr_out4 <= 8'h1 ; // beginning of shift register
		ptr_in4 <= 8'h0 ;
		we <= 1'h0 ; 		// set to read
		state <= 4'd8 ; 	//turn off the state machine	
		buffer_full <= 1'h0 ;//interlock to cause buffer to fill before weights change
		w1 <= 18'h0 ;
		w2 <= 18'h0 ;
		w3 <= 18'h0 ;
		w4 <= 18'h0 ;
		//last_clk <= 1'h1;
	end
	
	else begin
		case (state)
	
			1: 
			begin
				// set up read ptr_out data
				addr_reg2 <= ptr_out2;
				addr_reg3 <= ptr_out3;
				addr_reg4 <= ptr_out4;
				we <= 1'h0;
				// make some output
				// original signal in R channel
				// denoised signal in L channel
				// audio seems to negate signal, so invert it
				//audio_outR <= -audio_inR ;
				//audio_outL <= -error_out[17:2];
				// next state
				state <= 4'd2;
			end
	
			2: 
			begin
				//get ptr_out data
				shifted2_ref60 <= {read_data2, 2'h0} ;
				shifted3_ref60 <= {read_data3, 2'h0} ;
				shifted4_ref60 <= {read_data4, 2'h0} ;
					
				// set up write ptr_in data
				addr_reg2 <= ptr_in2;
				addr_reg3 <= ptr_in3;
				addr_reg4 <= ptr_in4;
				we <= 1'h1;
				write_data2 <= audio_inL ;
				write_data3 <= audio_inL ;
				write_data4 <= audio_inL ;
				
				// store current ref channel
				ref60 <= {audio_inL, 2'h0} ;
				
				// make some output
				// original signal in R channel
				// denoised signal in L channel
				// audio seems to negate signal, so invert it
				//audio_outR <= -audio_inR ;
				//audio_outL <= -error_out[17:2];
				
				// next state
				state <= 4'd7;
			end
			
			7:
			begin
				state <= 4'd3;
				we <= 1'h1;
			end
			
			3:
			begin
				// turn off memory write
				we <= 1'h0;
				// update weights w = w + mu*ref*sign(error)
				
				if (buffer_full == 1'h1)
				begin
					w1 <= new_w1 ;
					w2 <= new_w2 ;
					w3 <= new_w3 ;
					w4 <= new_w4 ;
				end
				
				// next state
				state <= 4'd5;
			end
			
			
			5: 
			begin
				// phase shifter pointer control
				// update write pointer
				if (ptr_in2 == 8'd200) //200 1/4 cycle at 60 Hz
				begin
					ptr_in2 <= 8'h0;
					buffer_full <= 1'h1 ; // ready to modify weights
				end
				else
					ptr_in2 <= ptr_in2 + 8'h1 ;
					
				// update read pointer
				if (ptr_out2 == 8'd200)
					ptr_out2 <= 8'h0;
				else
					ptr_out2 <= ptr_out2 + 8'h1 ;
					
				// update write pointer
				if (ptr_in3 == 8'd133) //133 is 1/6 cycle
					ptr_in3 <= 8'h0;
				else
					ptr_in3 <= ptr_in3 + 8'h1 ;
					
				// update read pointer
				if (ptr_out3 == 8'd133)
					ptr_out3 <= 8'h0;
				else
					ptr_out3 <= ptr_out3 + 8'h1 ;
					
				// update write pointer
				if (ptr_in4 == 8'd67) //67 is 1/12 cycle
					ptr_in4 <= 8'h0;
				else
					ptr_in4 <= ptr_in4 + 8'h1 ;
					
				// update read pointer
				if (ptr_out4 == 8'd67)
					ptr_out4 <= 8'h0;
				else
					ptr_out4 <= ptr_out4 + 8'h1 ;
				
				//next state is end state
				state <= 4'd8;
			end
			
			8:
			begin
				// wait for the audio clock and one-shot it
				if (AUD_DACLRCK && last_clk==1)
				begin
					state <= 4'd1 ;
					last_clk <= 1'h0 ;
				end
				// reset the one-shot memory
				else if (~AUD_DACLRCK && last_clk==0)
				begin
					last_clk <= 1'h1 ;
				end	
			end
			
			default:
			begin
				// default state is end state
				state <= 4'd8 ;
			end
		endcase
	end
end	
/// end statemachine //////////////////////////////////////////////////
endmodule

//////////////////////////////////////////////////
//// M4k ram for circular buffer /////////////////
//////////////////////////////////////////////////
// Synchronous RAM 
// modified for 16 bit access
// of 200 words to tune for 1/4 cycle at 60 Hz
module ram_infer (q, a, d, we, clk);
output reg  [15:0] q;
input [15:0] d;
input [7:0] a;
input we, clk;
 
reg [15:0] mem [255:0];
	always @ (negedge clk) 
	begin
		if (we) mem[a] <= d;
		q <= mem[a] ;
	end
endmodule 
//////////////////////////////////////////////////


//////////////////////////////////////////////////
//// signed mult of 2.16 format 2'comp////////////
//////////////////////////////////////////////////
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