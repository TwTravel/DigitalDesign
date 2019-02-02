// --------------------------------------------------------------------
// --------------------------------------------------------------------
//
// Major Functions: Video output from Stack machine 
//		VGA state is in SRAM 
//		Three stack cpus share SRAM with VGA via an interleaved switch
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
// rk447 : Interrupt implementation
// Bruce R Land, Cornell University, Nov 2011 -- multiproc interface
// Bruce R Land, Cornell University, Nov 2010 -- fast cpu and VGA
// Improved top module written by Adam Shapiro Oct 2009
// --------------------------------------------------------------------

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
   
   //Set all GPIO to tri-state.
   //assign GPIO_0 = 36'hzzzzzzzzz;
   assign GPIO_1 = 36'hzzzzzzzzz;

   //Disable audio codec.
   //assign AUD_DACDAT = 1'b0;
   //assign AUD_XCK    = 1'b0;

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

   //Disable all other peripherals.
   //assign I2C_SCLK = 1'b0;
   assign IRDA_TXD = 1'b0;
   //assign TD_RESET = 1'b0;
   assign TDO = 1'b0;
   assign UART_TXD = 1'b0;

	//LEDs
	assign LEDG = LEDGwire;
	wire [8:0] LEDGwire;
// === VGA timing and interface =================
wire	VGA_CTRL_CLK;
wire	AUD_CTRL_CLK;
wire	FAST_CLK;
wire  sram_clk;
wire	DLY_RST;

assign	TD_RESET	=	1'b1;	//	Allow 27 MHz
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

// Safe reset
wire reset ; //have two cascaded registers for connecting a reset signal
reg resetReg0, resetReg1;
always @ (posedge FAST_CLK) begin//TODO: slow clock or fast clock
	resetReg0 <= KEY[0];
	resetReg1 <= resetReg0;
end
assign reset = resetReg1;


Reset_Delay			r0	(	.iCLK(CLOCK_27),.oRESET(DLY_RST)	);

// sram_clk and FAST_CLK are 50.4 MHz -- VGA_CLK is 25.2
VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(sram_clk),.c1(FAST_CLK),.c2(VGA_CLK)	); //.areset(~DLY_RST)

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
							.iCLK(VGA_CLK), //VGA_CTRL_CLK
							.iRST_N(DLY_RST)	); //.iRST_N(DLY_RST)

wire [9:0]	mVGA_R;				//memory output to VGA
wire [9:0]	mVGA_G;
wire [9:0]	mVGA_B;
wire [18:0]	mVGA_ADDR;			//video memory address
wire [9:0]  Coord_X, Coord_Y;	//display coods

//Hex display stuff
	hex_to_seven_seg seg0(
    .B(timeThousandth),//.B(pcoHex[3:0]),//.B(timeThousandth),
    .SSEG_L(HEX0)//hundredth
  );	
	hex_to_seven_seg seg1(
    .B(timeHundredth),//.B(pcoHex[7:4]),//.B(timeHundredth),
    .SSEG_L(HEX1)//tenth
  );	
  hex_to_seven_seg seg2(
    .B(timeTenth),//.B(pcoHex[11:8]),//.B(timeTenth),
    .SSEG_L(HEX2)
  );
  hex_to_seven_seg seg3(
    .B(timeOnes),           //
    .SSEG_L(HEX3)
  );
  hex_to_seven_seg seg4(
    
    .SSEG_L(HEX4)//ones
  );
	hex_to_seven_seg seg5(
    .B(pcnHex[3:0]),//.B(timeTens),
    .SSEG_L(HEX5)//tens
  );
  hex_to_seven_seg seg6(
    .B(pcnHex[7:4]),//.B(timeHundreds),
    .SSEG_L(HEX6)//hundreds
  );
  hex_to_seven_seg seg7(
    .B(pcnHex[11:8]),
    .SSEG_L(HEX7)
  );

// === SRAM interface ===============================
// 18 bits of adddress:
// 9 bits of Y 
// 10 bits of X (excludes low bit which drives LB/UB)
// reset high is normal operation
reg [17:0] sram_addr_reg ;
reg [15:0] sram_data_reg ;
reg sram_we, sram_ub, sram_lb ;

assign SRAM_ADDR = sram_addr_reg ;
assign SRAM_CE_N = 1'b0; // always enabled
assign SRAM_OE_N = 1'b0; // always enabled
assign SRAM_LB_N = sram_lb;
assign SRAM_UB_N = sram_ub;
assign SRAM_WE_N = sram_we;
assign SRAM_DQ   = sram_we? 16'hzzzz : sram_data_reg ;

reg  Coord_x_0 ; // low bit of vga x

// === memory switch ==================================
// now allow VGA and 3 cpus to access SRAM
// VGA gets SRAM on every other memory clock cycle
// (once per VGA cycle).
// cpus get SRAM on every other cycle and must
// arbitrate who reads/writes.
// SRAM clock is same frequency as cpu clock (50.4 MHZ)
// but is phase shifted +90 degrees in the PLL.

wire [17:0] cpu1_out0, cpu1_out1, cpu1_out2, cpu1_out3, cpu1_out4 ;
wire [17:0] cpu2_out0, cpu2_out1, cpu2_out2, cpu2_out3 ;
wire [17:0] cpu3_out0, cpu3_out1, cpu3_out2, cpu3_out3 ;
// data from SRAM back to cpus
reg [15:0] cpu1_sram_data, cpu2_sram_data, cpu3_sram_data, vga_sram_data ;
// feedback to cpu telling cpu that memory is theirs
reg cpu1_access, cpu2_access, cpu3_access;
// internal time counter to account for slow software
reg [3:0] cpu1_wait, cpu2_wait, cpu3_wait ;
// internal mutex counter to account for slow software
reg [3:0] cpu1_mwait, cpu2_mwait, cpu3_mwait ;
//
// mutex
reg [7:0] mutex ;

parameter wait_time = 4'd8 ; //4'd10 the wait time for a cpu to clear it's request flag

/* cpu i/o register layout
minicpu cpu1(.clk(FAST_CLK), .reset(reset),  .run(1'b1),
	.in0(SW[17:0]),
	.in1({2'b00,cpu1_sram_data}),
	.in2({cpu1_access}), 
	.in3(18'd1), // cpu 1 -- cpu identifer
	.in4(cpu1_in4), // char rom data -- cpu 1 only
	.out0(cpu1_out0), // sram address
	.out1(cpu1_out1), // sram data
	.out2(cpu1_out2), // sram control word
   .out3(cpu1_out3), // a count of aggregate particles
	.out4(cpu1_out4)  // char rom address
	); 
*/
// sram control word:
	// bit 0 low => we
	// bit 1 low => write low byte
	// bit 1 high=> write high byte
	// bit 2 high => request sram access
	// bit 3 high => full word read/write
	// bit 4 high => mutex test and set
	// bit 5 high => mutex read
	// bit 6 high => mutex clear
// ==== Memory protocol ======
// Processor outputs address (and data on write).
// Processor requests memory (read, write, mutex operation)
// Processor waits for memory to ACK access
// On read, processsor reads memory. 
// Processor clears request 
// --(memory delays a few cycles to allow proecssor to clear request)

always @(posedge sram_clk) //sram_clk
begin
	
	if (~reset)
	begin
		sram_addr_reg <= {Coord_Y[8:0], Coord_X[9:1]} ;
		sram_data_reg  <= 16'b0 ;
		sram_lb <= 1'b0 ; 
		sram_ub <=  1'b0 ;
		sram_we <= 1'b0 ;
		// tell all cpus that they don't have access
		cpu1_access <= 1'b0 ;
		cpu2_access <= 1'b0 ;
		cpu3_access <= 1'b0 ;
		// init cpu wait functions
		cpu1_wait <= 1'b0 ;
		cpu2_wait <= 1'b0 ;
		cpu3_wait <= 1'b0 ;
	end
	
	//else if (reset_wait)
	//	reset_wait <= 1'b0 ;
		
	// on VGA_CLK allow VGA controller access
	// set up read, then finish read on next cycle
	else if (VGA_CLK) //(clk_phase) note that sram_clk is phase-locked and twice as fast
	begin
		sram_addr_reg <= {Coord_Y[8:0], Coord_X[9:1]} ;
		sram_lb <= 1'b0 ; 
		sram_ub <=  1'b0 ; 
		sram_we <=  1'b1 ;	
	end

	// on ~VGA_CLK allow CPU access
	// set up read, then finish read on next cycle	
	// sram_cntl word:
	// bit 0 low => we
	// bit 1 low => write low byte
	// bit 1 high=> write high byte
	// bit 2 high => request sram access
	// bit 3 high => full word read/write
	// bit 4 high => mutex test and set
	// bit 5 high => mutex read
	// bit 6 high => mutex clear
	else  // if (~VGA_CLK)
	begin
		
		if (cpu1_out2[2] && cpu1_wait==0 ) 
		begin
			sram_addr_reg <= cpu1_out0 ;
			sram_data_reg <= cpu1_out1 ; 
			sram_lb <= (cpu1_out2[3] | cpu1_out2[0])? 0 : cpu1_out2[1] ; 
			sram_ub <= (cpu1_out2[3] | cpu1_out2[0])? 0 : ~cpu1_out2[1] ; 
			sram_we <= cpu1_out2[0] ;
			cpu1_access <= 1'b1 ;
			cpu1_wait <= 1'b1 ;
		end
		
		else if (cpu2_out2[2] && cpu2_wait==0 ) 
		begin
			sram_addr_reg <= cpu2_out0 ;
			sram_data_reg <= cpu2_out1 ; 
			sram_lb <= (cpu2_out2[3] | cpu2_out2[0])? 0 : cpu2_out2[1] ; 
			sram_ub <= (cpu2_out2[3] | cpu2_out2[0])? 0 : ~cpu2_out2[1] ;
			sram_we <= cpu2_out2[0] ;
			cpu2_access <= 1'b1 ;	
			cpu2_wait <= 1'b1 ;
		end
	
		else if (cpu3_out2[2] && cpu3_wait==0 ) 
		begin
			sram_addr_reg <= cpu3_out0 ;
			sram_data_reg <= cpu3_out1 ; 
			sram_lb <= (cpu3_out2[3] | cpu3_out2[0])? 0 : cpu3_out2[1] ; 
			sram_ub <= (cpu3_out2[3] | cpu3_out2[0])? 0 : ~cpu3_out2[1] ;  
			sram_we <= cpu3_out2[0] ;
			cpu3_access <= 1'b1 ;	
			cpu3_wait <= 1'b1 ;
		end
		
		//=== handle mutex, independent of SRAM ====
		// cpu 1 mutex test-and-set
		else if (cpu1_out2[4] && cpu1_mwait==4'b0 ) 
		begin
			if (mutex[cpu1_out0])
				cpu1_sram_data <= 1'b1 ; 
			else
			begin // if not set, then set it
				cpu1_sram_data <= 1'b0 ; 	
				mutex[cpu1_out0] <= 1'b1 ;
			end
			cpu1_access <= 1'b1 ;	
			cpu1_mwait <= 1'b1 ;
		end 
		// mutex read
		else if (cpu1_out2[5] && cpu1_mwait==4'b0 ) 
		begin
			cpu1_sram_data <= mutex[cpu1_out0] ; 
			cpu1_access <= 1'b1 ;	
			cpu1_mwait <= 1'b1 ;
		end 
		// mutex clear
		else if (cpu1_out2[6] && cpu1_mwait==4'b0 ) 
		begin
			mutex[cpu1_out0] <= 1'b0 ; 
			cpu1_access <= 1'b1 ;	
			cpu1_mwait <= 1'b1 ;
		end 
		//	
		
		// mutex -- cpu 2
		else if (cpu2_out2[4] && cpu2_mwait==4'b0 ) 
		begin
			if (mutex[cpu2_out0])
				cpu2_sram_data <= 1'b1 ; 
			else
			begin // if not set, then set it
				cpu2_sram_data <= 1'b0 ; 	
				mutex[cpu2_out0] <= 1'b1 ;
			end
			cpu2_access <= 1'b1 ;	
			cpu2_mwait <= 1'b1 ;
		end 
		
		// mutex read
		else if (cpu2_out2[5] && cpu2_mwait==4'b0 ) 
		begin
			cpu2_sram_data <= mutex[cpu2_out0] ; 
			cpu2_access <= 1'b1 ;	
			cpu2_mwait <= 1'b1 ;
		end 
		// mutex clear
		else if (cpu2_out2[6] && cpu2_mwait==4'b0 ) 
		begin
			mutex[cpu2_out0] <= 1'b0 ; 
			cpu2_access <= 1'b1 ;	
			cpu2_mwait <= 1'b1 ;
		end 
		//	
		
		// mutex -- cpu 3
		else if (cpu3_out2[4] && cpu3_mwait==4'b0 ) 
		begin
			if (mutex[cpu3_out0])
				cpu3_sram_data <= 1'b1 ; 
			else
			begin // if not set, then set it
				cpu3_sram_data <= 1'b0 ; 	
				mutex[cpu3_out0] <= 1'b1 ;
			end
			cpu3_access <= 1'b1 ;	
			cpu3_mwait <= 1'b1 ;
		end 
		// mutex read
		else if (cpu3_out2[5] && cpu3_mwait==4'b0 ) 
		begin
			cpu3_sram_data <= mutex[cpu3_out0] ; 
			cpu3_access <= 1'b1 ;	
			cpu3_mwait <= 1'b1 ;
		end 
		// mutex clear
		else if (cpu3_out2[6] && cpu3_mwait==4'b0 ) 
		begin
			mutex[cpu3_out0] <= 1'b0 ; 
			cpu3_access <= 1'b1 ;	
			cpu3_mwait <= 1'b1 ;
		end 	
	end
	
	// read/write data on opposite cycle from 
	// previous setup steps above
	// get data 
	if (VGA_CLK && cpu1_wait==1)
	begin
		cpu1_sram_data <= SRAM_DQ ;
	end
	//
	if (VGA_CLK && cpu2_wait==1)
	begin
		cpu2_sram_data <= SRAM_DQ ;
	end
	//
	if (VGA_CLK && cpu3_wait==1)
	begin
		cpu3_sram_data <= SRAM_DQ ;
	end	
	//
	if (~VGA_CLK)
	begin
		vga_sram_data <= SRAM_DQ ;
		Coord_x_0 <= (Coord_X[0]);
	end	
	
	
	// memory time outs for each cpu
	if (cpu1_wait>0)
	begin
		if (cpu1_wait < wait_time) // 
			cpu1_wait <= cpu1_wait + 4'd1 ;
		else
		begin
			cpu1_wait <= 4'b0 ;
			cpu1_access <= 1'b0 ;
		end
	end
	//
	if (cpu2_wait>0)
	begin
		if (cpu2_wait < wait_time) // 
			cpu2_wait <= cpu2_wait + 4'd1 ;
		else
		begin
			cpu2_wait <= 4'b0 ;
			cpu2_access <= 1'b0 ;
		end
	end
	//
	if (cpu3_wait>0)
	begin
		if (cpu3_wait < wait_time) // 
			cpu3_wait <= cpu3_wait + 4'd1 ;
		else
		begin
			cpu3_wait <= 4'b0 ;
			cpu3_access <= 1'b0 ;
		end
	end
	
	//	 mutex timeouts for each cpu
	// time outs for cpu 2
	if (cpu2_mwait>0)
	begin
		if (cpu2_mwait < wait_time) // 
			cpu2_mwait <= cpu2_mwait + 4'd1 ;
		else
		begin
			cpu2_mwait <= 4'b0 ;
			cpu2_access <= 1'b0 ;
		end
	end
	// time outs for cpu 3 
	if (cpu3_mwait>0)
	begin
		if (cpu3_mwait < wait_time) // 
			cpu3_mwait <= cpu3_mwait + 4'd1 ;
		else
		begin
			cpu3_mwait <= 4'b0 ;
			cpu3_access <= 1'b0 ;
		end
	end	
	
	// time outs for cpu 1
	if (cpu1_mwait>0)
	begin
		if (cpu1_mwait < wait_time) // 
			cpu1_mwait <= cpu1_mwait + 4'd1 ;
		else
		begin
			cpu1_mwait <= 4'b0 ;
			cpu1_access <= 1'b0 ;
		end
	end	
end // @(posedge sram_clk)

// === end of memory switch ============================

// === color map =======================================
// remap color index for bigger dynamic range
wire [9:0] r, g, b ;
assign mVGA_R = r ;
assign mVGA_G = g ;
assign mVGA_B = b ;
wire [7:0] index ;
assign index = (Coord_x_0)? vga_sram_data[15:8] : vga_sram_data[7:0] ;

// define the vga colormap
colormap cmap(r, g, b, index);

// === font rom =========================================
wire [15:0] cpu1_in4;
char_rom rom1(FAST_CLK, cpu1_out4, cpu1_in4);
wire [11:0] pcnHex,pcoHex;
// === cpus==============================================
// define the CPU 1
minicpu cpu1(
	.clk(FAST_CLK),//.clk(FAST_CLK), slowClock
	.reset(reset),  .run(1'b1),
	.in0(SW[17:0]),
	.in1({2'b00,cpu1_sram_data}),
	.in2({cpu1_access}), //.in2({~VGA_VS, ~VGA_HS}),
	.in3(18'd1), // cpu 1
	.in4(cpu1_in4), // char rom data
	.out0(cpu1_out0), // sram address
	.out1(cpu1_out1), // sram data
	.out2(cpu1_out2), // sram control
   .out3(cpu1_out3), // a count of aggregate particles
	.out4(cpu1_out4),  // char rom address
	//interrupt stuff
	.key1in(KEY[1]),
	.key2in(KEY[2]),
	.key3in(KEY[3]),
	.stopTimer(stopTimer),
	.LEDGcpu(LEDGwire),
	.LEDRcpu(LEDRwire),
	.pcnHex(pcnHex),
	.pcoHex(pcoHex)
	); 
wire slowClock;
slowClockGen slowClockGen0(.clk_in(FAST_CLK),.reset(reset),.clk_out(slowClock));
wire [17:0] LEDRwire;
assign LEDR = LEDRwire;

//instantiate a timer and a timer counter
wire restartCounter, stopTimer;
wire [3:0] timeTenth, timeHundredth,timeThousandth;
wire [3:0] timeOnes, timeTens, timeHundreds;	
timeCounter timeToHex(
.reset(reset),
.clk(FAST_CLK),
//.restart(),
.thousandth(timeThousandth),
.hundredth(timeHundredth),
.tenth(timeTenth),
.ones(timeOnes),
.tens(timeTens),
.hundreds(timeHundreds),
.computationDone(stopTimer)
);



endmodule //top module

/////////////////////////////////////////////////////////////////////
/// vga character rom ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////

module char_rom(clk, addr, q) /* synthesis romstyle = "M4K" */ ;
 parameter DWIDTH=8,AWIDTH=11,WORDS=2048;

 input clk ;
 input [AWIDTH-1:0] addr;
 output [DWIDTH-1:0] q;
 reg [DWIDTH-1:0] q;
 // IF YOUR PROGRAM IS IN a mif file use:
 // reg [DWIDTH-1:0] mem [WORDS-1:0] /* synthesis ram_init_file = "TestPgm0.mif" */ ;
 // see http://www.altera.com/literature/hb/qts/qts_qii51008.pdf EXAMPLE 9-78
 
 reg [DWIDTH-1:0] mem [WORDS-1:0]  /* synthesis ram_init_file = "font_rom.mif" */ ;
 
// initial // Read the memory contents in the file
//dual_port_rom_init.txt.
//begin
//$readmemb("dual_port_rom_init.txt", rom);
//end

 always @(posedge clk)
   begin
     q <= mem[addr];
   end

endmodule

///////////////////////////////////////////////////////////////////////
/// color map /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

module colormap(r,g,b, index);
// index bits r=[7:5], g=[4:2], b=[1:0]
input [7:0] index;
output reg [9:0] r, g, b ;
always @(*)
begin
if (index[7:6]==2'b11)
begin
	// red map
	case(index[5:4])
		0: r=10'h0;
		1: r=10'h100;
		2: r=10'h200;
		3: r=10'h3ff;
	endcase 
	// green map
	case(index[3:2])
		0: g=10'h0;
		1: g=10'h100;
		2: g=10'h200;
		3: g=10'h3ff;
	endcase 
	// blue map
	case(index[1:0])
		0: b=10'h0;
		1: b=10'h100;
		2: b=10'h200;
		3: b=10'h3ff;
	endcase
end
	
else if (index[7:6]==2'b10) 
begin
		// red map
	case(index[5:4])
		0: r=10'h0;
		1: r=10'h100>>1;
		2: r=10'h200>>1;
		3: r=10'h3ff>>1;
	endcase 
	// green map
	case(index[3:2])
		0: g=10'h0;
		1: g=10'h100>>1;
		2: g=10'h200>>1;
		3: g=10'h3ff>>1;
	endcase 
	// blue map
	case(index[1:0])
		0: b=10'h0;
		1: b=10'h100>>1;
		2: b=10'h200>>1;
		3: b=10'h3ff>>1;
	endcase
end
	
else if (index[7:6]==2'b01) 
begin
		// red map
	case(index[5:4])
		0: r=10'h0;
		1: r=10'h100>>2;
		2: r=10'h200>>2;
		3: r=10'h3ff>>2;
	endcase 
	// green map
	case(index[3:2])
		0: g=10'h0;
		1: g=10'h100>>2;
		2: g=10'h200>>2;
		3: g=10'h3ff>>2;
	endcase 
	// blue map
	case(index[1:0])
		0: b=10'h0;
		1: b=10'h100>>2;
		2: b=10'h200>>2;
		3: b=10'h3ff>>2;
	endcase
end
	
else begin
		// red map
	case(index[5:4])
		0: r=10'h0;
		1: r=10'h100>>3;
		2: r=10'h200>>3;
		3: r=10'h3ff>>3;
	endcase 
	// green map
	case(index[3:2])
		0: g=10'h0;
		1: g=10'h100>>3;
		2: g=10'h200>>3;
		3: g=10'h3ff>>3;
	endcase 
	// blue map
	case(index[1:0])
		0: b=10'h0;
		1: b=10'h100>>3;
		2: b=10'h200>>3;
		3: b=10'h3ff>>3;
	endcase
end
end
endmodule

/////////////////////////////////////////////////////////////////////
//// signed mult of 10.8 format 2'comp //////////////////////////////
/////////////////////////////////////////////////////////////////////
module signed_mult (out, a, b);

	output 		[17:0]	out;
	input 	signed	[17:0] 	a;
	input 	signed	[17:0] 	b;
	
	wire	signed	[17:0]	out;
	wire 	signed	[35:0]	mult_out;

	assign mult_out = a * b;
	//assign out = mult_out[33:17];
	assign out = {mult_out[35], mult_out[24:8]};
endmodule
//////////////////////////////////////////////////

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// The following CPU design is from
// http://www.cs.hiroshima-u.ac.jp/~nakano/wiki/
// and is GPL licensed
//
// with added opcodes, 18-bit data, and modified mult
////////////////////////////////////////////////////////////

`define IDLEA 3'b000
`define IDLEB 3'b001
`define EXEC 3'b010
//interrupt definitions
`define INT_BEGIN 3'b011//state when interrupt is entered
`define INT_END   3'b100//state for returning from interrupt
//end int defs

`define  ADD  5'b00000
`define  SUB  5'b00001
`define  MUL  5'b00010
`define  SHL  5'b00011
`define  SHR  5'b00100
`define  BAND 5'b00101
`define  BOR  5'b00110
`define  BXOR 5'b00111
`define  AND  5'b01000
`define  OR   5'b01001
`define  EQ   5'b01010
`define  NE   5'b01011
`define  GE   5'b01100
`define  LE   5'b01101
`define  GT   5'b01110
`define  LT   5'b01111
`define  NEG  5'b10000
`define  BNOT 5'b10001
`define  NOT  5'b10010
`define  A    5'b10011
`define  B    5'b10111
`define  Aa   5'b11011
`define  Ba   5'b11111
`define  ASR  5'b10100 // arithmetic shift right
`define  MFIX 5'b10101 //fixed mult

`define HALT 4'b0000
`define PUSHI 4'b0001
`define PUSH 4'b0010
`define POP  4'b0011
`define JMP  4'b0100
`define JZ  4'b0101
`define JNZ 4'b0110
`define LD  4'b0111
`define ST  4'b1000
`define PPPC 4'b1001
`define IN   4'b1101
`define OUT  4'b1110
`define OP   4'b1111
//interrupt instructions in execute
`define INT  4'b1010      //prefix for interrupts. a




//////////////////////////////////
module alu(a, b, f, s);

 input [17:0] a, b;
 input [4:0] 	f;
 output [17:0] s;
 reg  [17:0] 	 s;
 wire [17:0] x, y, mout;

 assign x = a + 18'h20000;
 assign y = b + 18'h20000;
  
 always @(a or b or x or y or f or mout)
   case(f)
     `ADD : s = b + a;
     `SUB : s = b - a;
     `MUL : s =  b * a; //mout ; // b * a;
	  `MFIX: s =  mout ;
     `SHL : s = b << a;
     `SHR : s = b >> a;
	  `ASR : s = $signed(b) >>> a;
     `BAND: s = b & a;
     `BOR : s = b | a;
     `BXOR: s = b ^ a;
     `AND : s = b && a;
     `OR  : s = b || a;
     `EQ  : s = b == a;
     `NE  : s = b != a;
     `GE  : s = y >= x;
     `LE  : s = y <= x;
     `GT  : s = y > x;
     `LT  : s = y < x;
     `NEG : s = -a;
     `BNOT : s = ~a;
     `NOT : s = !a;
	  `A   : s = a;
	  `B   : s = b;
	  `Aa  : s = a;
	  `Ba  : s = b;
     default : s = 18'hxxxx;
   endcase

	signed_mult m_10_8(mout, a, b) ;
endmodule

////////////state machine////////////////////////
module statef(clk,reset,run,halt,cs, execToEndInt,IHexecToBeginInt,pcnextIn, pcReturnInt,
statefExitInt, statefBeginInt);
   
  input clk, reset, run, halt,execToEndInt,IHexecToBeginInt;
  //input [4:0] intFlags;
  output [2:0] cs;
  reg [2:0] cs;
  input [11:0] pcnextIn;
  output reg [11:0] pcReturnInt;
  output reg statefExitInt;
  output reg statefBeginInt;
 /*IDLEA:0
   IDLEB:1
	EXEC:2
	INT_BEGIN:3
   INT_END:4
 */
  always @(posedge clk or negedge reset)
    if(!reset) begin
		cs <= `IDLEA;
		statefExitInt <= 1'b0;
		statefBeginInt <= 1'b0;
	 end
    else
      case(cs)
        `IDLEA: if(run) cs <= `IDLEB;
        `IDLEB: cs <= `EXEC;
        `EXEC: begin
					//statefExitInt <= 1'b0;
					if(halt) cs <= `IDLEA;
					else if (IHexecToBeginInt) begin 
						cs <= `INT_BEGIN;
						statefBeginInt <= 1'b1;
						pcReturnInt <= pcnextIn;
					end
					else if (execToEndInt) begin
						cs <= `INT_END;
						statefExitInt <= 1'b1;
					end
               else cs <= `EXEC;				
					end
		  `INT_BEGIN: begin
				cs <= `EXEC; //move back to execute state to process interrupt code
				statefBeginInt <= 1'b0;
		  end
		  `INT_END: begin
				cs<= `EXEC;
				statefExitInt <= 1'b0;
		  end
		  //`EXEC:  cs <= `EXEC;
        default: cs <= 3'bxxx;
      endcase

endmodule


//////////////////////////////////////
module stackm(clk, reset, load, push, pop, pop2, thru, d, dthru, qtop, qnext);
parameter AWIDTH = 4, N = 16;

  input clk, reset, load, push, pop, pop2, thru;
  input [17:0] d, dthru;
  output [17:0] qtop, qnext;
  reg [AWIDTH-1:0] ptop, ptopf, addra, addrb;
  reg [17:0] mem [N-1:0];
  reg [17:0] qtopf;
  wire [17:0] pnextf;
  wire thruwrite;

  always @(push or pop or pop2 or ptop)
  if(push) ptopf = ptop - 1;
  else if(pop) ptopf = ptop + 1;
  else if(pop2) ptopf = ptop + 2;
  else ptopf = ptop;

  always @(posedge clk or negedge reset) 
  if(!reset) ptop <= 0;
  else ptop <= ptopf;

  assign  pnextf = ptopf + 1;
  assign thruwrite = !(push||pop) && thru;

  always @(load or thruwrite or d or dthru)
  if(load) qtopf = d;
  else if(thruwrite) qtopf = dthru;
  else qtopf = 18'hxxxx;

  always @(posedge clk)
  begin
    if(load || thruwrite) mem[ptopf] <= qtopf;
    addra <= ptopf;
  end

  always @(posedge clk)
  begin
    if(push && thru) mem[pnextf] <= dthru;
    addrb <= pnextf;
  end

  assign qtop = (thru ? dthru : mem[addra]);
  assign qnext = mem[addrb];

endmodule
//////////////////////////////////////////////////


// module dpram(clk, load1, addr1, addr2, d1, q1, q2);
//addr2:pcnext, q2:irout, q1:ramout
module dpram(clk, load1, addr1, addr2, d1, q1, q2/*, intFlags, ISR_addr*/);
 parameter DWIDTH=18,AWIDTH=12,WORDS=4096;

 input clk,load1 ; //,load2;
 input [AWIDTH-1:0] addr1,addr2;
 input [DWIDTH-1:0] d1 ; //,d2;
 //input [4:0] intFlags; //interrupt flag register
 //output reg [AWIDTH-1:0] ISR_addr;
 output [DWIDTH-1:0] q1,q2;
 reg [DWIDTH-1:0] q1,q2;
 reg [DWIDTH-1:0] mem [WORDS-1:0]  /* synthesis ram_init_file = "codeimageTest.mif" */ ;

 /*mem[12] has timer interrupt vector address
   mem[13] Key1, mem[14]: Key2, mem[15]: Key3, mem[16] unusedISR
 */

 always @(posedge clk)
   begin
     if(load1) mem[addr1] <= d1;
     q1 <= mem[addr1];
  end

 always @(posedge clk)
   begin
//     if(load2) mem[addr2] <= d2;
     q2 <= mem[addr2];
	  //output the right address depending on the interrupt flag
	 /* case(intFlags)
	  5'b00001: ISR_addr <= mem[12];
	  5'b00010:	ISR_addr <= mem[13];
	  5'b00100:	ISR_addr <= mem[14];
	  5'b01000:	ISR_addr <= mem[15][11:0];//Key3
	  5'b10000:	ISR_addr <= mem[16];
	  //default: //ISR_addr  <= mem[3];reset
	  endcase*/
	  //TODO: use priority encoder?
	  //casez() {4'd?,1'b1}
  end

endmodule
//////////////////////////////////////

module minicpu(clk, reset, run, 
in0, in1, in2, in3, in4, in5, in6, in7,
out0, out1, out2, out3, out4, out5, out6, out7,	
key1in, key2in, key3in, stopTimer, LEDGcpu, LEDRcpu,
pcnHex, pcoHex		
);

 input clk,reset,run;
 input [17:0] in0, in1, in2, in3, in4, in5, in6, in7  ;
 input key1in, key2in, key3in;
 output [17:0] out0, out1, out2, out3, out4, out5, out6, out7 ;
 output [8:0] LEDGcpu;
 output  [17:0] LEDRcpu;
 output stopTimer;
 output [11:0] pcnHex, pcoHex;
 assign pcnHex = pcnext;
 assign pcoHex = pcout;
 
 wire [2:0] cs;//cpu state
 wire [17:0] irout, qtop, dbus ;//instr reg, top, data bus
 wire [17:0] qnext, ramout, aluout;//next , ram out , alu out
 reg [11:0] abus;//address bus
 reg halt, jump, pcinc, push, pop, thru, qthru, dbus2qtop;
 // halt, jump, , , , thru:      , qthru:            , data bus 2 top
 reg dbus2ram, dbus2obuf, ir2dbus, qtop2dbus, alu2dbus, ram2dbus, in2dbus;
 //reg dbus2intData;
 //data bus 2 ram, data bus 2 output buffer, instruction register to data bus,
 //stack top 2 data bus, alu 2 data bus, ram 2 data bus, in 2 data bus
 reg pop2, ir2abus, qtop2abus, qnext2abus;
 wire SFinsideIntBegin;//StatefInIntbeg to show cpu is in `INT_BEGIN state
 //pop2? , instr reg 2 addr bus, top to addr bus, next 2 addr bus
 reg poppc, pushpc ; // added by BRL4 to support POPPC/PUSHPC opcode
 reg [11:0] pcout, pcnext;
 reg [17:0] out[7:0] ;
 wire [17:0] in[7:0] ;
//definitions for interrupt
reg  execToEndInt;//EXEC to endint
wire [11:0] pcReturnInt; //pc address to return to from interrupt
wire [11:0] ISR_addr; //ISR address to jump to on interrupt
reg gieCode = 1'b1;
//reg [17:0] intData; comes from data bus
reg [2:0] intDataType;//1: clear a flag, 2:set a flag, 3: mask an interrupt
//4:unmask an interrupt,5: set timer overflow
//
wire statefExitInt;
 statef statef0(.clk(clk),.reset(reset),.run(run),.halt(halt),.cs(cs),
.execToEndInt(execToEndInt), /*.intFlags(intFlags),*/ .pcnextIn(pcnext),
.pcReturnInt(pcReturnInt),.IHexecToBeginInt(IHexecToBeginInt),.statefExitInt(statefExitInt),
.statefBeginInt(SFinsideIntBegin)
 );
 stackm stackm0(.clk(clk),.reset(reset),.load(dbus2qtop),.push(push),
	.pop(pop),.pop2(pop2),.thru(qthru),.d(dbus),.dthru(ramout),.qtop(qtop),.qnext(qnext));
	
 alu alu0(.a(qtop),.b(qnext),.f(irout[4:0]),.s(aluout));
 dpram #(18,12,4096) dpram0(.clk(clk),.load1(dbus2ram),.addr1(abus),.addr2(pcnext),.d1(dbus),
 .q1(ramout),.q2(irout));
//instantiate interrupt hardware
//assign LEDRcpu[2:0] = cs;
//assign LEDRcpu[17] = 1'b1;
//assign LEDRcpu = {SFinsideIntBegin,statefExitInt,13'd0,cs};//{irout}; //intFlags;
assign LEDRcpu = {stopTimer};//{SFinsideIntBegin,statefExitInt, abus};
wire [2:0] intFlags; 
wire IHexecToBeginInt;
interruptHardware interrupts(
.clk(clk),
.reset(reset),
.timerIntOut(stopTimer),
.gieIn(gieCode),
.key1new(key1in),
.key2new(key2in),
.key3new(key3in),
.interruptFlags(intFlags),
.intDataType(intDataType),
.intData(dbus),
.LEDGout(LEDGcpu[8:0]),
.IHexecToBeginInt(IHexecToBeginInt),
.returnFromInt(execToEndInt),//TODO
.timerOvfIn(timerOvfReg)
//.SFinsideIntBeginSignal(SFinsideIntBegin)
);
//timer overflow stuff
reg timerOvfChanged;
reg [17:0] timerOvfReg;

 always @ (pcinc or jump or cs or pcout or irout or poppc or qtop)
   if(cs == `IDLEB) pcnext = pcout;
   else if(pcinc)  pcnext = pcout + 1;
   else if(jump)  pcnext = irout[11:0];
	else if(poppc) pcnext = qtop[11:0]; // added to support POPPC opcode
	else if(cs==`INT_BEGIN) begin
		//pcReturnInt = pcnext;//save program counter. pcout or pcnext
		pcnext      = ramout[11:0]; //jump to ISR vector	
		//SFinsideIntBegin    = 1'b1;
		//pcout       = ISR_addr;
	end
	else if(cs==`INT_END) pcnext   = pcReturnInt;//restore program counter
	//TODO: in end interrupt state set pcnext to value stored in Interrupt module
   else begin 
		pcnext = 12'hxxx;
		//SFinsideIntBegin = 1'b0;
	end

 always @ (posedge clk or negedge reset) begin
   if(!reset) begin //reset condition
		pcout <= 0;
		timerOvfReg <= 18'd0;
		//execToEndInt <= 1'b0;Comment out
		//intData <= 6'b111111;//no data to send. Comment out
	end
   else begin
		if(pcinc || jump || poppc || SFinsideIntBegin || statefExitInt) pcout <= pcnext; // mod to support poppc. TODO
		//if (pcinc || jump || poppc || cs==`INT_BEGIN || cs==`INT_END) pcout <= pcnext;
		if (timerOvfChanged) timerOvfReg <= dbus;
      else timerOvfReg <= 18'd0;	
	end
 end
 // update the output ports
 always @ (posedge clk)
   if(dbus2obuf) out[irout[2:0]] <= dbus ;//send data through output port
	
 // the 8 ports are external
 assign out0 = out[0];
 assign out1 = out[1];
 assign out2 = out[2];
 assign out3 = out[3];
 assign out4 = out[4];
 assign out5 = out[5];
 assign out6 = out[6];
 assign out7 = out[7];
 
 // the 8 ports are external
 assign in[0] = in0;
 assign in[1] = in1;
 assign in[2] = in2;
 assign in[3] = in3;
 assign in[4] = in4;
 assign in[5] = in5;
 assign in[6] = in6;
 assign in[7] = in7;

 always @ (posedge clk or negedge reset)
   if(!reset) qthru <= 0;
   else qthru <= thru;

 always @ (cs or ir2abus or qtop2abus or qnext2abus or irout or qtop or qnext )
 if(ir2abus) abus = irout[11:0];
 else if(qtop2abus) abus = qtop[11:0];
 else if(qnext2abus) abus = qnext[11:0];
 else if (SFinsideIntBegin)  abus = intFlags + 4'd11;//SFinsideIntBegin
 else abus = 12'hxxx;

 assign dbus = ir2dbus ? {{6{irout[11]}},irout[11:0]} : 18'hzzzz;
 assign dbus = qtop2dbus ? qtop : 18'hzzzz;
 assign dbus = alu2dbus ? aluout : 18'hzzzz;
 assign dbus = ram2dbus ? ramout : 18'hzzzz;
 assign dbus = in2dbus ? in[irout[2:0]] : 18'hzzzz;
 assign dbus = pushpc ? pcnext : 18'hzzzz; // added by BRL4 to support PUSHPC opcode

 
 always @(cs or irout or qtop )
   begin
     halt = 0; pcinc = 0; jump = 0; push = 0; pop = 0; pop2 = 0; 
	  thru = 0; dbus2qtop = 0; dbus2ram = 0; dbus2obuf = 0; ir2dbus = 0; 
	  qtop2dbus = 0; alu2dbus = 0; ram2dbus = 0; in2dbus = 0; ir2abus = 0; 
	  qtop2abus = 0; qnext2abus = 0; 
	  poppc = 0; pushpc = 0; // added to support poppc and pushpc
	  execToEndInt = 0; timerOvfChanged =0;
	  
  if(cs == `EXEC) begin
    case(irout[15:12])
      `PUSHI:
         begin
           ir2dbus = 1; dbus2qtop = 1; push = 1; pcinc = 1;
         end	 
      `PUSH: 
         begin
           ir2abus = 1; push = 1; thru = 1; pcinc = 1;
         end
      `POP:
         begin
           ir2abus = 1; qtop2dbus = 1; dbus2ram = 1; pop = 1; pcinc = 1;
         end
      `JMP: jump = 1;
      `JZ:
           begin
             if(qtop == 0) jump = 1;
             else pcinc = 1;
             pop = 1;
           end
      `JNZ: 
          begin
            if(qtop != 0) jump = 1;
             else pcinc = 1;
             pop = 1;
          end
      `LD:
         begin
           qtop2abus = 1; thru = 1; pcinc = 1;
         end
      `ST:
         begin
           qnext2abus = 1; qtop2dbus = 1; dbus2ram = 1; pop2 = 1; pcinc = 1;
         end
		// added by BRL4 //////////////////////////////// 
		 `PPPC:
		  if(irout[0] == 0) //pushpc
			begin
				pushpc = 1; dbus2qtop = 1; push = 1; pcinc = 1;
			end
			
			else //poppc
			begin
				poppc = 1;  pop = 1;
			end
		// end addition ////////////////////////////////
		// added by rk447. Interrupts /////////////////////////////
		`INT:
		begin
			case(irout[7:4])
			/* 4'h1:  set/clear global int. RetI instruction
				4'h2:  clear an interrupt flag
				4'h3:  set an interrupt flag
				4'h4:  Mask an interrupt
				4'h5:  Unmask an interrupt
			*/
				4'h1: 
				begin
					/*if (irout[3:0] == 4'd0) begin//clear global interrupt
						gieCode = 1'b0;
						pcinc   = 1'b1;
					end
					else if (irout[3:0] == 4'd1) begin//set global interrupts
						gieCode = 1'b1;
						pcinc   = 1'b1;
					end					
					else*/ if (irout[3:0]== 4'd2) begin //RETI instruction. 2
						//change state to INT_END
						execToEndInt = 1'b1;//cause a transition from exec to end int
					end
				end//end 4'h1
				/*4'h2: begin//clear an interrupt flag
					intDataType = 3'd0;
					qtop2dbus   = 1'b1;//get data from the stack
					pcinc  = 1'b1;
				end//end 4'h2*/
				/*4'h3: begin//set an interrupt flag
					intDataType = 3'd1;
					qtop2dbus   = 1'b1;
					//pcinc = 1'b1;TODO
				end//end 4'h3
				4'h4: begin //mask (disable an interrupt) 
					intDataType    = 3'd2;
					qtop2dbus   = 1'b1;
					pcinc     = 1'b1;
					//clear it's interrupt flag?
				end//end 4'h4
				4'h5: begin //unmask an interrupt
					intDataType = 3'd3;
					qtop2dbus   = 1'b1;
					pcinc    = 1'b1;
				end//end 4'h5*/
				4'h6:begin//update the timer overflow value
				    timerOvfChanged = 1'b1;
					//intDataType = 3'd4;
					qtop2dbus   = 1'b1;
					pcinc    = 1'b1;
					//pop = 1'b1;
				end
				
				default: pcinc = 1;
		   endcase//end interrupt irout[7:4]
		end//end `INT*/
		//end addition rk447
     `IN:
         begin
          in2dbus = 1; dbus2qtop = 1; push = 1; pcinc = 1;
         end
      `OUT:
         begin
           qtop2dbus = 1; dbus2obuf = 1; pop = 1; pcinc = 1;
         end
      `OP:
           begin
             alu2dbus = 1; dbus2qtop = 1; pcinc = 1;
             if(irout[4] == 0) pop = 1; //binary operations
				 // do nothing for bnot, neg, not
				 if(irout[4:0]==5'b10011) push = 1;  // dup
				 if(irout[4:0]==5'b10111) pop = 1;  // drop
				 if(irout[4:0]==5'b11111) push = 1; // over
				 if(irout[4:0]==5'b11011) pop = 1;  // dropnext
				 if(irout[4:0]==5'b10100) pop = 1;  // arithmetic shift right
				 if(irout[4:0]==5'b10101) pop = 1;  //fixed mult
           end
			  
       default:
         begin
           pcinc = 1 ; // halt=1; change opcode zero to NOP
         end
      endcase//end irout[15:12]
  end//end (cs==EXEC)
  else if (cs== `INT_BEGIN) begin//enter interrupt
		//ram2dbus = 1'b1; //data from ram to pcnext. NOt needed
		//SFinsideIntBegin = 1'b1;
  end
  
  else if (cs== `INT_END) begin //leave interrupt
		//execToEndInt = 1'b1;//restore program counter. Done in reti
  end//end cs == `INT_END
  //TODO: already taken care of above
end//end always
endmodule//end minicpu

//module for storing interrupt registers
module interruptHardware(clk,reset,key1new,key2new,key3new, unusedIntIn,gieIn,timerIntOut,
interruptFlags, LEDGout, intData, returnFromInt, intDataType,
IHexecToBeginInt, timerOvfIn
); 
input clk,reset,key1new,key2new,key3new, unusedIntIn, gieIn,returnFromInt;
input [17:0] intData;//data from the stack
input [2:0] intDataType;
input [17:0] timerOvfIn;
//input [11:0] pcReturn;
output reg timerIntOut;
output reg [2:0] interruptFlags;
output reg [8:0] LEDGout;
output reg IHexecToBeginInt;//used to change state in statef

reg key1old, key2old, key3old;
//reg [4:0] interruptFlags;//send this to the cpu and its state machine
reg [4:0] interruptMask;//1 to unmask an interrupt
reg gieLocal; //used to turn off other interrupts when one interrupt is received
wire gieReg; //global interrupt enable flag. Input from gieIn and gieLocal
assign gieReg = gieLocal;// & gieIn;
//counter stuff
parameter counterLen = 18;
reg [counterLen-1:0] counter;
//parameter countVal   = 18'd50400000;//32'd47547170;
reg [17:0] counterOverflow;//should be 18 bits
/////////////////////////////////////////
always @ (posedge clk   or negedge reset)
begin
	if(~reset) begin
		key1old <= 1'b0;
		key2old <= 1'b0;
		key3old <= 1'b0;
		gieLocal <= 1'b1;//disable interrupts
		interruptFlags <= 3'd0;
		IHexecToBeginInt <= 1'b0;
		interruptMask  <= 5'b01111;//5'd0;TODO
		counter     <= 18'd0;
		//
		timerIntOut <= 1'b0;
		LEDGout[7:0]     <= 3'd0;
		LEDGout[8]      <= 1'b1;
	//	SFinsideIntBeginSignal <= 1'b0;
		counterOverflow <= 18'd50400 ; //1ms initial value
	end//reset
	else begin //not reset condition
	   //set a new timer overflow value if applicable
		if (timerOvfIn >0 ) begin
			counter <= 32'd0;
			counterOverflow <= timerOvfIn;
			//interruptMask[0] <= 1'b1;
		end
	   //check what kind of interrupt instruction has been sent
		case(intDataType)
		3'd0: begin//clear an interrupt flag
			//interruptFlags[intData[2:0]] <= intData[2:0]; //clear flag indexed by intData[2:0] (0..4)
		end
		3'd1: begin //set an interrupt flag
			//interruptFlags[intData[2:0]] <= intData[2:0]; 
		end
		3'd2: begin // mask an interrupt (write a 0)
			//interruptMask[intData[2:0]] <= intData[2:0]; 
		end
		3'd3: begin //unmask an interrupt
			//interruptMask[intData[2:0]] <= 1'b1; 
		end
		3'd4: begin//set timer overflow
			//counterOverflow    <= intData;
		end
		//default: 
		endcase
		key1old <= key1new;
		key2old <= key2new;
		key3old <= key3new;
		LEDGout[7:5] <= interruptFlags;
		//////////////////
		if (gieReg) begin //global interrupts enabled
				if (counter == counterOverflow && interruptMask[0]) begin//timer interrupt. TODO countVal
					interruptFlags <= 3'd1;
					IHexecToBeginInt <= 1'b1;					
					counter           <= 32'd0;
					gieLocal            <= 1'b0; //disable further interrupts
					timerIntOut       <= 1'b1;//TODO
					
					LEDGout[4]        <= ~LEDGout[4];
				end
				else begin
					counter           <= counter + 1'b1;
				//	interruptFlags[0] <= 1'b0;
				end
				 if (~key1new && key1old && interruptMask[1]) begin//falling edge key1
					interruptFlags <= 3'd2;
					IHexecToBeginInt <= 1'b1;
			
					gieLocal            <= 1'b0; //disable further interrupts
					LEDGout[0]        <= ~LEDGout[0];
				end
				/*else begin
					interruptFlags <= 3'd0;
					IHexecToBeginInt <= 1'b0;
				end*/
				else if (~key2new && key2old && interruptMask[2]) begin//key 2
					interruptFlags <= 3'd3;
					IHexecToBeginInt <= 1'b1;
			
					gieLocal            <= 1'b0; //disable further interrupts
					LEDGout[1]        <= ~LEDGout[1];
				end
				/*else begin
					interruptFlags <= 3'd0;
					IHexecToBeginInt <= 1'b0;
				end*/
				else if (~key3new && key3old && interruptMask[3]) begin//key 3
					interruptFlags <= 3'd4;
					IHexecToBeginInt <= 1'b1;
			
					gieLocal            <= 1'b0; //disable further interrupts
					LEDGout[2]        <= ~LEDGout[2];
				end
				/*else begin
					interruptFlags[3] <= 1'b0;
				end*/

				else if (unusedIntIn && interruptMask[4]) begin //unused Interrupt
				   //IHexecToBeginInt  <= 1'b1;
					//interruptFlags <= 3'd5;
					//SFinsideIntBeginSignal    <= 1'b1;
					//gieLocal            <= 1'b0; //disable further interrupts
				end
				else begin//no interrupt
					//interruptFlags <= 3'd0;TODO: just latch its most recent value
					//IHexecToBeginInt <= 1'b0;
				end
		end//end gie
		else begin//global interrupts disabled
			interruptFlags <= 5'd0;
			IHexecToBeginInt <= 1'b0;
	//		SFinsideIntBeginSignal <= 1'b0;
		end//end gie disabled
		if (interruptFlags > 0) begin//software generated interrupt
			IHexecToBeginInt  <= 1'b0;
			//interruptFlags <= 3'd0; //reset flags so cpu can stay in EXEC state
			//gieLocal    <= 1'b0;?
		end
		//counter stuff
		//counter     <= counter + 1'b1;
		if (returnFromInt) begin//returned from an interrupt
			interruptFlags <= 3'd0;
	//		SFinsideIntBeginSignal <= 1'b0;
			gieLocal       <= 1'b1; //enable further interrupts to be taken
		end
	end//not reset cond
end//end always
endmodule//end interruptHardware


//for timing how long it takes for an interrupt to occur
///////////////////////////////////////////////////
module timeCounter(
input reset,
input clk,
input restart,//when computation restarts
input computationDone,
output [3:0] hundreds,
output [3:0] tens,
output [3:0] ones,
output [3:0] tenth,//100ms
output [3:0] hundredth,//10ms
output [3:0] thousandth,//1ms
output LEDG9,
output [7:0] LEDG7to0
);
localparam msCount = 16'd50400;
//localparam ten_msCount = 19'd504000;//number of counts to get 10ms
reg [15:0] tempCounter; //actually counts cycles of sram clock
reg [3:0] tenthReg, hundredthReg, thousandthReg;
reg [3:0] onesReg,tensReg,hundredsReg;
assign thousandth = thousandthReg;
assign hundredth = hundredthReg;
assign tenth = tenthReg;
assign ones = onesReg;
assign tens = tensReg;
assign hundreds = hundredsReg;

reg [7:0] LEDGreg;
reg LEDG9reg;
assign LEDG9 = LEDG9reg;
reg LEDGreg2;
assign LEDG7to0 = LEDGreg2;

//reg computationDoneOld;
always @ (posedge clk) //50 MHZ counter
begin
	if (~reset || restart) begin
		tenthReg <= 4'd0;
		hundredthReg <=4'd0;
		thousandthReg <= 4'd0;
		onesReg  <=4'd0;
		tensReg  <= 4'd0;
		hundredsReg <= 4'd0;
		tempCounter <= 19'd0;
		LEDGreg2 <= 1'd0;
		LEDG9reg    <= 1'b0;
	end//end reset condition
	else begin//not in reset

		 if (~computationDone) begin
		    LEDG9reg    <= 1'b0;
			 tempCounter <= tempCounter + 1'b1;
			   if (tempCounter == msCount-1'b1) begin //ms passed
					//if (tempCounter == ten_msCount) begin
					 tempCounter  <= 16'd0;	
			       thousandthReg <= thousandthReg + 1'b1;
					 if (thousandthReg == 4'd9) begin
						 thousandthReg  <= 4'd0;
						 hundredthReg   <= hundredthReg + 1'b1;
					 end				
					 if (hundredthReg == 4'd9) begin
						  hundredthReg <= 4'd0;
						  tenthReg     <= tenthReg + 1'b1;
					 end
					 if (tenthReg ==4'd9) begin
						  tenthReg     <= 4'd0;
						  onesReg  <= onesReg + 1'b1;
					 end
					 if (onesReg ==4'd9) begin
							onesReg <= 4'd0;
							tensReg <= tensReg + 1'b1;
					 end
					 if (tensReg == 4'd9) begin
							tensReg <= 4'd0;
							hundredsReg <= hundredsReg + 1'b1;
					 end
			  end//end 1 ms passed
		 end//end not computation done
		 else begin//computation done
				LEDG9reg <= 1'b1;
				LEDGreg2 <=hundredthReg;
				//LEDGreg2[7:4] <= tensReg;
		 end
	end//end not in reset condition
end//end always
endmodule

module slowClockGen(clk_in,clk_out,reset);
input clk_in,reset;
output reg clk_out;
parameter clkHalfPer = 37500000;
reg [31:0] counter;

always @ (posedge clk_in)
begin
	if(~reset) begin
		counter <= 32'd0;
		clk_out <= 1'b0;
	end
	else begin
		counter <= counter + 1'b1;
		if (counter== clkHalfPer) begin
		   counter <= 32'd0;
			clk_out <= ~clk_out;
		end
   end
end
endmodule



//////////////////////////////////////////
//// end file //////////////////////////////////////