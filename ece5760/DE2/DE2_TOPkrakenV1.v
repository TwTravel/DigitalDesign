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
// Shell code for the DE@ is written by:          
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan 302
// --------------------------------------------------------------------
//// Kraken CPU /////////////////////////////////////////////////////////
//I/O description
// SW16 will force reset when on
// 4 digit 7-seg display will show inst if SW17=0 or data memory output if SW17=1
// SW15:0 will be used for input: inst if SW17=0 or data bus if SW17=1
// 2 digit 7-seg display will show address: inst if SW17=0 or data bus if SW17=1
// KEY3 will be ~clk
// KEY2 will be write-enable: inst if SW17=0 or data bus if SW17=1
// KEY1 is inc/dec snoop address
// KEY0 is snoop address clk
// green LED 7 is Fetch/Execute with Fetch=on
// green LED 0 is data memory write_enable
////////////////////////////////////////////////////////////////////////

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

/////////// cpu wiring ////////////
reg [7:0] MemAddrSnoop ; 		//address for reset-mode data/inst readout
wire reset;						//Yup, this sets the PC to zero when high
reg CPUstate;					//hold value of fetch/execute ; 1/0
//
reg [7:0] PC ;					//program counter 
wire [7:0] PCsum ;				//new PC value
wire PCadd_sel, PCinput_sel;	//add 1/offset; input PCsum/Rs
//			
wire [15:0] IR ;				//Instruction register
//IR[15:12]=opcode; [11:8]=Rd address; [7:4]=Rs; [3:0]=Rt; [7:0]=immed
wire [3:0] opcode, IR_Rd_addr, IR_Rs_addr, IR_Rt_addr;
wire [7:0] immed; 

wire [15:0] Rs, Rt, ALUout;		//actual register/ALU values
reg [1:0] regWrite_sel;			//choose Rd source Mem, ALU, PC
reg [15:0] regWriteData;		// data to write to regs 
wire RSaddr_sel ;				//Choose Rs address source 
wire [3:0] RSaddr ; 			//and the actual Rs address
wire reg_we	;					//trigger the register write

wire [15:0] DataDisplay ; 		//variable to be put on 7-seg displays
wire [15:0] DataMem_out, DataMem_in; 	//data memory data interface
wire [7:0] DataMem_addr; 				//data memory address
wire DataMem_we, clk ;					//data memory controls
///////////////////////
//opcode hex values
parameter opADD=4'h0, opSUB=4'h1, opAND=4'h2, opOR=4'h3, opXOR=4'h4;
parameter opNOT=4'h5, opSLA=4'h6, opSRA=4'h7, opLI=4'h8;
parameter opLW=4'h9, opSW=4'ha, opBIZ=4'hb, opBNZ=4'hc, opJAL=4'hd, opJMP=4'he, opJR=4'hf;
//cpu state definitions
parameter FETCH=1'b1, EXECUTE=1'b0;
////// basic cpu control /////////////
assign clk = ~KEY[3];  //This cpu will be single stepped mostly
assign reset = SW[16];
/////////////////////////////////////

// Turn off LCD
assign	LCD_ON		=	1'b0;
assign	LCD_BLON	=	1'b0;
//	All inout port turn to tri-state
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ		=	8'hzz;
//assign	SRAM_DQ		=	16'hzzzz;
assign	OTG_DATA	=	16'hzzzz;
assign	LCD_DATA	=	8'hzz;
assign	SD_DAT		=	1'bz;
assign	I2C_SDAT	=	1'bz;
assign	ENET_DATA	=	16'hzzzz;
assign	AUD_ADCLRCK	=	1'bz;
assign	AUD_DACLRCK	=	1'bz;
assign	AUD_BCLK	=	1'bz;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;

////////////// Snoop memory address ////////////////////////////
//Used when cpu is reset to read/write inst/data memory
//to upcount and display KEY0 is updata clock; KEY1 is direction (up/down)
always @ (negedge KEY[0])
begin
	if (KEY[1]) MemAddrSnoop <= MemAddrSnoop + 8'h1;
	else MemAddrSnoop <= MemAddrSnoop - 8'h1;	
end
//display the hex value of address
HexDigit Digit4(HEX4, MemAddrSnoop[3:0]);
HexDigit Digit5(HEX5, MemAddrSnoop[7:4]);

//////////////////////// SRAM Interface	////////////////////////
//note that this mem is not clocked, so the IR gets the value
//at SRAM_ADDR asynch after the propagation delay of the memory
// just 8 bits of address
assign SRAM_ADDR = (reset?{10'h0, MemAddrSnoop}: {10'h0,PC} );	//	SRAM Address bus 18 Bits
assign SRAM_UB_N = 0;						// hi byte select enabled
assign SRAM_LB_N = 0;						// lo byte select enabled
assign SRAM_CE_N = 0;						// chip is enabled
assign SRAM_WE_N = ~(~KEY[2] & reset & ~SW[17]);	// write when KEY2 is pressed AND reset AND inst mode
assign SRAM_OE_N = 0;						//output enable is overidden by WE
// If no WE, then float bus, so that SRAM can drive it (READ)
// If WE, drive it with data from SWITCHES[15:0] to be stored in SRAM (WRITE)
assign SRAM_DQ = (SRAM_WE_N? 16'hzzzz : SW[15:0]);
assign IR = SRAM_DQ;		

///////////// 4 digit 7-seg display /////////////
// Show memory on the 7-seg display regWriteData
assign DataDisplay = (SW[17]?  DataMem_out: SRAM_DQ); //if sw17==1, show data, else show inst
//assign DataDisplay = (SW[17]?  DataMem_in: SRAM_DQ); //if sw17==1, show regdata, else show inst
HexDigit Digit0(HEX0, DataDisplay[3:0]);
HexDigit Digit1(HEX1, DataDisplay[7:4]);
HexDigit Digit2(HEX2, DataDisplay[11:8]);
HexDigit Digit3(HEX3, DataDisplay[15:12]);
assign LEDR = SW; //visual indication of toggle sw positions

/////////////////// data RAM ////////////////////
assign DataMem_we = (reset? (~KEY[2] & reset & SW[17]): (opcode==opSW & CPUstate==EXECUTE));
assign DataMem_addr = (reset? MemAddrSnoop: Rs[7:0]) ;
assign DataMem_in = (reset? SW[15:0]: Rt) ;
assign LEDG[0] = DataMem_we ;
//Use the definition from Altera HDL style manual to infer 
//Synchronous RAM with Read-Through-Write Behavior
ram_infer DataMem(DataMem_out, DataMem_addr, DataMem_in, DataMem_we, clk);

/////////////////// 16x16 registers ////////////////////
assign RSaddr_sel = (opcode==opBIZ | opcode==opBNZ);
assign RSaddr = (RSaddr_sel? IR_Rd_addr: IR_Rs_addr);
assign reg_we = (CPUstate==EXECUTE) & 
				~( (opcode==opSW) | (opcode==opBIZ) | (opcode==opBNZ) | 
				(opcode==opJMP) | (opcode==opJR) ); 
always @*
begin
	if  (opcode==opJAL) regWrite_sel = 2'h0;
	else if (opcode==opLW)regWrite_sel = 2'h2;
	else if (opcode==opLI)regWrite_sel = 2'h3;
	else regWrite_sel = 2'h1;
	
	case(regWrite_sel)
		2'b00: regWriteData = PC;
		2'b01: regWriteData = ALUout;
		2'b10: regWriteData = DataMem_out;
		2'b11: regWriteData = {8'b0, immed} ;
	endcase
end
//Use the definition from Altera HDL style manual to infer 
//Synchronous dual-read RAM with Read-Through-Write Behavior
// parameters(readData1, readData2, writeAddr, readAddr1, readAddr2, writeData, we, clock)
dual_ram_infer regbank(Rs, Rt, IR_Rd_addr, RSaddr, IR_Rt_addr, regWriteData, reg_we, clk);

//ALU
ALU ALU1(Rs, Rt, opcode, ALUout);

/////////// program counter and instruction register ///////
//Display the PC
HexDigit Digit6(HEX6, PC[3:0]);
HexDigit Digit7(HEX7, PC[7:4]);
//parse the IR
assign opcode = IR[15:12]; 
assign IR_Rd_addr = IR[11:8];  
assign IR_Rs_addr = IR[7:4]; 
assign IR_Rt_addr = IR[3:0];
assign immed = IR[7:0];
//Choose to add one or offset
assign PCadd_sel = (opcode==opBIZ & Rs==0) | 
					(opcode==opBNZ & ~(Rs==0)) | 
					(opcode==opJAL) | (opcode==opJMP) ;
assign PCsum = PC + (PCadd_sel? immed: 8'h1) ;
//Choose to use Rs or sum to update PC
assign PCinput_sel = ~(opcode==opJR);

//fetch/execute state machine
assign LEDG[7] = CPUstate ;
always @ (posedge clk)
begin
	if (reset)		//synch reset
	begin
		PC <= 0;
		CPUstate <= EXECUTE;
	end
	else if (CPUstate==EXECUTE) 
	begin
		PC <= (PCinput_sel? PCsum: Rs[7:0]);
		CPUstate <= FETCH;
	end
	else if (CPUstate==FETCH)
	begin
		CPUstate <= EXECUTE;
	end
end

endmodule //end top level DE2_TOP
////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////
//ALU
module ALU (Rs, Rt, opcode, ALUout);
input [15:0] Rs, Rt; 
input [3:0] opcode ;
output reg [15:0] ALUout;
always @*
begin
	case (opcode)
	4'h0: ALUout = Rs + Rt;
	4'h1: ALUout = Rs - Rt;
	4'h2: ALUout = Rs & Rt;
	4'h3: ALUout = Rs | Rt;
	4'h4: ALUout = Rs ^ Rt;
	4'h5: ALUout = ~Rs ;
	4'h6: ALUout = Rs<<1;
	4'h7: ALUout = Rs>>1;
	default ALUout = Rs;
	endcase
end
endmodule

////////////////////////////////////////////////
// 16x16 register array
// with dual-read + write
// taken from Altera HDL style manual page 6-20
// modified for synchronous RAM with Read-Through-Write Behavior
// and modified for 16 bit access
// of 16 words
module dual_ram_infer (q, q2, write_address, read_address, read_address2, d, we, clk);
output  [15:0] q;
output  [15:0] q2;
input [15:0] d;
input [3:0] write_address;
input [3:0] read_address;
input [3:0] read_address2;
input we, clk;
reg [3:0] a1, a2;
reg [15:0] mem [15:0];
always @ (posedge clk) begin
	if (we) mem[write_address] <= d;
	a1 <= read_address;
	a2 <= read_address2;
end
assign q = mem[a1];
assign q2 = mem[a2];
endmodule

/////////////////////////////////////////////////
// data memory: 
// single read and write
// taken from Altera HDL style manual page 6-17
// Synchronous RAM with Read-Through-Write Behavior
// and modified for 16 bit access
// of 256 words
module ram_infer (q, a, d, we, clk);
output  [15:0] q;
input [15:0] d;
input [7:0] a;
input we, clk;
reg [7:0] read_add;
reg [15:0] mem [255:0];
	always @ (posedge clk) begin
	if (we) mem[a] <= d;
	read_add <= a;
	end
	assign q = mem[read_add];
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
///////////////////////////////////////////////