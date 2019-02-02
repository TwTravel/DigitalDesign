// --------------------------------------------------------------------
// --------------------------------------------------------------------
//
// Major Functions:	lockin amplifier
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
// Tristan Rocheleau, Cornell University, Nov 2008
// --------------------------------------------------------------------


module lockin_amp
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
assign	LCD_ON		=	1'b1;
assign	LCD_BLON	=	1'b1;

//	All inout port turn to tri-state
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ		=	8'hzz;
assign	SRAM_DQ		=	16'hzzzz;
assign	OTG_DATA	=	16'hzzzz;
assign	SD_DAT		=	1'bz;
assign	ENET_DATA	=	16'hzzzz;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;

wire	reset; 
wire	locked;
wire	NIOS_CLK;
wire	ADPLL_locked;
wire	PLL_pos;
wire	PLL_neg;

wire	[13:0]	ADCa;
wire	[13:0]	ADCb;

wire	[13:0]	DACa;
wire	[13:0]	DACb;

assign	reset = ~KEY[0];
assign	LEDG[8]	= ADPLL_locked;		//display PLL locking on led.  just for reference


wire	[9:0]	processed_I;		//output lines from NIOS.  Not used, just available for future feature expansion.
wire	[9:0]	processed_Q;

wire	[31:0]	control;			
//control lines from nios.  
//bit 0: frequency source.  0 is user set, 1 is pll output
//bit 1: 




wire	signed	[17:0]	refout_I;
wire	signed	[17:0] 	refout_Q;
wire	signed	[13:0]	reference_in;

wire	signed	[17:0]	signal_in;
wire	signed	[35:0]	signalI1;
wire	signed	[35:0]	signalQ1;
reg		signed	[35:0]	signalI1_reg;
reg		signed	[35:0]	signalQ1_reg;
wire	signed	[35:0]	signalI2;
wire	signed	[35:0]	signalQ2;

wire	signed 	[31:0]	time_const;// = {10'b001111111, 26'b0};

reg		[9:0]	sigout_A;		//output signals, assigned to VGA DACs.(A/D board seem to really suck, not sure why.   <- cause it's badly designed, that's why!)
reg		[9:0]	sigout_B;

wire			DDS_sync_output;
wire			reference_square_wave;
wire	[29:0]	DDS_feedback_out;

wire	CLOCK_100;

reg		[31:0]	clock_div;

clock_50_PLL pll1(
	CLOCK_50,
	CLOCK_100,		//output 100MHz signal for DDS + analog control logic	
	DRAM_CLK,		//50MHz 
	NIOS_CLK,		//50MHz with 3ns delay
	locked);		




always @ (posedge NIOS_CLK)			//clock divider, used for various debug purposes
begin
	clock_div <= clock_div + 1;
end


assign	GPIO_0[16] = NIOS_CLK;		//ADC0 clock out
assign	GPIO_0[18] = NIOS_CLK;		//ADC1 clock out  0=A??

//assign	GPIO_1[16] = NIOS_CLK;		//DAC0 clock out		//not using DAC on A/D board, so no clocks for them
//assign	GPIO_1[18] = NIOS_CLK;		//DAC1 clock out

//assign	GPIO_0[17] = CLOCK_100;		//DAC A write
//assign	GPIO_0[34] = CLOCK_100;		//DAC B write

assign	GPIO_1[35] = 1;  			//DAC mode.  1=dual port, 0=interleaved

assign	GPIO_0[35] = 0;				//Enable ADC A
assign	GPIO_0[33] = 0;				//Enable ADC B

assign	GPIO_0[32] = 1;				//analog board on.



/*GPIO_0[0] = ADC A out of range 		//out of range detect is not implemented here
GPIO_0[2] = ADC A out of range 
*/


//best try from schematics for DE2 board:			//these are the pinouts for the A/D to DE2 board connection.  This was really annoying to get right.
assign  ADCa = {GPIO_0[31],GPIO_0[29],GPIO_0[30],GPIO_0[28],GPIO_0[27],GPIO_0[25],GPIO_0[26],GPIO_0[24],
                 GPIO_0[23],GPIO_0[21],GPIO_0[22],GPIO_0[20],GPIO_0[19],GPIO_0[17]}; 
	
assign  ADCb = {GPIO_0[15],GPIO_0[13],GPIO_0[14],GPIO_0[12],GPIO_0[11],GPIO_0[9],GPIO_0[10],GPIO_0[8],
                 GPIO_0[7],GPIO_0[5],GPIO_0[6],GPIO_0[4],GPIO_0[3],GPIO_0[1]}; 

assign  {GPIO_1[1],GPIO_1[3],GPIO_1[4],GPIO_1[6],GPIO_1[5],GPIO_1[7],GPIO_1[8],GPIO_1[10],
         GPIO_1[9],GPIO_1[11],GPIO_1[12],GPIO_1[14],GPIO_1[13],GPIO_1[15]} = DACa; 

assign  {GPIO_1[19],GPIO_1[21],GPIO_1[22],GPIO_1[24],GPIO_1[23],GPIO_1[25],GPIO_1[27],GPIO_1[29],
         GPIO_1[26],GPIO_1[28],GPIO_1[31],GPIO_1[33],GPIO_1[30],GPIO_1[32]} = DACb; 
         
////////////////////////////////////////////////
//test stuff.  All for debug.  
/*assign	ADCa = 	SW[17] ? 
				(clock_div[10] ? (14'b10000000000000 + 14'd2000) : (14'b10000000000000 - 14'd2000))
				: {GPIO_0[31],GPIO_0[29],GPIO_0[30],GPIO_0[28],GPIO_0[27],GPIO_0[25],GPIO_0[26],GPIO_0[24],
                 GPIO_0[23],GPIO_0[21],GPIO_0[22],GPIO_0[20],GPIO_0[19],GPIO_0[17]}				;  //EXT_CLOCK ? (14'b10000000000000 + 14'd2000) : (14'b10000000000000 - 14'd2000);
*/
//assign	ADCb = EXT_CLOCK ? (14'b10000000000000 + 14'd1000) : (14'b10000000000000 - 14'd1000);

//assign	GPIO_0[0] = clock_div[10];

//always @ (posedge KEY[1])
//	time_const[35:18] <= SW[17:0];
/*
reg [17:0]	sigin_max;

always @ (posedge ~NIOS_CLK)
begin
	if(~KEY[0])
	begin
		if({ADCa, 4'b0} > sigin_max)
			sigin_max <= {ADCa, 4'b0};
		else
			sigin_max <= sigin_max;
	end
	
	else
	begin
		if({ADCa, 4'b0} < sigin_max)
			sigin_max <= {ADCa, 4'b0};
		else
			sigin_max <= sigin_max;
	end
end
*/
//assign LEDR[17:0] = sigin_max;//DDS_feedback_out[33:16];
assign LEDR[17:0] = control[17:0];
//assign	control[17:0] = SW[17:0];

/////////////////////////////////////////////////

//signal flow is as follows:
//ADCa[13:0] -> signal_in[17:0] ->(mult) signalI/Q1[35:0] ->(filter) signalI/Q2[35:0] -> sigout_A/B(whatever is set) 
//reference flow:
//ADCb[13:0] ->(zero cross) reference_square_wave -> PLL -> frequency[39:0]

assign 	signal_in = {ADCa[13:0], 4'b0} - 18'b100000000000000000;	//convert 14' unsigned to 18' signed

signed_mult	mixer_I	(signalI1[35:0], signal_in[17:0], refout_I[17:0]);			//I and Q mixer/multiplier
signed_mult mixer_Q (signalQ1[35:0], signal_in[17:0], refout_Q[17:0]);								

always @ (posedge NIOS_CLK)		//there is insufficient time for the signal to propagate through the mixers + filter in 1 clock cycle.
begin							//thus, it must be registered after the mixer.  The filter output is also already registered.
	signalI1_reg <= signalI1;	//if not registered, the output signal gets real weird/oscillatory.    <- this also took forever to figure out.  
	signalQ1_reg <= signalQ1;
end	
	
exponential_decay_filter	I1(signalI1_reg[35:0], signalI2[35:0], {2'b0, time_const[31:0], 2'b0}, NIOS_CLK, 1'b0);			//low pass filter mixer outputs
exponential_decay_filter	Q2(signalQ1_reg[35:0], signalQ2[35:0], {2'b0, time_const[31:0], 2'b0}, NIOS_CLK, 1'b0);			s


assign	reference_in = ADCb[13:0] - 14'b10000000000000;
assign	VGA_G = sigout_A;
assign	VGA_B = sigout_B;

always @ (negedge NIOS_CLK)			//output routing.  I'm just using registers for simplicity of always block stamement declaration
begin
	if(control[0])
		frequency[29:0] = {DDS_feedback_out[29:0]}; 		//control frequency source, internal or external.  
	else
		frequency[29:0] = {user_frequency[29:0]};


	if(control[3:1] == 3'b000)			//direct signal feedthrough
		sigout_A <= {1'b1, 9'b0} + signal_in[17:8];
	else if(control[3:1] == 3'b001)			//mixer output
		sigout_A <= {1'b1, 9'b0} + signalI1[35:26];
	else if(control[3:1] == 3'b010)			//filter output
		sigout_A <= {1'b1, 9'b0} + signalI2[35:26];
	else if(control[3:1] == 3'b011)			//nios processed signal.  not implemented
		sigout_A <= {1'b1, 9'b0} + processed_I[9:0];
	else if(control[3:1] == 3'b100)			//reference sine out
		sigout_A <= {1'b1, 9'b0} + refout_I[17:8];
	else
		sigout_A <= 10'b0;
	
	if(control[6:4] == 3'b000)			//direct signal feedthrough
		sigout_B <= {1'b1, 9'b0} + reference_in[13:4];
	else if(control[6:4] == 3'b001)			//mixer output
		sigout_B <= {1'b1, 9'b00} + signalQ1[35:26];
	else if(control[6:4] == 3'b010)			//filter output
		sigout_B <= {1'b1, 9'b00} + signalQ2[35:26];
	else if(control[6:4] == 3'b011)			//nios processed signal.  not implemented
		sigout_B <= {1'b1, 9'b0} + processed_Q[9:0];
	else if(control[6:4] == 3'b100)			//reference sine out
		sigout_B <= {1'b1, 9'b0} + refout_Q[17:8];
	else
		sigout_B <= 10'b0;	

end
/*		//original switch oriented debugging.
if(control[1])
	sigout_A = {1'b1, 9'b0} + signal_in[17:8];
else if(control[2])
	sigout_A = {1'b1, 9'b0} + refout_I[17:8];	
else if(control[3])
	sigout_A = {1'b1, 9'b0} + signalI1[35:26];
else if(control[4])
	sigout_A = {1'b1, 9'b0} + signalI2[35:26];
else if(control[5])
	sigout_A = {DDS_sync_output, 9'b0};
else if(control[6])
	sigout_A = (PLL_pos ? 10'd1000 : 10'd0);
else
	sigout_A = 10'b0;

if(control[7])
	sigout_B = {1'b1, 9'b0} + signal_in[14:5];
else if(control[8])
	sigout_B = {1'b1, 9'b0} + refout_Q[17:8];
else if(control[9])
	sigout_B = {1'b1, 9'b0} + signalQ1[32:23];
else if(control[10])
	sigout_B = {1'b1, 9'b0} + signalQ2[32:23];
else if(control[11])
	sigout_B = {1'b1, 9'b0} + reference_in[13:4];
else if(control[12])
	sigout_B = {reference_square_wave, 9'b0};
else if(control[13])
	sigout_B = (reference_square_wave ? 10'd1000 : 10'd0);
else if(control[14])
	sigout_B = (PLL_neg ? 10'd1000 : 10'd0);
else
	sigout_B = 10'b0;
end

*/



wire	[17:0]	refout_I_unsigned;
wire	[17:0]	refout_Q_unsigned;
assign	refout_I = refout_I_unsigned - 18'b100000000000000000;		//convert to 18 bit signed. more or less...
assign	refout_Q = refout_Q_unsigned - 18'b100000000000000000;	

signal_generator	s1			(frequency,			//output frequency
								NIOS_CLK,				//
								DDS_sync_output,	//sync to PLL
								refout_I_unsigned[17:0],		//output both I and Q
								refout_Q_unsigned[17:0]
								);
								
ref_digital_PLL dpll1	(DDS_sync_output,		//phase + frequency square wave from DDS
						reference_square_wave,	//ref signal after zero-crossing detect
						NIOS_CLK,
						DDS_feedback_out[29:0],
						ADPLL_locked,			//locked signal
						PLL_pos,				//debug signals indicating phase error
						PLL_neg);

zero_crossing_detector 	z1	(reference_in[13:0], 		//signal in should be in 2's comp
							NIOS_CLK,
							reference_square_wave);

reg		[29:0]	frequency;
wire	[31:0]	user_frequency;// = {32'd2000000};




assign DACb = SW[17] ? SW[15:2] : refout_I[17:4];				//just mirror inputs to outputs as test.
assign DACa = SW[16] ? ADCa 	: refout_Q[17:4];


assign VGA_SYNC = 1;
assign VGA_BLANK = 1;
assign VGA_CLK = NIOS_CLK;

//






wire	[7:0]	other_in;
wire	[31:0]	other_out;


control_nios (       // 1) global signals:
                       NIOS_CLK,
                       ~reset,
                       
						signalI2[35:4],			//filtered I in
						signalQ2[35:4],			//filtered Q in
							
						//char ram	
                        write_address_to_char_ram[9:0], 	//address_out_to_the_character_buffer,
                        0,								//datain_from_ram_from_the_character_buffer, no datain here
                        data_to_char_ram[31:0],			//dataout_to_ram_to_the_character_buffer,
                        char_ram_wren,				//wren_out_to_the_character_buffer,
						
						control[31:0],			//out
						{2'b0, frequency},						//freq in 
						
							
						//image ram
						write_address_to_image_ram[9:0], 	//address_out_to_the_character_buffer,
                        0,								//datain_from_ram_from_the_character_buffer, no datain here
                        data_to_image_ram[31:0],			//dataout_to_ram_to_the_character_buffer,
                        image_ram_wren,				//wren_out_to_the_character_buffer,
	
							
						// the_lcd
                        LCD_EN,					//	LCD Enable
                        LCD_RS,					//	LCD Command/Data Select, 0 = Command, 1 = Data
                        LCD_RW,					//	LCD Read/Write Select, 0 = Write, 1 = Read
                        LCD_DATA[7:0],				//	LCD Data bus 8 bits
                       	
                       	other_in,				//misc input?  locked info, perhaps?
                       	other_out,	//other_out[31:0],		//other uses?  I don't know.  How about cursor location
						processed_I[9:0],		//out
						processed_Q[9:0],		//out
						
						// the_sdram
						DRAM_ADDR,
						{DRAM_BA_1, DRAM_BA_0},
						DRAM_CAS_N,
						DRAM_CKE,
						DRAM_CS_N,
						DRAM_DQ,
						{DRAM_UDQM, DRAM_LDQM},
						DRAM_RAS_N,
						DRAM_WE_N,
                       
						time_const[31:0],		//out
						user_frequency[31:0],	//out      
						{11'b0, KEY[3:1], SW[17:0]}	//user_input in

						
						);
                      
	

//wire	DRAM_WE_N = SW[0] ? we_mess : 1'b1;
assign	cursor_location = other_out[9:0];   // = {cursor_y, cursor_x};

wire	[31:0]	data_to_image_ram;
wire	[9:0]	write_address_to_image_ram;
wire			image_ram_wren;


wire	[11:0]	display_char_address = X_COORD[9:3] + 7'd70 * Y_COORD[9:3];		//generate character lookup from output coords from NTSC disp generator

wire	[31:0]	data_to_char_ram;
wire	[9:0]	write_address_to_char_ram;		//only 10 bits of address space
wire	[11:0]	read_address_to_char_ram = display_char_address;
wire		char_ram_wren;
wire	[7:0]	data_from_char_ram;				   
					   
character_buffer	cbuff1	(data_to_char_ram[7:0],			//dual port ram character buffer for display.
						read_address_to_char_ram[11:0],
						NIOS_CLK,
						{2'b0, write_address_to_char_ram[9:0]},
						NIOS_CLK,
						char_ram_wren,
						data_from_char_ram[7:0]);

	
wire	[2:0]	char_col = X_COORD[2:0];	
wire	[2:0]	char_row = Y_COORD[2:0];
wire			char_pixel_out;
wire			cursor_pixel;

wire	[11:0]	cursor_location; // = 10'd40;
wire	[9:0]	cursor_y; // = 10'd40;
wire			cursor_on = clock_div[23];		//cursor flashes at ~1.5

assign cursor_pixel = (display_char_address == cursor_location) && cursor_on;  //cursor pixel generation.

character_generator cgen1	(NIOS_CLK,			//ascii character generator
					data_from_char_ram, 
					char_col,
					char_row,
					char_pixel_out);


wire	[9:0]	NTSC_signal_out;
wire	[9:0]	X_COORD;
wire	[9:0]	Y_COORD;
wire			sync_out;

assign 			VGA_R[9:0] = (NTSC_signal_out[9:0] >= 10'd511) ? 10'd1020 : (NTSC_signal_out[9:0] * 10'd2);		//assign NTSC signal to VGA_R out.  To compensate for voltage pulldown of 75OHm TV source, signal is doubled.  This is not ideal, especially for color rendering, but works okay for now.

//f the color for now.  Sigh...
wire	[8:0]	NTSC_Y = {char_pixel_out, (cursor_pixel ? 8'b11111111 : 8'b0)};					//intensity in, 2^10 steps.  The disp generator does not actually have this degree of color resolution.(sorry)
//wire	[9:0]	NTSC_G = {1'b0, char_pixel_out, X_COORD[7], Y_COORD[7], 6'b0};
wire	[3:0]	NTSC_color = SW[3:0];//  color is not really supported!!  This gives a small color pallete which works okay, but can have major distortion due to signal doubling above!  Still, I'e left it in cause it looks cool.  


NTSC_disp_generator	v1	(NTSC_Y[8:0],				//NTSC timing generator.
						NTSC_color[3:0],
						//16'd0,	//color phase,  16 bits for all colors
						NIOS_CLK,		//clock in.  50MHz
						NTSC_signal_out[9:0],	//ntsc signal out to dac
						X_COORD[9:0],	//current displayed x coordinate
						Y_COORD[9:0],	//current displayed y coordinate
						sync_out);		//sync signals, both horiz and vert
endmodule





///////////////////////////////////////////////////
//// signed mult of 2.16 format 2'comp ////////////
///////////////////////////////////////////////////
module signed_mult (out, a, b);
	
	output 		[35:0]	out;
	input 	signed	[17:0] 	a;
	input 	signed	[17:0] 	b;
	
	wire	signed	[35:0]	out;
	wire 	signed	[35:0]	mult_out;

	assign mult_out = a * b;
	assign out = mult_out[35:0];
	//assign out = {mult_out[35], mult_out[32:16]};
endmodule
////////////////////////////////////////////////////





