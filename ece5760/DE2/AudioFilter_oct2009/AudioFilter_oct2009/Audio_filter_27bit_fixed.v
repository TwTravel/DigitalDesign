// --------------------------------------------------------------------
// --------------------------------------------------------------------
//
// Major Functions: Audio Filter modules in 27-bit fixed point
//		2nd order IIR module
//		4th order IIR module
//		6th order IIR module
// Matlab pgm at end of code to convert Matlab filter to Verilog
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
// Bruce R Land, Cornell University, Nov 2007
// Improved top module written by Adam Shapiro
// Bruce Land Oct 2009 
// -- syntax cleanup and module name improvement
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
   assign LEDR = 18'h0;
   assign LEDG = 9'h0;
   
   //Set all GPIO to tri-state.
   assign GPIO_0 = 36'hzzzzzzzzz;
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

   //Disable SRAM.
   assign SRAM_ADDR = 18'h0;
   assign SRAM_CE_N = 1'b1;
   assign SRAM_DQ   = 16'hzzzz;
   assign SRAM_LB_N = 1'b1;
   assign SRAM_OE_N = 1'b1;
   assign SRAM_UB_N = 1'b1;
   assign SRAM_WE_N = 1'b1;

   //Disable VGA.
   //assign VGA_CLK   = 1'b0;
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
   assign UART_TXD = 1'b0;
   

wire	VGA_CTRL_CLK;
wire	AUD_CTRL_CLK;
wire	DLY_RST;

assign	TD_RESET	=	1'b1;	//	Allow 27 MHz
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);

I2C_AV_Config 		u3	(	//	Host Side
							.iCLK(CLOCK_50),
							.iRST_N(KEY[0]),
							//	I2C Side
							.I2C_SCLK(I2C_SCLK),
							.I2C_SDAT(I2C_SDAT)	);

AUDIO_DAC_ADC 			u4	(	//	Audio Side
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
							.iRST_N(DLY_RST)
							);

/// reset ///////////////////////////////////////////////////////						
//state machine start up	
wire reset; 
// reset control
assign reset = ~KEY[0];

/// audio stuff /////////////////////////////////////////////////
// output to audio DAC
wire signed [15:0] audio_outL, audio_outR ;
// input from audio ADC
wire signed [15:0] audio_inL, audio_inR ;
// filter outputs
wire signed [15:0] filter1_out, filter2_out, filter3_out ;

// make some output
// original signal in R channel
// filtered signal in L channel
assign audio_outR = audio_inR ; 
assign audio_outL = filter2_out ;

/// Define filters //////////////////////////////////////////////
//Filter: cutoff=0.100000 
//Filter: cutoff=0.200000 
IIR6_27bit_fixed  filter1( 
     .audio_out (filter1_out), 
     .audio_in (audio_inR), 
     .scale (3'd3), 
     .b1 (27'h17BD), 
     .b2 (27'h0), 
     .b3 (27'h7FFB8C7), 
     .b4 (27'h0), 
     .b5 (27'h4739), 
     .b6 (27'h0), 
     .b7 (27'h7FFE843), 
     .a2 (27'h9B2326), 
     .a3 (27'h6B801FD), 
     .a4 (27'h1818D8D), 
     .a5 (27'h6F660CC), 
     .a6 (27'h65C66F), 
     .a7 (27'h7EEF93E), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 

//Filter: cutoff=0.100000 
//Filter: cutoff=0.130000 
IIR6_27bit_fixed  filter2( 
     .audio_out (filter2_out), 
     .audio_in (audio_inR), 
     .scale (3'd3), 
     .b1 (27'hC8), 
     .b2 (27'h0), 
     .b3 (27'h7FFFDA8), 
     .b4 (27'h0), 
     .b5 (27'h258), 
     .b6 (27'h0), 
     .b7 (27'h7FFFF38), 
     .a2 (27'hAE287F), 
     .a3 (27'h669ED31), 
     .a4 (27'h2061A88), 
     .a5 (27'h682ABF0), 
     .a6 (27'h9994BB), 
     .a7 (27'h7E57FD4), 
     .state_clk(AUD_CTRL_CLK), 
     .lr_clk(AUD_DACLRCK), 
     .reset(reset) 
) ; //end filter 

endmodule

///////////////////////////////////////////////////////////////////
/// Second order IIR filter ///////////////////////////////////////
///////////////////////////////////////////////////////////////////
module IIR2_27bit_fixed (audio_out, audio_in, 
			scale, 
			b1, b2, b3, 
			a2, a3, 
			state_clk, lr_clk, reset) ;
// The filter is a "Direct Form II Transposed"
// 
//    a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
//                          - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
// 
//    If a(1) is not equal to 1, FILTER normalizes the filter
//    coefficients by a(1). 
//
// one audio sample, 16 bit, 2's complement
output reg signed [15:0] audio_out ;
// one audio sample, 16 bit, 2's complement
input wire signed [15:0] audio_in ;
// shift factor for output
input wire [2:0] scale ;
// filter coefficients
input wire signed [26:0] b1, b2, b3, a2, a3 ;
input wire state_clk, lr_clk, reset ;

/// filter vars //////////////////////////////////////////////////
wire signed [26:0] f1_mac_new, f1_coeff_x_value ;
reg signed [26:0] f1_coeff, f1_mac_old, f1_value ;

// input to filter
reg signed [26:0] x_n ;
// input history x(n-1), x(n-2)
reg signed [26:0] x_n1, x_n2 ; 

// output history: y_n is the new filter output, BUT it is
// immediately stored in f1_y_n1 for the next loop through 
// the filter state machine
reg signed [26:0] f1_y_n1, f1_y_n2 ; 

// MAC operation
signed_mult f1_c_x_v (f1_coeff_x_value, f1_coeff, f1_value);
assign f1_mac_new = f1_mac_old + f1_coeff_x_value ;

// state variable 
reg [3:0] state ;
//oneshot gen to sync to audio clock
reg last_clk ; 
///////////////////////////////////////////////////////////////////

//Run the filter state machine FAST so that it completes in one 
//audio cycle
always @ (posedge state_clk) 
begin
	if (reset)
	begin
		state <= 4'd15 ; //turn off the state machine	
	end
	
	else begin
		case (state)
	
			1: 
			begin
				// set up b1*x(n)
				f1_mac_old <= 27'd0 ;
				f1_coeff <= b1 ;
				f1_value <= {audio_in, 11'b0} ;				
				//register input
				x_n <= {audio_in, 11'b0} ;				
				// next state
				state <= 4'd2;
			end
	
			2: 
			begin
				// set up b2*x(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b2 ;
				f1_value <= x_n1 ;				
				// next state
				state <= 4'd3;
			end
			
			3:
			begin
				// set up b3*x(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b3 ;
				f1_value <= x_n2 ;
				// next state
				state <= 4'd6;
			end
						
			6: 
			begin
				// set up -a2*y(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a2 ;
				f1_value <= f1_y_n1 ; 
				//next state 
				state <= 4'd7;
			end
			
			7: 
			begin
				// set up -a3*y(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a3 ;
				f1_value <= f1_y_n2 ; 				
				//next state 
				state <= 4'd10;
			end
			
			10: 
			begin
				// get the output 
				// and put it in the LAST output var
				// for the next pass thru the state machine
				//mult by four because of coeff scaling
				// to prevent overflow
				f1_y_n1 <= f1_mac_new<<scale ; 
				audio_out <= f1_y_n1[26:11] ;				
				// update output history
				f1_y_n2 <= f1_y_n1 ;				
				// update input history
				x_n1 <= x_n ;
				x_n2 <= x_n1 ;
				//next state 
				state <= 4'd15;
			end
			
			15:
			begin
				// wait for the audio clock and one-shot it
				if (lr_clk && last_clk==1)
				begin
					state <= 4'd1 ;
					last_clk <= 1'h0 ;
				end
				// reset the one-shot memory
				else if (~lr_clk && last_clk==0)
				begin
					last_clk <= 1'h1 ;				
				end	
			end
			
			default:
			begin
				// default state is end state
				state <= 4'd15 ;
			end
		endcase
	end
end	

endmodule


///////////////////////////////////////////////////////////////////
/// Fourth order IIR filter ///////////////////////////////////////
///////////////////////////////////////////////////////////////////
module IIR4_27bit_fixed (audio_out, audio_in, 
			scale, 
			b1, b2, b3, b4, b5, 
			a2, a3, a4, a5, 
			state_clk, lr_clk, reset) ;
// The filter is a "Direct Form II Transposed"
// 
//    a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
//                          - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
// 
//    If a(1) is not equal to 1, FILTER normalizes the filter
//    coefficients by a(1). 
//
// one audio sample, 16 bit, 2's complement
output reg signed [15:0] audio_out ;
// one audio sample, 16 bit, 2's complement
input wire signed [15:0] audio_in ;
// shift factor for output
input wire [2:0] scale ;
// filter coefficients
input wire signed [26:0] b1, b2, b3, b4, b5, a2, a3, a4, a5 ;
input wire state_clk, lr_clk, reset ;

/// filter vars //////////////////////////////////////////////////
wire signed [26:0] f1_mac_new, f1_coeff_x_value ;
reg signed [26:0] f1_coeff, f1_mac_old, f1_value ;

// input to filter
reg signed [26:0] x_n ;
// input history x(n-1), x(n-2)
reg signed [26:0] x_n1, x_n2, x_n3, x_n4 ; 

// output history: y_n is the new filter output, BUT it is
// immediately stored in f1_y_n1 for the next loop through 
// the filter state machine
reg signed [26:0] f1_y_n1, f1_y_n2, f1_y_n3, f1_y_n4 ; 

// MAC operation
signed_mult f1_c_x_v (f1_coeff_x_value, f1_coeff, f1_value);
assign f1_mac_new = f1_mac_old + f1_coeff_x_value ;

// state variable 
reg [3:0] state ;
//oneshot gen to sync to audio clock
reg last_clk ; 
///////////////////////////////////////////////////////////////////

//Run the filter state machine FAST so that it completes in one 
//audio cycle
always @ (posedge state_clk) 
begin
	if (reset)
	begin
		state <= 4'd15 ; //turn off the state machine	
	end
	
	else begin
		case (state)
	
			1: 
			begin
				// set up b1*x(n)
				f1_mac_old <= 27'd0 ;
				f1_coeff <= b1 ;
				f1_value <= {audio_in, 11'b0} ;				
				//register input
				x_n <= {audio_in, 11'b0} ;				
				// next state
				state <= 4'd2;
			end
	
			2: 
			begin
				// set up b2*x(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b2 ;
				f1_value <= x_n1 ;				
				// next state
				state <= 4'd3;
			end
			
			3:
			begin
				// set up b3*x(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b3 ;
				f1_value <= x_n2 ;
				// next state
				state <= 4'd4;
			end
			
			4:
			begin
				// set up b4*x(n-3) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b4 ;
				f1_value <= x_n3 ;
				// next state
				state <= 4'd5;
			end
			
			5:
			begin
				// set up b5*x(n-4) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b5 ;
				f1_value <= x_n4 ;
				// next state
				state <= 4'd6;
			end
						
			6: 
			begin
				// set up -a2*y(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a2 ;
				f1_value <= f1_y_n1 ; 
				//next state 
				state <= 4'd7;
			end
			
			7: 
			begin
				// set up -a3*y(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a3 ;
				f1_value <= f1_y_n2 ; 				
				//next state 
				state <= 4'd8;
			end
			
			8: 
			begin
				// set up -a4*y(n-3) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a4 ;
				f1_value <= f1_y_n3 ; 				
				//next state 
				state <= 4'd9;
			end
			
			9: 
			begin
				// set up -a5*y(n-4) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a5 ;
				f1_value <= f1_y_n4 ; 				
				//next state 
				state <= 4'd10;
			end
			
			10: 
			begin
				// get the output 
				// and put it in the LAST output var
				// for the next pass thru the state machine
				//mult by four because of coeff scaling
				// to prevent overflow
				f1_y_n1 <= f1_mac_new<<scale ; 
				audio_out <= f1_y_n1[26:11] ;				
				// update output history
				f1_y_n2 <= f1_y_n1 ;
				f1_y_n3 <= f1_y_n2 ;
				f1_y_n4 <= f1_y_n3 ;				
				// update input history
				x_n1 <= x_n ;
				x_n2 <= x_n1 ;
				x_n3 <= x_n2 ;
				x_n4 <= x_n3 ;
				//next state 
				state <= 4'd15;
			end
			
			15:
			begin
				// wait for the audio clock and one-shot it
				if (lr_clk && last_clk==1)
				begin
					state <= 4'd1 ;
					last_clk <= 1'h0 ;
				end
				// reset the one-shot memory
				else if (~lr_clk && last_clk==0)
				begin
					last_clk <= 1'h1 ;				
				end	
			end
			
			default:
			begin
				// default state is end state
				state <= 4'd15 ;
			end
		endcase
	end
end	

endmodule

///////////////////////////////////////////////////////////////////
/// Sixth order IIR filter ///////////////////////////////////////
///////////////////////////////////////////////////////////////////
module IIR6_27bit_fixed (audio_out, audio_in, 
			scale, 
			b1, b2, b3, b4, b5, b6, b7,
			a2, a3, a4, a5, a6, a7,
			state_clk, lr_clk, reset) ;
// The filter is a "Direct Form II Transposed"
// 
//    a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
//                          - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
// 
//    If a(1) is not equal to 1, FILTER normalizes the filter
//    coefficients by a(1). 
//
// one audio sample, 16 bit, 2's complement
output reg signed [15:0] audio_out ;
// one audio sample, 16 bit, 2's complement
input wire signed [15:0] audio_in ;
// shift factor for output
input wire [2:0] scale ;
// filter coefficients
input wire signed [26:0] b1, b2, b3, b4, b5, b6, b7, a2, a3, a4, a5, a6, a7 ;
input wire state_clk, lr_clk, reset ;

/// filter vars //////////////////////////////////////////////////
wire signed [26:0] f1_mac_new, f1_coeff_x_value ;
reg signed [26:0] f1_coeff, f1_mac_old, f1_value ;

// input to filter
reg signed [26:0] x_n ;
// input history x(n-1), x(n-2)
reg signed [26:0] x_n1, x_n2, x_n3, x_n4, x_n5, x_n6 ; 

// output history: y_n is the new filter output, BUT it is
// immediately stored in f1_y_n1 for the next loop through 
// the filter state machine
reg signed [26:0] f1_y_n1, f1_y_n2, f1_y_n3, f1_y_n4, f1_y_n5, f1_y_n6 ; 

// MAC operation
signed_mult f1_c_x_v (f1_coeff_x_value, f1_coeff, f1_value);
assign f1_mac_new = f1_mac_old + f1_coeff_x_value ;

// state variable 
reg [3:0] state ;
//oneshot gen to sync to audio clock
reg last_clk ; 
///////////////////////////////////////////////////////////////////

//Run the filter state machine FAST so that it completes in one 
//audio cycle
always @ (posedge state_clk) 
begin
	if (reset)
	begin
		state <= 4'd15 ; //turn off the state machine	
	end
	
	else begin
		case (state)
	
			1: 
			begin
				// set up b1*x(n)
				f1_mac_old <= 27'd0 ;
				f1_coeff <= b1 ;
				f1_value <= {audio_in, 11'b0} ;				
				//register input
				x_n <= {audio_in, 11'b0} ;				
				// next state
				state <= 4'd2;
			end
	
			2: 
			begin
				// set up b2*x(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b2 ;
				f1_value <= x_n1 ;				
				// next state
				state <= 4'd3;
			end
			
			3:
			begin
				// set up b3*x(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b3 ;
				f1_value <= x_n2 ;
				// next state
				state <= 4'd4;
			end
			
			4:
			begin
				// set up b4*x(n-3) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b4 ;
				f1_value <= x_n3 ;
				// next state
				state <= 4'd5;
			end
			
			5:
			begin
				// set up b5*x(n-4) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b5 ;
				f1_value <= x_n4 ;
				// next state
				state <= 4'd6;
			end
						
			6: 
			begin
				// set up b6*x(n-5) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b6 ;
				f1_value <= x_n5 ;
				// next state
				state <= 4'd7;
			
			end
			
			7: 
			begin
				// set up b7*x(n-6) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b7 ;
				f1_value <= x_n6 ;
				// next state
				state <= 4'd8;
			
			end
			
			8:
			begin
				// set up -a2*y(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a2 ;
				f1_value <= f1_y_n1 ; 
				//next state 
				state <= 4'd9;
			end
			
			9: 
			begin
				// set up -a3*y(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a3 ;
				f1_value <= f1_y_n2 ; 				
				//next state 
				state <= 4'd10;
			end
			
			4'd10: 
			begin
				// set up -a4*y(n-3) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a4 ;
				f1_value <= f1_y_n3 ; 				
				//next state 
				state <= 4'd11;
			end
			
			4'd11: 
			begin
				// set up -a5*y(n-4) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a5 ;
				f1_value <= f1_y_n4 ; 				
				//next state 
				state <= 4'd12;
			end
			
			4'd12: 
			begin
				// set up -a6*y(n-5) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a6 ;
				f1_value <= f1_y_n5 ; 				
				//next state 
				state <= 4'd13;
			end
			
			13: 
			begin
				// set up -a7*y(n-6) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a7 ;
				f1_value <= f1_y_n6 ; 				
				//next state 
				state <= 4'd14;
			end
			
			14: 
			begin
				// get the output 
				// and put it in the LAST output var
				// for the next pass thru the state machine
				//mult by four because of coeff scaling
				// to prevent overflow
				f1_y_n1 <= f1_mac_new<<scale ; 
				audio_out <= f1_y_n1[26:11] ;				
				// update output history
				f1_y_n2 <= f1_y_n1 ;
				f1_y_n3 <= f1_y_n2 ;
				f1_y_n4 <= f1_y_n3 ;
				f1_y_n5 <= f1_y_n4 ;
				f1_y_n6 <= f1_y_n5 ;				
				// update input history
				x_n1 <= x_n ;
				x_n2 <= x_n1 ;
				x_n3 <= x_n2 ;
				x_n4 <= x_n3 ;
				x_n5 <= x_n4 ;
				x_n6 <= x_n5 ;
				//next state 
				state <= 4'd15;
			end
			
			15:
			begin
				// wait for the audio clock and one-shot it
				if (lr_clk && last_clk==1)
				begin
					state <= 4'd1 ;
					last_clk <= 1'h0 ;
				end
				// reset the one-shot memory
				else if (~lr_clk && last_clk==0)
				begin
					last_clk <= 1'h1 ;				
				end	
			end
			
			default:
			begin
				// default state is end state
				state <= 4'd15 ;
			end
		endcase
	end
end	

endmodule

//////////////////////////////////////////////////
//// signed mult of 3.24 format 2'comp////////////
//////////////////////////////////////////////////
module signed_mult (out, a, b);
	output 		[26:0]	out;
	input 	signed	[26:0] 	a;
	input 	signed	[26:0] 	b;
	wire	signed	[26:0]	out;
	wire 	signed	[53:0]	mult_out;
	assign mult_out = a * b;
	assign out = {mult_out[53], mult_out[49:24]};
endmodule
//////////////////////////////////////////////////


/////////////////////////////////////////////////////
//// Time weighted average amplitude (2'comp) ///////
/////////////////////////////////////////////////////
// dk_const    e-folding time of average			         
// 3			~8 samples
// 4			15 
// 5			32
// 6			64
// 7			128 -- 2.7 mSec at 48kHz
// 8			256 -- 5.3 mSec (useful for music/voice)
// 9			512 -- 10.5 mSec (useful for music/voice)
// 10			1024 -- 21 mSec (useful for music/voice)
// 11			2048 -- 42 mSec
module average (out, in, dk_const, clk);

	output reg signed [15:0] out ;
	input wire signed [15:0] in ;
	input wire [3:0] dk_const ;
	input wire clk;
	
	wire signed  [17:0] new_out ;
	//first order lowpass of absolute value of input
	assign new_out = out - (out>>>dk_const) + ((in[15]?-in:in)>>>dk_const) ;
	always @(posedge clk)
	begin
		 out <= new_out ;
	end
endmodule
//////////////////////////////////////////////////

/* matlab program to generate the filter header 

%27-bit, 24-bit fraction,  2's comp conversion
clear all
figure(1);clf;
clc

%The scale has to be adjusted so that filter coefficients are
% -2.0<coeff<2.0
%Scaling performed is 2^(-scale)
scale = 3;
%For lowpass, set equal to normalized Freq (cutoff/(Fs/2))
%For bandpass, set equal to normalized Freq vector ([low high]/(Fs/2))
freq = [0.1 0.13] ;
%Filter order:
%    use 2,4 for lowpass 
%        1,2 for bandpass
%NOTE that for a bandpass filter (order) poles are generated for the high
%and low cutoffs, so the total order is (order)*2
order = 3;

%could also use butter, or cheby1 or cheby2 or besself
% but note that besself is lowpass only!
[b, a] = butter(order, freq) ;
%[b, a] = cheby1(order, 0.1, freq) ;
%[b, a] = besself(order, freq) ;

bs = b * (2^-scale) ;
as = -a * (2^-scale) ;

disp(' ')
fprintf('//Filter: cutoff=%f \n',freq)
sorder = order*length(freq);
if sorder==2
    scstr = 'IIR2 filter(';
elseif sorder==4
    scstr = 'IIR4 filter('; 
elseif sorder==6
    scstr = 'IIR6 filter('; 
else
    error('order*length(freq) must equal 2 4 or 6')
end
fprintf('%s \n',scstr); 
fprintf('     .audio_out (your_out), \n')
fprintf('     .audio_in (your_in), \n')
fprintf('     .scale (3''d%1d), \n', scale)
for i=1:length(bs)
    if bs(i)>=0
        fprintf('     .b%1d (27''h%s), \n', i, dec2hex(fix(2^24*bs(i)))) ;
    else
        fprintf('     .b%1d (27''h%s), \n', i, dec2hex(bitcmp(fix(2^24*-bs(i)),27)+1));
    end
end

for i=2:length(as)
    if as(i)>=0
        fprintf('     .a%1d (27''h%s), \n', i, dec2hex(fix(2^24*as(i))))
    else
        fprintf('     .a%1d (27''h%s), \n', i,dec2hex(bitcmp(fix(2^24*-as(i)),27)+1))
    end
end
fprintf('     .state_clk(AUD_CTRL_CLK), \n');
fprintf('     .lr_clk(AUD_DACLRCK), \n');
fprintf('     .reset(reset) \n');
fprintf(') ; //end filter \n');

disp(' ')
disp('CHECK scaling! all b''s and a''s <2 absolute value?') 
disp('BUT as big as possible?')
bs
as

%sampling rate on DE2 board
Fs = 47000;

[fresponse, ffreq] = freqz(b,a,500);
plot(ffreq/pi*Fs/2,abs(fresponse), 'b', 'linewidth',2);
xlabel('frequency'); ylabel('filter amplitude');
hold on
bs = fix((b*(2^-scale))*2^24) ;
as = fix((a*(2^-scale))*2^24) ;
[fresponse, ffreq] = freqz(bs,as,500);
plot(ffreq/pi*Fs/2,abs(fresponse), 'r', 'linewidth',2);
legend('exact','scaled 24-bit')

%================================================================
%matlab pgm to test filter
%
Fs=44100;
endt =20;
t=0:1/Fs:endt ;
f0 = 1500 ;
t1 = endt ;
f1 =4000 ;
y = chirp(t,f0,t1,f1);
sound(0.4*y ,Fs)

*/
