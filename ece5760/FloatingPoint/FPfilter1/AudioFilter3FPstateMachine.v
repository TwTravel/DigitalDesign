// --------------------------------------------------------------------
// --------------------------------------------------------------------
//
// Major Functions:	Audio Filter modules 
//		2nd order IIR module
//		4th order IIR module
//		6th order IIR module
// Matlab pgm at end of code to convert Matlab filter to Verilog
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
// Bruce R Land, Cornell University, Nov 2007
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
							
							/*
AudioCodecControllerPE 		u4	(	//	Audio Side
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
				            .iCLK(AUD_CTRL_CLK),
							.iRST_N(DLY_RST)
							);
							*/
							
/// reset ///////////////////////////////////////////////////////						
//state machine start up	
wire reset; 
// reset control
assign reset = ~KEY[0];

/// audio stuff /////////////////////////////////////////////////
// output to audio DAC
wire signed [15:0] audio_outL, audio_outR ;
// input from audio ADC
wire signed [15:0] audio_inL, audio_inR ;
// filter outputs
wire signed [15:0] filter1_out, filter2_out, filter3_out ;

//reg signed [15:0] filter_out_buffer2 ;

// make some output
// original signal in R channel
// filtered signal in L channel
assign audio_outR = filter1_out ; 
assign audio_outL = filter2_out ;

/*//debug zero value
wire [17:0]  hexdisp, hexdisp_in ;
reg [17:0] hexdisp1 ;
always @ (negedge AUD_DACLRCK)
begin
	hexdisp1 <= (hexdisp_in[8]==0)? hexdisp : hexdisp1 ; //hexdisp[8]!=0 & 
end
HexDigit Digit0(HEX0, hexdisp1[3:0]);
HexDigit Digit1(HEX1, hexdisp1[7:4]);
HexDigit Digit2(HEX2, hexdisp1[11:8]);
HexDigit Digit3(HEX3, hexdisp1[15:12]);
HexDigit Digit4(HEX4, hexdisp1[17:16]);
*/

/*
/// PWM stuff ////////////////////////////////////////////////////
//make an LED intensity proportional to filter output
wire signed [15:0] filter1_amp ;
reg [7:0] PWM1 ;

// get the average amp (always >+0)
average f1_amp(filter1_amp, filter1_out, 8, AUD_DACLRCK);
// make the PWM
assign LEDG[0] = (PWM1>(filter1_amp[13:6]))? 0:1 ;
always @ (posedge AUD_DACLRCK) 
begin
	PWM1 <= PWM1 + 8'd1 ;
end
*/

/// Define FP filters ////////////////////////
//Filter: cutoff=0.100000 
//Filter: cutoff=0.200000 

IIR4 filter1( 
     .audio_out (filter1_out), 
     .audio_in (audio_inR), 
     .b1 (18'hF749), 
     .b2 (18'h0), 
     .b3 (18'h2F949), 
     .b4 (18'h0), 
     .b5 (18'hF749), 
     .a2 (18'h1059B), 
     .a3 (18'h3070A), 
     .a4 (18'h10548), 
     .a5 (18'h30148), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 


//Filter: cutoff=0.100000 
//Filter: cutoff=0.200000 
IIR2 filter2( 
     .audio_out (filter2_out), 
     .audio_in (audio_inR), 
     .b1 (18'hFD18), //hFD18
     .b2 (18'h0), 
     .b3 (18'h2FD18), 
     .a2 (18'h1038E), 
     .a3 (18'h30173), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk (AUD_DACLRCK), 
     .reset (reset)
) ; //end filter 

//Filter: cutoff=0.100000 
//Filter: cutoff=0.200000 
/*
IIR6 filter3( 
     .audio_out (filter3_out), 
     .audio_in (audio_inR), 
     .b1 (18'hF17B), 
     .b2 (18'h0), 
     .b3 (18'h2F51C), 
     .b4 (18'h0), 
     .b5 (18'hF51C), 
     .b6 (18'h0), 
     .b7 (18'h2F17B), 
     .a2 (18'h10736), 
     .a3 (18'h30947), 
     .a4 (18'h10981), 
     .a5 (18'h30909), 
     .a6 (18'h10597), 
     .a7 (18'h30110), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter  */

//Filter: cutoff=0.200000 
//Filter: cutoff=0.400000 
/*
IIR6 filter( 
     .audio_out (filter3_out), 
     .audio_in (audio_inR), 
     .b1 (18'hF728), 
     .b2 (18'h0), 
     .b3 (18'h2F9BC), 
     .b4 (18'h0), 
     .b5 (18'hF9BC), 
     .b6 (18'h0), 
     .b7 (18'h2F728), 
     .a2 (18'h10578), 
     .a3 (18'h3072C), 
     .a4 (18'h10728), 
     .a5 (18'h30589), 
     .a6 (18'h1033F), 
     .a7 (18'h2FF1C), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 
*/
endmodule



///////////////////////////////////////////////////////////////////
/// Second order IIR filter ///////////////////////////////////////
///////////////////////////////////////////////////////////////////
module IIR2 (audio_out, audio_in, 
			b1, b2, b3, 
			a2, a3, 
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
output wire signed [15:0] audio_out ;
// one audio sample, 16 bit, 2's complement
input wire signed [15:0] audio_in ;

// filter coefficients
input wire signed [17:0] b1, b2, b3, a2, a3 ;
input wire state_clk, lr_clk, reset ;

/// filter vars //////////////////////////////////////////////////
wire [17:0] f1_mac_new, f1_coeff_x_value ;
reg [17:0] f1_coeff, f1_mac_old, f1_value ;

// input to filter
reg [17:0] x_n ;
// input history x(n-1), x(n-2)
reg [17:0] x_n1, x_n2 ; 

// output history: y_n is the new filter output, BUT it is
// immediately stored in f1_y_n1 for the next loop through 
// the filter state machine
reg [17:0] f1_y_n1, f1_y_n2 ; 

// i/o conversion
// int output of FP calc
wire [9:0] audio_out_int ;
reg [17:0] audio_out_FP ;
wire [17:0] audio_in_FP ;
int2fp f1_input(audio_in_FP, audio_in[15:6], 0) ;
fp2int f1_output(audio_out_int, audio_out_FP, 0) ; //audio_out_FP
assign audio_out = {audio_out_int[9:0], 6'h0} ;

// MAC operation
//fpmult f1_c_x_v (f1_coeff_x_value, f1_coeff, f1_value);
fpmult f1_c_x_v (f1_coeff_x_value, f1_value, f1_coeff);
fpadd f1_mac_add (f1_mac_new, f1_mac_old, f1_coeff_x_value) ;


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
	end
	
	else begin
		case (state)
	
			1: 
			begin
				// set up b1*x(n)
				f1_mac_old <= 18'd0 ;
				f1_coeff <= b1 ;
				f1_value <= audio_in_FP ;				
				//register input
				x_n <= audio_in_FP ;				
				// next state
				state <= 4'd4;
			end
			
			
			4: 
			begin
				// set up b2*x(n-1) 
				f1_mac_old <= f1_mac_new ;
				//f1_coeff_x_value ; //f1_mac_new ; audio_in_FP
				//{audio_in_FP[17], audio_in_FP[16:9]-8'h1, audio_in_FP[8:0]};
				//audio_out_FP <= f1_coeff_x_value ;
				//test
				f1_coeff <= b2 ;
				f1_value <= x_n1 ;				
				// next state
				state <= 4'd5;
			end
			
			5:
			begin
				// set up b3*x(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b3 ;
				f1_value <= x_n2 ;			
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
				//next state 
				state <= 4'd10;
			end
			
			10: 
			begin
				// get the output 
				// and put it in the LAST output var
				// for the next pass thru the state machine
				f1_y_n1 <= f1_mac_new ; 
				audio_out_FP <= f1_mac_new ;				
				// update output history
				f1_y_n2 <= f1_y_n1 ;				
				// update input history
				x_n1 <= x_n ;
				x_n2 <= x_n1 ;
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



///////////////////////////////////////////////////////////////////
/// Fourth order IIR filter ///////////////////////////////////////
///////////////////////////////////////////////////////////////////
module IIR4 (audio_out, audio_in,  
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
output wire signed [15:0] audio_out ;
// one audio sample, 16 bit, 2's complement
input wire signed [15:0] audio_in ;

// filter coefficients
input wire [17:0] b1, b2, b3, b4, b5, a2, a3, a4, a5 ;
input wire state_clk, lr_clk, reset ;

/// filter vars //////////////////////////////////////////////////
wire [17:0] f1_mac_new, f1_coeff_x_value ;
reg [17:0] f1_coeff, f1_mac_old, f1_value ;

// input to filter
reg [17:0] x_n ;
// input history x(n-1), x(n-2)
reg [17:0] x_n1, x_n2, x_n3, x_n4 ; 

// output history: y_n is the new filter output, BUT it is
// immediately stored in f1_y_n1 for the next loop through 
// the filter state machine
reg [17:0] f1_y_n1, f1_y_n2, f1_y_n3, f1_y_n4 ; 

// i/o conversion
// int output of FP calc
wire [9:0] audio_out_int ;
reg [17:0] audio_out_FP ;
wire [17:0] audio_in_FP ;
int2fp f1_input(audio_in_FP, audio_in[15:6], 0) ;
fp2int f1_output(audio_out_int, audio_out_FP, 0) ;
assign audio_out = {audio_out_int, 6'h0} ;

// MAC operation
fpmult f1_c_x_v (f1_coeff_x_value, f1_coeff, f1_value);
fpadd f1_mac_add (f1_mac_new, f1_mac_old, f1_coeff_x_value) ;

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
	end
	
	else begin
		case (state)
	
			1: 
			begin
				// set up b1*x(n)
				f1_mac_old <= 18'd0 ;
				f1_coeff <= b1 ;
				f1_value <= audio_in_FP ;				
				//register input
				x_n <= audio_in_FP ;				
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
				f1_y_n1 <= f1_mac_new ; 
				audio_out_FP <= f1_mac_new ;				
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


///////////////////////////////////////////////////////////////////
/// Sixth order IIR filter ///////////////////////////////////////
///////////////////////////////////////////////////////////////////
module IIR6 (audio_out, audio_in,  
			b1, b2, b3, b4, b5, b6, b7,
			a2, a3, a4, a5, a6, a7,
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
output wire signed [15:0] audio_out ;
// one audio sample, 16 bit, 2's complement
input wire signed [15:0] audio_in ;

// filter coefficients
input wire signed [17:0] b1, b2, b3, b4, b5, b6, b7, a2, a3, a4, a5, a6, a7 ;
input wire state_clk, lr_clk, reset ;

/// filter vars //////////////////////////////////////////////////
wire [17:0] f1_mac_new, f1_coeff_x_value ;
reg [17:0] f1_coeff, f1_mac_old, f1_value ;

// input to filter
reg [17:0] x_n ;
// input history x(n-1), x(n-2)
reg [17:0] x_n1, x_n2, x_n3, x_n4, x_n5, x_n6 ; 

// output history: y_n is the new filter output, BUT it is
// immediately stored in f1_y_n1 for the next loop through 
// the filter state machine
reg [17:0] f1_y_n1, f1_y_n2, f1_y_n3, f1_y_n4, f1_y_n5, f1_y_n6 ; 

// i/o conversion
// int output of FP calc
wire [9:0] audio_out_int ;
reg [17:0] audio_out_FP ;
wire [17:0] audio_in_FP ;
int2fp f1_input(audio_in_FP, audio_in[15:6], 0) ;
fp2int f1_output(audio_out_int, audio_out_FP, 0) ;
assign audio_out = {audio_out_int, 6'h0} ;

// MAC operation
fpmult f1_c_x_v (f1_coeff_x_value, f1_coeff, f1_value);
fpadd f1_mac_add (f1_mac_new, f1_mac_old, f1_coeff_x_value) ;

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
	end
	
	else begin
		case (state)
	
			1: 
			begin
				// set up b1*x(n)
				f1_mac_old <= 18'd0 ;
				f1_coeff <= b1 ;
				f1_value <= audio_in_FP ;				
				//register input
				x_n <= audio_in_FP ;				
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
				// set up b6*x(n-5) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b6 ;
				f1_value <= x_n5 ;
				// next state
				state <= 4'd7;
			
			end
			
			7: 
			begin
				// set up b7*x(n-6) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b7 ;
				f1_value <= x_n6 ;
				// next state
				state <= 4'd8;
			
			end
			
			8:
			begin
				// set up -a2*y(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a2 ;
				f1_value <= f1_y_n1 ; 
				//next state 
				state <= 4'd9;
			end
			
			9: 
			begin
				// set up -a3*y(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a3 ;
				f1_value <= f1_y_n2 ; 				
				//next state 
				state <= 4'd10;
			end
			
			4'd10: 
			begin
				// set up -a4*y(n-3) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a4 ;
				f1_value <= f1_y_n3 ; 				
				//next state 
				state <= 4'd11;
			end
			
			4'd11: 
			begin
				// set up -a5*y(n-4) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a5 ;
				f1_value <= f1_y_n4 ; 				
				//next state 
				state <= 4'd12;
			end
			
			4'd12: 
			begin
				// set up -a6*y(n-5) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a6 ;
				f1_value <= f1_y_n5 ; 				
				//next state 
				state <= 4'd13;
			end
			
			13: 
			begin
				// set up -a7*y(n-6) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a7 ;
				f1_value <= f1_y_n6 ; 				
				//next state 
				state <= 4'd14;
			end
			
			14: 
			begin
				// get the output 
				// and put it in the LAST output var
				// for the next pass thru the state machine
				//mult by four because of coeff scaling
				// to prevent overflow
				f1_y_n1 <= f1_mac_new ; 
				audio_out_FP <= f1_mac_new ;				
				// update output history
				f1_y_n2 <= f1_y_n1 ;
				f1_y_n3 <= f1_y_n2 ;
				f1_y_n4 <= f1_y_n3 ;
				f1_y_n5 <= f1_y_n4 ;
				f1_y_n6 <= f1_y_n5 ;				
				// update input history
				x_n1 <= x_n ;
				x_n2 <= x_n1 ;
				x_n3 <= x_n2 ;
				x_n4 <= x_n3 ;
				x_n5 <= x_n4 ;
				x_n6 <= x_n5 ;
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

//////////////////////////////////////////////////////////
// floating point multiply 
// -- sign bit -- 8-bit exponent -- 9-bit mantissa
// Similar to fp_mult from altera
// NO denorms, no flags, no NAN, no infinity, no rounding!
//////////////////////////////////////////////////////////
// f1 = {s1, e1, m1), f2 = {s2, e2, m2)
// If either is zero (zero MSB of mantissa) then output is zero
// If e1+e2<129 the result is zero (underflow)
///////////////////////////////////////////////////////////	
module fpmult (fout, f1, f2);

	input [17:0] f1, f2 ;
	output [17:0] fout ;
	
	wire [17:0] fout ;
	reg sout ;
	reg [8:0] mout ;
	reg [8:0] eout ; // 9-bits for overflow
	
	wire s1, s2;
	wire [8:0] m1, m2 ;
	wire [8:0] e1, e2, sum_e1_e2 ; // extend to 9 bits to avoid overflow
	wire [17:0] mult_out ;	// raw multiplier output
	
	// parse f1
	assign s1 = f1[17]; 	// sign
	assign e1 = {1'b0, f1[16:9]};	// exponent
	assign m1 = f1[8:0] ;	// mantissa
	// parse f2
	assign s2 = f2[17];
	assign e2 = {1'b0, f2[16:9]};
	assign m2 = f2[8:0] ;
	
	// first step in mult is to add extended exponents
	assign sum_e1_e2 = e1 + e2 ;
	
	// build output
	// raw integer multiply
	unsigned_mult mm(mult_out, m1, m2);
	 
	// assemble output bits
	assign fout = {sout, eout[7:0], mout} ;
	
	always @(*)
	begin
		// if either is denormed or exponents are too small
		if ((m1[8]==1'd0) || (m2[8]==1'd0) || (sum_e1_e2 < 9'h82)) 
		begin 
			mout = 0;
			eout = 0;
			sout = 0; // output sign
		end
		else // both inputs are nonzero and no exponent underflow
		begin
			sout = s1 ^ s2 ; // output sign
			if (mult_out[17]==1)
			begin // MSB of product==1 implies normalized -- result >=0.5
				eout = sum_e1_e2 - 9'h80;
				mout = mult_out[17:9] ;
			end
			else // MSB of product==0 implies result <0.5, so shift ome left
			begin
				eout = sum_e1_e2 - 9'h81;
				mout = mult_out[16:8] ;
			end	
		end // nonzero mult logic
	end // always @(*)
	
endmodule

///////////////////////////////////////
// low level integer multiply
// From Altera HDL style manual
///////////////////////////////////////
module unsigned_mult (out, a, b);
	output [17:0] out;
	input [8:0] a;
	input [8:0] b;
	assign out = a * b;
endmodule


/////////////////////////////////////////////////////////////////////////////
// floating point Add 
// -- sign bit -- 8-bit exponent -- 9-bit mantissa
// NO denorms, no flags, no NAN, no infinity, no rounding!
/////////////////////////////////////////////////////////////////////////////
// f1 = {s1, e1, m1), f2 = {s2, e2, m2)
// If either input is zero (zero MSB of mantissa) then output is the remaining input.
// If either input is <(other input)/2**9 then output is the remaining input.
// Sign of the output is the sign of the greater magnitude input
// Add the two inputs if their signs are the same. 
// Subtract the two inputs (bigger-smaller) if their signs are different
//////////////////////////////////////////////////////////////////////////////	
module fpadd (fout, f1, f2);

	input [17:0] f1, f2 ;
	output [17:0] fout ;
	
	wire  [17:0] fout ;
	wire sout ;
	reg [8:0] mout ;
	reg [7:0] eout ;
	reg [9:0] shift_small, denorm_mout ; //9th bit is overflow bit
	
	wire s1, s2 ; // input signs
	reg  sb, ss ; // signs of bigger and smaller
	wire [8:0] m1, m2 ; // input mantissas
	reg  [8:0] mb, ms ; // mantissas of bigger and smaller
	wire [7:0] e1, e2 ; // input exp
	wire [7:0] ediff ;  // exponent difference
	reg  [7:0] eb, es ; // exp of bigger and smaller
	reg  [7:0] num_zeros ; // high order zeros in the difference calc
	
	// parse f1
	assign s1 = f1[17]; 	// sign
	assign e1 = f1[16:9];	// exponent
	assign m1 = f1[8:0] ;	// mantissa
	// parse f2
	assign s2 = f2[17];
	assign e2 = f2[16:9];
	assign m2 = f2[8:0] ;
	
	// find biggest magnitude
	always @(*)
	begin
		if (e1>e2) // f1 is bigger
		begin
			sb = s1 ; // the bigger number (absolute value)
			eb = e1 ;
			mb = m1 ;
			ss = s2 ; // the smaller number
			es = e2 ;
			ms = m2 ;
		end
		else if (e2>e1) //f2 is bigger
		begin
			sb = s2 ; // the bigger number (absolute value)
			eb = e2 ;
			mb = m2 ;
			ss = s1 ; // the smaller number
			es = e1 ;
			ms = m1 ;
		end
		else // e1==e2, so need to look at mantissa to determine bigger/smaller
		begin
			if (m1>m2) // f1 is bigger
			begin
				sb = s1 ; // the bigger number (absolute value)
				eb = e1 ;
				mb = m1 ;
				ss = s2 ; // the smaller number
				es = e2 ;
				ms = m2 ;
			end
			else // f2 is bigger or same size
			begin
				sb = s2 ; // the bigger number (absolute value)
				eb = e2 ;
				mb = m2 ;
				ss = s1 ; // the smaller number
				es = e1 ;
				ms = m1 ;
			end
		end
	end //found the bigger number
	
	// sign of output is the sign of the bigger (magnitude) input
	assign sout = sb ;
	// form the output
	assign fout = {sout, eout, mout} ;	
	
	// do the actual add:
	// -- equalize exponents
	// -- add/sub
	// -- normalize
	assign ediff = eb - es ; // the actual difference in exponents
	always @(*)
	begin
		if ((ms[8]==0) && (mb[8]==0))  // both inputs are zero
		begin
			mout = 9'b0 ;
			eout = 8'b0 ; 
		end
		else if ((ms[8]==0) || ediff>8)  // smaller is too small to matter
		begin
			mout = mb ;
			eout = eb ;
		end
		else  // shift/add/normalize
		begin
			// now shift but save the low order bits by extending the registers
			// need a high order bit for 1.0<sum<2.0
			shift_small = {1'b0, ms} >> ediff ;
			// same signs means add -- different means subtract
			if (sb==ss) //do the add
			begin
				denorm_mout = {1'b0, mb} + shift_small ;
				// normalize --
				// when adding result has to be 0.5<sum<2.0
				if (denorm_mout[9]==1) // sum bigger than 1
				begin
					mout = denorm_mout[9:1] ; // take the top bits (shift-right)
					eout = eb + 1 ; // compensate for the shift-right
				end
				else //0.5<sum<1.0
				begin
					mout = denorm_mout[8:0] ; // drop the top bit (no-shift-right)
					eout = eb ; // 
				end
			end // end add logic
			else // otherwise sb!=ss, so subtract
			begin
				denorm_mout = {1'b0, mb} - shift_small ;
				// the denorm_mout is always smaller then the bigger input
				// (and never an overflow, so bit 9 is always zero)
				// and can be as low as zero! Thus up to 8 shifts may be necessary
				// to normalize denorm_mout
				if (denorm_mout[8:0]==9'd0)
				begin
					mout = 9'b0 ;
					eout = 8'b0 ;
				end
				else
				begin
					// detect leading zeros
					casex (denorm_mout[8:0])
						9'b1xxxxxxxx: num_zeros = 8'd0 ;
						9'b01xxxxxxx: num_zeros = 8'd1 ;
						9'b001xxxxxx: num_zeros = 8'd2 ;
						9'b0001xxxxx: num_zeros = 8'd3 ;
						9'b00001xxxx: num_zeros = 8'd4 ;
						9'b000001xxx: num_zeros = 8'd5 ;
						9'b0000001xx: num_zeros = 8'd6 ;
						9'b00000001x: num_zeros = 8'd7 ;
						9'b000000001: num_zeros = 8'd8 ;
						default:       num_zeros = 8'd9 ;
					endcase	
					// shift out leading zeros
					// and adjust exponent
					eout = eb - num_zeros ;
					mout = denorm_mout[8:0] << num_zeros ;
				end
			end // end subtract logic
			// format the output
			//fout = {sout, eout, mout} ;	
		end // end shift/add(sub)/normailize/
	end // always @(*) to compute sum/diff	
endmodule 

/////////////////////////////////////////////////////////////////////////////
// integer to floating point  
// input: 10-bit signed integer and scale factor (-100 to +100) powers of 2
// output: -- sign bit -- 8-bit exponent -- 9-bit mantissa 
// fp_out = {sign, exp, mantissa}
// NO denorms, no flags, no NAN, no infinity, no rounding!
/////////////////////////////////////////////////////////////////////////////
module int2fp(fp_out, int_in, scale_in) ;
	input signed  [9:0] int_in ;
	input signed  [7:0] scale_in ;
	output wire [17:0] fp_out ; 
	
	wire [9:0] abs_int ;
	reg sign ;
	reg [8:0] mout ; // mantissa
	reg [7:0] eout ; // exponent
	reg [7:0] num_zeros ; // count leading zeros in input integer
	
	// get absolute value of int_in
	assign abs_int = (int_in[9])? (~int_in)+10'd1 : int_in ;
	
	// build output
	assign fp_out = {sign, eout, mout} ;
	 
	// detect leading zeros of absolute value
	// detect leading zeros
	// normalize and form exponent including leading zero shift and scaling
	always @(*)
	begin
		if (abs_int[8:0] == 0)
		begin // zero value
			eout = 0 ;
			mout = 0 ;
			sign = 0 ;
			num_zeros = 8'd0 ;
		end 
		else // not zero
		begin
			casex (abs_int[8:0])
				9'b1xxxxxxxx: num_zeros = 8'd0 ;
				9'b01xxxxxxx: num_zeros = 8'd1 ;
				9'b001xxxxxx: num_zeros = 8'd2 ;
				9'b0001xxxxx: num_zeros = 8'd3 ;
				9'b00001xxxx: num_zeros = 8'd4 ;
				9'b000001xxx: num_zeros = 8'd5 ;
				9'b0000001xx: num_zeros = 8'd6 ;
				9'b00000001x: num_zeros = 8'd7 ;
				9'b000000001: num_zeros = 8'd8 ;
				default:       num_zeros = 8'd9 ;
			endcase 
			mout = abs_int[8:0] << num_zeros ; 
			eout = scale_in + (8'h89 - num_zeros) ; // h80 is offset, h09 normalizes
			sign = int_in[9] ;
		end // if int_in!=0
	end // always @
	
endmodule

/////////////////////////////////////////////////////////////////////////////
// floating point to integer 
// output: 10-bit signed integer 
// input: -- sign bit -- 8-bit exponent -- 9-bit mantissa 
// and scale factor (-100 to +100) powers of 2
// fp_out = {sign, exp, mantissa}
// NO denorms, no flags, no NAN, no infinity, no rounding!
/////////////////////////////////////////////////////////////////////////////
module fp2int(int_out, fp_in, scale_in) ;
	output signed  [9:0] int_out ;
	input signed  [7:0] scale_in ;
	input wire [17:0] fp_in ; 
	
	wire [9:0] abs_int ;
	wire sign ;
	wire [8:0] m_in ; // mantissa
	wire [7:0] e_in ; // exponent
	
	//reg [7:0] num_zeros ; // count leading zeros in input integer
	
	assign sign = (m_in[8])? fp_in[17] : 1'h0 ;
	assign m_in = fp_in[8:0] ;
	assign e_in = fp_in[16:9] ;
	//
	assign abs_int = (e_in>8'h80)? (m_in >> (8'h89 - e_in)) : 10'd0 ;
	//assign int_out = (m_in[8])? {sign, (sign? (~abs_int)+9'd1 : abs_int)} : 10'd0 ;
	
	assign int_out = (sign? (~abs_int)+10'd1 : abs_int)  ;
	//assign int_out = {sign, sign? (~abs_int)+9'd1 : abs_int}  ;
endmodule
/////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////
//// Time weighted average amplitude (2'comp) 
///////////////////////////////////////////////////////
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
/////////////////////////////////////////////////////////
module average (out, in, dk_const, clk);

	output reg signed [15:0] out ;
	input wire signed [15:0] in ;
	input wire [3:0] dk_const ;
	input wire clk;
	
	wire signed  [17:0] new_out ;
	//first order lowpass of absolute value of input
	assign new_out = out - (out>>>dk_const) + ((in[15]?-in:in)>>>dk_const) ;
	always @(posedge clk)
	begin
		 out <= new_out ;
	end
endmodule
//////////////////////////////////////////////////

//////////////////////////////////////////////
// Decode one hex digit for LED 7-seg display
module HexDigit(segs, num);
	input [3:0] num	;		//the hex digit to be displayed
	output [6:0] segs ;		//actual LED segments
	reg [6:0] segs ;
	always @ (num)
	begin
		case (num)
				4'h0: segs = 7'b1000000;
				4'h1: segs = 7'b1111001;
				4'h2: segs = 7'b0100100;
				4'h3: segs = 7'b0110000;
				4'h4: segs = 7'b0011001;
				4'h5: segs = 7'b0010010;
				4'h6: segs = 7'b0000010;
				4'h7: segs = 7'b1111000;
				4'h8: segs = 7'b0000000;
				4'h9: segs = 7'b0010000;
				4'ha: segs = 7'b0001000;
				4'hb: segs = 7'b0000011;
				4'hc: segs = 7'b1000110;
				4'hd: segs = 7'b0100001;
				4'he: segs = 7'b0000110;
				4'hf: segs = 7'b0001110;
				default segs = 7'b1111111;
		endcase
	end
endmodule
///////////////////////////////////////////////
/*
*/