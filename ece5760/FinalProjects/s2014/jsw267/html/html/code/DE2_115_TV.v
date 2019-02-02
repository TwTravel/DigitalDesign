// --------------------------------------------------------------------
// Copyright (c) 2010 by Terasic Technologies Inc. 
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
// Major Functions:	DE2-115 TV_BOX
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Peli Li           :| 03/25/2010:| Initial Revision
//   V2.0 :| Peli Li           :| 04/17/2010:| change the megacore of MAC_3,VGA controller bits num
//   V3.0 :| Rosaline          :| 08/03/2010:| change the TD format support PAL
// --------------------------------------------------------------------

module DE2_115_TV
	(
		//////// CLOCK //////////
		CLOCK_50,
		CLOCK2_50,
		CLOCK3_50,
		ENETCLK_25,

		//////// Sma //////////
		SMA_CLKIN,
		SMA_CLKOUT,

		//////// LED //////////
		LEDG,
		LEDR,

		//////// KEY //////////
		KEY,

		//////// SW //////////
		SW,

		//////// SEG7 //////////
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5,
		HEX6,
		HEX7,

		//////// LCD //////////
		LCD_BLON,
		LCD_DATA,
		LCD_EN,
		LCD_ON,
		LCD_RS,
		LCD_RW,

		//////// RS232 //////////
		UART_CTS,
		UART_RTS,
		UART_RXD,
		UART_TXD,

		//////// PS2 //////////
		PS2_CLK,
		PS2_DAT,
		PS2_CLK2,
		PS2_DAT2,

		//////// SDCARD //////////
		SD_CLK,
		SD_CMD,
		SD_DAT,
		SD_WP_N,

		//////// VGA //////////
		VGA_B,
		VGA_BLANK_N,
		VGA_CLK,
		VGA_G,
		VGA_HS,
		VGA_R,
		VGA_SYNC_N,
		VGA_VS,

		//////// Audio //////////
		AUD_ADCDAT,
		AUD_ADCLRCK,
		AUD_BCLK,
		AUD_DACDAT,
		AUD_DACLRCK,
		AUD_XCK,

		//////// I2C for EEPROM //////////
		EEP_I2C_SCLK,
		EEP_I2C_SDAT,

		//////// I2C for Audio and Tv-Decode //////////
		I2C_SCLK,
		I2C_SDAT,

		//////// Ethernet 0 //////////
		ENET0_GTX_CLK,
		ENET0_INT_N,
		ENET0_MDC,
		ENET0_MDIO,
		ENET0_RST_N,
		ENET0_RX_CLK,
		ENET0_RX_COL,
		ENET0_RX_CRS,
		ENET0_RX_DATA,
		ENET0_RX_DV,
		ENET0_RX_ER,
		ENET0_TX_CLK,
		ENET0_TX_DATA,
		ENET0_TX_EN,
		ENET0_TX_ER,
		ENET0_LINK100,

		//////// Ethernet 1 //////////
		ENET1_GTX_CLK,
		ENET1_INT_N,
		ENET1_MDC,
		ENET1_MDIO,
		ENET1_RST_N,
		ENET1_RX_CLK,
		ENET1_RX_COL,
		ENET1_RX_CRS,
		ENET1_RX_DATA,
		ENET1_RX_DV,
		ENET1_RX_ER,
		ENET1_TX_CLK,
		ENET1_TX_DATA,
		ENET1_TX_EN,
		ENET1_TX_ER,
		ENET1_LINK100,

		//////// TV Decoder //////////
		TD_CLK27,
		TD_DATA,
		TD_HS,
		TD_RESET_N,
		TD_VS,

		/////// USB OTG controller
		OTG_DATA,
		OTG_ADDR,
		OTG_CS_N,
		OTG_WR_N,
		OTG_RD_N,
		OTG_INT,
		OTG_RST_N,
		OTG_DREQ,
		OTG_DACK_N,
		OTG_FSPEED,
		OTG_LSPEED,
		//////// IR Receiver //////////
		IRDA_RXD,

		//////// SDRAM //////////
		DRAM_ADDR,
		DRAM_BA,
		DRAM_CAS_N,
		DRAM_CKE,
		DRAM_CLK,
		DRAM_CS_N,
		DRAM_DQ,
		DRAM_DQM,
		DRAM_RAS_N,
		DRAM_WE_N,

		//////// SRAM //////////
		SRAM_ADDR,
		SRAM_CE_N,
		SRAM_DQ,
		SRAM_LB_N,
		SRAM_OE_N,
		SRAM_UB_N,
		SRAM_WE_N,

		//////// Flash //////////
		FL_ADDR,
		FL_CE_N,
		FL_DQ,
		FL_OE_N,
		FL_RST_N,
		FL_RY,
		FL_WE_N,
		FL_WP_N,

		//////// GPIO //////////
		GPIO,

		//////// EXTEND IO //////////
		EX_IO	
	   
	);

//===========================================================================
// PARAMETER declarations
//===========================================================================


//===========================================================================
// PORT declarations
//===========================================================================
//////////// CLOCK //////////
input		          		CLOCK_50;
input		          		CLOCK2_50;
input		          		CLOCK3_50;
input		          		ENETCLK_25;

//////////// Sma //////////
input		          		SMA_CLKIN;
output		          		SMA_CLKOUT;

//////////// LED //////////
output		     [8:0]		LEDG;
output		    [17:0]		LEDR;

//////////// KEY //////////
input		     [3:0]		KEY;

//////////// SW //////////
input		    [17:0]		SW;

//////////// SEG7 //////////
output		     [6:0]		HEX0;
output		     [6:0]		HEX1;
output		     [6:0]		HEX2;
output		     [6:0]		HEX3;
output		     [6:0]		HEX4;
output		     [6:0]		HEX5;
output		     [6:0]		HEX6;
output		     [6:0]		HEX7;

//////////// LCD //////////
output		          		LCD_BLON;
inout		     [7:0]		LCD_DATA;
output		          		LCD_EN;
output		          		LCD_ON;
output		          		LCD_RS;
output		          		LCD_RW;

//////////// RS232 //////////
output		          		UART_CTS;
input		          		UART_RTS;
input		          		UART_RXD;
output		          		UART_TXD;

//////////// PS2 //////////
inout		          		PS2_CLK;
inout		          		PS2_DAT;
inout		          		PS2_CLK2;
inout		          		PS2_DAT2;

//////////// SDCARD //////////
output		          		SD_CLK;
inout		          		SD_CMD;
inout		     [3:0]		SD_DAT;
input		          		SD_WP_N;

//////////// VGA //////////
output reg	 	     [7:0]		VGA_B;
output		          		VGA_BLANK_N;
output		          		VGA_CLK;
output reg 		     [7:0]		VGA_G;
output		          		VGA_HS;
output reg 		     [7:0]		VGA_R;
output		          		VGA_SYNC_N;
output		          		VGA_VS;

//////////// Audio //////////
input		          		AUD_ADCDAT;
inout		          		AUD_ADCLRCK;
inout		          		AUD_BCLK;
output		          		AUD_DACDAT;
inout		          		AUD_DACLRCK;
output		          		AUD_XCK;

//////////// I2C for EEPROM //////////
output		          		EEP_I2C_SCLK;
inout		          		EEP_I2C_SDAT;

//////////// I2C for Audio and Tv-Decode //////////
output		          		I2C_SCLK;
inout		          		I2C_SDAT;

//////////// Ethernet 0 //////////
output		          		ENET0_GTX_CLK;
input		          		ENET0_INT_N;
output		          		ENET0_MDC;
inout		          		ENET0_MDIO;
output		          		ENET0_RST_N;
input		          		ENET0_RX_CLK;
input		          		ENET0_RX_COL;
input		          		ENET0_RX_CRS;
input		     [3:0]		ENET0_RX_DATA;
input		          		ENET0_RX_DV;
input		          		ENET0_RX_ER;
input		          		ENET0_TX_CLK;
output		     [3:0]		ENET0_TX_DATA;
output		          		ENET0_TX_EN;
output		          		ENET0_TX_ER;
input		          		ENET0_LINK100;

//////////// Ethernet 1 //////////
output		          		ENET1_GTX_CLK;
input		          		ENET1_INT_N;
output		          		ENET1_MDC;
inout		          		ENET1_MDIO;
output		          		ENET1_RST_N;
input		          		ENET1_RX_CLK;
input		          		ENET1_RX_COL;
input		          		ENET1_RX_CRS;
input		     [3:0]		ENET1_RX_DATA;
input		          		ENET1_RX_DV;
input		          		ENET1_RX_ER;
input		          		ENET1_TX_CLK;
output		     [3:0]		ENET1_TX_DATA;
output		          		ENET1_TX_EN;
output		          		ENET1_TX_ER;
input		          		ENET1_LINK100;

//////////// TV Decoder 1 //////////
input		          		TD_CLK27;
input		     [7:0]		TD_DATA;
input		          		TD_HS;
output		          		TD_RESET_N;
input		          		TD_VS;


//////////// USB OTG controller //////////
inout            [15:0]     OTG_DATA;
output           [1:0]      OTG_ADDR;
output                      OTG_CS_N;
output                      OTG_WR_N;
output                      OTG_RD_N;
input            [1:0]      OTG_INT;
output                      OTG_RST_N;
input            [1:0]      OTG_DREQ;
output           [1:0]      OTG_DACK_N;
inout                       OTG_FSPEED;
inout                       OTG_LSPEED;

//////////// IR Receiver //////////
input		          		IRDA_RXD;

//////////// SDRAM //////////
output		    [12:0]		DRAM_ADDR;
output		     [1:0]		DRAM_BA;
output		          		DRAM_CAS_N;
output		          		DRAM_CKE;
output		          		DRAM_CLK;
output		          		DRAM_CS_N;
inout		    [31:0]		DRAM_DQ;
output		     [3:0]		DRAM_DQM;
output		          		DRAM_RAS_N;
output		          		DRAM_WE_N;

//////////// SRAM //////////
output		    [19:0]		SRAM_ADDR;
output		          		SRAM_CE_N;
inout		    [15:0]		SRAM_DQ;
output		          		SRAM_LB_N;
output		          		SRAM_OE_N;
output		          		SRAM_UB_N;
output		          		SRAM_WE_N;

//////////// Flash //////////
output		    [22:0]		FL_ADDR;
output		          		FL_CE_N;
inout		     [7:0]		FL_DQ;
output		          		FL_OE_N;
output		          		FL_RST_N;
input		          		FL_RY;
output		          		FL_WE_N;
output		          		FL_WP_N;

//////////// GPIO //////////
inout		    [35:0]		GPIO;

//////// EXTEND IO //////////
inout		    [6:0]		EX_IO;
///////////////////////////////////////////////////////////////////
//=============================================================================
// REG/WIRE declarations
//=============================================================================
wire reset = ~KEY[0];

wire	CPU_CLK;
wire	CPU_RESET;
wire	CLK_18_4;
wire	CLK_25;

//	For Audio CODEC
//	For Audio Controller
wire			AUD_CTRL_CLK;	

//	For ITU-R 656 Decoder
wire	[15:0]	YCbCr;
wire	[9:0]	TV_X;
wire			TV_DVAL;

//	For VGA Controller
wire	[9:0]	mRed;
wire	[9:0]	mGreen;
wire	[9:0]	mBlue;
wire	[10:0]	VGA_X_d0;
wire	[10:0]	VGA_Y_d0;
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
wire			mDVAL;
wire	[15:0]	m4YCbCr;
wire	[15:0]	m5YCbCr;
wire	[8:0]	Tmp1,Tmp2;
wire	[7:0]	Tmp3,Tmp4;
wire            NTSC;
wire            PAL;

//  VGA Controller
wire 	[7:0] 	Y, Cb_d0, Cr_d0;
wire 	[9:0] 	VGA_R10_d0;
wire 	[9:0] 	VGA_G10_d0;
wire 	[9:0] 	VGA_B10_d0;
wire 		   	VGA_HS_d0, VGA_VS_d0, VGA_SYNC_N_d0, VGA_BLANK_N_d0;
wire 	[21:0] 	VGA_Addr_full_d0;
wire 	[18:0] 	VGA_Addr_d0 = VGA_Addr_full_d0[18:0];

//  Color Detect
wire signed 	[10:0]  top_left_fsm_d6 	[0:1];
wire signed 	[10:0]  top_right_fsm_d6	[0:1];
wire signed 	[10:0]  bot_left_fsm_d6	 	[0:1];
wire signed 	[10:0]  bot_right_fsm_d6	[0:1];
wire signed 	[10:0]  top_left_fsm_d7 	[0:1];
wire signed 	[10:0]  top_right_fsm_d7	[0:1];
wire signed 	[10:0]  bot_left_fsm_d7	 	[0:1];
wire signed 	[10:0]  bot_right_fsm_d7	[0:1];
wire signed 	[10:0]  top_left_fsm_d20	[0:1];
wire signed 	[10:0]  top_right_fsm_d20	[0:1];
wire signed 	[10:0]  bot_left_fsm_d20	[0:1];
wire signed 	[10:0]  bot_right_fsm_d20	[0:1];


//  Color History
wire 	[18:0] 	color_write_addr;
wire 	[3:0] 	color_write_data;
wire       		color_we;
wire 	[18:0] 	color_just_read_addr_d3;
wire 	[3:0] 	color_read_data_d3;
wire 			color_data_valid_d3;
wire 	[9:0] 	color_just_read_x_d3, color_just_read_y_d3;

//  For Delayers
wire  	[7:0]  	VGA_R_d20, VGA_G_d20, VGA_B_d20;
wire 			VGA_VS_d4, VGA_VS_d5, VGA_VS_d6;
wire unsigned 	[10:0] 	VGA_X_d20, VGA_Y_d20;
// wire 	[53:0] 	harris_feature_d5, harris_feature_d20;
wire			median_color_d4;
wire 	     	color_d20;

localparam x  			= 0;
localparam y  			= 1;
localparam threshold_Cb_green = 8'b01111100;
localparam threshold_Cr_green = 8'b01111000;

//=============================================================================
// Structural coding
//=============================================================================

//	Flash
assign	FL_RST_N	=	1'b1;

//	16*2 LCD Module
assign	LCD_ON		=	1'b1;	//	LCD ON
assign	LCD_BLON	=	1'b1;	//	LCD Back Light	

//	All inout port turn to tri-state 
assign	SD_DAT		=	4'b1zzz;  //Set SD Card to SD Mode
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	GPIO	=	36'hzzzzzzzzz;
assign	EX_IO   	=	7'bzzzzzzz;

//	Disable USB speed select
assign	OTG_FSPEED	=	1'bz;
assign	OTG_LSPEED	=	1'bz;

//	Turn On TV Decoder
assign	TD_RESET_N	=	1'b1;
assign	AUD_XCK	=	AUD_CTRL_CLK;

assign	m1VGA_Read	=	VGA_Y_d0[0]		?	1'b0		:	VGA_Read	;
assign	m2VGA_Read	=	VGA_Y_d0[0]		?	VGA_Read	:	1'b0		;
assign	mYCbCr_d	=	!VGA_Y_d0[0]		?	m1YCbCr		:
											      m2YCbCr		;
assign	mYCbCr		=	m5YCbCr;

assign	Tmp1	=	m4YCbCr[7:0]+mYCbCr_d[7:0];
assign	Tmp2	=	m4YCbCr[15:8]+mYCbCr_d[15:8];
assign	Tmp3	=	Tmp1[8:2]+m3YCbCr[7:1];
assign	Tmp4	=	Tmp2[8:2]+m3YCbCr[15:9];
assign	m5YCbCr	=	{Tmp4,Tmp3};

//turn off 7 segment LUT
assign HEX0 = 7'd0;
assign HEX1 = 7'd0;
assign HEX2 = 7'd0;
assign HEX3 = 7'd0;
assign HEX4 = 7'd0;
assign HEX5 = 7'd0;
assign HEX6 = 7'd0;
assign HEX7 = 7'd0;
							
//	TV Decoder Stable Check
TD_Detect			u2	(	.oTD_Stable(TD_Stable),
							.oNTSC(NTSC),
							.oPAL(PAL),
							.iTD_VS(TD_VS),
							.iTD_HS(TD_HS),
							.iRST_N(!reset)	);

//	Reset Delay Timer
Reset_Delay			u3	(	.iCLK(CLOCK_50),
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
							.iCLK_27(TD_CLK27)	);

//	For Down Sample 720 to 640
DIV 				u5	(	.aclr(!DLY0),	
							.clock(TD_CLK27),
							.denom(4'h9),
							.numer(TV_X),
							.quotient(Quotient),
							.remain(Remain));

//	SDRAM frame buffer
Sdram_Control_4Port	u6	(	//	HOST Side
						    .REF_CLK(TD_CLK27),
							.CLK_18(AUD_CTRL_CLK),
						    .RESET_N(DLY0),
							//	FIFO Write Side 1
						    .WR1_DATA(YCbCr),
							.WR1(TV_DVAL),
							.WR1_FULL(WR1_FULL),
							.WR1_ADDR(0),
							.WR1_MAX_ADDR(NTSC ? 640*507 : 640*576),		//	525-18
							.WR1_LENGTH(9'h80),
							.WR1_LOAD(!DLY0),
							.WR1_CLK(TD_CLK27),
							//	FIFO Read Side 1
						    .RD1_DATA(m1YCbCr),
				        	.RD1(m1VGA_Read),
				        	.RD1_ADDR(NTSC ? 640*13 : 640*42),			//	Read odd field and bypess blanking
							.RD1_MAX_ADDR(NTSC ? 640*253 : 640*282),
							.RD1_LENGTH(9'h80),
				        	.RD1_LOAD(!DLY0),
							.RD1_CLK(TD_CLK27),
							//	FIFO Read Side 2
						    .RD2_DATA(m2YCbCr),
				        	.RD2(m2VGA_Read),
				        	.RD2_ADDR(NTSC ? 640*267 : 640*330),			//	Read even field and bypess blanking
							.RD2_MAX_ADDR(NTSC ? 640*507 : 640*570),
							.RD2_LENGTH(9'h80),
				        	.RD2_LOAD(!DLY0),
							.RD2_CLK(TD_CLK27),
							//	SDRAM Side
						    .SA(DRAM_ADDR),
						    .BA(DRAM_BA),
						    .CS_N(DRAM_CS_N),
						    .CKE(DRAM_CKE),
						    .RAS_N(DRAM_RAS_N),
				            .CAS_N(DRAM_CAS_N),
				            .WE_N(DRAM_WE_N),
						    .DQ(DRAM_DQ),
				            .DQM({DRAM_DQM[1],DRAM_DQM[0]}),
							.SDR_CLK(DRAM_CLK)	);

//	YUV 4:2:2 to YUV 4:4:4
YUV422_to_444		u7	(	//	YUV 4:2:2 Input
							.iYCbCr(mYCbCr),
							//	YUV	4:4:4 Output
							.oY(mY),
							.oCb(mCb),
							.oCr(mCr),
							//	Control Signals
							.iX(VGA_X_d0-160),
							.iCLK(TD_CLK27),
							.iRST_N(DLY0));

//	YCbCr 8-bit to RGB-10 bit 
YCbCr2RGB 			u8	(	//	Output Side
							.Red 	(mRed),
							.Green 	(mGreen),
							.Blue 	(mBlue),
							.oDVAL 	(mDVAL),
							.Y_out 	(Y), 
							.Cb_out (Cb_d0), 
							.Cr_out (Cr_d0),
							//	Input Side
							.iY 	(mY),
							.iCb 	(mCb),
							.iCr 	(mCr),
							.iDVAL 	(VGA_Read),
							//	Control Signal
							.iRESET (!DLY2),
							.iCLK 	(TD_CLK27));

VGA_Ctrl	u9	(	
	//	Host Side
	.iRed 		(mRed),
	.iGreen 	(mGreen),
	.iBlue 		(mBlue),
	.oCurrent_X (VGA_X_d0),
	.oCurrent_Y (VGA_Y_d0),
	.oAddress 	(VGA_Addr_full_d0), 
	.oRequest 	(VGA_Read),
	//	VGA Side
	.oVGA_R 	(VGA_R10_d0),
	.oVGA_G 	(VGA_G10_d0),
	.oVGA_B 	(VGA_B10_d0),
	.oVGA_HS 	(VGA_HS_d0),
	.oVGA_VS 	(VGA_VS_d0),
	.oVGA_SYNC 	(VGA_SYNC_N_d0),
	.oVGA_BLANK (VGA_BLANK_N_d0),
	.oVGA_CLOCK (VGA_CLK),
	//	Control Signal
	.iCLK 		(TD_CLK27),
	.iRST_N 	(DLY2)	
);

//---------------------------------Delayers

delay #(.DATA_WIDTH(54), .DELAY(15)) delay_harris_feature
(
	.clk 			(VGA_CLK), 
	.data_in 		(harris_feature_d5), 
	.data_out 		(harris_feature_d20)
);
//Delay the VGA control signals for the VGA Side
delay #( .DATA_WIDTH(4), .DELAY(20) ) delay_vga_ctrl_20
( 
	.clk 		(VGA_CLK), 
	.data_in 	({VGA_HS_d0, VGA_VS_d0, VGA_SYNC_N_d0, VGA_BLANK_N_d0}), 
	.data_out 	({VGA_HS, VGA_VS, VGA_SYNC_N, VGA_BLANK_N})
);
//Delay RGB values
delay #( .DATA_WIDTH(24), .DELAY(20) ) delay_rgb_20
( 
	.clk 		(VGA_CLK), 
	.data_in 	({VGA_R10_d0[9:2], VGA_G10_d0[9:2], VGA_B10_d0[9:2]}), 
	.data_out 	({VGA_R_d20, VGA_G_d20, VGA_B_d20})
);
//Delay the x y just for referencing
delay #( .DATA_WIDTH(22), .DELAY(20) ) delay_x_y_20
( 
	.clk 		(VGA_CLK), 
	.data_in 	({VGA_X_d0,VGA_Y_d0}), 
	.data_out 	({VGA_X_d20, VGA_Y_d20})
); 
delay #( .DATA_WIDTH(1), .DELAY(4) ) vga_vsync_delay4
(
	.clk 		(VGA_CLK), 
	.data_in	(VGA_VS_d0), 
	.data_out   (VGA_VS_d4)
);
delay #( .DATA_WIDTH(1), .DELAY(5) ) vga_vsync_delay5
(
	.clk 		(VGA_CLK), 
	.data_in	(VGA_VS_d0), 
	.data_out   (VGA_VS_d5)
);
delay #( .DATA_WIDTH(1), .DELAY(6) ) vga_vsync_delay6
(
	.clk 		(VGA_CLK), 
	.data_in	(VGA_VS_d0), 
	.data_out   (VGA_VS_d6)
);

delay #( .DATA_WIDTH(1), .DELAY(15) ) time_avg_color_delay
(
	.clk 		(VGA_CLK), 
	.data_in 	(color_d5), 
	.data_out   (color_d20)
);

delay #( .DATA_WIDTH(88), .DELAY(13) ) fsm_corner_delay
(
	.clk 		(VGA_CLK), 
	.data_in 	({	top_left_fsm_d7[x], top_right_fsm_d7[x], 
					bot_left_fsm_d7[x], bot_right_fsm_d7[x],
					top_left_fsm_d7[y], top_right_fsm_d7[y],
					bot_left_fsm_d7[y], bot_right_fsm_d7[y]}), 
	.data_out   ({	top_left_fsm_d20[x], top_right_fsm_d20[x], 
					bot_left_fsm_d20[x], bot_right_fsm_d20[x],
					top_left_fsm_d20[y], top_right_fsm_d20[y],
					bot_left_fsm_d20[y], bot_right_fsm_d20[y]})
);

//---------------------end delayers

harris_corner_detect find_corners(
	.clk 	 	 	(VGA_CLK), 
	.reset 		 	(reset), 
	.ram_clr 	 	(!VGA_VS_d0),
	.VGA_BLANK_N 	(VGA_BLANK_N_d0), 
	.VGA_R 			(VGA_R10_d0[9:2]),
	.VGA_G 			(VGA_G10_d0[9:2]),
	.VGA_B 			(VGA_B10_d0[9:2]),
	.scale 			({2'b00, 2'd0, 4'b1111}),
	.harris_feature (harris_feature_d5)
);

//Read the history of this (x,y) pixel
color_history color_hist (
	.clk 			(VGA_CLK), 
	.reset 			(reset), 
	
	//Address to write new data to SRAM
	.write_addr 	(color_write_addr),  
	.write_data 	(color_write_data), 
	.write_en 		(color_we), 

	//Input of where to read
	.read_x 		(VGA_X_d0), 
	.read_y 		(VGA_Y_d0),
	.read_addr 		(VGA_Addr_d0),

	//Output (delayed by 3) of what was read
	.read_data 		(color_read_data_d3), 
	.data_valid 	(color_data_valid_d3), 
	.just_read_x 	(color_just_read_x_d3), 
	.just_read_y 	(color_just_read_y_d3),
	.just_read_addr (color_just_read_addr_d3)

);

wire median_filter_green_d0 = ((Cb_d0 < threshold_Cb_green) && (Cr_d0 <threshold_Cr_green));
wire median_filter_green_d20;
delay #( .DATA_WIDTH(1), .DELAY(20))  delay_orig_green
( 
	.clk 		(VGA_CLK), 
	.data_in 	(median_filter_green_d0), 
	.data_out 	(median_filter_green_d20)
); 

median_filter median_filter_color_beforetimeavg (
	.clk 				(VGA_CLK), 
	.reset 				(reset), 
	.ram_clr 			(!VGA_VS_d0),
	.VGA_BLANK_N 		(VGA_BLANK_N_d0), 
	.data_in 			(median_filter_green_d0), 
	.data_out 			(median_color_d4)
);

wire [3:0] 	color_read_data_d4;
wire [18:0] color_just_read_addr_d4;
wire [9:0] 	color_just_read_x_d4, color_just_read_y_d4;
wire 	    color_d5;
wire unsigned [18:0] color_count;
wire [9:0] 	color_x_d5, color_y_d5;

//Delay the x y just for referencing
single_delay #( .DATA_WIDTH(44))  delay_for_mf
( 
	.clk 		(VGA_CLK), 
	.data_in 	({color_read_data_d3, color_just_read_addr_d3, 
				color_just_read_x_d3, color_just_read_y_d3}), 
	.data_out 	({color_read_data_d4, color_just_read_addr_d4, 
				color_just_read_x_d4, color_just_read_y_d4})
); 

//inputs are delayed by 4 due to median filtering
//outputs that are not corners delayed by 5
color_detect color_detect (
	//inputs
	.clk 				(VGA_CLK), 
	.reset 				(reset), 
	.VGA_VS 			(VGA_VS_d4),
	.median_color 		(median_color_d4),
	.color_history 		(color_read_data_d4),
	.read_addr 			(color_just_read_addr_d4),
	.read_x 			(color_just_read_x_d4), 
	.read_y 			(color_just_read_y_d4),
	.threshold_history 	(SW[17:16]), 

	//outputs, delays by 
	.color_detected 	(color_d5), 
	.color_count 		(color_count),
	.color_x      		(color_x_d5), 
	.color_y      		(color_y_d5),
	
	//outputs where timing doesn't matter
	.updated_color_history 	(color_write_data), 
	.we 				 	(color_we), 
	.write_addr 		 	(color_write_addr)
);

//delays corners (x,y) by 1
//inputs are delayed by 5 already
wire [9:0] test_x_max, test_x_min, test_y_max, test_y_min;
wire [9:0] test_x_max_ylocalmin, test_x_max_ylocalmax,
		   test_x_min_ylocalmin, test_x_min_ylocalmax,
		   test_y_max_xlocalmin, test_y_max_xlocalmax, 
		   test_y_min_xlocalmin, test_y_min_xlocalmax;
wire unsigned [22:0] scale_dist;

fsm corner_follower (
	.clk 				(VGA_CLK), 
	.reset 				(reset), 
	.VGA_VS 			(VGA_VS_d5), 
	.pixel_valid 		(color_d5), 
	.pixel_x 			({1'b0, color_x_d5}),
	.pixel_y 			({1'b0, color_y_d5}),
	.threshold 			(11'b00000111110), //11'b000 00 1111 10
	.threshold_flip     (11'd0), //not used 
	.offset 			(6'b000111), //6'b000111
	.out_top_left_x 	(top_left_fsm_d6[x]),
    .out_top_left_y 	(top_left_fsm_d6[y]),
    .out_top_right_x 	(top_right_fsm_d6[x]),
    .out_top_right_y 	(top_right_fsm_d6[y]),
    .out_bot_left_x 	(bot_left_fsm_d6[x]),
    .out_bot_left_y 	(bot_left_fsm_d6[y]),
    .out_bot_right_x 	(bot_right_fsm_d6[x]),
    .out_bot_right_y 	(bot_right_fsm_d6[y]),

    //Test wires	
    .state(), 
    .thresh_exceeded_flags(),
    .count(),
    .thresh_flags(), 
    .test_x_max(test_x_max), 
    .test_x_min(test_x_min), 
    .test_y_max(test_y_max),
    .test_y_min(test_y_min), 
    .test_x_max_ylocalmin(test_x_max_ylocalmin),
    .test_x_max_ylocalmax(test_x_max_ylocalmax),
    .test_x_min_ylocalmin(test_x_min_ylocalmin),
    .test_x_min_ylocalmax(test_x_min_ylocalmax),
    .test_y_max_xlocalmin(test_y_max_xlocalmin),
    .test_y_max_xlocalmax(test_y_max_xlocalmax),
    .test_y_min_xlocalmin(test_y_min_xlocalmin),
    .test_y_min_xlocalmax(test_y_min_xlocalmax),
    .corner_flip()
);

median_filter_corner #(
	.p_filter_length(5), 
	.p_bit_width_in(11)
) median_filter_corner(
	.clk(VGA_CLK), 
	.reset(reset),
	.VGA_VS(VGA_VS_d6), 
	.data_in({top_left_fsm_d6[x], top_left_fsm_d6[y], top_right_fsm_d6[x], top_right_fsm_d6[y], 
	bot_left_fsm_d6[x], bot_left_fsm_d6[y], bot_right_fsm_d6[x], bot_right_fsm_d6[y]}), 
	.data_out({top_left_fsm_d7[x], top_left_fsm_d7[y], top_right_fsm_d7[x], top_right_fsm_d7[y], 
	bot_left_fsm_d7[x], bot_left_fsm_d7[y], bot_right_fsm_d7[x], bot_right_fsm_d7[y]})

);

wire [10:0] VGA_X_d15, VGA_Y_d15;
delay #( .DATA_WIDTH(22), .DELAY(15) ) delay_xy
(
	.clk 			(VGA_CLK), 
	.data_in 		({VGA_X_d0, VGA_Y_d0}), 
	.data_out 		({VGA_X_d15, VGA_Y_d15})
);

wire draw_image;
wire [7:0] image_R_d20, image_G_d20, image_B_d20;
wire unsigned [10:0] draw_start_d20 [0:1];
wire unsigned [10:0] draw_end_d20   [0:1]; 
boundary_select bounds(
	//inputs
	.clk 			(VGA_CLK), 
	.reset 			(reset), 
	.SW 			(18'd0),
	.clocktower     (SW[15]),
	.VGA_X      	(VGA_X_d15), 
	.VGA_Y 			(VGA_Y_d15), 
	.top_left_x 	(top_left_fsm_d7[x]),
	.top_left_y 	(top_left_fsm_d7[y]),
	.top_right_x 	(top_right_fsm_d7[x]),
	.top_right_y 	(top_right_fsm_d7[y]),
	.bot_left_x 	(bot_left_fsm_d7[x]),
	.bot_left_y 	(bot_left_fsm_d7[y]),
	.bot_right_x 	(bot_right_fsm_d7[x]),
	.bot_right_y 	(bot_right_fsm_d7[y]),
	//outputs
	.draw_image  	(draw_image), 
	.image_R 		(image_R_d20),
	.image_G 		(image_G_d20),
	.image_B 		(image_B_d20),
	.draw_start_x   (draw_start_d20[x]), 
	.draw_start_y   (draw_start_d20[y]), 
	.draw_end_x		(draw_end_d20[x]), 
	.draw_end_y 	(draw_end_d20[y]), 
	.theta		    (), 
	.scale          ()
);


always @ (*) begin
	case (SW[2:0])
		//Nice Final product
		3'd0: begin
			VGA_R = VGA_R_d20;
			VGA_G = VGA_G_d20;
			VGA_B = VGA_B_d20;
			//If I am within the window where I want to draw
			if (draw_image && color_count > 19'd25) begin
				if (!(image_R_d20 == 8'd43 && image_G_d20 == 8'd213 && image_B_d20 == 8'd55)) begin
					VGA_R = image_R_d20;
					VGA_G = image_G_d20;
					VGA_B = image_B_d20;
				end	
			end
		end

		//How the angle and location of clocktower are being established
		3'd1: begin
			//Red: draw start
			if (VGA_X_d20 < draw_start_d20[x] + 5 && VGA_X_d20 > draw_start_d20[x] - 5
			 && VGA_Y_d20 < draw_start_d20[y] + 5 && VGA_Y_d20 > draw_start_d20[y] - 5) begin
					VGA_R = 8'hFF;
					VGA_G = 8'h00;
					VGA_B = 8'h00;
				end
			//orange: draw end
			else if (VGA_X_d20 < draw_end_d20[x] + 5 && VGA_X_d20 >= draw_end_d20[x] - 5
			 	  && VGA_Y_d20 < draw_end_d20[y] + 5 && VGA_Y_d20 >= draw_end_d20[y] - 5) begin
					VGA_R = 8'h00;
					VGA_G = 8'hFF;
					VGA_B = 8'hFF;
				end
			else begin
				VGA_R = VGA_R_d20;
				VGA_G = VGA_G_d20;
				VGA_B = VGA_B_d20;
			end
			if (draw_image && color_count > 19'd25) begin
				if (!(image_R_d20 == 8'd43 && image_G_d20 == 8'd213 && image_B_d20 == 8'd55)) begin
					VGA_R = image_R_d20;
					VGA_G = image_G_d20;
					VGA_B = image_B_d20;
				end	
			end
			
		end

		//Color and corner detection
		3'd2: begin
			//Red: top left
			if (VGA_X_d20 < top_left_fsm_d20[x] + 5 && VGA_X_d20 >= top_left_fsm_d20[x] - 5
			 && VGA_Y_d20 < top_left_fsm_d20[y] + 5 && VGA_Y_d20 >= top_left_fsm_d20[y] - 5) begin
					VGA_R = 8'hFF;
					VGA_G = 8'h00;
					VGA_B = 8'h00;
				end
			//orange: top right
			else if (VGA_X_d20 < top_right_fsm_d20[x] + 5 && VGA_X_d20 >= top_right_fsm_d20[x] - 5
			 	  && VGA_Y_d20 < top_right_fsm_d20[y] + 5 && VGA_Y_d20 >= top_right_fsm_d20[y] - 5) begin
					VGA_R = 8'hFF;
					VGA_G = 8'd125;
					VGA_B = 8'h00;
				end
			//yellow: bottom left
			else if (VGA_X_d20 < bot_left_fsm_d20[x] + 5 && VGA_X_d20 >= bot_left_fsm_d20[x] - 5
			      && VGA_Y_d20 < bot_left_fsm_d20[y] + 5 && VGA_Y_d20 >= bot_left_fsm_d20[y] - 5) begin
					VGA_R = 8'hFF;
					VGA_G = 8'hFF;
					VGA_B = 8'h00;
				end
			//cyan: bottom right
			else if (VGA_X_d20 < bot_right_fsm_d20[x] + 5 && VGA_X_d20 >= bot_right_fsm_d20[x] - 5
			      && VGA_Y_d20 < bot_right_fsm_d20[y] + 5 && VGA_Y_d20 >= bot_right_fsm_d20[y] - 5) begin
					VGA_R = 8'h00;
					VGA_G = 8'hFF;
					VGA_B = 8'hFF;
				end

			//Green area : pink
			else if (color_d20) begin
				VGA_R = 8'hFF;
				VGA_G = 8'h00;
				VGA_B = 8'hFF;
			end
			
			else begin
				VGA_R = VGA_R_d20;
				VGA_G = VGA_G_d20;
				VGA_B = VGA_B_d20;
			end

			//red
			if(VGA_X_d20 == test_x_max
				&& VGA_Y_d20 >= test_x_max_ylocalmin
				&& VGA_Y_d20 <= test_x_max_ylocalmax ) begin
				VGA_R = 8'hFF;
				VGA_G = 8'h00;
				VGA_B = 8'h00;
			end
			//orange
			else if(VGA_X_d20 == test_x_min 
				&& VGA_Y_d20 >= test_x_min_ylocalmin
				&& VGA_Y_d20 <= test_x_min_ylocalmax ) begin
				VGA_R = 8'hFF;
				VGA_G = 8'd125;
				VGA_B = 8'h00;
			end

			//yellow
			else if (VGA_Y_d20 == test_y_max 
				&& VGA_X_d20 >= test_y_max_xlocalmin
				&& VGA_X_d20 <= test_y_max_xlocalmax ) begin
				VGA_R = 8'hFF;
				VGA_G = 8'hFF;
				VGA_B = 8'h00;
			end
			//cyan
			else if (VGA_Y_d20 == test_y_min 
				&& VGA_X_d20 >= test_y_min_xlocalmin
				&& VGA_X_d20 <= test_y_min_xlocalmax ) begin
				VGA_R = 8'h00;
				VGA_G = 8'hFF;
				VGA_B = 8'hFF;
			end
		end

		//Median filtering
		3'd3: begin
			//red
			if (median_filter_green_d20) begin
				VGA_R = 8'hFF;
				VGA_G = 8'h00;
				VGA_B = 8'hFF;
			end
			else begin
				VGA_R = VGA_R_d20;
				VGA_G = VGA_G_d20;
				VGA_B = VGA_B_d20;
			end
		end


		default: begin
			VGA_R = VGA_R_d20;
			VGA_G = VGA_G_d20;
			VGA_B = VGA_B_d20;
		end
	 endcase
end

//	Line buffer, delay one line
Line_Buffer u10	(	.aclr(!DLY0),
					.clken(VGA_Read),
					.clock(TD_CLK27),
					.shiftin(mYCbCr_d),
					.shiftout(m3YCbCr));

Line_Buffer u11	(	.aclr(!DLY0),
					.clken(VGA_Read),
					.clock(TD_CLK27),
					.shiftin(m3YCbCr),
					.shiftout(m4YCbCr));

AUDIO_DAC 	u12	(	//	Audio Side
					.oAUD_BCK(AUD_BCLK),
					.oAUD_DATA(AUD_DACDAT),
					.oAUD_LRCK(AUD_DACLRCK),
					//	Control Signals
					.iSrc_Select(2'b01),
			        .iCLK_18_4(AUD_CTRL_CLK),
					.iRST_N(DLY1)	);

//	Audio CODEC and video decoder setting
I2C_AV_Config 	u1	(	//	Host Side
						.iCLK(CLOCK_50),
						.iRST_N(!reset),
						//	I2C Side
						.I2C_SCLK(I2C_SCLK),
						.I2C_SDAT(I2C_SDAT)	);	



endmodule

