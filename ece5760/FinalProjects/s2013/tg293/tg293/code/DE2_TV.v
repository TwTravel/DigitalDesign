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
// Major Functions:  DE2 TV Box
// --------------------------------------------------------------------

module DE2_TV
(
  // Clock Input      
  input         OSC_27,    //  27 MHz
  input         OSC_50,    //  50 MHz
  input         EXT_CLOCK,   //  External Clock
  // Push Button   
  input   [3:0] KEY,         //  Button[3:0]
  // DPDT DPDT_SWitch   
  input  [17:0] DPDT_SW,          //  DPDT DPDT_SWitch[17:0]
  // 7-SEG Dispaly 
  output  [6:0] HEX0,        //  Seven Segment Digital 0
  output  [6:0] HEX1,        //  Seven Segment Digital 1
  output  [6:0] HEX2,        //  Seven Segment Digital 2
  output  [6:0] HEX3,        //  Seven Segment Digital 3
  output  [6:0] HEX4,        //  Seven Segment Digital 4
  output  [6:0] HEX5,        //  Seven Segment Digital 5
  output  [6:0] HEX6,        //  Seven Segment Digital 6
  output  [6:0] HEX7,        //  Seven Segment Digital 7
  // LED  
  output  [8:0] LED_GREEN,   //  LED Green[8:0]
  output [17:0] LED_RED,     //  LED Red[17:0]
  // UART 
  output        UART_TXD,    //  UART Transmitter
  input         UART_RXD,    //  UART Receiver
  // IRDA
  output        IRDA_TXD,    //  IRDA Transmitter
  input         IRDA_RXD,    //  IRDA Receiver
  // SDRAM Interface  
  inout  [15:0] DRAM_DQ,     //  SDRAM Data bus 16 Bits
  output [11:0] DRAM_ADDR,   //  SDRAM Address bus 12 Bits
  output        DRAM_LDQM,   //  SDRAM Low-byte Data Mask 
  output        DRAM_UDQM,   //  SDRAM High-byte Data Mask
  output        DRAM_WE_N,   //  SDRAM Write Enable
  output        DRAM_CAS_N,  //  SDRAM Column Address Strobe
  output        DRAM_RAS_N,  //  SDRAM Row Address Strobe
  output        DRAM_CS_N,   //  SDRAM Chip Select
  output        DRAM_BA_0,   //  SDRAM Bank Address 0
  output        DRAM_BA_1,   //  SDRAM Bank Address 0
  output        DRAM_CLK,    //  SDRAM Clock
  output        DRAM_CKE,    //  SDRAM Clock Enable
  // Flash Interface  
  inout   [7:0] FL_DQ,       //  FLASH Data bus 8 Bits
  output [21:0] FL_ADDR,     //  FLASH Address bus 22 Bits
  output        FL_WE_N,     //  FLASH Write Enable
  output        FL_RST_N,    //  FLASH Reset
  output        FL_OE_N,     //  FLASH Output Enable
  output        FL_CE_N,     //  FLASH Chip Enable
  // SRAM Interface  
  inout  [15:0] SRAM_DQ,     //  SRAM Data bus 16 Bits
  output [17:0] SRAM_ADDR,   //  SRAM Adress bus 18 Bits
  output        SRAM_UB_N,   //  SRAM High-byte Data Mask 
  output        SRAM_LB_N,   //  SRAM Low-byte Data Mask 
  output        SRAM_WE_N,   //  SRAM Write Enable
  output        SRAM_CE_N,   //  SRAM Chip Enable
  output        SRAM_OE_N,   //  SRAM Output Enable
  // ISP1362 Interface 
  inout  [15:0] OTG_DATA,    //  ISP1362 Data bus 16 Bits
  output  [1:0] OTG_ADDR,    //  ISP1362 Address 2 Bits
  output        OTG_CS_N,    //  ISP1362 Chip Select
  output        OTG_RD_N,    //  ISP1362 Write
  output        OTG_WR_N,    //  ISP1362 Read
  output        OTG_RST_N,   //  ISP1362 Reset
  output        OTG_FSPEED,  //  USB Full Speed,  0 = Enable, Z = Disable
  output        OTG_LSPEED,  //  USB Low Speed,   0 = Enable, Z = Disable
  input         OTG_INT0,    //  ISP1362 Interrupt 0
  input         OTG_INT1,    //  ISP1362 Interrupt 1
  input         OTG_DREQ0,   //  ISP1362 DMA Request 0
  input         OTG_DREQ1,   //  ISP1362 DMA Request 1
  output        OTG_DACK0_N, //  ISP1362 DMA Acknowledge 0
  output        OTG_DACK1_N, //  ISP1362 DMA Acknowledge 1
  // LCD Module 16X2   
  output        LCD_ON,      //  LCD Power ON/OFF
  output        LCD_BLON,    //  LCD Back Light ON/OFF
  output        LCD_RW,      //  LCD Read/Write Select, 0 = Write, 1 = Read
  output        LCD_EN,      //  LCD Enable
  output        LCD_RS,      //  LCD Command/Data Select, 0 = Command, 1 = Data
  inout   [7:0] LCD_DATA,    //  LCD Data bus 8 bits
  // SD_Card Interface 
  inout         SD_DAT,      //  SD Card Data
  inout         SD_DAT3,     //  SD Card Data 3
  inout         SD_CMD,      //  SD Card Command Signal
  output        SD_CLK,      //  SD Card Clock
  // USB JTAG link  
  input         TDI,         // CPLD -> FPGA (data in)
  input         TCK,         // CPLD -> FPGA (clk)
  input         TCS,         // CPLD -> FPGA (CS)
  output        TDO,         // FPGA -> CPLD (data out)
  // I2C    
  inout         I2C_SDAT,    //  I2C Data
  output        I2C_SCLK,    //  I2C Clock
  // PS2   
  input         PS2_DAT,     //  PS2 Data
  input         PS2_CLK,     //  PS2 Clock
  // VGA   
  output        VGA_CLK,     //  VGA Clock
  output        VGA_HS,      //  VGA H_SYNC
  output        VGA_VS,      //  VGA V_SYNC
  output        VGA_BLANK,   //  VGA BLANK
  output        VGA_SYNC,    //  VGA SYNC
  output  [9:0] VGA_R,       //  VGA Red[9:0]
  output  [9:0] VGA_G,       //  VGA Green[9:0]
  output  [9:0] VGA_B,       //  VGA Blue[9:0]
  // Ethernet Interface 
  inout  [15:0] ENET_DATA,   //  DM9000A DATA bus 16Bits
  output        ENET_CMD,    //  DM9000A Command/Data Select, 0 = Command, 1 = Data
  output        ENET_CS_N,   //  DM9000A Chip Select
  output        ENET_WR_N,   //  DM9000A Write
  output        ENET_RD_N,   //  DM9000A Read
  output        ENET_RST_N,  //  DM9000A Reset
  input         ENET_INT,    //  DM9000A Interrupt
  output        ENET_CLK,    //  DM9000A Clock 25 MHz
  // Audio CODEC 
  inout         AUD_ADCLRCK, //  Audio CODEC ADC LR Clock
  input         AUD_ADCDAT,  //  Audio CODEC ADC Data
  inout         AUD_DACLRCK, //  Audio CODEC DAC LR Clock
  output        AUD_DACDAT,  //  Audio CODEC DAC Data
  inout         AUD_BCLK,    //  Audio CODEC Bit-Stream Clock
  output        AUD_XCK,     //  Audio CODEC Chip Clock
  // TV Decoder  
  input   [7:0] TD_DATA,     //  TV Decoder Data bus 8 bits
  input         TD_HS,       //  TV Decoder H_SYNC
  input         TD_VS,       //  TV Decoder V_SYNC
  output        TD_RESET,    //  TV Decoder Reset
  input         TD_CLK,      //  TV Decoder Line Locked Clock
  // GPIO  
  inout  [35:0] GPIO_0,      //  GPIO Connection 0
  inout  [35:0] GPIO_1       //  GPIO Connection 1
);
	// SRAM Stuff
	reg R_W;
	reg [17:0] addr_reg;
	reg [15:0] data_reg; //memory data register  for SRAM
	reg we ;		//write enable for SRAM
	// SRAM_control
	assign SRAM_ADDR = addr_reg;
	assign SRAM_DQ = (we)? 16'hzzzz : data_reg ;
	assign SRAM_UB_N = 0;					// hi byte select enabled
	assign SRAM_LB_N = 0;					// lo byte select enabled
	assign SRAM_CE_N = 0;					// chip is enabled
	assign SRAM_WE_N = we;					// write when ZERO
	assign SRAM_OE_N = 0;					//output enable is overidden by WE


  //  For Audio CODEC
  wire  AUD_CTRL_CLK;  //  For Audio Controller
  assign  AUD_XCK = AUD_CTRL_CLK;

  //  7 segment LUT
  SEG7_LUT_8 u0 
  (
    .oSEG0  (HEX0),
    .oSEG1  (HEX1),
    .oSEG2  (HEX2),
    .oSEG3  (HEX3),
    .oSEG4  (HEX4),
    .oSEG5  (HEX5),
    .oSEG6  (HEX6),
    .oSEG7  (HEX7),
    .iDIG   ({Game_Score_2,Game_Score_1,Game_Time_4,Game_Time_3,Game_Time_2,Game_Time_1}) 
  );

  // Audio CODEC and video decoder setting
  I2C_AV_Config u1  
  (  //  Host Side
    .iCLK     (OSC_50),
    .iRST_N   (KEY[0]),
    //  I2C Side
    .I2C_SCLK (I2C_SCLK),
    .I2C_SDAT (I2C_SDAT)  
  );

  //  TV Decoder Stable Check
  TD_Detect u2 
  (  
    .oTD_Stable (TD_Stable),
    .iTD_VS     (TD_VS),
    .iTD_HS     (TD_HS),
    .iRST_N     (KEY[0])  
  );

  //  Reset Delay Timer
  Reset_Delay u3 
  (  
    .iCLK   (OSC_50),
    .iRST   (TD_Stable),
    .oRST_0 (DLY0),
    .oRST_1 (DLY1),
    .oRST_2 (DLY2)
  );

  //  ITU-R 656 to YUV 4:2:2
  ITU_656_Decoder u4 
  (  //  TV Decoder Input
    .iTD_DATA   (TD_DATA),
    //  Position Output
    .oTV_X      (TV_X),
    //.oTV_Y(TV_Y),
    //  YUV 4:2:2 Output
    .oYCbCr     (YCbCr),
    .oDVAL      (TV_DVAL),
    //  Control Signals
    .iSwap_CbCr (Quotient[0]),
    .iSkip      (Remain==4'h0),
    .iRST_N     (DLY1),
    .iCLK_27    (TD_CLK)  
  );

  //  For Down Sample 720 to 640
  DIV u5  
  (  
    .aclr     (!DLY0), 
    .clock    (TD_CLK),
    .denom    (4'h9),
    .numer    (TV_X),
    .quotient (Quotient),
    .remain   (Remain)
  );

  //  SDRAM frame buffer
  Sdram_Control_4Port u6  
  (  //  HOST Side
    .REF_CLK      (OSC_27),
    .CLK_18       (AUD_CTRL_CLK),
    .RESET_N      (1'b1),
    //  FIFO Write Side 1
    .WR1_DATA     (YCbCr),
    .WR1          (TV_DVAL),
    .WR1_FULL     (WR1_FULL),
    .WR1_ADDR     (0),
    .WR1_MAX_ADDR (640*507),    //  525-18
    .WR1_LENGTH   (9'h80),
    .WR1_LOAD     (!DLY0),
    .WR1_CLK      (TD_CLK),
    //  FIFO Read Side 1
    .RD1_DATA     (m1YCbCr),
    .RD1          (m1VGA_Read),
    .RD1_ADDR     (640*13),      //  Read odd field and bypess blanking
    .RD1_MAX_ADDR (640*253),
    .RD1_LENGTH   (9'h80),
    .RD1_LOAD     (!DLY0),
    .RD1_CLK      (OSC_27),
    //  FIFO Read Side 2
    .RD2_DATA     (m2YCbCr),
    .RD2          (m2VGA_Read),
    .RD2_ADDR     (640*267),      //  Read even field and bypess blanking
    .RD2_MAX_ADDR (640*507),
    .RD2_LENGTH   (9'h80),
    .RD2_LOAD     (!DLY0),
    .RD2_CLK      (OSC_27),
    //  SDRAM Side
    .SA           (DRAM_ADDR),
    .BA           ({DRAM_BA_1,DRAM_BA_0}),
    .CS_N         (DRAM_CS_N),
    .CKE          (DRAM_CKE),
    .RAS_N        (DRAM_RAS_N),
    .CAS_N        (DRAM_CAS_N),
    .WE_N         (DRAM_WE_N),
    .DQ           (DRAM_DQ),
    .DQM          ({DRAM_UDQM,DRAM_LDQM}),
    .SDR_CLK      (DRAM_CLK)  
  );

  //  YUV 4:2:2 to YUV 4:4:4
  YUV422_to_444 u7 
  (  //  YUV 4:2:2 Input
    .iYCbCr   (mYCbCr),
    //  YUV  4:4:4 Output
    .oY       (mY),
    .oCb      (mCb),
    .oCr      (mCr),
    //  Control Signals
    .iX       (VGA_X),
    .iCLK     (OSC_27),
    .iRST_N   (DLY0)
  );

  //  YCbCr 8-bit to RGB-10 bit 
  YCbCr2RGB u8 
  (  //  Output Side
    .Red      (mRed),
    .Green    (mGreen),
    .Blue     (mBlue),
    .oDVAL    (mDVAL),
    //  Input Side
    .iY       (BeforeRGB_Y),
    .iCb      (BeforeRGB_Cb),
    .iCr      (BeforeRGB_Cr),
    .iDVAL    (VGA_Read),
    //  Control Signal
    .iRESET   (!DLY2),
    .iCLK     (OSC_27)
  );

  // Comment out this module if you don't want the mirror effect
	Mirror_Col u100  
	(  //  Input Side
		.iCCD_R       (mRed),
		.iCCD_G       (mGreen),
		.iCCD_B       (mBlue),
		.iCCD_DVAL    (mDVAL),
		.iCCD_PIXCLK  (VGA_CLK), //(TD_CLK),
		.iRST_N       (DLY2),
		//  Output Side
		.oCCD_R       (Red),
		.oCCD_G       (Green),
		.oCCD_B       (Blue)//,
    //.oCCD_DVAL(TV_DVAL));
	);

  //VGA Controller
	VGA_Ctrl u9 
	(  //  Host Side
		.iRed       (mVGA_R), 
		.iGreen     (mVGA_G),
		.iBlue      (mVGA_B), 
		.oCurrent_X (VGA_X),
		.oCurrent_Y (VGA_Y),
		.oRequest   (VGA_Read),
		//  VGA Side
		.oVGA_R     (VGA_R),
		.oVGA_G     (VGA_G),
		.oVGA_B     (VGA_B),
		.oVGA_HS    (VGA_HS),
		.oVGA_VS    (VGA_VS),
		.oVGA_SYNC  (VGA_SYNC),
		.oVGA_BLANK (VGA_BLANK),
		.oVGA_CLOCK (VGA_CLK),
		//  Control Signal
		.iCLK       (OSC_27), // 27 MHz clock
		.iRST_N     (DLY2)  
	);
    
	wire [9:0]  mVGA_R;
	wire [9:0]  mVGA_G;
	wire [9:0]  mVGA_B;
	wire [9:0] Red, Green, Blue;

	// Check RGB value of a pixel in the background image in ROM memory.
	// If it's 0, black, get RGB value from the camcorder; 
	// otherwise print white lines and letters on the screen
	// To get grayscale, replace the next three lines with the commented-out lines
	assign  mVGA_R = Red;//( Red >> 2 ) + ( Green >> 1 ) + ( Blue >> 3 );
	assign  mVGA_G = Green;//( Red >> 2 ) + ( Green >> 1 ) + ( Blue >> 3 );
	assign  mVGA_B = Blue;//( Red >> 2 ) + ( Green >> 1 ) + ( Blue >> 3 );

	//  For ITU-R 656 Decoder
	wire  [15:0] YCbCr;
	wire  [9:0]  TV_X;
	wire         TV_DVAL;

  //  For VGA Controller
	wire  [9:0]  mRed;
	wire  [9:0]  mGreen;
	wire  [9:0]  mBlue;
	wire  [10:0] VGA_X;
	wire  [10:0] VGA_Y;
	wire  VGA_Read;  //  VGA data request
	wire  m1VGA_Read;  //  Read odd field
	wire  m2VGA_Read;  //  Read even field

	//  For YUV 4:2:2 to YUV 4:4:4
	wire  [7:0]  mY,BeforeRGB_Y;
	wire  [7:0]  mCb,BeforeRGB_Cb;
	wire  [7:0]  mCr,BeforeRGB_Cr;

	//  For field select
	wire  [15:0]  mYCbCr;
	wire  [15:0]  mYCbCr_d;
	wire  [15:0]  m1YCbCr;
	wire  [15:0]  m2YCbCr;
	wire  [15:0]  m3YCbCr;

	//  For Delay Timer
	wire      TD_Stable;
	wire      DLY0;
	wire      DLY1;
	wire      DLY2;

	//  For Down Sample
	wire  [3:0]  Remain;
	wire  [9:0]  Quotient;

   assign  m1VGA_Read =  VGA_Y[0]  ?  1'b0     :  VGA_Read;
   assign  m2VGA_Read =  VGA_Y[0]  ?  VGA_Read :  1'b0;
   assign  mYCbCr_d   =  !VGA_Y[0] ?  m1YCbCr  :  m2YCbCr;
   assign  mYCbCr     =  m5YCbCr;

   wire      mDVAL;
	reg [7:0]MiddleCr,MiddleCb;
	reg [4:0]VGA_Counter;
	wire [4:0]CbRange,CrRange;
	reg [79:0] Skin_Binary [59:0];	//binary 80*60 skin detection
	reg [15:0]Skin_Binary_Temp ;	//temporary for skindetection
	reg [6:0] Skin_B_X;
	reg [5:0] Skin_B_Y;
	reg [3:0] Skin_Counter;
	reg [2:0] Frame_Counter;
	reg Frame_CLK;
	reg Hand_Push_L,Hand_Push_R,Hand_Push_L_Temp,Hand_Push_R_Temp;
	assign CbRange = DPDT_SW[17:13];
	assign CrRange = DPDT_SW[4:0];
	
	wire VGA_RH_LR,VGA_RH_TB,VGA_LH_LR,VGA_LH_TB;
	wire VGA_RH_Cursor,VGA_LH_Cursor;
	assign VGA_RH_Cursor = ((VGA_X[9:2] == RHPosition_X) && (VGA_Y[8:2] + 2'd2 >= RHPosition_Y) && (VGA_Y[8:2] <= RHPosition_Y + 2'd2)) || ((VGA_Y[8:2] == RHPosition_Y) && (VGA_X[9:2] + 2'd2 >= RHPosition_X) && (VGA_X[9:2] <= RHPosition_X + 2'd2));
	assign VGA_LH_Cursor = ((VGA_X[9:2] == LHPosition_X) && (VGA_Y[8:2] + 2'd2 >= LHPosition_Y) && (VGA_Y[8:2] <= LHPosition_Y + 2'd2)) || ((VGA_Y[8:2] == LHPosition_Y) && (VGA_X[9:2] + 2'd2 >= LHPosition_X) && (VGA_X[9:2] <= LHPosition_X + 2'd2));
	assign VGA_RH_LR = (VGA_X[9:2] == RHLEFT_X || VGA_X[9:2] == RHRIGHT_X);
	assign VGA_RH_TB = (VGA_Y[8:2] == RHTOP_Y || VGA_Y[8:2] == RHBOT_Y);
	assign VGA_LH_LR = (VGA_X[9:2] == LHLEFT_X || VGA_X[9:2] == LHRIGHT_X);
	assign VGA_LH_TB = (VGA_Y[8:2] == LHTOP_Y || VGA_Y[8:2] == LHBOT_Y);
	wire IsSkin;
	assign IsSkin = (mCb >= 8'd80 && mCb <= 8'd120) && (mCr >= 8'd131 && mCr <= 8'd175); // 80-120 133-173
	wire IsSkinForOutput;
	assign IsSkinForOutput = (Skin_Binary_Temp[7]);

	//reg [79:0]IsSkinInReg;
	//assign IsSkinInReg = Skin_Binary[VGA_Y[9:3]][VGA_X[8:3]];
	//assign IsSkin = (mCb - MiddleCb < CbRange || MiddleCb - mCb < CbRange) && (mCr - MiddleCr < CrRange || MiddleCr - mCr < CrRange);
	//assign IsSkin = 1'b1;
	
	assign LED_RED[1:0] = {Hand_Push_L,Hand_Push_R};
	
	always @ (posedge OSC_27)
	begin
		if (!DLY2)	//reset
		begin
			Skin_Binary[Skin_B_Y] <= 80'b0;
			LHPosition_X <= LH_X_INIT;
			LHTOP_X <= LH_X_INIT;
			LHBOT_X <= LH_X_INIT;
			LHLEFT_X <= LH_X_INIT;
			LHRIGHT_X <= LH_X_INIT;
			LHPosition_Y <= LH_Y_INIT;
			LHTOP_Y <= LH_Y_INIT;
			LHBOT_Y <= LH_Y_INIT;
			LHLEFT_Y <= LH_Y_INIT;
			LHRIGHT_Y <= LH_Y_INIT;
			RHPosition_X <= RH_X_INIT;
			RHTOP_X <= RH_X_INIT;
			RHBOT_X <= RH_X_INIT;
			RHLEFT_X <= RH_X_INIT;
			RHRIGHT_X <= RH_X_INIT;
			RHPosition_Y <= RH_Y_INIT;
			RHTOP_Y <= RH_Y_INIT;
			RHBOT_Y <= RH_Y_INIT;
			RHLEFT_Y <= RH_Y_INIT;
			RHRIGHT_Y <= RH_Y_INIT;
			NewFrame = 1'b0;
			Frame_Counter <= 3'b0;
			ContinueFlag = 1'b0;
			Hand_Push_L <= 1'b0;
			Hand_Push_L_Temp <= 1'b0;
			Hand_Push_R <= 1'b0;
			Hand_Push_R_Temp <= 1'b0;
		end
		else if (~VGA_VS | ~VGA_HS)	//Looking For a Hand
		begin
			case (HandState)
				0: 	//Stop state LHPosition read
				begin
					if (NewFrame)		//Refresh Every New Frame
					begin
						HandState <= 1; 
						we <= 1'b1;
						addr_reg <= {LHPosition_X,LHPosition_Y};
						NewFrame <= 1'b0;
						ContinueFlag <= 1'b0;						
					end
				end
				1:		//Stop state LHPosition Judge
				begin
					if (SRAM_DQ[7] == 1'b1) //if LHP is skin
					begin
						HandState <= 2;	//goto judge LH TOP
						we <= 1'b1;
						addr_reg <= {LHPosition_X,LHPosition_Y};
						TEMP_POSITION_X <= LHPosition_X ;
						TEMP_POSITION_Y <= LHPosition_Y ;
						Hand_Push_L_Temp <= 1'b1;		//assume hand pushes
						Hand_Push_L <= Hand_Push_L_Temp;	//Copy temp value to handpush
					end
					else
					begin
						we <= 1'b1;
						addr_reg <= {RHPosition_X,RHPosition_Y};
						ContinueFlag <= 1'b0;	
						HandState <= 7;	//goto RH
						Hand_Push_L <= 0;
					end
				end
				2:		//LHTOP_Y 
				begin
					if (SRAM_DQ[7] == 1'b1 && TEMP_POSITION_Y>=7'd2)		//if TOP is skin, continue go
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_Y <= TEMP_POSITION_Y - 1'b1;
						ContinueFlag <= 1'b0;
						HandState <= 2;
					end
					else if (ContinueFlag == 1'b0)	//For 2 serial non-skin, judge as non skin
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_Y <= TEMP_POSITION_Y - 1'b1;
						ContinueFlag = 1'b1;
						HandState <= 2;
					end
					else //not skin or reach the top line, record LHTOP,goto LHBOT
					begin
						LHTOP_Y <= TEMP_POSITION_Y;
						if (TEMP_POSITION_Y + 2'd2 >= LHTOP_Y)	//if move down, not push
						begin
							Hand_Push_L_Temp <= 1'b0;
						end
						we <= 1'b1;
						addr_reg <= {LHPosition_X,LHPosition_Y};
						TEMP_POSITION_X <= LHPosition_X ;
						TEMP_POSITION_Y <= LHPosition_Y ;
						ContinueFlag <= 1'b0;	
						HandState <= 3;
					end
				end
				3:		//LHBOT_Y 
				begin
					if (SRAM_DQ[7] == 1'b1 && TEMP_POSITION_Y<=7'd117)		//if BOT is skin, continue go
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_Y <= TEMP_POSITION_Y + 1'b1;
						ContinueFlag <= 1'b0;
						HandState <= 3;
					end
					else if (ContinueFlag == 1'b0)
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_Y <= TEMP_POSITION_Y + 1'b1;
						ContinueFlag <= 1'b1;
						HandState <= 3;
					end
					else //not skin or reach the bot line, record LHBOT,goto LHLFET
					begin
						LHBOT_Y <= TEMP_POSITION_Y;
						if (TEMP_POSITION_Y - 2'd2 <= LHBOT_Y)	//if move up, not push
						begin
							Hand_Push_L_Temp <= 1'b0;
						end
						we <= 1'b1;
						addr_reg <= {LHPosition_X,LHPosition_Y};
						TEMP_POSITION_X <= LHPosition_X ;
						TEMP_POSITION_Y <= LHPosition_Y ;
						ContinueFlag <= 1'b0;	
						HandState <= 4;
					end
				end
				4:		//LHLEFT_X (mirrored!)
				begin
					if (SRAM_DQ[7] == 1'b1 && TEMP_POSITION_X<=157)		//if LEFT is skin, continue go
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_X <= TEMP_POSITION_X + 1'b1;
						ContinueFlag <= 1'b0;
						HandState <= 4;
					end
					else if (ContinueFlag == 1'b0)
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_X <= TEMP_POSITION_X + 1'b1;
						ContinueFlag <= 1'b1;
						HandState <= 4;
					end
					else //not skin or reach the left line, record LHLFET,goto LHRIGHT
					begin
						LHLEFT_X <= TEMP_POSITION_X;
						we <= 1'b1;
						addr_reg <= {LHPosition_X,LHPosition_Y};
						TEMP_POSITION_X <= LHPosition_X ;
						TEMP_POSITION_Y <= LHPosition_Y ;
						ContinueFlag <= 1'b0;	
						HandState <= 5;
					end
				end
				5:		//LHRIGHT_X (mirrored!)
				begin
					if (SRAM_DQ[7] == 1'b1 && TEMP_POSITION_X>=80)		//if RIGHT is skin, continue go
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_X <= TEMP_POSITION_X - 1'b1;
						ContinueFlag <= 1'b0;
						HandState <= 5;
					end
					else if (ContinueFlag == 1'b0)
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_X <= TEMP_POSITION_X - 1'b1;
						ContinueFlag <= 1'b1;
						HandState <= 5;
					end
					else //not skin or reach the right line, record LHRIGHT,goto Refresh LH
					begin
						LHRIGHT_X <= TEMP_POSITION_X;
						we <= 1'b1;
						addr_reg <= {LHPosition_X,LHPosition_Y};
						TEMP_POSITION_X <= LHPosition_X ;
						TEMP_POSITION_Y <= LHPosition_Y ;
						ContinueFlag <= 1'b0;	
						HandState <= 6;
					end
				end
				6:		//Refresh LH and Goto RH
				begin
					LHPosition_X = (LHLEFT_X >> 1) + (LHRIGHT_X >> 1) + 1'b1;
					LHPosition_Y = (LHTOP_Y >> 1) + (LHBOT_Y >> 1) + 1'b1;
					HandState <= 7;
					we <= 1'b1;
					addr_reg <= {RHPosition_X,RHPosition_Y};
					ContinueFlag <= 1'b0;	
				end
				7:		//Stop state LHPosition Judge
				begin
					if (SRAM_DQ[7] == 1'b1) //if RHP is skin
					begin
						HandState <= 8;	//goto judge RH TOP
						we <= 1'b1;
						addr_reg <= {RHPosition_X,RHPosition_Y};
						TEMP_POSITION_X <= RHPosition_X ;
						TEMP_POSITION_Y <= RHPosition_Y ;
						Hand_Push_R_Temp <= 1'b1;		//assume hand pushes
						Hand_Push_R <= Hand_Push_R_Temp;	//Copy temp value to handpush
					end
					else
					begin
						HandState <= 0;	//goto STOP
						Hand_Push_R <= 0;
					end
				end
				8:		//RHTOP_Y 
				begin
					if (SRAM_DQ[7] == 1'b1 && TEMP_POSITION_Y>=7'd2)		//if TOP is skin, continue go
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_Y <= TEMP_POSITION_Y - 1'b1;
						ContinueFlag <= 1'b0;
						HandState <= 8;
					end
					else if (ContinueFlag == 1'b0)	//For 2 serial non-skin, judge as non skin
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_Y <= TEMP_POSITION_Y - 1'b1;
						ContinueFlag = 1'b1;
						HandState <= 8;
					end
					else //not skin or reach the top line, record LHTOP,goto LHBOT
					begin
						RHTOP_Y <= TEMP_POSITION_Y;
						if (TEMP_POSITION_Y + 2'd2 >= RHTOP_Y)	//if move down, not push
						begin
							Hand_Push_R_Temp <= 1'b0;
						end
						we <= 1'b1;
						addr_reg <= {RHPosition_X,RHPosition_Y};
						TEMP_POSITION_X <= RHPosition_X ;
						TEMP_POSITION_Y <= RHPosition_Y ;
						ContinueFlag <= 1'b0;	
						HandState <= 9;
					end
				end
				9:		//RHBOT_Y 
				begin
					if (SRAM_DQ[7] == 1'b1 && TEMP_POSITION_Y<=7'd117)		//if BOT is skin, continue go
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_Y <= TEMP_POSITION_Y + 1'b1;
						ContinueFlag <= 1'b0;
						HandState <= 9;
					end
					else if (ContinueFlag == 1'b0)
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_Y <= TEMP_POSITION_Y + 1'b1;
						ContinueFlag <= 1'b1;
						HandState <= 9;
					end
					else //not skin or reach the bot line, record LHBOT,goto LHLFET
					begin
						RHBOT_Y <= TEMP_POSITION_Y;
						if (TEMP_POSITION_Y - 2'd2 <= RHBOT_Y)	//if move up, not push
						begin
							Hand_Push_R_Temp <= 1'b0;
						end
						we <= 1'b1;
						addr_reg <= {RHPosition_X,RHPosition_Y};
						TEMP_POSITION_X <= RHPosition_X ;
						TEMP_POSITION_Y <= RHPosition_Y ;
						ContinueFlag <= 1'b0;	
						HandState <= 10;
					end
				end
				10:		//LHLEFT_X (mirrored!)
				begin
					if (SRAM_DQ[7] == 1'b1 && TEMP_POSITION_X<=79)		//if LEFT is skin, continue go
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_X <= TEMP_POSITION_X + 1'b1;
						ContinueFlag <= 1'b0;
						HandState <= 10;
					end
					else if (ContinueFlag == 1'b0)
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_X <= TEMP_POSITION_X + 1'b1;
						ContinueFlag <= 1'b1;
						HandState <= 10;
					end
					else //not skin or reach the left line, record RHLFET,goto RHRIGHT
					begin
						RHLEFT_X <= TEMP_POSITION_X;
						we <= 1'b1;
						addr_reg <= {RHPosition_X,RHPosition_Y};
						TEMP_POSITION_X <= RHPosition_X ;
						TEMP_POSITION_Y <= RHPosition_Y ;
						ContinueFlag <= 1'b0;	
						HandState <= 11;
					end
				end
				11:		//RHRIGHT_X (mirrored!)
				begin
					if (SRAM_DQ[7] == 1'b1 && TEMP_POSITION_X>=2)		//if RIGHT is skin, continue go
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_X <= TEMP_POSITION_X - 1'b1;
						ContinueFlag <= 1'b0;
						HandState <= 11;
					end
					else if (ContinueFlag == 1'b0)
					begin
						we <=1'b1;
						addr_reg <= {TEMP_POSITION_X,TEMP_POSITION_Y};
						TEMP_POSITION_X <= TEMP_POSITION_X - 1'b1;
						ContinueFlag <= 1'b1;
						HandState <= 11;
					end
					else //not skin or reach the right line, record LHRIGHT,goto Refresh LH
					begin
						RHRIGHT_X <= TEMP_POSITION_X;
						we <= 1'b1;
						addr_reg <= {RHPosition_X,RHPosition_Y};
						TEMP_POSITION_X <= RHPosition_X ;
						TEMP_POSITION_Y <= RHPosition_Y ;
						ContinueFlag <= 1'b0;	
						HandState <= 12;
					end
				end
				12:		//Refresh RH and Goto Stop
				begin
					RHPosition_X = (RHLEFT_X >> 1) + (RHRIGHT_X >> 1) + 1'b1;
					RHPosition_Y = (RHTOP_Y >> 1) + (RHBOT_Y >> 1) + 1'b1;
					HandState <= 0;
				end
			endcase
		end
		else
		begin
			if (VGA_X == 9'd640 && VGA_Y == 9'd480)	//NewFrame
			begin
				Frame_CLK <= ~Frame_CLK;
				if (Frame_Counter == 3'd2)
				begin
					NewFrame <= 1'b1;
					Frame_Counter <= 3'b0;
				end
				else
				begin
					Frame_Counter <= Frame_Counter + 1'b1;
				end
			end
			case (VGA_X[1:0])
				0:
				begin
					addr_reg <= {VGA_X[9:2],VGA_Y[8:2]};
					we <= 1'b1;
					Skin_Counter <= Skin_Counter + IsSkin;
				end
				1:
				begin
					Skin_Binary_Temp <= SRAM_DQ;
					Skin_Counter <= Skin_Counter + IsSkin;
				end
				3:
				begin
					if (VGA_Y[1:0] == 2'b11)	//botright corner,rewrite SRAM, first bit IsSkin
					begin
						we <= 1'b0;
						data_reg <= {(((Skin_Binary_Temp[6:0] + Skin_Counter + IsSkin)>7'd4)?1'b1:1'b0),(Skin_Binary_Temp[6:0] + Skin_Counter + IsSkin)>>1};
					end
					else
					begin
						we <= 1'b0;
						data_reg <= Skin_Binary_Temp + Skin_Counter + IsSkin;
					end

					Skin_Counter <= 4'b0;
				end
				default:
				begin
					Skin_Counter <= Skin_Counter + IsSkin;
				end
			endcase
		end
	end
	//Color
	wire Square_Edge;
	assign Square_Edge = (VGA_X[4:1] == 4'h0 || VGA_X[4:1] ==4'hF || VGA_Y[4:1] == 4'h0 || VGA_Y[4:1] ==4'hF);
	
	wire [7:0]BeforeRGB_Y_Single,BeforeRGB_Cb_Single,BeforeRGB_Cr_Single;
	
	assign BeforeRGB_Y_Single = (VGA_LH_Cursor | VGA_RH_Cursor) ?
								8'h3F			//if cursor, red
							:	(Game_Screen_Flag ? 
							  ((Screen_F_Flag | Square_Edge)? 8'h00 : 8'hFF) 
							: (IsSkinForOutput && DPDT_SW[16]) ? 8'hFF : mY);
	assign BeforeRGB_Cb_Single = (VGA_LH_Cursor | VGA_RH_Cursor) ? 
								8'h70		//if cursor, red
							:	(Game_Screen_Flag ? 
								((Out_1 & (Type_1 == 3'b0)) ?
								8'hF0 : 8'h10) 	//if square, green
							:  ((IsSkinForOutput && DPDT_SW[16]) ? 	//if skin, white
								(8'h80) : mCb));//mCb;
	assign BeforeRGB_Cr_Single = (VGA_LH_Cursor | VGA_RH_Cursor) ?
								8'hFF			//if cursor, red
							:	(Game_Screen_Flag ? 
								8'h10 
							: ((IsSkinForOutput && DPDT_SW[16]) ? (8'h80) : mCr));
	
	assign BeforeRGB_Y = (BeforeRGB_Y_Single>>1)+(mY>>1);
	assign BeforeRGB_Cb = (BeforeRGB_Cb_Single>>1)+(mCb>>1);
	assign BeforeRGB_Cr = (BeforeRGB_Cr_Single>>1)+(mCr>>1);
	
	
	reg [7:0]LHPosition_X,RHPosition_X;
	reg [6:0]LHPosition_Y,RHPosition_Y;
	reg [7:0]LHTOP_X,LHBOT_X,LHLEFT_X,LHRIGHT_X,RHTOP_X,RHBOT_X,RHLEFT_X,RHRIGHT_X;
	reg [6:0]LHTOP_Y,LHBOT_Y,LHLEFT_Y,LHRIGHT_Y,RHTOP_Y,RHBOT_Y,RHLEFT_Y,RHRIGHT_Y;
	reg [7:0]TEMP_POSITION_X;
	reg [6:0]TEMP_POSITION_Y;
	reg [4:0]HandState;
	reg NewFrame,ContinueFlag;
	parameter LH_X_INIT = 7'd110;
	parameter LH_Y_INIT = 6'd40;
	parameter RH_X_INIT = 7'd50;
	parameter RH_Y_INIT = 6'd40;

   //  Line buffer, delay one line
   Line_Buffer u10  
   (  
     .clken    (VGA_Read),
     .clock    (OSC_27),
     .shiftin  (mYCbCr_d),
     .shiftout (m3YCbCr)
   );

   Line_Buffer u11
   (  
     .clken    (VGA_Read),
     .clock    (OSC_27),
     .shiftin  (m3YCbCr),
     .shiftout (m4YCbCr)
   );

   wire  [15:0] m4YCbCr;
   wire  [15:0] m5YCbCr;
   wire  [8:0]  Tmp1,Tmp2;
   wire  [7:0]  Tmp3,Tmp4;
   reg [7:0] TmpCb,TmpCr;
   reg flagCbCr;

   assign  Tmp1    = m4YCbCr[7:0] + mYCbCr_d[7:0];
   assign  Tmp2    = m4YCbCr[15:8] + mYCbCr_d[15:8];
   assign  Tmp3    = Tmp1[8:2] + m3YCbCr[7:1];
   assign  Tmp4    = Tmp2[8:2] + m3YCbCr[15:9];
   assign  m5YCbCr = { Tmp4, Tmp3 };


   assign  TD_RESET = 1'b1;  //  Allow 27 MHz
//==========================================================
//===============Random Number Generator====================
//==========================================================
	reg [30:0]Rand;
	wire Rand_Low_Bit;
	assign Rand_Low_Bit = Rand[27] ^ Rand[30];
	always @ (posedge OSC_27)
	begin
		if (!DLY2)
		begin
			Rand[30:0] <= 31'h55555555;
		end
		else
		begin
			Rand[30:0] <= {Rand[29:0],Rand_Low_Bit};
		end
	end
//========================================
//===============Graph====================
//========================================
	reg [319:0]Screen_Filled;
	reg [8:0]Screen_Index;
	reg [3:0]State_VGA_Graph;
	reg [2:0] State_Screen_Filled;
	wire R_CLK;
	reg Reset_1;
	reg Set_1;
	wire Finish_1;
	wire [4:0]VGA_X_1;
	wire [3:0]VGA_Y_1;
	wire [5:0]Speed_1;
	reg [2:0]Type_1;
	reg [1:0]Angle_1;
	reg [4:0]X_1;
	reg [3:0]Y_1;
	reg [3:0]Frame_Counter_1;
	reg Last_Frame_CLK;
	wire En_1;
	wire Out_1;
	wire Bound_1;
	wire [4:0]X_out_1;
	wire [3:0]Y_out_1;
	wire [3:0]State_1;
	wire [19:0]Top_Line;
	assign Top_Line = {Screen_Filled[304],Screen_Filled[288],Screen_Filled[272],Screen_Filled[256],Screen_Filled[240],
							 Screen_Filled[224],Screen_Filled[208],Screen_Filled[192],Screen_Filled[176],Screen_Filled[160],
							 Screen_Filled[144],Screen_Filled[128],Screen_Filled[112],Screen_Filled[96],Screen_Filled[80],
							 Screen_Filled[64],Screen_Filled[48],Screen_Filled[32],Screen_Filled[16],Screen_Filled[0]};
	
	wire [1:0]Game_Screen_Flag;
	assign Game_Screen_Flag = {Screen_F_Flag | Out_1};
	

	wire Screen_F_Flag;
	assign Screen_F_Flag = Screen_Filled [{VGA_X[9:5],VGA_Y[8:5]}];
	
	assign R_CLK = Frame_CLK;
	assign VGA_X_1 = VGA_X[9:5];
	assign VGA_Y_1 = VGA_Y[8:5];
	assign Speed_1 = 6'b000100;
	assign En_1 = 1'b1;
	wire [319:0]Push_To_Start;
	assign Push_To_Start = 320'hDC1F_D405_F407_8000_843F_FFF0_843F_8000_FFF7_9635_FFFD_8000_FC1F_B404_EC1F_8000_8400_FC00_8400_8000;
	always @ (posedge OSC_27)
	begin
		if (!DLY2)
		begin
			Screen_Filled <= Push_To_Start;
			Set_1 <= 1'b0;
			State_VGA_Graph <= 4'b0;
			Reset_1 <= 1'b1;
			Frame_Counter_1 <= 4'b0;
			Game_Score_1 <= 4'b0;
			Game_Score_2 <= 4'b0;
		end
		else
		begin
			case (State_VGA_Graph)
				0:
				begin
					Screen_Filled <= Push_To_Start;
					if (Hand_Push_L & Hand_Push_R)
					begin
						Screen_Filled <= {20{16'h8000}};
						Game_Score_1 <= 4'b0;
						Game_Score_2 <= 4'b0;
						Game_Score_3 <= 4'b0;
						State_VGA_Graph <= 3'd1;
					end
				end
				1:
				begin
					if (Reset_1)
					begin
						Set_1 <= 1'b0;
						if (Finish_1 == 1'b0)
						begin
							Last_Frame_CLK <= Frame_CLK;
							if (Last_Frame_CLK == 1'b0 && Frame_CLK == 1'b1)
							begin
								Frame_Counter_1 <= Frame_Counter_1+4'b1;
							end
							if (Frame_Counter_1 == 4'd3)
							begin
								Reset_1 <= 1'b0;
								Frame_Counter_1 <= 1'b0;
							end
						end
						else
						begin
							Frame_Counter_1 <= 4'b0;
						end
					end
					else if (Finish_1 == 1'b0 && Set_1 == 1'b0 && DPDT_SW[17])	//start
					begin
						Set_1 <= 1'b1;
						X_1 <= Rand[30:27]+2'd2;
						Y_1 <= 4'b0;
						Type_1 <= Rand[25:23];
						Angle_1 <= Rand[22:21];		
					end
					else if (Finish_1 == 1'b1 && Set_1 == 1'b1) //reset
					begin
						case (Type_1)
							0:
							begin
								if (Y_out_1+1'b1 < 15)
								begin
									Screen_Filled[{X_out_1,Y_out_1+1'b1}] <= 1'b0; 
									Screen_Filled[{X_out_1+1'b1,Y_out_1+1'b1}] <= 1'b0; 
								end
							end
							1:		//Square
							begin
								Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
								Screen_Filled[{X_out_1,Y_out_1-1'b1}] <= 1'b1; 
								Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
								Screen_Filled[{X_out_1+1'b1,Y_out_1-1'b1}] <= 1'b1; 
							end
							2:		//Bar
							begin
								case (Angle_1[0])
									0:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-2'd2}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-2'd3}] <= 1'b1; 
									end
									1:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd3,Y_out_1}] <= 1'b1; 
									end
								endcase
							end
							3:		//L
							begin
								case (Angle_1)
									0:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-2'd1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-2'd2}] <= 1'b1; 
									end
									1:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1-1'b1}] <= 1'b1; 
									end
									2:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1+2'd2}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1+1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
									end
									3:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd1,Y_out_1-1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1-1'b1}] <= 1'b1; 
									end
								endcase
							end
							4:		//Reverse L
							begin
								case (Angle_1)
									0:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1-2'd1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1-2'd2}] <= 1'b1; 
									end
									1:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-1'b1}] <= 1'b1; 
									end
									2:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-2'd2}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd1,Y_out_1-2'd2}] <= 1'b1; 
									end
									3:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1+1'b1}] <= 1'b1; 
									end
								endcase
							end
							5:		//T
							begin
								case (Angle_1)
									0:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1+1'd1}] <= 1'b1; 
									end
									1:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1+1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1-1'b1}] <= 1'b1; 
									end
									2:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd1,Y_out_1-2'd1}] <= 1'b1; 
									end
									3:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-2'd2}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd1,Y_out_1-1'b1}] <= 1'b1; 
									end
								endcase
							end
							6:		//Z
							begin
								case (Angle_1[0])
									0:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd1,Y_out_1+1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1+1'd1}] <= 1'b1; 
									end
									1:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1-1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1-2'd2}] <= 1'b1; 
									end
								endcase
							end
							7:		//reverse Z
							begin
								case (Angle_1[0])
									0:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+1'b1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd1,Y_out_1-1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1+2'd2,Y_out_1-1'd1}] <= 1'b1; 
									end
									1:
									begin
										Screen_Filled[{X_out_1,Y_out_1}] <= 1'b1; 
										Screen_Filled[{X_out_1,Y_out_1-1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1-1'b1,Y_out_1-1'b1}] <= 1'b1; 
										Screen_Filled[{X_out_1-1'b1,Y_out_1-2'd2}] <= 1'b1; 
									end
								endcase
							end
						endcase
						Set_1 <= 1'b0;
					end	//end reset
					else
					begin	//hit
						if (Hand_Push_L | Hand_Push_R)
						begin
							if (((LHPosition_X[7:3] == X_out_1)||(LHPosition_X[7:3] == X_out_1+1'b1)) && ((LHPosition_Y[6:3] == Y_out_1)||(LHPosition_Y[6:3] == Y_out_1-1'b1)))
							begin
								if (Game_Score_1 == 4'd9)
								begin
									Game_Score_1 <= 4'd0;
									if (Game_Score_2 == 4'd9)
									begin
										Game_Score_2 <= 4'd0;
										Game_Score_3 <= Game_Score_3 + 1'b1;
									end
									else
									begin
										Game_Score_2 <= Game_Score_2 + 1'b1;
									end
								end
								else
								begin
									Game_Score_1 <= Game_Score_1 + 1'b1;
								end
								Reset_1 <= 1'b1;
							end
							else if (((RHPosition_X[7:3] == X_out_1)||(RHPosition_X[7:3] == X_out_1+1'b1)) && ((RHPosition_Y[6:3] == Y_out_1)||(RHPosition_Y[6:3] == Y_out_1-1'b1)))
							begin
								if (Game_Score_1 == 4'd9)
								begin
									Game_Score_1 <= 4'd0;
									if (Game_Score_2 == 4'd9)
									begin
										Game_Score_2 <= 4'd0;
										Game_Score_3 <= Game_Score_3 + 1'b1;
									end
									else
									begin
										Game_Score_2 <= Game_Score_2 + 1'b1;
									end
								end
								else
								begin
									Game_Score_1 <= Game_Score_1 + 1'b1;
								end
								Reset_1 <= 1'b1;
							end
						end
						if (Top_Line != 20'b0)
						begin
							State_VGA_Graph <= 3'd0;
						end
					end	//end hit
				end
			endcase
		end
	end
	//Game Results
	reg [3:0]Game_Time_1,Game_Time_2,Game_Time_3,Game_Time_4;
	reg [3:0]Game_Score_1,Game_Score_2,Game_Score_3;
	reg [4:0]Game_Frame_Counter;
	reg [3:0]Last_State_VGA_Graph;
	reg Flag_Refresh_Timer;
	always @ (posedge R_CLK)
	begin
		if (!DLY2)
		begin
			Game_Time_1 <= 4'b0;
			Game_Time_2 <= 4'b0;
			Game_Time_3 <= 4'b0;
			Game_Time_4 <= 4'b0;
			Game_Frame_Counter <= 5'b0;
		end
		else if (Last_State_VGA_Graph == 4'b0)
		begin
			if (State_VGA_Graph == 4'b1)
			begin
				Last_State_VGA_Graph <= 4'b1;
				Game_Time_1 <= 4'b0;
				Game_Time_2 <= 4'b0;
				Game_Time_3 <= 4'b0;
				Game_Time_4 <= 4'b0;
				Game_Frame_Counter <= 5'b0;
			end
		end
		else
		begin
			Last_State_VGA_Graph <= State_VGA_Graph;
			if (Game_Frame_Counter == 5'd29)
			begin
				Game_Frame_Counter <= 5'b0;
				if (Game_Time_1 == 4'd9)
				begin
					Game_Time_1 <= 4'b0;
					if (Game_Time_2 == 4'd9)
					begin
						Game_Time_2 <= 4'b0;
						if (Game_Time_3 == 4'd9)
						begin
							Game_Time_3 <= 4'd0;
							Game_Time_4 <= Game_Time_4 + 1'b1;
						end
						else
						begin
							Game_Time_3 <= Game_Time_3 + 1'b1;
						end
					end
					else
					begin
						Game_Time_2 <= Game_Time_2 + 1'b1;
					end
				end
				else
				begin
					Game_Time_1 <= Game_Time_1 + 1'b1;
				end
			end
			else
			begin
				Game_Frame_Counter <= Game_Frame_Counter + 1'b1;
			end
		end
	end
	
	assign LED_RED[17:13] = Y_out_1;
	assign LED_RED[12:8] = VGA_Y[8:5];
	assign LED_RED[7:2] = {State_VGA_Graph,Reset_1,Set_1,Finish_1,Out_1,Bound_1};
	assign LED_GREEN[2:0] = Out_State;
	//assign LED_GREEN = State_1;
	wire [2:0]Out_State;
	VGA_Graph VG1 (.R_CLK(R_CLK),
						.Reset(Reset_1),
						.Set(Set_1),
						.Finish(Finish_1),
						.En(En_1),
						.i_VGA_X(VGA_X_1),
						.i_VGA_Y(VGA_Y_1),
						.i_Type(Type_1),
						.i_Angle(Angle_1),
						.i_Speed(Speed_1),
						.i_Xin(X_1),
						.i_Yin(Y_1),
						.i_Screen_Filled(Screen_Filled),
						.o_Xout(X_out_1),
						.o_Yout(Y_out_1),
						.Out(Out_1),
						.Bound(Bound_1),
						.Out_State(Out_State)
						);
endmodule