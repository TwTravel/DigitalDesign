`timescale 1ns/100ps
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
// Major Functions:	DE2 TOP LEVEL
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Chen       :| 05/08/19  :|      Initial Revision
//   V1.1 :| Johnny Chen       :| 05/11/16  :|      Add to FLASH Address FL_ADDR[21:20]
//   V1.2 :| Johnny Chen       :| 05/11/16  :|		Fixed ISP1362 INT/DREQ Pin Direction.   
// --------------------------------------------------------------------

module DE2_TOP
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
inout			AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			AUD_ADCDAT;				//	Audio CODEC ADC Data
inout			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT;				//	Audio CODEC DAC Data
inout			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK;				//	Audio CODEC Chip Clock
////////////////////	TV Devoder		////////////////////////////
input	[7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
input			TD_HS;					//	TV Decoder H_SYNC
input			TD_VS;					//	TV Decoder V_SYNC
output			TD_RESET;				//	TV Decoder Reset
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1


//	Turn on all display
assign	HEX0		=	7'h00;
assign	HEX1		=	7'h00;
assign	HEX2		=	7'h00;
assign	HEX3		=	7'h00;
assign	HEX4		=	7'h00;
assign	HEX5		=	7'h00;
assign	HEX6		=	7'h00;
assign	HEX7		=	7'h00;
assign	LEDG	    =	9'h1FF;
//assign	LEDR		=	18'h3FFFF;
assign	LCD_ON		=	1'b1;
assign	LCD_BLON	=	1'b1;

//	All inout port turn to tri-state
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ		=	8'hzz;
assign	SRAM_DQ		=	16'hzzzz;
assign	OTG_DATA	=	16'hzzzz;
assign	LCD_DATA	=	8'hzz;
assign	SD_DAT		=	1'bz;
assign	I2C_SDAT	=	1'bz;
//assign	ENET_DATA	=	16'hzzzz;
assign	AUD_ADCLRCK	=	1'bz;
assign	AUD_DACLRCK	=	1'bz;
assign	AUD_BCLK	=	1'bz;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;

assign TD_RESET = 1'b1;

 
wire    SRAM_UB_N=0;
wire    SRAM_LB_N=0;
wire    SRAM_CE_N=0;
wire    SRAM_OE_N=0;

wire VGA_CTRL_CLK,AUD_CTRL_CLK,VGA_CLK;
wire AUD_ADCLRCK	=	AUD_DACLRCK;
wire AUD_XCK		=	AUD_CTRL_CLK;
wire DLY_RST;

wire [15:0] audio_in_r,audio_in_l,audio_out_0_r,audio_out_0_l,audio_out_1_r,audio_out_1_l;
wire [16:0] audio_in_combined = {audio_in_l[15],audio_in_l} + {audio_in_r[15],audio_in_r};
wire [16:0] audio_out_l_combined = {audio_out_0_l[15],audio_out_0_l} + {audio_out_1_l[15],audio_out_1_l};
wire [16:0] audio_out_r_combined = {audio_out_0_r[15],audio_out_0_r} + {audio_out_1_r[15],audio_out_1_r};

reg  [15:0] AudioOutL,AudioOutR;
wire left0_done,right0_done,left1_done,right1_done;

wire [17:0] fake_sdram_addr;

wire [16:0] fake_sdram_data_in;
wire [16:0] fake_sdram_data_out;
wire        fake_sdram_we;

wire [7:0]  coeff_ram_update_addr;
wire [16:0] coeff_ram_update_data;

wire coeff_ram_update_0_l_we,coeff_ram_update_1_l_we;
wire coeff_ram_update_0_r_we,coeff_ram_update_1_r_we;
wire audio_in_ready;
wire audio_out_done;
wire filter_0_select,filter_1_select;
wire [15:0] EthernetAudioStream;


reg [15:0] Counter48k;
wire Pulse48k = (Counter48k < 4);

always@(posedge CLOCK_50) begin
  Counter48k <= ((Counter48k == 1070) | ~KEY[0]) ? 0 : Counter48k + 1;  // was 1041, 1070 gives better alignment on this board
end 

always@(posedge AUD_CTRL_CLK) begin
  if(left0_done)
    AudioOutL <= audio_out_l_combined[16:1];
  else
    AudioOutL <= AudioOutL;

  if(right0_done)
    AudioOutR <= audio_out_r_combined[16:1];
  else
    AudioOutR <= AudioOutR;
//  AudioOutR <= audio_in_r;
end
  




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
							.iAUD_ADCDAT(AUD_ADCDAT),
							//	Control Signals
							.iSrc_Select(SW[17]),
				            .iCLK_18_4(AUD_CTRL_CLK),
							.iRST_N(DLY_RST),
							.oAudioSampleIn_L(audio_in_l),
					        .oAudioSampleIn_R(audio_in_r),
					        .oAudioSampleIn_Ready(audio_in_ready),			
					        .iAudioSampleOut_L(AudioOutL),
					        .iAudioSampleOut_R(AudioOutR),
					        .oAudioSampleOut_Done(audio_out_done)
							);						


filter  left0(
  .Clock(AUD_CTRL_CLK),
  .Reset(~KEY[0]),
// Coeff Ram Update
  .CoeffRamAddr(coeff_ram_update_addr),
  .CoeffRamData(coeff_ram_update_data),
  .CoeffRamWE(coeff_ram_update_0_l_we),
//Filter control 
  .CoeffRamSelect(filter_0_select),
  .Start(audio_in_ready),
  .In(audio_in_combined[16:1]),
  .Out(audio_out_0_l),
  .Done(left0_done)
);

filter  right0(
  .Clock(AUD_CTRL_CLK),
  .Reset(~KEY[0]),
// Coeff Ram Update
  .CoeffRamAddr(coeff_ram_update_addr),
  .CoeffRamData(coeff_ram_update_data),
  .CoeffRamWE(coeff_ram_update_0_r_we),
//Filter control 
  .CoeffRamSelect(filter_0_select),
  .Start(audio_in_ready),
  .In(audio_in_combined[16:1]),
  .Out(audio_out_0_r),
  .Done(right0_done)
);

filter  left1(
  .Clock(AUD_CTRL_CLK),
  .Reset(~KEY[0]),
// Coeff Ram Update
  .CoeffRamAddr(coeff_ram_update_addr),
  .CoeffRamData(coeff_ram_update_data),
  .CoeffRamWE(coeff_ram_update_1_l_we),
//Filter control 
  .CoeffRamSelect(filter_1_select),
  .Start(audio_in_ready),
  .In(EthernetAudioStream),
  .Out(audio_out_1_l),
  .Done(left1_done)
);

filter  right1(
  .Clock(AUD_CTRL_CLK),
  .Reset(~KEY[0]),
// Coeff Ram Update
  .CoeffRamAddr(coeff_ram_update_addr),
  .CoeffRamData(coeff_ram_update_data),
  .CoeffRamWE(coeff_ram_update_1_r_we),
//Filter control 
  .CoeffRamSelect(filter_1_select),
  .Start(audio_in_ready),
  .In(EthernetAudioStream),
  .Out(audio_out_1_r),
  .Done(right1_done)
);



CoeffUpdater CoUp(
  .Clock(AUD_CTRL_CLK),
  .Reset(~KEY[0]),
  .Azimuth(Azimuth),
  .Elevation(Elevation),
  .Stream(Stream),
  .Start( ChangeCoefficientPulse ),
  .Busy(),

  .SDRAM_Addr(fake_sdram_addr),
  .SDRAM_ReadData({SRAM_DQ,1'b0}),
  .SDRAM_ReadEnable(),

  .CoeffRam_Addr(coeff_ram_update_addr),
  .CoeffRam_Data(coeff_ram_update_data),

  .CoeffRam0_L_WE(coeff_ram_update_0_l_we),
  .CoeffRam0_R_WE(coeff_ram_update_0_r_we),
  .CoeffRam1_L_WE(coeff_ram_update_1_l_we),
  .CoeffRam1_R_WE(coeff_ram_update_1_r_we),
  .Filter0Select(filter_0_select),
  .Filter1Select(filter_1_select),
 
  .Filter0Done()

  );


reg [2:0]  uart_address;
reg        uart_begintransfer;
wire       uart_chipselect=1;
reg        uart_read_n;
reg        uart_write_n;
reg [15:0] uart_writedata;

wire        uart_dataavailable;
wire        uart_irq;
wire [7:0] uart_readdata;
wire        uart_readyfordata;



assign LEDR[0] = uart_dataavailable;
assign LEDR[1] = uart_readyfordata;
assign LEDR[2] = uart_irq;    
assign LEDR[11:4] = uart_readdata[7:0];



reg StateNoCommand;
reg StateStuffIt;
reg StateChangeCoefficient0;
reg StateChangeCoefficient1;
reg ChangeCoefficientPulse;
reg     [31:0]  StuffItCount;
wire StuffItDone = (StuffItCount == 32'h3d090);
reg [4:0] Elevation,Azimuth;
reg       Stream;
reg [7:0] StuffItLow;


wire 	[15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
wire 	[17:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
reg             SRAM_WE_N;


always@(posedge AUD_CTRL_CLK) begin
  if(~KEY[0]) begin
    StateNoCommand          <= 1'b1;
    StateStuffIt            <= 1'b0;
    StateChangeCoefficient0 <= 1'b0;
    StateChangeCoefficient1 <= 1'b0;
  end
  else 
    if (UART_ReadValid) begin 
      StateNoCommand         <= (StateStuffIt & StuffItDone) |
                                (StateChangeCoefficient1) |

                                StateNoCommand & ~(UART_ReadData < 4) ;
      StateStuffIt           <= StateNoCommand & (UART_ReadData == 16'h0) |
                                StateStuffIt   & ~StuffItDone;
  
      StateChangeCoefficient0 <= StateNoCommand & (UART_ReadData == 16'h1);
      StateChangeCoefficient1 <= StateChangeCoefficient0;
    end
end

always@(posedge AUD_CTRL_CLK) begin
  ChangeCoefficientPulse <= (StateChangeCoefficient1 & UART_ReadValid) ? 1'b1 : 1'b0;
  SRAM_WE_N              <= (StateStuffIt & UART_ReadValid)            ? 1'b0 : 1'b1;
  StuffItCount           <= (StateStuffIt & ~SRAM_WE_N)                ? StuffItCount + 1 : 
                            (StateStuffIt & SRAM_WE_N )                ? StuffItCount     : 0;
  if(UART_ReadValid) begin
    Azimuth   <= (StateChangeCoefficient0) ? UART_ReadData[4:0] : Azimuth;
    Stream    <= (StateChangeCoefficient0) ? UART_ReadData[8]   : Stream;
    Elevation <= (StateChangeCoefficient1) ? UART_ReadData[4:0] : Elevation;
  end
end


assign SRAM_ADDR = (StateStuffIt) ? StuffItCount[17:0] : fake_sdram_addr;
assign SRAM_DQ   = (StateStuffIt) ? UART_ReadData      : 16'bz;


// communicate with the UART,
// When data comes in, set UART_ReadValid & UART_ReadData to read byte;
reg StateUART;
reg [15:0] UART_ReadData;
reg UART_ReadValid;

reg UARTDataAvailable_L;
wire UARTDataAvailablePulse = uart_dataavailable & ~UARTDataAvailable_L;

always@(posedge AUD_CTRL_CLK) begin
  UARTDataAvailable_L <= uart_dataavailable;
end


reg UARTStateWaitByteFirst;
reg UARTStateGetByteFirst0;
reg UARTStateGetByteFirst1;
reg UARTStateWaitByteSecond;
reg UARTStateGetByteSecond0;
reg UARTStateGetByteSecond1;

always@(posedge AUD_CTRL_CLK) begin
  if (~KEY[0]) begin
    UARTStateWaitByteFirst <= 1;
    UARTStateGetByteFirst0 <= 0;
    UARTStateGetByteFirst1 <= 0;
    UARTStateWaitByteSecond <= 0;
    UARTStateGetByteSecond0 <= 0;
    UARTStateGetByteSecond1 <= 0;
  end
  else begin
    UARTStateWaitByteFirst  <= (UARTStateWaitByteFirst & ~UARTDataAvailablePulse) | UARTStateGetByteSecond1;
    UARTStateGetByteFirst0  <= (UARTStateWaitByteFirst & UARTDataAvailablePulse);
    UARTStateGetByteFirst1  <= UARTStateGetByteFirst0;
    UARTStateWaitByteSecond <= (UARTStateWaitByteSecond & ~UARTDataAvailablePulse) | UARTStateGetByteFirst1;
    UARTStateGetByteSecond0 <= (UARTStateWaitByteSecond & UARTDataAvailablePulse);
    UARTStateGetByteSecond1 <= UARTStateGetByteSecond0;
  end
end

always@(posedge AUD_CTRL_CLK) begin
  if (~KEY[0]) begin
    uart_address <= 0;
    uart_read_n <= 1;
    UART_ReadValid <= 0;
    UART_ReadData <= 16'h0;
    uart_begintransfer <= 0;
  end
  else begin;
    uart_read_n <= ~(UARTStateGetByteFirst0 | UARTStateGetByteSecond0);
    uart_begintransfer <= UARTStateGetByteFirst0 | UARTStateGetByteSecond0;
    UART_ReadValid <= UARTStateGetByteSecond1;
    UART_ReadData <= UARTStateGetByteFirst1  ? {uart_readdata, 8'b0} :
                     UARTStateGetByteSecond1 ? {UART_ReadData[15:8], uart_readdata} : UART_ReadData;

  end
end


///////////////////////////////////
////  Ethernet Phy/Mac Logic   ////
///////////////////////////////////

//	DM9000A Clock 25 MHz
reg CLOCK_25;
always@(posedge CLOCK_50) begin
  CLOCK_25 <= ~CLOCK_25;
end

wire [15:0] iENET_DATA;
wire        iENET_CMD;
wire        iENET_RD_N;
wire        iENET_WR_N;
wire        iENET_CS_N;

reg KEY2_L,KEY1_L;
always@(posedge CLOCK_25) begin
  KEY2_L <= KEY[2];
  KEY1_L <= KEY[1];
end
wire KEY2Pulse = ~KEY[2] & KEY2_L;
wire KEY1Pulse = ~KEY[1] & KEY1_L;
wire DriveZ;

wire EthernetRead = (SW[16]) ? audio_in_ready : Pulse48k;

EnetIF EthernetInterface(
  .Clock(CLOCK_25),
  .Reset(~KEY[0]),
  .StartInit(KEY2Pulse),
  .StartRead(EthernetRead),
  .DriveZ(DriveZ),
  .ENET_DATAw(iENET_DATA),
  .ENET_DATAr(ENET_DATA),
  .ENET_CMD(iENET_CMD),
  .ENET_CS_N(iENET_CS_N),
  .ENET_WR_N(iENET_WR_N),
  .ENET_RD_N(iENET_RD_N),
  .ENET_RST_N(ENET_RST_N),
  .ENET_INT(ENET_INT),
  .ENET_CLK(ENET_CLK),

  .AudioStream(EthernetAudioStream)

  );

reg KEY3_L;
reg StateRead0;
reg StateRead1;
reg StateRead1a;
reg StateRead2;
reg StateRead3;
reg StateRead4;

wire KEY3Pulse = ~KEY[3] & KEY3_L;

always@(posedge CLOCK_25) begin
  KEY3_L <= KEY[3];
  if(~KEY[0]) begin
    StateRead0 <= 1'b1;
    StateRead1 <= 1'b0;
    StateRead1a<= 1'b0;
    StateRead2 <= 1'b0;
    StateRead3 <= 1'b0;
    StateRead4 <= 1'b0;
  end
  else begin
    StateRead0 <= StateRead0 & ~KEY3Pulse | 
                  StateRead4;
    StateRead1 <= StateRead0 & KEY3Pulse;
    StateRead1a <= StateRead1;
    StateRead2 <= StateRead1a;
    StateRead3 <= StateRead2;
    StateRead4 <= StateRead3;
  end
end

assign ENET_RD_N = (StateRead0) ? iENET_RD_N :
                   (StateRead1) ? 1          :
                   (StateRead3 & ~SW[17]) ? 0          : 1;

assign ENET_DATA = (StateRead0 & DriveZ)  ? 16'bz :
                   (StateRead0 & ~DriveZ) ? iENET_DATA :
                   (StateRead1 | StateRead1a) ? SW[15:0]   : 
                   ((StateRead3 | StateRead4) & SW[17] ) ?
                      (
                      (SW[15:0] == 16'h1F) ?  0 :
                      (SW[15:0] == 16'h00) ?  1 :
                      (SW[15:0] == 16'hFF) ? 16'h81 :
                      (SW[15:0] == 16'hFE) ? 16'h3f :
                      (SW[15:0] == 16'h01) ? 16'h2C :
                      (SW[15:0] == 16'h05) ? 16'h03 : 16'bZZZZ
                       ) : 16'bz;

assign ENET_CMD  = (StateRead0) ? iENET_CMD  :
                   (StateRead1 | StateRead1a) ?          0 : 
                   (StateRead3) ?          1 : 1;

assign ENET_WR_N = (StateRead0) ? iENET_WR_N :
                   (StateRead1) ?          0 :
                   (StateRead3 & SW[17]) ?          0 : 1;

assign ENET_CS_N = 0;//(StateRead0) ? iENET_CS_N : (ENET_RD_N & ENET_WR_N);

uart_0 test_uart(
                // inputs:
                 .address(uart_address),
                 .begintransfer(uart_begintransfer),
                 .chipselect(uart_chipselect),
                 .clk(AUD_CTRL_CLK),
                 .read_n(uart_read_n),
                 .reset_n(KEY[0]),
                 .rxd(UART_RXD),
                 .write_n(uart_write_n),
                 .writedata(uart_writedata),

                // outputs:
                 .dataavailable(uart_dataavailable),
                 .irq(uart_irq),
                 .readdata(uart_readdata),
                 .readyfordata(uart_readyfordata),
                 .txd(UART_TXD)
              );
endmodule
