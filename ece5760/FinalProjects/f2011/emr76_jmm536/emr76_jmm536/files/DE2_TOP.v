// --------------------------------------------------------------------
// --------------------------------------------------------------------
//
// Major Functions: Video output from Stack machine 
//		VGA state is in m4k blocks
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
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

    // Audio CODEC
    inout         AUD_ADCLRCK, // Audio CODEC ADC LR Clock
    input         AUD_ADCDAT,  // Audio CODEC ADC Data
    inout         AUD_DACLRCK, // Audio CODEC DAC LR Clock
    output        AUD_DACDAT,  // Audio CODEC DAC Data
    inout         AUD_BCLK,    // Audio CODEC Bit-Stream Clock
    output        AUD_XCK,     // Audio CODEC Chip Clock

    // GPIO
    inout  [35:0] GPIO_0,      // GPIO Connection 0
    inout  [35:0] GPIO_1       // GPIO Connection 1
);


   
   //Set all GPIO to tri-state.

   assign GPIO_1 = 36'hzzzzzzzzz;

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

   //Disable SRAM.
   assign SRAM_ADDR = 18'h0;
   assign SRAM_CE_N = 1'b1;
   assign SRAM_DQ   = 16'hzzzz;
   assign SRAM_LB_N = 1'b1;
   assign SRAM_OE_N = 1'b1;
   assign SRAM_UB_N = 1'b1;
   assign SRAM_WE_N = 1'b1;


   //Disable all other peripherals.

   assign IRDA_TXD = 1'b0;

   assign TDO = 1'b0;

	   

	wire	VGA_CTRL_CLK;
	wire	AUD_CTRL_CLK;
	wire	FAST_CLK;
	wire	DLY_RST;

	assign	TD_RESET	=	1'b1;	//	Allow 27 MHz
	assign	AUD_ADCLRCK	=	AUD_DACLRCK;
	assign	AUD_XCK		=	AUD_CTRL_CLK;

	Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

	//Phase Lock Loop to generate the clocks
	VGA_Audio_PLL   p1	(	.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(FAST_CLK)	);

	//initializes the audio codac
	I2C_AV_Config 		u5	(	//	Host Side
								.iCLK(CLOCK_50),
								.iRST_N(KEY[0]),
								//	I2C Side
								.I2C_SCLK(I2C_SCLK),
								.I2C_SDAT(I2C_SDAT)	);

	//configures the i/o for the audio codac
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
	
	
	// for flute/ocarina we want something like synthesize('test.wav', 220, 1, [0 1 0 1 0 .5 0 .1])
	// input from audio ADC
	wire signed [15:0] audio_inL, audio_inR ;
	// output to audio DAC
	wire signed [15:0] audio_outL, audio_outR ;
	//wire signed [17:0] audio_outL_18, audio_outR_18; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	//declare the wires used used for the pure signal, vibrato-enveloped signal, and volume-controlled signal
	wire [19:0] vib_signal_long, vib_ramp, scaled_signal_long;
	wire [9:0] vib_signal, scaled_signal;
	
	assign vib_ramp = (sine_out_5Hz * ramp); //create the ramped vibrato envelope
	assign vib_signal_long = synth_signal[13:4]*(10'b0100000000 + {vib_ramp[19],vib_ramp[17:9]}); //fixed-point multiply the synthesized signal by the vibrato ramp
	assign vib_signal = {vib_signal_long[19],vib_signal_long[17:9]}; //truncate appropriate bits for fixed-point
	assign scaled_signal_long = volume * vib_signal; //fixed-point multiply the new signal by the volume
	assign scaled_signal = {scaled_signal_long[19],scaled_signal_long[17:9]}; //truncate appropriate bits for fixed-point
	assign audio_outL = {scaled_signal,6'b0}; //convert to a 16-bit number for the audio codac
	assign audio_outR = {scaled_signal,6'b0};
	
	
	//set GPIO_0 pins as inputs
	assign GPIO_0[29] = 0;
	assign GPIO_0[31] = 0;
	assign GPIO_0[33] = 0;
	assign GPIO_0[35] = 0;
	
	//assign the push button pins to the green LEDs for debugging and user-feedback
	assign LEDG[0] = GPIO_0[27];
	assign LEDG[1] = GPIO_0[26];
	assign LEDG[2] = GPIO_0[28];
	assign LEDG[3] = GPIO_0[30];
	assign LEDG[4] = GPIO_0[32];
	assign LEDG[5] = GPIO_0[34];
	
	assign LEDR = mic_abs; //assign the volume to the red LEDs for debugging and user-feedback
								

	/*				  
	wire CPU_CLK ;
	NiosTimer nios2(
				.clk(CPU_CLK), 
				.reset_n(KEY[0]), 
				.in_port_to_the_AUD_DACLRCK(AUD_DACLRCK),
				//.out_port_from_the_LED(LEDG[7:0]),
				.in_port_to_the_SAMPLE(audio_outL),
				.in_port_to_the_SWITCH(SW[7:0]),
				.out_port_from_the_WIDEOUT(DDS_incr_off),
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
							
	//DDS hardware
	reg [31:0] DDS_accum0HarmUp, DDS_accum1HarmUp, DDS_accum2HarmUp, DDS_accum3HarmUp, DDS_accum4HarmUp;
	reg [31:0] DDS_accum5HarmUp, DDS_accum6HarmUp, DDS_accum7HarmUp, DDS_accum8HarmUp, DDS_accum9HarmUp;
	reg [31:0] DDS_accum_5Hz;
	reg [31:0] DDS_incr, DDS_incr_off;
	wire [9:0] sine_out, cos_out;
	wire [9:0] sine_out0HarmUp, sine_out1HarmUp, sine_out2HarmUp, sine_out3HarmUp, sine_out4HarmUp;
	wire [9:0] sine_out5HarmUp, sine_out6HarmUp, sine_out7HarmUp, sine_out8HarmUp, sine_out9HarmUp;
	wire [9:0] sine_out_5Hz;
	//reg [9:0] saved_sine, saved_sine2;				
	reg [13:0] synth_signal;				
	
	
	// Instantiate the module sdram_pll (inclk0, c0)
	// to shift sdram clock -3 ns as suggested in
	// tut_DE2_sdram_verilog.pdf
	sdram_pll neg_3ns (CLOCK_50, DRAM_CLK, CPU_CLK);

	/*
	//show switch settings
	HexDigit Digit3(HEX3, SW[15:12]);
	HexDigit Digit2(HEX2, count_sec_tens);
	HexDigit Digit1(HEX1, count_sec_ones);
	HexDigit Digit0(HEX0, count_sec_tenth);
	//show LEDs as hex
	HexDigit Digit5(HEX5, LEDG[7:4]);
	HexDigit Digit4(HEX4, LEDG[3:0]);
	*/
	
	always@(GPIO_0)

	begin
		if     (~GPIO_0[27]&~GPIO_0[26]&~GPIO_0[28]&~GPIO_0[34]&~GPIO_0[32]&~GPIO_0[30])  DDS_incr <= 43*262*(SW[1:0]+1);
		else if( GPIO_0[27]&~GPIO_0[26]&~GPIO_0[28]&~GPIO_0[34]&~GPIO_0[32]&~GPIO_0[30])  DDS_incr <= 43*277*(SW[1:0]+1);
		else if(~GPIO_0[27]&~GPIO_0[26]&~GPIO_0[28]&~GPIO_0[34]&~GPIO_0[32]& GPIO_0[30])  DDS_incr <= 43*294*(SW[1:0]+1);
		else if( GPIO_0[27]&~GPIO_0[26]&~GPIO_0[28]&~GPIO_0[34]&~GPIO_0[32]& GPIO_0[30])  DDS_incr <= 43*311*(SW[1:0]+1);
		else if(~GPIO_0[27]&~GPIO_0[26]&~GPIO_0[28]&~GPIO_0[34]& GPIO_0[32]&~GPIO_0[30])  DDS_incr <= 43*330*(SW[1:0]+1);
		else if(~GPIO_0[27]&~GPIO_0[26]&~GPIO_0[28]&~GPIO_0[34]& GPIO_0[32]& GPIO_0[30])  DDS_incr <= 43*349*(SW[1:0]+1);
		else if(~GPIO_0[27]&~GPIO_0[26]& GPIO_0[28]&~GPIO_0[34]&~GPIO_0[32]&~GPIO_0[30])  DDS_incr <= 43*370*(SW[1:0]+1);
		else if(~GPIO_0[27]&~GPIO_0[26]& GPIO_0[28]&~GPIO_0[34]&~GPIO_0[32]& GPIO_0[30])  DDS_incr <= 43*392*(SW[1:0]+1);
		else if(~GPIO_0[27]&~GPIO_0[26]& GPIO_0[28]&~GPIO_0[34]& GPIO_0[32]&~GPIO_0[30])  DDS_incr <= 43*415*(SW[1:0]+1);
		else if(~GPIO_0[27]&~GPIO_0[26]& GPIO_0[28]&~GPIO_0[34]& GPIO_0[32]& GPIO_0[30])  DDS_incr <= 43*440*(SW[1:0]+1);
		else if(~GPIO_0[27]& GPIO_0[26]& GPIO_0[28]&~GPIO_0[34]&~GPIO_0[32]& GPIO_0[30])  DDS_incr <= 43*466*(SW[1:0]+1);
		else if(~GPIO_0[27]& GPIO_0[26]& GPIO_0[28]&~GPIO_0[34]& GPIO_0[32]&~GPIO_0[30])  DDS_incr <= 43*494*(SW[1:0]+1);
		else if( GPIO_0[27]& GPIO_0[26]& GPIO_0[28]&~GPIO_0[34]& GPIO_0[32]& GPIO_0[30])	 DDS_incr <= 43*523*(SW[1:0]+1);
		else if(~GPIO_0[27]& GPIO_0[26]& GPIO_0[28]& GPIO_0[34]& GPIO_0[32]&~GPIO_0[30])	 DDS_incr <= 43*554*(SW[1:0]+1);
		else if( GPIO_0[27]& GPIO_0[26]& GPIO_0[28]& GPIO_0[34]& GPIO_0[32]& GPIO_0[30])	 DDS_incr <= 43*587*(SW[1:0]+1);
		else DDS_incr <= 0;
		
	end
	

//registers to used to generate the vibrato effect
reg unsigned [32:0] count_50Mhz;
reg unsigned [16:0] count_ramp;
reg unsigned [9:0] ramp;
reg unsigned [3:0] count_sec_tenth;
reg unsigned [3:0] count_sec_ones;
reg unsigned [3:0] count_sec_tens;

	
	// make a direct digital systhesis accumulator 
	// and output the top 8 bits to connector JP1
	// and output a 10-bit sine wave to the VGA plug
	always @ (posedge CLOCK_50) begin
		if (volume)
		begin
			DDS_accum0HarmUp <= DDS_accum0HarmUp + DDS_incr;
			DDS_accum1HarmUp <= DDS_accum1HarmUp + (DDS_incr<<1);  						//2*DDS_incr
			DDS_accum2HarmUp <= DDS_accum2HarmUp + (DDS_incr<<1)+DDS_incr;  			//3*DDS_incr
			DDS_accum3HarmUp <= DDS_accum3HarmUp + (DDS_incr<<2);  						//4*DDS_incr
			DDS_accum4HarmUp <= DDS_accum4HarmUp + (DDS_incr<<2)+DDS_incr; 				//5*DDS_incr 4+1
			DDS_accum5HarmUp <= DDS_accum5HarmUp + (DDS_incr<<2)+(DDS_incr<<1);			//6*DDS_incr 4+2
			DDS_accum6HarmUp <= DDS_accum6HarmUp + (DDS_incr<<2)+(DDS_incr<<1)+DDS_incr;//7*DDS_incr 4+2+1
			DDS_accum7HarmUp <= DDS_accum7HarmUp + (DDS_incr<<3);						//8*DDS_incr 8
			DDS_accum8HarmUp <= DDS_accum8HarmUp + (DDS_incr<<3)+DDS_incr;				//9*DDS_incr 8+1
			DDS_accum9HarmUp <= DDS_accum9HarmUp + (DDS_incr<<3)+(DDS_incr<<1);			//10*DDS_incr 8+2
			
			DDS_accum_5Hz <= DDS_accum_5Hz + 428;//107; //5*85899/4000


			count_50Mhz <= count_50Mhz+1;
			
			if (count_50Mhz > 15000000) //wait for three tenths of a second
			begin
				count_ramp <= count_ramp+1;
				if ((count_ramp == 130210) && (ramp < 256))  //130210 = (2/3)/256 aka 2/3sec divided 256 ways
				begin
					ramp <= ramp+1;
					count_ramp<=0;
				end
			end
			
		end
		else //reset everything if volume is below threshold
		begin
			count_50Mhz <= 0; 
			count_ramp <= 0;
			ramp <= 0;
			count_sec_tenth <= 0;
			count_sec_ones <= 0;
			count_sec_tens <= 0;
		end
	end
	
	
	reg signed [15:0] mic_abs;
	reg unsigned [19:0] count;
	//reg signed [15:0] sample_array [7:0];
	//reg unsigned [2:0] array_ptr,array_ptr_plus1;
	//reg unsigned [18:0] low_pass_sample;
	//reg unsigned [15:0] shifted_low_pass_sample;
	
	
	//registers to hold on to the volume threshold levels
	reg latch15,latch14,latch13,latch12,latch11,latch10,latch9,latch8,latch7,last_latch;
	reg signed [9:0] volume, prevVolume; //register to store the current volume
		
		
	reg unsigned [3:0] latch, prevLatch;	
		
	always @ (negedge AUD_DACLRCK)
	begin
	
		if (audio_inR < 0) mic_abs <= (-1)*audio_inR;
		else mic_abs <= audio_inR;
		
		//latch any the the volume level
		latch15 <= latch15 | mic_abs[15];
		latch14 <= latch14 | mic_abs[14];
		latch13 <= latch13 | mic_abs[13];
		latch12 <= latch12 | mic_abs[12];
		latch11 <= latch11 | mic_abs[11];
		latch10 <= latch10 | mic_abs[10];
		latch9  <= latch9  | mic_abs[9];
		latch8  <= latch8  | mic_abs[8];
		latch7  <= latch7  | mic_abs[7];
		
		count <= count + 1;
		if (count==1200) //recalculate the volume every 1200 samples
		begin
			count <= 0;
			
			
			/*
			if      (latch15) latch <= 15;
			else if (latch14) latch <= 14;
			else if (latch13) latch <= 13;
			else if (latch12) latch <= 12;
			else if (latch11) latch <= 11;
			else if (latch10) latch <= 10;
			else if (latch9)  latch <= 9;
			else if (latch8)  latch <= 8;
			else if (latch7)  latch <= 7;
			else              latch <= 0;
			*/
			
			//determine the volume as the highest threshold level reached by the mic
			if (latch15)      volume <= 10'b0111111111;
			else if (latch14) volume <= 10'b0111111111;
			else if (latch13) volume <= 10'b0111111111;
			else if (latch12) volume <= 10'b0011111111;
			else if (latch11) volume <= 10'b0001111111;
			else if (latch10) volume <= 10'b0000111111;
			else if (latch9)  volume <= 10'b0000011111;
			else if (latch8)  volume <= 10'b0000001111;
			else if (latch7)  volume <= 10'b0000000111;
			else 			  volume <= 10'b0000000000; //if no threshold was crossed then set the volume to zero
			
			
			/*
			if (latch > prevLatch && prevVolume < 10'b0111111111) volume <= (prevVolume << 1) + 1;
			else if (latch < prevLatch && prevLatch < 14) volume <= (prevVolume >> 1);
			else volume <= prevVolume;
			
			prevLatch <= latch;
			prevVolume <= volume;
			*/
			
			//if (prevVolume - volume > 2*volume) volume <= prevVolume;
			
			//clear the latches
			latch15 <= 0;
			latch14 <= 0; 
			latch13 <= 0;
			latch12 <= 0;
			latch11 <= 0;
			latch10 <= 0;
			latch9 <= 0;
			latch8 <= 0;
			latch7 <= 0;
		end
			
		//saved_sine <= sine_out0HarmUp;
		
		
		//sum the pure synthesized sinusoids to get each instrument
		if (~SW[17]&~SW[16]) // Flute
		begin 
			synth_signal <= (sine_out0HarmUp) + (sine_out1HarmUp) + (sine_out2HarmUp>>>1);
		end
		
		else if (~SW[17]&SW[16]) // Voice "AH"
		begin
			synth_signal <= (sine_out0HarmUp>>>0) + (sine_out1HarmUp>>>2) +  (sine_out2HarmUp>>>1) +
					(sine_out3HarmUp>>>1) + (sine_out4HarmUp>>>0) +  (sine_out5HarmUp>>>1) +
					(sine_out6HarmUp>>>2) + (sine_out7HarmUp>>>2) +  (sine_out8HarmUp>>>1) +
					(sine_out9HarmUp>>>2);
		end
		
		else // Ocarina
		begin
			synth_signal <= (sine_out0HarmUp>>>0) +
			(sine_out2HarmUp>>>3) + (sine_out2HarmUp>>>5) + (sine_out2HarmUp>>>7) +
			(sine_out4HarmUp>>>4) + (sine_out4HarmUp>>>6) + (sine_out4HarmUp>>>8);
		end
		
	end
	
	//hook up the ROM table
	sync_rom cosTable(CLOCK_50, DDS_accum0HarmUp[31:24]+8'h40, cos_out);
	
	//synthesize the pure sinusoids from the accumulators
	sync_rom sineTable0HarmUp(CLOCK_50, DDS_accum0HarmUp[31:24], sine_out0HarmUp);
	sync_rom sineTable1HarmUp(CLOCK_50, DDS_accum1HarmUp[31:24], sine_out1HarmUp);
	sync_rom sineTable2HarmUp(CLOCK_50, DDS_accum2HarmUp[31:24], sine_out2HarmUp);
	sync_rom sineTable3HarmUp(CLOCK_50, DDS_accum3HarmUp[31:24], sine_out3HarmUp);
	sync_rom sineTable4HarmUp(CLOCK_50, DDS_accum4HarmUp[31:24], sine_out4HarmUp);
	sync_rom sineTable5HarmUp(CLOCK_50, DDS_accum5HarmUp[31:24], sine_out5HarmUp);
	sync_rom sineTable6HarmUp(CLOCK_50, DDS_accum6HarmUp[31:24], sine_out6HarmUp);
	sync_rom sineTable7HarmUp(CLOCK_50, DDS_accum7HarmUp[31:24], sine_out7HarmUp);
	sync_rom sineTable8HarmUp(CLOCK_50, DDS_accum8HarmUp[31:24], sine_out8HarmUp);
	sync_rom sineTable9HarmUp(CLOCK_50, DDS_accum9HarmUp[31:24], sine_out9HarmUp);
	
	sync_rom sineTable5Hz(CLOCK_50, DDS_accum_5Hz[31:24], sine_out_5Hz); //vibrato
	
	

endmodule //top module

							
/*	
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

*/

///////////////////////////////////////////////
// Infer ROM storage
// for a sin table for the DDS

module sync_rom (clock, address, sine);
	input clock;
	input [7:0] address;
	output [9:0] sine;
	reg [9:0] sine;
	always @ (posedge clock)
	begin
		case (address)
			8'h00: sine = 10'h200 ;
			8'h01: sine = 10'h20c ;
			8'h02: sine = 10'h219 ;
			8'h03: sine = 10'h225 ;
			8'h04: sine = 10'h232 ;
			8'h05: sine = 10'h23e ;
			8'h06: sine = 10'h24a ;
			8'h07: sine = 10'h257 ;
			8'h08: sine = 10'h263 ;
			8'h09: sine = 10'h26f ;
			8'h0a: sine = 10'h27c ;
			8'h0b: sine = 10'h288 ;
			8'h0c: sine = 10'h294 ;
			8'h0d: sine = 10'h2a0 ;
			8'h0e: sine = 10'h2ac ;
			8'h0f: sine = 10'h2b7 ;
			8'h10: sine = 10'h2c3 ;
			8'h11: sine = 10'h2cf ;
			8'h12: sine = 10'h2da ;
			8'h13: sine = 10'h2e5 ;
			8'h14: sine = 10'h2f0 ;
			8'h15: sine = 10'h2fb ;
			8'h16: sine = 10'h306 ;
			8'h17: sine = 10'h311 ;
			8'h18: sine = 10'h31b ;
			8'h19: sine = 10'h326 ;
			8'h1a: sine = 10'h330 ;
			8'h1b: sine = 10'h33a ;
			8'h1c: sine = 10'h344 ;
			8'h1d: sine = 10'h34d ;
			8'h1e: sine = 10'h357 ;
			8'h1f: sine = 10'h360 ;
			8'h20: sine = 10'h369 ;
			8'h21: sine = 10'h372 ;
			8'h22: sine = 10'h37a ;
			8'h23: sine = 10'h382 ;
			8'h24: sine = 10'h38b ;
			8'h25: sine = 10'h392 ;
			8'h26: sine = 10'h39a ;
			8'h27: sine = 10'h3a1 ;
			8'h28: sine = 10'h3a8 ;
			8'h29: sine = 10'h3af ;
			8'h2a: sine = 10'h3b6 ;
			8'h2b: sine = 10'h3bc ;
			8'h2c: sine = 10'h3c2 ;
			8'h2d: sine = 10'h3c8 ;
			8'h2e: sine = 10'h3cd ;
			8'h2f: sine = 10'h3d3 ;
			8'h30: sine = 10'h3d8 ;
			8'h31: sine = 10'h3dc ;
			8'h32: sine = 10'h3e1 ;
			8'h33: sine = 10'h3e5 ;
			8'h34: sine = 10'h3e8 ;
			8'h35: sine = 10'h3ec ;
			8'h36: sine = 10'h3ef ;
			8'h37: sine = 10'h3f2 ;
			8'h38: sine = 10'h3f5 ;
			8'h39: sine = 10'h3f7 ;
			8'h3a: sine = 10'h3f9 ;
			8'h3b: sine = 10'h3fb ;
			8'h3c: sine = 10'h3fc ;
			8'h3d: sine = 10'h3fd ;
			8'h3e: sine = 10'h3fe ;
			8'h3f: sine = 10'h3fe ;
			8'h40: sine = 10'h3ff ;
			8'h41: sine = 10'h3fe ;
			8'h42: sine = 10'h3fe ;
			8'h43: sine = 10'h3fd ;
			8'h44: sine = 10'h3fc ;
			8'h45: sine = 10'h3fb ;
			8'h46: sine = 10'h3f9 ;
			8'h47: sine = 10'h3f7 ;
			8'h48: sine = 10'h3f5 ;
			8'h49: sine = 10'h3f2 ;
			8'h4a: sine = 10'h3ef ;
			8'h4b: sine = 10'h3ec ;
			8'h4c: sine = 10'h3e8 ;
			8'h4d: sine = 10'h3e5 ;
			8'h4e: sine = 10'h3e1 ;
			8'h4f: sine = 10'h3dc ;
			8'h50: sine = 10'h3d8 ;
			8'h51: sine = 10'h3d3 ;
			8'h52: sine = 10'h3cd ;
			8'h53: sine = 10'h3c8 ;
			8'h54: sine = 10'h3c2 ;
			8'h55: sine = 10'h3bc ;
			8'h56: sine = 10'h3b6 ;
			8'h57: sine = 10'h3af ;
			8'h58: sine = 10'h3a8 ;
			8'h59: sine = 10'h3a1 ;
			8'h5a: sine = 10'h39a ;
			8'h5b: sine = 10'h392 ;
			8'h5c: sine = 10'h38b ;
			8'h5d: sine = 10'h382 ;
			8'h5e: sine = 10'h37a ;
			8'h5f: sine = 10'h372 ;
			8'h60: sine = 10'h369 ;
			8'h61: sine = 10'h360 ;
			8'h62: sine = 10'h357 ;
			8'h63: sine = 10'h34d ;
			8'h64: sine = 10'h344 ;
			8'h65: sine = 10'h33a ;
			8'h66: sine = 10'h330 ;
			8'h67: sine = 10'h326 ;
			8'h68: sine = 10'h31b ;
			8'h69: sine = 10'h311 ;
			8'h6a: sine = 10'h306 ;
			8'h6b: sine = 10'h2fb ;
			8'h6c: sine = 10'h2f0 ;
			8'h6d: sine = 10'h2e5 ;
			8'h6e: sine = 10'h2da ;
			8'h6f: sine = 10'h2cf ;
			8'h70: sine = 10'h2c3 ;
			8'h71: sine = 10'h2b7 ;
			8'h72: sine = 10'h2ac ;
			8'h73: sine = 10'h2a0 ;
			8'h74: sine = 10'h294 ;
			8'h75: sine = 10'h288 ;
			8'h76: sine = 10'h27c ;
			8'h77: sine = 10'h26f ;
			8'h78: sine = 10'h263 ;
			8'h79: sine = 10'h257 ;
			8'h7a: sine = 10'h24a ;
			8'h7b: sine = 10'h23e ;
			8'h7c: sine = 10'h232 ;
			8'h7d: sine = 10'h225 ;
			8'h7e: sine = 10'h219 ;
			8'h7f: sine = 10'h20c ;
			8'h80: sine = 10'h200 ;
			8'h81: sine = 10'h1f3 ;
			8'h82: sine = 10'h1e6 ;
			8'h83: sine = 10'h1da ;
			8'h84: sine = 10'h1cd ;
			8'h85: sine = 10'h1c1 ;
			8'h86: sine = 10'h1b5 ;
			8'h87: sine = 10'h1a8 ;
			8'h88: sine = 10'h19c ;
			8'h89: sine = 10'h190 ;
			8'h8a: sine = 10'h183 ;
			8'h8b: sine = 10'h177 ;
			8'h8c: sine = 10'h16b ;
			8'h8d: sine = 10'h15f ;
			8'h8e: sine = 10'h153 ;
			8'h8f: sine = 10'h148 ;
			8'h90: sine = 10'h13c ;
			8'h91: sine = 10'h130 ;
			8'h92: sine = 10'h125 ;
			8'h93: sine = 10'h11a ;
			8'h94: sine = 10'h10f ;
			8'h95: sine = 10'h104 ;
			8'h96: sine = 10'h0f9 ;
			8'h97: sine = 10'h0ee ;
			8'h98: sine = 10'h0e4 ;
			8'h99: sine = 10'h0d9 ;
			8'h9a: sine = 10'h0cf ;
			8'h9b: sine = 10'h0c5 ;
			8'h9c: sine = 10'h0bb ;
			8'h9d: sine = 10'h0b2 ;
			8'h9e: sine = 10'h0a8 ;
			8'h9f: sine = 10'h09f ;
			8'ha0: sine = 10'h096 ;
			8'ha1: sine = 10'h08d ;
			8'ha2: sine = 10'h085 ;
			8'ha3: sine = 10'h07d ;
			8'ha4: sine = 10'h074 ;
			8'ha5: sine = 10'h06d ;
			8'ha6: sine = 10'h065 ;
			8'ha7: sine = 10'h05e ;
			8'ha8: sine = 10'h057 ;
			8'ha9: sine = 10'h050 ;
			8'haa: sine = 10'h049 ;
			8'hab: sine = 10'h043 ;
			8'hac: sine = 10'h03d ;
			8'had: sine = 10'h037 ;
			8'hae: sine = 10'h032 ;
			8'haf: sine = 10'h02c ;
			8'hb0: sine = 10'h027 ;
			8'hb1: sine = 10'h023 ;
			8'hb2: sine = 10'h01e ;
			8'hb3: sine = 10'h01a ;
			8'hb4: sine = 10'h017 ;
			8'hb5: sine = 10'h013 ;
			8'hb6: sine = 10'h010 ;
			8'hb7: sine = 10'h00d ;
			8'hb8: sine = 10'h00a ;
			8'hb9: sine = 10'h008 ;
			8'hba: sine = 10'h006 ;
			8'hbb: sine = 10'h004 ;
			8'hbc: sine = 10'h003 ;
			8'hbd: sine = 10'h002 ;
			8'hbe: sine = 10'h001 ;
			8'hbf: sine = 10'h001 ;
			8'hc0: sine = 10'h001 ;
			8'hc1: sine = 10'h001 ;
			8'hc2: sine = 10'h001 ;
			8'hc3: sine = 10'h002 ;
			8'hc4: sine = 10'h003 ;
			8'hc5: sine = 10'h004 ;
			8'hc6: sine = 10'h006 ;
			8'hc7: sine = 10'h008 ;
			8'hc8: sine = 10'h00a ;
			8'hc9: sine = 10'h00d ;
			8'hca: sine = 10'h010 ;
			8'hcb: sine = 10'h013 ;
			8'hcc: sine = 10'h017 ;
			8'hcd: sine = 10'h01a ;
			8'hce: sine = 10'h01e ;
			8'hcf: sine = 10'h023 ;
			8'hd0: sine = 10'h027 ;
			8'hd1: sine = 10'h02c ;
			8'hd2: sine = 10'h032 ;
			8'hd3: sine = 10'h037 ;
			8'hd4: sine = 10'h03d ;
			8'hd5: sine = 10'h043 ;
			8'hd6: sine = 10'h049 ;
			8'hd7: sine = 10'h050 ;
			8'hd8: sine = 10'h057 ;
			8'hd9: sine = 10'h05e ;
			8'hda: sine = 10'h065 ;
			8'hdb: sine = 10'h06d ;
			8'hdc: sine = 10'h074 ;
			8'hdd: sine = 10'h07d ;
			8'hde: sine = 10'h085 ;
			8'hdf: sine = 10'h08d ;
			8'he0: sine = 10'h096 ;
			8'he1: sine = 10'h09f ;
			8'he2: sine = 10'h0a8 ;
			8'he3: sine = 10'h0b2 ;
			8'he4: sine = 10'h0bb ;
			8'he5: sine = 10'h0c5 ;
			8'he6: sine = 10'h0cf ;
			8'he7: sine = 10'h0d9 ;
			8'he8: sine = 10'h0e4 ;
			8'he9: sine = 10'h0ee ;
			8'hea: sine = 10'h0f9 ;
			8'heb: sine = 10'h104 ;
			8'hec: sine = 10'h10f ;
			8'hed: sine = 10'h11a ;
			8'hee: sine = 10'h125 ;
			8'hef: sine = 10'h130 ;
			8'hf0: sine = 10'h13c ;
			8'hf1: sine = 10'h148 ;
			8'hf2: sine = 10'h153 ;
			8'hf3: sine = 10'h15f ;
			8'hf4: sine = 10'h16b ;
			8'hf5: sine = 10'h177 ;
			8'hf6: sine = 10'h183 ;
			8'hf7: sine = 10'h190 ;
			8'hf8: sine = 10'h19c ;
			8'hf9: sine = 10'h1a8 ;
			8'hfa: sine = 10'h1b5 ;
			8'hfb: sine = 10'h1c1 ;
			8'hfc: sine = 10'h1cd ;
			8'hfd: sine = 10'h1da ;
			8'hfe: sine = 10'h1e6 ;
			8'hff: sine = 10'h1f3 ;
		endcase
	end
endmodule						
	