// Modified by Ran Hu, Chonggang Li, 2013
// --------------------------------------------------------------------
// Modified by Jeff Yates, Tom Gowing, Kerran Flanagan
// For use in ece 5760 final project: Cartoonifier
//
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
// Major Functions:	DE2 TV Box
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Joe Yang	       :| 05/07/05  :| Initial Revision
//   V1.1 :| Johnny Chen       :| 05/09/05  :| Changed YCbCr2RGB Block,
//											   RGB output 8 Bits => 10 Bits
//   V1.2 :| Johnny Chen	   :| 05/10/05  :| H_SYNC & V_SYNC Timing fixed.
//   V1.3 :| Johnny Chen       :| 05/11/16  :| Added FLASH Address FL_ADDR[21:20]
//   V1.4 :| Joe Yang	       :| 06/07/20  :| Modify Output Color
//	 V2.0 :| Johnny Chen	   :| 06/11/20	:| New Version for DE2 v2.X PCB.

///
//       rtrytrytr
// --------------------------------------------------------------------

module DE2_TV
	(
		////////////////////	Clock Input	 	////////////////////	 
		OSC_27,							//	27 MHz
		OSC_50,							//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,							//	Button[3:0]
		////////////////////	DPDT Switch		////////////////////
		DPDT_SW,						//	DPDT Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digital 0
		HEX1,							//	Seven Segment Digital 1
		HEX2,							//	Seven Segment Digital 2
		HEX3,							//	Seven Segment Digital 3
		HEX4,							//	Seven Segment Digital 4
		HEX5,							//	Seven Segment Digital 5
		HEX6,							//	Seven Segment Digital 6
		HEX7,							//	Seven Segment Digital 7
		////////////////////////	LED		////////////////////////
		LED_GREEN,						//	LED Green[8:0]
		LED_RED,						//	LED Red[17:0]
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
		SRAM_ADDR,						//	SRAM Adress bus 18 Bits
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
		TD_CLK,							//	TV Decoder Line Locked Clock
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0
		GPIO_1							//	GPIO Connection 1
	);

////////////////////////	Clock Input	 	////////////////////////
input			OSC_27;					//	27 MHz
input			OSC_50;					//	50 MHz
input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Button[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	DPDT_SW;				//	DPDT Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digital 0
output	[6:0]	HEX1;					//	Seven Segment Digital 1
output	[6:0]	HEX2;					//	Seven Segment Digital 2
output	[6:0]	HEX3;					//	Seven Segment Digital 3
output	[6:0]	HEX4;					//	Seven Segment Digital 4
output	[6:0]	HEX5;					//	Seven Segment Digital 5
output	[6:0]	HEX6;					//	Seven Segment Digital 6
output	[6:0]	HEX7;					//	Seven Segment Digital 7
////////////////////////////	LED		////////////////////////////
output	[8:0]	LED_GREEN;				//	LED Green[8:0]
output	[17:0]	LED_RED;				//	LED Red[17:0]
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
input			TD_CLK;					//	TV Decoder Line Locked Clock
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1
////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------------------//
//STAGE 0: Video decoder, VGA Controller, SDRAM, ETC.--------------------------------------//

//	Enable TV Decoder
assign	TD_RESET	=	KEY[0];

//	For Audio CODEC
wire		AUD_CTRL_CLK;	//	For Audio Controller
assign		AUD_XCK	=	AUD_CTRL_CLK;
//show label number
wire [4:0] label_number_display;
assign label_number_display=label_number-1;

HexDigit hd7(HEX7, label_number_display/10);
HexDigit hd6(HEX6, label_number_display%10);
//show tempo
HexDigit hd5(HEX5, bps);
//show transpose
note_display nd4(.segs(HEX4),.key(first_note));
wire [2:0] first_note;
assign first_note=DPDT_SW[9:7];
//show pause
pause_displey pd3(.segs(HEX3),.key(pause_n));

//show score
HexDigit hd2(HEX2, score_number/100);
HexDigit hd1(HEX1, (score_number/10)%10);
HexDigit hd0(HEX0, score_number%10);

						
//	Audio CODEC and video decoder setting
I2C_AV_Config 		u1	(	//	Host Side
							.iCLK(OSC_50),
							.iRST_N(KEY[0]),
							//	I2C Side
							.I2C_SCLK(I2C_SCLK),
							.I2C_SDAT(I2C_SDAT)	);

//	TV Decoder Stable Check
TD_Detect			u2	(	.oTD_Stable(TD_Stable),
							.iTD_VS(TD_VS),
							.iTD_HS(TD_HS),
							.iRST_N(KEY[0])	);

//	Reset Delay Timer
Reset_Delay			u3	(	.iCLK(OSC_50),
							.iRST(TD_Stable),
							.oRST_0(DLY0),
							.oRST_1(DLY1),
							.oRST_2(DLY2));

//	ITU-R 656 to YUV 4:2:2
ITU_656_Decoder		u4	(	//	TV Decoder Input
							.iTD_DATA(TD_DATA),
							//	Position Output
							.oTV_X(TV_X),
							//	YUV 4:2:2 Output
							.oYCbCr(YCbCr),
							.oDVAL(TV_DVAL),
							//	Control Signals
							.iSwap_CbCr(Quotient[0]),
							.iSkip(Remain==4'h0),
							.iRST_N(DLY1),
							.iCLK_27(TD_CLK)	);

//	For Down Sample 720 to 640
DIV 				u5	(	.aclr(!DLY0),	
							.clock(TD_CLK),
							.denom(4'h9),
							.numer(TV_X),
							.quotient(Quotient),
							.remain(Remain));

//	SDRAM frame buffer
Sdram_Control_4Port	u6	(	//	HOST Side
						    .REF_CLK(OSC_27),
							.CLK_18(AUD_CTRL_CLK),
						    .RESET_N(1'b1),
							//	FIFO Write Side 1
						    .WR1_DATA(YCbCr),
							.WR1(TV_DVAL),
							.WR1_FULL(WR1_FULL),
							.WR1_ADDR(0),
							.WR1_MAX_ADDR(640*507),		//	525-18
							.WR1_LENGTH(9'h80),
							.WR1_LOAD(!DLY0),
							.WR1_CLK(TD_CLK),
							//	FIFO Read Side 1
						    .RD1_DATA(m1YCbCr),
				        	.RD1(m1VGA_Read),
				        	.RD1_ADDR(640*13),			//	Read odd field and bypess blanking
							.RD1_MAX_ADDR(640*253),
							.RD1_LENGTH(9'h80),
				        	.RD1_LOAD(!DLY0),
							.RD1_CLK(OSC_27),
							//	FIFO Read Side 2
						    .RD2_DATA(m2YCbCr),
				        	.RD2(m2VGA_Read),
				        	.RD2_ADDR(640*267),			//	Read even field and bypess blanking
							.RD2_MAX_ADDR(640*507),
							.RD2_LENGTH(9'h80),
				        	.RD2_LOAD(!DLY0),
							.RD2_CLK(OSC_27),
							//	SDRAM Side
						    .SA(DRAM_ADDR),
						    .BA({DRAM_BA_1,DRAM_BA_0}),
						    .CS_N(DRAM_CS_N),
						    .CKE(DRAM_CKE),
						    .RAS_N(DRAM_RAS_N),
				            .CAS_N(DRAM_CAS_N),
				            .WE_N(DRAM_WE_N),
						    .DQ(DRAM_DQ),
				            .DQM({DRAM_UDQM,DRAM_LDQM}),
							.SDR_CLK(DRAM_CLK)	);

//	YUV 4:2:2 to YUV 4:4:4
YUV422_to_444		u7	(	//	YUV 4:2:2 Input
							.iYCbCr(mYCbCr),
							//	YUV	4:4:4 Output
							.oY(mY),
							.oCb(mCb),
							.oCr(mCr),
							//	Control Signals
							.iX(vga_x),
							.iCLK(OSC_27),
							.iRST_N(DLY0));

//	YCbCr 8-bit to RGB-10 bit 
YCbCr2RGB 			u8	(	//	Output Side
							.Red(mRed),
							.Green(mGreen),
							.Blue(mBlue),
							.oDVAL(mDVAL),
							//	Input Side
							.iY(mY),
							.iCb(mCb),
							.iCr(mCr),
							.iDVAL(VGA_Read),
							//	Control Signal
							.iRESET(!DLY2),
							.iCLK(OSC_27));
							
//	VGA Controller
VGA_Ctrl			u9	(	//	Host Side
							.iRed(final_r),//writting?o1:
							.iGreen(final_g),//writting?o2:
							.iBlue(final_b),//writting?o3:
							.oCurrent_X(vga_x),
							.oCurrent_Y(vga_y),
							.oRequest(VGA_Read),
							.oShift_Flag(Shift_En),
							//	VGA Side
							.oVGA_R(VGA_R),
							.oVGA_G(VGA_G),
							.oVGA_B(VGA_B),
							.oVGA_HS(VGA_HS),
							.oVGA_VS(VGA_VS),
							.oVGA_SYNC(VGA_SYNC),
							.oVGA_BLANK(VGA_BLANK),
							.oVGA_CLOCK(VGA_CLK),
							//	Control Signal
							.iCLK(OSC_27),
							.iRST_N(DLY2)	);

							
							
					
				
				

							
//	For ITU-R 656 Decoder
wire	[15:0]	YCbCr;
wire	[9:0]	TV_X;
wire			TV_DVAL;

//	For VGA Controller
wire	[9:0]	mRed, eRed, mux_Red;
wire	[9:0]	mGreen, eGreen, mux_Green;
wire	[9:0]	mBlue, eBlue, mux_Blue;

wire	[10:0]	vga_x;
wire	[10:0]	vga_y;
wire			VGA_Read;	//	VGA data request
wire			m1VGA_Read;	//	Read odd field
wire			m2VGA_Read;	//	Read even field
wire			Shift_En;
wire			vert_edge, horiz_edge, is_edge;

//	For YUV 4:2:2 to YUV 4:4:4
wire	[7:0]	mY;
wire	[7:0]	mCb;
wire	[7:0]	mCr;

//	For field select
wire	[15:0]	mYCbCr;
wire	[15:0]	mYCbCr_d;
wire	[15:0]	m1YCbCr;
wire	[15:0]	m2YCbCr;
wire	[15:0]	m3YCbCr;

//	For Delay Timer
wire			TD_Stable;
wire			DLY0;
wire			DLY1;
wire			DLY2;

//	For Down Sample
wire	[3:0]	Remain;
wire	[9:0]	Quotient;

//color read
assign	m1VGA_Read	=	vga_y[0]		?	1'b0		:	VGA_Read	;
assign	m2VGA_Read	=	vga_y[0]		?	VGA_Read	:	1'b0		;
assign	mYCbCr_d	=	!vga_y[0]		?	m1YCbCr		:
											m2YCbCr		;
assign	mYCbCr		=	m5YCbCr;

wire			mDVAL;

//	Line buffer, delay one line
Line_Buffer u10	(	.clken(VGA_Read),
					.clock(OSC_27),
					.shiftin(mYCbCr_d),
					.shiftout(m3YCbCr));

Line_Buffer u11	(	.clken(VGA_Read),
					.clock(OSC_27),
					.shiftin(m3YCbCr),
					.shiftout(m4YCbCr));

wire	[15:0]	m4YCbCr;
wire	[15:0]	m5YCbCr;
wire	[8:0]	Tmp1,Tmp2;
wire	[7:0]	Tmp3,Tmp4;

assign	Tmp1	=	m4YCbCr[7:0]+mYCbCr_d[7:0];
assign	Tmp2	=	m4YCbCr[15:8]+mYCbCr_d[15:8];
assign	Tmp3	=	Tmp1[8:2]+m3YCbCr[7:1];
assign	Tmp4	=	Tmp2[8:2]+m3YCbCr[15:9];
assign	m5YCbCr	=	{Tmp4,Tmp3};


AUDIO_DAC 	u12	(	//	Audio Side
					.oAUD_BCK(AUD_BCLK),
					.oAUD_DATA(AUD_DACDAT),
					.oAUD_LRCK(AUD_DACLRCK),
					
					
					.iSRAM_DATA(audio_out),
					//	Control Signals
					.iSrc_Select(2'b11),
			        .iCLK_18_4(AUD_CTRL_CLK),
					.iRST_N(DLY1)	);




//generate sound
sound s1(.ifrequency(freq),.odata(audio_outR),.clk(OSC_50));
//get frequenct
get_frequency gf1 (.inote(note_played),.istart_note(first_note),.ofrequency(freq),.clk(DPDT_SW[1]));
wire[10:0] freq;					
					
//Swith[0] is used to select the two different kinds of sounds by user					
assign audio_out=DPDT_SW[0]?		audio_outR :		audio_outL;	
				
//Karplus-strong algorithm module to synthesis piano notes 								
wire [15:0] audio_outL, audio_outR ,audio_out;
wire [2:0] statevalue;
wire [10:0] notevalue;
karplus_note s2(.clock50(OSC_27),
.audiolrclk(AUD_DACLRCK),
.reset((~KEY[1])||DPDT_SW[1]),
.startnote(first_note),
.comb(note_played), 
.audioOut(audio_outL)
);



					
					
//-----------------------------------------------------------------------------------------//
//VGA display configuration--------------------------------------//

wire [9:0]display_r,display_g,display_b;

wire [7:0] display_data;
assign display_data=run_compare?roi_data:(writting?data_in:data_out);
assign display_r={display_data[6],display_data[7], 8'b0};
assign display_g={display_data[5:2], 6'b0};
assign display_b={display_data[1:0], 8'b0};					


wire [9:0]final_r,final_g,final_b;
assign final_r=(roi_marking | bg_marking | run_compare)?piano_VGA_R:display_r;
assign final_g=(roi_marking | bg_marking | run_compare)?piano_VGA_G:display_g;
assign final_b=(roi_marking | bg_marking | run_compare)?piano_VGA_B:display_b;


					
//-----------------------------------------------------------------------------------------//
//SRAM writting configuration--------------------------------------//

wire[7:0] data_in;
wire[7:0] data_out;

wire [9:0] sram_x;
wire [8:0] sram_y;

wire [9:0] vga_x_write;
wire [8:0] vga_y_write;
//if vga is synchronizing
wire sync;
assign sync=(~VGA_VS | ~VGA_HS);
//if in sync, give address as 0
assign vga_x_write=sync?0:{vga_x[9:1],vga_x[0]};
assign vga_y_write=sync?0:vga_y[8:0];
//the address to reach SRAM
assign sram_x=roi_filtering?filter_x:(labeling?label_x:vga_x_write);
assign sram_y=roi_filtering?filter_y:(labeling?label_y:vga_y_write);



assign SRAM_ADDR = {sram_x[9:1],sram_y[8:0]};
assign SRAM_DQ[15:8] = (writting)? (sram_x[0]? data_in:8'hzz):8'hzz  ;
assign SRAM_DQ[7:0] = (writting)? (~sram_x[0]? data_in:8'hzz):8'hzz  ;
assign SRAM_UB_N = ~sram_x[0];					// hi byte select enabled
assign SRAM_LB_N = sram_x[0];					// lo byte select enabled
assign SRAM_CE_N = 0;					// chip is enabled
assign SRAM_WE_N = ~writting;					// write when ZERO
assign SRAM_OE_N = 0;					//output enable is overidden by WE					
					
assign data_out=sram_x[0]?SRAM_DQ[15:8]:SRAM_DQ[7:0];					
					
//-----------------------------------------------------------------------------------------//
//STAGE 1: the data_in to write in SRAM--------------------------------------//

wire roi_marking;
assign roi_marking=DPDT_SW[1];

wire bg_marking;

wire writting;
//if is writting to SRAM
assign writting= roi_marking | bg_marking |(roi_filtering & filter_writing)|label_writting_enable ;
wire label_writting_enable;
assign label_writting_enable=labeling & label_writting;
 
wire isgreen;
wire isblue;			
wire [9:0] o1,o2,o3;

//check color
inrange i1(.r(mRed),.g(mGreen),.b(mBlue),.o1(o1),.o2(o2),.o3(o3),.sw(DPDT_SW),.isblue(isblue),.isgreen(isgreen));						

//write data
assign data_in=(roi_marking?roi_data:
(bg_marking?bg_data:(filter_writing?filter_data_out:(label_writting_enable?label_data_out:8'hff))));//


//-----------------------------------------------------------------------------------------//
//STAGE 2: regin or interest write in SRAM--------------------------------------//
wire[7:0] roi_data;
assign roi_data=isblue?8'b01000000 :(isgreen?8'b00100000:8'h00);
wire[7:0] bg_data;
assign bg_data=isblue?8'b00000010 :(isgreen?8'b00100000:8'h00);


//-----------------------------------------------------------------------------------------//
//STAGE 3: filter for color 1--------------------------------------//
filter_process fp1(
.iReset(~KEY[1]),
.iFilter_trigger(DPDT_SW[2]),
.oROI_filtering(roi_filtering1),
.oFilter_reading(filter_reading1),
.oFilter_writing(filter_writing1),
.iData(data_out),
.oData(filter_data_out1),
.oROI_x(filter_x1),
.oROI_y(filter_y1),
.clk(OSC_27),
.iDigit(6),
.iIgnore(5));

//-----------------------------------------------------------------------------------------//
//STAGE 4: filter for color 2--------------------------------------//
filter_process fp2(
.iReset(~KEY[1]),
.iFilter_trigger(DPDT_SW[3]),
.oROI_filtering(roi_filtering2),
.oFilter_reading(filter_reading2),
.oFilter_writing(filter_writing2),
.iData(data_out),
.oData(filter_data_out2),
.oROI_x(filter_x2),
.oROI_y(filter_y2),
.clk(OSC_27),
.iDigit(5),
.iIgnore(6));

//display current state
assign LED_GREEN[0]=roi_filtering;
assign LED_GREEN[1]=filter_writing;
assign LED_GREEN[2]=labeling;

wire roi_filtering;
wire roi_filtering1;
wire roi_filtering2;
assign roi_filtering=roi_filtering1 | roi_filtering2;

wire filter_reading,filter_writing;
wire filter_reading1,filter_writing1;
wire filter_reading2,filter_writing2;
assign filter_reading=filter_reading1 | filter_reading2;
assign filter_writing=filter_writing1 | filter_writing2;


wire[7:0] filter_data_out;
wire[7:0] filter_data_out1;
wire[7:0] filter_data_out2;

assign filter_data_out=roi_filtering1 ? filter_data_out1 : filter_data_out2;


wire [9:0] filter_x;
wire [8:0] filter_y;

assign filter_x=roi_filtering1? filter_x1:filter_x2;
assign filter_y=roi_filtering1? filter_y1:filter_y2;

wire [9:0] filter_x1;
wire [8:0] filter_y1;

wire [9:0] filter_x2;
wire [8:0] filter_y2;


//-----------------------------------------------------------------------------------------//
//STAGE 5: label detected keys--------------------------------------//

label ll1(
.iTrigger(DPDT_SW[4]),
.ooLabling(labeling),
.oLabel_reading(label_reading),
.ooLabel_writting(label_writting),
.oLabel_x(label_x),
.oLabel_y(label_y),
.clk(OSC_27),
.iData(data_out),
.oData(label_data_out),
.oLabel_number(label_number),
.reset(~KEY[3]),
.oState(label_state));

wire [3:0] label_state;

wire labeling;
wire label_reading;
wire label_writting;
wire [9:0] label_x;
wire [8:0] label_y;
wire [7:0] label_data_out;
wire [4:0] label_number;
//-----------------------------------------------------------------------------------------//
//STAGE 6: find the max diff key--------------------------------------//

compare_max cc1 (
.iCompare_x(vga_x),
.iCompare_y(vga_y),
.iRun(run_compare),
.iData(data_out),
.clk(OSC_27),
.oComb(comb_out),
.iSync(sync),
.iBlue(isblue),
.iGreen(isgreen),
.iThresh(10'h90),
.oNote(note_played));

wire[4:0] note_played;
wire [19:0] comb_out;
wire run_compare;
assign run_compare=DPDT_SW[5];

//-----------------------------------------------------------------------------------------//
//STAGE 7: Image to show on the screen--------------------------------------//

calculate_piano cp1(
.x(vga_x[9:1]),
.y(vga_y[9:1]),
.value(piano_data),
.h_line(179),
.key_color(16'h4444),
.key_color2((comb1==comb_out)?16'h2000:16'h4444),
.comb0(comb1),
.comb1(comb2),
.comb2(comb3),
.comb3(comb4),
.ikeys(comb_out),
.front(front),
.nkeys_input(nkeys),
.calib((roi_marking | bg_marking)),
.calib2((roi_marking | bg_marking)),
.practice(practice));

//choose mode
wire practice;
assign practice=DPDT_SW[17];
//choose number of keys
wire[3:0] nkeys;
assign nkeys=DPDT_SW[16:14];
//image to display
wire[15:0] piano_data;
wire [9:0]	piano_VGA_R;
wire [9:0]	piano_VGA_G;
wire [9:0]	piano_VGA_B;
assign  piano_VGA_R = {piano_data[15:12], 6'b0} ;
assign  piano_VGA_G = {piano_data[11:8], 6'b0} ;
assign  piano_VGA_B = {piano_data[7:4], 6'b0} ;

//timer for beat
wire[8:0] front;
timer t1(.iclk(OSC_50),.ofront(front),.ibmp(bps),.obeats(beats),.iReset(timer_reset),.pause(~pause_n),.inumber_of_notes(54));

wire timer_reset;
assign timer_reset=~KEY[2];

assign LED_GREEN[7]=(beats==0)?1:0;

wire [7:0] beats;

//get melody
melody mm1(.iBeat(beats),.oComb1(comb1),.oComb2(comb2),.oComb3(comb3),.oComb4(comb4),.clk(DPDT_SW[1]));
wire[5:0] comb1,comb2,comb3,comb4;

//pause
wire pause_n;
assign pause_n=DPDT_SW[6];

//tempo config
wire[3:0] bps;
assign bps=DPDT_SW[13:10];

//calculate score
score ss1(
.iBeat(beats),
.iComb_melody(comb1),
.iComb_play(comb_out),
.ireset(timer_reset),
.oScore(score_number),
.clk(OSC_27));

wire [7:0] score_number;

endmodule					









//Karplus-strong algorithm module to synthesis piano notes 
//Refer to 5760 DSP example code of guitar string pluck synthesis:
//https://instruct1.cit.cornell.edu/courses/ece576/DE2/fpgaDSP.html
module karplus_note (clock50, audiolrclk, reset, startnote, comb, audioOut);

input clock50;  //clock as reference
input audiolrclk;  //sample frequency
input reset;     //reset signal
input [2:0] startnote;  //chose the startnote frequency
input [4:0] comb;   //represent which keys are pressed
output[15:0] audioOut;  //output audio signal


wire [4:0] combination; 
reg [4:0] combination_last;
assign combination=(comb==0)?0:comb+startnote;   //keys are pressed


reg [17:0] Out;  //middle string
reg [17:0] OutS,OutH;    //lower string and higher string
reg [17:0] OutSum;   //the sum of three strings
assign audioOut = OutSum[17:2];   //take the higher 15 bits to output

reg [10:0] note;   //define the length of the middle string shiftregister
reg [10:0] noteS;   //define the length of the lower string shiftregister
reg [10:0] noteH;		//define the length of the higher string shiftregister	

reg pluck ;   //pluck the string, and counts for three strings
reg last_pluck;
reg [11:0] pluck_count,pluck_countS,pluck_countH;

// state variable 0=reset, 1=readinput,
// 2=readoutput, 3=writeinput, 4=write 5=updatepointers, 
// 9=stop
reg [2:0] state ;
reg last_clk ; //oneshot gen

wire [17:0] gain ;   // constant for gain
		
//pointers into the shift register
//4096 at 48kHz imples 12 Hz
reg [11:0] ptr_in, ptr_out,ptr_inS,ptr_outS,ptr_inH,ptr_outH; 

//memory control
reg we,weS,weH; //write enable--active high
wire [17:0] sr_data,sr_dataS,sr_dataH; 
reg [17:0]  write_data,write_dataS,write_dataH;
reg [11:0] addr_reg,addr_regS,addr_regH;

//data registers for arithmetic
reg [17:0] in_data, out_data;
reg [17:0] in_dataS, out_dataS;
reg [17:0] in_dataH, out_dataH;
wire [17:0] new_out, new_outH;

//random number generator and lowpass filter
wire x_low_bit ;    // random number gen low-order bit
reg [30:0] x_rand ;   //  rand number
wire [17:0] new_lopass ;
reg [17:0]  lopass ;

wire [2:0] alpha;   //alpha that is used in filter
assign alpha=3'b111;


// pluck control by combination
always @ (posedge clock50)
begin
	pluck <= (combination==combination_last)?((combination==5'd0)?1'b0:1'b1):0;
	combination_last<=combination;
end

//generate a random number at audio rate
// --AUD_DACLRCK toggles once per left/right pair
// --so it is the start signal for a random number update
// --at audio sample rate
//right-most bit for rand number shift regs
assign x_low_bit = x_rand[27] ^ x_rand[30];
// newsample = (1-alpha)*oldsample + (random+/-1)*alpha
// rearranging:
// newsample = oldsample + ((random+/-1)-oldsample)*alpha
// alpha is set from 1 to 1/128 using switches
// alpha==1 means no lopass at all. 1/128 loses almost all the input bits
assign new_lopass = lopass + ((( (x_low_bit)?18'h1_0000:18'h3_0000) - lopass)>>>alpha);

//your basic XOR random # gen
always @ (posedge audiolrclk)
begin
	if (reset)
	begin
		x_rand <= 31'h55555555;
		lopass <= 18'h0 ;
	end
	else begin
		x_rand <= {x_rand[29:0], x_low_bit} ;
		lopass <= new_lopass;
	end
end

//when user pushes a button transfer rand number to circular buffer
//treat each bit of rand register as +/-1, 18-bit, 2'comp
//when loading to circ buffer
//shift buffer, apply filter, update indexes	
//once per audio clock tick
assign gain = 18'h0_7FF8 ; 


//Run the state machine FAST so that it completes in one 
//audio cycle
always @ (posedge clock50)
begin
	if (reset)
	begin
		ptr_out <= 12'h1 ; //output beginning of shift register
		ptr_outS <=12'h1;
		ptr_outH <=12'h1;
		ptr_in <= 12'h0 ;   //input beginning of shift register
		ptr_inS<=12'h0;
		ptr_inH <= 12'h0 ;
		we <= 1'h0 ;    //write enable signal
		weS<= 1'h0;
		weH<= 1'h0;
		state <= 3'd7; //turn off the update state machine	
		last_clk <= 1'h1;
		
	end
	
	else begin
	
      //frequency(Hz) and the notes they correspond		
      if (combination==5'd18)//698-f2
         note <= 11'd66;	
      else if (combination==5'd17)//659-e2
         note <= 11'd71;	
      else if (combination==5'd16)//587-d2
         note <= 11'd79;	
      else if (combination==5'd15)//523-c2
         note <= 11'd89;	
      else if (combination==5'd14)//493-b1
         note <= 11'd94;	
      else if (combination==5'd13)//440-a1
         note <= 11'd106;
      else if (combination==5'd12)//391-g1
         note <= 11'd119;
      else if (combination==5'd11)//349-f1
         note <= 11'd133;
      else if (combination==5'd10)//329-e1
         note <= 11'd142;
      else if (combination==5'd9)//293-d1
         note <= 11'd160;
      else if (combination==5'd8)//261-c1
         note <= 11'd179;	
      else if (combination==5'd7)//246-b0
         note <= 11'd188;
      else if (combination==5'd6)//220-a0
         note <= 11'd210;	
      else if (combination==5'd5)//196-g0
         note <= 11'd238;
      else if (combination==5'd4)//174-f0
         note <= 11'd261;
      else if (combination==5'd3)//164-e0
	      note<= 11'd280;
      else if (combination==5'd2)//146-d0
         note <= 11'd315;
      else if (combination==5'd1)//130.8-c0
         note<= 11'd350;	
	
		case (state)
	
			1: 
			begin
				// set up read ptr_out data
				addr_reg <= ptr_out;
				addr_regS<= ptr_outS;
				addr_regH <= ptr_outH;
				we <= 1'h0;
				weS<= 1'h0;
				weH<= 1'h0;		
				state <= 3'd2;
			end
	
			2: 
			begin
				//get ptr_out data
				out_data <= sr_data;
				out_dataS<= sr_dataS;
				out_dataH <= sr_dataH;
				// set up read ptr_in data
				addr_reg <= ptr_in;
				addr_regS<= ptr_inS;
				addr_regH <= ptr_inH;
				we <= 1'h0;
				weS<= 1'h0;
				weH<= 1'h0;
				state <= 3'd3;
			end
			
			3: 
			begin
				//get prt_in data
				in_data <= sr_data;
				in_dataS <= sr_dataS;
				in_dataH <= sr_dataH;
				noteS<=note+2'd2;  //define the length of the lower string shiftregister
				noteH<=note-2'd2;   //define the length of the higher string shiftregister
				state <= 3'd4 ;
			end
			
			4:
			begin
				//write ptr_in data:  
				// -- can be either computed feedback, or noise from pluck
				Out <= new_out;
				OutS<= new_outS;
				OutH<= new_outH;
				OutSum<=Out+OutS+OutH;
				addr_reg <= ptr_in;
				addr_regS<= ptr_inS;
				addr_regH <= ptr_inH;
				we <= 1'h1 ;
				weS<= 1'h1;
				weH<= 1'h1;
				// feedback or new pluck
				if (pluck )
				begin 				   
					// is this a new pluck? (part of the debouncer)
					//middle string
					if (last_pluck==0)
					begin
						// if so, reset the count
						pluck_count <= 12'd0;
						ptr_out<=12'd1;
						ptr_in<=12'd0;
						// and debounce pluck
						last_pluck <= 1'd1;
					end
					// have the correct number of random numbers been loaded?
					else if (pluck_count<note)
					begin
						//if less, load lowpass output into memory
						pluck_count <= pluck_count + 12'd1 ;
						write_data <= new_lopass;
						
					end
					//update feedback if not actually loading random numbers
					else 
						//slow human holds button down, but feedback is still necessary
						write_data <= new_out ;
						
				
				//lower string
				if (last_pluck==0)
					begin
						// if so, reset the count
						pluck_countS <= 12'd0;
						ptr_inS<=12'd0;
						ptr_outS<=12'd1;
						// and debounce pluck
						last_pluck <= 1'd1;
					end
					// have the correct number of random numbers been loaded?
					else if (pluck_countS<noteS)
					begin
						//if less, load lowpass output into memory
						pluck_countS <= pluck_countS + 12'd1 ;
						//write_data <= new_lopass;
						write_dataS<= new_lopass;
					end
					//update feedback if not actually loading random numbers
					else 
						//slow human holds button down, but feedback is still necessary
						//write_data <= new_out ;
						write_dataS <=new_outS;
						
						
					//higher string	
					if (last_pluck==0)
					begin
						// if so, reset the count
						ptr_outH<=12'd1;
						ptr_inH<=12'd0;
						pluck_countH <= 12'd0;
						// and debounce pluck
						last_pluck <= 1'd1;
					end
					// have the correct number of random numbers been loaded?
					else if (pluck_countH<noteH)
					begin
						//if less, load lowpass output into memory
						pluck_countH <= pluck_countH + 12'd1 ;
						write_dataH <= new_lopass;
						
					end
					//update feedback if not actually loading random numbers
					else 
						//slow human holds button down, but feedback is still necessary
						write_dataH <= new_outH ;
		

		      end
				else begin 
					// update feedback if pluck button is not pushed
					// and get ready for next pluck since the button is released
					last_pluck = 1'h0;
					write_data <= new_out;
					write_dataS <= new_outS;
					write_dataH <= new_outH;
				end
				state <= 3'd5;
			end
			
			5: 
			begin
				we <= 0;
				weS<= 0 ;
				weH<= 0;
				//update 2 ptrs for middle string
				if (ptr_in == note)
					ptr_in <= 12'h0;
				else
					ptr_in <= ptr_in + 12'h1 ;
				
				if (ptr_out == note)
					ptr_out <= 12'h0;
				else
					ptr_out <= ptr_out + 12'h1 ;
					
				//update 2 ptrs for lower string	
				if (ptr_inS == noteS)
					ptr_inS <= 12'h0;
				else
					ptr_inS <= ptr_inS + 12'h1 ;
				
				if (ptr_outS == noteS)
					ptr_outS <= 12'h0;
				else
					ptr_outS <= ptr_outS + 12'h1 ;				
				

            //update 2 ptrs for higher string
				if (ptr_inH == noteH)
					ptr_inH <= 12'h0;
				else
					ptr_inH <= ptr_inH + 12'h1 ;
				
				if (ptr_outH == noteH)
					ptr_outH <= 12'h0;
				else
					ptr_outH <= ptr_outH + 12'h1 ;

				state <= 3'd7;
			end
			
			7:
			begin
			//judge if there is another strike
				if (audiolrclk && last_clk)
				begin
					state <= 3'd1 ;
					last_clk <= 1'h0 ;
				end
				else if (~audiolrclk)
				begin
					last_clk <= 1'h1 ;
					state<= 3'd7;
				end	
			end
			
		endcase
	end
end	

//make the shift register
ram_infer KS(sr_data, addr_reg, write_data, we, clock50);
ram_infer KS2(sr_dataS, addr_regS, write_dataS, weS, clock50);	
ram_infer KS3(sr_dataH, addr_regH, write_dataH, weH, clock50);	

//make a multiplier and compute gain*(in+out)
signed_mult gainfactor(new_out, gain, (out_data + in_data));
signed_mult gainfactor2(new_outS, gain, (out_dataS + in_dataS));
signed_mult gainfactor3(new_outH, gain, (out_dataH + in_dataH));


endmodule





// M4k ram for circular buffer 
// Synchronous RAM with Read-Through-Write Behavior
// and modified for 18 bit access
// of 109 words to tune for 440 Hz
module ram_infer (q, a, d, we, clk);
output  [17:0] q;
input [17:0] d;
input [11:0] a;
input we, clk;
reg [11:0] read_add;
// define the length of the shiftregister
// 48000/2000 is 24 Hz. Should be long enough
// for any reasonable note
parameter note = 2047 ; 
reg [17:0] mem [note:0];
	always @ (posedge clk) 
	begin
		if (we) mem[a] <= d;
		read_add <= a;
	end
	assign q = mem[read_add];
endmodule 





//signed mult of 2.16 format 2'comp
module signed_mult (out, a, b);

	output 		[17:0]	out;
	input 	signed	[17:0] 	a;
	input 	signed	[17:0] 	b;
	
	wire	signed	[17:0]	out;
	wire 	signed	[35:0]	mult_out;

	assign mult_out = a * b;
	assign out = {mult_out[35], mult_out[32:16]};
endmodule


//find the color					
module inrange(r,g,b,o1,o2,o3,sw,isgreen,isblue);
input[9:0]r,g,b;
output[9:0] o1,o2,o3;
output isgreen,isblue;
input [17:0] sw;
assign o1=sw[17]?r:0;
assign isgreen=((g>10'h378)&(r<10'h1c0)&(b<10'h1c0)); //green if meet the condidion
assign o2=sw[17]?g:(isgreen?g:0);
assign isblue=((b>10'h3fe)&(r<10'h1c0)&(g<10'h3c0));//blue if meet the condidion
assign o3=sw[17]?b:(isblue?b:0);
endmodule

//filter nois		
module filter_process(iReset,iFilter_trigger,oROI_filtering,oFilter_reading,oFilter_writing,iData,oData,oROI_x,oROI_y,clk,iDigit,iIgnore);
	//command
	input iReset;
	input iFilter_trigger;
	//state indication
	output reg oROI_filtering;
	output reg oFilter_reading;
	output reg oFilter_writing;
	//data read
	input[7:0] iData;
	//data write
	output reg[7:0] oData;
	output reg [9:0] oROI_x;
	output reg [8:0] oROI_y;
	//clock
	input clk;
	//posistion in table
	input [3:0] iDigit;
	//if ignore
	input [3:0] iIgnore;
	//center data
	reg[7:0] center_data; 
	//coordination
	reg[9:0] roi_x;
	reg[8:0] roi_y;
	//count for color and non-olor
	reg[3:0] zero_count;
	reg[3:0] one_count;
	//number count for neighbor
	reg left_count;
	reg right_count;
	reg up_count;
	reg down_count;
	//if ignore
	reg ignore;
	//state
	reg [3:0] roi_state;
	
	//reset
	initial begin
	roi_state<=0;
	oROI_filtering<=0;
	oFilter_reading<=0;
	oFilter_writing<=0;
	oData<=0;
	oROI_x<=0;
	oROI_y<=0;
	end

	always @(posedge clk)
	begin

	
		case(roi_state)
		//wait for trigger
		0:
		begin
			roi_x<=0;
			roi_y<=0;
			oROI_filtering<=0;
			oFilter_reading<=0;
			oFilter_writing<=0;	
			oData<=0;
			if(iFilter_trigger==0)
			begin
				roi_state<=1;
			
			end
		end
		//start from origin
		1:
		begin
			if(iFilter_trigger==1)
			begin

				oROI_filtering<=1;
				oFilter_reading<=1;
				oFilter_writing<=0;
				zero_count<=0;
				one_count<=0;
				left_count<=0;
				down_count<=0;
				up_count<=0;
				right_count<=0;
				ignore<=0;
				oROI_x<=roi_x-1;
				oROI_y<=roi_y-1;
				roi_state<=2;
			end
		end
		//read left upp
		2:
		begin
			if(iData[iDigit])
			begin
				one_count<=one_count+1;
				//left_count<=left_count+1;
			end
			else
			begin
				zero_count<=zero_count+1;
			end
			oROI_x<=roi_x;
			oROI_y<=roi_y-1;	
			roi_state<=3;		
		end	
		//read up
		3:
		begin
			if(iData[iDigit])
			begin
				up_count<=1;
				one_count<=one_count+1;
			end
			else
			begin
				up_count<=0;
				zero_count<=zero_count+1;
			end
			oROI_x<=roi_x+1;
			oROI_y<=roi_y-1;	
			roi_state<=4;		
		end			
		//read right up
		4:
		begin
			if(iData[iDigit])
			begin
				one_count<=one_count+1;
			end
			else
			begin
				zero_count<=zero_count+1;
			end
			oROI_x<=roi_x-1;
			oROI_y<=roi_y;	
			roi_state<=5;		
		end			
		//read left
		5:
		begin
			if(iData[iDigit])
			begin
				one_count<=one_count+1;
				left_count<=1;
			end
			else
			begin
				zero_count<=zero_count+1;
				left_count<=0;
			end
			oROI_x<=roi_x;
			oROI_y<=roi_y;	
			roi_state<=6;		
		end	
		//read center
		6:
		begin
			center_data<=iData; //store center data
			if(iData[iDigit])
			begin
				one_count<=one_count+1;
			end
			else
			begin
				zero_count<=zero_count+1;
			end			
			//check if meet the condition for ignore
			if(iData[iIgnore])
			begin
				ignore<=1;
			end
			else
			begin
				ignore<=0;
			end
			
			oROI_x<=roi_x+1;
			oROI_y<=roi_y;	
			roi_state<=7;		
		end			
		//read right neighbor
		7:
		begin
			if(iData[iDigit])
			begin
				one_count<=one_count+1;
				right_count<=1;
			end
			else
			begin
				zero_count<=zero_count+1;
				right_count<=0;
			end
			oROI_x<=roi_x-1;
			oROI_y<=roi_y+1;	
			roi_state<=8;		
		end			
		//read left down neighbor
		8:
		begin
			if(iData[iDigit])
			begin
				one_count<=one_count+1;
				//left_count<=left_count+1;
			end
			else
			begin
				zero_count<=zero_count+1;
			end
			oROI_x<=roi_x;
			oROI_y<=roi_y+1;	
			roi_state<=9;		
		end	
		//read down neighbop
		9:
		begin
			if(iData[iDigit])
			begin
				down_count<=1;
				one_count<=one_count+1;
			end
			else
			begin
				zero_count<=zero_count+1;
				down_count<=0;
			end
			oROI_x<=roi_x+1;
			oROI_y<=roi_y+1;	
			roi_state<=10;		
		end
		//read right down neighbor
		10:
		begin
			if(iData[iDigit])
			begin
				one_count<=one_count+1;
				//right_count<=right_count+1;
			end
			else
			begin
				zero_count<=zero_count+1;
			end
			oFilter_reading<=0;
			roi_state<=11;	
		end
		//check if noise or not
		11:
		begin
			//condition for noise
			if((((~right_count)&(~left_count))|((~up_count)&(~down_count))))
			begin
				oData<=0; //clear data
			end
			else
			begin
				oData<=center_data; //remain data
			end
			oROI_x<=roi_x;
			oROI_y<=roi_y;	
			//if not meet the condition of ignoring
			if(~ignore)
			begin
				oFilter_writing<=1;
			end
			//check if the end of frame
			if(roi_x<639)
			begin
				roi_x<=roi_x+1;
				roi_state<=12;	
			end
			else
			begin
				if(roi_y<479)
				begin
					roi_y<=roi_y+1;
					roi_x<=0;
					roi_state<=12;	
				end
				else
				begin
					roi_state<=0;
				end;
			end;			
		end
		//start again for the next pixel
		12:
		begin
			oFilter_reading<=1;
			oFilter_writing<=0;
			zero_count<=0;
			one_count<=0;
			left_count<=0;
			right_count<=0;
			up_count<=0;
			down_count<=0;
			ignore<=0;
			oROI_x<=roi_x-1;
			oROI_y<=roi_y-1;
			roi_state<=2;
		end		
		endcase
	end
endmodule





//convert digit to hex display
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




//do label process
module label(iTrigger,ooLabling,oLabel_reading,ooLabel_writting,oLabel_x,oLabel_y,clk,iData,
oData,oLabel_number,reset,oState);
//command
input iTrigger;
//state indication
output  ooLabling;
output reg oLabel_reading;
output ooLabel_writting;
output reg[9:0]oLabel_x;
output reg[8:0]oLabel_y;
//state
reg oLabling;
assign ooLabling=oLabling;

reg oLabel_writting;
assign ooLabel_writting=oLabel_writting;
//clock
input clk;
//input data
input[7:0] iData;
//output data
output reg[7:0] oData;
output [4:0] oLabel_number;
//reset
input reset;
//state
output oState;
assign oState=label_state;
//state
reg[4:0] label_state;
//track of the label number
reg[4:0] label_number;
assign oLabel_number=label_number;
//if find on color pixel in this column
reg column_count;
//if find the first color
reg found_first;

parameter init=0,wait_for_trigger=1,find_first_point=2,search_first_column_read=3,search_first_column_write=4,
search_next_column_read=5,search_next_column_write=6;
//rest the system	
	initial begin
		label_state<=init;
		oLabel_reading<=0;
		oLabel_writting<=0;
		oLabling<=0;
		oLabel_x<=0;
		oLabel_y<=0;
		oData<=0;
		label_number<=1;
		column_count<=0;
		found_first<=0;
	end
	always @(posedge clk)
	begin
			case(label_state)
				//initiate the state
				init:
				begin
						oLabel_reading<=0;
						oLabel_writting<=0;
						oLabling<=0;
						oLabel_x<=0;
						oLabel_y<=0;
						oData<=0;				
						column_count<=0;
						found_first<=0;
					//ready to wait for trigger
					if(iTrigger==0)
					begin
						label_number<=1;
						label_state<=wait_for_trigger;
					end
				end
				
				wait_for_trigger:
				begin
				//wait for trigger
					if(iTrigger==1)
					begin
						label_state<=search_first_column_write;
						oLabel_x<=0;
						oLabel_y<=0;
						oLabel_reading<=1;
						oLabel_writting<=0;
						oLabling<=1;
						found_first<=0;
					end
				end
				
				// search the first color column
				search_first_column_write:
				begin
					//if contains color and not labeled
					if((iData[label_number[0]+5])&(~iData[7]))
					begin
						oData<={3'b100,label_number};//label it
						oLabel_writting<=1;
						oLabel_reading<=0;
						found_first<=1; //mark it has found the first pixel
					end					
					label_state<=search_first_column_read;
				end
			
				//laebel the rest of the first column
				search_first_column_read:
				begin
					oLabel_reading<=1;
					oLabel_writting<=0;
					//check if the end of the column
					if(oLabel_y<479)
					begin
						oLabel_y<=oLabel_y+1;
						label_state<=search_first_column_write;
					end
					else
					begin
						//check if the end of the frame
						if(oLabel_x<639)
						begin
							oLabel_x<=oLabel_x+1;
							oLabel_y<=0;
							if(found_first)
							begin
								label_state<=search_next_column_write;
								column_count<=0;
							end
							else
							begin
								label_state<=search_first_column_write;
							end
						end
						else
						begin
							label_state<=init;
							oLabling<=0;
						end
					
						
					end
				end
				
				
				//search the rest of the same key
				search_next_column_write:
				begin
				//if is color and not labeled
					if((iData[label_number[0]+5])&(~iData[7]))
					begin
						oLabel_reading<=0;
						oLabel_writting<=1;
						oData<={4'b1100,label_number};//label it
						column_count<=1;
					end				
					label_state<=search_next_column_read;
				end
				
				
				
				search_next_column_read:
				begin
				//stop writting
					oLabel_reading<=1;
					oLabel_writting<=0;
					//if not the end of the column
					if(oLabel_y<479)
					begin
						oLabel_y<=oLabel_y+1;
						label_state<=search_next_column_write;
					end
					else
					begin
						if(column_count)
						begin				
							//if not the end of the frame
							if(oLabel_x<639)
							begin
								oLabel_x<=oLabel_x+1;
								oLabel_y<=0;
								column_count<=0;
								label_state<=search_next_column_write;
							end
							else
							begin
								label_state<=init;
								oLabling<=0;
							end	
						end
						else
						begin
							// increase the label number
							label_number=label_number+1;
							//go to the origin of the frame
							oLabel_x<=0;
							oLabel_y<=0;
							label_state<=search_first_column_write;
							found_first<=0;
						end
					end
				end
			endcase
	end
endmodule



//find the hit key combination
module compare(iCompare_x,iCompare_y,iRun,iData,clk,oComb,iSync,iBlue,iGreen,iThresh);
//coordination
input [9:0] iCompare_x;
input [8:0] iCompare_y;
//command
input iRun;
//input dat
input [7:0] iData;
//clock
input clk;
//output data
output [19:0] oComb;
//input data
input iSync;
input iBlue;
input iGreen;
//threshold
input[5:0] iThresh;
//state of each key
reg pressed[20:0];
reg [7:0] count[20:0];
//walker
reg [4:0] index;
//output combination
assign oComb={pressed[20],pressed[19],pressed[18],pressed[17],pressed[16],pressed[15],pressed[14],pressed[13],pressed[12],pressed[11],pressed[10],pressed[9],pressed[8],pressed[7],
pressed[6],pressed[5],pressed[4],pressed[3],pressed[2],pressed[1]};
//state
reg [3:0] compare_state;

parameter wait_origion=0,check_next=1,do_threshold=2;

initial begin
	compare_state<=0;
end


always @ (posedge clk)
begin
	if(iRun)
	begin

		case(compare_state)
			//start from the origin of of the frame
			wait_origion:
			if(~iSync)
			begin
				begin
					if((iCompare_x==1)&&(iCompare_y==1))
					begin
						compare_state<=check_next;
					end	
				end
			end
			
			check_next:
			begin
			//if not in sync
				if(~iSync)
				begin
				//if labeled
					if(iData[7])
					begin
					//if has color 0
						if(iData[0])
						begin
						//check color
							if(~iBlue)
							begin
							//increase count
								count[iData[4:0]]<=count[iData[3:0]]+1;
							end
						end
						else
						begin
						//check color
							if(~iGreen)
							begin
							//increase count
								count[iData[4:0]]<=count[iData[3:0]]+1;
							end
						end					
					end
					//if the end of the frame
					if((iCompare_x==639)&&(iCompare_y==479))
					begin
						compare_state<=do_threshold;
						index<=1;
					end					
				end
			end
			//threshold count
			do_threshold:
			begin
			//if larger than threshold
				if(count[index]>iThresh)
				begin
					pressed[index]<=1;
				end
				else
				begin
					pressed[index]<=0;
				end
				//if already do threshold for all keys
				if(index==4'hf)
				begin
					compare_state<=wait_origion;
					count[20]<=0;
					count[19]<=0;
					count[18]<=0;
					count[17]<=0;
					count[16]<=0;
					count[15]<=0;
					count[14]<=0;
					count[13]<=0;
					count[12]<=0;
					count[11]<=0;
					count[10]<=0;
					count[9]<=0;
					count[8]<=0;
					count[7]<=0;
					count[6]<=0;
					count[5]<=0;
					count[4]<=0;
					count[3]<=0;
					count[2]<=0;
					count[1]<=0;
					count[0]<=0;
					
					index<=1;
				end	
				else
				begin
					index<=index+1;
				end
			end
			
		endcase
		
	end
	else
	begin
		compare_state<=0;
		//clear registers
		pressed[20]<=0;
		pressed[19]<=0;
		pressed[18]<=0;
		pressed[17]<=0;
		pressed[16]<=0;
		pressed[15]<=0;
		pressed[14]<=0;
		pressed[13]<=0;
		pressed[12]<=0;
		pressed[11]<=0;
		pressed[10]<=0;
		pressed[9]<=0;
		pressed[8]<=0;
		pressed[7]<=0;
		pressed[6]<=0;
		pressed[5]<=0;
		pressed[4]<=0;
		pressed[3]<=0;
		pressed[2]<=0;
		pressed[1]<=0;
		pressed[0]<=0;
		
		count[20]<=0;
		count[19]<=0;
		count[18]<=0;
		count[17]<=0;
		count[16]<=0;		
		count[15]<=0;
		count[14]<=0;
		count[13]<=0;
		count[12]<=0;
		count[11]<=0;
		count[10]<=0;
		count[9]<=0;
		count[8]<=0;
		count[7]<=0;
		count[6]<=0;
		count[5]<=0;
		count[4]<=0;
		count[3]<=0;
		count[2]<=0;
		count[1]<=0;
		count[0]<=0;
	end
end
endmodule



//find the single key pressed
module compare_max(iCompare_x,iCompare_y,iRun,iData,clk,oComb,iSync,iBlue,iGreen,iThresh,oNote);
//coordination
input [9:0] iCompare_x;
input [8:0] iCompare_y;
//command
input iRun;
//input data
input [7:0] iData;
//clock
input clk;
//output of key combination
output [19:0] oComb;
//input info
input iSync;
input iBlue;
input iGreen;
//threshold
input[9:0] iThresh;
//whick key is pressed
output reg [4:0] oNote;

reg pressed[20:0];
reg [9:0] count[20:0];
reg [9:0] max_number;
//walker
reg [4:0] index;
//the key with max diff
reg [4:0] max_index;
//the combination of key press
assign oComb={pressed[20],pressed[19],pressed[18],pressed[17],pressed[16],pressed[15],pressed[14],pressed[13],pressed[12],pressed[11],pressed[10],pressed[9],pressed[8],pressed[7],
pressed[6],pressed[5],pressed[4],pressed[3],pressed[2],pressed[1]};
//state
reg [3:0] compare_state;

parameter wait_origion=0,check_next=1,find_max=2;
//reset
initial begin
	compare_state<=0;
	oNote<=0;
end


always @ (posedge clk)
begin
//if running
	if(iRun)
	begin
		case(compare_state)
			//wait for origin
			wait_origion:
			if(~iSync)
			begin
				begin
				//if origin
					if((iCompare_x==1)&&(iCompare_y==1))
					begin
						compare_state<=check_next;
					end	
				end
			end
		
			check_next:
			begin
			//if not sync
				if(~iSync)
				begin
				//if labeled
					if(iData[7])
					begin
					//if has color 0
						if(iData[0])
						begin
						//check color diff
							if(~iBlue)
							begin
							//increase count
								count[iData[4:0]]<=count[iData[4:0]]+1;
							end
						end
						else
						begin
						//check color diff
							if(~iGreen)
							begin
							//increase count
								count[iData[4:0]]<=count[iData[4:0]]+1;
							end
						end					
					end
					//if end of frame
					if((iCompare_x==639)&&(iCompare_y==479))
					begin
						compare_state<=find_max;
						index<=2;
						max_index<=1;
						max_number<=count[1];
					end					
				end
			end
			//find the key with max diff
			find_max:
			begin
				if(count[index]>max_number)
				begin
					max_number<=count[index];
					max_index<=index;
					pressed[max_index]<=0;
				end
				else
				begin
					pressed[index]<=0;
				end
				//if already compare all keys
				if(index==5'd21)
				begin
				//if the largest diff larger than threshold
					if(max_number>iThresh)
					begin
					//set the key pressed
						pressed[max_index]<=1;
						oNote<=max_index;
					end
					else
					begin
						pressed[max_index]<=0;
						oNote<=0;
					end
					//reset count
					compare_state<=wait_origion;
					count[20]<=0;
					count[19]<=0;
					count[18]<=0;
					count[17]<=0;
					count[16]<=0;
					count[15]<=0;					
					count[15]<=0;
					count[14]<=0;
					count[13]<=0;
					count[12]<=0;
					count[11]<=0;
					count[10]<=0;
					count[9]<=0;
					count[8]<=0;
					count[7]<=0;
					count[6]<=0;
					count[5]<=0;
					count[4]<=0;
					count[3]<=0;
					count[2]<=0;
					count[1]<=0;
					count[0]<=0;					
					//reset index
					index<=1;
				end	
				else
				begin
				//increase index
					index<=index+1;
				end
			end
			
		endcase
		
	end
	else
	begin
	
		//reset state
		compare_state<=0;
		//clear registers
		pressed[20]<=0;
		pressed[19]<=0;
		pressed[18]<=0;
		pressed[17]<=0;
		pressed[16]<=0;
		pressed[15]<=0;		
		pressed[15]<=0;
		pressed[14]<=0;
		pressed[13]<=0;
		pressed[12]<=0;
		pressed[11]<=0;
		pressed[10]<=0;
		pressed[9]<=0;
		pressed[8]<=0;
		pressed[7]<=0;
		pressed[6]<=0;
		pressed[5]<=0;
		pressed[4]<=0;
		pressed[3]<=0;
		pressed[2]<=0;
		pressed[1]<=0;
		pressed[0]<=0;
		//note is 0 means not pressed
		oNote<=0;
		
		count[20]<=0;
		count[19]<=0;
		count[18]<=0;
		count[17]<=0;
		count[16]<=0;			
		count[15]<=0;
		count[14]<=0;
		count[13]<=0;
		count[12]<=0;
		count[11]<=0;
		count[10]<=0;
		count[9]<=0;
		count[8]<=0;
		count[7]<=0;
		count[6]<=0;
		count[5]<=0;
		count[4]<=0;
		count[3]<=0;
		count[2]<=0;
		count[1]<=0;
		count[0]<=0;
	end
end
endmodule



//display for piano
module calculate_piano(x,y,value,h_line,key_color,key_color2,comb0,comb1,comb2,comb3,ikeys,front,nkeys_input,calib,calib2,practice); //calculate a single pixel
//max supported key number
parameter  maxkeys=20;
//coordination
input[8:0] x;
input [8:0] y;
//output value
output[15:0] value;
//key combination
input [maxkeys-1:0] ikeys;
//number of keys
input [3:0] nkeys_input;
//input state
input calib;
input calib2;
input practice;


reg [4:0] nkeys;

//key number  interprete
always @(*)
begin
	case(nkeys_input)
	0:	nkeys<=1;
	1:	nkeys<=2;
	2:	nkeys<=4;
	3:	nkeys<=5;
	4:	nkeys<=8;
	5:	nkeys<=10;
	6:	nkeys<=16;
	7:	nkeys<=20;
	endcase
end
//display key lengh	
wire [8:0] length;
assign length=320/nkeys;
//display key height
parameter height=60;
//the splition line between keys and notes
input [8:0] h_line;
//key colors
input[15:0] key_color;
input[15:0] key_color2;
//combination for each beat
input [maxkeys-1:0] comb0,comb1,comb2,comb3;
//front line
input[8:0] front;
//note color
reg[15:0] color;

//intermedia result for calculation
wire[8:0] temp1,temp2,temp3,temp4,temp5,temp6;
wire [maxkeys-1:0] comb;
assign comb=(temp4==0)?comb3:((temp4==1)?comb2:((temp4==2)?comb1:((temp4==3)?comb0:0)));
assign temp2=x%length;
assign temp3=x/length;
assign temp4=(y+height-front)/height; //temp4 is from 0 to 3
assign temp5=(y+height-front)%height; 
assign value=color;

always @(*)
begin
//if the pixel is in splition line
	if(y==h_line )
	begin
		if(calib)
			color<=16'h0000;
		else
			color<=16'h0000;
		
	end
	else
	begin
		//if pixel in column splition line
		if((temp2==0 )&(x>0))
		begin
			color<=0;
		end
		else
		begin
		//if pixel in notes display section
			if(y<h_line)
			begin
			//if in calibration mode
				if(calib)
				begin
					color<=0;
				end
				else
				begin
				//if in practice mode
					if(practice)
					begin
					//if key is to pressed
						if(ikeys[temp3])
							color<=16'h2222;
						else
							color<=16'h3333;
					end
					else
					begin
					//if pixel is the note to be played
							if(comb[temp3])
							begin
							//if mark the start of a new note
								if(temp5==59)
								begin
									color<=0;
								end
								else
								begin
								//if vertical match
									if (temp4==3)
									begin
										color<=key_color2;
									end
									else
									begin
										color<=key_color;
									end
								end
							end						
							else
							begin
							//if column pressed
								if(ikeys[temp3])
									color<=16'h2222;
								else
									color<=16'h3333;
							end
					end
				end
			end
			else
			begin
			//if in calibration mode
				if(calib)
				begin
					if(calib2)
					begin
					//if color 0
							if(temp3[0])
							begin
								color<=16'h0f00;
							end
							else
							begin
								color<=16'h00f0;
							end					
					end
					else
					begin
						color<=16'h0f0f;
					end
					
				end
				else
				begin
				//if color 0
							if(temp3[0])
							begin
								color<=16'h0f00;
							end
							else
							begin
								color<=16'h00f0;
							end
				end
			end
		end
	end
end
endmodule




// clock to drive melody display
module timer(iclk,ofront,ibmp,obeats,iReset,pause,inumber_of_notes);
input iclk;
output [8:0] ofront;
input [7:0] ibmp;
output reg[7:0] obeats;
input  iReset;
input pause;
input [7:0] inumber_of_notes;

wire[8:0] line_time;
reg[8:0] front;
assign ofront=front;
reg [16:0] count;
reg[16:0] count_p;

reg[3:0] timer_state;

parameter wait_for_trigger=0,counting=1;
assign line_time=1000/(ibmp*60);

initial begin
	obeats<=0;
	count_p<=0;
	count<=0;
	timer_state<=wait_for_trigger;
end


always @ (posedge iclk)
begin
	
	//reset
	if(iReset)
	begin
		obeats<=0;
		count_p<=0;
		count<=0;
		timer_state<=counting;
	end
	else
	begin
	
		case(timer_state)
		//wait for tirgger
			wait_for_trigger:
			begin
				obeats<=0;
				count_p<=0;
				count<=0;
	
			end
			//triggered
			counting:
			begin
				if(~pause)
				begin
					if(count_p<50000)//if hasn't accumulated for 50000 periods
					begin
						count_p<=count_p+1;// count of period increse by 1
					end
					else
					begin
						count_p<=0; //clear the count of period
						if(count<line_time)
						begin
							count<=count+1;//increase count of micro second by 1
						end
						else
						begin
							count<=0;
							//if the end of front
							if(front<59)
							begin
								front<=front+1;
							end
							else
							begin
							
								front<=0;
								//if the end of the song
								if(obeats==inumber_of_notes)
									timer_state<=wait_for_trigger;
								else
								//increase beat count
									obeats<=obeats+1;
							end
						end
					end
				end
			end
		endcase
	end
end
endmodule


//store the melody as ram
module melody(iBeat,oComb1,oComb2,oComb3,oComb4,clk);
//currently
input [7:0] iBeat;
//output combination for each beat
//current beat
output [5:0] oComb1;
//next beat
output [5:0] oComb2;
//next next beat
output [5:0] oComb3;
//next next next beat
output [5:0] oComb4;
input clk;

assign oComb1=song1[iBeat];
assign oComb2=song1[iBeat+1];
assign oComb3=song1[iBeat+2];
assign oComb4=song1[iBeat+3];

reg [5:0] song1 [67:0];



always@(posedge clk)
begin
	song1[0]<=6'b000000;
	song1[1]<=6'b000000;
	song1[2]<=6'b000000;
	song1[3]<=6'b001000;
	song1[4]<=6'b001000;
	song1[5]<=6'b001000;
	song1[6]<=6'b000001;
	song1[7]<=6'b000010;
	song1[8]<=6'b000010;
	song1[9]<=6'b000001;
	song1[10]<=6'b000000;
	song1[11]<=6'b100000;
	song1[12]<=6'b100000;
	song1[13]<=6'b010000;
	song1[14]<=6'b010000;
	song1[15]<=6'b001000;
	song1[16]<=6'b000000;
	song1[17]<=6'b000000;
	song1[18]<=6'b000000;
	song1[19]<=6'b001000;
	song1[20]<=6'b001000;
	song1[21]<=6'b001000;
	song1[22]<=6'b000001;
	song1[23]<=6'b000010;
	song1[24]<=6'b000010;
	song1[25]<=6'b000001;
	song1[26]<=6'b000000;
	song1[27]<=6'b100000;
	song1[28]<=6'b100000;
	song1[29]<=6'b010000;
	song1[30]<=6'b010000;
	song1[31]<=6'b001000;
	song1[32]<=6'b000000;
	song1[33]<=6'b000000;
	song1[34]<=6'b000001;
	song1[35]<=6'b001000;
	song1[36]<=6'b001000;
	song1[37]<=6'b001000;
	song1[38]<=6'b000001;
	song1[39]<=6'b001000;
	song1[40]<=6'b001000;
	song1[41]<=6'b001000;
	song1[42]<=6'b000000;
	song1[43]<=6'b001000;
	song1[44]<=6'b001000;
	song1[45]<=6'b001000;
	song1[46]<=6'b001000;
	song1[47]<=6'b001000;
	song1[48]<=6'b001000;
	song1[49]<=6'b001000;
	song1[50]<=6'b001000;
	song1[51]<=6'b000000;
	song1[52]<=6'b000000;
	song1[53]<=6'b000000;
	song1[54]<=6'b000000;
	song1[55]<=6'b000000;
	song1[56]<=6'b000000;
	song1[57]<=6'b000000;
	song1[58]<=6'b000000;
	song1[59]<=6'b000000;
	song1[60]<=6'b000000;
	song1[61]<=6'b000000;
	song1[62]<=6'b000000;
	song1[63]<=6'b000000;

end


endmodule







//grade user's performance
module score(iBeat,iComb_melody,iComb_play,ireset,oScore,clk);
//beat number
input [7:0] iBeat;
//correct melody
input [5:0] iComb_melody;
//user played melody
input [5:0] iComb_play;
input ireset;
output reg[7:0] oScore;
input clk;

reg [7:0] current_beat;
reg counted;
//clear score
initial begin
	oScore<=0;
	current_beat<=0;
	counted<=0;
end

always @ (posedge clk)
begin
//reset
	if(ireset)
	begin
		oScore<=0;
		current_beat<=0;
		counted<=0;
	end
	else
	begin
	//if beat changed
		if(iBeat==current_beat)
		begin
		//is melody is not empty and haven't been counted
			if((iComb_melody!=0)&&(~counted))
			begin
				if(iComb_melody==iComb_play)
				begin
					oScore<=oScore+1;
					//set as counted
					counted<=1;
				end
			end
		end
		else
		begin
		//set the beat number
			current_beat<=iBeat;
			counted<=0;			
		end
	end
end
endmodule



module note_display (segs,key);
	input [2:0] key	;		//the hex digit to be displayed
	output reg [6:0] segs ;		//actual LED segments
	always @ (key)
	begin
		case (key)				
				3'h0: segs = 7'b1000110; //c
				3'h1: segs = 7'b0100001; //d
				3'h2: segs = 7'b0000110; //e
				3'h3: segs = 7'b0001110; //f	
				3'h4: segs = 7'b0010000; //g
				3'h5: segs = 7'b0001000; //a
				3'h6: segs = 7'b0000011; //b
				3'h7: segs = 7'b0000011; //c
				default segs = 7'b1111111;
		endcase
	end
endmodule

module pause_displey(segs,key);
	input  key	;		//the hex digit to be displayed
	output reg [6:0] segs ;		//actual LED segments
	always @ (key)
	begin
		case (key)
				1'h0: segs = 7'b0001100; //pause
				1'h1: segs = 7'b0101111; //run
				default segs = 7'b1111111;
		endcase
	end
endmodule	

//generate sound with square wave
module sound (ifrequency,odata,clk);
//input frequency
input [10:0] ifrequency;
//output audio data
output [15:0] odata;
//clock
input clk;
//counter
reg[6:0] count_p;
reg[12:0] count_f;
//frequency splition
wire [12:0] num_of_fivek;
assign num_of_fivek=250000/ifrequency;
assign odata=(ifrequency==0)? 0:(flip? 16'h7fff:16'h8000);
reg flip;
//reset
initial begin
	flip<=0;
	count_f<=0;
	count_p<=0;
end


always @(posedge clk)
begin
//cout_p is 500k
	if(count_p<100)
	begin
		count_p<=count_p+1;
	end
	else
	begin
		count_p<=0;
		//not reach the slip point
		if(count_f<num_of_fivek)
		begin
			count_f<=count_f+1;
		end
		else
		begin
			count_f<=0;
			//do data flip;
			flip<=~flip;
		end
	end
end
endmodule


//note-frequency interpretion
module get_frequency(inote,istart_note,ofrequency,clk);
input [4:0] inote;
input [3:0] istart_note;
output [10:0] ofrequency;
input clk;
//if not playing, frequency is 0
assign ofrequency=(inote==0)?0:freq_table[inote+istart_note];

reg [10:0] freq_table[26];

always @ (posedge clk)
begin

	freq_table[0]<= 0;
	freq_table[1]<= 262;
	freq_table[2]<= 294;
	freq_table[3]<= 330;
	freq_table[4]<= 349;
	freq_table[5]<= 392;
	freq_table[6]<= 440;
	freq_table[7]<= 494;
	freq_table[8]<= 523;
	freq_table[9]<= 587;
	freq_table[10]<= 659;
	freq_table[11]<= 698;
	freq_table[12]<= 784;
	freq_table[13]<= 880;
	freq_table[14]<= 988;
	freq_table[15]<= 1047;
	freq_table[16]<= 1175;
	freq_table[17]<= 1319;
	freq_table[18]<= 1397;
	freq_table[19]<= 1568;
	freq_table[20]<= 1760;
	freq_table[21]<= 1976;
	freq_table[22]<= 2093;
	freq_table[23]<= 2349;
	freq_table[24]<= 2637;
	freq_table[25]<= 2794;

end
endmodule