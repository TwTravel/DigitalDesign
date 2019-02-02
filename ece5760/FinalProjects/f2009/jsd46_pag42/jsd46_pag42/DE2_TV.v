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

//	Enable TV Decoder
assign	TD_RESET	=	KEY[0];

//	For Audio CODEC
wire		AUD_CTRL_CLK;	//	For Audio Controller
assign		AUD_XCK	=	AUD_CTRL_CLK;



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
							.iX(VGA_X),
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

wire [9:0] eRed, eGreen, eBlue;

// green screen, fade, and text effects
effects				uNew (	.iRESET(~KEY[0]),
							.iCLK27(OSC_27),
							.iCLK50(OSC_50),
							.imVGA_R(mVGA_R),
							.imVGA_G(mVGA_G),
							.imVGA_B(mVGA_B),
							.iKEY(~KEY[1]),
							.iSetL(~KEY[2]),
							.iX(VGA_X),
							.iY(VGA_Y),
							.iRed(mRed),
							.iGreen(mGreen),
							.iBlue(mBlue),
							.iSW(DPDT_SW[17:0]),
							.next_key(next_key),
							.char(char),
							.oLEDG(LED_GREEN),
							.oLEDR(LED_RED),
							.oRed(eRed),
							.oGreen(eGreen),
							.oBlue(eBlue)	);



// SRAM
reg [17:0] addr_reg; 	//memory address register for SRAM
reg [15:0] data_reg; 	//memory data register  for SRAM
reg we ;				//write enable for SRAM
reg lock; //did we stay in sync?

// SRAM_control
assign SRAM_ADDR = addr_reg;
assign SRAM_DQ = (we)? 16'hzzzz : data_reg ;
assign SRAM_UB_N = 0;					// hi byte select enabled
assign SRAM_LB_N = 0;					// lo byte select enabled
assign SRAM_CE_N = 0;					// chip is enabled
assign SRAM_WE_N = we;					// write when ZERO
assign SRAM_OE_N = 0;					//output enable is overidden by WE

// VGA
wire 		reset;
wire		VGA_CTRL_CLK;
wire [9:0]	mVGA_R;
wire [9:0]	mVGA_G;
wire [9:0]	mVGA_B;
wire [19:0]	mVGA_ADDR;			//video memory address

//	VGA Controller
VGA_Ctrl			u9	(	//	Host Side
							.iRed(eRed),
							.iGreen(eGreen),
							.iBlue(eBlue),
							.oCurrent_X(VGA_X),
							.oCurrent_Y(VGA_Y),
							.oRequest(VGA_Read),
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

//Assign the Red, Green, and Blue values from SRAM
//SRAM is packed two pixels per data 16 bits, so 8 bits of color per pixel
//each 8 bits holds the color values as RRRGGGBB
//On assigns it duplicates the respective colors and pads if necessary to form 10 bits for each color

assign  mVGA_R = VGA_X[0] ? {SRAM_DQ[15:13], SRAM_DQ[15:13],SRAM_DQ[15:13],1'b1} : {SRAM_DQ[7:5], SRAM_DQ[7:5],SRAM_DQ[7:5],1'b1} ;
assign  mVGA_G = VGA_X[0] ? {SRAM_DQ[12:10], SRAM_DQ[12:10],SRAM_DQ[12:10],1'b1} : {SRAM_DQ[4:2], SRAM_DQ[4:2],SRAM_DQ[4:2],1'b1};
assign  mVGA_B = VGA_X[0] ? {SRAM_DQ[9:8], SRAM_DQ[9:8],SRAM_DQ[9:8],SRAM_DQ[9:8],SRAM_DQ[9:8]}  : {SRAM_DQ[1:0], SRAM_DQ[1:0],SRAM_DQ[1:0],SRAM_DQ[1:0],SRAM_DQ[1:0]};

reg [25:0] bgc2;

always @(posedge VGA_CLK) begin
	if(~KEY[0]) begin
		bgc2 <= 26'd0;
	end
	else begin
		if(bgc2 < 26'h3FFFFFF) begin
			bgc2 <= bgc2 + 26'd1;
		end
		else begin
			bgc2 <= 26'd0;
		end
	end
	
end

//	For ITU-R 656 Decoder
wire	[15:0]	YCbCr;
wire	[9:0]	TV_X;
wire			TV_DVAL;

//	For VGA Controller
wire	[9:0]	mRed;
wire	[9:0]	mGreen;
wire	[9:0]	mBlue;
wire	[10:0]	VGA_X;
wire	[10:0]	VGA_Y;
wire			VGA_Read;	//	VGA data request
wire			m1VGA_Read;	//	Read odd field
wire			m2VGA_Read;	//	Read even field

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



assign	m1VGA_Read	=	VGA_Y[0]		?	1'b0		:	VGA_Read	;
assign	m2VGA_Read	=	VGA_Y[0]		?	VGA_Read	:	1'b0		;
assign	mYCbCr_d	=	!VGA_Y[0]		?	m1YCbCr		:
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
					//	Control Signals
					.iSrc_Select(2'b01),
			        .iCLK_18_4(AUD_CTRL_CLK),
					.iRST_N(DLY1)	);

////////////////////
// keyboard stuff //
////////////////////
// set all inout ports to tri-state
assign  GPIO_0    =  36'hzzzzzzzzz;
assign  GPIO_1    =  36'hzzzzzzzzz;

wire [7:0] scan_code;

reg [7:0] history[1:4];
wire read, scan_ready;

oneshot pulser(
   .pulse_out(read),
   .trigger_in(scan_ready),
   .clk(OSC_50)
);

keyboard kbd	(
  .keyboard_clk(PS2_CLK),
  .keyboard_data(PS2_DAT),
  .clock50(OSC_50),
  .reset(~KEY[0]),
  .read(read),
  .scan_ready(scan_ready),
  .scan_code(scan_code)
);

hex_7seg dsp0(history[1][3:0],HEX0);
hex_7seg dsp1(history[1][7:4],HEX1);

hex_7seg dsp2(history[2][3:0],HEX2);
hex_7seg dsp3(history[2][7:4],HEX3);

hex_7seg dsp4(history[3][3:0],HEX4);

reg [3:0] count;
reg [17:0] scan_count;

assign LEDR = scan_count;

always @(posedge (next_key | ~KEY[0]))
begin
	if (~KEY[0]) count <= 0;
	count <= count + 1;
end

// for keyboard debugging
hex_7seg dsp5(count,HEX5);
hex_7seg dsp6(char[3:0],HEX6);
hex_7seg dsp7(char[7:4],HEX7);

always @(posedge scan_ready)
begin
    history[4] <= history[3];
    history[3] <= history[2];
    history[2] <= history[1];
    history[1] <= scan_code;
end

wire next_key;
wire [8:0] char;

keypress kp	(	.scan_ready(scan_ready),
				.scan_code(scan_code),
				.next_key(next_key),
				.char(char)	);

//////////////////////////
// Image Transfer Stuff //
//////////////////////////
wire [17:0] addr_image;
wire [15:0] data_image;
wire we_image;
reg [14:0] myAddr;
wire [2:0] myData_out;
reg [14:0] imAddr;
wire [2:0] imData_out;
reg [2:0] imData_in;
wire serial_data_clock;
wire [7:0] lastRXD;
wire sendACK;
reg rSendACK;
assign sendACK = rSendACK;
wire [17:0] bgc;
wire baudClock, baudClock_8Times, baudClock_fast8;

//The baud generator
BaudGenerator bg1(	.clock_in(OSC_50),
					.baud_clock_out(baudClock)
				  );
//8 times baud generator
BaudGenerator_8Times bg8t1(	.clock_in(OSC_50),
							.baud_clock_out(baudClock_8Times)
							);
//better 8 times as fast baud generator							
BaudGenerator_fast bgf1(.clock_in(OSC_50),
						.baud_clock_out(baudClock_fast8)
						);
//the serial receiver
SerialReceiver_improved_fastClock sr_i1(
			.CLOCK_50(OSC_50),
			.UART_RXD(UART_RXD),
			.lastReceived(serData),
			.dataReady_out(dataReady),
			.errorFlag_out(errorFlag),
			.reset(~KEY[0]),
			.dataCounter(dataCounter),
			.bigCounter(bgc),
			//.errs(LEDR[6:0]),
			//.state_out(LEDG[7:4]),
			.error_check(receive_error_check),
			.timeout(packet_timeout),
			.baud_clock(baudClock),
			.baud_8_clock(baudClock_fast8)
			);

wire packet_timeout;  // signal that the current packet has timedout
wire packet1_ready; //signal that the current packet is ready
wire [127:0] packet1; //the current packet data
wire packet1_crc_result; //the CRC result of the current packet
wire transmit_idle;
wire [7:0] crc;
wire [3:0] receive_state_out;
wire [8:0] receive_error_check;

//The Packet manager module
PacketManager pm1(
										.data_in(serData),
										.packet_out(packet1),
										.timeout(packet_timeout),
										.timeout_in(packet_timeout),
										.dataAvailable_in(dataReady),
										.reset(~KEY[0]),
										.packet_ready_out(packet1_ready),
										.idle(transmit_idle),
										.last_packet(last_packet),
										//.timeout_count({LEDR[17:0],LEDG[7:1]} ),
										.fast_clock(OSC_50),
										//.data_index_out(LEDG[7:3])
									);
									
//The CRC module									
CRC crc1(
					.packet_in(last_packet /*packet1*/),
					.packet_ready_in(packet1_ready),
					.crc_result_out(packet1_crc_result),
					.reset(~KEY[0]),
					.crc_out(crc)
				);
				
wire [127:0] last_packet; //the last packet received
wire [7:0] lastCRC; //the last CRC result received
reg [9:0] xwp, ywp; //register for x and y coordinates into sram and vga
reg [4:0] iwp; //state variable for creating the image
reg [7:0] bwp; //a more memory state variable for creating the image

//The serial Transmitter Wire
SerialTransmitter_improved st_i1( 
												.CLOCK_50(OSC_50),
												.UART_TXD(UART_TXD),
												.toTransmit({8{packet1_crc_result}}),
												.reset(~KEY[0]),
												//.dataSent_out(),
												.sendNew(packet1_ready),
												//.SW(),
												//.idle(transmit_idle),
												.goBackToIdle(~packet1_ready),
												.lastTransmit(lastCRC),
												.timeout_send(packet_timeout),
												.baud_clock(baudClock)
												);

	
wire imageWrite_ready;
wire [15:0] imageWrite_color;
wire [9:0] imageWrite_xpos;
wire [9:0] imageWrite_ypos;

			

wire [7:0] serData;
wire [7:0] serialToTransmit;
wire dataReady;
wire dataSent;
wire errorFlag;
wire sendNewSerial;

reg [17:0] recvCounter;

assign serialToTransmit = serTransmit;

reg [7:0] serTransmit;
reg [3:0] serState;
wire [7:0] dataCounter;
reg [7:0] sendDataCounter;
reg serSendNew;
reg wtf; //seriously, wtf? use this register if you are confused about what is going on
//assign LEDG[5] = errorFlag;
parameter [3:0] recvData = 4'd0,
				sendingConfirmation = 4'd1;
				
assign sendNewSerial = serSendNew;

reg imLoaded;


reg [4:0] simpleCase;
reg [9:0] imageWidth, imageHeight;
reg [9:0] currX, currY;
reg [15:0] rData;
reg [17:0] rAddr;

reg serialDataAlreadyUsed;

reg [4:0] dstate;
parameter [4:0] waitGoodPacket = 5'd0,
				useData = 5'd1,
				waitNext = 5'd2;
				
reg defaultError;
reg [8:0] x_pos, y_pos; //coordinates of cell being drawn
wire [17:0] SW = DPDT_SW[17:0];
assign reset = ~KEY[0];

always @ (posedge VGA_CLK)
begin
	//reset with one pixel in first line
	if (~KEY[3])
	begin
		//reset position
		x_pos <= 0;
		y_pos <= 0;
		//clear the screen
		addr_reg <= {VGA_X[9:1],VGA_Y[8:0]} ;	// [17:0]
		we <= 1'b0;								//write some memory
		data_reg <= 16'hF0F0;						//write all zeros (black)		
		myAddr <= 0;
		//imAddr <= 0;
		imLoaded <= 0;
		rSendACK <= 0;
		simpleCase <= 5'd0;
		serialDataAlreadyUsed <= 0;
		currX <= 0;
		currY <= 0;
		imageHeight <= 0;
		imageWidth <= 0;
		serState <= recvData;
		serSendNew <= 0;
		sendDataCounter <= 0;
		serTransmit <= 0;
		wtf <= 0;
		recvCounter <= 0;
		xwp <= 0;
		ywp <= 0;
		iwp <= 1;
		dstate <= waitGoodPacket;
	end

	//modify display during sync
	else if(~VGA_VS | ~VGA_HS)
	begin
		//case statement for the 5 different receive modes
		case(SW[2:0])
			0: begin //Direct Draw Mode
				//in direct draw mode you directly specify the pixel location and color value for each pixel
				//stretches in the x direction, and does not stretch in the Y
				//takes in a 320x240 image and outputs a 640x240 image
				if((packet1_ready == 1'b1) && (packet1_crc_result == 1'b1)) begin
					we <= 1'b0;
					if(iwp < 4) begin
						case(iwp)
							1: begin
								addr_reg <= last_packet[127:110];
								data_reg <= {2{last_packet[103:96]}};
							end
							2: begin
								addr_reg <= last_packet[95:78];
								data_reg <= {2{last_packet[71:64]}};
							end
							3: begin
								addr_reg <= last_packet[63:46];
								data_reg <= {2{last_packet[39:32]}};
							end
						endcase
						iwp <= iwp + 1;
					end
					else begin
						iwp <= 1;
					end
				end
				else begin
					we <= 1'b1;
				end
			end
			
			//320x240 image draw mode
			//takes in a 320x240 image and stretches in x and y to create a 640x480 image
			//the packet here specifies a start x and y coordinate, and then increments x by 1 for every data byte
			
			1: begin
				 if((packet1_ready == 1'b1) && (packet1_crc_result == 1'b1)) begin
					if(iwp < 24) begin
						iwp <= iwp + 1;
					end
					else begin
						iwp <= 0;
					end
					if(iwp == 0) begin
						xwp[8:0] <= last_packet[127:119];
						ywp[8:0] <= last_packet[118:110];
						we <= 1'b0;
					end
					if(iwp > 0 && iwp < 13) begin
						we <= 1'b0;
						if( (xwp[8:0] + ({4'b0,iwp}-9'd1)) < 320) begin
							//addr_reg <= {xwp[8:0] + ({4'b0,iwp}-9'd1), ywp[8:0]};
							addr_reg <= {last_packet[127:119] + ({4'b0,iwp}-9'd1), ({last_packet[117:110],1'b0})};
						end
						else begin
							//addr_reg <= {(xwp[8:0] + (iwp - 1) - 320) , ywp[8:0] + 1};
						end
					end
					if(iwp > 12 && iwp < 25) begin
						we <= 1'b0;
						if( (xwp[8:0] + ({4'b0,iwp-9'd12}-9'd1)) < 320) begin
							//addr_reg <= {xwp[8:0] + ({4'b0,iwp}-9'd1), ywp[8:0]};
							addr_reg <= {last_packet[127:119] + ({4'b0,iwp-9'd12}-9'd1), ({last_packet[117:110],1'b1})};
						end
						else begin
							//addr_reg <= {(xwp[8:0] + (iwp - 1) - 320) , ywp[8:0] + 1};
						end
					end
					case(iwp)
						1: data_reg <= {2{last_packet[103:96]}};
						2: data_reg <= {2{last_packet[95:88]}};
						3: data_reg <= {2{last_packet[87:80]}};
						4: data_reg <= {2{last_packet[79:72]}};
						5: data_reg <= {2{last_packet[71:64]}};
						6: data_reg <= {2{last_packet[63:56]}};
						7: data_reg <= {2{last_packet[55:48]}};
						8: data_reg <= {2{last_packet[47:40]}};
						9: data_reg <= {2{last_packet[39:32]}};
						10: data_reg <= {2{last_packet[31:24]}};
						11: data_reg <= {2{last_packet[23:16]}};
						12: data_reg <= {2{last_packet[15:8]}};
						13: data_reg <= {2{last_packet[103:96]}};
						14: data_reg <= {2{last_packet[95:88]}};
						15: data_reg <= {2{last_packet[87:80]}};
						16: data_reg <= {2{last_packet[79:72]}};
						17: data_reg <= {2{last_packet[71:64]}};
						18: data_reg <= {2{last_packet[63:56]}};
						19: data_reg <= {2{last_packet[55:48]}};
						20: data_reg <= {2{last_packet[47:40]}};
						21: data_reg <= {2{last_packet[39:32]}};
						22: data_reg <= {2{last_packet[31:24]}};
						23: data_reg <= {2{last_packet[23:16]}};
						24: data_reg <= {2{last_packet[15:8]}};
					endcase
				end
				else begin
					we <= 1'b1;
				end
			
			end
			
			//this is a stretch x only 320x240 to 640x480 image draw method
			//works the same as mode 1, but doesn't stretch y
			2: begin
				if((packet1_ready == 1'b1) && (packet1_crc_result == 1'b1)) begin
					if(iwp < 12) begin
						iwp <= iwp + 1;
					end
					else begin
						iwp <= 0;
					end
					if(iwp == 0) begin
						xwp[8:0] <= last_packet[127:119];
						ywp[8:0] <= last_packet[118:110];
						we <= 1'b0;
					end
					if(iwp > 0 && iwp < 13) begin
						we <= 1'b0;
						if( (xwp[8:0] + ({4'b0,iwp}-9'd1)) < 320) begin
							//addr_reg <= {xwp[8:0] + ({4'b0,iwp}-9'd1), ywp[8:0]};
							addr_reg <= {last_packet[127:119] + ({4'b0,iwp}-9'd1), last_packet[118:110]};
						end
						else begin
							//addr_reg <= {(xwp[8:0] + (iwp - 1) - 320) , ywp[8:0] + 1};
						end
					end
					case(iwp)
						1: data_reg <= {2{last_packet[103:96]}};
						2: data_reg <= {2{last_packet[95:88]}};
						3: data_reg <= {2{last_packet[87:80]}};
						4: data_reg <= {2{last_packet[79:72]}};
						5: data_reg <= {2{last_packet[71:64]}};
						6: data_reg <= {2{last_packet[63:56]}};
						7: data_reg <= {2{last_packet[55:48]}};
						8: data_reg <= {2{last_packet[47:40]}};
						9: data_reg <= {2{last_packet[39:32]}};
						10: data_reg <= {2{last_packet[31:24]}};
						11: data_reg <= {2{last_packet[23:16]}};
						12: data_reg <= {2{last_packet[15:8]}};
					endcase
				end
				else begin
					we <= 1'b1;
				end
			end
			
			//640x480 image draw mode, draws a color image with 640x480 resolution
			3: begin
				if((packet1_ready == 1'b1) && (packet1_crc_result == 1'b1)) begin
					if(iwp < 6) begin
						iwp <= iwp + 1;
					end
					else begin
						iwp <= 0;
					end
					if(iwp == 0) begin
						xwp[8:0] <= last_packet[127:119];
						ywp[8:0] <= last_packet[116:108];
						we <= 1'b0;
					end
					if(iwp > 0 && iwp < 7) begin
						we <= 1'b0;
						if( (last_packet[127:119] + ({4'b0,iwp}-9'd1)) < 320) begin
							//addr_reg <= {xwp[8:0] + ({4'b0,iwp}-9'd1), ywp[8:0]};
							addr_reg <= {last_packet[127:119] + ({4'b0,iwp}-9'd1), last_packet[116:108]};
						end
						else begin
							//addr_reg <= {(xwp[8:0] + (iwp - 1) - 320) , ywp[8:0] + 1};
						end
					end
					case(iwp)
						1: data_reg <= {last_packet[103:96],last_packet[95:88]};
						
						2: data_reg <= {last_packet[87:80],last_packet[79:72]};
						
						3: data_reg <= {last_packet[71:64],last_packet[63:56]};
						
						4: data_reg <= {last_packet[55:48],last_packet[47:40]};
						
						5: data_reg <= {last_packet[39:32],last_packet[31:24]};
						
						6: data_reg <= {last_packet[23:16],last_packet[15:8]};
						
					endcase
				end
				else begin
					we <= 1'b1;
				end
			end
			
			//Black and White Image Draw method, supports 320x240 image resolution
			4: begin
				 if(1'b1)begin//(packet1_ready == 1'b1) && (packet1_crc_result == 1'b1)) begin
					if(bwp < 193) begin
						bwp <= bwp + 1;
					end
					else begin
						bwp <= 0;
					end
					if(bwp == 0) begin
						xwp[8:0] <= last_packet[127:119];
						ywp[8:0] <= last_packet[118:110];
						we <= 1'b0;
					end
					if(bwp > 0 && bwp < 97) begin
						we <= 1'b0;
						if( (xwp[8:0] + ({1'b0,bwp}-9'd1)) < 320) begin
							//addr_reg <= {xwp[8:0] + ({4'b0,iwp}-9'd1), ywp[8:0]};
							addr_reg <= {last_packet[127:119] + ({1'b0,bwp}-9'd1), ({last_packet[117:110],1'b0})};
						end
						else begin
							//addr_reg <= {(xwp[8:0] + (iwp - 1) - 320) , ywp[8:0] + 1};
						end
					end
					if(bwp > 96 && bwp < 193) begin
						we <= 1'b0;
						if( (xwp[8:0] + ({4'b0,bwp-9'd96}-9'd1)) < 320) begin
							//addr_reg <= {xwp[8:0] + ({4'b0,iwp}-9'd1), ywp[8:0]};
							addr_reg <= {last_packet[127:119] + ({1'b0,bwp-9'd96}-9'd1), ({last_packet[117:110],1'b1})};
						end
						else begin
							//addr_reg <= {(xwp[8:0] + (iwp - 1) - 320) , ywp[8:0] + 1};
						end
					end
					case(bwp)
						1: data_reg <= {16{last_packet[103]}};
						2: data_reg <= {16{last_packet[102]}};
						3: data_reg <= {16{last_packet[101]}};
						4: data_reg <= {16{last_packet[100]}};
						5: data_reg <= {16{last_packet[99]}};
						6: data_reg <= {16{last_packet[98]}};
						7: data_reg <= {16{last_packet[97]}};
						8: data_reg <= {16{last_packet[96]}};
						9: data_reg <= {16{last_packet[95]}};
						10: data_reg <= {16{last_packet[94]}};
						11: data_reg <= {16{last_packet[93]}};
						12: data_reg <= {16{last_packet[92]}};
						13: data_reg <= {16{last_packet[91]}};
						14: data_reg <= {16{last_packet[90]}};
						15: data_reg <= {16{last_packet[89]}};
						16: data_reg <= {16{last_packet[88]}};
						17: data_reg <= {16{last_packet[87]}};
						18: data_reg <= {16{last_packet[86]}};
						19: data_reg <= {16{last_packet[85]}};
						20: data_reg <= {16{last_packet[84]}};
						21: data_reg <= {16{last_packet[83]}};
						22: data_reg <= {16{last_packet[82]}};
						23: data_reg <= {16{last_packet[81]}};
						24: data_reg <= {16{last_packet[80]}};
						25: data_reg <= {16{last_packet[79]}};
						26: data_reg <= {16{last_packet[78]}};
						27: data_reg <= {16{last_packet[77]}};
						28: data_reg <= {16{last_packet[76]}};
						29: data_reg <= {16{last_packet[75]}};
						30: data_reg <= {16{last_packet[74]}};
						31: data_reg <= {16{last_packet[73]}};
						32: data_reg <= {16{last_packet[72]}};
						33: data_reg <= {16{last_packet[71]}};
						34: data_reg <= {16{last_packet[70]}};
						35: data_reg <= {16{last_packet[69]}};
						36: data_reg <= {16{last_packet[68]}};
						37: data_reg <= {16{last_packet[67]}};
						38: data_reg <= {16{last_packet[66]}};
						39: data_reg <= {16{last_packet[65]}};
						40: data_reg <= {16{last_packet[64]}};
						41: data_reg <= {16{last_packet[63]}};
						42: data_reg <= {16{last_packet[62]}};
						43: data_reg <= {16{last_packet[61]}};
						44: data_reg <= {16{last_packet[60]}};
						45: data_reg <= {16{last_packet[59]}};
						46: data_reg <= {16{last_packet[58]}};
						47: data_reg <= {16{last_packet[57]}};
						48: data_reg <= {16{last_packet[56]}};
						49: data_reg <= {16{last_packet[55]}};
						50: data_reg <= {16{last_packet[54]}};
						51: data_reg <= {16{last_packet[53]}};
						52: data_reg <= {16{last_packet[52]}};
						53: data_reg <= {16{last_packet[51]}};
						54: data_reg <= {16{last_packet[50]}};
						55: data_reg <= {16{last_packet[49]}};
						56: data_reg <= {16{last_packet[48]}};
						57: data_reg <= {16{last_packet[47]}};
						58: data_reg <= {16{last_packet[46]}};
						59: data_reg <= {16{last_packet[45]}};
						60: data_reg <= {16{last_packet[44]}};
						61: data_reg <= {16{last_packet[43]}};
						62: data_reg <= {16{last_packet[42]}};
						63: data_reg <= {16{last_packet[41]}};
						64: data_reg <= {16{last_packet[40]}};
						65: data_reg <= {16{last_packet[39]}};
						66: data_reg <= {16{last_packet[38]}};
						67: data_reg <= {16{last_packet[37]}};
						68: data_reg <= {16{last_packet[36]}};
						69: data_reg <= {16{last_packet[35]}};
						70: data_reg <= {16{last_packet[34]}};
						71: data_reg <= {16{last_packet[33]}};
						72: data_reg <= {16{last_packet[32]}};
						73: data_reg <= {16{last_packet[31]}};
						74: data_reg <= {16{last_packet[30]}};
						75: data_reg <= {16{last_packet[29]}};
						76: data_reg <= {16{last_packet[28]}};
						77: data_reg <= {16{last_packet[27]}};
						78: data_reg <= {16{last_packet[26]}};
						79: data_reg <= {16{last_packet[25]}};
						80: data_reg <= {16{last_packet[24]}};
						81: data_reg <= {16{last_packet[23]}};
						82: data_reg <= {16{last_packet[22]}};
						83: data_reg <= {16{last_packet[21]}};
						84: data_reg <= {16{last_packet[20]}};
						85: data_reg <= {16{last_packet[19]}};
						86: data_reg <= {16{last_packet[18]}};
						87: data_reg <= {16{last_packet[17]}};
						88: data_reg <= {16{last_packet[16]}};
						89: data_reg <= {16{last_packet[15]}};
						90: data_reg <= {16{last_packet[14]}};
						91: data_reg <= {16{last_packet[13]}};
						92: data_reg <= {16{last_packet[12]}};
						93: data_reg <= {16{last_packet[11]}};
						94: data_reg <= {16{last_packet[10]}};
						95: data_reg <= {16{last_packet[9]}};
						96: data_reg <= {16{last_packet[8]}};
						97: data_reg <= {16{last_packet[103]}};
						98: data_reg <= {16{last_packet[102]}};
						99: data_reg <= {16{last_packet[101]}};
						100: data_reg <= {16{last_packet[100]}};
						101: data_reg <= {16{last_packet[99]}};
						102: data_reg <= {16{last_packet[98]}};
						103: data_reg <= {16{last_packet[97]}};
						104: data_reg <= {16{last_packet[96]}};
						105: data_reg <= {16{last_packet[95]}};
						106: data_reg <= {16{last_packet[94]}};
						107: data_reg <= {16{last_packet[93]}};
						108: data_reg <= {16{last_packet[92]}};
						109: data_reg <= {16{last_packet[91]}};
						110: data_reg <= {16{last_packet[90]}};
						111: data_reg <= {16{last_packet[89]}};
						112: data_reg <= {16{last_packet[88]}};
						113: data_reg <= {16{last_packet[87]}};
						114: data_reg <= {16{last_packet[86]}};
						115: data_reg <= {16{last_packet[85]}};
						116: data_reg <= {16{last_packet[84]}};
						117: data_reg <= {16{last_packet[83]}};
						118: data_reg <= {16{last_packet[82]}};
						119: data_reg <= {16{last_packet[81]}};
						120: data_reg <= {16{last_packet[80]}};
						121: data_reg <= {16{last_packet[79]}};
						122: data_reg <= {16{last_packet[78]}};
						123: data_reg <= {16{last_packet[77]}};
						124: data_reg <= {16{last_packet[76]}};
						125: data_reg <= {16{last_packet[75]}};
						126: data_reg <= {16{last_packet[74]}};
						127: data_reg <= {16{last_packet[73]}};
						128: data_reg <= {16{last_packet[72]}};
						129: data_reg <= {16{last_packet[71]}};
						130: data_reg <= {16{last_packet[70]}};
						131: data_reg <= {16{last_packet[69]}};
						132: data_reg <= {16{last_packet[68]}};
						133: data_reg <= {16{last_packet[67]}};
						134: data_reg <= {16{last_packet[66]}};
						135: data_reg <= {16{last_packet[65]}};
						136: data_reg <= {16{last_packet[64]}};
						137: data_reg <= {16{last_packet[63]}};
						138: data_reg <= {16{last_packet[62]}};
						139: data_reg <= {16{last_packet[61]}};
						140: data_reg <= {16{last_packet[60]}};
						141: data_reg <= {16{last_packet[59]}};
						142: data_reg <= {16{last_packet[58]}};
						143: data_reg <= {16{last_packet[57]}};
						144: data_reg <= {16{last_packet[56]}};
						145: data_reg <= {16{last_packet[55]}};
						146: data_reg <= {16{last_packet[54]}};
						147: data_reg <= {16{last_packet[53]}};
						148: data_reg <= {16{last_packet[52]}};
						149: data_reg <= {16{last_packet[51]}};
						150: data_reg <= {16{last_packet[50]}};
						151: data_reg <= {16{last_packet[49]}};
						152: data_reg <= {16{last_packet[48]}};
						153: data_reg <= {16{last_packet[47]}};
						154: data_reg <= {16{last_packet[46]}};
						155: data_reg <= {16{last_packet[45]}};
						156: data_reg <= {16{last_packet[44]}};
						157: data_reg <= {16{last_packet[43]}};
						158: data_reg <= {16{last_packet[42]}};
						159: data_reg <= {16{last_packet[41]}};
						160: data_reg <= {16{last_packet[40]}};
						161: data_reg <= {16{last_packet[39]}};
						162: data_reg <= {16{last_packet[38]}};
						163: data_reg <= {16{last_packet[37]}};
						164: data_reg <= {16{last_packet[36]}};
						165: data_reg <= {16{last_packet[35]}};
						166: data_reg <= {16{last_packet[34]}};
						167: data_reg <= {16{last_packet[33]}};
						168: data_reg <= {16{last_packet[32]}};
						169: data_reg <= {16{last_packet[31]}};
						170: data_reg <= {16{last_packet[30]}};
						171: data_reg <= {16{last_packet[29]}};
						172: data_reg <= {16{last_packet[28]}};
						173: data_reg <= {16{last_packet[27]}};
						174: data_reg <= {16{last_packet[26]}};
						175: data_reg <= {16{last_packet[25]}};
						176: data_reg <= {16{last_packet[24]}};
						177: data_reg <= {16{last_packet[23]}};
						178: data_reg <= {16{last_packet[22]}};
						179: data_reg <= {16{last_packet[21]}};
						180: data_reg <= {16{last_packet[20]}};
						181: data_reg <= {16{last_packet[19]}};
						182: data_reg <= {16{last_packet[18]}};
						183: data_reg <= {16{last_packet[17]}};
						184: data_reg <= {16{last_packet[16]}};
						185: data_reg <= {16{last_packet[15]}};
						186: data_reg <= {16{last_packet[14]}};
						187: data_reg <= {16{last_packet[13]}};
						188: data_reg <= {16{last_packet[12]}};
						189: data_reg <= {16{last_packet[11]}};
						190: data_reg <= {16{last_packet[10]}};
						191: data_reg <= {16{last_packet[9]}};
						192: data_reg <= {16{last_packet[8]}};
						
					endcase
				end
				else begin
					we <= 1'b1;
				end
			
			end
			
		endcase
		
		
	end

	//show display when not blanking, 
	//which implies we=1 (not enabled); and use VGA module address
	else
	begin
		lock <= 1'b0; //clear lock if display starts because this destroys mem addr_reg
		addr_reg <= {VGA_X[9:1],VGA_Y[8:0]} ;
		we <= 1'b1;
	end
end

endmodule
