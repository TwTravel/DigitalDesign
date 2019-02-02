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

  //  For Audio CODEC
  wire  AUD_CTRL_CLK;  //  For Audio Controller
  assign  AUD_XCK = AUD_CTRL_CLK;

  //  7 segment LUT
 /* SEG7_LUT_8 u0 
  (
    .oSEG0  (HEX0),
    .oSEG1  (HEX1),
    .oSEG2  (HEX2),
    .oSEG3  (HEX3),
    .oSEG4  (HEX4),
    .oSEG5  (HEX5),
    .oSEG6  (HEX6),
    .oSEG7  (HEX7),
    .iDIG   (DPDT_SW) 
  );*/
	
	reg [17:0] score;
	
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
    .iDIG   (score) 
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
    .iY       (mY),
    .iCb      (mCb),
    .iCr      (mCr),
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
	 //.ledout     (LED_RED),
    .iRST_N     (DLY2),
	 .Avg_X      (AVG_X),
	 .Avg_Y      (AVG_Y)
  );
  reg [9:0]  mVGA_R;
  reg [9:0]  mVGA_G;
  reg [9:0]  mVGA_B;
  
  wire [9:0] Red, Green, Blue;


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
  wire  [7:0]  mY;
  wire  [7:0]  mCb;
  wire  [7:0]  mCr;

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

  assign  Tmp1    = m4YCbCr[7:0] + mYCbCr_d[7:0];
  assign  Tmp2    = m4YCbCr[15:8] + mYCbCr_d[15:8];
  assign  Tmp3    = Tmp1[8:2] + m3YCbCr[7:1];
  assign  Tmp4    = Tmp2[8:2] + m3YCbCr[15:9];
  assign  m5YCbCr = { Tmp4, Tmp3 };

  assign  TD_RESET = 1'b1;  //  Allow 27 MHz
/*
  AUDIO_DAC_ADC u12  
  (  //  Audio Side
    .oAUD_BCK     (AUD_BCLK),
    .oAUD_DATA    (AUD_DACDAT),
    .oAUD_LRCK    (AUD_DACLRCK),
    .oAUD_inL     (audio_inL), // audio data from ADC 
    .oAUD_inR     (audio_inR), // audio data from ADC 
    .iAUD_ADCDAT  (AUD_ADCDAT),
    .iAUD_extL    (audio_outL), // audio data to DAC
    .iAUD_extR    (audio_outR), // audio data to DAC
    //  Control Signals
    .iCLK_18_4    (AUD_CTRL_CLK),
    .iRST_N       (DLY0)
  );*/
wire [17:0] mem_bit1;
wire [17:0] mem_bit2;
wire [17:0] mem_bit3;
wire [10:0] AVG_X, AVG_Y;

reg [30:0] x_rand1, x_rand2, x_rand3;
reg [28:0] y_rand1, y_rand2, y_rand3;
wire x_low_bit1, y_low_bit1;
wire x_low_bit2, y_low_bit2;
wire x_low_bit3, y_low_bit3;

reg [9:0] start_position_x1;
reg [8:0] start_position_y1;
reg [9:0] start_position_x2;
reg [8:0] start_position_y2;

reg [27:0] count;
reg [3:0] state;
wire [7:0] dataout;
wire [9:0] table_x[0:11];
wire [8:0] table_y[0:11];
reg [1:0] index_x1, index_y1, index_x2, index_y2;
wire [9:0] vVGA_R,vVGA_G,vVGA_B;
reg [9:0] cVGA_R,cVGA_G,cVGA_B;
wire hit1, hit2, nohit1, nohit2;
reg flag1img,flag2img, flag1sound, flag2sound, flag3sound;
reg [3:0] state_vga,state_sound;
reg [23:0] cnt_sound;
wire clear_zero;
reg [3:0] next_level, pre_next_level;
wire [27:0] move_count;
reg [13:0] wave;
reg flag_bruce,last_bruce;


assign clear_zero = ~KEY[3];//used to clear everything
//If the position need to display a mole, then play it, otherwise just display the grass land
assign hit1 = ((VGA_X < start_position_x1 + 10'd80) &&(VGA_X >= start_position_x1) && (VGA_Y < start_position_y1 + 9'd80) && (VGA_Y >= start_position_y1) &&(flag1img == 1'd1));//&& (AVG_X < start_position_x1 + 10'd80) &&(AVG_X >= start_position_x1) && (AVG_Y < start_position_y1 + 9'd80) && (AVG_Y >= start_position_y1));
assign hit2 = ((VGA_X < start_position_x2 + 10'd80) &&(VGA_X >= start_position_x2) && (VGA_Y < start_position_y2 + 9'd80) && (VGA_Y >= start_position_y2) &&(flag2img == 1'd1));//&& (AVG_X < start_position_x2 + 10'd80) &&(AVG_X >= start_position_x2) && (AVG_Y < start_position_y2 + 9'd80) && (AVG_Y >= start_position_y2));
assign nohit1 = ((VGA_X < start_position_x1 + 10'd80) &&(VGA_X >= start_position_x1) && (VGA_Y < start_position_y1 + 9'd80) && (VGA_Y >= start_position_y1));
assign nohit2 = ((VGA_X < start_position_x2 + 10'd80) &&(VGA_X >= start_position_x2) && (VGA_Y < start_position_y2 + 9'd80) && (VGA_Y >= start_position_y2));





parameter total_count = 28'h7FFFFFF;
assign move_count = (total_count >> next_level);
//These are the color information from camera
assign  vVGA_R = Red;//( Red >> 2 ) + ( Green >> 1 ) + ( Blue >> 3 );
assign  vVGA_G = Green;//( Red >> 2 ) + ( Green >> 1 ) + ( Blue >> 3 );
assign  vVGA_B = Blue;//( Red >> 2 ) + ( Green >> 1 ) + ( Blue >> 3 );

//generate location centre xi
genvar i;
generate
for(i=0;i<4;i=i+1)
begin: tx
	assign table_x[i] = 10'd160 * i + 10'd40;
end
endgenerate
//generate the location centre yi
genvar j;
generate
for(j=0;j<3;j=j+1)
begin: ty
	assign table_y[j] = 9'd160 * j + 9'd40;
end
endgenerate

//two ports M4K blocks control part
//used to display moles
vga_buffer display(
	.address_a ((VGA_Y-start_position_y1)*80+(VGA_X-start_position_x1)),
	.address_b ((VGA_Y-start_position_y2)*80+(VGA_X-start_position_x2)), // vga current address
	.clock(OSC_27),
	.data_a (1'b0),
	.data_b (1'b0), // never write on port b
	.wren_a (1'b0),
	.wren_b (1'b0), // never write on port b
	.q_a (mem_bit1),
	.q_b (mem_bit2)); // data used to update VGA
	
//one port M4K blocks control part
//used to display Bruce	
bruce bruce(
	.address((VGA_Y-start_position_y2)*80+(VGA_X-start_position_x2 )),
	.clock(OSC_27),
	.data(1'b0),
	.wren(1'b0),
	.q(mem_bit3)
);

//initialization for the rand number of moles' position	
initial
begin
	x_rand1 <= 31'h55555555;
	y_rand1 <= 29'h55555555;
	x_rand2 <= 31'h66666666;
	y_rand2 <= 29'h66666666;
	x_rand3 <= 31'h57777777;
	y_rand3 <= 29'h57777777;
end
//random generation
assign x_low_bit1 = x_rand1[27] ^ x_rand1[30];
assign y_low_bit1 = y_rand1[26] ^ y_rand1[28];
assign x_low_bit2 = x_rand2[27] ^ x_rand2[30];
assign y_low_bit2 = y_rand2[26] ^ y_rand2[28];
assign x_low_bit3 = x_rand3[27] ^ x_rand3[30];
assign y_low_bit3 = y_rand3[26] ^ y_rand3[28];

//assign flag_bruce = (x_rand1[30] && (x_rand2[3:2] == 2'd1))?1'b0
//						 :(x_rand1[30])?1'b1: 1'b1;

parameter idle=4'd0,state1=4'd1,state2=4'd2,state3=4'd3;	
always @ (posedge OSC_27)
begin
	x_rand1 <= {x_rand1[29:0], x_low_bit1} ;
	y_rand1 <= {y_rand1[27:0], y_low_bit1} ;
	x_rand2 <= {x_rand2[29:0], x_low_bit2} ;
	y_rand2 <= {y_rand2[27:0], y_low_bit2} ;
	x_rand3 <= {x_rand3[29:0], x_low_bit3} ;
	y_rand3 <= {y_rand3[27:0], y_low_bit3} ; 
	
	case(state)
	idle:
	begin
		count <= count + 28'b1;
		if(count == move_count)
		begin
	
			count <= 28'b0;
			state <= state1;
			index_x1 <= x_rand1 % 4;
			index_y1 <= y_rand1 % 3;
			//determine whether we need to display bruce
			//It's a random bit
			if(x_rand1[30])
			begin
				index_x2 <= x_rand2 % 4;
				index_y2 <= y_rand2 % 3;
				if(x_rand1[4] == 1'd1)
					flag_bruce <= 1'd1;
				else
					flag_bruce <= 1'd0;
				last_bruce <= flag_bruce;
					
			end
			else
			//generate mole's x and y position
			begin
				index_x2 <= x_rand1 % 4;
				index_y2 <= y_rand1 % 3;
			end
			

		end
		else
		begin
			state <= idle;
		end
		
		//flagimg is used to control whether we hit the first or second mole
		if((AVG_X < start_position_x1 + 10'd80) &&(AVG_X >= start_position_x1) && (AVG_Y < start_position_y1 + 9'd80) && (AVG_Y >= start_position_y1))
		begin
			flag1img <= 1'd1;	
		end
		else if((AVG_X < start_position_x2 + 10'd80) &&(AVG_X >= start_position_x2) && (AVG_Y < start_position_y2 + 9'd80) && (AVG_Y >= start_position_y2))
		begin
			flag2img <= 1'd1;
		end

		
	end

	state1:
	begin
		//initial the start position
		start_position_x1 <= table_x[index_x1];		
		start_position_y1 <= table_y[index_y1];
		start_position_x2 <= table_x[index_x2];		
		start_position_y2 <= table_y[index_y2];
		state <= idle;
		//clear the score and reset the level to 0
		if(clear_zero || (next_level != pre_next_level))
		begin
			pre_next_level <= next_level;
			score <= 18'b0;
		end
		//determine whether we hit the mole or bruce or nothing at all, and we can calculate the score player gets	
		if(flag1img==1'b1 && flag2img==1'b1 && (last_bruce==1'b0) && ((start_position_x1!=start_position_x2) || (start_position_y1!=start_position_y2)))	
		begin
			score <= score + 18'd2;
		end
		//hit one mole
		else if(((flag1img==1'b1 && flag2img==1'b0) || (flag1img==1'b0 && flag2img==1'b1 && last_bruce==1'b0)) || (start_position_x1==start_position_x2 && start_position_y1==start_position_y2 && flag1img==1'b1 && flag2img==1'b1))
		begin
			score <= score + 18'd1;
		end
		//hit one mole and bruce
		else if(flag1img==1'b1 && flag2img==1'b1  && last_bruce==1'd1)
		begin
			if(score >= 18'd4)
			begin
				score <= score - 18'd4;
			end
			else
			begin
				score <= 18'd0;
			end
		end
		//just hit bruce
		else if(flag1img==1'b0 && flag2img==1'b1  && last_bruce==1'd1)
		begin
			if(score >= 18'd5)
			begin
				score <= score - 18'd5;
			end
			else
			begin
				score <= 18'd0;
			end
		end
		//level up!
		if(score >= 18'd15)
		begin
			next_level <= next_level + 4'd1;			
			score <= 18'd0;
			wave <= 14'd1;	
			flag3sound <= 1'd1;
		end
		else
			wave <= 14'd0;
		//reset the level audio
		if(flag3sound)
			flag3sound <= 1'b0;
			
		
		flag1img <= 1'd0;
		flag2img <= 1'd0;

	end
	endcase

	
	
	case(state_sound)
	state1:
	begin
		//determine whether we need the audio to display
		if((AVG_X < start_position_x1 + 10'd80) &&(AVG_X >= start_position_x1) && (AVG_Y < start_position_y1 + 9'd80) && (AVG_Y >= start_position_y1))
		begin
			flag1sound <= 1'd1;	
			state_sound <= state2;
		end
		
		else if((AVG_X < start_position_x2 + 10'd80) &&(AVG_X >= start_position_x2) && (AVG_Y < start_position_y2 + 9'd80) && (AVG_Y >= start_position_y2))
		begin
			flag2sound <= 1'd1;
			state_sound <= state2;
			flag3sound <= 1'd0;
		end
		else
		begin
			state_sound <= state1;
		end
	end
	
	state2:
	begin
		//using counter to control the audio time
		if(cnt_sound == 24'hffffff)
		begin
			flag1sound <= 1'd0;
			flag2sound <= 1'd0;
			cnt_sound <= 24'd0;
			state_sound <= state1;
		end
		else
			cnt_sound <= cnt_sound + 24'd1;
	end
	endcase
end



//This always block is used to display the VGA screen, to get the right data from M4K
always @ (posedge OSC_27)
begin
	case(state_vga)
	state1:
	begin
		if(hit1) //hit first mole
		begin
			cVGA_R <= 10'b1111111111;
			cVGA_B <= 10'b0;
			cVGA_G <= 10'b0;
		end
		else if (nohit1)//not hit first mole
		begin
			cVGA_R <= {mem_bit1[17:12],4'b0};
			cVGA_G <= {mem_bit1[11:6],4'b0};	
			cVGA_B <= {mem_bit1[5:0],4'b0};
		end
		
		else if(hit2)//hit second mole or bruce
		begin
			cVGA_R <= 10'b1111111111;
			cVGA_B <= 10'b0;
			cVGA_G <= 10'b0;
		end
		else if (nohit2 && (~last_bruce)) //not hit second mole
		begin

			cVGA_R <= {mem_bit2[17:12],4'b0};
			cVGA_G <= {mem_bit2[11:6],4'b0};	
			cVGA_B <= {mem_bit2[5:0],4'b0};
		end
		else if (nohit2)//not hit bruce
		begin

			cVGA_R <= {mem_bit3[17:12],4'b0};
			cVGA_G <= {mem_bit3[11:6],4'b0};	
			cVGA_B <= {mem_bit3[5:0],4'b0};
		end
		else
		begin
			cVGA_R <= 10'b0;
			cVGA_G <= 10'b1111111111;
			cVGA_B <= 10'b0;
		end
		state_vga <= state2;
	end
	
	state2:
	begin
		//display the instrument we used to hit the mole
		if((Red<10'd450)&&(Green > 10'd700)&&(Blue < 10'd450))
		begin
			mVGA_R <= 10'd0;
			mVGA_G <= 10'd0;
			mVGA_B <= 10'd0;
		end
		else
		begin
			mVGA_R <= cVGA_R;
			mVGA_G <= cVGA_G;
			mVGA_B <= cVGA_B;
		end
		state_vga <= state1;
	end
	
	//state3:
	endcase
end
/*****************************************************************************************/


wire	VGA_CTRL_CLK;
wire	DLY_RST;

assign	TD_RESET	=	1'b1;	//	Allow 27 MHz
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;


AUDIO_DAC_ADC 			u14	(	//	Audio Side
							.oAUD_BCK(AUD_BCLK),
							.oAUD_DATA(AUD_DACDAT),
							.oAUD_LRCK(AUD_DACLRCK),
							.oAUD_inL(audio_inL), // audio data from ADC 
							.oAUD_inR(audio_inR), // audio data from ADC 
							.iAUD_ADCDAT(AUD_ADCDAT),
							.iAUD_extL(audio_outL), // audio data to DAC
							.iAUD_extR(audio_outR), // audio data to DAC
							//	Control Signals
				         .iCLK_18_4(AUD_CTRL_CLK),
							.iRST_N(DLY0)
							);

/// audio stuff /////////////////////////////////////////////////

// reset control
assign reset = ~KEY[2];
//assign LEDG[0] = reset;

// The data for the DACs
wire signed [15:0] audio_outL, audio_outR ;

// output from DDS units and noise
wire signed [15:0] sine_out, fm_out, modulated_out;
wire signed [31:0] fm_depth ;

// output two sine waves in quadrature
assign audio_outR = modulated_out<<1;
assign audio_outL = fm_out<<1 ; 

////////////////////////////////////////////////
// FM Modulated main sine wave generator
sine_attack_decay sine_fm (.clock(AUD_DACLRCK), 
				.reset(~(flag1sound|| flag2sound || flag3sound)),
				// note that increment takes input from the FM module
				.increment({7'h02, 23'b0} + fm_depth), 
				.phase(8'd0),
				.attack(4'd0), // fast rise
				.decay(4'd7),
				.amp(16'h8FFF),
				.shaped_out(modulated_out));

// generate modulation for main oscillator	
// set modulator depth with SW[3:0]
// set modulator frequency with SW[17:4]			
sine_attack_decay fm (.clock(AUD_DACLRCK), 
				.reset(~(flag1sound || flag2sound || flag3sound)),
				.increment({wave, 18'b0}), 
				.phase(8'd0), 
				.attack(4'd1), // fast rise
				.decay(4'd6),  // fairly slow fall
				.amp(16'h7FFF), // nearly full amp
				.shaped_out(fm_out));
// now scale the FM output to modulate the increment of the main oscillator
// shange the 2's comp to offset binary, shift, subtract off average value again
assign fm_depth = ({fm_out+16'h8000, $signed(16'b0)}>>DPDT_SW[3:0]) - (32'h80000000>>DPDT_SW[3:0]);
endmodule



/*************************************************************************************/
//////////////////////////////////////////////////
////////////	Attack and decay sine //////////////
//////////////////////////////////////////////////
// Input is an increment, phase and a clock, attack time, decay time, initial amplitude
// output is a shaped sine wave
// Output frequency = increment * clock_rate / accumulator_bit_length
// Here accumulator_bit_length is 32 bits
// Phase is measured in samples out of 256/cycle. e.g. 64 input is 90 degrees
// attack and decay parameters are in shift-right units from a slow clock Range: 0=fast 15=very slow
module sine_attack_decay (clock, reset, increment, phase, attack, decay, amp, shaped_out);
input clock, reset;
input [31:0] increment ;
input [7:0]  phase ;
input [3:0] attack, decay ;
input [15:0] amp ;
output wire signed [15:0] shaped_out;

reg [31:0]	accumulator;
reg [7:0] LR_clk_divider; 
reg [15:0] amp_rise, amp_fall;
wire signed [15:0] sine_out ;
wire  [15:0] amp_rise_main, envelope ;
wire [31:0] temp_mult, temp_envelope;

always@(posedge clock) begin
	if (reset) begin
		accumulator <= 0;
		amp_fall <= amp ; 
		amp_rise <= amp ;
	end
	
	// increment phase accumulator
	else accumulator <= accumulator + increment  ;
	
	LR_clk_divider = LR_clk_divider + 1;
	if (LR_clk_divider == 0) begin
		amp_fall <= amp_fall - (amp_fall>>decay) ;
		amp_rise <= amp_rise - (amp_rise>>attack);
	end	
end

// form (1-exp(-t/tau)) for the attack phase
assign amp_rise_main =  amp - amp_rise;
// product of rise and fall exponentials is the amplitude envelope
assign temp_envelope = amp_rise_main * amp_fall ;
assign envelope = temp_envelope[31:16]  ;		

// link the accumulator to the sine lookup table
sync_rom sineTable(clock, accumulator[31:24]+phase, sine_out);
assign temp_mult = (sine_out<<1) * $signed(envelope);
//assign shaped_out = (envelope<16'h10)? 16'd0 : temp_mult[31:16] ;
assign shaped_out = temp_mult[31:16] ;

endmodule




//////////////////////////////////////////////////

//////////////////////////////////////////////////
////////////	Direct Digital Synth	//////////////
//////////////////////////////////////////////////
// Input is an increment, phase and a clock
// output is a sine wave
// Output frequency = increment * clock_rate / accumulator_bit_length
// Here accumulator_bit_length is 32 bits
// Phase is measured in samples out of 256/cycle. e.g. 64 input is 90 degrees

module DDS (clock, reset, increment, phase, sine_out);
input clock, reset;
input [31:0] increment ;
input [7:0]  phase;
output wire signed [15:0] sine_out;
reg [31:0]	accumulator;

always@(posedge clock) begin
	if (reset) accumulator <= 0;
	// increment phase accumulator
	else accumulator <= accumulator + increment  ;
end

// link the accumulator to the sine lookup table
sync_rom sineTable(clock, accumulator[31:24]+phase, sine_out);

endmodule
//////////////////////////////////////////////////

//////////////////////////////////////////////////
////////////	Linear feedback noise	///////////
//////////////////////////////////////////////////
// Input is an lowpass cutoff and a clock
// output is bandlimited white noise
// frequency cutoff is given as a power of two from 0 to 7
// where 0 means no filtering and 7 means a cutoff ~= clock/(2^7) 

module LFSR (clock, reset, cutoff, gain, noise_out);
input clock, reset;
input [2:0]  cutoff, gain;
output wire signed [15:0] noise_out;

//random number generator and lowpass filter
wire x_low_bit ; // random number gen low-order bit
reg  signed [30:0] x_rand ;//  rand number
wire signed [17:0] new_lopass, rand_bits ;
reg signed [17:0]  lopass ;

//generate a random number 
//right-most bit for rand number shift regs
assign x_low_bit = x_rand[27] ^ x_rand[30];
assign rand_bits = x_rand[17:0];
// LOWPASS:
// newsample = (1-alpha)*oldsample + random*alpha
// rearranging:
// newsample = oldsample + (random-oldsample)*alpha
// alpha is set from 1 to 1/128 using shifts from 0 to 7
// alpha==1 means no lopass at all. 1/128 loses almost all the input bits
//assign new_lopass = lopass + {{4{x_rand[17]}},x_rand[17:4]} - {{4{lopass[17]}},lopass[17:4]};

assign new_lopass = lopass + (rand_bits - lopass)>>>cutoff;
assign noise_out = lopass[17:2]<<gain ;

always@(posedge clock) begin
	if (reset)
	begin
		x_rand <= 31'h55555555;
		lopass <= 18'h0 ;
	end
	else begin
		x_rand <= {x_rand[29:0], x_low_bit} ;
		lopass <= new_lopass ;
	end
end
endmodule
//////////////////////////////////////////////////

//////////////////////////////////////////////////
////////////	Sin Wave ROM Table	//////////////
//////////////////////////////////////////////////
// produces a 2's comp, 16-bit, approximation
// of a sine wave, given an input phase (address)
module sync_rom (clock, address, sine);
input clock;
input [7:0] address;
output [15:0] sine;
reg signed [15:0] sine;
always@(posedge clock)
begin
    case(address)
    		8'h00: sine = 16'h0000 ;
			8'h01: sine = 16'h0192 ;
			8'h02: sine = 16'h0323 ;
			8'h03: sine = 16'h04b5 ;
			8'h04: sine = 16'h0645 ;
			8'h05: sine = 16'h07d5 ;
			8'h06: sine = 16'h0963 ;
			8'h07: sine = 16'h0af0 ;
			8'h08: sine = 16'h0c7c ;
			8'h09: sine = 16'h0e05 ;
			8'h0a: sine = 16'h0f8c ;
			8'h0b: sine = 16'h1111 ;
			8'h0c: sine = 16'h1293 ;
			8'h0d: sine = 16'h1413 ;
			8'h0e: sine = 16'h158f ;
			8'h0f: sine = 16'h1708 ;
			8'h10: sine = 16'h187d ;
			8'h11: sine = 16'h19ef ;
			8'h12: sine = 16'h1b5c ;
			8'h13: sine = 16'h1cc5 ;
			8'h14: sine = 16'h1e2a ;
			8'h15: sine = 16'h1f8b ;
			8'h16: sine = 16'h20e6 ;
			8'h17: sine = 16'h223c ;
			8'h18: sine = 16'h238d ;
			8'h19: sine = 16'h24d9 ;
			8'h1a: sine = 16'h261f ;
			8'h1b: sine = 16'h275f ;
			8'h1c: sine = 16'h2899 ;
			8'h1d: sine = 16'h29cc ;
			8'h1e: sine = 16'h2afa ;
			8'h1f: sine = 16'h2c20 ;
			8'h20: sine = 16'h2d40 ;
			8'h21: sine = 16'h2e59 ;
			8'h22: sine = 16'h2f6b ;
			8'h23: sine = 16'h3075 ;
			8'h24: sine = 16'h3178 ;
			8'h25: sine = 16'h3273 ;
			8'h26: sine = 16'h3366 ;
			8'h27: sine = 16'h3452 ;
			8'h28: sine = 16'h3535 ;
			8'h29: sine = 16'h3611 ;
			8'h2a: sine = 16'h36e4 ;
			8'h2b: sine = 16'h37ae ;
			8'h2c: sine = 16'h3870 ;
			8'h2d: sine = 16'h3929 ;
			8'h2e: sine = 16'h39da ;
			8'h2f: sine = 16'h3a81 ;
			8'h30: sine = 16'h3b1f ;
			8'h31: sine = 16'h3bb5 ;
			8'h32: sine = 16'h3c41 ;
			8'h33: sine = 16'h3cc4 ;
			8'h34: sine = 16'h3d3d ;
			8'h35: sine = 16'h3dad ;
			8'h36: sine = 16'h3e14 ;
			8'h37: sine = 16'h3e70 ;
			8'h38: sine = 16'h3ec4 ;
			8'h39: sine = 16'h3f0d ;
			8'h3a: sine = 16'h3f4d ;
			8'h3b: sine = 16'h3f83 ;
			8'h3c: sine = 16'h3fb0 ;
			8'h3d: sine = 16'h3fd2 ;
			8'h3e: sine = 16'h3feb ;
			8'h3f: sine = 16'h3ffa ;
			8'h40: sine = 16'h3fff ;
			8'h41: sine = 16'h3ffa ;
			8'h42: sine = 16'h3feb ;
			8'h43: sine = 16'h3fd2 ;
			8'h44: sine = 16'h3fb0 ;
			8'h45: sine = 16'h3f83 ;
			8'h46: sine = 16'h3f4d ;
			8'h47: sine = 16'h3f0d ;
			8'h48: sine = 16'h3ec4 ;
			8'h49: sine = 16'h3e70 ;
			8'h4a: sine = 16'h3e14 ;
			8'h4b: sine = 16'h3dad ;
			8'h4c: sine = 16'h3d3d ;
			8'h4d: sine = 16'h3cc4 ;
			8'h4e: sine = 16'h3c41 ;
			8'h4f: sine = 16'h3bb5 ;
			8'h50: sine = 16'h3b1f ;
			8'h51: sine = 16'h3a81 ;
			8'h52: sine = 16'h39da ;
			8'h53: sine = 16'h3929 ;
			8'h54: sine = 16'h3870 ;
			8'h55: sine = 16'h37ae ;
			8'h56: sine = 16'h36e4 ;
			8'h57: sine = 16'h3611 ;
			8'h58: sine = 16'h3535 ;
			8'h59: sine = 16'h3452 ;
			8'h5a: sine = 16'h3366 ;
			8'h5b: sine = 16'h3273 ;
			8'h5c: sine = 16'h3178 ;
			8'h5d: sine = 16'h3075 ;
			8'h5e: sine = 16'h2f6b ;
			8'h5f: sine = 16'h2e59 ;
			8'h60: sine = 16'h2d40 ;
			8'h61: sine = 16'h2c20 ;
			8'h62: sine = 16'h2afa ;
			8'h63: sine = 16'h29cc ;
			8'h64: sine = 16'h2899 ;
			8'h65: sine = 16'h275f ;
			8'h66: sine = 16'h261f ;
			8'h67: sine = 16'h24d9 ;
			8'h68: sine = 16'h238d ;
			8'h69: sine = 16'h223c ;
			8'h6a: sine = 16'h20e6 ;
			8'h6b: sine = 16'h1f8b ;
			8'h6c: sine = 16'h1e2a ;
			8'h6d: sine = 16'h1cc5 ;
			8'h6e: sine = 16'h1b5c ;
			8'h6f: sine = 16'h19ef ;
			8'h70: sine = 16'h187d ;
			8'h71: sine = 16'h1708 ;
			8'h72: sine = 16'h158f ;
			8'h73: sine = 16'h1413 ;
			8'h74: sine = 16'h1293 ;
			8'h75: sine = 16'h1111 ;
			8'h76: sine = 16'h0f8c ;
			8'h77: sine = 16'h0e05 ;
			8'h78: sine = 16'h0c7c ;
			8'h79: sine = 16'h0af0 ;
			8'h7a: sine = 16'h0963 ;
			8'h7b: sine = 16'h07d5 ;
			8'h7c: sine = 16'h0645 ;
			8'h7d: sine = 16'h04b5 ;
			8'h7e: sine = 16'h0323 ;
			8'h7f: sine = 16'h0192 ;
			8'h80: sine = 16'h0000 ;
			8'h81: sine = 16'hfe6e ;
			8'h82: sine = 16'hfcdd ;
			8'h83: sine = 16'hfb4b ;
			8'h84: sine = 16'hf9bb ;
			8'h85: sine = 16'hf82b ;
			8'h86: sine = 16'hf69d ;
			8'h87: sine = 16'hf510 ;
			8'h88: sine = 16'hf384 ;
			8'h89: sine = 16'hf1fb ;
			8'h8a: sine = 16'hf074 ;
			8'h8b: sine = 16'heeef ;
			8'h8c: sine = 16'hed6d ;
			8'h8d: sine = 16'hebed ;
			8'h8e: sine = 16'hea71 ;
			8'h8f: sine = 16'he8f8 ;
			8'h90: sine = 16'he783 ;
			8'h91: sine = 16'he611 ;
			8'h92: sine = 16'he4a4 ;
			8'h93: sine = 16'he33b ;
			8'h94: sine = 16'he1d6 ;
			8'h95: sine = 16'he075 ;
			8'h96: sine = 16'hdf1a ;
			8'h97: sine = 16'hddc4 ;
			8'h98: sine = 16'hdc73 ;
			8'h99: sine = 16'hdb27 ;
			8'h9a: sine = 16'hd9e1 ;
			8'h9b: sine = 16'hd8a1 ;
			8'h9c: sine = 16'hd767 ;
			8'h9d: sine = 16'hd634 ;
			8'h9e: sine = 16'hd506 ;
			8'h9f: sine = 16'hd3e0 ;
			8'ha0: sine = 16'hd2c0 ;
			8'ha1: sine = 16'hd1a7 ;
			8'ha2: sine = 16'hd095 ;
			8'ha3: sine = 16'hcf8b ;
			8'ha4: sine = 16'hce88 ;
			8'ha5: sine = 16'hcd8d ;
			8'ha6: sine = 16'hcc9a ;
			8'ha7: sine = 16'hcbae ;
			8'ha8: sine = 16'hcacb ;
			8'ha9: sine = 16'hc9ef ;
			8'haa: sine = 16'hc91c ;
			8'hab: sine = 16'hc852 ;
			8'hac: sine = 16'hc790 ;
			8'had: sine = 16'hc6d7 ;
			8'hae: sine = 16'hc626 ;
			8'haf: sine = 16'hc57f ;
			8'hb0: sine = 16'hc4e1 ;
			8'hb1: sine = 16'hc44b ;
			8'hb2: sine = 16'hc3bf ;
			8'hb3: sine = 16'hc33c ;
			8'hb4: sine = 16'hc2c3 ;
			8'hb5: sine = 16'hc253 ;
			8'hb6: sine = 16'hc1ec ;
			8'hb7: sine = 16'hc190 ;
			8'hb8: sine = 16'hc13c ;
			8'hb9: sine = 16'hc0f3 ;
			8'hba: sine = 16'hc0b3 ;
			8'hbb: sine = 16'hc07d ;
			8'hbc: sine = 16'hc050 ;
			8'hbd: sine = 16'hc02e ;
			8'hbe: sine = 16'hc015 ;
			8'hbf: sine = 16'hc006 ;
			8'hc0: sine = 16'hc001 ;
			8'hc1: sine = 16'hc006 ;
			8'hc2: sine = 16'hc015 ;
			8'hc3: sine = 16'hc02e ;
			8'hc4: sine = 16'hc050 ;
			8'hc5: sine = 16'hc07d ;
			8'hc6: sine = 16'hc0b3 ;
			8'hc7: sine = 16'hc0f3 ;
			8'hc8: sine = 16'hc13c ;
			8'hc9: sine = 16'hc190 ;
			8'hca: sine = 16'hc1ec ;
			8'hcb: sine = 16'hc253 ;
			8'hcc: sine = 16'hc2c3 ;
			8'hcd: sine = 16'hc33c ;
			8'hce: sine = 16'hc3bf ;
			8'hcf: sine = 16'hc44b ;
			8'hd0: sine = 16'hc4e1 ;
			8'hd1: sine = 16'hc57f ;
			8'hd2: sine = 16'hc626 ;
			8'hd3: sine = 16'hc6d7 ;
			8'hd4: sine = 16'hc790 ;
			8'hd5: sine = 16'hc852 ;
			8'hd6: sine = 16'hc91c ;
			8'hd7: sine = 16'hc9ef ;
			8'hd8: sine = 16'hcacb ;
			8'hd9: sine = 16'hcbae ;
			8'hda: sine = 16'hcc9a ;
			8'hdb: sine = 16'hcd8d ;
			8'hdc: sine = 16'hce88 ;
			8'hdd: sine = 16'hcf8b ;
			8'hde: sine = 16'hd095 ;
			8'hdf: sine = 16'hd1a7 ;
			8'he0: sine = 16'hd2c0 ;
			8'he1: sine = 16'hd3e0 ;
			8'he2: sine = 16'hd506 ;
			8'he3: sine = 16'hd634 ;
			8'he4: sine = 16'hd767 ;
			8'he5: sine = 16'hd8a1 ;
			8'he6: sine = 16'hd9e1 ;
			8'he7: sine = 16'hdb27 ;
			8'he8: sine = 16'hdc73 ;
			8'he9: sine = 16'hddc4 ;
			8'hea: sine = 16'hdf1a ;
			8'heb: sine = 16'he075 ;
			8'hec: sine = 16'he1d6 ;
			8'hed: sine = 16'he33b ;
			8'hee: sine = 16'he4a4 ;
			8'hef: sine = 16'he611 ;
			8'hf0: sine = 16'he783 ;
			8'hf1: sine = 16'he8f8 ;
			8'hf2: sine = 16'hea71 ;
			8'hf3: sine = 16'hebed ;
			8'hf4: sine = 16'hed6d ;
			8'hf5: sine = 16'heeef ;
			8'hf6: sine = 16'hf074 ;
			8'hf7: sine = 16'hf1fb ;
			8'hf8: sine = 16'hf384 ;
			8'hf9: sine = 16'hf510 ;
			8'hfa: sine = 16'hf69d ;
			8'hfb: sine = 16'hf82b ;
			8'hfc: sine = 16'hf9bb ;
			8'hfd: sine = 16'hfb4b ;
			8'hfe: sine = 16'hfcdd ;
			8'hff: sine = 16'hfe6e ;
	endcase
end
endmodule