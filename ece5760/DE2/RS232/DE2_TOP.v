///////////////////////////////////////////////////////////////////////////
//
// Serial transmitter test code
// Bruce Land, Cornell University 2010
//
// Serial transmit module written by James Du (jsd46) and Peter Greczner (pag42)
// for their final project in ECE 5760, cornell university, 2009
// http://instruct1.cit.cornell.edu/courses/ece576/FinalProjects/f2009/jsd46_pag42/jsd46_pag42/
//
//
////////////////////////////////////////////////////////////////////////////

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
   //assign UART_TXD = 1'b0;
	
	/////////////////////////////////////////////////////////////
	// reset define
	wire reset ;
	assign reset = ~KEY[0] ;
	
	////////////////////////////////////////////////////////////
	// characters to send
	// generate a new character at a settable rate
	// from the printable characters
	//
	reg [7:0] data ; 
	wire data_out ; // copy of UART_TXD to send to GPIO connector
	reg sendNew ; // flag to UART that data is ready
	// data_rate MUST be lower than max supported at a given baud rate
	//10000 at 115200 baud ; 3500 at 38400 baud ; 
	parameter data_rate = 20 ; // bytes per second
	parameter data_rate_set =  50000000/data_rate ; // assumes clock rate of 50e6
	reg [31:0] data_rate_counter ;
	// this example just cycles thru the printable characters:
	parameter first_char = 8'd48 ; // '0'
	parameter last_char = 8'd122 ; // 'z'
	
	// the data rate generator:
	always @(posedge CLOCK_50)
	begin
		if (reset) 
		begin
			data <= first_char ;
			sendNew <= 0 ;
		end
		
		// set the rate at which bytes are sent:
		// NOTE that there is NO check to see if
		// UART is done, so don't go too fast
		if (data_rate_counter == data_rate_set) 
		begin
			data_rate_counter <= 32'd0 ;
			// and send some changing data
			sendNew <= 1 ; // one cycle data strobe
			// cycle thru all characters
			if (data > last_char) data <= first_char ;
			else data <= data + 8'd1 ;
		end
		else 
		begin
			data_rate_counter <= data_rate_counter + 1 ;
			sendNew <= 0 ; // clear data strobe
		end
	end
	
	//output to scope and uart transmit pin
	assign GPIO_0[1] = data_out ;
	assign UART_TXD = data_out ;
	
	/////////////////////////////////////////////////////////////
	// baud clock
	//
	reg baud_clock ;
	reg [31:0] baud_counter ;
	// uart works at 115200, 38400, 9600 baud ;
	parameter baud_rate = 115200 ; // 38400 ; //9600 ;
	parameter baud_set = (50000000/(2*baud_rate)) - 1 ; // assumes clock rate of 50e6
	
	// baud clock generator
	always @(posedge CLOCK_50)
	begin
		if (reset) baud_counter <= 32'd0 ;
		if (baud_counter == baud_set) 
		begin
			baud_counter <= 32'd0 ;
			baud_clock <= ~baud_clock ;
		end
		else baud_counter <= baud_counter + 1 ;
	end
	// testing ooutput
	assign GPIO_0[0] = baud_clock ;
	
	// interface to uart module
	
	SerialTransmitter_improved uart(
		.CLOCK_50(CLOCK_50), 	// input 50MHz clock
		.UART_TXD(data_out), 	// output external serial transmitter line
		.toTransmit(data), 		// input Byte to transmit
		.reset(reset) , 			// input reset signal
	//output dataSent_out, 		// output was the data sent completely?
		.sendNew(sendNew), 		// input should we send the new data?
	//output idle, //are we currently in idle transmit mode?
	//output [7:0] lastTransmit, //the last byte transmitted
		.baud_clock(baud_clock) 	// input the baud clock
	);
   
endmodule

//////////////////////////////////////////////////////////////////////////
//
// Serial module written by James Du (jsd46) and Peter Greczner (pag42)
// for their final project in ECE 5760, cornell university, 2009
// http://instruct1.cit.cornell.edu/courses/ece576/FinalProjects/f2009/jsd46_pag42/jsd46_pag42/
//
//////////////////////////////////////////////////////////////////////////
module SerialTransmitter_improved( 
	input CLOCK_50, //50MHz clock
	output  UART_TXD, //Serial transmitter
	input [7:0] toTransmit, //Byte to transmit
	input reset, //reset signal
	output dataSent_out, //was the data sent completely?
	input sendNew, //should we send the new data?
	output idle, //are we currently in idle transmit mode?
	output [7:0] lastTransmit, //the last byte transmitted
	input baud_clock //the baud clock
	);
	
	reg [7:0] txd, last_txd; //transmitted byte registers
	reg [3:0] currBit; //current bit of byte to transmit
	reg [3:0] transmitState;  //the transmit state
	
	parameter [3:0] idleWait = 4'd0, //transmit is idel
					sendStartBit = 4'd1, //sending start bit
					sendData = 4'd2, //sending 8 bits of data
					sendStopBit = 4'd3; //sending stop bit
					
	reg dataSent; //was the data sent?
	reg txd_out; //the current bit being send over UART
	reg should_send; //should we now start a transfer
	reg begin_bit ; // rising edge of baud clock waveform
	
	assign idle = (transmitState == idleWait) ? 1'b1 : 1'b0;
	assign UART_TXD = txd_out;
	assign dataSent_out = dataSent;
	assign lastTransmit = last_txd;
	
	always @(posedge CLOCK_50)
	begin
		//if we got a send request and we are currently idle, then begin send
		if(sendNew & (transmitState == idleWait)) begin
			dataSent <= 0;
			should_send <= 1'b1;
		end
		
		//reset all important variables
		if(reset) begin
			transmitState <= idleWait;
			dataSent <= 0;
			currBit <= 0;
			txd <= 0;
			txd_out <= 1;
			should_send <= 0;
			begin_bit <= 0 ; 
		end
		
		else begin // not reset
			if (baud_clock & begin_bit) //if a baud tick has occured and this is the rising edge
			begin
				// only do state machine on rising edge of baud clock
				// then reset begin_bit flag to note that rising edge has already occured
				begin_bit <= 0 ; 
				
				case(transmitState)
					idleWait: begin
						txd_out <= 1'b1; // idle level
						if(should_send) begin 
							txd <= toTransmit;
							last_txd <= toTransmit;
							transmitState <= sendStartBit; //begin transfer by entering send start bit state
							dataSent <= 0;
							should_send <= 0;
						end
					end
					
					//send the start bit
					sendStartBit: begin
						txd_out <= 1'b0; //the start bit
						transmitState <= sendData;
						currBit <= 4'd0; //reset the current data indice bit
					end
					
					//send all 8 bits of data
					sendData: begin
						txd_out <= txd[currBit];
						currBit <= currBit + 4'd1;
						//if all data was sent then enter the send stop bit state
						if(currBit == 4'd7) begin 
							transmitState <= sendStopBit;
						end
					end
					
					//send the stop bit
					sendStopBit: begin
						txd_out <= 1'b1;
						dataSent <= 1;
						transmitState <= idleWait;
					end	
					
				endcase
				
			end // if (baud_clock & begin_bit)	
			
			// interlock so state machine only goes once/baud_clock
			// on the rising edge of baud clock waveform
			else if (~baud_clock & ~begin_bit)
			begin
				begin_bit <= 1 ; // 
			end
		end
	end
endmodule