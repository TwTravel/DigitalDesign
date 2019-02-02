// --------------------------------------------------------------------
//
// CPU-based DSP functions
//
// Matlab pgm at end of code to convert Matlab filter to assembler
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
// Bruce R Land, Cornell University, Sept 2008
// --------------------------------------------------------------------


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
output			AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			AUD_ADCDAT;				//	Audio CODEC ADC Data
output			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT;				//	Audio CODEC DAC Data
output			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK;				//	Audio CODEC Chip Clock
////////////////////	TV Devoder		////////////////////////////
input	[7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
input			TD_HS;					//	TV Decoder H_SYNC
input			TD_VS;					//	TV Decoder V_SYNC
output			TD_RESET;				//	TV Decoder Reset
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1

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
							//.iSrc_Select(SW[17]),
				            .iCLK_18_4(AUD_CTRL_CLK),
							.iRST_N(DLY_RST)
							);

/// reset ///////////////////////////////////////////////////////						
//state machine start up	
reg reset, lastReset; 
// reset control
//assign reset = ~KEY[0];

/// audio stuff /////////////////////////////////////////////////
// output to audio DAC
wire signed [15:0] audio_outL, audio_outR ;
// input from audio ADC
wire signed [15:0] audio_inL, audio_inR ;
// filter outputs
wire signed [15:0] filter1_out ;

// make some output
// original signal in R channel
// filtered signal in L channel
assign audio_outR = audio_inR ; 
assign audio_outL = out0[17:2] ;

wire signed [17:0] out0 ;
scomp f1 (CLOCK_50, reset, out0, {audio_inR,2'b00} );

always @ (posedge AUD_CTRL_CLK)  
begin
	if (AUD_DACLRCK && reset==1)
	begin
		reset <= 1'h0 ;
	end
	// reset the one-shot memory
	else if (~AUD_DACLRCK && reset==0)
	begin
		reset <= 1'h1 ;				
	end	
end
// wait for the audio clock and one-shot it
					
endmodule

///////////////////////////////////////////////////
/// signed mult of 2.16 format 2'comp 
///////////////////////////////////////////////////
module signed_mult (out, a, b);

	output 		[17:0]	out;
	input 	signed	[17:0] 	a;
	input 	signed	[17:0] 	b;
	
	wire	signed	[17:0]	out;
	wire 	signed	[35:0]	mult_out;

	assign mult_out = a * b;
	//assign out = mult_out[33:17];
	assign out = {mult_out[35], mult_out[32:16]};
endmodule
//////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////
/// uP3 design from Hamblen "Rapid prototyping of digital systems"
//
// Modified for 18-bit data and instructions
// instruction: 6-bit opcode  
//              12-bit address (or i/o address, or immediate)
// fractional multiply instruction 2:16
// i/o to audio
// --------------------------------------------------------------------
// Bruce Land Sept 2008, Cornell University
// --------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////
// ISA:			opcode
// ADD addr		00		
// ST addr		01	
// LD addr		02	
// JMP addr		03	
// JNEG addr	04	
// OUT addr		05
// IN addr		06
// MULT	add		07
// SHL shift    08
// single 18-bit accumulator
// addr is 10-bits
//////////////////////////////////////////////////////////////////////////	
module scomp (clock, reset, out0, in0);
   input clock,reset;
   input  [17:0]  in0;
   output [17:0]  out0;
   reg  [17:0] register_A,  instruction_register, out0;
   reg  [11:0] program_counter;
   reg  [3:0] state;
   
// State Encodings
parameter	reset_pc 		= 4'h0,
			fetch			= 4'h1,
			decode			= 4'h2,
			execute_add 	= 4'h3,
			execute_store 	= 4'h4,
			execute_store2 	= 4'h5,
			execute_store3 	= 4'h6,
			execute_load	= 4'h7,
			execute_jump	= 4'h8,
			execute_jump_n  = 4'h9,
			execute_out     = 4'ha,
			execute_in		= 4'hb,
			execute_mult	= 4'hc,
			execute_shl		= 4'hd   ;

	reg [11:0] memory_address_register;
	reg memory_write;
	
	wire [17:0] memory_data_register;
	wire [17:0] memory_data_register_out = memory_data_register;
	wire [17:0] memory_address_register_out = memory_address_register;
	wire memory_write_out = memory_write;

// Use Altsynram function for computer's memory (256 18-bit words)
altsyncram	altsyncram_component (
				.wren_a (memory_write_out),
				.clock0 (clock),
				.address_a (memory_address_register_out),
				.data_a (register_A),
				.q_a (memory_data_register));
	defparam
		altsyncram_component.operation_mode = "SINGLE_PORT",
		altsyncram_component.width_a = 18,
		altsyncram_component.widthad_a = 8,
		altsyncram_component.outdata_reg_a = "UNREGISTERED",
		altsyncram_component.lpm_type = "altsyncram",
// Reads in mif file for initial program and data values
		//altsyncram_component.init_file = "TestPgm.mif",
		altsyncram_component.intended_device_family = "Cyclone";
		
// fixed point multiplier
   wire signed [17:0] multResult ;
   signed_mult(multResult, register_A, memory_data_register) ; 
   
   always @(posedge clock or posedge reset)
     begin
        if (reset)
            state = reset_pc;
        else 
			case (state)
// reset the computer, need to clear some registers
       		reset_pc :
       		begin
					program_counter = 10'b0 ;
					register_A = 18'b0 ;
					state = fetch;
					out0 = 18'h0 ;
       		end
// Fetch instruction from memory and add 1 to program counter
       		fetch :
       		begin
					instruction_register = memory_data_register;
					program_counter = program_counter + 1;
					state = decode;
       		end
// Decode instruction and send out address of any required data operands
       		decode :
       		begin
					case (instruction_register[17:12])
						6'b000000:
						    state = execute_add;
						6'b000001:
						    state = execute_store;
						6'b000010:
						    state = execute_load;
						6'b000011:
						    state = execute_jump;
						6'b000100:
						    state = execute_jump_n;
						6'b000101:
						    state = execute_out;
						6'b000110:
						    state = execute_in;
						6'b000111:
						    state = execute_mult;
						6'b001000:
						    state = execute_shl;
						default:
						    state = fetch;
					endcase
       		end
// Execute the ADD instruction
       		execute_add :
       		begin
					register_A = register_A + memory_data_register;
					state = fetch;
       		end
// Execute the STORE instruction (needs three clock cycles for memory write)
       		execute_store :
       		begin
// write register_A to memory
 					state = execute_store2;
// This state ensures that the memory address is valid until after memory_write goes low
       		end
       		execute_store2 :
       		begin
				state = execute_store3;
       		end
// Execute the LOAD instruction
       		execute_load :
       		begin
				register_A = memory_data_register;
				state = fetch;
       		end
 // Execute the JUMP instruction
       		execute_jump :
       		begin
				program_counter = instruction_register[11:0];
				state = fetch;
       		end
 // Execute the JUMP A negative instruction      		
       		execute_jump_n :
       		begin
				program_counter = 
					(register_A[15]==1'h1)? instruction_register[11:0] : program_counter ;
				state = fetch;
       		end
 // Execute the OUT instruction  -- note! no addr decoding    		
       		execute_out :
       		begin
				out0 = register_A ;
				state = fetch ;
			end
// Execute the IN instruction  -- note! no addr decoding        		
       		execute_in :
       		begin
				register_A = in0 ;
				state = fetch ;
       		end  
 // Execute the MULT instruction      		
       		execute_mult :
       		begin
				register_A = multResult ;
				state = fetch ;
			end
 // Execute the SHL instruction      		
       		execute_shl :
       		begin
				register_A = register_A << memory_data_register[2:0] ;
				state = fetch ;
			end
 // default is fetch      		    		
       		default :
       		begin
            	state = fetch;
       		end
		endcase
     end
	
	 always @(state or program_counter or instruction_register)
	   begin
		case (state)
			reset_pc: 		memory_address_register = 12'h 00;
			fetch:			memory_address_register = program_counter;
			decode:			memory_address_register = instruction_register[11:0];
			execute_add: 	memory_address_register = program_counter;
			execute_store: 	memory_address_register = instruction_register[11:0];
			execute_store2: memory_address_register = program_counter;
			execute_load:	memory_address_register = program_counter;
			execute_jump:	memory_address_register = instruction_register[11:0];
			execute_jump_n:	memory_address_register = 
							(register_A[15]==1'h1)? instruction_register[11:0] : program_counter ;
			execute_out:	memory_address_register = program_counter;
			execute_in:		memory_address_register = program_counter;
			execute_mult:	memory_address_register = program_counter;
			execute_shl:	memory_address_register = program_counter;
			default: 		memory_address_register = program_counter;
		endcase
		case (state)
			execute_store: 	memory_write = 1'b 1;
			default:	 	memory_write = 1'b 0;
		endcase
	  end		
endmodule

module annotate;
defparam
	DE2_Default.f1.altsyncram_component.init_file = "Test18bitFilter.mif" ;
endmodule
///////////////////////////////////////////////////////////////////////////////////////

