// --------------------------------------------------------------------
// --------------------------------------------------------------------
//
// Major Functions: Rs232 serial and LCD control
// from minicpu
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
// Bruce R Land, Cornell University, Oct 2011
// Bruce R Land, Cornell University, Nov 2010
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

   //Turn off all displays.
   assign HEX0 = 7'h7F;
   assign HEX1 = 7'h7F;
   assign HEX2 = 7'h7F;
   assign HEX3 = 7'h7F;
   assign HEX4 = 7'h7F;
   assign HEX5 = 7'h7F;
   assign HEX6 = 7'h7F;
   assign HEX7 = 7'h7F;
  // assign LEDR = 18'h0;
  // assign LEDG = 9'h0;
   
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

   //Enable LCD.
   //assign LCD_BLON = 1'b1;
   //assign LCD_DATA = 8'hzz;
   //assign LCD_EN   = 1'b0;
   //assign LCD_ON   = 1'b1;
   //assign LCD_RS   = 1'b0;
   //assign LCD_RW   = 1'b0;

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

   //Disable SRAM.
   assign SRAM_ADDR = 18'h0;
   assign SRAM_CE_N = 1'b1;
   assign SRAM_DQ   = 16'hzzzz;
   assign SRAM_LB_N = 1'b1;
   assign SRAM_OE_N = 1'b1;
   assign SRAM_UB_N = 1'b1;
   assign SRAM_WE_N = 1'b1;

   //Disable VGA.
   
   assign VGA_CLK   = 1'b0;
   assign VGA_BLANK = 1'b0;
   assign VGA_SYNC  = 1'b0;
   assign VGA_HS    = 1'b0;
   assign VGA_VS    = 1'b0;
   assign VGA_R     = 10'h0;
   assign VGA_G     = 10'h0;
   assign VGA_B     = 10'h0;
   

   //Disable all other peripherals.
   //assign I2C_SCLK = 1'b0;
   assign IRDA_TXD = 1'b0;
   //assign TD_RESET = 1'b0;
   assign TDO = 1'b0;
   //assign UART_TXD = 1'b0;
   
// reset
wire reset ;
assign reset = KEY[2] ;
assign LEDG[7] = KEY[2] ;
wire [17:0] serial_out, LCD_out ;

// define the CPU
minicpu cpu1(.clk(CLOCK_50), .reset(reset), .run(1'b1), 
	// 7:0 is the char, 8 is receiving, 9 is data ready, 
	// 10 is transmitter busy, 11 is new character ready
	.in0({6'b0,char_ready, transmitting_data, data_received, receiving_data, received_data}), 
	.out0(serial_out),
	.in1({17'b0, LCD_done}),
	.out1(LCD_out), // LCD_out needs 9-bit data, reset, and data strobe {7'b0, reset, strobe, [8:0] data}
	.out2(LEDR),
  	);

///////////////////////////////////////////////////////
/* 

The following serial routines were written by:

Dr. John S. Loomis
Associate Professor
Electrical and Computer Engineering
University of Dayton
Dayton, OH 45469-0232

Office: KL-341 D
Phone: (937) 229-3981
EMail: John.Loomis@notes.udayton.edu 

See:
http://www.johnloomis.org/digitallab/

*/
///////////////////////////////////////////////////////
wire [7:0] transmit_data, received_data;
wire transmit_data_en, transmitting_data, data_received, receiving_data, read_done ;
reg char_ready, last_data_received ;

assign transmit_data = serial_out[7:0];
assign transmit_data_en = serial_out[8];
assign read_done = serial_out[9];

always @(posedge read_done or posedge data_received )
begin
	if (read_done) char_ready <= 0 ;
	else if (data_received) char_ready <= 1;
end

wire txd;
assign UART_TXD = txd ;
assign GPIO_0[0] = txd ;

RS232_Out u2(
// Inputs
.clk(CLOCK_50),
.reset(~reset),
.transmit_data_in(transmit_data),
.transmit_data_en(transmit_data_en),
// Outputs
.serial_data_out(txd), // UART_TXD
.transmitting_data(transmitting_data)
);

RS232_In u3(
// Inputs
.clk(CLOCK_50),
.reset(~reset),
.serial_data_in(UART_RXD), // UART_RXD
.receive_data_en(1'b1),
// Outputs
.received_data(received_data), // serial char
.data_received(data_received), // receive complete signal
.receiving_data(receiving_data)
);

///////////////////////////////////////////////////////
/* 

The following LCD routines were written by:

Dr. John S. Loomis
Associate Professor
Electrical and Computer Engineering
University of Dayton
Dayton, OH 45469-0232

Office: KL-341 D
Phone: (937) 229-3981
EMail: John.Loomis@notes.udayton.edu 

See:
http://www.johnloomis.org/digitallab/

*////////////////////////////////////////////////////////
//wire	DLY_RST;
//Reset_Delay r0( .iCLK(CLOCK_50),.oRESET(DLY_RST), .iReset(~reset) );

//wire [8:0] char_code ;
wire  LCD_done ;
assign LEDG[0] = LCD_done ;
assign LEDG[1] = LCD_out[9] ; // char strobe
assign LEDG[2] = LCD_out[10] ; // reset
assign LCD_ON   = LCD_out[11] ; // power
assign LCD_BLON = LCD_out[11] ; // backlight power

LCD lcd_cntl(
// Host Side
   .iCLK(CLOCK_50),
   .iRST_N(~LCD_out[10]), //DLY_RST ~LCD_out[10]
	.char_code(LCD_out[8:0]),
	.char_strobe(LCD_out[9]),
	.done(LCD_done), 
// LCD Side
   .LCD_DATA(LCD_DATA),
   .LCD_RW(LCD_RW),
   .LCD_EN(LCD_EN),
   .LCD_RS(LCD_RS)
);

endmodule //top module

///////////////////////////////////////////////////
//// signed mult of 10.8 format 2'comp ////////////
///////////////////////////////////////////////////
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
// Bruce Land 2010-2011
////////////////////////////////////////////////////////////

`define IDLEA 2'b00
`define IDLEB 2'b01
`define EXEC 2'b10

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
     `MUL : s = mout ; // b * a;
     `SHL : s = b << a;
     `SHR : s = b >> a;
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

/*///////////////////////////////////
module statef(clk,reset,run,halt,cs);
   
  input clk, reset, run, halt;
  output [1:0] cs;
  reg [1:0] cs;

  always @(posedge clk or negedge reset)
    if(!reset) cs <= `IDLEA;
    else
      case(cs)
        `IDLEA: if(run) cs <= `IDLEB;
        `IDLEB: cs <= `EXEC;
        `EXEC: if(halt) cs <= `IDLEA;
                else cs <= `EXEC;
		  //`EXEC:  cs <= `EXEC;
        default: cs <= 2'bxx;
      endcase

endmodule
*/

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
module dpram(clk, load1, addr1, addr2, d1, q1, q2);
 parameter DWIDTH=18,AWIDTH=12,WORDS=4096;

 input clk,load1 ; //,load2;
 input [AWIDTH-1:0] addr1,addr2;
 input [DWIDTH-1:0] d1 ; //,d2;
 output [DWIDTH-1:0] q1,q2;
 reg [DWIDTH-1:0] q1,q2;
 reg [DWIDTH-1:0] mem [WORDS-1:0] /* synthesis ram_init_file = "serial_lcd.mif" */ ;

 always @(posedge clk)
   begin
     if(load1) mem[addr1] <= d1;
     q1 <= mem[addr1];
  end

 always @(posedge clk)
   begin
//     if(load2) mem[addr2] <= d2;
     q2 <= mem[addr2];
  end

//  initial begin
//		mem[12'h000]=16'hd000;
//		mem[12'h001]=16'he000;
//		mem[12'h002]=16'h4000;
//  end

endmodule
//////////////////////////////////////

module minicpu(clk, reset, run, in0, in1, in2, in3, out0, out1, out2, out3);

 input clk,reset,run;
 input [17:0] in0, in1, in2, in3 ;
 output [17:0] out0, out1, out2, out3;
 
 reg [1:0] cs;
 wire [17:0] irout, qtop, dbus ;
 wire [17:0] qnext, ramout, aluout;
 reg [11:0] abus;
 reg halt, jump, pcinc, push, pop, thru, qthru, dbus2qtop;
 reg dbus2ram, dbus2obuf, ir2dbus, qtop2dbus, alu2dbus, ram2dbus, in2dbus;
 reg pop2, ir2abus, qtop2abus, qnext2abus;
 reg poppc, pushpc ; // added by BRL4 to support POPPC/PUSHPC opcode
 reg [11:0] pcout, pcnext;
 reg [17:0] out[7:0] ;
 wire [17:0] in[7:0] ;

 //statef statef0(.clk(clk),.reset(reset),.run(run),.halt(halt),.cs(cs));
 // moved state generator into cpu main module
  always @(posedge clk or negedge reset) 
  begin
    if(!reset) cs <= `IDLEA;
    else
      case(cs)
        `IDLEA: if(run) cs <= `IDLEB;
        `IDLEB: cs <= `EXEC;
        `EXEC: if(halt) cs <= `IDLEA;
                else cs <= `EXEC;
		  //`EXEC:  cs <= `EXEC;
        default: cs <= 2'bxx;
      endcase
  end
		
 stackm stackm0(.clk(clk),.reset(reset),.load(dbus2qtop),.push(push),
	.pop(pop),.pop2(pop2),.thru(qthru),.d(dbus),.dthru(ramout),.qtop(qtop),.qnext(qnext));
 alu alu0(.a(qtop),.b(qnext),.f(irout[4:0]),.s(aluout));
 dpram #(18,12,4096) dpram0(.clk(clk),.load1(dbus2ram),.addr1(abus),.addr2(pcnext),.d1(dbus),.q1(ramout),.q2(irout));

 always @ (pcinc or jump or cs or pcout or irout or poppc or qtop)
   if(cs == `IDLEB) pcnext = pcout;
   else if(pcinc)  pcnext = pcout + 1;
   else if(jump)  pcnext = irout[11:0];
	else if(poppc) pcnext = qtop[11:0]; // added to support POPPC opcode
   else pcnext = 12'hxxx;

 always @ (posedge clk or negedge reset)
   if(!reset) pcout <= 0;
   else if(pcinc || jump || poppc) pcout <= pcnext; // mod to support poppc

 // update the output ports
 always @ (posedge clk)
   if(dbus2obuf) out[irout[2:0]] <= dbus ;
	
 // only 4 of the 8 ports are external
 assign out0 = out[0];
 assign out1 = out[1];
 assign out2 = out[2];
 assign out3 = out[3];
 
 // only 4 of the 8 ports are external
 assign in[0] = in0;
 assign in[1] = in1;
 assign in[2] = in2;
 assign in[3] = in3;

 always @ (posedge clk or negedge reset)
   if(!reset) qthru <= 0;
   else qthru <= thru;

 always @ (ir2abus or qtop2abus or qnext2abus or irout or qtop or qnext)
 if(ir2abus) abus = irout[11:0];
 else if(qtop2abus) abus = qtop[11:0];
 else if(qnext2abus) abus = qnext[11:0];
 else abus = 12'hxxx;

 assign dbus = ir2dbus ? {{6{irout[11]}},irout[11:0]} : 18'hzzzz;
 assign dbus = qtop2dbus ? qtop : 18'hzzzz;
 assign dbus = alu2dbus ? aluout : 18'hzzzz;
 assign dbus = ram2dbus ? ramout : 18'hzzzz;
 assign dbus = in2dbus ? in[irout[2:0]] : 18'hzzzz;
 assign dbus = pushpc ? pcnext : 18'hzzzz; // added by BRL4 to support PUSHPC opcode

 always @(cs or irout or qtop)
   begin
     halt = 0; pcinc = 0; jump = 0; push = 0; pop = 0; pop2 = 0; 
	  thru = 0; dbus2qtop = 0; dbus2ram = 0; dbus2obuf = 0; ir2dbus = 0; 
	  qtop2dbus = 0; alu2dbus = 0; ram2dbus = 0; in2dbus = 0; ir2abus = 0; 
	  qtop2abus = 0; qnext2abus = 0; 
	  poppc = 0; pushpc = 0; // added to support poppc and pushpc
	  
  if(cs == `EXEC)
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
				 if(irout[4:0]==5'b10111) pop = 1; // drop
				 if(irout[4:0]==5'b11111) push = 1; // over
				 if(irout[4:0]==5'b11011) pop = 1;  // dropnext
           end
			  
       default:
         begin
           pcinc = 1 ; // halt=1; change opcode zero to NOP
         end
      endcase
  end

endmodule
// end of processor

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
/* 

The following serial routines were written by:

Dr. John S. Loomis
Associate Professor
Electrical and Computer Engineering
University of Dayton
Dayton, OH 45469-0232

Office: KL-341 D
Phone: (937) 229-3981
EMail: John.Loomis@notes.udayton.edu 

See:
http://www.johnloomis.org/digitallab/

*/
///////////////////////////////////////////////////////

module RS232_In (
// Inputs
input clk,
input reset,
input serial_data_in,
input receive_data_en,
// Outputs
output reg [(DATA_WIDTH-1):0] received_data,
output reg receiving_data,
output reg data_received,
output baud_clock
);
//434 is 115200 baud (5e7/115200)
// 5250 is 9600 baud (50.4e6/9600) with FAST_CLK
// 5208 is 9600 baud (50e6/9600) with CLOCK_50
parameter BAUD_COUNT = 16'd5208;
parameter DATA_WIDTH = 8;
parameter TOTAL_DATA_WIDTH = DATA_WIDTH + 2;

wire shift_data_reg_en;
wire all_bits_received;


assign baud_clock = shift_data_reg_en;
reg [(TOTAL_DATA_WIDTH - 1):0]	data_in_shift_reg;
//reg receiving_data;
reg prev_receiving_data;



always @(posedge clk)
begin
	if (reset == 1'b1)
		receiving_data <= 1'b0;
	else if (all_bits_received == 1'b1)
		receiving_data <= 1'b0;
	else if (serial_data_in == 1'b0)
		receiving_data <= 1'b1;
end

always @(posedge clk)
begin
	prev_receiving_data  <= receiving_data;
	if (receiving_data==1'b1)
		data_received <= 1'b0;
	else if (prev_receiving_data==1'b1)
	begin
		data_received <= 1'b1;
		received_data <= data_in_shift_reg[DATA_WIDTH:1];
	end
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		data_in_shift_reg	<= {TOTAL_DATA_WIDTH{1'b0}};
	else if (shift_data_reg_en)
		data_in_shift_reg	<= 
			{serial_data_in, data_in_shift_reg[(TOTAL_DATA_WIDTH - 1):1]};
end

Baud_Counter RS232_In_Counter (
// Inputs
.clk(clk),
.reset(reset),
.reset_counters(~receiving_data),
// Outputs
.baud_clock_rising_edge(),
.baud_clock_falling_edge(shift_data_reg_en),
.all_bits_transmitted(all_bits_received)
);
defparam 
	RS232_In_Counter.BAUD_COUNT= BAUD_COUNT,
	RS232_In_Counter.DATA_WIDTH= DATA_WIDTH;

endmodule

//////////////////////////////////////////////////////////
///////////////////////////////////////////////////////
/* 

The following serial routines were written by:

Dr. John S. Loomis
Associate Professor
Electrical and Computer Engineering
University of Dayton
Dayton, OH 45469-0232

Office: KL-341 D
Phone: (937) 229-3981
EMail: John.Loomis@notes.udayton.edu 

See:
http://www.johnloomis.org/digitallab/

*/
///////////////////////////////////////////////////////
module RS232_Out(
// Inputs
input clk,
input reset,
	
input [DATA_WIDTH:1] transmit_data_in,
input transmit_data_en,

// Outputs
output reg serial_data_out,
output reg transmitting_data
);

parameter DATA_WIDTH = 8;
//434 is 115200 baud (5e7/115200)
// 5208 is 9600 baud (5e7/9600)
parameter BAUD_COUNT = 16'd5208; 

wire shift_data_reg_en, read_input_en;
//wire baud_clock;
wire all_bits_transmitted;

// debug outputs
//assign baud_clock = shift_data_reg_en;
//assign next_bit = data_out_shift_reg[0];

reg [DATA_WIDTH:0] data_out_shift_reg;
// local copy of input so that input can be cleared
wire [DATA_WIDTH:1] transmit_data ;
assign transmit_data = transmit_data_in ;

initial
begin
	serial_data_out <= 1'b1;
	data_out_shift_reg	<= {(DATA_WIDTH + 1){1'b1}}; // all ones
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		serial_data_out <= 1'b1; 
	else
		serial_data_out <= data_out_shift_reg[0]; //next bit
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		transmitting_data <= 1'b0;
	else if (all_bits_transmitted == 1'b1)
		transmitting_data <= 1'b0;
	else if (transmit_data_en)
		transmitting_data <= 1'b1;
		//transmit_data <= transmit_data_in ;
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		data_out_shift_reg	<= {(DATA_WIDTH + 1){1'b1}}; // all ones
	else if (read_input_en)
		data_out_shift_reg	<=  {transmit_data,1'b0};
	else if (shift_data_reg_en)
		data_out_shift_reg	<= 
			{1'b1, data_out_shift_reg[DATA_WIDTH:1]};
end

assign read_input_en = ~transmitting_data & ~all_bits_transmitted & transmit_data_en;

Baud_Counter Out_Counter (
// Inputs
.clk(clk), .reset(reset), .reset_counters(~transmitting_data),
// Outputs
.baud_clock_rising_edge(shift_data_reg_en),
.baud_clock_falling_edge(),
.all_bits_transmitted(all_bits_transmitted)
);
defparam
	Out_Counter.BAUD_COUNT = BAUD_COUNT,
	Out_Counter.DATA_WIDTH = DATA_WIDTH;

endmodule
/////////////////////////////////////////////////

module Baud_Counter (
	// Inputs
input	clk,
input	reset,
	
input	reset_counters,

	// Outputs
output reg baud_clock_rising_edge,
output reg baud_clock_falling_edge,
output reg all_bits_transmitted
);

parameter BAUD_COUNTER_WIDTH = 16; //9
parameter BAUD_COUNT =  5; // overridden by upper level module
parameter BAUD_TICK_COUNT =  BAUD_COUNT - 1; //9'd433;
parameter HALF_BAUD_TICK_COUNT	= BAUD_COUNT / 2; //9'd216;

parameter DATA_WIDTH = 8;//9;
parameter TOTAL_DATA_WIDTH = DATA_WIDTH + 2;

reg [(BAUD_COUNTER_WIDTH - 1):0] baud_counter;
reg [3:0] bit_counter;

// control baud_counter
always @(posedge clk)
begin
	if (reset == 1'b1)
		baud_counter <= {BAUD_COUNTER_WIDTH{1'b0}};
	else if (reset_counters)
		baud_counter <= {BAUD_COUNTER_WIDTH{1'b0}};
	else if (baud_counter == BAUD_TICK_COUNT)
		baud_counter <= {BAUD_COUNTER_WIDTH{1'b0}};
	else
		baud_counter <= baud_counter + 1'b1;
end

// control baud_clock_rising_edge signal
always @(posedge clk)
begin
	if (reset == 1'b1)
		baud_clock_rising_edge <= 1'b0;
	else if (baud_counter == BAUD_TICK_COUNT)
		baud_clock_rising_edge <= 1'b1;
	else
		baud_clock_rising_edge <= 1'b0;
end

// control baud_clock_falling_edge signal
always @(posedge clk)
begin
	if (reset == 1'b1)
		baud_clock_falling_edge <= 1'b0;
	else if (baud_counter == HALF_BAUD_TICK_COUNT)
		baud_clock_falling_edge <= 1'b1;
	else
		baud_clock_falling_edge <= 1'b0;
end

// control bit counter
always @(posedge clk)
begin
	if (reset == 1'b1)
		bit_counter <= 4'h0;
	else if (reset_counters)
		bit_counter <= 4'h0;
	else if (bit_counter == TOTAL_DATA_WIDTH)
		bit_counter <= 4'h0;
	else if (baud_counter == BAUD_TICK_COUNT)
		bit_counter <= bit_counter + 4'h1;
end

// control all_bits_transmitted signal
always @(posedge clk)
begin
	if (reset == 1'b1)
		all_bits_transmitted <= 1'b0;
	else if (bit_counter == TOTAL_DATA_WIDTH)
		all_bits_transmitted <= 1'b1;
	else
		all_bits_transmitted <= 1'b0;
end

endmodule

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
/* 

The following LCD routines were written by:

Dr. John S. Loomis
Associate Professor
Electrical and Computer Engineering
University of Dayton
Dayton, OH 45469-0232

Office: KL-341 D
Phone: (937) 229-3981
EMail: John.Loomis@notes.udayton.edu 

See:
http://www.johnloomis.org/digitallab/
*//////////////////////////////////////////////
/// LCD control ///////////////////////////////
///////////////////////////////////////////////

module    LCD (
// Host Side
  input iCLK,iRST_N,
  input [8:0] char_code,
  input  char_strobe,
  output reg done,
// LCD Side
  output [7:0]     LCD_DATA,
  output LCD_RW,LCD_EN,LCD_RS    
);
//    Internal Wires/Registers
reg    [5:0]    LUT_INDEX;
reg    [8:0]    LUT_DATA;
reg    [5:0]    mLCD_ST;
reg    [17:0]    mDLY;
reg        mLCD_Start;
reg    [7:0]    mLCD_DATA;
reg        mLCD_RS;
wire        mLCD_Done;
reg  internal_strobe, last_char_strobe ;

parameter    LCD_INTIAL    =    0;
parameter    LCD_LINE1    =    8;
parameter    LCD_CH_LINE    =    LCD_LINE1+16;
parameter    LCD_LINE2    =    LCD_LINE1+16+1;
parameter    LUT_SIZE    =    LCD_LINE1+32+1;

always@(posedge iCLK or negedge iRST_N ) //or negedge iRST_N
begin
	 
    if(!iRST_N)
    begin
        LUT_INDEX    <=    0;
        mLCD_ST        <=    0;
        mDLY        <=    0;
        mLCD_Start    <=    0;
        mLCD_DATA    <=    0;
        mLCD_RS        <=    0;
		  internal_strobe <= 0; 
		  last_char_strobe <= 0 ;
		  done <= 0 ;
    end
    else
    begin
		  if (char_strobe & ~last_char_strobe & ~internal_strobe & (LUT_INDEX==LUT_SIZE)) 
		  begin
				internal_strobe <= 1; 
				done <= 0 ;
		  end
		  
		  if (char_strobe) last_char_strobe <= 1;
		  else  last_char_strobe <= 0 ;
		  
        if(LUT_INDEX<LUT_SIZE)
        begin
            case(mLCD_ST)
            0:    begin
                    mLCD_DATA    <=    LUT_DATA[7:0];
                    mLCD_RS        <=    LUT_DATA[8];
                    mLCD_Start    <=    1;
                    mLCD_ST        <=    1;
                end
            1:    begin
                    if(mLCD_Done)
                    begin
                        mLCD_Start    <=    0;
                        mLCD_ST        <=    2;                    
                    end
                end
            2:    begin
                    if(mDLY<18'h3FFFE) // 5 mSec
                    mDLY    <=    mDLY + 1'b1;
                    else
                    begin
                        mDLY    <=    0;
                        mLCD_ST    <=    3;
                    end
                end
            3:    begin
                    LUT_INDEX    <=    LUT_INDEX + 1'b1;
                    mLCD_ST    <=    0;
						  if (LUT_INDEX == LUT_SIZE-1) done <= 1; // is this ending correct?
                end
            endcase
        end //if(LUT_INDEX<LUT_SIZE)
		  
		  else if (internal_strobe )
		  begin
            case(mLCD_ST)
            0:    begin
                    mLCD_DATA    <=    char_code;
                    mLCD_RS        <=    char_code[8];
                    mLCD_Start    <=    1;
                    mLCD_ST        <=    1;
                end
            1:    begin
                    if(mLCD_Done)
                    begin
                        mLCD_Start    <=    0;
                        mLCD_ST        <=    2;                    
                    end
                end
            2:    begin
                    if(mDLY<18'hFFFE) // 5msec==3FFFE
                    mDLY    <=    mDLY + 1'b1;
                    else
                    begin
                        mDLY    <=    0;
                        mLCD_ST    <=    3;
                    end
                end
            3:    begin
                    //LUT_INDEX    <=    LUT_INDEX + 1'b1;
                    mLCD_ST    <=    0;
						  internal_strobe <= 0;
						  done <= 1;
                end
            endcase		  
		  end // if (internal_strobe)
    end
end

always @(LUT_INDEX)
begin
    case(LUT_INDEX)
    //    Initial
    LCD_INTIAL+0:    LUT_DATA    <=    9'h038; // need to send initial cmd several times to synch
	 LCD_INTIAL+1:    LUT_DATA    <=    9'h038;
	 LCD_INTIAL+2:    LUT_DATA    <=    9'h038;
	 LCD_INTIAL+3:    LUT_DATA    <=    9'h038;
    LCD_INTIAL+4:    LUT_DATA    <=    9'h00C;
    LCD_INTIAL+5:    LUT_DATA    <=    9'h001;
    LCD_INTIAL+6:    LUT_DATA    <=    9'h006;
    LCD_INTIAL+7:    LUT_DATA    <=    9'h080;
    //    Line 1
    LCD_LINE1+0:    LUT_DATA    <=    9'h120;    //    blanks
    LCD_LINE1+1:    LUT_DATA    <=    9'h120;
    LCD_LINE1+2:    LUT_DATA    <=    9'h120;
    LCD_LINE1+3:    LUT_DATA    <=    9'h120;
    LCD_LINE1+4:    LUT_DATA    <=    9'h120;
    LCD_LINE1+5:    LUT_DATA    <=    9'h120;
    LCD_LINE1+6:    LUT_DATA    <=    9'h120;
    LCD_LINE1+7:    LUT_DATA    <=    9'h120;
    LCD_LINE1+8:    LUT_DATA    <=    9'h120;
    LCD_LINE1+9:    LUT_DATA    <=    9'h120;
    LCD_LINE1+10:    LUT_DATA    <=    9'h120;
    LCD_LINE1+11:    LUT_DATA    <=    9'h120;
    LCD_LINE1+12:    LUT_DATA    <=    9'h120;
    LCD_LINE1+13:    LUT_DATA    <=    9'h120;
    LCD_LINE1+14:    LUT_DATA    <=    9'h120;
    LCD_LINE1+15:    LUT_DATA    <=    9'h120;
    //    Change Line
    LCD_CH_LINE:    LUT_DATA    <=    9'h0C0;
    //    Line 2
    LCD_LINE2+0:    LUT_DATA    <=    9'h120;    //    blanks
    LCD_LINE2+1:    LUT_DATA    <=    9'h120;
    LCD_LINE2+2:    LUT_DATA    <=    9'h120;
    LCD_LINE2+3:    LUT_DATA    <=    9'h120;
    LCD_LINE2+4:    LUT_DATA    <=    9'h120;
    LCD_LINE2+5:    LUT_DATA    <=    9'h120;
    LCD_LINE2+6:    LUT_DATA    <=    9'h120;
    LCD_LINE2+7:    LUT_DATA    <=    9'h120;
    LCD_LINE2+8:    LUT_DATA    <=    9'h120;
    LCD_LINE2+9:    LUT_DATA    <=    9'h120;
    LCD_LINE2+10:    LUT_DATA    <=   9'h120;
    LCD_LINE2+11:    LUT_DATA    <=   9'h120;
    LCD_LINE2+12:    LUT_DATA    <=   9'h120;
    LCD_LINE2+13:    LUT_DATA    <=   9'h120;
    LCD_LINE2+14:    LUT_DATA    <=   9'h120;
    LCD_LINE2+15:    LUT_DATA    <=   9'h120;
    default:        LUT_DATA    <=    9'h121 ;
    endcase
end

LCD_Controller u0(
//    Host Side
.iDATA(mLCD_DATA),
.iRS(mLCD_RS),
.iStart(mLCD_Start),
.oDone(mLCD_Done),
.iCLK(iCLK),
.iRST_N(iRST_N),
//    LCD Interface
.LCD_DATA(LCD_DATA),
.LCD_RW(LCD_RW),
.LCD_EN(LCD_EN),
.LCD_RS(LCD_RS)    );

endmodule
 
/////////////////////////////////////////////////////
/// LCD controller //////////////////////////////////
//////////////////////////////////////////////////////
module LCD_Controller (    
//    Host Side
input [7:0] iDATA,
input iRS,
input iStart,
output reg oDone,
input iCLK,iRST_N,
//    LCD Interface
output [7:0] LCD_DATA,
output LCD_RW,
output reg LCD_EN,
output LCD_RS    );

parameter    CLK_Divide    =    16;

//    Internal Register
reg        [4:0]    Cont;
reg        [1:0]    ST;
reg        preStart,mStart;

/////////////////////////////////////////////
//    Only write to LCD, bypass iRS to LCD_RS
assign    LCD_DATA    =    iDATA; 
assign    LCD_RW        =    1'b0;
assign    LCD_RS        =    iRS;
/////////////////////////////////////////////

always@(posedge iCLK or negedge iRST_N)
begin
    if(!iRST_N)
    begin
        oDone    <=    1'b0;
        LCD_EN    <=    1'b0;
        preStart<=    1'b0;
        mStart    <=    1'b0;
        Cont    <=    0;
        ST        <=    0;
    end
    else
    begin
        //////    Input Start Detect ///////
        preStart<=    iStart;
        if({preStart,iStart}==2'b01)
        begin
            mStart    <=    1'b1;
            oDone    <=    1'b0;
        end
        //////////////////////////////////
        if(mStart)
        begin
            case(ST)
            0:    ST    <=    1;    //    Wait Setup
            1:    begin
                    LCD_EN    <=    1'b1;
                    ST        <=    2;
                end
            2:    begin                    
                    if(Cont<CLK_Divide)
                    Cont    <=    Cont + 1'b1;
                    else
                    ST        <=    3;
                end
            3:    begin
                    LCD_EN    <=    1'b0;
                    mStart    <=    1'b0;
                    oDone    <=    1'b1;
                    Cont    <=    0;
                    ST        <=    0;
                end
            endcase
        end
    end
end

endmodule
////////////////////////////////////////////////////
/// Reset Delay ////////////////////////////////////
////////////////////////////////////////////////////
/*
module Reset_Delay( input iCLK, output reg oRESET, input iReset);
reg [19:0] Cont;

always@(posedge iCLK)
begin
	 if (iReset) Cont <= 0;
    if(Cont!=20'hfFFFF) //hFFFFF
    begin
        Cont <= Cont + 1'b1;
        oRESET <= 1'b0;
    end
    else
    oRESET <= 1'b1;
end

endmodule
*/

////////// end of file //////////////////////////
