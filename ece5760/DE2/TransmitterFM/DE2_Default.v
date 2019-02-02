// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE2 Default Bitstream
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Chen       :| 05/08/19  :|      Initial Revision
//   V1.1 :| Sean Peng         :| 05/09/30  :|      Changed CLOCK, SW, LEDG/R
//                                                  according to Zvonko's requests.
//   V1.2 :| Johnny Chen       :| 05/11/16  :|      Add to FLASH Address FL_ADDR[21:20]
//   V1.3 :| Johnny Chen       :| 05/12/12  :|      Fixed VGA_Audio_PLL Initial Sequence.
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

//DDS hardware
reg [31:0] DDS_accum;
wire [9:0] sq_out;
reg [31:0] DDS_accum_mod;
wire [9:0] mod_out;

wire signed [15:0] modulation;
wire [19:0] scaled_mod;
//bogus clock
wire VGA_CLK_c2;

Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK_c2)	);


I2C_AV_Config 		u3	(	//	Host Side
							.iCLK(CLOCK_50),
							.iRST_N(KEY[0]),
							//	I2C Side
							.I2C_SCLK(I2C_SCLK),
							.I2C_SDAT(I2C_SDAT)	);

//set up DDS frequency
//Use switches to set freq

AUDIO_DAC_ADC 			u4	(	//	Audio Side
							.oAUD_BCK(AUD_BCLK),
							.oAUD_DATA(AUD_DACDAT),
							.oAUD_LRCK(AUD_DACLRCK),
							.iAUD_ADCDAT(AUD_ADCDAT),
							//	Control Signals
							.iSrc_Select(SW[17]),
				            .iCLK_18_4(AUD_CTRL_CLK),
							.iRST_N(DLY_RST),
							.modulation(modulation)
							);


	//make a direct digital systnesis accumulator 
	// and output the top 8 bits to connector JP1
	// and output a 10-bit sine wave to the VGA plug
	// set carrier frequency to 1 MHz DDS_incr = 32'h51EB84C
	// 11 MHz 32'h3851DCA8
	// 9 MHz 2DF8F778 : 4.5 16FC7BBC
	// 7 Mhz 274AF224
	// set modulation to 400 Hz 85E7
	always @ (posedge CLOCK_50) begin
		//generate 4.5 Mhz square wave carrier with FM modulation
		DDS_accum <= DDS_accum + 32'h16FC7BBC + 
				((SW[1])?  //Choose: sine wave/audio input
				(mod_out<<15) : 
				(256+((modulation[15]==0)? modulation[15:7]+256 : modulation[15:7]-256))<<15) ;
		// generate 400/800 Hz
		DDS_accum_mod = DDS_accum_mod + ((SW[0])? 32'hF5E7 : 32'h85E7) ;
	end
	
	//hook up the ROM table for carrier
	sqwave sqTable(CLOCK_50, DDS_accum[31:24], sq_out);
	
	//hook up the ROM table for 400 Hz modulation
	sync_rom modTable(CLOCK_50, DDS_accum_mod[31:24], mod_out);
	
	//use the VGA DAC for an FM modulated RF signal 
	assign VGA_R = sq_out;
	assign VGA_SYNC = 1 ;
	assign VGA_BLANK = 1 ;
	assign VGA_CLK = CLOCK_50 ;
	
endmodule

//////////////////////////////////////////////////
// Square wave table for the DDS
module sqwave (clock, address, sq);
	input clock;
	input [7:0] address;
	output [9:0] sq;
	reg [9:0] sq;
	always @ (posedge clock)
	begin
		sq <= (address<128)? 10'h1ff : 10'h001 ;
	end
endmodule
				
//////////////////////////////////////////////////
// Infer ROM storage
// for a sin table for the DDS

module sync_rom (clock, address, sine);
	input clock;
	input [7:0] address;
	output [9:0] sine;
	reg [9:0] sine;
	always @ (posedge clock)
	begin
		case (address)
			8'h00: sine = 10'h100 ;
			8'h01: sine = 10'h106 ;
			8'h02: sine = 10'h10c ;
			8'h03: sine = 10'h112 ;
			8'h04: sine = 10'h118 ;
			8'h05: sine = 10'h11f ;
			8'h06: sine = 10'h125 ;
			8'h07: sine = 10'h12b ;
			8'h08: sine = 10'h131 ;
			8'h09: sine = 10'h137 ;
			8'h0a: sine = 10'h13d ;
			8'h0b: sine = 10'h144 ;
			8'h0c: sine = 10'h14a ;
			8'h0d: sine = 10'h14f ;
			8'h0e: sine = 10'h155 ;
			8'h0f: sine = 10'h15b ;
			8'h10: sine = 10'h161 ;
			8'h11: sine = 10'h167 ;
			8'h12: sine = 10'h16d ;
			8'h13: sine = 10'h172 ;
			8'h14: sine = 10'h178 ;
			8'h15: sine = 10'h17d ;
			8'h16: sine = 10'h183 ;
			8'h17: sine = 10'h188 ;
			8'h18: sine = 10'h18d ;
			8'h19: sine = 10'h192 ;
			8'h1a: sine = 10'h197 ;
			8'h1b: sine = 10'h19c ;
			8'h1c: sine = 10'h1a1 ;
			8'h1d: sine = 10'h1a6 ;
			8'h1e: sine = 10'h1ab ;
			8'h1f: sine = 10'h1af ;
			8'h20: sine = 10'h1b4 ;
			8'h21: sine = 10'h1b8 ;
			8'h22: sine = 10'h1bc ;
			8'h23: sine = 10'h1c1 ;
			8'h24: sine = 10'h1c5 ;
			8'h25: sine = 10'h1c9 ;
			8'h26: sine = 10'h1cc ;
			8'h27: sine = 10'h1d0 ;
			8'h28: sine = 10'h1d4 ;
			8'h29: sine = 10'h1d7 ;
			8'h2a: sine = 10'h1da ;
			8'h2b: sine = 10'h1dd ;
			8'h2c: sine = 10'h1e0 ;
			8'h2d: sine = 10'h1e3 ;
			8'h2e: sine = 10'h1e6 ;
			8'h2f: sine = 10'h1e9 ;
			8'h30: sine = 10'h1eb ;
			8'h31: sine = 10'h1ed ;
			8'h32: sine = 10'h1f0 ;
			8'h33: sine = 10'h1f2 ;
			8'h34: sine = 10'h1f4 ;
			8'h35: sine = 10'h1f5 ;
			8'h36: sine = 10'h1f7 ;
			8'h37: sine = 10'h1f8 ;
			8'h38: sine = 10'h1fa ;
			8'h39: sine = 10'h1fb ;
			8'h3a: sine = 10'h1fc ;
			8'h3b: sine = 10'h1fd ;
			8'h3c: sine = 10'h1fd ;
			8'h3d: sine = 10'h1fe ;
			8'h3e: sine = 10'h1fe ;
			8'h3f: sine = 10'h1fe ;
			8'h40: sine = 10'h1ff ;
			8'h41: sine = 10'h1fe ;
			8'h42: sine = 10'h1fe ;
			8'h43: sine = 10'h1fe ;
			8'h44: sine = 10'h1fd ;
			8'h45: sine = 10'h1fd ;
			8'h46: sine = 10'h1fc ;
			8'h47: sine = 10'h1fb ;
			8'h48: sine = 10'h1fa ;
			8'h49: sine = 10'h1f8 ;
			8'h4a: sine = 10'h1f7 ;
			8'h4b: sine = 10'h1f5 ;
			8'h4c: sine = 10'h1f4 ;
			8'h4d: sine = 10'h1f2 ;
			8'h4e: sine = 10'h1f0 ;
			8'h4f: sine = 10'h1ed ;
			8'h50: sine = 10'h1eb ;
			8'h51: sine = 10'h1e9 ;
			8'h52: sine = 10'h1e6 ;
			8'h53: sine = 10'h1e3 ;
			8'h54: sine = 10'h1e0 ;
			8'h55: sine = 10'h1dd ;
			8'h56: sine = 10'h1da ;
			8'h57: sine = 10'h1d7 ;
			8'h58: sine = 10'h1d4 ;
			8'h59: sine = 10'h1d0 ;
			8'h5a: sine = 10'h1cc ;
			8'h5b: sine = 10'h1c9 ;
			8'h5c: sine = 10'h1c5 ;
			8'h5d: sine = 10'h1c1 ;
			8'h5e: sine = 10'h1bc ;
			8'h5f: sine = 10'h1b8 ;
			8'h60: sine = 10'h1b4 ;
			8'h61: sine = 10'h1af ;
			8'h62: sine = 10'h1ab ;
			8'h63: sine = 10'h1a6 ;
			8'h64: sine = 10'h1a1 ;
			8'h65: sine = 10'h19c ;
			8'h66: sine = 10'h197 ;
			8'h67: sine = 10'h192 ;
			8'h68: sine = 10'h18d ;
			8'h69: sine = 10'h188 ;
			8'h6a: sine = 10'h183 ;
			8'h6b: sine = 10'h17d ;
			8'h6c: sine = 10'h178 ;
			8'h6d: sine = 10'h172 ;
			8'h6e: sine = 10'h16d ;
			8'h6f: sine = 10'h167 ;
			8'h70: sine = 10'h161 ;
			8'h71: sine = 10'h15b ;
			8'h72: sine = 10'h155 ;
			8'h73: sine = 10'h14f ;
			8'h74: sine = 10'h14a ;
			8'h75: sine = 10'h144 ;
			8'h76: sine = 10'h13d ;
			8'h77: sine = 10'h137 ;
			8'h78: sine = 10'h131 ;
			8'h79: sine = 10'h12b ;
			8'h7a: sine = 10'h125 ;
			8'h7b: sine = 10'h11f ;
			8'h7c: sine = 10'h118 ;
			8'h7d: sine = 10'h112 ;
			8'h7e: sine = 10'h10c ;
			8'h7f: sine = 10'h106 ;
			8'h80: sine = 10'h100 ;
			8'h81: sine = 10'h0f9 ;
			8'h82: sine = 10'h0f3 ;
			8'h83: sine = 10'h0ed ;
			8'h84: sine = 10'h0e7 ;
			8'h85: sine = 10'h0e0 ;
			8'h86: sine = 10'h0da ;
			8'h87: sine = 10'h0d4 ;
			8'h88: sine = 10'h0ce ;
			8'h89: sine = 10'h0c8 ;
			8'h8a: sine = 10'h0c2 ;
			8'h8b: sine = 10'h0bb ;
			8'h8c: sine = 10'h0b5 ;
			8'h8d: sine = 10'h0b0 ;
			8'h8e: sine = 10'h0aa ;
			8'h8f: sine = 10'h0a4 ;
			8'h90: sine = 10'h09e ;
			8'h91: sine = 10'h098 ;
			8'h92: sine = 10'h092 ;
			8'h93: sine = 10'h08d ;
			8'h94: sine = 10'h087 ;
			8'h95: sine = 10'h082 ;
			8'h96: sine = 10'h07c ;
			8'h97: sine = 10'h077 ;
			8'h98: sine = 10'h072 ;
			8'h99: sine = 10'h06d ;
			8'h9a: sine = 10'h068 ;
			8'h9b: sine = 10'h063 ;
			8'h9c: sine = 10'h05e ;
			8'h9d: sine = 10'h059 ;
			8'h9e: sine = 10'h054 ;
			8'h9f: sine = 10'h050 ;
			8'ha0: sine = 10'h04b ;
			8'ha1: sine = 10'h047 ;
			8'ha2: sine = 10'h043 ;
			8'ha3: sine = 10'h03e ;
			8'ha4: sine = 10'h03a ;
			8'ha5: sine = 10'h036 ;
			8'ha6: sine = 10'h033 ;
			8'ha7: sine = 10'h02f ;
			8'ha8: sine = 10'h02b ;
			8'ha9: sine = 10'h028 ;
			8'haa: sine = 10'h025 ;
			8'hab: sine = 10'h022 ;
			8'hac: sine = 10'h01f ;
			8'had: sine = 10'h01c ;
			8'hae: sine = 10'h019 ;
			8'haf: sine = 10'h016 ;
			8'hb0: sine = 10'h014 ;
			8'hb1: sine = 10'h012 ;
			8'hb2: sine = 10'h00f ;
			8'hb3: sine = 10'h00d ;
			8'hb4: sine = 10'h00b ;
			8'hb5: sine = 10'h00a ;
			8'hb6: sine = 10'h008 ;
			8'hb7: sine = 10'h007 ;
			8'hb8: sine = 10'h005 ;
			8'hb9: sine = 10'h004 ;
			8'hba: sine = 10'h003 ;
			8'hbb: sine = 10'h002 ;
			8'hbc: sine = 10'h002 ;
			8'hbd: sine = 10'h001 ;
			8'hbe: sine = 10'h001 ;
			8'hbf: sine = 10'h001 ;
			8'hc0: sine = 10'h001 ;
			8'hc1: sine = 10'h001 ;
			8'hc2: sine = 10'h001 ;
			8'hc3: sine = 10'h001 ;
			8'hc4: sine = 10'h002 ;
			8'hc5: sine = 10'h002 ;
			8'hc6: sine = 10'h003 ;
			8'hc7: sine = 10'h004 ;
			8'hc8: sine = 10'h005 ;
			8'hc9: sine = 10'h007 ;
			8'hca: sine = 10'h008 ;
			8'hcb: sine = 10'h00a ;
			8'hcc: sine = 10'h00b ;
			8'hcd: sine = 10'h00d ;
			8'hce: sine = 10'h00f ;
			8'hcf: sine = 10'h012 ;
			8'hd0: sine = 10'h014 ;
			8'hd1: sine = 10'h016 ;
			8'hd2: sine = 10'h019 ;
			8'hd3: sine = 10'h01c ;
			8'hd4: sine = 10'h01f ;
			8'hd5: sine = 10'h022 ;
			8'hd6: sine = 10'h025 ;
			8'hd7: sine = 10'h028 ;
			8'hd8: sine = 10'h02b ;
			8'hd9: sine = 10'h02f ;
			8'hda: sine = 10'h033 ;
			8'hdb: sine = 10'h036 ;
			8'hdc: sine = 10'h03a ;
			8'hdd: sine = 10'h03e ;
			8'hde: sine = 10'h043 ;
			8'hdf: sine = 10'h047 ;
			8'he0: sine = 10'h04b ;
			8'he1: sine = 10'h050 ;
			8'he2: sine = 10'h054 ;
			8'he3: sine = 10'h059 ;
			8'he4: sine = 10'h05e ;
			8'he5: sine = 10'h063 ;
			8'he6: sine = 10'h068 ;
			8'he7: sine = 10'h06d ;
			8'he8: sine = 10'h072 ;
			8'he9: sine = 10'h077 ;
			8'hea: sine = 10'h07c ;
			8'heb: sine = 10'h082 ;
			8'hec: sine = 10'h087 ;
			8'hed: sine = 10'h08d ;
			8'hee: sine = 10'h092 ;
			8'hef: sine = 10'h098 ;
			8'hf0: sine = 10'h09e ;
			8'hf1: sine = 10'h0a4 ;
			8'hf2: sine = 10'h0aa ;
			8'hf3: sine = 10'h0b0 ;
			8'hf4: sine = 10'h0b5 ;
			8'hf5: sine = 10'h0bb ;
			8'hf6: sine = 10'h0c2 ;
			8'hf7: sine = 10'h0c8 ;
			8'hf8: sine = 10'h0ce ;
			8'hf9: sine = 10'h0d4 ;
			8'hfa: sine = 10'h0da ;
			8'hfb: sine = 10'h0e0 ;
			8'hfc: sine = 10'h0e7 ;
			8'hfd: sine = 10'h0ed ;
			8'hfe: sine = 10'h0f3 ;
			8'hff: sine = 10'h0f9 ;
		endcase
	end
endmodule
///////////////////////////////////////////////////