/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
// The CPU design is from
// http://www.cs.hiroshima-u.ac.jp/~nakano/wiki/
// and is GPL licensed
//
// See Nakano, K.; Ito, Y., 
// Processor, Assembler, and Compiler Design Education Using an FPGA, 
// Parallel and Distributed Systems, 2008. ICPADS '08. 14th IEEE International Conference on; 
// 8-10 Dec. 2008 pages: 723 - 728 
//////////////////////////////////////////////////////////////////////////////////////////////

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
  // assign HEX0 = 7'h7F;
  // assign HEX1 = 7'h7F;
   assign HEX2 = 7'h7F;
   assign HEX3 = 7'h7F;
   assign HEX4 = 7'h7F;
   assign HEX5 = 7'h7F;
   assign HEX6 = 7'h7F;
   assign HEX7 = 7'h7F;
   //assign LEDR = 18'h0;
   //assign LEDG = 9'h0;
   
   //Set all GPIO to tri-state.
   assign GPIO_0 = 36'hzzzzzzzzz;
   assign GPIO_1 = 36'hzzzzzzzzz;

   //Disable audio codec.
   assign AUD_DACDAT = 1'b0;
   assign AUD_XCK    = 1'b0;

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
   assign I2C_SCLK = 1'b0;
   assign IRDA_TXD = 1'b0;
   assign TD_RESET = 1'b0;
   assign TDO = 1'b0;
   assign UART_TXD = 1'b0;
   
	wire reset ;
	assign reset = KEY[0];
	
	wire cpu_clk ;
//	reg [24:0] counter ;
//	always @(posedge CLOCK_50)
//	begin
//		counter <= counter + 25'b1 ;
//	end
//	assign cpu_clk = counter[24] ;
	
	wire [11:0] address ;
	wire [15:0] qtop ;
	assign LEDG = qtop ;
	
	cpu_pll pll_tinycpu(CLOCK_50, cpu_clk);
	// module tinycpu(clk, reset, run, in, cs, pcout, irout, qtop, abus, dbus, out);
	tinycpu cpu1(.clk(cpu_clk), .reset(reset), 
	.run(1'b1), 
	.in(SW[15:0]),
	.qtop(qtop),
	.abus(address),
	.out(LEDR[15:0]));
	
	HexDigit d0(HEX0, address[3:0]);
	HexDigit d1(HEX1, address[8:4]);
endmodule

//////////////////////////////////////////////
// Decode one hex digit for LED 7-seg display
module HexDigit(segs, num);
	input [3:0] num	;		//the hex digit to be displayed
	output [6:0] segs ;		//actual LED segments
	reg [6:0] segs ;
	always @ (num)
	begin
		case (num)
				4'h0: segs = 7'b1000000;
				4'h1: segs = 7'b1111001;
				4'h2: segs = 7'b0100100;
				4'h3: segs = 7'b0110000;
				4'h4: segs = 7'b0011001;
				4'h5: segs = 7'b0010010;
				4'h6: segs = 7'b0000010;
				4'h7: segs = 7'b1111000;
				4'h8: segs = 7'b0000000;
				4'h9: segs = 7'b0010000;
				4'ha: segs = 7'b0001000;
				4'hb: segs = 7'b0000011;
				4'hc: segs = 7'b1000110;
				4'hd: segs = 7'b0100001;
				4'he: segs = 7'b0000110;
				4'hf: segs = 7'b0001110;
				default segs = 7'b1111111;
		endcase
	end
endmodule

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// The following CPU design is from
// http://www.cs.hiroshima-u.ac.jp/~nakano/wiki/
// and is GPL licensed
////////////////////////////////////////////////////////////

`define IDLE 3'b000
`define FETCHA 3'b001 
`define FETCHB 3'b010 
`define EXECA  3'b011 
`define EXECB  3'b100 

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

`define HALT  4'b0000  
`define PUSHI 4'b0001  
`define PUSH  4'b0010  
`define POP   4'b0011  
`define JMP   4'b0100  
`define JZ    4'b0101  
`define JNZ   4'b0110  
`define IN    4'b1101  
`define OUT   4'b1110  
`define OP    4'b1111  
//////////////////////////////////////////////////////////////

module alu(a, b, f, s);

 input [15:0] a, b;
 input [4:0] 	f;
 output [15:0] s;
 reg  [15:0] 	 s;
 wire [15:0] x, y;

 assign x = a + 16'h8000;
 assign y = b + 16'h8000;
  
 always @(a or b or x or y or f)
   case(f)
     `ADD : s = b + a;
     `SUB : s = b - a;
     `MUL : s = b * a;
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
     default : s = 16'hxxxx;
   endcase

endmodule
//////////////////////////////////////////////////////////////////
 module counter(clk,reset,load,inc,d,q);
  parameter N = 16;
   
  input clk,reset,load,inc;
  input [N-1:0] d;
  output [N-1:0] q;
  reg [N-1:0] 	 q;

  always @(posedge clk or negedge reset)
    if(!reset) q <= 0;
    else if(load) q <= d;
    else if(inc) q <= q + 16'd1;

endmodule
///////////////////////////////////////////////////////////////////////
 module state(clk,reset,run,cont,halt,cs);
  
  input clk, reset, run, cont, halt;
  output [2:0] cs;
  reg [2:0]cs;

  always @(posedge clk or negedge reset)
    if(!reset) cs <= `IDLE;
    else
      case(cs)
        `IDLE: if(run) cs <= `FETCHA;
        `FETCHA: cs <= `FETCHB;
        `FETCHB: cs <= `EXECA;
        `EXECA: if(halt) cs <= `IDLE;
                else if(cont) cs <= `EXECB;
                else cs <= `FETCHA;
        `EXECB: cs <= `FETCHA;
        default: cs <= 3'bxxx;
      endcase

endmodule
/////////////////////////////////////////////////////////////////////
module stack(clk, reset, load, push, pop, d, qtop, qnext);
  parameter N = 8;
	 
  input clk, reset, load, push, pop;
  input [15:0] d;
  output [15:0] qtop, qnext;
  reg [15:0] q [0:N-1];

  assign qtop = q[0];
  assign qnext = q[1];
   
  always @(posedge clk or negedge reset)
    if(!reset) q[0] <= 0;
    else if(load) q[0] <= d;
    else if(pop) q[0] <= q[1];

  integer i;
  always @(posedge clk or negedge reset)
    for(i=1;i< N-1;i=i+1)
      if(!reset) q[i] <= 0;
      else if(push) q[i] <= q[i-1];
      else if(pop) q[i] <= q[i+1];
   
  always @(posedge clk or negedge reset)
    if(!reset) q[N-1] <= 0;
    else if(push) q[N-1] <= q[N-2];

endmodule
/////////////////////////////////////////////////////////////////////
module ram(clk, load, addr, d, q) ;
 parameter DWIDTH=16,AWIDTH=12,WORDS=4096;

 input clk,load;
 input [AWIDTH-1:0] addr;
 input [DWIDTH-1:0] d;
 output [DWIDTH-1:0] q;
 reg [DWIDTH-1:0] q;
 // IF YOUR PROGRAM IS IN a mif file use:
 // reg [DWIDTH-1:0] mem [WORDS-1:0] /* synthesis ram_init_file = "TestPgm0.mif" */ ;
 // see http://www.altera.com/literature/hb/qts/qts_qii51008.pdf EXAMPLE 9-78
 
 reg [DWIDTH-1:0] mem [WORDS-1:0] ;
 
 always @(posedge clk)
   begin
     if(load) mem[addr] <= d;
     q <= mem[addr];
   end

	// see http://www.altera.com/literature/hb/qts/qts_qii51007.pdf
	// example 6-25 for how to init memory
	// count on leds (BRL4 oct 2010)
initial begin
	// counter
	mem[12'h000]=16'h1000; // pushi 0
	mem[12'h001]=16'h1001; // loop0: pushi 1
	mem[12'h002]=16'hf000; // add one to the counter
	
	// code DUP function (copy stack top)
	mem[12'h003]=16'h3fff; // pop fff (memory address:fff) 
	mem[12'h004]=16'h2fff; // push fff (memory address:fff)		
	mem[12'h005]=16'h2fff; // push fff (memory address:fff)	
	
	// output one copy, leave one on stack for next loop
	mem[12'h006]=16'he000; // out	
	
	// slow it down with an inner loop counter
	mem[12'h007]=16'h1000; // pushi 0
	mem[12'h008]=16'h1001; // loop1: pushi 1
	mem[12'h009]=16'hf000; // add
	
	// code DUP function
	mem[12'h00a]=16'h3fff; // pop fff (memory address:ffe) 
	mem[12'h00b]=16'h2fff; // push fff (memory address:ffe)		
	mem[12'h00c]=16'h2fff; // push fff (memory address:ffe)
	
	// jump back to inner loop1 unless overflow
	mem[12'h00d]=16'h6008; // jnz loop1 -- go until equal --- and pop stack
	mem[12'h00e]=16'h3fff; // pop fff -- throw away the extra copy of inner loop counter if we fall thru jnz
	
	// halt if sw[0] is on
	mem[12'h00f]=16'hd000; // input switch
	mem[12'h010]=16'h1001; // pushi 1 -- detect botton bit set
	mem[12'h011]=16'hf00a; // eq means (next==top -> top)
	mem[12'h012]=16'h6014; // jnz halt --- and pop stack
	
	// back to beginning
	mem[12'h013]=16'h4001; // jmp loop0
	// or halt
	mem[12'h014]=16'h4014; // halt: jmp halt
end

endmodule

/////////////////////////////////////////////////////////////////////

module tinycpu(clk, reset, run, in, cs, pcout, irout, qtop, abus, dbus, out);

  input clk,reset,run;
  input [15:0] in;
  output [2:0] cs;
  output [15:0] irout, qtop, out;
  output reg [15:0] dbus ;
  output [11:0] pcout, abus;
  wire [15:0] qnext, ramout, aluout;
  reg [11:0] abus;
  reg halt, cont, pcinc, push, pop, abus2pc, dbus2ir, dbus2qtop, dbus2ram,
      dbus2obuf, pc2abus, ir2abus, ir2dbus, qtop2dbus, alu2dbus, ram2dbus,
      in2dbus;

  counter #(12) pc0(.clk(clk), .reset(reset), .load(abus2pc), .inc(pcinc),
                    .d(abus), .q(pcout));
  counter #(16) ir0(.clk(clk), .reset(reset), .load(dbus2ir), .inc(0),
                   .d(dbus), .q(irout));
  state state0(.clk(clk), .reset(reset), .run(run), .cont(cont),
               .halt(halt), .cs(cs));
  stack stack0(.clk(clk), .reset(reset), .load(dbus2qtop), .push(push),
               .pop(pop), .d(dbus), .qtop(qtop), .qnext(qnext));
  alu alu0(.a(qtop), .b(qnext), .f(irout[4:0]), .s(aluout));
  ram #(16,12,4096) ram0(.clk(clk), .load(dbus2ram), .addr(abus[11:0]),
                         .d(dbus), .q(ramout));
  counter #(16) obuf0(.clk(clk), .reset(reset), .load(dbus2obuf), .inc(0),
                      .d(dbus), .q(out));
  
  always @(pc2abus or ir2abus or pcout or irout)
    if(pc2abus) abus <= pcout;
    else if(ir2abus) abus <= irout[11:0];
    else abus <= 12'hxxx;

//  assign dbus = ir2dbus ? {{4{irout[11]}},irout[11:0]} : 16'hzzzz;
//  assign dbus = qtop2dbus ? qtop : 16'hzzzz;
//  assign dbus = alu2dbus ? aluout : 16'hzzzz;
//  assign dbus = ram2dbus ? ramout : 16'hzzzz;
//  assign dbus = in2dbus ? in : 16'hzzzz;
  always @(*)
  begin
		if (ir2dbus) dbus = {{4{irout[11]}},irout[11:0]};
		else if (qtop2dbus) dbus = qtop ;
		else if (alu2dbus) dbus = aluout ;
		else if (ram2dbus) dbus = ramout ;
		else if (in2dbus) dbus = in ;
		else dbus = 16'hxxxx ;
  end
  
  
  always @(cs or irout or qtop)
    begin
      halt = 0; pcinc = 0; push = 0; pop = 0; cont = 0; abus2pc = 0;
      dbus2ir = 0; dbus2qtop = 0; dbus2ram = 0; dbus2obuf = 0; pc2abus = 0;
      ir2abus = 0; ir2dbus = 0; qtop2dbus = 0; alu2dbus = 0; ram2dbus = 0;
      in2dbus = 0;
      if(cs == `FETCHA) 
        begin
          pcinc = 1; pc2abus = 1;
        end
      else if(cs == `FETCHB)
        begin
          ram2dbus = 1; dbus2ir = 1;
        end
      else if(cs == `EXECA)
        case(irout[15:12])
        `PUSHI:
           begin
             ir2dbus = 1; dbus2qtop = 1; push = 1;
           end	 
        `PUSH:
           begin
             ir2abus = 1; cont = 1;
           end
        `POP:
           begin
             ir2abus = 1; qtop2dbus = 1; dbus2ram = 1; pop = 1;
           end
        `JMP:
           begin
             ir2abus = 1; abus2pc = 1;
           end
        `JZ:
           begin
             if(qtop == 16'b0) 
               begin
                 ir2abus = 1; abus2pc = 1;
               end
             pop = 1;
           end
        `JNZ:
           begin
             if ((qtop != 16'b0)) 
               begin
                 ir2abus = 1; abus2pc = 1;
               end
             pop = 1;
           end
        `IN:
           begin
             in2dbus = 1; dbus2qtop = 1; push = 1;
           end
        `OUT:
           begin
             qtop2dbus = 1; dbus2obuf = 1; pop = 1;
           end
        `OP:
           begin
             alu2dbus = 1; dbus2qtop = 1;
             if(irout[4] == 0) pop = 1;
           end
        default:
           halt = 1;
        endcase
      else if(cs == `EXECB)
        if(irout[15:12]==`PUSH)
          begin
          ram2dbus = 1; dbus2qtop = 1; push = 1;
        end
    end

endmodule
//////////////////////////////////////////
//module annotate;
//defparam
//	DE2_TOP.cpu1.altsyncram_component.init_file.init_file = "TestPgm0.mif";
//	//DE2_TOP.cpu2.altsyncram_component.init_file = "TestPgm0.mif"
//endmodule
