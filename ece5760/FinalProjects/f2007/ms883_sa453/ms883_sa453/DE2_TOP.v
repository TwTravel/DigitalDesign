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
output 	[6:0]	HEX0;					//	Seven Segment Digit 0
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
assign	HEX4		=	7'h00;
assign	HEX5		=	7'h00;
assign	HEX6		=	7'h00;
assign	HEX7		=	7'h00;

assign	LCD_ON		=	1'b1;
assign	LCD_BLON	=	1'b1;

//	All inout port turn to tri-state
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ		=	8'hzz;
//assign	SRAM_DQ		=	16'hzzzz;
assign	OTG_DATA	=	16'hzzzz;
assign	LCD_DATA	=	8'hzz;
assign	SD_DAT		=	1'bz;
assign	I2C_SDAT	=	1'bz;
assign	ENET_DATA	=	16'hzzzz;
//assign	AUD_ADCLRCK	=	1'bz;
assign	AUD_DACLRCK	=	1'bz;
assign	AUD_BCLK	=	1'bz;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;

/***************************************************************************************************/
wire [17:0] addr_reg; //memory address register for SRAM
wire [15:0] data_reg; //memory data register  for SRAM
wire we ;		//write enable for SRAM

wire		VGA_CTRL_CLK;
wire		AUD_CTRL_CLK;
wire [9:0]	mVGA_R;
wire [9:0]	mVGA_G;
wire [9:0]	mVGA_B;
wire [19:0]	mVGA_ADDR;			//video memory address
wire [9:0]  Coord_X, Coord_Y;	//display coods
wire		DLY_RST;
wire 		myReset;

assign	TD_RESET	=	1'b1;	//	Allow 27 MHz input
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

assign SRAM_WE_N = we;					// write when ZERO
assign SRAM_UB_N = 0;					// hi byte select enabled
assign SRAM_LB_N = 0;					// lo byte select enabled
assign SRAM_CE_N = 0;					// chip is enabled
assign SRAM_OE_N = 0;					//output enable is overidden by WE
assign SRAM_DQ	 =	~we ? data_reg:16'hzzzz;
assign SRAM_ADDR = addr_reg;

assign mVGA_R = {SRAM_DQ[15:12], 6'b0} ;
assign mVGA_G = {SRAM_DQ[11:8], 6'b0} ;
assign mVGA_B = {SRAM_DQ[7:4], 6'b0} ;

Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);


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


wire [17:0] nI,nJ,nK;
wire [17:0] vI,vJ,vK;
wire [17:0] uI,uJ,uK;
wire TransformDone;

wire [17:0] LookFromI, LookFromJ, LookFromK;
wire [17:0] LookToI, LookToJ, LookToK;
wire [17:0] UpVectApproxI, UpVectApproxJ, UpVectApproxK;
wire [17:0] D, H, F;
reg [17:0] rLookFromI, rLookFromJ, rLookFromK;
reg [17:0] rLookToI, rLookToJ, rLookToK;
reg [17:0] rUpVectApproxI, rUpVectApproxJ, rUpVectApproxK;
reg [17:0] rD, rH, rF; 

assign LookFromI = rLookFromI;
assign LookFromJ = rLookFromJ;
assign LookFromK = rLookFromK;
assign LookToI = rLookToI;
assign LookToJ = rLookToJ;
assign LookToK = rLookToK;
assign UpVectApproxI = rUpVectApproxI;
assign UpVectApproxJ = rUpVectApproxJ;
assign UpVectApproxK = rUpVectApproxK;
assign D = rD;
assign H = rH;
assign F = rF;

/***************************************************************
Transform module computes the N, V and U vectors which are used
for computation of the Tview and Tpers matrices. It takes the 
Camera position and orientation attributes as input.
***************************************************************/
Transform MS_transform(
			  .iClk(VGA_CTRL_CLK),
			  .iReset(~KEY[0]),
			  .iStart(1'b1),
			  .iLookFromI(LookFromI), 
			  .iLookFromJ(LookFromJ), 
			  .iLookFromK(LookFromK), 
			  .iLookToI(LookToI),
			  .iLookToJ(LookToJ),
			  .iLookToK(LookToK), 
			  .iUpVectApproxI(UpVectApproxI),
			  .iUpVectApproxJ(UpVectApproxJ),
			  .iUpVectApproxK(UpVectApproxK), 
			  .nI(nI),.nJ(nJ),.nK(nK),
			  .vI(vI),.vJ(vJ),.vK(vK),
			  .uI(uI),.uJ(uJ),.uK(uK),
			  .oDone(TransformDone)
			 );
/***************************************************************
End of Transform module
***************************************************************/

/***************************************************************
ComputeScreenCoord module computes the View Matrix and the 
Perspective Matrix. Finally the Tcamera matrix is computed and 
the world coordinates are multipled to it to obtain the Screen 
Coordinates. It takes the world coordinates, N, V, U, LookFrom 
vectors, and D, F, H distances as the input.
***************************************************************/
ComputeScreenCoord MS_ComputeScreenCoord(
						.iXv(Xw),
						.iYv(Yw),
						.iZv(Zw),
						.iUi(uI),
						.iUj(uJ),
						.iUk(uK),
						.iVi(vI),
						.iVj(vJ),
						.iVk(vK),
						.iNi(nI),
						.iNj(nJ),
						.iNk(nK),
						.iLookFromI(LookFromI), 
						.iLookFromJ(LookFromJ), 
				  		.iLookFromK(LookFromK), 
						.iD(D), 
				  		.iF(F), 
				  		.iH(H),
						.oX(Xs_temp),
						.oY(Ys_temp),
						.oZ(Zs)
					  );
/***************************************************************
End of ComputeScreenCoord module
***************************************************************/

/***************************************************************
control module is the central module which controls the flow of
vertex processing until it reaches the TriangleDrawer module. It
reads the world coordinates from the world ram. Then it stores
corresponding screen coordinates into the screen ram. It also 
reads from the face ram and writes the display coordinates to 
the display ram.
***************************************************************/
control   MS_control(  
			   .iClk(VGA_CTRL_CLK),
			   .iReset(~KEY[1]),
			   .oXw(Xw),.oYw(Yw),.oZw(Zw),
			   .iXs(Xs),.iYs(Ys),.iZs(Zs),
			   .oReady(ControlReady),
			   .iDisplayAddress(oAddress),
			   .oDisplayVertexRead(iRamData),
			   .iCameraPosChanged(TransformDone)
			 );
/***************************************************************
End of control module
***************************************************************/			

wire [9:0] x1 , y1 , x2, y2 ;
wire ready;
wire enable;
assign myReset = ~KEY[1];
reg [15:0] Color;

/***************************************************************
After the computation of the screen coordinates the pixels are 
sent to LineDrawer for plotting on the screen.
***************************************************************/
LineDrawer MS_LineDrawer(
				  .iClk(VGA_CTRL_CLK),
				  .iDrawEnable(enable),
				  .iX1(x1),
				  .iY1(y1),
				  .iX2(x2),
				  .iY2(y2),
				  .iColor(/*Color*/16'hFFFF),
				  .oReady(ready),
				  .iVGA_HS(VGA_HS),
				  .iVGA_VS(VGA_VS),
				  .oAddrReg(addr_reg),
				  .oWe(we),
				  .oDataReg(data_reg),
				  .oCoord_X(Coord_X),
				  .oCoord_Y(Coord_Y),
				  .iReset(myReset),
				);
/***************************************************************
End of LineDrawer module
***************************************************************/			

/***************************************************************
TriangleDrawer module draws each face of the object by reading 
the display ram and providing the pixels to line drawer join 
them accordingly.
***************************************************************/
TriangleDrawer MS_TriangleDrawer( 	
				.iClk(VGA_CTRL_CLK),
			   	.iReset(myReset), 
			   	.oDrawEnable(enable),
				.oX1(x1),
				.oY1(y1),
				.oX2(x2),
				.oY2(y2),
				.iReady(ready),
				.oAddress(oAddress),
				.iRamData(iRamData),
				.iControlReady(ControlReady)
				);
/***************************************************************
End of TriangleDrawer module
***************************************************************/				

wire [17:0] Xw,Yw,Zw;
wire [17:0] Xs,Ys,Zs;
wire ControlReady;

wire[4:0]  oAddress;
wire [63:0] iRamData;

reg	[17:0]	LEDR;					//	LED Red[17:0]
wire signed [17:0] Xs_temp,Ys_temp,X_tri,Y_tri;

assign Xs = X_tri + 18'ha0_00;
assign Ys = Y_tri + 18'hF0_00;

/* Scaling of the vertices is done here to make the object visible on the screen*/
Multiplier   mm1( .iA(18'ha0_00) ,
				  .iB(Xs_temp) , 
				  .oProduct(X_tri)
				);
				
Multiplier   mm2( .iA(18'hF0_00) ,
				  .iB(Ys_temp) , 
				  .oProduct(Y_tri)
				);

/*Displays the value of the parameter being changed by the user on the LED display*/
always @(posedge VGA_CTRL_CLK) begin
	if(SW[0]) begin
		LEDR<= nI;
	end
	else if(SW[1]) begin
		LEDR<= nJ;
	end
	else if(SW[2])begin
		LEDR<= nK;
	end
	else 
	if(SW[3]) begin
		LEDR<= UpVectApproxI;
	end
	else if(SW[4]) begin
		LEDR<= UpVectApproxJ;
	end
	else 
	if(SW[5]) begin
		LEDR<= UpVectApproxK;
	end
	else 
	if(SW[6]) begin
		LEDR<= vI;
	end
	else if(SW[7]) begin
		LEDR<= vJ;
	end
	else if (SW[8]) begin
		LEDR<= vK;
	end
	else
	if (SW[9]) begin
		LEDR<= uI;
	end 
	else if (SW[10]) begin
		LEDR<= uJ;
	end
	else if (SW[11]) begin
		LEDR<= uK;
	end
	else if (SW[12]) begin
		LEDR<= Xs;
	end
	else if (SW[13]) begin
		LEDR<= Ys;
	end
	else 
	begin
		LEDR<= Zs;
	end
		
end 
reg [3:0] Digit0,Digit1,Digit2,Digit3;

HexDigit DigitH0(HEX3,Digit0);
HexDigit DigitH1(HEX2, Digit1);
HexDigit DigitH2(HEX1, Digit2);
HexDigit DigitH3(HEX0, Digit3);

/*Displays the value of the parameter being changed by the user on the Seven Segment display*/
always @( CLOCK_50) begin
	case (SW[3:0] ) 
	4'd1: begin
		  Digit0 <= rD[15:12];
		  Digit1 <= rD[11:8];
		  Digit2 <= rD[7:4];
		  Digit3 <= rD[3:0];
		  end
	4'd2: begin
		  Digit0 <= rF[15:12];
		  Digit1 <= rF[11:8];
		  Digit2 <= rF[7:4];
		  Digit3 <= rF[3:0];
		  end
	4'd3: begin
		  Digit0 <= rH[15:12];
		  Digit1 <= rH[11:8];
		  Digit2 <= rH[7:4];
		  Digit3 <= rH[3:0];
		  end
	4'd4: begin
		  Digit0 <= rLookFromI[15:12];
		  Digit1 <= rLookFromI[11:8];
		  Digit2 <= rLookFromI[7:4];
		  Digit3 <= rLookFromI[3:0];
		  end
	4'd5: begin
		  Digit0 <= rLookFromJ[15:12];
		  Digit1 <= rLookFromJ[11:8];
		  Digit2 <= rLookFromJ[7:4];
		  Digit3 <= rLookFromJ[3:0];
		  end
	4'd6: begin
		  Digit0 <= rLookFromK[15:12];
		  Digit1 <= rLookFromK[11:8];
		  Digit2 <= rLookFromK[7:4];
		  Digit3 <= rLookFromK[3:0];
		  end
	4'd7: begin
		  Digit0 <= rLookToI[15:12];
		  Digit1 <= rLookToI[11:8];
		  Digit2 <= rLookToI[7:4];
		  Digit3 <= rLookToI[3:0];
		  end
	4'd8: begin
		  Digit0 <= rLookToJ[15:12];
		  Digit1 <= rLookToJ[11:8];
		  Digit2 <= rLookToJ[7:4];
		  Digit3 <= rLookToJ[3:0];
		  end
	4'd9: begin
		  Digit0 <= rLookToK[15:12];
		  Digit1 <= rLookToK[11:8];
		  Digit2 <= rLookToK[7:4];
		  Digit3 <= rLookToK[3:0];
		  end
	endcase
end

/*Logic to accept inputs from the user through switches and keys*/
always @ (negedge KEY[3]) begin
	case(SW[3:0])
	4'd0:	begin
		rLookFromI <= 18'h3_80;
		rLookFromJ <= 18'h4_80;
		rLookFromK <= 18'h5_00;
		rLookToI <= 18'h0_80;
		rLookToJ <= 18'h0_80;
		rLookToK <= 18'h0_80;
		rUpVectApproxI <= 18'h0_00;
		rUpVectApproxJ <= 18'h1_00;
		rUpVectApproxK <= 18'h0_00;
		rD <= 18'h4_00;
		rF <= 18'hA_00;
		rH <= 18'h0_B3;
	end
	4'd1:	begin
		if (rD < 18'h6_00 & SW[17]) begin
			rD <= rD + 18'h0_80;
		end
		else if (rD > 18'h1_00 & ~SW[17]) begin
			rD <= rD - 18'h0_80;
		end
	end
	4'd2:	begin
		if (rF < 18'h14_00 & SW[17]) begin
			rF <= rF + 18'h0_80;
		end
		else if (rF > 18'h1_00 & ~SW[17]) begin
			rF <= rF - 18'h0_80;
		end
	end
	4'd3:	begin
		if (rH < 18'hA_00 & SW[17]) begin
			rH <= rH + 18'h0_80;
		end
		else if (rH > 18'h0_19 & ~SW[17]) begin
			rH <= rH - 18'h0_80;
		end
	end	
	4'd4:	begin
		if (rLookFromI < 18'hA_00 & SW[17]) begin
			rLookFromI <= rLookFromI + 18'h0_80;
		end
		else if (rLookFromI > 18'h0_19 & ~SW[17]) begin
			rLookFromI <= rLookFromI - 18'h0_80;
		end
	end	
	4'd5:	begin
		if (rLookFromJ < 18'hA_00 & SW[17]) begin
			rLookFromJ <= rLookFromJ + 18'h0_80;
		end
		else if (rLookFromJ > 18'h0_19 & ~SW[17]) begin
			rLookFromJ <= rLookFromJ - 18'h0_80;
		end
	end	
	4'd6:	begin
		if (rLookFromK < 18'hA_00 & SW[17]) begin
			rLookFromK <= rLookFromK + 18'h0_80;
		end
		else if (rLookFromK > 18'h0_19 & ~SW[17]) begin
			rLookFromK <= rLookFromK - 18'h0_80;
		end
	end	
	4'd7:	begin
		if (rLookToI < 18'hA_00 & SW[17]) begin
			rLookToI <= rLookToI + 18'h0_80;
		end
		else if (rLookToI > 18'h0_19 & ~SW[17]) begin
			rLookToI <= rLookToI - 18'h0_80;
		end
	end	
	4'd8:	begin
		if (rLookToJ < 18'hA_00 & SW[17]) begin
			rLookToJ <= rLookToJ + 18'h0_80;
		end
		else if (rLookToJ > 18'h0_19 & ~SW[17]) begin
			rLookToJ <= rLookToJ - 18'h0_80;
		end
	end	
	4'd9:	begin
		if (rLookToK < 18'hA_00 & SW[17]) begin
			rLookToK <= rLookToK + 18'h0_80;
		end
		else if (rLookToK > 18'h0_19 & ~SW[17]) begin
			rLookToK <= rLookToK - 18'h0_80;
		end
	end	
	4'd10:	begin
		if (rUpVectApproxI < 18'hA_00 & SW[17]) begin
			rUpVectApproxI <= rUpVectApproxI + 18'h0_80;
		end
		else if (rUpVectApproxI > 18'h0_19 & ~SW[17]) begin
			rUpVectApproxI <= rUpVectApproxI - 18'h0_80;
		end
	end	
	4'd11:	begin
		if (rUpVectApproxJ < 18'hA_00 & SW[17]) begin
			rUpVectApproxJ <= rUpVectApproxJ + 18'h0_80;
		end
		else if (rUpVectApproxJ > 18'h0_19 & ~SW[17]) begin
			rUpVectApproxJ <= rUpVectApproxJ - 18'h0_80;
		end
	end	
	4'd12:	begin
		if (rUpVectApproxK < 18'hA_00 & SW[17]) begin
			rUpVectApproxK <= rUpVectApproxK + 18'h0_80;
		end
		else if (rUpVectApproxK > 18'h0_19 & ~SW[17]) begin
			rUpVectApproxK <= rUpVectApproxK - 18'h0_80;
		end
	end	
	
	
	endcase
end

/******************************************************************************************/
endmodule