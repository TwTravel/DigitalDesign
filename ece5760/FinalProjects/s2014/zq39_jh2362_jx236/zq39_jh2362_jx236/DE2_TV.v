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

  // //  7 segment LUT
  // SEG7_LUT_8 u0 
  // (
    // .oSEG0  (HEX0),
    // .oSEG1  (HEX1),
    // .oSEG2  (HEX2),
    // .oSEG3  (HEX3),
    // .oSEG4  (HEX4),
    // .oSEG5  (HEX5),
    // .oSEG6  (HEX6),
    // .oSEG7  (HEX7),
    // .iDIG   (DPDT_SW) 
  // );

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
    .iRed       (VGA_R_to_VGA_Ctrl), 
    .iGreen     (VGA_G_to_VGA_Ctrl),
    .iBlue      (VGA_B_to_VGA_Ctrl), 
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
  
  
reg [9:0] VGA_R_to_VGA_Ctrl;
reg [9:0] VGA_G_to_VGA_Ctrl;
reg [9:0] VGA_B_to_VGA_Ctrl;

//*****************************************************************
// definitions					
//*****************************************************************	
parameter PEN_RADIUS=3'd4;
parameter MIN_MOVING_DISTANCE=3'd5;
parameter MAX_MOVING_DISTANCE=3'd30;
parameter DETECT_MIN_INTERVAL=3'd2;
parameter PREPARE_TIME_IN_S=3'd3;
parameter GAMING_TIME_IN_S=3'd5;


wire reset = ~KEY[0];
  
  // Show m4k on the VGA
// -- use m4k a for state machine
// -- use m4k b for VGA refresh
wire mem_bit ; //current data from m4k to VGA
reg disp_bit ; // registered data from m4k to VGA
wire state_bit ; // current data from m4k to state machine
reg we ; // write enable for a
wire we_to_m4k = we; // write enable for a
reg [18:0] addr_reg ; // for a
wire [18:0] addr_reg_to_m4k = start_draw?{x_vga_line_out[9:0],y_vga_line_out[8:0]}:addr_reg;
reg data_reg ; // for a
wire data_reg_to_m4k=data_reg; // for a
vga_buffer display(
	.address_a (addr_reg_to_m4k) , 
	.address_b ({VGA_X[9:0],VGA_Y[8:0]}), // vga current address
	.clock (OSC_27),
	.data_a (data_reg_to_m4k),
	.data_b (1'b0), // never write on port b
	.wren_a (we_to_m4k),
	.wren_b (1'b0), // never write on port b
	.q_a (state_bit),
	.q_b (mem_bit) ); // data used to update VGA

// // DLA state machine

// //state names
reg [4:0] state;
parameter init=5'd0, init1=5'd1, init2=5'd2, init3=5'd3,calcVal=5'd4,
			writeVal=5'd5, writeVal1=5'd6,  writeVal2=5'd7,  writeVal3=5'd8, writeVal4=5'd9,
			fall=5'd10, fall1=5'd11, fall2=5'd12, fall3=5'd13, fall4=5'd14, fall5=5'd15, fall6=5'd16,
			fall7=5'd17, fall8=5'd18, fall9=5'd19, check_center=5'd20, check_center1=5'd21,
			check_center2=5'd22, check_center3=5'd23, check_center4=5'd24, check_center5=5'd25,
			check_radius=5'd26, check_radius1=5'd27, check_radius2=5'd28, check_radius3=5'd29,
			check_radius4=5'd30, check_radius5=5'd31;
always @ (negedge OSC_27)
begin
	// register the m4k output for better timing on VGA
	// negedge seems to work better than posedge
	disp_bit <= mem_bit;
end

wire [10:0] x_distance_2_xcenter = (VGA_X>=center_x)?(VGA_X-center_x):(center_x-VGA_X);
wire [10:0] y_distance_2_ycenter = (VGA_Y>=center_y)?(VGA_Y-center_y):(center_y-VGA_Y);

always @ (VGA_X ,VGA_Y)
begin
	if(disp_bit || egg_dect || VGA_Y==400) begin
		VGA_R_to_VGA_Ctrl <= {8'hFF,2'd0};
		VGA_G_to_VGA_Ctrl <= {8'h00,2'd0};
		VGA_B_to_VGA_Ctrl <= {8'h00,2'd0};
	end else if(detected) begin
		if((x_distance_2_xcenter*x_distance_2_xcenter+y_distance_2_ycenter*y_distance_2_ycenter)<=PEN_RADIUS*PEN_RADIUS) begin
			VGA_R_to_VGA_Ctrl <= {8'hFF,2'd0};
			VGA_G_to_VGA_Ctrl <= {8'h00,2'd0};
			VGA_B_to_VGA_Ctrl <= {8'h00,2'd0};
		end else begin
			VGA_R_to_VGA_Ctrl <= mVGA_R;
			VGA_G_to_VGA_Ctrl <= mVGA_G;
			VGA_B_to_VGA_Ctrl <= mVGA_B;
		end
	end else begin
		VGA_R_to_VGA_Ctrl <= mVGA_R;
		VGA_G_to_VGA_Ctrl <= mVGA_G;
		VGA_B_to_VGA_Ctrl <= mVGA_B;
	end
end

reg iniFin;
reg [18:0] addr_reg_old;
reg [18:0] addr_reg_old2;

reg no_hit;

wire refresh = ~KEY[3];
reg [9:0] x_scan_counter;
reg [8:0] y_scan_counter;
reg [31:0] fall_speed_counter;
reg [8:0] bottom_counter;
reg fall_done;


reg check_done;
reg [9:0] x_left;
reg [8:0] y_left;
reg [9:0] x_right;
reg [8:0] y_right;
reg [9:0] x_top;
reg [8:0] y_top;
reg [9:0] x_bottom;
reg [8:0] y_bottom;
reg [9:0] x_center1;
reg [8:0] y_center1;
reg [9:0] x_center2;
reg [8:0] y_center2;
reg [9:0] x_center;
reg [8:0] y_center;
reg [20:0] radius_squre_max;
reg [20:0] radius_squre_min;
reg [9:0] x_center_bottom;
reg [8:0] y_center_bottom;

always @ (posedge OSC_27) //OSC_27
begin
	// register the m4k output for better timing on VGA
	
	if (reset)		//synch reset assumes KEY0 is held down 1/60 second
	begin
		state <= calcVal;	//first state in regular state machine 
	end
	
	else if(refresh)
	begin
	 //clear the screen
		addr_reg <= {VGA_X[9:0],VGA_Y[8:0]} ;	// [17:0]
		addr_reg_old <= 0;
		addr_reg_old2 <= 0;
		we <= 1'b1;								//write some memory
		data_reg <= 1'b0;
		data_to_vga_line_buffer <= 0;
		state <= calcVal;	//first state in regular state machine 
		start_draw_line <= 1'b0;
		x_scan_counter <= 0;
		y_scan_counter <= 0;
		fall_speed_counter <= 0;
		check_done <= 0;
		bottom_counter <= 0;
		fall_done <= 0;
		
		x_left <= 640;
		y_left <= 0;
		x_right <= 0;
		y_right <= 0;
		x_top <= 0;
		y_top <= 480;
		x_bottom <= 0;
		y_bottom <= 0;
		x_center <= 0;
		y_center <= 0;
		y_center_bottom <= 0;
		
		radius_squre_max <= 0;
		radius_squre_min <= 1000000;
		no_hit <= 0;
	end
	
	//begin state machine to modify display 
	else
	begin
		case(state)
			calcVal:
			begin
				we <= 1'b0; //no memory write
				addr_reg <= {center_x_old2[9:0],center_y_old2[8:0]};
				
				

				if(ready_to_recoord&(game_state==game_start)) begin
					state <= writeVal;
					data_reg <= 1'd1;
				end else if(start_check) begin
					state <= check_center;
				end else if(start_fall& !fall_done) begin
					state <= fall;
					
					data_reg <= 1'd0;
				end else begin
					data_reg <= 1'd0;
				end
				
			end
			
			writeVal:
			begin
				addr_reg_old <= addr_reg;
				addr_reg_old2 <= addr_reg_old;
			
				we <= 1'b1; //write memory
				state <= writeVal1;
			end
			
			writeVal1: // finish memory write
			begin
				we <= 1'b0; 
				if(addr_reg_old[18:9]<=20 || addr_reg_old[8:0]<=20 ||  addr_reg_old2[18:9]<=20 ||  addr_reg_old2[8:0]<=20) begin
					state <= calcVal;
				end else begin
					state <= writeVal2;
				end
			end
			
			writeVal2: // write line on the screen
			begin
				we <=1'b1;
				start_draw_line <= 1'b1;
				state <= writeVal3;
			end
			
			writeVal3:
			begin
				state <= writeVal4;
			end
			
			writeVal4:
			begin
				if(vga_line_idle) begin
					we <= 1'd0;
					start_draw_line <= 1'd0;
					state <= calcVal;
				end
			end
			
			// move the ball
			fall:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				data_to_vga_line_buffer <= 0;
				// if(fall_speed_counter<1) begin
					// fall_speed_counter <= fall_speed_counter+1;
				// end else begin
					// fall_speed_counter <= 0;
					state <= fall1;
				// end
			end
			
			fall1:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				data_to_vga_line_buffer <= 0;
				state <= fall2;
			end
			
			fall2:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				data_to_vga_line_buffer <= 0;
				state <= fall3;
			end
			
			fall3:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				if(y_scan_counter==0) begin
					data_reg <= 0;
				end else begin
					data_reg <= data_from_vga_line_buffer;
				end
				data_to_vga_line_buffer <= state_bit;
				state <= fall4;
			end
			
			fall4:
			begin
				we <= 1'd1;
				addr_reg <= {x_scan_counter,y_scan_counter};
				state <= fall5;
			end
			
			fall5:
			begin
				we <= 1'd1;
				addr_reg <= {x_scan_counter,y_scan_counter};
				state <= fall6;
			end
			
			fall6:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 1;
				state <= fall7;
			end
			
			fall7:
			begin
				if(y_scan_counter<400) begin
					state <= fall;
					if(x_scan_counter<639) begin
						x_scan_counter <= x_scan_counter +1;
					end else begin
						x_scan_counter <= 0;
						y_scan_counter <= y_scan_counter +1;
						
					end
				end else if(y_scan_counter==400) begin
					x_scan_counter <= 0;
					y_scan_counter <= 0;
					state <= calcVal;
					bottom_counter <= bottom_counter +1;
					if(bottom_counter==400) begin
						fall_done <= 1;
					end
				end
			end
			
			// check the circle
			
			check_center:// check the center
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				state <= check_center1;
			end
			
			check_center1:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				state <= check_center2;
			end
			
			check_center2:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				state <= check_center3;
			end
			
			check_center3:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				if(state_bit) begin
					if(x_scan_counter>20&&x_scan_counter<620&&y_scan_counter>20&&y_scan_counter<460) begin
						if(x_scan_counter<=x_left) begin
							x_left <= x_scan_counter;
							y_left <= y_scan_counter;
						end
						if(x_scan_counter>=x_right) begin
							x_right <= x_scan_counter;
							y_right <= y_scan_counter;
						end
						if(y_scan_counter<=y_top) begin
							x_top <= x_scan_counter;
							y_top <= y_scan_counter;
						end
						if(y_scan_counter>=y_bottom) begin
							x_bottom <= x_scan_counter;
							y_bottom <= y_scan_counter;
						end				
						
						if(x_scan_counter==320) begin
							if(y_scan_counter>=y_center_bottom) begin
								y_center_bottom <= y_scan_counter;
							end
						end
					end
				end
				
				
				if(y_scan_counter<479) begin
					state <= check_center;
					if(x_scan_counter<639) begin
						x_scan_counter <= x_scan_counter +1;
					end else begin
						x_scan_counter <= 0;
						y_scan_counter <= y_scan_counter +1;
					end
				end else if(y_scan_counter==479) begin
					x_scan_counter <= 0;
					y_scan_counter <= 0;
					state <= check_center4;
				end
			end
			
			check_center4://get the center
			begin
				if(y_center_bottom!=0) begin
					bottom_counter <= y_center_bottom;
				end
				x_center1 <= (x_left>>1)+(x_right>>1);
				y_center1 <= (y_left>>1)+(y_right>>1);
				x_center2 <= (x_top>>1)+(x_bottom>>1);
				y_center2 <= (y_top>>1)+(y_bottom>>1);
				state <= check_center5;
			end
			
			check_center5:
			begin
				if(bottom_counter==0) begin
					no_hit <= 1;
				end
				x_center <= (x_center1>>1)+(x_center2>>1);
				y_center <= (y_center1>>1)+(y_center2>>1);
				state <= check_radius;
			end
			
			check_radius:// check the radius
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				state <= check_radius1;
			end
			
			check_radius1:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				state <= check_radius2;
			end
			
			check_radius2:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				state <= check_radius3;
			end
			
			check_radius3:
			begin
				we <= 1'd0;
				addr_reg <= {x_scan_counter,y_scan_counter};
				data_reg <= 0;
				if(state_bit) begin
					if(x_scan_counter>20&&x_scan_counter<620&&y_scan_counter>20&&y_scan_counter<460) begin
						if(dist_to_circle_center_squre>radius_squre_max) begin
							radius_squre_max <= dist_to_circle_center_squre;
						end
						if(dist_to_circle_center_squre<radius_squre_min) begin
							radius_squre_min <= dist_to_circle_center_squre;
						end
					end
				end
				
				
				if(y_scan_counter<479) begin
					state <= check_radius;
					if(x_scan_counter<639) begin
						x_scan_counter <= x_scan_counter +1;
					end else begin
						x_scan_counter <= 0;
						y_scan_counter <= y_scan_counter +1;
					end
				end else if(y_scan_counter==479) begin
					x_scan_counter <= 0;
					y_scan_counter <= 0;
					state <= check_radius4;
					check_done <= 1;
				end
			end
			
			check_radius4:
			begin
				state <= check_radius5;
			end
			
			check_radius5:
			begin
				state <= calcVal;
			end
		endcase
	end
end

wire [9:0] x_dist_to_circle_center = (x_scan_counter>x_center)?(x_scan_counter-x_center):(x_center-x_scan_counter);
wire [8:0] y_dist_to_circle_center = (y_scan_counter>y_center)?(y_scan_counter-y_center):(y_center-y_scan_counter);

wire [19:0] x_dist_to_circle_center_squre = x_dist_to_circle_center*x_dist_to_circle_center;
wire [19:0] y_dist_to_circle_center_squre = y_dist_to_circle_center*y_dist_to_circle_center;

wire [20:0] dist_to_circle_center_squre = x_dist_to_circle_center_squre+y_dist_to_circle_center_squre;






reg [17:0] ledr;
reg [8:0] ledg;

assign LED_RED = ledr;
assign LED_GREEN = ledg;

  
always@(posedge OSC_27) begin
	// if(start_check) begin
		// ledr[0] <= 1;
	// end
	if(DPDT_SW[16:15]==0) begin
		ledg[7:0] <= radius_squre_min[7:0];
		ledr <= radius_squre_min[20:8];
	end else if(DPDT_SW[16:15]==1) begin
		ledg[7:0] <= radius_squre_max[7:0];
		ledr <= radius_squre_max[20:8];
	end else if(DPDT_SW[16:15]==2) begin
		ledg[7:0] <= damage_t[7:0];
		ledr[12:0] <= damage_t[20:8];
		ledr[17:13] <= damage;
	end else if(DPDT_SW[16:15]==3) begin
		ledg <= fall_done;
		ledr <= life;
	end
	
	// ledg[0] <= detected;
	// if(ready_to_recoord) begin
		// ledg[1] <= ledg[1]^1'd1;
	// end
	// if(disp_bit) begin
		// ledg[2] <= ledg[2]^1'd1;
	// end
	// ledg[7:3] <= state;
end

reg data_to_vga_line_buffer;
wire data_from_vga_line_buffer;

vga_line_buffer vlb(
.clock(OSC_27),
.data(data_to_vga_line_buffer),
.rdaddress(x_scan_counter),
.wraddress(x_scan_counter),
.wren(we),
.q(data_from_vga_line_buffer)
);









reg start_draw_line;
wire start_draw = start_draw_line&(game_state==game_start);
wire [10:0] x1_in_to_vga_line, x2_in_to_vga_line, y1_in_to_vga_line, y2_in_to_vga_line;
wire vga_line_idle;
wire [10:0] x_vga_line_out;
wire [10:0] y_vga_line_out;

assign x1_in_to_vga_line = addr_reg_old[18:9];
assign x2_in_to_vga_line = addr_reg_old2[18:9];
assign y1_in_to_vga_line = addr_reg_old[8:0];
assign y2_in_to_vga_line = addr_reg_old2[8:0];

vga_line vl(
	.clk(OSC_27),
	.reset(refresh),

	.ix1(addr_reg_old[18:9]),
	.iy1(addr_reg_old[8:0]),
	.ix2(addr_reg_old2[18:9]),
	.iy2(addr_reg_old2[8:0]),

	.istart_draw(start_draw),

	.ox_out(x_vga_line_out),
	.oy_out(y_vga_line_out),

	.oidle(vga_line_idle)
);





//*****************************************************************
// update egg					
//*****************************************************************

reg [3:0] egg_choose;
reg egg_dect;

always@(posedge OSC_27) begin
	if(refresh) begin
	end else if(VGA_X>=270&&VGA_X<370&&VGA_Y>=380&&VGA_Y<460) begin
		addr_e_x <= VGA_X-270;
		addr_e_y <= VGA_Y-380;
		case(egg_choose)
			0: egg_dect <= data_e0;
			1: egg_dect <= data_e1;
			2: egg_dect <= data_e2;
			3: egg_dect <= data_e3;
			4: egg_dect <= data_e4;
			default: egg_dect <= data_e0;
		endcase
	end else begin
		egg_dect <= 1'd0;
	end
	
	if(life>15) begin
		egg_choose <= 0;
	end else if(life>10) begin
		egg_choose <= 1;
	end else if(life>5) begin
		egg_choose <= 2;
	end else if(life>0) begin
		egg_choose <= 3;
	end else begin
		egg_choose <= 4;
	end

	addr_e <= addr_e_y*100+addr_e_x;
end


reg [18:0] addr_e_x;
reg [18:0] addr_e_y;
reg [12:0] addr_e;
wire data_e0;

egg1 e1(
.address(addr_e),
.clock(OSC_27),
.data(1'd0),
.wren(1'd0),
.q(data_e0)
);

wire data_e1;

egg2 e2(
.address(addr_e),
.clock(OSC_27),
.data(1'd0),
.wren(1'd0),
.q(data_e1)
);

wire data_e2;

egg3 e3(
.address(addr_e),
.clock(OSC_27),
.data(1'd0),
.wren(1'd0),
.q(data_e2)
);

wire data_e3;

egg4 e4(
.address(addr_e),
.clock(OSC_27),
.data(1'd0),
.wren(1'd0),
.q(data_e3)
);

wire data_e4;

egg5 e5(
.address(addr_e),
.clock(OSC_27),
.data(1'd0),
.wren(1'd0),
.q(data_e4)
);


//*****************************************************************
// update life digit 1				
//*****************************************************************

// reg [1:0] life_digt1_choose;
// reg life_digt1_dect;

// always@(posedge OSC_27) begin
	// if(refresh) begin
	// end else if(VGA_X>=450&&VGA_X<510&&VGA_Y>=0&&VGA_Y<100) begin
		// addr_life_digt1_x <= VGA_X-270;
		// addr_life_digt1_y <= VGA_Y-380;
		// case(life_digt1_choose)
			// 0: life_digt1_dect <= data_digt_0;
			// 1: life_digt1_dect <= data_digt_1;
			// 2: life_digt1_dect <= data_digt_2;
			// default: life_digt1_dect <= data_digt_0;
		// endcase
		// addr_digt <= addr_life_digt1_y*60+addr_life_digt1_x;
	// end else begin
		// life_digt1_dect <= 1'd0;
	// end
	
	// if(life>=20) begin
		// life_digt1_choose <= 2;
	// end else if(life>=10) begin
		// life_digt1_choose <= 1;
	// end else begin
		// life_digt1_choose <= 0;
	// end

	
// end


// reg [18:0] addr_life_digt1_x;
// reg [18:0] addr_life_digt1_y;
// reg [12:0] addr_digt;
// wire data_digt_0;

// digt0 d0(
// .address(addr_digt),
// .clock(OSC_27),
// .data(1'd0),
// .wren(1'd0),
// .q(data_digt_0)
// );

// wire data_digt_1;

// digt1 d1(
// .address(addr_digt),
// .clock(OSC_27),
// .data(1'd0),
// .wren(1'd0),
// .q(data_digt_1)
// );

// wire data_digt_2;

// digt2 d2(
// .address(addr_digt),
// .clock(OSC_27),
// .data(1'd0),
// .wren(1'd0),
// .q(data_digt_2)
// );

// // wire data_digt_3;

// // digt3 d3(
// // .address(addr_digt),
// // .clock(OSC_27),
// // .data(1'd0),
// // .wren(1'd0),
// // .q(data_digt_3)
// // );
  
//*****************************************************************
// threshold setting							
//*****************************************************************




reg [7:0] U_th_high;
reg [7:0] V_th_high;
reg [7:0] U_th_low;
reg [7:0] V_th_low;




always@(posedge OSC_27) begin
	if(reset) begin
		U_th_high <= 8'd110;
		V_th_high <= 8'd110;
		U_th_low <= 8'd70;
		V_th_low <= 8'd70;
	end else begin
		if(~KEY[1]) begin 
			if(DPDT_SW[16]) begin//change red threshold
				if(DPDT_SW[17]==0) begin
					U_th_high <= DPDT_SW[7:0];
				end else begin
					U_th_low <= DPDT_SW[7:0];
				end
			end else begin//change green threshold
				if(DPDT_SW[17]==0) begin
					V_th_high <= DPDT_SW[7:0];
				end else begin
					V_th_low <= DPDT_SW[7:0];
				end
			end
		end
	end
	
	
	
	
end


//*****************************************************************
// YUV detection							
//*****************************************************************

wire detected;
wire [10:0] center_x;
wire [10:0] center_y;

wire detect_iter;

color_detector cd(
	.iclk(OSC_27),
	.ireset_n(TD_RESET),
	
	.icurrent_x(VGA_X),
	.icurrent_y(VGA_Y),
	
	.iU(mCb),
	.iV(mCr),
	
	
	.iU_th_high(U_th_high),
	.iV_th_high(V_th_high),
	.iU_th_low(U_th_low),
	.iV_th_low(V_th_low),
	
	.iradius(DETECT_MIN_INTERVAL),
	
	.odetected(detected),
	.ocenter_x(center_x),
	.ocenter_y(center_y),
	
	.detect_iter(detect_iter),
	.ledr()

);


  
  
  
//*****************************************************************
// tracking					
//*****************************************************************


reg [18:0] record_interval;
reg [10:0] center_x_old;
reg [10:0] center_y_old;
reg [10:0] center_x_old2;
reg [10:0] center_y_old2;
reg ready_to_recoord;

wire [10:0] x_moving_distance = (VGA_X>=center_x_old)?(VGA_X-center_x_old):(center_x_old-VGA_X);
wire [10:0] y_moving_distance = (VGA_Y>=center_y_old)?(VGA_Y-center_y_old):(center_y_old-VGA_Y);


always@(posedge OSC_27) begin
	if(reset) begin
		center_x_old <= 11'd0;
		center_y_old <= 11'd0;
		center_x_old2 <= 11'd0;
		center_y_old2 <= 11'd0;
		record_interval <= 19'd0;
		ready_to_recoord <= 1'd0;
	end else begin
		if(record_interval<19'd270000) begin
			record_interval <= record_interval+19'd1;
		end else begin
			record_interval <= 19'd0;
		
			center_x_old2 <= center_x;
			center_y_old2 <= center_y;
		end
	end
	
	center_x_old <= center_x_old2;
	center_y_old <= center_y_old2;
	
	if(center_x_old!=center_x_old2 || center_y_old!=center_y_old2) begin
		ready_to_recoord <= 1'd1;
	end else begin
		ready_to_recoord <= 1'd0;
	end
end
  

  
  
  
  
  
  
  
  
//*****************************************************************
// threshold display						
//*****************************************************************							

wire [3:0] ec1_hex0;
wire [3:0] ec1_hex1;
wire [3:0] ec1_hex2;
wire [3:0] ec2_hex0;
wire [3:0] ec2_hex1;
wire [3:0] ec2_hex2;
wire [3:0] ec3_hex1;
wire [3:0] ec3_hex2;
wire [7:0] in2ec1 = DPDT_SW[17]?U_th_low:U_th_high;
wire [7:0] in2ec2 = DPDT_SW[17]?V_th_low:V_th_high;
wire [7:0] in2ec3 = DPDT_SW[17];

Eightbit_3HEX_converter ec1(
	.in(in2ec1),
	.out2(ec1_hex2),
	.out1(ec1_hex1),
	.out0(ec1_hex0)
);
SEG7_LUT	red0 (	.oSEG(HEX0),.iDIG(ec1_hex0_t)	);
SEG7_LUT	red1 (	.oSEG(HEX1),.iDIG(ec1_hex1_t)	);
SEG7_LUT	red2 (	.oSEG(HEX2),.iDIG(ec1_hex2_t)	);

Eightbit_3HEX_converter ec2(
	.in(in2ec2),
	.out2(ec2_hex2),
	.out1(ec2_hex1),
	.out0(ec2_hex0)
);

SEG7_LUT	blue0 (	.oSEG(HEX3),.iDIG(ec2_hex0_t)	);
SEG7_LUT	blue1 (	.oSEG(HEX4),.iDIG(ec2_hex1_t)	);
SEG7_LUT	blue2 (	.oSEG(HEX5),.iDIG(ec2_hex2_t)	);

Eightbit_3HEX_converter ec3(
	.in(in2ec3),
	.out2(ec3_hex2),
	.out1(ec3_hex1),
	.out0()
);

SEG7_LUT	green1 (	.oSEG(HEX6),.iDIG(ec3_hex1_t)	);
SEG7_LUT	green2 (	.oSEG(HEX7),.iDIG(ec3_hex2_t)	);

reg [24:0] color_disp_counter;
reg [3:0] ec1_hex0_t;
reg [3:0] ec1_hex1_t;
reg [3:0] ec1_hex2_t;
reg [3:0] ec2_hex0_t;
reg [3:0] ec2_hex1_t;
reg [3:0] ec2_hex2_t;
reg [3:0] ec3_hex1_t;
reg [3:0] ec3_hex2_t;

always@(posedge OSC_27) begin
	if(reset) begin
		color_disp_counter <= 25'd0;
	end else begin
		if(color_disp_counter<25'd27000000) begin
			color_disp_counter <= color_disp_counter + 25'd1;
		end else begin
			color_disp_counter <= 25'd0;
		
			ec1_hex0_t <= ec1_hex0;
			ec1_hex1_t <= ec1_hex1;
			ec1_hex2_t <= ec1_hex2;
			ec2_hex0_t <= ec2_hex0;
			ec2_hex1_t <= ec2_hex1;
			ec2_hex2_t <= ec2_hex2;
			ec3_hex1_t <= ec3_hex1;
			ec3_hex2_t <= count_down;
		end
	end

end
  
  
  
  
//*****************************************************************
// game logic					
//*****************************************************************

reg [31:0] game_counter;
reg start_fall;
reg start_check;
reg [20:0] damage_t;
reg [4:0] damage;
reg signed [5:0] life;
reg win;

reg [2:0] count_down;


reg [3:0] game_state;
parameter game_ready=4'd0,game_start=4'd1,game_prep=4'd2,game_calc=4'd3;
parameter game_move=4'd4, game_end=4'd5, game_end2=4'd6;

always@(posedge OSC_27) begin
	if(reset) begin
		game_counter <= 0;
		start_fall <= 0;
		life <= 20;
		win <= 0;
		count_down <= 0;
	end else if(~KEY[2]) begin
		start_fall <= 0;
		start_check <= 0;
		damage <= 0;
		damage_t <= 0;
		game_counter <= 0;
		game_state <= game_end2;
		life <= 20;
		win <= 0;
		count_down <= 0;
	end else if(refresh) begin
		start_fall <= 0;
		start_check <= 0;
		damage <= 0;
		damage_t <= 0;
		game_counter <= 0;
		game_state <= game_ready;
		count_down <= 0;
	end else begin
		case(game_state)
			game_ready:
			begin
				game_state <= game_prep;
				count_down <= PREPARE_TIME_IN_S;
			end
			
			game_prep:
			begin
				if(game_counter<(32'd27000000*PREPARE_TIME_IN_S)) begin
					game_counter <= game_counter+1;
				end else begin
					game_state <= game_start;
					game_counter <= 0;
				end
				
				if(game_counter>(32'd27000000*(PREPARE_TIME_IN_S+1-count_down))) begin
					count_down <= count_down-1;
				end else if(game_counter==32'd27000000*PREPARE_TIME_IN_S) begin
					count_down <= GAMING_TIME_IN_S;
				end
			end
			
			game_start:
			begin
				if(game_counter<(32'd27000000*GAMING_TIME_IN_S)) begin
					game_counter <= game_counter+1;
				end else begin
					game_state <= game_calc;
					game_counter <= 0;
				end
				
				if(game_counter>=(32'd27000000*(GAMING_TIME_IN_S+1-count_down))) begin
					count_down <= count_down-1;
				end
			end
			
			game_calc:
			begin
				if(check_done) begin
					game_state <= game_move;
					start_check <= 0;
					
					casex(radius_squre_min)
						21'b1xxxxxxxxxxxxxxxxxxxx: damage_t=(radius_squre_max>>20);
						21'b01xxxxxxxxxxxxxxxxxxx: damage_t=(radius_squre_max>>19);
						21'b01xxxxxxxxxxxxxxxxxxx: damage_t=(radius_squre_max>>18);
						21'b0001xxxxxxxxxxxxxxxxx: damage_t=(radius_squre_max>>17);
						21'b00001xxxxxxxxxxxxxxxx: damage_t=(radius_squre_max>>16);
						21'b000001xxxxxxxxxxxxxxx: damage_t=(radius_squre_max>>15);
						21'b0000001xxxxxxxxxxxxxx: damage_t=(radius_squre_max>>14);
						21'b00000001xxxxxxxxxxxxx: damage_t=(radius_squre_max>>13);
						21'b000000001xxxxxxxxxxxx: damage_t=(radius_squre_max>>12);
						21'b0000000001xxxxxxxxxxx: damage_t=(radius_squre_max>>11);
						21'b00000000001xxxxxxxxxx: damage_t=(radius_squre_max>>10);
						21'b000000000001xxxxxxxxx: damage_t=(radius_squre_max>>9);
						21'b0000000000001xxxxxxxx: damage_t=(radius_squre_max>>8);
						21'b00000000000001xxxxxxx: damage_t=(radius_squre_max>>7);
						21'b000000000000001xxxxxx: damage_t=(radius_squre_max>>6);
						21'b0000000000000001xxxxx: damage_t=(radius_squre_max>>5);
						21'b00000000000000001xxxx: damage_t=(radius_squre_max>>4);
						21'b000000000000000001xxx: damage_t=(radius_squre_max>>3);
						21'b0000000000000000001xx: damage_t=(radius_squre_max>>2);
						21'b00000000000000000001x: damage_t=(radius_squre_max>>1);
						21'b000000000000000000001: damage_t=(radius_squre_max);
						default: damage_t=radius_squre_max;
					endcase
				end else begin
					start_check <= 1;
				end
			end
			
			game_move:
			begin
				casex(damage_t)
					21'b1xxxxxxxxxxxxxxxxxxxx: damage=0;
					21'b01xxxxxxxxxxxxxxxxxxx: damage=1;
					21'b001xxxxxxxxxxxxxxxxxx: damage=2;
					21'b0001xxxxxxxxxxxxxxxxx: damage=3;
					21'b00001xxxxxxxxxxxxxxxx: damage=4;
					21'b000001xxxxxxxxxxxxxxx: damage=5;
					21'b0000001xxxxxxxxxxxxxx: damage=6;
					21'b00000001xxxxxxxxxxxxx: damage=7;
					21'b000000001xxxxxxxxxxxx: damage=8;
					21'b0000000001xxxxxxxxxxx: damage=9;
					21'b00000000001xxxxxxxxxx: damage=10;
					21'b000000000001xxxxxxxxx: damage=11;
					21'b0000000000001xxxxxxxx: damage=12;
					21'b00000000000001xxxxxxx: damage=13;
					21'b000000000000001xxxxxx: damage=14;
					21'b0000000000000001xxxxx: damage=15;
					21'b00000000000000001xxxx: damage=16;
					21'b000000000000000001xxx: damage=17;
					21'b0000000000000000001xx: damage=18;
					21'b00000000000000000001x: damage=19;
					21'b000000000000000000001: damage=20;
					default: damage=0;
				endcase
					
				if(fall_done) begin
					game_state <= game_end;
					start_fall <= 0;
				end else if(disp_bit) begin
					start_fall <= 1;
				end else begin
					start_fall <= 0;
				end
			end
			
			game_end:
			begin
				if(!no_hit) begin
					life <= life-damage;
				end
				game_state <= game_end2;

			end
			
			game_end2:
			begin
				if(life<=0) begin
					win <= 1;
				end
			end
		endcase
	
	end
end

//*****************************************************************
// circle check				
//*****************************************************************


// wire [21:0] check_bottom;

// circle_check(
	// .i_clk(OSC_27),
	// .i_reset(refresh),
	// .i_chstart(start_check),
	// .i_loc_x(VGA_X),//VGA_X
	// .i_loc_y(VGA_Y),//VGA_Y
	// .i_disp_bit(disp_bit),
	// .o_done(check_done),
	// .r_diff(),
	// .o_damage(),//damage from 1 to 128
	// .o_bottom(check_bottom),//lower bits -- y, higher bits -- x
	// .o_left(),
	// .o_right()
// );






















  
  
    
  wire [9:0]  mVGA_R;
  wire [9:0]  mVGA_G;
  wire [9:0]  mVGA_B;
  wire [9:0] Red, Green, Blue;

  // Check RGB value of a pixel in the background image in ROM memory.
  // If it's 0, black, get RGB value from the camcorder; 
  // otherwise print white lines and letters on the screen
  // To get grayscale, replace the next three lines with the commented-out lines
  assign  mVGA_R = mRed;//( Red >> 2 ) + ( Green >> 1 ) + ( Blue >> 3 );
  assign  mVGA_G = mGreen;//( Red >> 2 ) + ( Green >> 1 ) + ( Blue >> 3 );
  assign  mVGA_B = mBlue;//( Red >> 2 ) + ( Green >> 1 ) + ( Blue >> 3 );

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
  );

endmodule