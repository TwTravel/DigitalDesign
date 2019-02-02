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
// Major Functions:	DE2 NIOS Reference Design
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V2.0 :| Johnny Chen       :| 06/07/19  :|      Initial Revision
// --------------------------------------------------------------------

module DE2_NIOS_HOST_MOUSE_VGA
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_27,						//	On Board 27 MHz
		CLOCK_50,						//	On Board 50 MHz
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
		DRAM_BA_1,						//	SDRAM Bank Address 1
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	Flash Interface		////////////////
		FL_DQ,							//	FLASH Data bus 8 Bits
		FL_ADDR,						//	FLASH Address bus 20 Bits
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
		TDI,  							//	CPLD -> FPGA (Data in)
		TCK,  							//	CPLD -> FPGA (Clock)
		TCS,  							//	CPLD -> FPGA (CS)
	    TDO,  							//	FPGA -> CPLD (Data out)
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
input			CLOCK_27;				//	On Board 27 MHz
input			CLOCK_50;				//	On Board 50 MHz
input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	SW;						//	Toggle Switch[17:0]
////////////////////////	7-SEG Display	////////////////////////
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
output			SRAM_UB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_LB_N;				//	SRAM High-byte Data Mask 
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

wire	CPU_CLK;
wire	CPU_RESET;
wire	CLK_18_4;
wire	CLK_25;

//	Flash
assign	FL_RST_N	=	1'b1;

//	16*2 LCD Module
assign	LCD_ON		=	1'b1;	//	LCD ON
assign	LCD_BLON	=	1'b1;	//	LCD Back Light	

//	All inout port turn to tri-state
assign	SD_DAT		=	1'bz;
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;

//	Disable USB speed select
assign	OTG_FSPEED	=	1'bz;
assign	OTG_LSPEED	=	1'bz;

//	Turn On TV Decoder
assign	TD_RESET	=	1'b1;

//	Set SD Card to SD Mode
assign	SD_DAT3		=	1'b1;

//-----------------------------MY PART OF CODE ---------------------------------//

//	All inout port turn to tri-state
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ		=	8'hzz;
assign	SRAM_DQ		=	16'hzzzz;
assign	OTG_DATA	=	16'hzzzz;
assign	SD_DAT		=	1'bz;
assign	ENET_DATA	=	16'hzzzz;
assign	TD_RESET	=	1'b1;	//	Allow 27 MHz input

wire [31:0]	mSEG7_DIG;
reg	 [31:0]	Cont;
wire		VGA_CTRL_CLK;
wire		AUD_CTRL_CLK;
wire [9:0]	mVGA_R;
wire [9:0]	mVGA_G;
wire [9:0]	mVGA_B;
wire [19:0]	mVGA_ADDR;			//video memory address
wire [9:0]  Coord_X, Coord_Y;	//display coods
wire		DLY_RST;
reg [9:0]	cur_x;
reg [9:0]	cur_y;

//DLA state machine variables
wire reset;
reg [17:0] addr_reg; //memory address register for SRAM
reg [15:0] data_reg; //memory data register  for SRAM
reg we;		//write enable for SRAM
reg [3:0] state;	//state machine
reg [7:0] led;		//debug led register
wire seed_low_bit, x_low_bit, y_low_bit; //rand low bits for SR
reg lock; //did we stay in sync?
reg memwait; //slow mem?

reg signed [10:0] delta_x1, delta_y1, x1_1, x1_2, y1_1, y1_2;
reg signed [10:0] delta_x2, delta_y2, x2_1, x2_2, y2_1, y2_2;
reg signed [10:0] delta_x, delta_y, x_end, y_end;
reg [8:0] i, j, i_1, j_1, i_2, j_2;

//reg driving_axis; // 0 = x, 1 = y
//reg vertical;    // 1 = vertical, 0 = horizontal
//reg [17:0] LEDR;
reg [4:0] line_number1, line_number2;
reg line; // 1 = line_number1, 0 = line_number2
reg [6:0] counter;
wire [10:0] x_min, x_max, y_min, y_max;	// max and min points
reg [8:0] ballx, bally;
reg [10:0] oldballx, oldbally;
reg [10:0] newballx, newbally;
reg [31:0] ball_h2s;			// hardware to software variable - SOPC input port

assign x_min = 10'd 3;			// max and min points - boundaries
assign x_max = 10'd 511;		//638;
assign y_min = 10'd 3;
assign y_max = 10'd 478;


wire [31:0] command_bus; //an input bus from the NiosII with command information
//reg [7:0] feedback_bus; //a bus used to send information back to the NiosII
//reg [7:0] readback_bus; //another bus used to send information back to the NiosII
wire [31:0] command_bus1;
wire [31:0] ball_xy;
wire [31:0] bounds_min;
wire [31:0] bounds_max;
wire [31:0] cur_xy;

VGA_Controller		u2	(	//	Host Side
							.iCursor_RGB_EN(4'b1111),
							.oAddress(mVGA_ADDR),
							.iCursor_X(cur_x),
							.iCursor_Y(cur_y),
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


// SRAM_control
assign SRAM_ADDR = addr_reg;
assign SRAM_DQ = (we)? 16'hzzzz : data_reg ;
assign SRAM_UB_N = 0;					// hi byte select enabled
assign SRAM_LB_N = 0;					// lo byte select enabled
assign SRAM_CE_N = 0;					// chip is enabled
assign SRAM_WE_N = we;					// write when ZERO
assign SRAM_OE_N = 0;					//output enable is overidden by WE

// Show SRAM on the VGA
//assign  mVGA_R = {SRAM_DQ[15:12], 6'b0} ;
//assign  mVGA_G = {SRAM_DQ[11:8], 6'b0} ;
//assign  mVGA_B = {SRAM_DQ[7:4], 6'b0} ;

// Show memory on the VGA, even/odd bytes
assign  mVGA_R = {(Coord_X[0]?SRAM_DQ[15:14]:SRAM_DQ[7:6]), 8'b0} ;
assign  mVGA_G = {(Coord_X[0]?SRAM_DQ[13:10]:SRAM_DQ[5:2]), 6'b0} ;
assign  mVGA_B = {(Coord_X[0]?SRAM_DQ[9:8]:SRAM_DQ[1:0]), 8'b0} ;

assign reset = ~KEY[0];
//assign LEDG = led;
parameter new_walker=5'd0, init=5'd1, test1=5'd2, test2=5'd3, update_walker=5'd4 ;

		
Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

VGA_Audio_PLL 		PLL2	(	.areset(~DLY_RST),.inclk0(CLOCK_27),
							.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);

// ------------------------------END OF MY CODE -----------------------------------//

//Reset_Delay	delay1	(.iRST(KEY[0]),.iCLK(CLOCK_50),.oRESET(CPU_RESET));


SDRAM_PLL 	PLL1	(.inclk0(CLOCK_50),.c0(DRAM_CLK),.c1(CPU_CLK),.c2(CLK_25));
//Audio_PLL 	PLL2	(.areset(!CPU_RESET),.inclk0(CLOCK_27),.c0(CLK_18_4));

system_0 	u0	(
				// 1) global signals:
                 .clk(CPU_CLK),
				 .clk_50(CLOCK_50),
                 .reset_n(DLY_RST),

                // the_Audio_0
                 .iCLK_18_4_to_the_Audio_0(CLK_18_4),
                 .oAUD_BCK_from_the_Audio_0(AUD_BCLK),
                 .oAUD_DATA_from_the_Audio_0(AUD_DACDAT),
                 .oAUD_LRCK_from_the_Audio_0(AUD_DACLRCK),
                 .oAUD_XCK_from_the_Audio_0(AUD_XCK),

				// the_DM9000A
				 .ENET_CLK_from_the_DM9000A(ENET_CLK),
                 .ENET_CMD_from_the_DM9000A(ENET_CMD),
                 .ENET_CS_N_from_the_DM9000A(ENET_CS_N),
                 .ENET_DATA_to_and_from_the_DM9000A(ENET_DATA),
                 .ENET_INT_to_the_DM9000A(ENET_INT),
                 .ENET_RD_N_from_the_DM9000A(ENET_RD_N),
                 .ENET_RST_N_from_the_DM9000A(ENET_RST_N),
                 .ENET_WR_N_from_the_DM9000A(ENET_WR_N),
				 .iOSC_50_to_the_DM9000A(CLOCK_50),
				 
                // the_ISP1362
                 .OTG_ADDR_from_the_ISP1362(OTG_ADDR),
                 .OTG_CS_N_from_the_ISP1362(OTG_CS_N),
                 .OTG_DATA_to_and_from_the_ISP1362(OTG_DATA),
                 .OTG_INT0_to_the_ISP1362(OTG_INT0),
                 .OTG_INT1_to_the_ISP1362(OTG_INT1),
                 .OTG_RD_N_from_the_ISP1362(OTG_RD_N),
                 .OTG_RST_N_from_the_ISP1362(OTG_RST_N),
                 .OTG_WR_N_from_the_ISP1362(OTG_WR_N),

                /*// the_VGA_0
                 .VGA_BLANK_from_the_VGA_0(VGA_BLANK),
                 .VGA_B_from_the_VGA_0(VGA_B),
                 .VGA_CLK_from_the_VGA_0(VGA_CLK),
                 .VGA_G_from_the_VGA_0(VGA_G),
                 .VGA_HS_from_the_VGA_0(VGA_HS),
                 .VGA_R_from_the_VGA_0(VGA_R),
                 .VGA_SYNC_from_the_VGA_0(VGA_SYNC),
                 .VGA_VS_from_the_VGA_0(VGA_VS),
                 .iCLK_25_to_the_VGA_0(CLK_25),*/

                // the_SD_CLK
                 .out_port_from_the_SD_CLK(SD_CLK),

                // the_SD_CMD
                 .bidir_port_to_and_from_the_SD_CMD(SD_CMD),

                // the_SD_DAT
                 .bidir_port_to_and_from_the_SD_DAT(SD_DAT),

                // the_SEG7_Display
                 .oSEG0_from_the_SEG7_Display(HEX0),
                 .oSEG1_from_the_SEG7_Display(HEX1),
                 .oSEG2_from_the_SEG7_Display(HEX2),
                 .oSEG3_from_the_SEG7_Display(HEX3),
                 .oSEG4_from_the_SEG7_Display(HEX4),
                 .oSEG5_from_the_SEG7_Display(HEX5),
                 .oSEG6_from_the_SEG7_Display(HEX6),
                 .oSEG7_from_the_SEG7_Display(HEX7),

               
                // the_button_pio
                 .in_port_to_the_button_pio(KEY),

                // the_lcd_16207_0
                 .LCD_E_from_the_lcd_16207_0(LCD_EN),
                 .LCD_RS_from_the_lcd_16207_0(LCD_RS),
                 .LCD_RW_from_the_lcd_16207_0(LCD_RW),
                 .LCD_data_to_and_from_the_lcd_16207_0(LCD_DATA),

                // the_led_green
                 .out_port_from_the_led_green(LEDG),

                // the_led_red
                 .out_port_from_the_led_red(LEDR),

                // the_sdram_0
                 .zs_addr_from_the_sdram_0(DRAM_ADDR),
                 .zs_ba_from_the_sdram_0({DRAM_BA_1,DRAM_BA_0}),
                 .zs_cas_n_from_the_sdram_0(DRAM_CAS_N),
                 .zs_cke_from_the_sdram_0(DRAM_CKE),
                 .zs_cs_n_from_the_sdram_0(DRAM_CS_N),
                 .zs_dq_to_and_from_the_sdram_0(DRAM_DQ),
                 .zs_dqm_from_the_sdram_0({DRAM_UDQM,DRAM_LDQM}),
                 .zs_ras_n_from_the_sdram_0(DRAM_RAS_N),
                 .zs_we_n_from_the_sdram_0(DRAM_WE_N),

                  // the_sram_0
                 /*.SRAM_ADDR_from_the_sram_0(SRAM_ADDR),
                 .SRAM_CE_N_from_the_sram_0(SRAM_CE_N),
                 .SRAM_DQ_to_and_from_the_sram_0(SRAM_DQ),
                 .SRAM_LB_N_from_the_sram_0(SRAM_LB_N),
                 .SRAM_OE_N_from_the_sram_0(SRAM_OE_N),
                 .SRAM_UB_N_from_the_sram_0(SRAM_UB_N),
                 .SRAM_WE_N_from_the_sram_0(SRAM_WE_N),*/

                // the_switch_pio
                 .in_port_to_the_switch_pio(SW),

                // the_tri_state_bridge_0_avalon_slave
                 .select_n_to_the_cfi_flash_0(FL_CE_N),
                 .tri_state_bridge_0_address(FL_ADDR),
                 .tri_state_bridge_0_data(FL_DQ),
                 .tri_state_bridge_0_readn(FL_OE_N),
                 .write_n_to_the_cfi_flash_0(FL_WE_N),

                // the_uart_0
                 .rxd_to_the_uart_0(UART_RXD),
                 .txd_from_the_uart_0(UART_TXD),
                
				// the_wideOut pio
                 .out_port_from_the_wideOut(command_bus), 
				// the_wideOut1 pio
                 .out_port_from_the_wideOut1(command_bus1),
				// the_ball_xy pio
                 .out_port_from_the_ball_xy(ball_xy),
                // the_bounds_min pio
                 .out_port_from_the_bounds_min(bounds_min),
				// the_bounds_max pio
                 .out_port_from_the_bounds_max(bounds_max),
                // the_mouse_xy pio
                 .out_port_from_the_mouse_xy(cur_xy),
				// the_ball_h2s
				 .in_port_to_the_ball_h2s(ball_h2s)
				);

I2C_AV_Config 	u1	(	//	Host Side
						.iCLK(CLOCK_50),
						.iRST_N(KEY[0]),
						//	I2C Side
						.I2C_SCLK(I2C_SCLK),
						.I2C_SDAT(I2C_SDAT)	);
						

// ----------------------------- MY CODE AGAIN ------------------------------//

always @ (posedge VGA_CTRL_CLK)
begin
	cur_x <= cur_xy[9:0];
	cur_y <= cur_xy[19:10];
	if (reset)		//synch reset assumes KEY0 is held down 1/60 second
		begin
			counter <= 0;
			//clear the screen
			addr_reg <= {Coord_X[9:1], Coord_Y[8:0]}; //{Coord_X[9:1],Coord_Y[9:1]} ;
			we <= 1'b0;								//write some memory
			data_reg <= 16'hFFFF;		//16'h0;					//write all zeros (black)		
			line_number1 <= 1;
			line_number2 <= 1;
			line <= 1;								// start with line_number1
			state <= new_walker ;						//first state in state machine 
			ballx <= 10'd 10;			// initial ball location
			bally <= 10'd 10;
			//oldballx <= 10'd 9;		// initial old ball location
			//oldbally <= 10'd 9;

			ball_h2s[9:0] <= ballx;
			ball_h2s[19:10] <= bally;
			ball_h2s[20] <= 1;
		end
	
	//modify display during sync
	else if ((~VGA_VS | ~VGA_HS) & KEY[3])  //sync is active low; KEY3 is pause
		begin
		ball_h2s[20] <= 0;
		if( counter == 6'd 63 || state != test2 )//|| command_bus[30] ) //|| line_number1 == 5)
		begin
			case(state)
			
				new_walker: //generate a new one
					begin
						// command_bus = [x1_1/x2_1,y1_1/y2_1,x1_2]
						// command_bus1 = [x2_2, y2_2, y1_2] --- 10 bits each
						x1_1 <= command_bus[9:1];		// x -> 9:1
						x1_2 <= command_bus[29:21];
						y1_1 <= command_bus[18:10];		// y -> 8:0
						y1_2 <= command_bus1[28:20];
						
						x2_1 <= command_bus[9:1];		// Line 2
						x2_2 <= command_bus1[9:1];		
						y2_1 <= command_bus[18:10];
						y2_2 <= command_bus1[18:10];
						
						we <= 1'b0;			// draw ball
						ballx <= ball_xy[9:1];
						bally <= ball_xy[18:10];
						addr_reg <= {ball_xy[9:1], ball_xy[18:10]};
						data_reg <= 16'h0000;
						ball_h2s[9:0] <= ball_xy[9:0];
						ball_h2s[19:10] <= ball_xy[19:10];
						ball_h2s[31] <= 0;
			
						state <= init;
						
						//addr_reg <= {9'd160,9'd120} ;	//(x,y)						
						//write a white dot in the middle of the screen
						//data_reg <= 16'hFFFF ;
					end

				init: 
					begin
						//we <= 1'b1;					// no write enabled				
						delta_x1 <= x1_2 - x1_1;
						delta_y1 <= y1_2 - y1_1;
						i_1 <= x1_1;
						j_1 <= y1_1;
						delta_x2 <= x2_2 - x2_1;
						delta_y2 <= y2_2 - y2_1;
						i_2 <= x2_1;
						j_2 <= y2_1;
						
						we <= 1'b0;	
						addr_reg <= {ballx, bally};	
						//addr_reg <= {ball_xy[9:1], ball_xy[18:10]};//{ballx, bally};					
						data_reg <= 16'hFFFF ; 	// write over ball with white
						
						state <= test1 ;
					end			
				
				test1: 
					begin
						lock <= 1'b1;
						//we <= 1'b1;		// write not enabled
						if ( line )
							begin
								i <= i_1;
								j <= j_1;
								delta_x <= delta_x1;
								delta_y <= delta_y1;
								x_end <= x1_2;
								y_end <= y1_2;
							end
						else
							begin
								i <= i_2;
								j <= j_2;
								delta_x <= delta_x2;
								delta_y <= delta_y2;
								x_end <= x2_2;
								y_end <= y2_2;
							end
							
						if ( i != x_end || j != y_end )
							begin
								ballx <= ball_xy[9:1];
								bally <= ball_xy[18:10];
								we <= 1'b0;	
								addr_reg <= {ball_xy[9:1], ball_xy[18:10]};
								ball_h2s[9:0] <= ball_xy[9:0];
								ball_h2s[19:10] <= ball_xy[19:10];					
								data_reg <= 16'h0000 ;
								state <= test2 ;		// if not done drawing line, continue
							end
						else if (line_number1 < 8 && line_number2 < 8)
							begin
								if ( i_1 == x1_2 && j_1 == y1_2 )
									begin
									if ( i_2 == x2_2 && j_2 == y2_2 )		// only if BOTH are done
										begin
											ball_h2s[31] <= 1;
											state <= new_walker;
										end
									else
										begin
											line = 1; // line 1 done, line 2 not, do line 2 next.
										end
									end
								else if	( i_2 == x2_2 && j_2 == y2_2 )
									begin
									if ( i_1 == x1_2 && j_1 == y1_2 )		// only if BOTH are done
										begin
											ball_h2s[31] <= 1;
											state <= new_walker;
										end
									else
										begin
											line = 0;	// line 2 done, line 1 not, do line 1 next
										end
									end
								else
									begin
										state <= new_walker;		// if both lines are not done drawing, finish both
									end
							end
						else
							begin
								state <= new_walker;
							end

					end
				
				test2:
					begin
						if (lock)
							begin
								we <= 1'b0;					// write enabled
								addr_reg <= {i,j} ;			// write the point
								data_reg <= 16'h0; // 16'hFFFF;		// color is white
								state <= update_walker;
							end
						else
							begin
								we <= 1'b0;	
								addr_reg <= {ballx, bally};	
								//addr_reg <= {ball_xy[9:1], ball_xy[18:10]};//{ballx, bally};					
								data_reg <= 16'hFFFF ; 	// write over ball with white
								state <= test1 ;			// if lost lock, try again
							end																	
					end
							
				update_walker: //update the walker
					begin
						//we <= 1'b1; //no mem write
						//inc/dec while staying on screen
						if ( line )
							begin
							if ( delta_y == 0 )
								begin
									if ( delta_x < 0 && i > x_min )		//x_1 != x_min
										i_1 <= i - 1;			// move line backwards
									else if ( delta_x > 0 && i < x_max)
										i_1 <= i + 1;			// move line forwards
									else;
								end
							else //if(delta_x == 0)
								begin
									if ( delta_y < 0 && j > y_min )
										j_1 <= j - 1;
									else if ( delta_y > 0 && j < y_max)
										j_1 <= j + 1;
									else;	
								end
							end
						else
							begin	
							if ( delta_y == 0 )
								begin
									if ( delta_x < 0 && i > x_min )		//x_1 != x_min
										i_2 <= i - 1;			// move line backwards
									else if ( delta_x > 0 && i < x_max)
										i_2 <= i + 1;			// move line forwards
									else;
								end
							else //if(delta_x == 0)
								begin
									if ( delta_y < 0 && j > y_min )
										j_2 <= j - 1;
									else if ( delta_y > 0 && j < y_max)
										j_2 <= j + 1;	
									else;
								end
							end	
						we <= 1'b0;	
						addr_reg <= {ballx, bally};
						//addr_reg <= {ball_xy[9:1], ball_xy[18:10]};//{ballx, bally};					
						data_reg <= 16'hFFFF ; 	// write over ball with white
						state <= test1;
					end
					
			endcase
		if ( line )
			begin
				line <= 0;	// alternate drawing points of two lines
			end
		else
			begin
				line <= 1;
			end
			
	end	// end if counter
	counter = counter + 1;
		
	end
	
	//show display when not blanking, 
	//which implies we=1 (not enabled); and use VGA module address
	else
	begin
		lock <= 1'b0; //clear lock if display starts because this destroys mem addr_reg
		addr_reg <= {Coord_X[9:1], Coord_Y[8:0]}; //{Coord_X[9:1],Coord_Y[9:1]} ;
		we <= 1'b1;
	end
end
// ----------------------------- END OF MY CODE -------------------------------//

endmodule