module DE2_TOP 
   (
   // Clock Input
   input      CLOCK_27,    // 27 MHz
   input      CLOCK_50,    // 50 MHz
   input      EXT_CLOCK,   // External Clock
   // Push Button
   input  [3:0]  KEY,         // Pushbutton[3:0]
   // DPDT Switch
   input  [17:0] SW,       // Toggle Switch[17:0]
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
   input      UART_RXD,    // UART Receiver
   // IRDA
   output        IRDA_TXD,    // IRDA Transmitter
   input      IRDA_RXD,    // IRDA Receiver
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
   inout  [7:0]  FL_DQ,    // FLASH Data bus 8 Bits
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
   input      OTG_INT0,    // ISP1362 Interrupt 0
   input      OTG_INT1,    // ISP1362 Interrupt 1
   input      OTG_DREQ0,   // ISP1362 DMA Request 0
   input      OTG_DREQ1,   // ISP1362 DMA Request 1
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
   inout      SD_DAT,      // SD Card Data
   inout      SD_DAT3,     // SD Card Data 3
   inout      SD_CMD,      // SD Card Command Signal
   output        SD_CLK,      // SD Card Clock
   // I2C
   inout      I2C_SDAT,    // I2C Data
   output        I2C_SCLK,    // I2C Clock
   // PS2
   input      PS2_DAT,     // PS2 Data
   input      PS2_CLK,     // PS2 Clock
   // USB JTAG link
   input      TDI,         // CPLD -> FPGA (data in)
   input      TCK,         // CPLD -> FPGA (clk)
   input      TCS,         // CPLD -> FPGA (CS)
   output        TDO,         // FPGA -> CPLD (data out)
   // VGA
   output        VGA_CLK,     // VGA Clock
   output        VGA_HS,      // VGA H_SYNC
   output        VGA_VS,      // VGA V_SYNC
   output        VGA_BLANK,   // VGA BLANK
   output        VGA_SYNC,    // VGA SYNC
   output [9:0]  VGA_R,    // VGA Red[9:0]
   output [9:0]  VGA_G,    // VGA Green[9:0]
   output [9:0]  VGA_B,    // VGA Blue[9:0]
   // Ethernet Interface
   inout  [15:0] ENET_DATA,   // DM9000A DATA bus 16Bits
   output        ENET_CMD,    // DM9000A Command/Data Select, 0 = Command, 1 = Data
   output        ENET_CS_N,   // DM9000A Chip Select
   output        ENET_WR_N,   // DM9000A Write
   output        ENET_RD_N,   // DM9000A Read
   output        ENET_RST_N,  // DM9000A Reset
   input      ENET_INT,    // DM9000A Interrupt
   output        ENET_CLK,    // DM9000A Clock 25 MHz
   // Audio CODEC
   inout      AUD_ADCLRCK, // Audio CODEC ADC LR Clock
   input      AUD_ADCDAT,  // Audio CODEC ADC Data
   inout      AUD_DACLRCK, // Audio CODEC DAC LR Clock
   output        AUD_DACDAT,  // Audio CODEC DAC Data
   inout      AUD_BCLK,    // Audio CODEC Bit-Stream Clock
   output        AUD_XCK,     // Audio CODEC Chip Clock
   // TV Decoder
   input  [7:0]  TD_DATA,     // TV Decoder Data bus 8 bits
   input      TD_HS,    // TV Decoder H_SYNC
   input      TD_VS,    // TV Decoder V_SYNC
   output        TD_RESET,    // TV Decoder Reset
   // GPIO
   inout  [35:0] GPIO_0,      // GPIO Connection 0
   inout  [35:0] GPIO_1    // GPIO Connection 1
   
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
   //assign GPIO_1[35:16] = 20'hzzzzz;
   assign GPIO_1 = 36'hzzzzzzzzz;

   //Disable audio codec.
   assign AUD_DACDAT = 1'b0;
   assign AUD_XCK   = 1'b0;

   //Disable DRAM.
   assign DRAM_ADDR  = 12'h0;
   assign DRAM_BA_0  = 1'b0;
   assign DRAM_BA_1  = 1'b0;
   assign DRAM_CAS_N = 1'b1;
   assign DRAM_CKE     = 1'b0;
   assign DRAM_CLK     = 1'b0;
   assign DRAM_CS_N  = 1'b1;
   assign DRAM_DQ   = 16'hzzzz;
   assign DRAM_LDQM  = 1'b0;
   assign DRAM_RAS_N = 1'b1;
   assign DRAM_UDQM  = 1'b0;
   assign DRAM_WE_N  = 1'b1;

   //Disable flash.
   assign FL_ADDR = 22'h0;
   assign FL_CE_N = 1'b1;
   assign FL_DQ   = 8'hzz;
   assign FL_OE_N = 1'b1;
   assign FL_RST_N = 1'b1;
   assign FL_WE_N = 1'b1;

   //Disable LCD.
   assign LCD_BLON = 1'b0;
   assign LCD_DATA = 8'hzz;
   assign LCD_EN  = 1'b0;
   assign LCD_ON  = 1'b0;
   assign LCD_RS  = 1'b0;
   assign LCD_RW  = 1'b0;

   //Disable OTG.
   assign OTG_ADDR      = 2'h0;
   assign OTG_CS_N      = 1'b1;
   assign OTG_DACK0_N = 1'b1;
   assign OTG_DACK1_N = 1'b1;
   assign OTG_FSPEED  = 1'b1;
   assign OTG_DATA      = 16'hzzzz;
   assign OTG_LSPEED  = 1'b1;
   assign OTG_RD_N      = 1'b1;
   assign OTG_RST_N   = 1'b1;
   assign OTG_WR_N      = 1'b1;

   //Disable SDRAM.
   assign SD_DAT = 1'bz;
   assign SD_CLK = 1'b0;

   //Disable SRAM.
   assign SRAM_ADDR = 18'h0;
   assign SRAM_CE_N = 1'b1;
   assign SRAM_DQ  = 16'hzzzz;
   assign SRAM_LB_N = 1'b1;
   assign SRAM_OE_N = 1'b1;
   assign SRAM_UB_N = 1'b1;
   assign SRAM_WE_N = 1'b1;

   //Disable VGA.
   assign VGA_CLK  = 1'b0;
   assign VGA_BLANK = 1'b0;
   assign VGA_SYNC    = 1'b0;
   assign VGA_HS   = 1'b0;
   assign VGA_VS   = 1'b0;
   assign VGA_R    = 10'h0;
   assign VGA_G    = 10'h0;
   assign VGA_B    = 10'h0;

   //Disable all other peripherals.
   assign I2C_SCLK = 1'b0;
   assign IRDA_TXD = 1'b0;
   assign TD_RESET = 1'b1;
   assign TDO = 1'b0;
   assign UART_TXD = 1'b0;
   
   (*keep*)wire reset;
   (*keep*)wire latch_dc;
   (*keep*)wire zz_rden;
   (*keep*)wire new_stream;
   (*keep*)wire [3:0] vl_size;
   (*keep*)wire [3:0] size_of_fifo;
   (*keep*)wire [7:0] q;
   (*keep*)wire [7:0] vl_code;
   (*keep*)wire [11:0] zz_rdaddress;
   (*keep*)wire [15:0] next_transmit;
   
   reg rreset;
   reg rrreset;
   
   assign reset = ~KEY[0];

   // memory module, emulating the results of the 2-D DCT
   // no write in this system, memory is preloaded with known values
   ram_2port_2 postdct_to_translator(
      // READ
      .rdclock(CLOCK_50), // read clock
      .rden(zz_rden), // read enable from the zig-zag module
      .rdaddress(zz_rdaddress), // read address from the zig-zag module
      .q(q), // value going to the translation module
      // WRITE
      .wrclock(),
      .wren(),
      .wraddress(),
      .data() 
      );
   
   // controls read addresses such that the coefficients are read out in a zig-zag pattern
   zigzag zz(
      .clk(CLOCK_50), // control clock
      .enable(~reset), // enable the module
      .rden(zz_rden), // output: read enable for the memory module
      .rdaddress(zz_rdaddress), // output: read address for the memory module
      .latch_dc(latch_dc) // output: tells the top level to latch the DC coefficient
      );

   // translates the output from the memory module to a variable length code word
   translate_to_vl t2vl(
      .clk(CLOCK_50), // control clock
      //.enable(~reset & rzz_rden), // enable the module
      .enable(~rreset), // enable the module
      .value(q), // input: the value of the pixel being evaluated
      .size(vl_size), // output: size of the coefficient
      .code(vl_code) // output: the translated coefficient
      );

   // handles the bitstream to be transmitted
   bitstream_buffer buffer(
      .clk(CLOCK_50), // control clock
      .enable(~rrreset), // enable the module
      .size(vl_size), // input: the size of the code being translated
      .code(vl_code), // input: the code being translated
      .next_transmit(next_transmit), // output: an output of x-bits
      .new_stream(new_stream), // output: signal indicates a new set of bits to transmit
      .end_of_frame(1'b1) // input: signifies the end of the frame (or image). used to signify when to transmit remaining bits
      );
      
   // fifo to hold values until they are sent through ethernet
   bitstream_fifo fifo(
      .clock(CLOCK_50),
      .sclr(reset), // at system reset, clear the fifo
      .wrreq(new_stream), // when appropriate, write new 16-bit element to fifo
      .data(next_transmit), // data to send from the bitstream buffer
      
      .rdreq(fifo_rd_actual),
      .empty(fifo_empty),
      .full(),
      .q(fifo_data),
      .usedw(size_of_fifo) );
      
   always @(posedge CLOCK_50) begin
      rreset <= reset;
      rrreset <= rreset;
   end
   
   (*preserve*)reg [3:0]      state;
   (*preserve*)reg [15:0]     length;
   reg            taco, bell;
      
   (*keep*)wire         fifo_rd_actual, fifo_empty;
   (*keep*)wire [15:0]     fifo_data;
   (*preserve*)reg            fifo_rd;
   
   assign fifo_rd_actual = fifo_rd & !udp_full;
   
   (*keep*)wire            udp_full, udp_wr;
   (*preserve*)reg [15:0]     udp_data;
   (*preserve*)reg            udp_stop;
   
   assign udp_wr = !udp_full & !udp_stop;
   
   always @ (posedge CLOCK_50) begin
      taco <= !KEY[1];
      bell <= taco;
      
      if (bell) begin
         state <= 4'b0;
         length <= 16'd6;//size_of_fifo;
         
         fifo_rd <= 1'b0;
         
         udp_data <= 16'b0;
         udp_stop <= 1'b1;
      end
      else if (udp_full) begin
         state <= state;
         udp_data <= udp_data;
      end
      else begin
         case (state)
            4'd0: begin
                     state <= 4'd1;
                     
                     udp_data <= length;
                     udp_stop <= 1'b0;
                     fifo_rd <= 1'b1;
                  end
            4'd1: begin
                     state <= (fifo_empty) ? 4'd1 :
                        (length <= 16'd2) ? 4'd2 : 4'd1;
                        
                     fifo_rd <= 1'b1;
                     udp_data <= fifo_data;
                     length <= (fifo_empty) ? length : length - 16'd2;
                  end
            4'd2: begin
                     state <= 4'd2;
                     
                     fifo_rd <= 1'b0;
                     udp_stop <= 1'b1;
                  end
         endcase
      end
   end

   udp_wrapper udp (
      .clk(CLOCK_50),
      .reset(reset),
      
      .enet_clk(ENET_CLK),
      .enet_int(ENET_INT),
      .enet_rst_n(ENET_RST_N),
      .enet_cs_n(ENET_CS_N),
      .enet_cmd(ENET_CMD),
      .enet_wr_n(ENET_WR_N),
      .enet_rd_n(ENET_RD_N),
      .enet_data(ENET_DATA),
      
      .udp_clk(CLOCK_50),
      .udp_wr(udp_wr),
      .udp_data(udp_data),
      .udp_full(udp_full),
      
      .halt(1'b0)
   ); 
   
endmodule
