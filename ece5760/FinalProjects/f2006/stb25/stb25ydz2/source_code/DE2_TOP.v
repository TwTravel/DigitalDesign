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
`include "RayTrace.h"

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
output			OTG_DACK0_N;			//	ISP1362 DMA AcknowLEDGe 0
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
assign	LCD_ON		=	1'b0;
assign	LCD_BLON	=	1'b0;

//	All inout port turn to tri-state_m
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ		=	8'hzz;
assign	SRAM_DQ		=	16'hzzzz;
assign	OTG_DATA	=	16'hzzzz;
assign	LCD_DATA	=	8'hzz;
assign	SD_DAT		=	1'bz;
assign	I2C_SDAT	=	1'bz;
assign	ENET_DATA	=	16'hzzzz;
assign	AUD_ADCLRCK	=	1'bz;
assign	AUD_DACLRCK	=	1'bz;
assign	AUD_BCLK	=	1'bz;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;



//VGA

wire		VGA_CTRL_CLK;
wire		AUD_CTRL_CLK;
wire [9:0]	mVGA_R;
wire [9:0]	mVGA_G;
wire [9:0]	mVGA_B;
wire [19:0]	mVGA_ADDR;			//video memory address
wire [9:0]  Coord_X, Coord_Y;	//display coods
wire		DLY_RST;
reg    pixel;
reg  [3:0]  pixel_cnt;
reg         we;

assign	TD_RESET	=	1'b1;	//	Allow 27 MHz input
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;



//Used for random number generator
Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);


//VGA_Controller reads memory at x,y and outputs to dac, produces synch and porch signals based on timing in header file
VGA_Controller		u1	(	//	Host Side
							.iCursor_RGB_EN(4'b0111),
							.oAddress(mVGA_ADDR),
							.oCoord_X(Coord_X),
							.oCoord_Y(Coord_Y),
							.iRed(mVGA_R),
							.iGreen(mVGA_G),
							.iBlue(mVGA_B),
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
							.iRST_N(DLY_RST)	);

reg [17:0] addr_reg; //memory address register for SRAM
reg [15:0] data_reg; //memory data register  for SRAM
reg [3:0] state_m;	//state_m machine
reg TRACE;

// SRAM_control
assign SRAM_ADDR = addr_reg;
assign SRAM_DQ = (we)? 16'hzzzz : data_reg ; //VGA reading or state machine writing
assign SRAM_UB_N = 0;					// hi byte select enabled
assign SRAM_LB_N = 0;					// lo byte select enabled
assign SRAM_CE_N = 0;					// chip is enabled
assign SRAM_WE_N = we;					// write when ZERO
assign SRAM_OE_N = 0;					// output enable is overidden by WE

//1'b0 5'bRED 5'bGREEN 5'bBLUE
// VGA_COLOR
assign  mVGA_R = {SRAM_DQ[14:10],{5{SRAM_DQ[15]}}}&{10{~Coord_X[9]}};
assign  mVGA_G = {SRAM_DQ[9 : 5],{5{SRAM_DQ[15]}}}&{10{~Coord_X[9]}};
assign  mVGA_B = {SRAM_DQ[4 : 0],{5{SRAM_DQ[15]}}}&{10{~Coord_X[9]}};

wire [9:0] x1,y1,x2,y2;
wire [7:0] COLOR;
wire [7:0] PIXEL;
wire [17:0] SRAM_ADDR2;
wire [15:0] SRAM_DATA_IN;
wire [15:0] SRAM_DATA_OUT;
wire HB_NLB,WE_N;
wire RESET,ENABLE;
wire [3:0] CHAR;
wire [2:0] cmd;

wire Reset;
assign Reset = ~KEY[3];

sqrt_fixedpoint_pipelined sq(N2,N,VGA_CTRL_CLK,sqrtDone,sqrtStart,(Reset|sqrtReset));
wire [23:0] N;
reg [23:0] N2;

reg [71:0] Origin;
wire [71:0] Light;

reg [11:0] redaliasbuffer[8:0];
reg [11:0] greenaliasbuffer[8:0];
reg [11:0] bluealiasbuffer[8:0];
reg [3:0] aliasstate;

reg [23:0] ScreenDistance;
//assign ScreenDistance  = ({SW[17:8],14'b0})>>4; // 100/16 = 6.25
//17,13
wire whichscreen;
assign whichscreen = SW[5];


wire antialias4,antialias8;
assign antialias4 = SW[0];
assign antialias8 = SW[1];


wire [23:0] ScreenWidth,ScreenWidth_2,ScreenHeight,ScreenHeight_2,ScreenIncrement;

assign ScreenIncrement = 24'h001000>>5; //   1/16 = 0.0625

assign ScreenWidth     = (SW[4])? 24'h200000>>5 : 24'h140000>>5; // 512 / 320
assign ScreenWidth_2   = (SW[4])? 24'h100000>>5 : 24'h0a0000>>5; // 
assign ScreenHeight    = (SW[4])? 24'h1E0000>>5 : 24'h0f0000>>5; // 480 / 240
assign ScreenHeight_2  = (SW[4])? 24'h0F0000>>5 : 24'h078000>>5; // 
 
reg [23:0] lightx,lighty,lightz;

sdrampll sd(CLOCK_50,DRAM_CLK);
sdram K
    (
      .clk                           (CLOCK_50),
      .in_port_to_the_done           (done),
      .in_port_to_the_pov_x          (pov_x),
      .in_port_to_the_pov_y          (pov_y),
      .in_port_to_the_pov_z          (pov_z),
      .in_port_to_the_rotz           (rotz),
      .out_port_from_the_sphere      (sphere_num),
      .out_port_from_the_color       (color),
      .out_port_from_the_r2          (r_square),
	  .out_port_from_the_r_inv       (radius_inv),
      .out_port_from_the_radius      (radius),
      .out_port_from_the_reflect     (reflect),
      .out_port_from_the_valid       (valid),
      .out_port_from_the_x1          (x),
      .out_port_from_the_y1          (y),
      .out_port_from_the_z1          (z),
      .reset_n                        (~Reset),
      .zs_addr_from_the_sdram_0       (DRAM_ADDR),
      .zs_ba_from_the_sdram_0         ({DRAM_BA_1, DRAM_BA_0}),
      .zs_cas_n_from_the_sdram_0      (DRAM_CAS_N),
      .zs_cke_from_the_sdram_0        (DRAM_CKE),
      .zs_cs_n_from_the_sdram_0       (DRAM_CS_N),
      .zs_dq_to_and_from_the_sdram_0  (DRAM_DQ),
      .zs_dqm_from_the_sdram_0        ({DRAM_UDQM, DRAM_LDQM}),
      .zs_ras_n_from_the_sdram_0      (DRAM_RAS_N),
      .zs_we_n_from_the_sdram_0       (DRAM_WE_N)
    );

//input ports
reg [5:0] sphere_count;
wire [23:0] pov_x, pov_y, pov_z;
wire [7:0] rotz;
reg done;
assign rotz[5:0] = {SW[17]&SW[16], SW[15]&SW[14], SW[13]&SW[12], SW[11]&SW[10], SW[9]&SW[8], SW[7]&SW[6]};
//assign LEDR[10:5] = rotz[5:0];
//assign rotz[5]=SW[17]&SW[16];


//output ports
wire [7:0] sphere_num;
wire [15:0] color;
wire [23:0] r_square, x, y, z;
wire [11:0] radius, radius_inv;
wire [11:0] reflect;
wire valid;
reg old_valid;

wire [3:0] LastSphere;
assign LastSphere = sphere_num[7:4];
reg [207:0] Spheres[4:0];



/*
wire [207:0] Spheres[13:0];
//IsLight 1/Radius Radius^2 Reflectivity(fraction) Translucency(fraction) R G B Radius X Y Z					

assign Spheres[0] = (whichscreen)?{1'b0, 24'h000555 , 48'h000009000000 , 12'h400 , 12'h000 , 5'h0c , 5'h1f , 5'h14 , 24'h003000 , 24'h000000 , 24'h000000, 24'h005000 }:{1'b0, 24'h000555 , 48'h000009000000 , 12'h200 , 12'h000 , 5'h1f , 5'h1f , 5'h00 , 24'h003000 , 24'h00f000 , 24'h000000, 24'h00f000 };//0
assign Spheres[1] = (whichscreen)?{1'b0, 24'h000555 , 48'h000009000000 , 12'h400 , 12'h000 , 5'h1b , 5'h1b , 5'h1b , 24'h003000 , 24'h00f000 , 24'h000000, 24'h005000 }:{1'b0, 24'h000555 , 48'h000009000000 , 12'h200 , 12'h000 , 5'h00 , 5'h00 , 5'h1f , 24'h003000 , 24'h000000 , 24'h000000, 24'h000000 };//1
assign Spheres[2] = (whichscreen)?{1'b0, 24'h000555 , 48'h000009000000 , 12'h400 , 12'h000 , 5'h00 , 5'h1f , 5'h1f , 24'h003000 , 24'h000000 , 24'h00f000, 24'h005000 }:{1'b0, 24'h000555 , 48'h000009000000 , 12'h200 , 12'h000 , 5'h1f , 5'h1f , 5'h00 , 24'h003000 , 24'hff1000 , 24'h000000, 24'h00f000 };//2
assign Spheres[3] = (whichscreen)?{1'b0, 24'h000555 , 48'h000009000000 , 12'h400 , 12'h000 , 5'h1f , 5'h1f , 5'h00 , 24'h003000 , 24'h00f000 , 24'h00f000, 24'h005000 }:{1'b0, 24'h000555 , 48'h000009000000 , 12'h200 , 12'h000 , 5'h1f , 5'h00 , 5'h00 , 24'h003000 , 24'h000000 , 24'h00f000, 24'h00f000 };//3
assign Spheres[4] = (whichscreen)?{1'b0, 24'h000111 , 48'h0000e1000000 , 12'h800 , 12'h000 , 5'h00 , 5'h1f , 5'h00 , 24'h00f000 , 24'h000000 , 24'h015000, 24'h015000 }:{1'b0, 24'h000555 , 48'h000009000000 , 12'h200 , 12'h000 , 5'h1f , 5'h00 , 5'h00 , 24'h003000 , 24'h000000 , 24'hff1000, 24'h00f000 };//4
assign Spheres[5] = (whichscreen)?{1'b0, 24'h000111 , 48'h0000e1000000 , 12'h800 , 12'h000 , 5'h1f , 5'h00 , 5'h00 , 24'h00f000 , 24'h015000 , 24'h000000, 24'h015000 }:{1'b0, 24'h000555 , 48'h000009000000 , 12'h200 , 12'h000 , 5'h00 , 5'h00 , 5'h1f , 24'h003000 , 24'h000000 , 24'h000000, 24'h01e000 };//5
assign Spheres[6] = (whichscreen)?{1'b0, 24'h000555 , 48'h000009000000 , 12'h400 , 12'h000 , 5'h00 , 5'h00 , 5'h1f , 24'h003000 , 24'hff1000 , 24'hff1000, 24'h005000 }:{1'b0, 24'h000111 , 48'h0000e1000000 , 12'h400 , 12'h000 , 5'h00 , 5'h1f , 5'h00 , 24'h00f000 , 24'h000000 , 24'h000000, 24'h00f000 };//6
assign Spheres[7] = (whichscreen)?{1'b0, 24'h000555 , 48'h000009000000 , 12'h400 , 12'h000 , 5'h0f , 5'h0f , 5'h1f , 24'h003000 , 24'hff1000 , 24'h000000, 24'h005000 }:{1'b1, 24'h000555 , 48'h000009000000 , 12'h000 , 12'h000 , 5'h1f , 5'h1f , 5'h1f , 24'h003000 , lightx , lighty, lightz };//7
assign Spheres[8] = (whichscreen)?{1'b0, 24'h000555 , 48'h000009000000 , 12'h400 , 12'h000 , 5'h15 , 5'h1f , 5'h1f , 24'h003000 , 24'h00f000 , 24'hff1000, 24'h005000 }:{1'b0, 24'h000084 , 48'h0003c1000000 , 12'h800 , 12'h000 , 5'h0c , 5'h0c , 5'h0c , 24'h01f000 , 24'h02f000 , 24'hfd1000, 24'h02f000 };//1
assign Spheres[9] = (whichscreen)?{1'b0, 24'h000555 , 48'h000009000000 , 12'h400 , 12'h000 , 5'h0f , 5'h0f , 5'h0f , 24'h003000 , 24'h000000 , 24'hff1000, 24'h005000 }:{1'b0, 24'h000084 , 48'h0003c1000000 , 12'h800 , 12'h000 , 5'h0c , 5'h0c , 5'h0c , 24'h01f000 , 24'hfd1000 , 24'hfd1000, 24'h02f000 };//1
assign Spheres[10] = (whichscreen)?{1'b0, 24'h000555 , 48'h000009000000 , 12'h400 , 12'h000 , 5'h0f , 5'h0c , 5'h0c , 24'h003000 , 24'hff1000 , 24'h00f000, 24'h005000 }:0;//1
assign Spheres[11] = (whichscreen)?{1'b0, 24'h000111 , 48'h0000e1000000 , 12'h800 , 12'h000 , 5'h0f , 5'h0f , 5'h00 , 24'h00f000 , 24'hfeb000 , 24'h000000, 24'h015000 }:0;//5
assign Spheres[12] = (whichscreen)?{1'b0, 24'h000111 , 48'h0000e1000000 , 12'h800 , 12'h000 , 5'h0f , 5'h03 , 5'h0c , 24'h00f000 , 24'h000000 , 24'hfeb000, 24'h015000 }:0;//5

assign Spheres[13] = (whichscreen)?{1'b1, 24'h000800 , 48'h000004000000 , 12'h000 , 12'h000 , 5'h1f , 5'h1f , 5'h1f , 24'h002000 , lightx , lighty, lightz }:0;//8
*/


wire [235:0] Planes[3:0];
//CheckerWidth4,A24,B24,C24,D24,Xn24,Yn24,Zn24,R5,G5,B5,HasLimits1,Reflec12,XL12,YL12,ZL12
assign Planes[0] = {4'b0000,24'h000000,24'h000000,24'hfff000,24'h028000,24'h000000,24'h000000,24'hfff000,5'h00,5'h00,5'h00,1'b0,12'h800,12'h000,12'h000,12'h000};
assign Planes[1] = {4'b0001,24'h000000,24'hfff000,24'h000000,24'h016000,24'h000000,24'hfff000,24'h000000,5'h1d,5'h1d,5'h1d,1'b0,12'h800,12'h000,12'h000,12'h000};
assign Planes[2] = {4'b0000,24'hfff000,24'h000000,24'h000000,24'h01A000,24'hfff000,24'h000000,24'h000000,5'h00,5'h00,5'h00,1'b0,12'h800,12'h000,12'h000,12'h000};
assign Planes[3] = {4'b0000,24'h001000,24'h000000,24'h000000,24'h01A000,24'h001000,24'h000000,24'h000000,5'h00,5'h00,5'h00,1'b0,12'h800,12'h000,12'h000,12'h000};

reg RenderPlanes;
reg [1:0] planecount,shadowplane;
wire [1:0] LastPlane;
assign LastPlane = 2'b11;


assign Light[`XOffset] = lightx;
assign Light[`YOffset] = lighty;
assign Light[`ZOffset] = lightz;

reg [71:0] vectordirection,OC,rn,ri;
reg [23:0] vd,vo;
reg [23:0] tca,t2hc;
reg [23:0] countx,county;
reg [4:0] state;
reg [2:0] raystate;
reg [33:0] wbuffer [31:0];
reg [4:0] spherecount,shadowsphere,shadowR,shadowG,shadowB;
reg sqrtStart;
reg [23:0] t;
reg [47:0] L2OC,Magnitude;
wire sqrtDone;

Div24 xdiv(
	.clock(VGA_CTRL_CLK),
	.denom(denomx),
	.numer(numerx),
	.quotient(quotientx),
	.remain(remainx));	

Div24 ydiv(
	.clock(VGA_CTRL_CLK),
	.denom(denomy),
	.numer(numery),
	.quotient(quotienty),
	.remain(remainy));	
	
Div24 zdiv(
	.clock(VGA_CTRL_CLK),
	.denom(denomz),
	.numer(numerz),
	.quotient(quotientz),
	.remain(remainz));	

wire [11:0] Nqq;
wire [23:0] NQ;	

assign NQ = {6'b0,Nqq,6'b0};

SQRT SPQR(
	.clk(VGA_CTRL_CLK),
	.radical(N2),
	.q(Nqq),
	.remainder());
	
	
reg [17:0] writebufferaddr[63:0];
reg [15:0] writebufferdata[63:0];
reg [5:0]  writebufferhead;
reg [5:0]  writebuffertail;
	
reg [47:0] tmagx,tmagy,tmagz,tx3,ty3,tz3,tx4,ty4,tz4;
reg [23:0] tx1,tx2,ty1,ty2,tz1,tz2,tx5,ty5,tz5,tx6,ty6,tz6,tx7,ty7,tz7;
	
reg [23:0] denomx,denomy,denomz;
reg [35:0] numerx,numery,numerz;
wire [35:0] quotientx,quotienty,quotientz;
wire [23:0] remainx,remainy,remainz;
wire [2:0] maxreflections;
assign maxreflections = SW[3:2];
reg  [2:0] numreflections;

reg [3:0] divcount;
reg [23:0] debuga,debugb,debugc,debugd,debugled;
wire [23:0] debug;
assign LEDR[15:0] = sr[23:8];
assign LEDG[7:0] = sr[7:0];
assign LEDR[16] = (state==0);
assign LEDR[17] = (state==20);
wire [23:0] sr;
reg sqrtReset;
reg [1:0] hit;
reg [23:0] storedt,NdotI;
reg [71:0] storedri,storedv;
reg [11:0] redsofar,bluesofar,greensofar;
reg [11:0] redthistime,bluethistime,greenthistime;
reg [11:0] weight,newweight;
reg IsInside,IsInFront;
reg [47:0] distancetolight;

assign sr = debugled;

assign debug = (SW[1]==0)?((SW[0]==0)? debuga : debugb ):( (SW[0]==0)? debugc : debugd );

always @(posedge VGA_CTRL_CLK)begin
	if(Reset)begin
		//clear the screen
		addr_reg <= {Coord_Y[8:0],Coord_X[8:0]} ;	// [17:0]
		we <= 1'b0;									//write some memory
		data_reg <= 16'b0;
		Origin[`XOffset] <= 24'h000000;
		Origin[`YOffset] <= 24'h000000;
		Origin[`ZOffset] <= 24'hfe0000;
		vectordirection[`XOffset] <= ScreenWidth_2 -(24'h000000>>>5);
		vectordirection[`YOffset] <= ScreenHeight_2-(24'h000000>>>5);
		vectordirection[`ZOffset] <= ScreenDistance-(24'hfe0000>>>5);
		RenderPlanes <= ~KEY[2];
		countx <= ScreenWidth<<5;
		county <= ScreenHeight<<5;
		raystate <= `InitRay;
		numreflections <= 0;
		divcount <= 0;
		state  <= 1;
		ScreenDistance <= ({10'b1000100000,14'b0})>>4;
		lightx <= 24'h00f000;
		lighty <= 24'h00f000;
		lightz <= 24'hfff000;
		aliasstate <= 0;
		weight <= 12'hfff;
		redsofar <= 12'h000;
		greensofar <= 12'h000;
		bluesofar <= 12'h000;
		hit <= 0;
		sqrtStart <= 0;
		spherecount <= 0;
		planecount <= 0;
		writebufferhead <= 0;
		writebuffertail <= 0;
		debuga <= 24'hffffffff;
		debugb <= 24'hffffffff;
		debugc <= 24'hffffffff;
		debugd <= 24'h00000000;
		debugled <= 24'h0;
	end
	else begin
		case(state)
		//normalize direction vector
			5'd0:begin
				tx1[23:0] = (vectordirection[`XSign])?((~vectordirection[`XOffset])+1):(vectordirection[`XOffset]);
				tmagx[47:0] = tx1[23:0]*tx1[23:0];
				ty1[23:0] = (vectordirection[`YSign])?((~vectordirection[`YOffset])+1):(vectordirection[`YOffset]);
				tmagy[47:0] = ty1[23:0]*ty1[23:0];
   				tz1[23:0] = (vectordirection[`ZSign])?((~vectordirection[`ZOffset])+1):(vectordirection[`ZOffset]);
				tmagz[47:0] = tz1[23:0]*tz1[23:0];

				sqrtReset <= 0;
				if(/*raystate==`Shadow0*/`IsShadow && spherecount == LastSphere)begin
					state<=29;
				end
				else begin
					Magnitude = tmagx + tmagy + tmagz;
					distancetolight = Magnitude<<8; 
					N2 = Magnitude[35:12];
					sqrtStart <= 1;	
					state <= 4;
				end	
			end
			//End of Frame
			5'd1:begin
				done = 1; //done drawing a frame
					if (sphere_count >= LastSphere+1) begin
						state <= 0;
						debugled <= debugled +1;
						done <= 0;
						old_valid <= 0;
						sphere_count <= 0;
					end	
					else if (~old_valid && valid) begin
						if (sphere_count == LastSphere) begin
							Spheres[LastSphere] = {1'b1, 24'h000800 , 48'h000004000000 , 12'h000 , 12'h000 , 5'h1f , 5'h1f , 5'h1f , 24'h002000 , lightx , lighty, lightz };
							sphere_count <= sphere_count +1;
						end
						else begin
							Spheres[sphere_num[3:0]] <= {1'b0, {12'h000, radius_inv}, {r_square, 24'h000000}, reflect, 12'h000, color[14:0], {radius, 12'h000}, x, y, z};
							sphere_count <= sphere_count +1;
						end
					end
					old_valid <= valid;
			end
			5'd3:begin
				state <= 4;
			end
			5'd4:begin
				if(sqrtDone)begin
					state <= 5;
					numerx <= {vectordirection[`XOffset],12'b0};
					numery <= {vectordirection[`YOffset],12'b0};
					numerz <= {vectordirection[`ZOffset],12'b0};
					denomx <= N;
					denomy <= N;
					denomz <= N;
					sqrtStart <= 0;
					sqrtReset <= 1;
				end
				else begin
					state <= 4;
				end
			end
			5'd5:begin
				sqrtReset <= 0;
				if(divcount==5)begin //probably too many cycles, no just right
					divcount <= 0;
					vectordirection[`XOffset] = quotientx[23:0];
					vectordirection[`YOffset] = quotienty[23:0];
					vectordirection[`ZOffset] = quotientz[23:0];
					state <= 7;	
				end 
				else begin
					divcount <= divcount + 1;
					state <= 5;
				end
			end
			5'd6:begin
		
			end
		//find ray to center and its length squared
			5'd7:begin
				sqrtReset <= 0;

				if(raystate == `InitRay)begin
					OC[`XOffset] = Spheres[spherecount][`XOffset]-Origin[`XOffset];
					OC[`YOffset] = Spheres[spherecount][`YOffset]-Origin[`YOffset];
					OC[`ZOffset] = Spheres[spherecount][`ZOffset]-Origin[`ZOffset];
				end 
				else /*if(raystate == `Shadow0)*/ begin
					OC[`XOffset] = Spheres[spherecount][`XOffset]-ri[`XOffset];
					OC[`YOffset] = Spheres[spherecount][`YOffset]-ri[`YOffset];
					OC[`ZOffset] = Spheres[spherecount][`ZOffset]-ri[`ZOffset];
				end
				
				if(spherecount == LastSphere && /*raystate == `Shadow0*/`IsShadow)begin
					state <= 29;
				end
				else begin
					tx1[23:0] = (OC[`XSign])?((~OC[`XOffset])+1):(OC[`XOffset]);
					tmagx[47:0] = tx1[23:0]*tx1[23:0];
					ty1[23:0] = (OC[`YSign])?((~OC[`YOffset])+1):(OC[`YOffset]);
					tmagy[47:0] = ty1[23:0]*ty1[23:0];
	   				tz1[23:0] = (OC[`ZSign])?((~OC[`ZOffset])+1):(OC[`ZOffset]);
					tmagz[47:0] = tz1[23:0]*tz1[23:0];
					
					Magnitude = tmagx + tmagy + tmagz;
					L2OC = Magnitude;
					if((Magnitude-{12'b0,Spheres[spherecount][`ROffset],12'b0})>distancetolight && /*raystate ==`Shadow0*/`IsShadow)begin//gives the screen the shakes but fixes bug
						state <= 7;
						spherecount <= spherecount + 1;
					end
					else begin
						state <= 10;
					end
					IsInside<=0;
				end	
			end
			//check if ray is outside sphere, shadow rays shouldnt be inside the sphere!!??!!?? i think i can ignore these
			5'd10:begin
				if(L2OC<Spheres[spherecount][`R2Offset])begin //Needs to be signed, if its inside make it black
					if(raystate == `InitRay)begin
						if(raystate==`InitRay)begin
							state <= 29;
							redaliasbuffer[aliasstate]=0;
							greenaliasbuffer[aliasstate]=0;
							bluealiasbuffer[aliasstate]=0;	
							writebufferaddr[writebufferhead] = {county[20:12],countx[20:12]};
							writebufferdata[writebufferhead] = 0;
							writebufferhead <= writebufferhead + 1;

						end
						else begin
							state <= 29;
						end
					end
					else begin
						tx1[23:0] = (vectordirection[`XSign])?((~vectordirection[`XOffset])+1):(vectordirection[`XOffset]);
						ty1[23:0] = (vectordirection[`YSign])?((~vectordirection[`YOffset])+1):(vectordirection[`YOffset]);
		   				tz1[23:0] = (vectordirection[`ZSign])?((~vectordirection[`ZOffset])+1):(vectordirection[`ZOffset]);
						tx2[23:0] = (OC[`XSign])?((~OC[`XOffset])+1):(OC[`XOffset]);
						ty2[23:0] = (OC[`YSign])?((~OC[`YOffset])+1):(OC[`YOffset]);
						tz2[23:0] = (OC[`ZSign])?((~OC[`ZOffset])+1):(OC[`ZOffset]);
						ty3 = ty1[23:0]*ty2[23:0];
						tx3 = tx1[23:0]*tx2[23:0];
						tz3 = tz1[23:0]*tz2[23:0];
						tx4 = (vectordirection[`XSign]^OC[`XSign])?((~tx3[47:0])+1):tx3[47:0];
						ty4 = (vectordirection[`YSign]^OC[`YSign])?((~ty3[47:0])+1):ty3[47:0];
						tz4 = (vectordirection[`ZSign]^OC[`ZSign])?((~tz3[47:0])+1):tz3[47:0];
						tmagx[47:0] = tx4[47:0];
						tmagy[47:0] = ty4[47:0];
						tmagz[47:0] = tz4[47:0];

						state <= 13;
			    		Magnitude = tmagx + tmagy + tmagz;
						tca = Magnitude[35:12];
						IsInFront <= 0;
						IsInside <= 1;
					end			
				end
				else begin				
					tx1[23:0] = (vectordirection[`XSign])?((~vectordirection[`XOffset])+1):(vectordirection[`XOffset]);
					ty1[23:0] = (vectordirection[`YSign])?((~vectordirection[`YOffset])+1):(vectordirection[`YOffset]);
	   				tz1[23:0] = (vectordirection[`ZSign])?((~vectordirection[`ZOffset])+1):(vectordirection[`ZOffset]);
					tx2[23:0] = (OC[`XSign])?((~OC[`XOffset])+1):(OC[`XOffset]);
					ty2[23:0] = (OC[`YSign])?((~OC[`YOffset])+1):(OC[`YOffset]);
					tz2[23:0] = (OC[`ZSign])?((~OC[`ZOffset])+1):(OC[`ZOffset]);
					ty3 = ty1[23:0]*ty2[23:0];
					tx3 = tx1[23:0]*tx2[23:0];
					tz3 = tz1[23:0]*tz2[23:0];
					tx4 = (vectordirection[`XSign]^OC[`XSign])?((~tx3[47:0])+1):tx3[47:0];
					ty4 = (vectordirection[`YSign]^OC[`YSign])?((~ty3[47:0])+1):ty3[47:0];
					tz4 = (vectordirection[`ZSign]^OC[`ZSign])?((~tz3[47:0])+1):tz3[47:0];
					tmagx[47:0] = tx4[47:0];
					tmagy[47:0] = ty4[47:0];
					tmagz[47:0] = tz4[47:0];

					state <= 13;
		    		Magnitude = tmagx + tmagy + tmagz;
					tca = Magnitude[35:12];
					IsInFront <= 0;
				end
			end
			//check if sphere is in front of origin, make it as explicit as possible what bits i want...
			5'd13:begin
				if(Magnitude[47]==1)begin //does this really mean ? inside sphere, will handle differently with transparency
					if((spherecount==(LastSphere-1))&&/*(raystate==`Shadow0)*/`IsShadow)begin
						state <= 29;
					end
					else if(spherecount<LastSphere)begin
						spherecount <= spherecount + 1;
						state <= 7;
					end
					else begin
					
					
					//next pixel, call this one black
						//raystate <= `InitRay;
						if(hit && `IsRay /*&& ~RenderPlanes*/)begin
							state <= 20;
						end
						else if(/*hit && *//*raystate == `InitRay*/`IsRay && RenderPlanes)begin
							state <= 9;//Check planes if spheres exhausted
							planecount <= 0;
						end else begin
							if(raystate == `InitRay)begin
								state <= 29;
								redaliasbuffer[aliasstate]=0;
								greenaliasbuffer[aliasstate]=0;
								bluealiasbuffer[aliasstate]=0;
								writebufferaddr[writebufferhead] = {county[20:12],countx[20:12]};
								writebufferdata[writebufferhead] = 0;
								writebufferhead <= writebufferhead + 1;

							end
							else begin
								state <= 29;
							end
						end
					end
				end
				else begin
					tx1[23:0] = (tca[23])?((~tca)+1):(tca);
					if((IsInside||spherecount==shadowsphere)&&/*raystate==`Shadow0*/`IsShadow)begin
						state <= 29;
						leg <= 1;
						if(hit==1)begin
						redthistime = {2'b0,Spheres[shadowsphere][`RCOffset],5'b0} >> 1;
						greenthistime = {2'b0,Spheres[shadowsphere][`GCOffset],5'b0} >> 1;
						bluethistime = {2'b0,Spheres[shadowsphere][`BCOffset],5'b0} >> 1;
						end
						else begin
						redthistime = redthistime >> 1;
						greenthistime = greenthistime >> 1;
						bluethistime = bluethistime >> 1;
						end

					end else begin
						Magnitude = tx1[23:0]*tx1[23:0] - L2OC + Spheres[spherecount][`R2Offset];
						t2hc = Magnitude[35:12];
						state <= 16;
					end
				end
			end
		//find square of half chord intersection distance

		//test if square is negative
			5'd16:begin
				if(Magnitude[47]==1)begin //negative misses sphere, ray obviously is outside
					leg <= 0;
					if((spherecount==(LastSphere-1))&&(/*raystate==`Shadow0*/`IsShadow))begin
						state <= 29;
					end else
					if(spherecount<LastSphere)begin
						spherecount <= spherecount + 1;
						state <= 7;
					end
					else begin
					//Check planes if spheres exhausted
					
					//next pixel, call this one black
						//raystate <= `InitRay;
						
						if(hit && `IsRay /*&& ~RenderPlanes*/)begin
							state <= 20;
						end
						else if(/*hit && *//*raystate == `InitRay*/`IsRay && RenderPlanes)begin
							state <= 9;//Check planes if spheres exhausted
							planecount <= 0;
						end else begin
							if(raystate == `InitRay)begin
								state <= 29;
								redaliasbuffer[aliasstate]=0;
								greenaliasbuffer[aliasstate]=0;
								bluealiasbuffer[aliasstate]=0;
								writebufferaddr[writebufferhead] = {county[20:12],countx[20:12]};
								writebufferdata[writebufferhead] = 0;
								writebufferhead <= writebufferhead + 1;

							end
							else begin
								state <= 29;
							end
						end
					end
				end
				else begin
					if(/*(raystate==`Shadow0)*/`IsShadow)begin
						state <= 29;
						leg <= 1;
						if(hit==1)begin
						redthistime = {2'b0,Spheres[shadowsphere][`RCOffset],5'b0} >> 1;
						greenthistime = {2'b0,Spheres[shadowsphere][`GCOffset],5'b0} >> 1;
						bluethistime = {2'b0,Spheres[shadowsphere][`BCOffset],5'b0} >> 1;
						end
						else begin
						redthistime = redthistime >> 1;
						greenthistime = greenthistime >> 1;
						bluethistime = bluethistime >> 1;
						end
						
					end
					else begin
						leg <= 1;
						//find the distance to closest point

						N2 = t2hc;
						sqrtStart <= 1;	
						state <= 18;

					end
				end
			end

			//these comments are in the wrong place mostly
			//calculate intersection distance
			//find intersection point
			//find closest t, first intersection if sorted
			//Set up shadow ray
			5'd18:begin
				state <= 19;
			end
			5'd19:begin
				if(sqrtDone)begin
					sqrtReset <= 1;
					sqrtStart <= 0;
					if(L2OC>=Spheres[spherecount][`R2Offset])begin //Needs to be signed
						tx1[23:0] = tca[23:0] - N[23:0];
						t = tx1[23:0];
					end
					else begin
						tx1[23:0] = tca[23:0] + N[23:0];
						t = tx1[23:0];
					end
					if(t<storedt || hit == 0)begin
						tx1[23:0] = (vectordirection[`XSign])?((~vectordirection[`XOffset])+1):(vectordirection[`XOffset]);
						ty1[23:0] = (vectordirection[`YSign])?((~vectordirection[`YOffset])+1):(vectordirection[`YOffset]);
		   				tz1[23:0] = (vectordirection[`ZSign])?((~vectordirection[`ZOffset])+1):(vectordirection[`ZOffset]);
						tx2[23:0] = (t[23])?((~t[23:0])+1):(t[23:0]);
						tx3 = tx1[23:0]*tx2[23:0];
						ty3 = ty1[23:0]*tx2[23:0];
						tz3 = tz1[23:0]*tx2[23:0];
						tx4 = (vectordirection[`XSign]^t[23])?((~tx3[47:0])+1):tx3[47:0];
						ty4 = (vectordirection[`YSign]^t[23])?((~ty3[47:0])+1):ty3[47:0];
						tz4 = (vectordirection[`ZSign]^t[23])?((~tz3[47:0])+1):tz3[47:0];
						tmagx[47:0] = tx4[47:0];
						tmagy[47:0] = ty4[47:0];
						tmagz[47:0] = tz4[47:0];
						if(raystate == `InitRay)begin
							ri[`XOffset] = Origin[`XOffset] + tmagx[35:12];
							ri[`YOffset] = Origin[`YOffset] + tmagy[35:12];
							ri[`ZOffset] = Origin[`ZOffset] + tmagz[35:12];
						end
						else begin
							ri[`XOffset] = storedri[`XOffset] + tmagx[35:12];
							ri[`YOffset] = storedri[`YOffset] + tmagy[35:12];
							ri[`ZOffset] = storedri[`ZOffset] + tmagz[35:12];
						end
						//writebufferaddr[writebufferhead] = {county[20:12],countx[20:12]};
						//writebufferdata[writebufferhead] = {Spheres[spherecount][`IsLight],Spheres[spherecount][`COffset]};
						//writebufferhead <= writebufferhead + 1;
						redthistime = {2'b0,Spheres[spherecount][`RCOffset],5'b0};
						bluethistime = {2'b0,Spheres[spherecount][`BCOffset],5'b0};
						greenthistime = {2'b0,Spheres[spherecount][`GCOffset],5'b0};
						shadowR <= Spheres[spherecount][`RCOffset];
						shadowB <= Spheres[spherecount][`BCOffset];
						shadowG <= Spheres[spherecount][`GCOffset];
						shadowsphere <= spherecount;
						storedt <= t;
						storedv <= vectordirection;
					end

					hit <= 1;
					if(spherecount==LastSphere)begin
						/*if(RenderPlanes)state <= 9;
						else */state <= 20;
						planecount <= 0;
					end 
					else begin
						state <= 7;
						spherecount <= spherecount + 1;
					end
				end
				else begin
					state <= 19;
				end	
			end
			5'd20:begin
				sqrtReset <= 0;
				if(Spheres[shadowsphere][`IsLight])begin
					state <= 29;
					redthistime <= 12'h3ff;
					bluethistime <= 12'h3ff;
					greenthistime <= 12'h3ff;
				end else begin
					//spherecount <= 0;
					tx1 = (Light[`XOffset]-ri[`XOffset]);
					ty1 = (Light[`YOffset]-ri[`YOffset]);
					tz1 = (Light[`ZOffset]-ri[`ZOffset]);
					vectordirection[`XOffset] = {{4{tx1[23]}},tx1}>>4;	
					vectordirection[`YOffset] = {{4{ty1[23]}},ty1}>>4;
					vectordirection[`ZOffset] = {{4{tz1[23]}},tz1}>>4;
					//state <= 0;
					state <= 26;
					raystate <= raystate + 1;//shadow	
					//here is where shadow is launched
				end
			end
			//calculate normal at point
			5'd21:begin
				if(hit==1)begin
				tx2 = ri[`XOffset]-Spheres[shadowsphere][`XOffset];
				ty2 = ri[`YOffset]-Spheres[shadowsphere][`YOffset];
				tz2 = ri[`ZOffset]-Spheres[shadowsphere][`ZOffset];
				
				tx1[23:0] = (tx2[23])?((~tx2[23:0])+1):(tx2[23:0]);
				ty1[23:0] = (ty2[23])?((~ty2[23:0])+1):(ty2[23:0]);
   				tz1[23:0] = (tz2[23])?((~tz2[23:0])+1):(tz2[23:0]);

				//Spheres[spherecount][`R1Offset] is positive.

				tx3 = tx1[23:0]*Spheres[shadowsphere][`R1Offset];
				ty3 = ty1[23:0]*Spheres[shadowsphere][`R1Offset];
				tz3 = tz1[23:0]*Spheres[shadowsphere][`R1Offset];
				
				tx4 = (tx2[23])?((~tx3[47:0])+1):tx3[47:0];
				ty4 = (ty2[23])?((~ty3[47:0])+1):ty3[47:0];
				tz4 = (tz2[23])?((~tz3[47:0])+1):tz3[47:0];
				
				rn[`XOffset] = tx4[35:12];
				rn[`YOffset] = ty4[35:12];
				rn[`ZOffset] = tz4[35:12];
				end
				else begin
					rn[`XOffset] = Planes[shadowplane][`ApOffset];
					rn[`YOffset] = Planes[shadowplane][`BpOffset];
					rn[`ZOffset] = Planes[shadowplane][`CpOffset];
				end
				
				state <= 24;
			end
			//R = I - 2(N.I)N
			5'd22:begin
				//2(N.I)
				tx1[23:0] = (vectordirection[`XSign])?((~vectordirection[`XOffset])+1):(vectordirection[`XOffset]);
				ty1[23:0] = (vectordirection[`YSign])?((~vectordirection[`YOffset])+1):(vectordirection[`YOffset]);
   				tz1[23:0] = (vectordirection[`ZSign])?((~vectordirection[`ZOffset])+1):(vectordirection[`ZOffset]);
				tx2[23:0] = (rn[`XSign])?((~rn[`XOffset])+1):(rn[`XOffset]);
				ty2[23:0] = (rn[`YSign])?((~rn[`YOffset])+1):(rn[`YOffset]);
				tz2[23:0] = (rn[`ZSign])?((~rn[`ZOffset])+1):(rn[`ZOffset]);
				ty3 = ty1[23:0]*ty2[23:0];
				tx3 = tx1[23:0]*tx2[23:0];
				tz3 = tz1[23:0]*tz2[23:0];
				tx4 = (vectordirection[`XSign]^rn[`XSign])?((~tx3[47:0])+1):tx3[47:0];
				ty4 = (vectordirection[`YSign]^rn[`YSign])?((~ty3[47:0])+1):ty3[47:0];
				tz4 = (vectordirection[`ZSign]^rn[`ZSign])?((~tz3[47:0])+1):tz3[47:0];
				tmagx[47:0] = tx4[47:0];
				tmagy[47:0] = ty4[47:0];
				tmagz[47:0] = tz4[47:0];
	    		Magnitude = tmagx + tmagy + tmagz;

				NdotI = Magnitude[34:11];
				
				state <= 23;
			end
			5'd23:begin
				//I - 2(N.I)N
				tx1[23:0] = (NdotI[23])?((~NdotI[23:0])+1):(NdotI[23:0]);

				tx2[23:0] = (rn[`XSign])?((~rn[`XOffset])+1):(rn[`XOffset]);
				ty2[23:0] = (rn[`YSign])?((~rn[`YOffset])+1):(rn[`YOffset]);
				tz2[23:0] = (rn[`ZSign])?((~rn[`ZOffset])+1):(rn[`ZOffset]);
				ty3 = tx1[23:0]*ty2[23:0];
				tx3 = tx1[23:0]*tx2[23:0];
				tz3 = tx1[23:0]*tz2[23:0];
				tx4 = (NdotI[23]^rn[`XSign])?((~tx3[47:0])+1):tx3[47:0];
				ty4 = (NdotI[23]^rn[`YSign])?((~ty3[47:0])+1):ty3[47:0];
				tz4 = (NdotI[23]^rn[`ZSign])?((~tz3[47:0])+1):tz3[47:0];
				
				vectordirection[`XOffset] = vectordirection[`XOffset] - tx4[35:12];
				vectordirection[`YOffset] = vectordirection[`YOffset] - ty4[35:12];
				vectordirection[`ZOffset] = vectordirection[`ZOffset] - tz4[35:12];
				
				
				state <= 0;
				//here is where reflection is launched
			end
			5'd24:begin
				//do Bruce shadowing
				tx1[23:0] = (vectordirection[`XSign])?((~vectordirection[`XOffset])+1):(vectordirection[`XOffset]);
				ty1[23:0] = (vectordirection[`YSign])?((~vectordirection[`YOffset])+1):(vectordirection[`YOffset]);
   				tz1[23:0] = (vectordirection[`ZSign])?((~vectordirection[`ZOffset])+1):(vectordirection[`ZOffset]);
				tx2[23:0] = (rn[`XSign])?((~rn[`XOffset])+1):(rn[`XOffset]);
				ty2[23:0] = (rn[`YSign])?((~rn[`YOffset])+1):(rn[`YOffset]);
				tz2[23:0] = (rn[`ZSign])?((~rn[`ZOffset])+1):(rn[`ZOffset]);
				ty3 = ty1[23:0]*ty2[23:0];
				tx3 = tx1[23:0]*tx2[23:0];
				tz3 = tz1[23:0]*tz2[23:0];
				tx4 = (vectordirection[`XSign]^rn[`XSign])?((~tx3[47:0])+1):tx3[47:0];
				ty4 = (vectordirection[`YSign]^rn[`YSign])?((~ty3[47:0])+1):ty3[47:0];
				tz4 = (vectordirection[`ZSign]^rn[`ZSign])?((~tz3[47:0])+1):tz3[47:0];
				tmagx[47:0] = tx4[47:0];
				tmagy[47:0] = ty4[47:0];
				tmagz[47:0] = tz4[47:0];
				Magnitude = tmagx + tmagy + tmagz;
				NdotI = Magnitude[34:11];

				if(hit ==1)state <= 25;
				else begin
					state <= 7;
					planecount <= 0;
					spherecount <= 0;
				end
			end
			5'd25:begin
				//vectordirection <= storedv;
				if(Magnitude[47]==1 && hit == 1)begin
					redthistime = redthistime >> 1;
					greenthistime = greenthistime >> 1;
					bluethistime = bluethistime >> 1;
					state <= 29;
				end
				else begin
					tx1 = Magnitude[23:12] * redthistime;
					ty1 = Magnitude[23:12] * bluethistime;
					tz1 = Magnitude[23:12] * greenthistime;
					tx2 = tx1[23:12] + (redthistime>>1);
					ty2 = ty1[23:12] + (bluethistime>>1);
					tz2 = tz1[23:12] + (greenthistime>>1);
					if(hit == 1)redthistime = tx2[11:0];
					if(hit == 1)bluethistime = ty2[11:0];
					if(hit == 1)greenthistime = tz2[11:0];
					state <= 7;	
					planecount <= 0;
					spherecount <= 0;
				end	
						
			end
			5'd26:begin
				tx1[23:0] = (vectordirection[`XSign])?((~vectordirection[`XOffset])+1):(vectordirection[`XOffset]);
				tmagx[47:0] = tx1[23:0]*tx1[23:0];
				ty1[23:0] = (vectordirection[`YSign])?((~vectordirection[`YOffset])+1):(vectordirection[`YOffset]);
				tmagy[47:0] = ty1[23:0]*ty1[23:0];
   				tz1[23:0] = (vectordirection[`ZSign])?((~vectordirection[`ZOffset])+1):(vectordirection[`ZOffset]);
				tmagz[47:0] = tz1[23:0]*tz1[23:0];

				Magnitude = tmagx + tmagy + tmagz;
				distancetolight = Magnitude<<8; 
				N2 = Magnitude[35:12];
				sqrtStart <= 1;	
				state <= 27;
				
			end
			5'd27:begin
				if(sqrtDone)begin
					state <= 28;
					numerx <= {vectordirection[`XOffset],12'b0};
					numery <= {vectordirection[`YOffset],12'b0};
					numerz <= {vectordirection[`ZOffset],12'b0};
					denomx <= N;
					denomy <= N;
					denomz <= N;
					sqrtStart <= 0;
					sqrtReset <= 1;
				end
				else begin
					state <= 27;
				end
			end
			5'd28:begin
				sqrtReset <= 0;
				if(divcount==5)begin //probably too many cycles, no just right
					divcount <= 0;
					vectordirection[`XOffset] = quotientx[23:0];
					vectordirection[`YOffset] = quotienty[23:0];
					vectordirection[`ZOffset] = quotientz[23:0];
					state <= 21;	
				end 
				else begin
					divcount <= divcount + 1;
					state <= 28;
				end
			end
			//Planes
			5'd2:begin
				state <= 0;
			end
			5'd8:begin
				state <= 0;
			end
			5'd9:begin
				sqrtReset <= 0;
				//Planes[planecount][`AOffset]
				tx1[23:0] = (vectordirection[`XSign])?((~vectordirection[`XOffset])+1):(vectordirection[`XOffset]);
				ty1[23:0] = (vectordirection[`YSign])?((~vectordirection[`YOffset])+1):(vectordirection[`YOffset]);
   				tz1[23:0] = (vectordirection[`ZSign])?((~vectordirection[`ZOffset])+1):(vectordirection[`ZOffset]);
				tx2[23:0] = (Planes[planecount][`ApSign])?((~Planes[planecount][`ApOffset])+1):(Planes[planecount][`ApOffset]);
				ty2[23:0] = (Planes[planecount][`BpSign])?((~Planes[planecount][`BpOffset])+1):(Planes[planecount][`BpOffset]);
				tz2[23:0] = (Planes[planecount][`CpSign])?((~Planes[planecount][`CpOffset])+1):(Planes[planecount][`CpOffset]);
				ty3 = ty1[23:0]*ty2[23:0];
				tx3 = tx1[23:0]*tx2[23:0];
				tz3 = tz1[23:0]*tz2[23:0];
				tx4 = (vectordirection[`XSign]^Planes[planecount][`ApSign])?((~tx3[47:0])+1):tx3[47:0];
				ty4 = (vectordirection[`YSign]^Planes[planecount][`BpSign])?((~ty3[47:0])+1):ty3[47:0];
				tz4 = (vectordirection[`ZSign]^Planes[planecount][`CpSign])?((~tz3[47:0])+1):tz3[47:0];
				tmagx[47:0] = tx4[47:0];
				tmagy[47:0] = ty4[47:0];
				tmagz[47:0] = tz4[47:0];
				Magnitude = tmagx + tmagy + tmagz;
				vd = Magnitude[35:12];
				if(Magnitude[47]==0||`IsShadow)begin
					if(planecount==LastPlane)begin
						if(hit)begin
							if(hit == 1)begin
								state <= 20;
							end
							else begin
								
								tx5 = (Light[`XOffset]-ri[`XOffset]);	
								ty5 = (Light[`YOffset]-ri[`YOffset]);
								tz5 = (Light[`ZOffset]-ri[`ZOffset]);
								vectordirection[`XOffset] = {{4{tx5[23]}},tx5}>>4;
								vectordirection[`YOffset] = {{4{ty5[23]}},ty5}>>4;
								vectordirection[`ZOffset] = {{4{tz5[23]}},tz5}>>4;
								//state <= 0;
								state <= 26;
								raystate <= raystate + 1;//shadow	
							end
						end
						else begin
							writebufferaddr[writebufferhead] = {county[20:12],countx[20:12]};
							writebufferdata[writebufferhead] = 0;
							if(raystate==`InitRay)writebufferhead <= writebufferhead + 1;
							if(raystate==`InitRay)redaliasbuffer[aliasstate]=0;
							if(raystate==`InitRay)greenaliasbuffer[aliasstate]=0;
							if(raystate==`InitRay)bluealiasbuffer[aliasstate]=0;	
							state <= 29;
						end
					end 
					else begin
						state <= 9;
						planecount <= planecount + 1;
					end
				end
				else begin
					state <= 11; 
				end
			end
			5'd11:begin
				if(raystate==`InitRay)begin
					tx1[23:0] = (Origin[`XSign])?((~Origin[`XOffset])+1):(Origin[`XOffset]);
					ty1[23:0] = (Origin[`YSign])?((~Origin[`YOffset])+1):(Origin[`YOffset]);
	   				tz1[23:0] = (Origin[`ZSign])?((~Origin[`ZOffset])+1):(Origin[`ZOffset]);
				end
				else begin
					tx1[23:0] = (ri[`XSign])?((~ri[`XOffset])+1):(ri[`XOffset]);
					ty1[23:0] = (ri[`YSign])?((~ri[`YOffset])+1):(ri[`YOffset]);
   					tz1[23:0] = (ri[`ZSign])?((~ri[`ZOffset])+1):(ri[`ZOffset]);
				end

				tx2[23:0] = (Planes[planecount][`ApSign])?((~Planes[planecount][`ApOffset])+1):(Planes[planecount][`ApOffset]);
				ty2[23:0] = (Planes[planecount][`BpSign])?((~Planes[planecount][`BpOffset])+1):(Planes[planecount][`BpOffset]);
				tz2[23:0] = (Planes[planecount][`CpSign])?((~Planes[planecount][`CpOffset])+1):(Planes[planecount][`CpOffset]);
				ty3 = ty1[23:0]*ty2[23:0];
				tx3 = tx1[23:0]*tx2[23:0];
				tz3 = tz1[23:0]*tz2[23:0];
				if(raystate==`InitRay)begin
					tx4 = (~(Origin[`XSign]^Planes[planecount][`ApSign]))?((~tx3[47:0])+1):tx3[47:0];
					ty4 = (~(Origin[`YSign]^Planes[planecount][`BpSign]))?((~ty3[47:0])+1):ty3[47:0];
					tz4 = (~(Origin[`ZSign]^Planes[planecount][`CpSign]))?((~tz3[47:0])+1):tz3[47:0];
				end
				else begin
					tx4 = (~(ri[`XSign]^Planes[planecount][`ApSign]))?((~tx3[47:0])+1):tx3[47:0];
					ty4 = (~(ri[`YSign]^Planes[planecount][`BpSign]))?((~ty3[47:0])+1):ty3[47:0];
					tz4 = (~(ri[`ZSign]^Planes[planecount][`CpSign]))?((~tz3[47:0])+1):tz3[47:0];
				end
	
				tmagx[47:0] = tx4[47:0];
				tmagy[47:0] = ty4[47:0];
				tmagz[47:0] = tz4[47:0];
				Magnitude = tmagx + tmagy + tmagz;
				vo = Magnitude[35:12] - Planes[planecount][`DOffset];
				
				//tx5 = (vo[23])?(~vo+1):vo;
				//ty5 = (vd[23])?(~vd+1):vd;
				numerx <= {vo,12'b0};

				denomx <= vd;

				state <= 12;
			end
			5'd12:begin
				if(divcount==5)begin //probably too many cycles, no just right
					divcount <= 0;
					t = quotientx[23:0];
					//t = (vo[23]^vd[23])?(~tz5+1):tz5;
					if(t[23]==0)begin
						if( ((t<storedt)||(hit == 0))&&(t>24'h000400) )begin
							tx1[23:0] = (vectordirection[`XSign])?((~vectordirection[`XOffset])+1):(vectordirection[`XOffset]);
							ty1[23:0] = (vectordirection[`YSign])?((~vectordirection[`YOffset])+1):(vectordirection[`YOffset]);
			   				tz1[23:0] = (vectordirection[`ZSign])?((~vectordirection[`ZOffset])+1):(vectordirection[`ZOffset]);
							tx2[23:0] = (t[23])?((~t[23:0])+1):(t[23:0]);
							tx3 = tx1[23:0]*tx2[23:0];
							ty3 = ty1[23:0]*tx2[23:0];
							tz3 = tz1[23:0]*tx2[23:0];
							tx4 = (vectordirection[`XSign]^t[23])?((~tx3[47:0])+1):tx3[47:0];
							ty4 = (vectordirection[`YSign]^t[23])?((~ty3[47:0])+1):ty3[47:0];
							tz4 = (vectordirection[`ZSign]^t[23])?((~tz3[47:0])+1):tz3[47:0];
							tmagx[47:0] = tx4[47:0];
							tmagy[47:0] = ty4[47:0];
							tmagz[47:0] = tz4[47:0];
							if(raystate == `InitRay)begin
								ri[`XOffset] = Origin[`XOffset] + tmagx[35:12];
								ri[`YOffset] = Origin[`YOffset] + tmagy[35:12];
								ri[`ZOffset] = Origin[`ZOffset] + tmagz[35:12];
							end
							else begin
								ri[`XOffset] = storedri[`XOffset] + tmagx[35:12];
								ri[`YOffset] = storedri[`YOffset] + tmagy[35:12];
								ri[`ZOffset] = storedri[`ZOffset] + tmagz[35:12];
							end
							//writebufferaddr[writebufferhead] = {county[20:12],countx[20:12]};
							//writebufferdata[writebufferhead] = {Spheres[spherecount][`IsLight],Spheres[spherecount][`COffset]};
							//writebufferhead <= writebufferhead + 1;
							
							tx5[23:0] = (ri[`XSign])?((~ri[`XOffset])+1):(ri[`XOffset]);
							ty5[23:0] = (ri[`YSign])?((~ri[`YOffset])+1):(ri[`YOffset]);
			   				tz5[23:0] = (ri[`ZSign])?((~ri[`ZOffset])+1):(ri[`ZOffset]);

							if(`HasLimits)begin
								if((tx5[23:12]<Planes[planecount][`XLOffset])&&(ty5[23:12]<Planes[planecount][`YLOffset])&&(tz5[23:12]<Planes[planecount][`ZLOffset]))begin
									hit = 2;
									storedt <= t;
									storedv <= vectordirection;
									if(Planes[planecount][`CheckerWidth]!=0)begin
										if((ri[63:60]&Planes[planecount][`CheckerWidth])==(ri[15:12]&Planes[planecount][`CheckerWidth]))begin
											redthistime = {2'b0,Planes[planecount][`RPOffset],5'b0};
											bluethistime = {2'b0,Planes[planecount][`BPOffset],5'b0};
											greenthistime = {2'b0,Planes[planecount][`GPOffset],5'b0};	
										end
										else begin
											redthistime = {2'b0,Planes[planecount][`RPOffset],5'b0}>>2;
											bluethistime = {2'b0,Planes[planecount][`BPOffset],5'b0}>>2;
											greenthistime = {2'b0,Planes[planecount][`GPOffset],5'b0}>>2;
										end		
									end
									else begin
										redthistime = {2'b0,Planes[planecount][`RPOffset],5'b0};
										bluethistime = {2'b0,Planes[planecount][`BPOffset],5'b0};
										greenthistime = {2'b0,Planes[planecount][`GPOffset],5'b0};
									end

									shadowplane <= planecount;
									shadowR <= Planes[planecount][`RPOffset];
									shadowB <= Planes[planecount][`BPOffset];
									shadowG <= Planes[planecount][`GPOffset];
								end
								else begin
								
								end
							end
							else begin
								hit = 2;
								storedt <= t;
								storedv <= vectordirection;
								if(Planes[planecount][`CheckerWidth]!=0)begin
									if((ri[63:60]&Planes[planecount][`CheckerWidth])==(ri[15:12]&Planes[planecount][`CheckerWidth]))begin
										redthistime = {2'b0,Planes[planecount][`RPOffset],5'b0};
										bluethistime = {2'b0,Planes[planecount][`BPOffset],5'b0};
										greenthistime = {2'b0,Planes[planecount][`GPOffset],5'b0};	
									end
									else begin
										redthistime = {2'b0,Planes[planecount][`RPOffset],5'b0}>>2;
										bluethistime = {2'b0,Planes[planecount][`BPOffset],5'b0}>>2;
										greenthistime = {2'b0,Planes[planecount][`GPOffset],5'b0}>>2;
									end		
								end
								else begin
									redthistime = {2'b0,Planes[planecount][`RPOffset],5'b0};
									bluethistime = {2'b0,Planes[planecount][`BPOffset],5'b0};
									greenthistime = {2'b0,Planes[planecount][`GPOffset],5'b0};
								end

								shadowplane <= planecount;
								shadowR <= Planes[planecount][`RPOffset];
								shadowB <= Planes[planecount][`BPOffset];
								shadowG <= Planes[planecount][`GPOffset];
							end

						end

						if(planecount==LastPlane)begin
							if(hit)begin
								if(hit == 1)begin
									state <= 20;
								end
								else begin
									tx6 = (Light[`XOffset]-ri[`XOffset]);
									ty6 = (Light[`YOffset]-ri[`YOffset]);
									tz6 = (Light[`ZOffset]-ri[`ZOffset]);
									vectordirection[`XOffset] = {{4{tx6[23]}},tx6}>>4;	
									vectordirection[`YOffset] = {{4{ty6[23]}},ty6}>>4;
									vectordirection[`ZOffset] = {{4{tz6[23]}},tz6}>>4;
									//vectordirection[`XOffset] <= (Light[`XOffset]-ri[`XOffset]);	
									//vectordirection[`YOffset] <= (Light[`YOffset]-ri[`YOffset]);
									//vectordirection[`ZOffset] <= (Light[`ZOffset]-ri[`ZOffset]);
									//state <= 0;
									state <= 26;
									raystate <= raystate + 1;//shadow	
								end
							end
							else begin
								writebufferaddr[writebufferhead] = {county[20:12],countx[20:12]};
								writebufferdata[writebufferhead] = 0;
								if(raystate==`InitRay)writebufferhead <= writebufferhead + 1;
									if(raystate==`InitRay)						redaliasbuffer[aliasstate]=0;
							if(raystate==`InitRay)greenaliasbuffer[aliasstate]=0;
							if(raystate==`InitRay)bluealiasbuffer[aliasstate]=0;	
								state <= 29;
							end
						end 
						else begin
							state <= 9;
							planecount <= planecount + 1;
						end
					
					end
					else begin
						if(planecount==LastPlane)begin
							if(hit)begin
								if(hit == 1)begin
									state <= 20;
								end
								else begin
									tx7 = (Light[`XOffset]-ri[`XOffset]);
									ty7 = (Light[`YOffset]-ri[`YOffset]);
									tz7 = (Light[`ZOffset]-ri[`ZOffset]);
									vectordirection[`XOffset] = {{4{tx7[23]}},tx7}>>4;	
									vectordirection[`YOffset] = {{4{ty7[23]}},ty7}>>4;
									vectordirection[`ZOffset] = {{4{tz7[23]}},tz7}>>4;
									//vectordirection[`XOffset] <= (Light[`XOffset]-ri[`XOffset]);	
									//vectordirection[`YOffset] <= (Light[`YOffset]-ri[`YOffset]);
									//vectordirection[`ZOffset] <= (Light[`ZOffset]-ri[`ZOffset]);
									//state <= 0;
									state <= 26;
									raystate <= raystate + 1;//shadow	
								end
							end
							else begin
							writebufferaddr[writebufferhead] = {county[20:12],countx[20:12]};
							writebufferdata[writebufferhead] = 0;
							if(raystate==`InitRay)writebufferhead <= writebufferhead + 1;
							if(raystate==`InitRay)							redaliasbuffer[aliasstate]=0;
							if(raystate==`InitRay)greenaliasbuffer[aliasstate]=0;
							if(raystate==`InitRay)bluealiasbuffer[aliasstate]=0;	
								state <= 29;
							end
						end 
						else begin
							state <= 9;
							planecount <= planecount + 1;
						end
					
					end
				end 
				else begin
					divcount <= divcount + 1;
					state <= 12;
				end
			end
			5'd14:begin
				state <= 0;
			end
			5'd15:begin
				state <= 0;
			end
			5'd17:begin
				state <= 0;
			end
			5'd30:begin
				state <= 0;			
			end
			5'd31:begin
				state <= 0;
			end
			5'd29:begin
				if(hit)begin
			    	//2'b0,10'bcolor, weight 12bit decimal
					tx1 = redthistime * weight;
					ty1 = greenthistime * weight;
					tz1 = bluethistime * weight;
				
					redsofar = redsofar + tx1[23:12];
					greensofar = greensofar + ty1[23:12];
					bluesofar = bluesofar + tz1[23:12];
				
					storedri = ri;
					
					//overflow check
					if(redsofar[11:10]!=0)redsofar = 12'h3ff;
					if(greensofar[11:10]!=0)greensofar = 12'h3ff;
					if(bluesofar[11:10]!=0)bluesofar = 12'h3ff;
				
					if(hit==1)tx2 = weight * Spheres[shadowsphere][`RFOffset];
					else tx2 = weight * Planes[shadowplane][`RfPOffset];
					weight = tx2[23:12];	
					
					//mightmaketoobright with Spheres[shadowsphere][`IsLight]
					writebufferaddr[writebufferhead] = {county[20:12],countx[20:12]};
					writebufferdata[writebufferhead] = {Spheres[shadowsphere][`IsLight],redsofar[9:5],greensofar[9:5],bluesofar[9:5]};
					writebufferhead <= writebufferhead + 1;
					redaliasbuffer[aliasstate]=redsofar;
					greenaliasbuffer[aliasstate]=greensofar;
					bluealiasbuffer[aliasstate]=bluesofar;
					
					if(numreflections == maxreflections || weight<`MinWeight || Spheres[shadowsphere][`IsLight])begin
						hit <= 0;
						state <= 29;
					end
					else begin
						spherecount <= 0;
						planecount <= 0;
						state <= 22;
						vectordirection <= storedv;
						redthistime = 0;
						//shadowsphere <= 0;
						greenthistime = 0;
						bluethistime = 0;
						hit <= 0;
						numreflections = numreflections + 1;
						raystate = raystate + 1;
					end			
							
				end
				else begin
			
					shadowplane <= 0;
					hit <= 0;
					planecount <= 0;
					numreflections <= 0;
					raystate <= `InitRay;
					spherecount <= 0;
					weight <= 12'hfff;
					redsofar <= 12'h000;
					greensofar <= 12'h000;
					bluesofar <= 12'h000;
					shadowsphere <= 0;
					
					
					if(antialias4||antialias8)begin
						if(aliasstate==4&&antialias4&&!antialias8 || aliasstate==8&&antialias8)begin
							aliasstate <= 0;
							if(antialias4&&!antialias8)tx1 = (redaliasbuffer[0]>>1)+(redaliasbuffer[1]>>3)+(redaliasbuffer[2]>>3)+(redaliasbuffer[3]>>3)+(redaliasbuffer[4]>>3);
							else tx1 = (redaliasbuffer[0]>>2)+(redaliasbuffer[1]>>4)+(redaliasbuffer[2]>>4)+(redaliasbuffer[3]>>4)+(redaliasbuffer[4]>>4)+(redaliasbuffer[5]>>3)+(redaliasbuffer[6]>>3)+(redaliasbuffer[7]>>3)+(redaliasbuffer[8]>>3);
							if(antialias4&&!antialias8)ty1 = (greenaliasbuffer[0]>>1)+(greenaliasbuffer[1]>>3)+(greenaliasbuffer[2]>>3)+(greenaliasbuffer[3]>>3)+(greenaliasbuffer[4]>>3);
							else ty1 = (greenaliasbuffer[0]>>2)+(greenaliasbuffer[1]>>4)+(greenaliasbuffer[2]>>4)+(greenaliasbuffer[3]>>4)+(greenaliasbuffer[4]>>4)+(greenaliasbuffer[5]>>3)+(greenaliasbuffer[6]>>3)+(greenaliasbuffer[7]>>3)+(greenaliasbuffer[8]>>3);
							if(antialias4&&!antialias8)tz1 = (bluealiasbuffer[0]>>1)+(bluealiasbuffer[1]>>3)+(bluealiasbuffer[2]>>3)+(bluealiasbuffer[3]>>3)+(bluealiasbuffer[4]>>3);
							else tz1 = (bluealiasbuffer[0]>>2)+(bluealiasbuffer[1]>>4)+(bluealiasbuffer[2]>>4)+(bluealiasbuffer[3]>>4)+(bluealiasbuffer[4]>>4)+(bluealiasbuffer[5]>>3)+(bluealiasbuffer[6]>>3)+(bluealiasbuffer[7]>>3)+(bluealiasbuffer[8]>>3);
							
							writebufferaddr[writebufferhead] = {county[20:12],countx[20:12]};
							writebufferdata[writebufferhead] = (county==0)?0:{Spheres[shadowsphere][`IsLight],tx1[9:5],ty1[9:5],tz1[9:5]};
							writebufferhead <= writebufferhead + 1;
							
							if(countx!=0)begin//check this
								countx <= countx-24'h001000;
								tx5 = ((countx-24'h001000)>>>5)-(ScreenWidth_2);
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});	
								ty5 = (county>>>5)-ScreenHeight_2;			
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
								vectordirection[`ZOffset] <= ScreenDistance-(Origin[`ZOffset]>>>5);
								state <= 0;
							end
							else if(county!=0) begin
								countx <= ScreenWidth<<5;
								county <= county-24'h001000;
								tx5 = ScreenWidth-ScreenWidth_2;
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});
								ty5 = ((county-24'h001000)>>>5)-ScreenHeight_2;	
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
								vectordirection[`ZOffset] <= ScreenDistance-(Origin[`ZOffset]>>>5);
								state <= 0;
							end
							else begin
								tx5 = ScreenWidth-ScreenWidth_2;
								ty5 = ScreenHeight - ScreenHeight_2;
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});	
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
								vectordirection[`ZOffset] <= ScreenDistance-(Origin[`ZOffset]>>>5);
								countx <= ScreenWidth<<5;
								county <= ScreenHeight<<5;
								state <= 1;
								
								if(~KEY[0])ScreenDistance <= ScreenDistance + 24'h000100;
								else if(~KEY[1])ScreenDistance <= ScreenDistance + 24'hFFFF00;
								
								if(SW[17]&&~SW[16])lightx <= lightx + 24'h001000;
								else if(SW[16]&&~SW[17])lightx <= lightx + 24'hfff000;
								if(SW[15]&&~SW[14])lighty <= lighty + 24'h001000;
								else if(SW[14]&&~SW[15])lighty <= lighty + 24'hfff000;
								if(SW[13]&&~SW[12])lightz <= lightz + 24'h001000;
								else if(SW[12]&&~SW[13])lightz <= lightz + 24'hfff000;
								
								if(SW[11]&&~SW[10])Origin[`XOffset] <= Origin[`XOffset] + 24'h001000;
								else if(SW[10]&&~SW[11])Origin[`XOffset] <= Origin[`XOffset]  + 24'hfff000;
								if(SW[9] &&~SW[8] )Origin[`YOffset] <= Origin[`YOffset] + 24'h001000;
								else if(SW[8] &&~SW[9] )Origin[`YOffset] <= Origin[`YOffset]  + 24'hfff000;
								if(SW[7] &&~SW[6] )Origin[`ZOffset] <= Origin[`ZOffset] + 24'h001000;
								else if(SW[6] &&~SW[7] )Origin[`ZOffset] <= Origin[`ZOffset]  + 24'hfff000;
																
							end
							
						end
						else begin
							aliasstate <= aliasstate + 1;
							if(aliasstate==0)begin
								tx5 = ((countx-24'h000800)>>>5)-(ScreenWidth_2);
								ty5 = ((county-24'h000800)>>>5)-ScreenHeight_2;
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							end
							else if(aliasstate==1)begin
								tx5 = ((countx-24'h000800)>>>5)-(ScreenWidth_2);
								ty5 = ((county+24'h000800)>>>5)-ScreenHeight_2;
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							end
							else if(aliasstate==2)begin
								tx5 = ((countx+24'h000800)>>>5)-(ScreenWidth_2);
								ty5 = ((county-24'h000800)>>>5)-ScreenHeight_2;
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							end
							else if(aliasstate==3)begin
								tx5 = ((countx+24'h000800)>>>5)-(ScreenWidth_2);
								ty5 = ((county+24'h000800)>>>5)-ScreenHeight_2;
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							end
							else if(aliasstate==4)begin
								tx5 = ((countx-24'h000800)>>>5)-(ScreenWidth_2);
								ty5 = ((county)>>>5)-ScreenHeight_2;
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							end
							else if(aliasstate==5)begin
								tx5 = ((countx)>>>5)-(ScreenWidth_2);
								ty5 = ((county+24'h000800)>>>5)-ScreenHeight_2;
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							end
							else if(aliasstate==6)begin
								tx5 = ((countx)>>>5)-(ScreenWidth_2);
								ty5 = ((county-24'h000800)>>>5)-ScreenHeight_2;
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							end
							else if(aliasstate==7)begin
								tx5 = ((countx+24'h000800)>>>5)-(ScreenWidth_2);
								ty5 = ((county)>>>5)-ScreenHeight_2;
								vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});
								vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							end
							state <= 0;
							vectordirection[`ZOffset] <= ScreenDistance-(Origin[`ZOffset]>>>5);
						end
					end
					else begin
						if(countx!=0)begin//check this
							countx <= countx-24'h001000;
							//`define XOffset 71:48 
							//`define YOffset 47:24
							//`define ZOffset 23:0
							tx5 = ((countx-24'h001000)>>>5)-(ScreenWidth_2);
							vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});	
							ty5 = (county>>>5)-ScreenHeight_2;			
							vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							vectordirection[`ZOffset] <= ScreenDistance-(Origin[`ZOffset]>>>5);
							state <= 0;
						end
						else if(county!=0) begin
							countx <= ScreenWidth<<5;
							county <= county-24'h001000;
							tx5 = ScreenWidth-ScreenWidth_2;
							vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});
							ty5 = ((county-24'h001000)>>>5)-ScreenHeight_2;	
							vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							vectordirection[`ZOffset] <= ScreenDistance-(Origin[`ZOffset]>>>5);
							state <= 0;
						end
						else begin
							tx5 = ScreenWidth-ScreenWidth_2;
							ty5 = ScreenHeight - ScreenHeight_2;
							vectordirection[`XOffset] <= tx5-({{5{Origin[`XSign]}},Origin[71:53]});	
							vectordirection[`YOffset] <= ty5-({{5{Origin[`YSign]}},Origin[47:29]});
							vectordirection[`ZOffset] <= ScreenDistance-(Origin[`ZOffset]>>>5);
							countx <= ScreenWidth<<5;
							county <= ScreenHeight<<5;
							state <= 1;
							
							if(~KEY[0])ScreenDistance <= ScreenDistance + 24'h000100;
							else if(~KEY[1])ScreenDistance <= ScreenDistance + 24'hFFFF00;
							
							if(SW[17]&&~SW[16])lightx <= lightx + 24'h001000;
							else if(SW[16]&&~SW[17])lightx <= lightx + 24'hfff000;
							if(SW[15]&&~SW[14])lighty <= lighty + 24'h001000;
							else if(SW[14]&&~SW[15])lighty <= lighty + 24'hfff000;
							if(SW[13]&&~SW[12])lightz <= lightz + 24'h001000;
							else if(SW[12]&&~SW[13])lightz <= lightz + 24'hfff000;
							
							if(SW[11]&&~SW[10])Origin[`XOffset] <= Origin[`XOffset] + 24'h001000;
							else if(SW[10]&&~SW[11])Origin[`XOffset] <= Origin[`XOffset]  + 24'hfff000;
							if(SW[9] &&~SW[8] )Origin[`YOffset] <= Origin[`YOffset] + 24'h001000;
							else if(SW[8] &&~SW[9] )Origin[`YOffset] <= Origin[`YOffset]  + 24'hfff000;
							if(SW[7] &&~SW[6] )Origin[`ZOffset] <= Origin[`ZOffset] + 24'h001000;
							else if(SW[6] &&~SW[7] )Origin[`ZOffset] <= Origin[`ZOffset]  + 24'hfff000;
							
						end
					end
				end
			end

		endcase
	end
	
	if(Reset)begin
	
	end else if ((~VGA_VS | ~VGA_HS)) begin
		if(writebufferhead!=writebuffertail)begin
			addr_reg <= writebufferaddr[writebuffertail];
			writebuffertail <= writebuffertail + 1;
			data_reg <= writebufferdata[writebuffertail];
			we <= 1'b0;
		end else begin
			we <= 1'b1;
		end
	end
	else begin
		addr_reg <= {Coord_Y[8:0],Coord_X[8:0]} ;//address to read from, x inverted so we start reading from left side of screen, 1024->0 instaed of what vga thinks 0->1024
		we <= 1'b1;
	end
	
	
	

	
	
end

/*
charmap[CHAR*7+county][countx]
wire [0:4] charmap[0:76];
	//0
assign charmap[0]  =	5'b01110;
*/

/*
//SDRAM PLL, 3ns skew
sdrampll sd(CLOCK_50,DRAM_CLK);

//niosII cpu
lab J(
      .clk                           (CLOCK_50),
      .in_port_to_the_Reset          (Reset),
      .in_port_to_the_Switch         (big_rand[17:0]),
      .in_port_to_the_done           (DONE),
      .in_port_to_the_pixel          (PIXEL),
      .out_port_from_the_char        (CHAR),
      .out_port_from_the_cmd         (cmd),
      .out_port_from_the_color       (COLOR),
      .out_port_from_the_x_1         (x1),
      .out_port_from_the_x_2         (x2),
      .out_port_from_the_y_1         (y1),
      .out_port_from_the_y_2         (y2),
	    .out_port_from_the_wtf		     (LEDG[7:0]),
      .reset_n                       (~Reset),
      .zs_addr_from_the_sdram_0      (DRAM_ADDR),
      .zs_ba_from_the_sdram_0        ({DRAM_BA_1, DRAM_BA_0}),
      .zs_cas_n_from_the_sdram_0     (DRAM_CAS_N),
      .zs_cke_from_the_sdram_0       (DRAM_CKE),
      .zs_cs_n_from_the_sdram_0      (DRAM_CS_N),
      .zs_dq_to_and_from_the_sdram_0 (DRAM_DQ),
      .zs_dqm_from_the_sdram_0       ({DRAM_UDQM, DRAM_LDQM}),
      .zs_ras_n_from_the_sdram_0     (DRAM_RAS_N),
      .zs_we_n_from_the_sdram_0      (DRAM_WE_N)
		);
		*/

HexDigit Digit0(HEX0, debug[3:0]);
HexDigit Digit1(HEX1, debug[7:4]);
HexDigit Digit2(HEX2, debug[11:8]);
HexDigit Digit3(HEX3, debug[15:12]);
HexDigit Digit4(HEX4, debug[19:16]);
HexDigit Digit5(HEX5, raystate);
HexDigit Digit6(HEX6, state[3:0]);
HexDigit Digit7(HEX7, {3'b0,state[4]});		
reg leg;
assign LEDG[8]=leg;
		
		
endmodule


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

//bad things happen when origin goes negative x,y
