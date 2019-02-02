
`include "header.vh"

module DE2_TOP (
    // Clock Input
    input         CLOCK_27,    // 27 MHz
    input         CLOCK_50,    // 50 MHz
    input         EXT_CLOCK,   // External Clock
    // Push Button
    input  [3:0]  KEY,         // Pushbutton[3:0]
    // DPDT Switch
    input  [17:0] SW,          // Toggle Switch[17:0]
    // 7-SEG Display
    output [6:0]  HEX0,        // Seven Segment Digit 0
    output [6:0]  HEX1,        // Seven Segment Digit 1
    output [6:0]  HEX2,        // Seven Segment Digit 2
    output [6:0]  HEX3,        // Seven Segment Digit 3
    output [6:0]  HEX4,        // Seven Segment Digit 4
    output [6:0]  HEX5,        // Seven Segment Digit 5
    output [6:0]  HEX6,        // Seven Segment Digit 6
    output [6:0]  HEX7,        // Seven Segment Digit 7
    // LED
    output [8:0]  LEDG,        // LED Green[8:0]
    output [17:0] LEDR,        // LED Red[17:0]
    // UART
    output        UART_TXD,    // UART Transmitter
    input         UART_RXD,    // UART Receiver
    // IRDA
    output        IRDA_TXD,    // IRDA Transmitter
    input         IRDA_RXD,    // IRDA Receiver
    
    // SDRAM Interface
    
    inout  [15:0] DRAM_DQ,     // SDRAM Data bus 16 Bits
    output [11:0] DRAM_ADDR,   // SDRAM Address bus 12 Bits
    output        DRAM_LDQM,   // SDRAM Low-byte Data Mask 
    output        DRAM_UDQM,   // SDRAM High-byte Data Mask
    output        DRAM_WE_N,   // SDRAM Write Enable
    output        DRAM_CAS_N,  // SDRAM Column Address Strobe
    output        DRAM_RAS_N,  // SDRAM Row Address Strobe
    output        DRAM_CS_N,   // SDRAM Chip Select
    output        DRAM_BA_0,   // SDRAM Bank Address 0
    output        DRAM_BA_1,   // SDRAM Bank Address 0
    output        DRAM_CLK,    // SDRAM Clock
    output        DRAM_CKE,    // SDRAM Clock Enable
    
    // Flash Interface
    inout  [7:0]  FL_DQ,       // FLASH Data bus 8 Bits
    output [21:0] FL_ADDR,     // FLASH Address bus 22 Bits
    output        FL_WE_N,     // FLASH Write Enable
    output        FL_RST_N,    // FLASH Reset
    output        FL_OE_N,     // FLASH Output Enable
    output        FL_CE_N,     // FLASH Chip Enable
    // SRAM Interface
    inout  [15:0] SRAM_DQ,     // SRAM Data bus 16 Bits
    output [17:0] SRAM_ADDR,   // SRAM Address bus 18 Bits
    output        SRAM_UB_N,   // SRAM High-byte Data Mask 
    output        SRAM_LB_N,   // SRAM Low-byte Data Mask 
    output        SRAM_WE_N,   // SRAM Write Enable
    output        SRAM_CE_N,   // SRAM Chip Enable
    output        SRAM_OE_N,   // SRAM Output Enable
    // ISP1362 Interface
    inout  [15:0] OTG_DATA,    // ISP1362 Data bus 16 Bits
    output [1:0]  OTG_ADDR,    // ISP1362 Address 2 Bits
    output        OTG_CS_N,    // ISP1362 Chip Select
    output        OTG_RD_N,    // ISP1362 Write
    output        OTG_WR_N,    // ISP1362 Read
    output        OTG_RST_N,   // ISP1362 Reset
    output        OTG_FSPEED,  // USB Full Speed, 0 = Enable, Z = Disable
    output        OTG_LSPEED,  // USB Low Speed,  0 = Enable, Z = Disable
    input         OTG_INT0,    // ISP1362 Interrupt 0
    input         OTG_INT1,    // ISP1362 Interrupt 1
    input         OTG_DREQ0,   // ISP1362 DMA Request 0
    input         OTG_DREQ1,   // ISP1362 DMA Request 1
    output        OTG_DACK0_N, // ISP1362 DMA Acknowledge 0
    output        OTG_DACK1_N, // ISP1362 DMA Acknowledge 1
    // LCD Module 16X2
    inout  [7:0]  LCD_DATA,    // LCD Data bus 8 bits
    output        LCD_ON,      // LCD Power ON/OFF
    output        LCD_BLON,    // LCD Back Light ON/OFF
    output        LCD_RW,      // LCD Read/Write Select, 0 = Write, 1 = Read
    output        LCD_EN,      // LCD Enable
    output        LCD_RS,      // LCD Command/Data Select, 0 = Command, 1 = Data
    // SD Card Interface
    inout         SD_DAT,      // SD Card Data
    inout         SD_DAT3,     // SD Card Data 3
    inout         SD_CMD,      // SD Card Command Signal
    output        SD_CLK,      // SD Card Clock
    // I2C
    inout         I2C_SDAT,    // I2C Data
    output        I2C_SCLK,    // I2C Clock
    // PS2
    input         PS2_DAT,     // PS2 Data
    input         PS2_CLK,     // PS2 Clock
    // USB JTAG link
    input         TDI,         // CPLD -> FPGA (data in)
    input         TCK,         // CPLD -> FPGA (clk)
    input         TCS,         // CPLD -> FPGA (CS)
    output        TDO,         // FPGA -> CPLD (data out)
    // VGA
    output        VGA_CLK,     // VGA Clock
    output        VGA_HS,      // VGA H_SYNC
    output        VGA_VS,      // VGA V_SYNC
    output        VGA_BLANK,   // VGA BLANK
    output        VGA_SYNC,    // VGA SYNC
    output [9:0]  VGA_R,       // VGA Red[9:0]
    output [9:0]  VGA_G,       // VGA Green[9:0]
    output [9:0]  VGA_B,       // VGA Blue[9:0]
    // Ethernet Interface
    inout  [15:0] ENET_DATA,   // DM9000A DATA bus 16Bits
    output        ENET_CMD,    // DM9000A Command/Data Select, 0 = Command, 1 = Data
    output        ENET_CS_N,   // DM9000A Chip Select
    output        ENET_WR_N,   // DM9000A Write
    output        ENET_RD_N,   // DM9000A Read
    output        ENET_RST_N,  // DM9000A Reset
    input         ENET_INT,    // DM9000A Interrupt
    output        ENET_CLK,    // DM9000A Clock 25 MHz
    // Audio CODEC
    inout         AUD_ADCLRCK, // Audio CODEC ADC LR Clock
    input         AUD_ADCDAT,  // Audio CODEC ADC Data
    inout         AUD_DACLRCK, // Audio CODEC DAC LR Clock
    output        AUD_DACDAT,  // Audio CODEC DAC Data
    inout         AUD_BCLK,    // Audio CODEC Bit-Stream Clock
    output        AUD_XCK,     // Audio CODEC Chip Clock
    // TV Decoder
    input  [7:0]  TD_DATA,     // TV Decoder Data bus 8 bits
    input         TD_HS,       // TV Decoder H_SYNC
    input         TD_VS,       // TV Decoder V_SYNC
    output        TD_RESET,    // TV Decoder Reset
    // GPIO
    inout  [35:0] GPIO_0,      // GPIO Connection 0
    inout  [35:0] GPIO_1       // GPIO Connection 1
);
/*
   //Turn off all displays.
   assign HEX0 = 7'h7F;
   assign HEX1 = 7'h7F;
   assign HEX2 = 7'h7F;
   assign HEX3 = 7'h7F;
   assign HEX4 = 7'h7F;
   assign HEX5 = 7'h7F;
   assign HEX6 = 7'h7F;
   assign HEX7 = 7'h7F;
   assign LEDR = 18'h0;
   assign LEDG = 9'h0;
*/
   //Set all GPIO to tri-state.
   assign GPIO_0 = 36'hzzzzzzzzz;
   assign GPIO_1 = 36'hzzzzzzzzz;

   //Disable audio codec.
   assign AUD_DACDAT = 1'b0;
   assign AUD_XCK    = 1'b0;
/*
   //Disable DRAM.
   assign DRAM_ADDR  = 12'h0;
   assign DRAM_BA_0  = 1'b0;
   assign DRAM_BA_1  = 1'b0;
   assign DRAM_CAS_N = 1'b1;
   assign DRAM_CKE   = 1'b0;
   assign DRAM_CLK   = 1'b0;
   assign DRAM_CS_N  = 1'b1;
   assign DRAM_DQ    = 16'hzzzz;
   assign DRAM_LDQM  = 1'b0;
   assign DRAM_RAS_N = 1'b1;
   assign DRAM_UDQM  = 1'b0;
   assign DRAM_WE_N  = 1'b1;
   */

   //Disable Ethernet.
   assign ENET_CLK   = 1'b0;
   assign ENET_CS_N  = 1'b1;
   assign ENET_CMD   = 1'b0;
   assign ENET_DATA  = 16'hzzzz;
   assign ENET_RD_N  = 1'b1;
   assign ENET_RST_N = 1'b1;
   assign ENET_WR_N  = 1'b1;

   //Disable flash.
   assign FL_ADDR  = 22'h0;
   assign FL_CE_N  = 1'b1;
   assign FL_DQ    = 8'hzz;
   assign FL_OE_N  = 1'b1;
   assign FL_RST_N = 1'b1;
   assign FL_WE_N  = 1'b1;

   //Disable LCD.
   assign LCD_BLON = 1'b0;
   assign LCD_DATA = 8'hzz;
   assign LCD_EN   = 1'b0;
   assign LCD_ON   = 1'b0;
   assign LCD_RS   = 1'b0;
   assign LCD_RW   = 1'b0;

   //Disable OTG.
   assign OTG_ADDR    = 2'h0;
   assign OTG_CS_N    = 1'b1;
   assign OTG_DACK0_N = 1'b1;
   assign OTG_DACK1_N = 1'b1;
   assign OTG_FSPEED  = 1'b1;
   assign OTG_DATA    = 16'hzzzz;
   assign OTG_LSPEED  = 1'b1;
   assign OTG_RD_N    = 1'b1;
   assign OTG_RST_N   = 1'b1;
   assign OTG_WR_N    = 1'b1;

   //Disable SDRAM.
   assign SD_DAT = 1'bz;
   assign SD_CLK = 1'b0;

	// SRAM_control
	
	wire [17:0] addr_reg; //memory address register for SRAM
	wire [15:0] data_reg; //memory data register  for SRAM
	wire we ;		//write enable for SRAM
	
	assign SRAM_ADDR = addr_reg;
	assign SRAM_DQ = (we)? data_reg : 16'hzzzz ;
	assign SRAM_UB_N = 0;					// hi byte select enabled
	assign SRAM_LB_N = 0;					// lo byte select enabled
	assign SRAM_CE_N = 0;					// chip is enabled
	assign SRAM_WE_N = ~we;					// write when ONE
	assign SRAM_OE_N = 0;					//output enable is overidden by WE
/*
   //Disable VGA.
   assign VGA_CLK   = 1'b0;
   assign VGA_BLANK = 1'b0;
   assign VGA_SYNC  = 1'b0;
   assign VGA_HS    = 1'b0;
   assign VGA_VS    = 1'b0;
   assign VGA_R     = 10'h0;
   assign VGA_G     = 10'h0;
   assign VGA_B     = 10'h0;
*/
   //Disable all other peripherals.
   assign I2C_SCLK = 1'b0;
   assign IRDA_TXD = 1'b0;
   assign TD_RESET = 1'b1;
   assign TDO = 1'b0;
   assign UART_TXD = 1'b0;
   
   wire DLY_RST;
   //assign DLY_RST = 1'b1;
   
   /*
	NiosTimer MyNios(
				.clk(CPU_CLK),
				.reset_n(KEY[0]),
				
				// the_AckNewBall
                .out_port_from_the_AckNewBall(AckNewBall),							
				// the_Color
				.out_port_from_the_Color(Color),
				// the_Completed
				.in_port_to_the_Completed(Completed),
				// the_Draw
				.out_port_from_the_Draw(Draw),
				// the_DrawStyle
				.out_port_from_the_DrawStyle(DrawStyle),
				// the_NewBall
                .in_port_to_the_NewBall(NewBall),
                // the_Prepare
                .out_port_from_the_Prepare(Prepare),
                // the_Ready
                .in_port_to_the_Ready(Ready),
				// the_Reset
				.in_port_to_the_Reset(),
				// the_SecondParameter
				.out_port_from_the_SecondParameter(SecondParameter),
				// the_XFirst
				.out_port_from_the_XFirst(XFirst),
				// the_YFirst
				.out_port_from_the_YFirst(YFirst),
				
				.zs_addr_from_the_sdram(DRAM_ADDR),
				.zs_ba_from_the_sdram({DRAM_BA_1, DRAM_BA_0}),
				.zs_cas_n_from_the_sdram(DRAM_CAS_N),
				.zs_cke_from_the_sdram(DRAM_CKE),
				.zs_cs_n_from_the_sdram(DRAM_CS_N),
				.zs_dq_to_and_from_the_sdram(DRAM_DQ),
				.zs_dqm_from_the_sdram({DRAM_UDQM, DRAM_LDQM}),
				.zs_ras_n_from_the_sdram(DRAM_RAS_N),
				.zs_we_n_from_the_sdram(DRAM_WE_N)
				);
	*/
   
   wire		VGA_CTRL_CLK;
   wire		AUD_CTRL_CLK;
   wire [9:0]	mVGA_R;
   wire [9:0]	mVGA_G;
   wire [9:0]	mVGA_B;
   wire [19:0]	mVGA_ADDR;			//video memory address
   wire [9:0] Coord_X, Coord_Y;
   
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
							.iRST_N(DLY_RST));
 
	
	wire n_reset;
		assign n_reset = KEY[0];
	
	reg [`pixel - 1 : 0] 
		p1_x, p1_y, 
		p2_x, p2_y, 
		p3_x, p3_y;
		
	reg [`color - 1 : 0] 
		p1_z, p1_r, p1_g, p1_b,
		p2_z, p2_r, p2_g, p2_b,
		p3_z, p3_r, p3_g, p3_b;
	
	wire screenReading ;
		assign screenReading = VGA_VS & VGA_HS;
	
	wire [17:0] tAddr;
	wire [15:0] tData;
	wire tWrite, completed;
	
	reg r_n_pause;
	reg r_n_reset;
	reg r_drawing;
	
	reg[`float - 1 : 0] r_n_x, r_n_y, r_n_z;
	/*
	wire z_existence;
		assign z_existence = ~(SRAM_DQ[15 - 3 * `color : 15 - 4 * `color + 1] == `color'b0);
	*/
	MemoryTriangleControler memoryTriangleControler(
	
		.clock(VGA_CTRL_CLK),
		.n_pause(r_n_pause),
		.n_reset(r_n_reset),
				
		.drawing(r_drawing),
		.completed(completed),
		
		.addr_reg(tAddr),
		.data_reg(tData),
		.write(tWrite),
		
		.p1_x(p1_x), 
		.p1_y(p1_y),
		.p1_z(p1_z), 
		.p1_r(p1_r), 
		.p1_g(p1_g), 
		.p1_b(p1_b),
		 
		.p2_x(p2_x), 
		.p2_y(p2_y),
		.p2_z(p2_z), 
		.p2_r(p2_r), 
		.p2_g(p2_g), 
		.p2_b(p2_b), 
				 
		.p3_x(p3_x),
		.p3_y(p3_y),	
		.p3_z(p3_z), 
		.p3_r(p3_r), 
		.p3_g(p3_g), 
		.p3_b(p3_b),
		
		.z_enable(SW[0]),
		.z_existence(SRAM_DQ[0]),
		.z_data(SRAM_DQ[`z_size : 1]),
		
		.light_enable(SW[1]),
		.light_r(`light_rgb'hF),
		.light_g(`light_rgb'hF),
		.light_b(`light_rgb'h0),
		
		.material_r(`light_rgb'hFF),
		.material_g(`light_rgb'h0),
		.material_b(`light_rgb'h0),
		
		.light_n_x(`float'b0),
		.light_n_y(`float'b0),
		.light_n_z(`float'b01111111),

		.n_x(r_n_x),
		.n_y(r_n_y),
		.n_z(r_n_z)
	);
	
	parameter
		stIdle 		= 3'd0,
		stClearing 	= 3'd1,
		stInitT1 	= 3'd2,
		stInitT2 	= 3'd3,
		stDrawing 	= 3'd4;
		
	reg[2:0] state;
	
	reg[8 : 0] screenX;
	reg[8 : 0] screenY;
	
	always@(posedge VGA_CTRL_CLK)begin
		case(state)				
			stIdle:begin
				r_n_pause <= `true;
				if(~KEY[0])begin
					state <= stClearing;
					screenX <= 9'b0;
					screenY <= 9'b0;
				end else if(~KEY[1]) begin
					state <= stInitT1;
					r_n_reset <= `true;
					r_drawing <= `true;
				end else if(~KEY[2])begin
					state <= stInitT2;
					r_n_reset <= `true;
					r_drawing <= `true;
				end else 
					r_n_reset <= `false;
			end
			
			stClearing:begin
				if(screenX < 9'd511)begin
					screenX <= screenX + 9'b1;
				end else begin
					screenX <= 9'b0;
					if(screenY < 9'd511)begin
						screenY <= screenY + 9'b1;
					end else begin
						state <= stIdle;
					end
				end
			end
			
			stInitT1:begin
			
				p1_x <= `pixel'h100;
				p1_y <= `pixel'hE0;
				p1_z <= `z_size'b1111111;
				p1_r <= `color'b00000;
				p1_g <= `color'b00000;
				p1_b <= `color'b11111;
				
				p2_x <= `pixel'h10;
				p2_y <= `pixel'h30;
				p2_z <= `z_size'h0;
				p2_r <= `color'b11111;
				p2_g <= `color'b00000;
				p2_b <= `color'b00000;				
				
				p3_x <= `pixel'h1E0;
				p3_y <= `pixel'h30;
				p3_z <= `z_size'h0;
				p3_r <= `color'b00000;
				p3_g <= `color'b11111;
				p3_b <= `color'b00000;
				
				r_n_x <= `float'b0;
				r_n_y <= `float'b0;
				r_n_z <= `float'b01111111;
				
				state <= stDrawing;
			end
			
			stInitT2:begin				
				p1_x <= `pixel'hC0;
				p1_y <= `pixel'hC0;
				p1_z <= `z_size'h0;
				p1_r <= `color'b00000;
				p1_g <= `color'b11111;
				p1_b <= `color'b00000;
				
				p2_x <= `pixel'h100;
				p2_y <= `pixel'h10;
				p2_z <= `z_size'b1111111;
				p2_r <= `color'b00000;
				p2_g <= `color'b00000;
				p2_b <= `color'b11111;
				
				p3_x <= `pixel'h140;
				p3_y <= `pixel'hC0;
				p3_z <= `z_size'h0;
				p3_r <= `color'b00000;
				p3_g <= `color'b11111;
				p3_b <= `color'b00000;
				
				r_n_x <= `float'b0;
				r_n_y <= `float'b0;
				r_n_z <= `float'b00111111;
				
				state <= stDrawing;
			end
			
			stDrawing:begin
				if(completed)begin
					state <= stIdle;
					r_n_reset <= `false;
					r_drawing <= `false;
				end
			end
		endcase			
	end
	
	wire screen_on_memory;
		assign screen_on_memory = 
			state==stIdle ? (  
				((~Coord_X[9]) && (Coord_Y[8:0] < 9'd256)) ?
					`true
				:
					`false
			)	:
					`true;
	
	assign addr_reg = 
			state==stIdle ? (  
				{Coord_Y[8:0], Coord_X[8:0]}
			) : state==stClearing ? (
				{screenY, screenX} 
			) : 
				tAddr;
				
	assign data_reg = 
			state==stIdle ? (
				16'b0
			) : state==stClearing ? (
				16'b0
			) :	state==stDrawing ? (
				tData
			) :	16'b0;
			
	assign we = 
			state==stIdle ? (
				`false
			) : state==stClearing ? (
				`true
			) :	state==stDrawing ? (
				tWrite
			) : `false;

	assign mVGA_R = 
		screen_on_memory ? {SRAM_DQ[15 - 0 * `color : 15 - 1 * `color + 1], {(10 - `color){1'b0}}} : `false;
	assign mVGA_G = 
		screen_on_memory ? {SRAM_DQ[15 - 1 * `color : 15 - 2 * `color + 1], {(10 - `color){1'b0}}} : `false;
	assign mVGA_B = 
		screen_on_memory ? {SRAM_DQ[15 - 2 * `color : 15 - 3 * `color + 1], {(10 - `color){1'b0}}} : `false;
   
endmodule
//