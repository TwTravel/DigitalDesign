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
// Major Functions:	VGA DLA simulator
// modifed by BRL4 for SRAM; Displays a color grid 
// 320/240, 12 bit color
// VGA controller, PLL, and reset are from DE2 distribution CD
// --------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////
//
// Code Modified December 2008 by
// Steven Hochstadt (sdh78) and Eric Chen (cc459)
// for ECE 576 Final Project
// Information about this project can be found on the ECE576 course
// website at http://instruct1.cit.cornell.edu/courses/ece576/
//
//////////////////////////////////////////////////////////////////////
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
output/*inout*/	AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
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

//////////////////////////////////////////////////////////////////////
////////////////////////////////////
//DLA state machine variables
wire reset;
reg [17:0] addr_reg; //memory address register for SRAM
reg [15:0] data_reg; //memory data register  for SRAM
reg we ;		//write enable for SRAM
reg [3:0] state;	//state machine
reg [7:0] led;		//debug led register
reg [30:0] x_rand;	//shift registers for random number gen  
reg [28:0] y_rand;
reg last_count;

wire seed_low_bit, x_low_bit, y_low_bit; //rand low bits for SR
reg [3:0] sum; //neighbor sum
reg lock; //did we stay in sync?
reg memwait; //slow mem?
////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

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

assign	TD_RESET	=	1'b1;	//	Allow 27 MHz input
//assign	AUD_ADCLRCK	=	AUD_DACLRCK;
//assign	AUD_XCK		=	AUD_CTRL_CLK;

Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
wire scaled_VGA_CLK;
assign scaled_VGA_CLK = AUD_CTRL_CLK;

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
							
//for the m4k block
reg [9:0] m4k_raddr; //m4k block read address
reg [9:0] m4k_waddr; //m4k block write address
reg [35:0] m4k_data; //m4k block data
reg [9:0] m4kv_raddr; //m4k block for velocity
reg [9:0] m4kv_waddr;
reg [35:0] m4kv_data;
reg [9:0] m4k_tempaddr; //temp values used in state machine
reg [9:0] m4kv_tempaddr;
reg m4k_wren;
reg m4kv_wren;
wire [35:0] m4k_out; //position output from the m4k block
wire [35:0] m4kv_out; //velocity output from the m4k block 

//variables for calculating collisions
wire signed [17:0] y_velocity; 
wire signed [17:0] x_velocity; 
wire signed [17:0] x_ball, y_ball, delta_vx, delta_vy; 
wire signed [35:0] distance;
reg signed [20:0] count;
reg signed [17:0] x_temp;
reg signed [17:0] y_temp;
reg signed [17:0] vx_temp;
reg signed [17:0] vy_temp;
reg signed [17:0] delta_x_temp;
reg signed [17:0] delta_y_temp;
reg signed [17:0] delta_vx_temp;
reg signed [17:0] delta_vy_temp;

//variables for the state machine
reg [8:0] count_x, count_y;
reg signed [17:0] x_ball_1;
reg signed [17:0] y_ball_1;
reg signed [17:0] vx_ball_1;
reg signed [17:0] vy_ball_1;
reg signed [17:0] x_ball_2;
reg signed [17:0] y_ball_2;
reg signed [17:0] vx_ball_2;
reg signed [17:0] vy_ball_2;
reg signed [17:0] x_ball_3;
reg signed [17:0] y_ball_3;
reg signed [17:0] vx_ball_3;
reg signed [17:0] vy_ball_3;
reg signed [17:0] x_ball_4;
reg signed [17:0] y_ball_4;
reg signed [17:0] vx_ball_4;
reg signed [17:0] vy_ball_4;


assign x_velocity = m4kv_out[35:18]; // m4k block format
assign y_velocity = m4kv_out[17:0];
assign x_ball = m4k_out[35:18];
assign y_ball = m4k_out[17:0];

//LEDR shows the distance being calculated right now
//for debugging
assign LEDR = {distance[35], distance[26:10]}; 

//m4k block for the position							
m4k_test m4k_positions(
	.rdaddress(m4k_raddr),
	.wraddress(m4k_waddr),
	.clock(scaled_VGA_CLK),
	.data(m4k_data),
	.wren(m4k_wren),
	.q(m4k_out));
	
//m4k block for the velocity
m4kv m4k_velocities(
	.rdaddress(m4kv_raddr),
	.wraddress(m4kv_waddr),
	.clock(scaled_VGA_CLK),
	.data(m4kv_data),
	.wren(m4kv_wren),
	.q(m4kv_out));
	
//collision calculater instantiated	
collision_calculator collision( .x1(x_temp), 
								.x2(x_ball), 
								.y1(y_temp), 
								.y2(y_ball), 
								.vx1(vx_temp), 
								.vx2(x_velocity), 
								.vy1(vy_temp), 
								.vy2(y_velocity), 
								.delta_vx_out(delta_vx), 
								.delta_vy_out(delta_vy),
								.distance(distance),
								.clk(scaled_VGA_CLK));

// SRAM_control
assign SRAM_ADDR = addr_reg;
assign SRAM_DQ = (we)? 16'hzzzz : data_reg ;
assign SRAM_UB_N = 0;					// hi byte select enabled
assign SRAM_LB_N = 0;					// lo byte select enabled
assign SRAM_CE_N = 0;					// chip is enabled
assign SRAM_WE_N = we;					// write when ZERO
assign SRAM_OE_N = 0;					//output enable is overidden by WE

// Show SRAM on the VGA
assign  mVGA_R = {SRAM_DQ[15:12], 6'b0} ;
assign  mVGA_G = {SRAM_DQ[11:8], 6'b0} ;
assign  mVGA_B = {SRAM_DQ[7:4], 6'b0} ;

// DLA state machine
assign reset = ~KEY[0];
assign LEDG = delta_vx[7:0];

//right-most bit for rand number shift regs
//your basic XOR random # gen
assign x_low_bit = x_rand[27] ^ x_rand[30];
assign y_low_bit = y_rand[26] ^ y_rand[28];

//state names
parameter init=4'd0, removeballs = 4'd4, checkborder=4'd1, drawballs=4'd2, oneshot=4'd3, waitbeforedrawballs=4'd5;
parameter waitbeforeoneshot = 4'd6, waitbeforeremoveballs = 4'd7, checkcollisions = 4'd8, 
waitbeforecheckcollisions = 4'd9, collideotherball = 4'd10, waitbeforecollideotherball = 4'd11,
waitbeforem4k = 4'd12, waitbeforecheckborder = 4'd13, waitbeforecheckborder2 = 4'd14;

//number of balls we want to have in the system
//max of 1024 in the mif file, but is changable
`define num_balls 10'd50

always @ (posedge scaled_VGA_CLK)
begin
	if (reset)		//synch reset assumes KEY0 is held down 1/60 second
	begin
		//clear the screen
		m4k_wren<=1'b0;
		m4kv_wren<=1'b0;
		addr_reg <= {Coord_X[9:1],Coord_Y[9:1]} ;	// [17:0]
		we <= 1'b0;								//write some memory
		data_reg <= 16'b0;						//write all zeros (black)		
		state <= init;	//first state in regular state machine
		//reset the m4k blocks addresses
		m4k_raddr <= 10'b0;
		m4kv_raddr <= 10'b0;
		
		lock <= 1'b1;
		led <= 0;
		last_count <= 1'b0;
	end
	
	//modify display during sync
	else if (((~VGA_VS | ~VGA_HS) & KEY[3]))  //sync is active low; KEY3 is pause
	begin
		case(state)		
			init:
			begin
				if (lock)
				begin
					if (m4k_raddr <= `num_balls)
					begin
						addr_reg <= {x_ball[16:8],y_ball[16:8]}; // draw balls
						we <= 1'b0;
						data_reg <= 16'hFFFF; // nice solid color
						m4k_raddr <= m4k_raddr + 10'b1;
						m4kv_raddr <= m4kv_raddr + 10'b1;
					end
					//done initializing
					else 
					begin
						//reset the m4k read addresses and go to next state
						m4k_raddr <= 10'b0;
						m4kv_raddr <= 10'b0;
						m4k_waddr <= 10'b0;
						m4kv_waddr <= 10'b0;
						state <= waitbeforecheckborder;
						we <= 1'b1;
					end
				end
				else
				begin
					lock <= 1'b1;
					we<=1'b1;
				end
			end			
			//wait for the memory address to be ready
			waitbeforecheckborder:
			begin
				state <= checkborder;
			end
			//extra cycle needed for special case
			waitbeforecheckborder2:
			begin
				state <= waitbeforecheckborder;
				m4k_wren <= 1'b1;
				m4kv_wren <= 1'b1;
			end
			
			checkborder:
			begin 
				if (m4k_raddr < `num_balls)
				begin
					we<=1'b1;
					//upper left corner
					if (((-x_velocity) > (x_ball-18'sd1024)) && ((-y_velocity) > (y_ball-18'sd512)))
					begin
						m4kv_data <= {(-x_velocity), (-y_velocity)};
						m4k_data <= {18'd1024-(x_velocity+(x_ball-18'sd1024)), ((-y_velocity)-y_ball+18'd512)};
						m4k_raddr <= m4k_raddr + 32'b1;
						m4kv_raddr <= m4kv_raddr + 32'b1;
						m4k_waddr <= m4k_raddr;
						m4kv_waddr <= m4kv_raddr;
						m4k_wren <= 1'b1;
						m4kv_wren <= 1'b1;
						state <= waitbeforecheckborder;
					end
					//lower left corner
					else if (((-x_velocity) > (x_ball-18'sd1024)) && ((y_ball+y_velocity)>18'sd61184))
					begin
						m4kv_data <= {-x_velocity, -y_velocity};
						m4k_data <= {18'd1024-(x_velocity+(x_ball-18'sd1024)), (18'd61184-((y_ball+y_velocity)-y_ball))};
						m4k_raddr <= m4k_raddr + 32'b1;
						m4kv_raddr <= m4kv_raddr + 32'b1;
						m4k_waddr <= m4k_raddr;
						m4kv_waddr <= m4kv_raddr;
						m4k_wren <= 1'b1;
						m4kv_wren <= 1'b1;
						state <= waitbeforecheckborder;
					end
					//left edge but not at a corner
					else if (((-x_velocity) > (x_ball-18'sd1024)) && ((y_ball+y_velocity) >= 18'd768) && ((y_ball+y_velocity) <=18'd60928))
					begin
						m4kv_data <= {-x_velocity, y_velocity};
						m4k_data <= {18'd1024-(x_velocity+(x_ball-18'sd1024)), (y_ball+y_velocity)};
						m4k_raddr <= m4k_raddr + 32'b1;
						m4kv_raddr <= m4kv_raddr + 32'b1;
						m4k_waddr <= m4k_raddr;
						m4kv_waddr <= m4kv_raddr;
						m4k_wren <= 1'b1;
						m4kv_wren <= 1'b1;
						state <= waitbeforecheckborder;
					end
					//upper right corner
					else if (((x_ball+x_velocity)>18'd81408) &&((-y_velocity) > (y_ball-18'sd512)))
					begin
						m4kv_data <= {-x_velocity, -y_velocity};
						m4k_data <= {(18'd81408-((x_ball+x_velocity)-18'd81408)), (-y_velocity)-y_ball+18'd512};	
						m4k_raddr <= m4k_raddr + 32'b1;
						m4kv_raddr <= m4kv_raddr + 32'b1;
						m4k_waddr <= m4k_raddr;
						m4kv_waddr <= m4kv_raddr;
						m4k_wren <= 1'b1;
						m4kv_wren <= 1'b1;
						state <= waitbeforecheckborder;		
					end
					//lower right corner
					else if (((x_ball+x_velocity)>18'd81408) && ((y_ball+y_velocity)>18'sd60928))
					begin
						m4kv_data <= {-x_velocity, -y_velocity};
						m4k_data <= {(18'd81408-((x_ball+x_velocity)-18'd81408)), (18'd60928-((y_ball+y_velocity)-y_ball))};
						m4k_raddr <= m4k_raddr + 32'b1;
						m4kv_raddr <= m4kv_raddr + 32'b1;
						m4k_waddr <= m4k_raddr;
						m4kv_waddr <= m4kv_raddr;
						m4k_wren <= 1'b1;
						m4kv_wren <= 1'b1;
						state <= waitbeforecheckborder;			
					end
					//right edge but not at a corner
					else if (((x_ball+x_velocity)>18'd81408) && ((y_ball+y_velocity) >= 18'd1024) && ((y_ball+y_velocity) <=18'd60928))
					begin
						m4kv_data <= {-x_velocity, y_velocity};
						m4k_data <= {(18'd81408-((x_ball+x_velocity)-18'd81408)), y_ball+y_velocity};
						m4k_raddr <= m4k_raddr + 32'b1;
						m4kv_raddr <= m4kv_raddr + 32'b1;
						m4k_waddr <= m4k_raddr;
						m4kv_waddr <= m4kv_raddr;
						m4k_wren <= 1'b1;
						m4kv_wren <= 1'b1;
						state <= waitbeforecheckborder;
					end
					//upper edge but not at a corner
					else if (((x_ball+x_velocity) >= 18'd1024) &&((x_ball+x_velocity) <= 18'd81408) && ((-y_velocity) > (y_ball-18'sd512)))
					begin
						m4kv_data <= {x_velocity, -y_velocity};
						m4k_data <= {x_velocity+x_ball, (-y_velocity)-y_ball+18'd512};
						m4k_raddr <= m4k_raddr + 32'b1;
						m4kv_raddr <= m4kv_raddr + 32'b1;
						m4k_waddr <= m4k_raddr;
						m4kv_waddr <= m4kv_raddr;
						m4k_wren <= 1'b1;
						m4kv_wren <= 1'b1;
						state <= waitbeforecheckborder;
					end
					//lower edge but not a corner
					else if (((x_ball+x_velocity) >= 18'd1024) &&((x_ball+x_velocity) <= 18'd81408) && ((y_ball+y_velocity)>18'sd60928))
					begin
						m4kv_data <= {x_velocity, -y_velocity};
						m4k_data <= {x_velocity+x_ball, (18'd60928-((y_ball+y_velocity)-y_ball))};
						m4k_raddr <= m4k_raddr + 32'b1;
						m4kv_raddr <= m4kv_raddr + 32'b1;
						m4k_waddr <= m4k_raddr;
						m4kv_waddr <= m4kv_raddr;
						m4k_wren <= 1'b1;
						m4kv_wren <= 1'b1;
						state <= waitbeforecheckborder;
					end					
					//not at a corner or an edge
					else
					begin
						//no boundary problem, now check for collisions
						state <= waitbeforecheckcollisions;
						x_temp <= x_ball;
						y_temp <= y_ball;
						vx_temp <= x_velocity;
						vy_temp <= y_velocity;
						count <= 32'd0;
						m4k_wren <= 1'b0;
						m4kv_wren <= 1'b0;
						m4k_waddr <= m4k_raddr;
						m4kv_waddr <= m4kv_raddr;
					end
					
					
				end
				//if there are no more balls to check, go wait for the one shot
				else begin
					state <= waitbeforeoneshot;
					m4k_raddr <= 32'b0;
					m4kv_raddr <= 32'b0;
					m4k_waddr <= 32'b0;
					m4kv_waddr <= 32'b0;
					m4k_wren <= 1'b0;
					m4kv_wren <= 1'b0;
				end
			end
			
			waitbeforecheckcollisions: // for filling up the pipeline
			begin
				if (count == 21'd4)
				begin
					state <= checkcollisions;
				end
				else
				begin
					count <= count + 1'b1;
				end
				//4 stage pipe line
				m4k_raddr <= m4k_raddr + 10'b1;
				m4kv_raddr <= m4kv_raddr + 10'b1;
				x_ball_1 <= x_ball;
				y_ball_1 <= y_ball;
				vx_ball_1 <= x_velocity;
				vy_ball_1 <= y_velocity;
				x_ball_2 <= x_ball_1;
				y_ball_2 <= y_ball_1;
				vx_ball_2 <= vx_ball_1;
				vy_ball_2 <= vy_ball_1;
				x_ball_3 <= x_ball_2;
				y_ball_3 <= y_ball_2;
				vx_ball_3 <= vx_ball_2;
				vy_ball_3 <= vy_ball_2;
				x_ball_4 <= x_ball_3;
				y_ball_4 <= y_ball_3;
				vx_ball_4 <= vx_ball_3;
				vy_ball_4 <= vy_ball_3;
			end
			
			checkcollisions:
			begin
				//if there is a collision
				if ((distance[17:0] < 36'd512) && ((m4k_raddr - 10'd5) != m4k_waddr)) // -8'd1
				begin
					m4kv_wren <= 1'b1;
					m4k_wren <= 1'b1;
					//flop in the calculated new position and velocity
					m4kv_data <= {-delta_vx+vx_temp, -delta_vy+vy_temp};
					m4k_data <= {-delta_vx+x_temp+vx_temp, -delta_vy+y_temp+vy_temp};
					//store the current address away
					m4k_tempaddr <= m4k_waddr;
					m4kv_tempaddr <= m4kv_waddr;
					//update to the correct write address
					m4k_waddr <= m4k_raddr - 10'd5;
					m4kv_waddr <= m4kv_raddr - 10'd5;
					
					x_temp <= x_ball_4;
					y_temp <= y_ball_4;
					vx_temp <= vx_ball_4;
					vy_temp <= vy_ball_4;
					delta_vx_temp <= delta_vx;
					delta_vy_temp <= delta_vy;
					//go on to find the other ball involved in the collision
					state <= waitbeforecollideotherball;
					count <= 21'b0;
				end
				//no collision, last ball
				else if (m4k_raddr - 10'd5 == `num_balls - 1'b1)
				begin
				
					m4kv_data <= {vx_temp, vy_temp};
					m4k_data <= {vx_temp+x_temp, vy_temp+y_temp}; 
					m4k_raddr <= m4k_waddr + 32'b1;
					m4kv_raddr <= m4kv_waddr + 32'b1;
					state <= waitbeforecheckborder2;
				end
				//no collision, not the last ball
				else
				begin
					//keep the pipe line filled
					state <= checkcollisions;
					m4k_raddr <= m4k_raddr + 10'b1;
					m4kv_raddr <= m4kv_raddr + 10'b1;
					count <= 21'b0;
					x_ball_1 <= x_ball;
					y_ball_1 <= y_ball;
					vx_ball_1 <= x_velocity;
					vy_ball_1 <= y_velocity;
					x_ball_2 <= x_ball_1;
					y_ball_2 <= y_ball_1;
					vx_ball_2 <= vx_ball_1;
					vy_ball_2 <= vy_ball_1;
					x_ball_3 <= x_ball_2;
					y_ball_3 <= y_ball_2;
					vx_ball_3 <= vx_ball_2;
					vy_ball_3 <= vy_ball_2;
					x_ball_4 <= x_ball_3;
					y_ball_4 <= y_ball_3;
					vx_ball_4 <= vx_ball_3;
					vy_ball_4 <= vy_ball_3;
				end							
			end
			//wait for memory addresses to be ready
			waitbeforecollideotherball:
			begin
				state <= collideotherball;
			end
			//deal with the other ball involved in the collision
			collideotherball:
			begin
				if (lock)
				begin
					m4kv_wren <= 1'b1;
					m4k_wren <= 1'b1;
					//position and velocity updated
					m4kv_data <= {delta_vx_temp+vx_temp, delta_vy_temp+vy_temp};
					m4k_data <= {delta_vx_temp+x_temp+vx_temp, delta_vy_temp+y_temp+vy_temp};
					//return to the original ball so can go on to the next one in the addr
					m4k_waddr <= m4k_tempaddr;
					m4k_raddr <= m4k_tempaddr+32'd1;
					m4kv_waddr <= m4kv_tempaddr;
					m4kv_raddr <= m4kv_tempaddr+32'd1;
					//go back to check for border problems
					state <= waitbeforecheckborder;
				end
				else
				begin
					we <= 1'b1;
					lock <= 1'b1;
				end
			end
			
			waitbeforeremoveballs:
			begin
				if ((!KEY[1] || SW[0]) )
					state <= removeballs;
			end
			
			removeballs:
			begin
				//make sure m4k block write enable is off
				m4k_wren <= 1'b0;
				m4kv_wren <= 1'b0;
				//if lock and paused key not pressed
				if(lock && KEY[1])begin
					// a loop to fill SRAM with black dots
					addr_reg <= {count_x, count_y};					
					we <= 1'b0;						
					data_reg <= 16'h0000;
					if (count_y != 9'd239)	begin
						if (count_x != 9'd321) begin							
							count_x <= count_x + 32'b1;
						end
						else begin 
							count_y <= count_y + 32'b1;
							count_x <= 32'b0;
						end
						state <= removeballs;
					end
					else begin
						count_y <= 32'b0;
						m4k_raddr <= 32'b0;
						m4kv_raddr <= 32'b0;
						//everything in SRAM is removed, now go on and draw balls
						state <= waitbeforedrawballs;		
					end
				end
				else begin
					lock <= 1;
					m4k_wren <= 1'b0;
					m4kv_wren <= 1'b0;
					we <= 1'b1;
				end
			end
			//extra cycle for the m4k address to be ready
			waitbeforedrawballs:
			begin
				state <= drawballs;
			end
			
			drawballs:
			begin
				m4k_wren <= 1'b0;
				m4kv_wren <= 1'b0;
				if (lock)
				begin				
					 // actually drawing the balls or blanks (black)
					 //according to the value in the SRAM
					if (m4k_raddr < `num_balls) begin
						addr_reg <= {x_ball[16:8],y_ball[16:8]};
						m4k_raddr <= m4k_raddr + 32'b1;
						m4kv_raddr <= m4k_raddr + 32'b1;
						we <= 1'b0;
						data_reg <= 16'hFFFF; // nice solid color
						//go on to draw the next ball
						state <= waitbeforedrawballs;
					end
					else begin
						m4k_raddr <= 32'b0;
						m4kv_raddr <= 32'b0;
						m4k_waddr <= 32'b0;
						m4kv_waddr <= 32'b0;
						state <= waitbeforecheckborder;
					end
				end
				else begin
					lock <= 1'b1;
					we <= 1'b1;
				end
			end	
			
			waitbeforeoneshot:
			begin
				state <= oneshot;
			end
			// one shot when VGA vertical not sync
			oneshot:
			begin 
				if (VGA_VS && last_count == 1'b0)
				begin
					last_count <= 1'b1;
					state <= waitbeforeremoveballs;
					led <= led + 8'b1;
					
				end
				else if (!VGA_VS && last_count == 1'b1)
				begin
					last_count <= 1'b0;
				end
				else begin
					state <= oneshot;
				end
			end
			
			default:
			begin
				// default state is end state
				state <= oneshot;
			end				
		endcase
	end
	//show display when not blanking, 
	//which implies we=1 (not enabled); and use VGA module address
	else
	begin
		lock <= 1'b0; //clear lock if display starts because this destroys SRAM addr_reg
		addr_reg <= {Coord_X[9:1],Coord_Y[9:1]} ;
		we <= 1'b1;
		if (!VGA_VS && state == oneshot && last_count == 1)
		begin
			last_count <= 1'b0;
			state <= waitbeforeremoveballs;
		end
	end
end

endmodule //top module


// Collision calculation
// pipelined calculator takes 4 clock cycles
module collision_calculator(x1, x2, y1, y2, vx1, vx2, vy1, vy2, delta_vx_out, delta_vy_out, distance, clk);

input signed [17:0] x1, x2, y1, y2, vx1, vx2, vy1, vy2;
input clk;

// pipe lined calculation
output reg signed [17:0] delta_vx_out, delta_vy_out;
output reg [35:0] distance;
reg [35:0] distance1;


reg signed [35:0] v_dot_r_x, v_dot_r_y, v_dot_r, unit_vector_x_1, unit_vector_y_1, 
				  unit_vector_y_2, unit_vector_x_2, delta_x_1, delta_y_1, delta_x_2, delta_y_2,
				  delta_x_3, delta_y_3;
reg signed [71:0] temp_out_x, temp_out_y;

//equation applied in four clock cycles in order to do some pipe-lining
always @ (posedge clk)
begin
	// clk 1
	v_dot_r_x <= ((x1 - x2) * (vx1 - vx2));
	v_dot_r_y <= ((y1 - y2) * (vy1 - vy2));
	unit_vector_x_1 <= (x1 - x2);
	unit_vector_y_1 <= (y1 - y2);
	delta_x_1 <= ((x1 - x2)>0) ? (x1-x2):(x2-x1);
	delta_y_1 <= ((y1 - y2)>0) ? (y1-y2):(y2-y1);
	
	// clk 2
	v_dot_r <= v_dot_r_x + v_dot_r_y;
	unit_vector_x_2 <= unit_vector_x_1;
	unit_vector_y_2 <= unit_vector_y_1;
	delta_x_2 <= delta_x_1;
	delta_y_2 <= delta_y_1;
	distance1 <= (delta_x_1>delta_y_1) ? ((delta_x_1)+(delta_y_1>>1)) : ((delta_y_1)+(delta_x_1>>1));
	
	// clk 3
	//velocity boost if two balls are too close
	//this is done in hopes to separate two balls "sticking" together (?)
	//and to keep the energy level of the whole system up (?)
	//not sure if this really works...
	if ((distance1 >= 256) && (distance1 < (384))) begin
		temp_out_x <= (unit_vector_x_2 * v_dot_r) >>> 17;
		temp_out_y <= (unit_vector_y_2 * v_dot_r) >>> 17;
	end
	else begin
		temp_out_x <= (unit_vector_x_2 * v_dot_r) >>> 18;
		temp_out_y <= (unit_vector_y_2 * v_dot_r) >>> 18;
	end
	delta_x_3 <= delta_x_2;
	delta_y_3 <= delta_y_2;
	
	// clk 4
	delta_vx_out <= {temp_out_x[71], temp_out_x[16:0]};
	delta_vy_out <= {temp_out_y[71], temp_out_y[16:0]};
	distance <= (delta_x_3>delta_y_3) ? ((delta_x_3)+(delta_y_3>>1)) : ((delta_y_3)+(delta_x_3>>1));
end
endmodule

// Collision calculation - non-pipelined version
/*module collision_calculator(x1, x2, y1, y2, vx1, vx2, vy1, vy2, delta_vx_out, delta_vy_out, distance);

input signed [17:0] x1, x2, y1, y2, vx1, vx2, vy1, vy2;
output signed [17:0] delta_vx_out, delta_vy_out;
output [35:0] distance;


wire signed [35:0] v_dot_r_x, v_dot_r_y, v_dot_r, unit_vector_x, unit_vector_y, delta_x, delta_y;
wire signed [71:0] temp_out_x, temp_out_y;
assign v_dot_r_x = ((x1 - x2) * (vx1 - vx2));
assign v_dot_r_y = ((y1 - y2) * (vy1 - vy2));
assign v_dot_r = v_dot_r_x + v_dot_r_y;
assign unit_vector_x = (x1 - x2);
assign unit_vector_y = (y1 - y2);
assign temp_out_x = (unit_vector_x * v_dot_r) >>> 17;
assign temp_out_y = (unit_vector_y * v_dot_r) >>> 17;
assign delta_vx_out = {temp_out_x[71], temp_out_x[16:0]};
assign delta_vy_out = {temp_out_y[71], temp_out_y[16:0]};
assign delta_x = ((x1 - x2)>0) ? (x1-x2):(x2-x1);
assign delta_y = ((y1 - y2)>0) ? (y1-y2):(y2-y1);
assign distance = (delta_x>delta_y) ? ((delta_x)+(delta_y>>1)) : ((delta_y)+(delta_x>>1));
endmodule*/