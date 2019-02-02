`define DEBUG
`include "debug.vh"

`include "image_decode_bmp.vh"

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
   assign LEDR[17:1] = 17'h0;
   assign LEDG[8] = 1'b0;
   assign LEDG[3:1] = 3'h0;
   
   //Set all GPIO to tri-state.
   assign GPIO_0 = 36'hzzzzzzzzz;
   assign GPIO_1 = 36'hzzzzzzzzz;

   //Disable audio codec.
   assign AUD_DACDAT = 1'b0;
   assign AUD_XCK    = 1'b0;

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

   //Disable SD card interface.
   assign SD_DAT = 1'bz;
   assign SD_CLK = 1'b0;

   //Disable all other peripherals.
   assign I2C_SCLK = 1'b0;
   assign IRDA_TXD = 1'b0;
   assign TDO = 1'b0;
   assign UART_TXD = 1'b0;

   wire po_reset;
   power_on_reset por(.clk(CLOCK_50),
                      .reset(po_reset));

   wire global_reset;
   assign global_reset = po_reset | ~KEY[0];

   //Generate SDRAM and CPU clocks.
   `KEEP wire clk_cpu;
   cpu_pll cpu_pll0(.inclk0(CLOCK_50),
                    .c0(clk_cpu),
                    .c1(DRAM_CLK));

   wire              cpu_inst_valid;
   wire [29:0]       cpu_data_in;
   wire              clk_dma;
   `KEEP wire        dma_write;
   `KEEP wire [15:0] dma_data;
   `PRESERVE wire    dma_ready;
   wire              gpu_bp;
   controller cpu0(.clk_0(clk_cpu),
                   .reset_n(1'b1),
                   .in_port_to_the_gpi({6'b0,~KEY[3:2]}),
                   .in_port_to_the_gpu_bp_in(gpu_bp),
                   .out_port_from_the_gpu_data_out({cpu_inst_valid,cpu_data_in}),
                   .out_port_from_the_heartbeat_led(LEDG[0]),
                   //DMA interface.
                   .int__gpu__data_out_from_the_gpu_interface(dma_data),
                   .int__gpu__write_from_the_gpu_interface(dma_write),
                   .int__gpu__clk_from_the_gpu_interface(clk_dma),
                   .gpu__int__ready_to_the_gpu_interface(dma_ready),
                   //SDRAM interface.
                   .zs_addr_from_the_sdram(DRAM_ADDR),
                   .zs_ba_from_the_sdram({DRAM_BA_1,DRAM_BA_0}),
                   .zs_cas_n_from_the_sdram(DRAM_CAS_N),
                   .zs_cke_from_the_sdram(DRAM_CKE),
                   .zs_cs_n_from_the_sdram(DRAM_CS_N),
                   .zs_dq_to_and_from_the_sdram(DRAM_DQ),
                   .zs_dqm_from_the_sdram({DRAM_UDQM, DRAM_LDQM}),
                   .zs_ras_n_from_the_sdram(DRAM_RAS_N),
                   .zs_we_n_from_the_sdram(DRAM_WE_N));

   //Strobe DMA write signal.
   //FIXME Does this work for multi-byte writes?
   `KEEP wire write_from_dma;
   strobe write_strobe(.clk(clk_cpu),
                       .reset(global_reset),
                       .in(dma_write),
                       .out(write_from_dma));

   //Strobe instruction valid signal so instruction is
   //issued only once.
   wire        gpu_inst_valid;
   wire [29:0] gpu_data_in;
   strobe inst_valid_strobe(.clk(clk_cpu),
                            .reset(global_reset),
                            .in(cpu_inst_valid),
                            .out(gpu_inst_valid));
   assign gpu_data_in = cpu_data_in;

   //Create/connect GPU.
   gpu gpu0(.clk_27(CLOCK_27),
            .reset(global_reset),
            //CPU interface.
            .clk_cpu(clk_cpu),
            .cpu_inst_valid(gpu_inst_valid),
            .cpu_data_in(gpu_data_in),
            .cpu_bp(gpu_bp),
            //DMA interface.
            .clk_dma(clk_dma),
            .dma_data_valid(dma_write),
            .dma_ready(dma_ready),
            .dma_data(dma_data),
            //RAM interface.
            .ram_dq(SRAM_DQ),
            .ram_addr(SRAM_ADDR),
            .ram_ub_n(SRAM_UB_N),
            .ram_lb_n(SRAM_LB_N),
            .ram_we_n(SRAM_WE_N),
            //Display interface.
            .clk_disp(VGA_CLK),
            .disp_hs_n(VGA_HS),
            .disp_vs_n(VGA_VS),
            .disp_blank_n(VGA_BLANK),
            .disp_sync(VGA_SYNC),
            .disp_r(VGA_R),
            .disp_g(VGA_G),
            .disp_b(VGA_B),
            //Debug.
            .cmd_active(LEDR[0]),
            .layer_en(SW[0]));
   assign TD_RESET = 1'b1;
   assign SRAM_CE_N = 1'b0;
   assign SRAM_OE_N = 1'b0;

   reg [15:0] data;
   always @(posedge clk_cpu) begin
      data <= global_reset ? 16'd0 :
              dma_write ? dma_data :
              data;
   end

   //Display last executed insruction for debugging.
   reg [29:0] data_buffer;
   always @(posedge clk_cpu) begin
      data_buffer <= global_reset ? 30'h0 :
                     gpu_inst_valid && gpu_data_in!=30'd0 ? gpu_data_in :
                     data_buffer;
   end

   reg [29:0] dma_count;
   always @(posedge clk_dma) begin
      dma_count <= global_reset ? 30'd0 :
                   dma_write ? dma_count+30'd1 :
                   dma_count;
   end

   wire [29:0] disp_sel;
   assign disp_sel = SW[16] ? {14'd0,data} :
                     SW[17] ? dma_count :
                     data_buffer;

   assign LEDG[7:4] = ~KEY;

   hex_driver h7(.value({2'h0,disp_sel[29:28]}),
                 .enable(1'b1),
                 .display(HEX7));
   hex_driver h6(.value(disp_sel[27:24]),
                 .enable(1'b1),
                 .display(HEX6));
   hex_driver h5(.value(disp_sel[23:20]),
                 .enable(1'b1),
                 .display(HEX5));
   hex_driver h4(.value(disp_sel[19:16]),
                 .enable(1'b1),
                 .display(HEX4));
   hex_driver h3(.value(disp_sel[15:12]),
                 .enable(1'b1),
                 .display(HEX3));
   hex_driver h2(.value(disp_sel[11:8]),
                 .enable(1'b1),
                 .display(HEX2));
   hex_driver h1(.value(disp_sel[7:4]),
                 .enable(1'b1),
                 .display(HEX1));
   hex_driver h0(.value(disp_sel[3:0]),
                 .enable(1'b1),
                 .display(HEX0));
   
endmodule