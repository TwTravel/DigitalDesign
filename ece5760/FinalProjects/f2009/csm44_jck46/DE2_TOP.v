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
	//assign LEDR = 18'h0;
	//assign LEDG = 9'h0;

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
	//csm44
	wire	m4clk;
	//sum of all audio outputs of keys
	reg [22:0] audioOutputSum;
	
	assign	TD_RESET	=	1'b1;	//	Allow 27 MHz
	assign	AUD_ADCLRCK	=	AUD_DACLRCK;
	assign	AUD_XCK		=	AUD_CTRL_CLK;

	Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);


    VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);

	//csm44
	m4Clk				p2 	(	.areset(~DLY_RST),
								.inclk0(CLOCK_50),
								.c0(m4clk) );

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
							.iAUD_extL(audioOutputSum[17:2]),//(SW[0] == 0) ?*/ audioOutput[17:2]+ audioOutput[35:20]),//audioOutput[17:2]) // audio data to DAC
							.iAUD_extR(audioOutputSum[17:2]),//(SW[0] == 0) ? */audioOutput[17:2]+ audioOutput[35:20]),//audioOutput[17:2]) // audio data to DAC
							//	Control Signals
							.iCLK_18_4(AUD_CTRL_CLK),
							.iRST_N(DLY_RST)
							);
	
	
	//key timer counters
	wire [467:0] kCount;
	//debouncer down outputs
	wire [17:0] keyPressed;
	//debouncer up outputs 
	wire [17:0] keyNotPressed;
	//alpha input into karplus
	wire [53:0] alph;
	//note input into karplus
	wire [161:0] nt;
	//gain input into karplus
	wire [323:0] gn;
	//audio outputs of keys
	wire [323:0] audioOutput;
	//output sum of all keys
	reg addstate;
	always@(posedge CLOCK_50)
	begin
		//pad with MSB so we don't lose data if many strings play at once (or wrap from pos to neg)
		audioOutputSum <= (	{audioOutput[17] ? 5'b11111 : 5'b00000, audioOutput[17:0]} + 
							{audioOutput[35] ? 5'b11111 : 5'b00000, audioOutput[35:18]} + 
							{audioOutput[53] ? 5'b11111 : 5'b00000, audioOutput[53:36]} +
							{audioOutput[71] ? 5'b11111 : 5'b00000, audioOutput[71:54]} + 
							{audioOutput[89] ? 5'b11111 : 5'b00000, audioOutput[89:72]} + 
							{audioOutput[107] ? 5'b11111 : 5'b00000, audioOutput[107:90]} + 
							{audioOutput[125] ? 5'b11111 : 5'b00000, audioOutput[125:108]} + 
							{audioOutput[143] ? 5'b11111 : 5'b00000, audioOutput[143:126]} + 
							{audioOutput[161] ? 5'b11111 : 5'b00000, audioOutput[161:144]} + 
							{audioOutput[179] ? 5'b11111 : 5'b00000, audioOutput[179:162]} + 
							{audioOutput[197] ? 5'b11111 : 5'b00000, audioOutput[197:180]} + 
							{audioOutput[215] ? 5'b11111 : 5'b00000, audioOutput[215:198]} + 
							{audioOutput[233] ? 5'b11111 : 5'b00000, audioOutput[233:216]} + 
							{audioOutput[251] ? 5'b11111 : 5'b00000, audioOutput[251:234]} + 
							{audioOutput[269] ? 5'b11111 : 5'b00000, audioOutput[269:252]} + 
							{audioOutput[287] ? 5'b11111 : 5'b00000, audioOutput[287:270]} + 
							{audioOutput[305] ? 5'b11111 : 5'b00000, audioOutput[305:288]} + 
							{audioOutput[323] ? 5'b11111 : 5'b00000, audioOutput[323:306]})>>>4;
						
	end						
	//****assign alpha values to keys****
	assign alph[2:0] = 3'b111;
	assign alph[5:3] = 3'b111;
	assign alph[8:6] = 3'b111;
	assign alph[11:9] = 3'b111;
	assign alph[14:12] = 3'b111;
	assign alph[17:15] = 3'b111;
	assign alph[20:18] = 3'b111;
	assign alph[23:21] = 3'b111;
	assign alph[26:24] = 3'b111;
	assign alph[29:27] = 3'b111;
	assign alph[32:30] = 3'b111;
	assign alph[35:33] = 3'b111;
	assign alph[38:36] = 3'b111;
	assign alph[41:39] = 3'b111;
	assign alph[44:42] = 3'b111;
	assign alph[47:45] = 3'b111;
	assign alph[50:48] = 3'b111;
	assign alph[53:51] = 3'b111;
	
	//*** assign note values to keys***
	assign nt[8:0] = 9'b011110011;
	assign nt[17:9] = 9'b011100110;
	assign nt[26:18] = 9'b011100111;
	assign nt[35:27] = 9'b011011010;
	assign nt[44:36] = 9'b011001110;
	assign nt[53:45] = 9'b011000010;
	assign nt[62:54] = 9'b010110111;
	assign nt[71:63] = 9'b010101101;
	assign nt[80:72] = 9'b010100011;
	assign nt[89:81] = 9'b010011010;
	assign nt[98:90] = 9'b010010010;
	assign nt[107:99] = 9'b010001001;
	assign nt[116:108] = 9'b010000001;
	assign nt[125:117] = 9'b001111010;
	assign nt[134:126] = 9'b001110100;
	assign nt[143:135] = 9'b001101101;
	assign nt[152:144] = 9'b001100111;
	assign nt[161:153] = 9'b001100001;

	//***assign gain values to keys***
	assign gn[17:0] = GPIO_0[1] ? 18'h0_7FC0 : 18'h0_7DA4 ;
	assign gn[35:18] = GPIO_0[3] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[53:36] = GPIO_0[5] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[71:54] = GPIO_0[7] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[89:72] = GPIO_0[9] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[107:90] = GPIO_0[11] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[125:108] = GPIO_0[13] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[143:126] = GPIO_0[15] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[161:144] = GPIO_0[17] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[179:162] = GPIO_0[19] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[197:180] = GPIO_0[21] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[215:198] = GPIO_0[23] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[233:216] = GPIO_0[25] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[251:234] = GPIO_0[27] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[269:252] = GPIO_0[29] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[287:270] = GPIO_0[31] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[305:288] = GPIO_0[33] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	assign gn[323:306] = GPIO_0[35] ? 18'h0_7FC0 : 18'h0_7DA4 ; 
	
	//Instantiate note simulators
	karplus key0(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[8:0]),
				 .gain(gn[17:0]),
				 .pluck(GPIO_0[1]),
				 .audioOut(audioOutput[17:0]),
				 .alpha(alph[2:0]));
				 //.count(kCount[25:0]));
				 
	karplus key1(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[17:9]),
				 .gain(gn[35:18]),
				 .pluck(GPIO_0[3]),
				 .audioOut(audioOutput[35:18]),
				 .alpha(alph[5:3]));
				 //.count(kCount[51:26]));
	
	karplus key2(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[26:18]),
				 .gain(gn[53:36]),
				 .pluck(GPIO_0[5]),
				 .audioOut(audioOutput[53:36]),
				 .alpha(alph[8:6]));
				 //.count(kCount[77:52]));
				 
	karplus key3(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[35:27]),
				 .gain(gn[71:54]),
				 .pluck(GPIO_0[7]),
				 .audioOut(audioOutput[71:54]),
				 .alpha(alph[11:9]));
				 //.count(kCount[103:78]));	
	
	karplus key4(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[44:36]),
				 .gain(gn[89:72]),
				 .pluck(GPIO_0[9]),
				 .audioOut(audioOutput[89:72]),
				 .alpha(alph[14:12]));	
				 
				 
	karplus key5(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[53:45]),
				 .gain(gn[107:90]),
				 .pluck(GPIO_0[11]),
				 .audioOut(audioOutput[107:90]),
				 .alpha(alph[17:15]));	
				 
	karplus key6(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[62:54]),
				 .gain(gn[125:108]),
				 .pluck(GPIO_0[13]),
				 .audioOut(audioOutput[125:108]),
				 .alpha(alph[20:18]));	
				 			 
	karplus key7(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[71:63]),
				 .gain(gn[143:126]),
				 .pluck(GPIO_0[15]),
				 .audioOut(audioOutput[143:126]),
				 .alpha(alph[23:21]));
				 
	karplus key8(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[80:72]),
				 .gain(gn[161:144]),
				 .pluck(GPIO_0[17]),
				 .audioOut(audioOutput[161:144]),
				 .alpha(alph[26:24]));
				 
	karplus key9(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[89:81]),
				 .gain(gn[179:162]),
				 .pluck(GPIO_0[19]),
				 .audioOut(audioOutput[179:162]),
				 .alpha(alph[29:27]));
				 
	karplus key10(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[98:90]),
				 .gain(gn[197:180]),
				 .pluck(GPIO_0[21]),
				 .audioOut(audioOutput[197:180]),
				 .alpha(alph[32:30]));
				 
	karplus key11(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[107:99]),
				 .gain(gn[215:198]),
				 .pluck(GPIO_0[23]),
				 .audioOut(audioOutput[215:198]),
				 .alpha(alph[35:33]));
				 
	karplus key12(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[116:108]),
				 .gain(gn[233:216]),
				 .pluck(GPIO_0[25]),
				 .audioOut(audioOutput[233:216]),
				 .alpha(alph[38:36]));
				 
	karplus key13(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[125:117]),
				 .gain(gn[251:234]),
				 .pluck(GPIO_0[27]),
				 .audioOut(audioOutput[251:234]),
				 .alpha(alph[41:39]));
				 
	karplus key14(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[134:126]),
				 .gain(gn[269:252]),
				 .pluck(GPIO_0[29]),
				 .audioOut(audioOutput[269:252]),
				 .alpha(alph[44:42]));
	
	karplus key15(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[143:135]),
				 .gain(gn[287:270]),
				 .pluck(GPIO_0[31]),
				 .audioOut(audioOutput[287:270]),
				 .alpha(alph[47:45]));
				 
	karplus key16(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[152:144]),
				 .gain(gn[305:288]),
				 .pluck(GPIO_0[33]),
				 .audioOut(audioOutput[305:288]),
				 .alpha(alph[50:48]));
				 
	karplus key17(.clock50(CLOCK_50),
				 .audiolrclk(AUD_DACLRCK),
				 .m4Clock(m4clk),
				 .reset(~KEY[0]),
				 .noteIn(nt[161:153]),
				 .gain(gn[323:306]),
				 .pluck(GPIO_0[35]),
				 .audioOut(audioOutput[323:306]),
				 .alpha(alph[53:51]));
				 
	//Timer instantion for velocity sensitive portion, unused for demo
	//assign LEDR[16:0] = kCount[25:9];
//	timer key0Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[0] & 
//							~GPIO_0[1] &
//							~(kCount[25:0] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[0]),
//					.q(kCount[25:0]));
//					
//	timer key1Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[2] & 
//							~GPIO_0[3] &
//							~(kCount[51:26] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[2]),
//					.q(kCount[51:26]));
//					
//	timer key2Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[4] & 
//							~GPIO_0[5] &
//							~(kCount[77:52] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[4]),
//					.q(kCount[77:52]));
//					
//	timer key3Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[6] & 
//							~GPIO_0[7] &
//							~(kCount[103:78] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[6]),
//					.q(kCount[103:78]));
//					
//	timer key4Timer (.clock(CLOCK_50),
//					.cnt_en(GPIO_0[8] & 
//							~GPIO_0[9] &
//							~(kCount[129:104] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[8]),
//					.q(kCount[129:104]));
//					
//	timer key5Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[10] & 
//							~GPIO_0[11] &
//							~(kCount[155:130] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[10]),
////					.q(kCount[155:130]));
//					
//	timer key6Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[12] & 
//							~GPIO_0[13] &
//							~(kCount[181:156] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[12]),
//					.q(kCount[181:156]));
					
//	timer key7Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[14] & 
//							~GPIO_0[15] &
//							~(kCount[207:182] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[14]),
//					.q(kCount[207:182]));
//					
//	timer key8Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[16] & 
//							~GPIO_0[17] &
//							~(kCount[233:208] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[16]),
//					.q(kCount[233:208]));
//					
//	timer key9Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[18] & 
//							~GPIO_0[19] &
//							~(kCount[259:234] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[18]),
//					.q(kCount[259:234]));
//					
//	timer key10Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[20] & 
//							~GPIO_0[21] &
//							~(kCount[285:260] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[20]),
//					.q(kCount[285:260]));
//					
//	timer key11Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[22] & 
//							~GPIO_0[23] &
//							~(kCount[311:286] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[22]),
//					.q(kCount[311:286]));
//					
//	timer key12Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[24] & 
//							~GPIO_0[25] &
//							~(kCount[337:312] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[24]),
//					.q(kCount[337:312]));
//					
//	timer key13Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[26] & 
//							~GPIO_0[27] &
//							~(kCount[363:338] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[26]),
//					.q(kCount[363:338]));
//					
//	timer key14Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[28] & 
//							~GPIO_0[29] &
//							~(kCount[389:364] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[30]),
//					.q(kCount[389:364]));
//					
//	timer key15Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[30] & 
//							~GPIO_0[31] &
//							~(kCount[415:390] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[30]),
//					.q(kCount[415:390]));
//					
//	timer key16Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[32] & 
//							~GPIO_0[33] &
//							~(kCount[441:416] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[32]),
//					.q(kCount[441:416]));
//					
//	timer key17Timer (.clock(CLOCK_50),
//					.cnt_en(~GPIO_0[34] & 
//							~GPIO_0[35] &
//							~(kCount[467:442] == 26'hFFFFFFF ? 1 : 0)),
//					.sclr(GPIO_0[34]),
//					.q(kCount[467:442]));
	

endmodule

//////////////////////////////////////////////////
//// M4k ram for circular buffer /////////////////
//////////////////////////////////////////////////
// Synchronous RAM with Read-Through-Write Behavior
// and modified for 18 bit access
// of 109 words to tune for 440 Hz
module ram_infer (q, a, d, we, clk);
	output  [17:0] q;
	input [17:0] d;
	input [11:0] a;
	input we, clk;
	reg [11:0] read_add;
	// define the length of the shiftregister
	// 48000/2000 is 24 Hz. Should be long enough
	// for any reasonable note
	parameter note = 2047 ; 
	reg [17:0] mem [note:0];
	always @ (posedge clk) 
	begin
		if (we) 
			begin
				mem[a] <= d;
				read_add <= a;
			end
	end
	assign q = mem[read_add];

endmodule 
//////////////////////////////////////////////////

//////////////////////////////////////////////////
//// signed mult of 2.16 format 2'comp////////////
//////////////////////////////////////////////////
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

//////////////////////////////////////////////////
module debouncer (in, out, clk);
	//Debounces port in
	//When in satisfies 'on' conditions, set out has high
	input wire in;
	input wire clk;
	output wire out;
	reg[1:0] state;
	assign out = in;
	/*
	always @ (posedge clk)
	begin
		case(state)
			//NoPush: Check if in is high
			//if so, transition to MaybePush
			//Set out to low.
			0: 
			begin
				out <= 0;
				if(in)
				begin
					state <= 1;
				end
				
				else
				begin
					state <= 0;
				end
			end
			//MaybePush: If in is still high, go to Push.
			//Else go to NoPush
			//Set out to low.
			1: 
			begin
				out <= 0;
				if(in)
				begin
					state <= 2;
				end
				
				else
				begin
					state <= 0;
				end
			end
			//Push: set out to high.
			//If in still high, stay in Push
			//Else go to MaybeNoPush
			2:
			begin
				out <= 1;
				if(in)
				begin
					state <= 2;
				end
				
				else
				begin
					state <= 3;
				end 
			end
			//MaybeNoPush: If in high, go back to Push
			//Set out to high still
			//If in low, go to NoPush
			3: 
			begin
				out <= 1;
				if(in)
				begin
					state <= 2;
				end
				
				else
				begin
					state <= 0;
				end 
			end
			default: 
			begin
				state <= 0;
			end
			endcase
	end
	*/
	
	
	
	
endmodule 