// --------------------------------------------------------------------
// ECE 5760 final project
// spw54 and as986
//
// NTSC to VGA modules are from the DE2_TV demo
// (excluded in this file for IP reasons)
// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
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
  input         TD_CLK,      // TV Decoder Line Locked Clock
  // GPIO
  input   [35:0] GPIO_0,      // GPIO Connection 0
  output  [35:0] GPIO_1       // GPIO Connection 1
);

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

//Disable all other peripherals.
assign IRDA_TXD = 1'b0;
assign TDO = 1'b0;
assign UART_TXD = 1'b0;

//////////////////////////
// start DE2_TV example //
//////////////////////////

// Example from DE2 CD
// Omited for IP reasons

//////////////////////////
// end DE2_TV example ////
//////////////////////////

wire reset   = ~KEY[0];
// wire button1 = ~KEY[3];
// wire button2 = ~KEY[2];
wire button1 = ~GPIO_0[34];
wire button2 = ~GPIO_0[35];

wire [29:0] STATUS1 = ((effect2 == 0) && effect2_en) || SW[17] ? RGB1 : pixels1;
wire [29:0] pixels1;
wire [2:0] effect1;
wire effect1_en;
icons icons_1 (
    .reset(reset),
    .clk(VGA_CLK),
    .button(button1),
    .x(VGA_X),
    .y(VGA_Y),
    .pixel_0(pixel_0),
    .pixel_1(pixel_1),
    .pixel_2(pixel_2),
    .pixel_3(pixel_3),
    .pixel_4(pixel_4),
    .pixel_5(pixel_5),
    .pixel_6(pixel_6),
    .pixel_7(pixel_7),
    .effect(effect2),
    .effect_en(effect2_en),
    .rom_addr_0(rom_addr_0_1),
    .rom_addr_1(rom_addr_1_1),
    .rom_addr_2(rom_addr_2_1),
    .rom_addr_3(rom_addr_3_1),
    .rom_addr_4(rom_addr_4_1),
    .rom_addr_5(rom_addr_5_1),
    .rom_addr_6(rom_addr_6_1),
    .rom_addr_7(rom_addr_7_1),
    .pixel(pixels1)
  );
  
wire [29:0] STATUS2 = ((effect1 == 0) && effect1_en) || SW[17] ? RGB2 : pixels2;
wire [29:0] pixels2;
wire [2:0] effect2;
wire effect2_en;
icons icons_2 (
    .reset(reset),
    .clk(VGA_CLK),
    .button(button2),
    .x(VGA_X),
    .y(VGA_Y + 2 * (350 - 243) + 32),
    .pixel_0(pixel_0),
    .pixel_1(pixel_1),
    .pixel_2(pixel_2),
    .pixel_3(pixel_3),
    .pixel_4(pixel_4),
    .pixel_5(pixel_5),
    .pixel_6(pixel_6),
    .pixel_7(pixel_7),
    .effect(effect1),
    .effect_en(effect1_en),
    .rom_addr_0(rom_addr_0_2),
    .rom_addr_1(rom_addr_1_2),
    .rom_addr_2(rom_addr_2_2),
    .rom_addr_3(rom_addr_3_2),
    .rom_addr_4(rom_addr_4_2),
    .rom_addr_5(rom_addr_5_2),
    .rom_addr_6(rom_addr_6_2),
    .rom_addr_7(rom_addr_7_2),
    .pixel(pixels2)
  );
  
wire [9:0] rom_addr_0_1, rom_addr_0_2;
wire [9:0] rom_addr_0 = VGA_Y > 243 ? rom_addr_0_1 : rom_addr_0_2;
wire [23:0] pixel_0;
rom_64x64 rom0 (
    .address(rom_addr_0),
    .clock(VGA_CLK),
    .q(pixel_0)
  );
  defparam rom0.init_file = "icon0.mif";

wire [9:0] rom_addr_1_1, rom_addr_1_2;
wire [9:0] rom_addr_1 = VGA_Y > 243 ? rom_addr_1_1 : rom_addr_1_2;
wire [23:0] pixel_1;
rom_64x64 rom1 (
    .address(rom_addr_1),
    .clock(VGA_CLK),
    .q(pixel_1)
  );
  defparam rom1.init_file = "icon1.mif";

wire [9:0] rom_addr_2_1, rom_addr_2_2;
wire [9:0] rom_addr_2 = VGA_Y > 243 ? rom_addr_2_1 : rom_addr_2_2;
wire [23:0] pixel_2;
rom_64x64 rom2 (
    .address(rom_addr_2),
    .clock(VGA_CLK),
    .q(pixel_2)
  );
  defparam rom2.init_file = "icon2.mif";

wire [9:0] rom_addr_3_1, rom_addr_3_2;
wire [9:0] rom_addr_3 = VGA_Y > 243 ? rom_addr_3_1 : rom_addr_3_2;
wire [23:0] pixel_3;
rom_64x64 rom3 (
    .address(rom_addr_3),
    .clock(VGA_CLK),
    .q(pixel_3)
  );
  defparam rom3.init_file = "icon3.mif";

wire [9:0] rom_addr_4_1, rom_addr_4_2;
wire [9:0] rom_addr_4 = VGA_Y > 243 ? rom_addr_4_1 : rom_addr_4_2;
wire [23:0] pixel_4;
rom_64x64 rom4 (
    .address(rom_addr_4),
    .clock(VGA_CLK),
    .q(pixel_4)
  );
  defparam rom4.init_file = "icon4.mif";

wire [9:0] rom_addr_5_1, rom_addr_5_2;
wire [9:0] rom_addr_5 = VGA_Y > 243 ? rom_addr_5_1 : rom_addr_5_2;
wire [23:0] pixel_5;
rom_64x64 rom5 (
    .address(rom_addr_5),
    .clock(VGA_CLK),
    .q(pixel_5)
  );
  defparam rom5.init_file = "icon5.mif";
  
wire [9:0] rom_addr_6_1, rom_addr_6_2;
wire [9:0] rom_addr_6 = VGA_Y > 243 ? rom_addr_6_1 : rom_addr_6_2;
wire [23:0] pixel_6;
rom_64x64 rom6 (
    .address(rom_addr_6),
    .clock(VGA_CLK),
    .q(pixel_6)
  );
  defparam rom6.init_file = "icon6.mif";
  
wire [9:0] rom_addr_7_1, rom_addr_7_2;
wire [9:0] rom_addr_7 = VGA_Y > 243 ? rom_addr_7_1 : rom_addr_7_2;
wire [23:0] pixel_7;
rom_64x64 rom7 (
    .address(rom_addr_7),
    .clock(VGA_CLK),
    .q(pixel_7)
  );
  defparam rom7.init_file = "icon7.mif";
  
wire VGA_HS_, VGA_VS_, VGA_SYNC_, VGA_BLANK_;
wire [9:0] VGA_R_, VGA_G_, VGA_B_;

wire [33:0] VGA_ = {VGA_HS_, VGA_VS_, VGA_SYNC_, VGA_BLANK_, VGA_R_, VGA_G_, VGA_B_};
wire [33:0] tap1, tap2, tap3, tap4, tap5, tap6, tap7, tap8;

ram_shift buffer (
    .aclr(!VGA_VS_),
    .clock(VGA_CLK && buf_shift_en),
    .shiftin(VGA_),
    .shiftout(),
    .taps({tap8, tap7, tap6, tap5, tap4, tap3, tap2, tap1})
  );
  
reg buf_shift_en;
reg [9:0] pixel_count;
always @ (posedge VGA_CLK)
begin
  if (KEY[0] && VGA_BLANK)
  begin
    if (pixel_count > 639)
      buf_shift_en <= 0;
    else
      buf_shift_en <= 1;
    pixel_count  <= pixel_count + 1;
  end
  else
  begin
    buf_shift_en <= 0;
    pixel_count  <= 0;
  end
end

delay d0 (VGA_HS_, VGA_CLK, VGA_HS);
delay d1 (VGA_VS_, VGA_CLK, VGA_VS);
delay d2 (VGA_SYNC_, VGA_CLK, VGA_SYNC);
delay d3 (VGA_BLANK_, VGA_CLK, VGA_BLANK);

wire [9:0] VGA_R1 = VGA_Y > 243 ? STATUS1[29:20] : RGB1[29:20];
wire [9:0] VGA_G1 = VGA_Y > 243 ? STATUS1[19:10] : RGB1[19:10];
wire [9:0] VGA_B1 = VGA_Y > 243 ? STATUS1[9:0]   : RGB1[9:0];

wire [9:0] VGA_R2 = VGA_Y > 243 ? RGB2[29:20] : STATUS2[29:20];
wire [9:0] VGA_G2 = VGA_Y > 243 ? RGB2[19:10] : STATUS2[19:10];
wire [9:0] VGA_B2 = VGA_Y > 243 ? RGB2[9:0]   : STATUS2[9:0];

// assign VGA_R = KEY[2] ? VGA_R1 : VGA_R2;
// assign VGA_G = KEY[2] ? VGA_G1 : VGA_G2;
// assign VGA_B = KEY[2] ? VGA_B1 : VGA_B2;
assign VGA_R = VGA_R1;
assign VGA_G = VGA_G1;
assign VGA_B = VGA_B1;

assign GPIO_1 = { VGA_CLK, VGA_BLANK, VGA_SYNC, VGA_HS, VGA_VS,
                  VGA_R2, VGA_G2, VGA_B2 };

reg [29:0] x00, x01, x02, x03, x04, x05, x06, x07, x08,
           x10, x11, x12, x13, x14, x15, x16, x17, x18,
           x20, x21, x22, x23, x24, x25, x26, x27, x28,
           x30, x31, x32, x33, x34, x35, x36, x37, x38,
           x40, x41, x42, x43, x44, x45, x46, x47, x48,
           x50, x51, x52, x53, x54, x55, x56, x57, x58;
           // x60, x61, x62, x63, x64, x65, x66, x67, x68,
           // x70, x71, x72, x73, x74, x75, x76, x77, x78;
           
always @ (posedge VGA_CLK)
begin
  x00 <= x01;
  x01 <= x02;
  x02 <= x03;
  x03 <= x04;
  x04 <= x05;
  x05 <= x06;
  x06 <= x07;
  x07 <= x08;
  x08 <= VGA_[29:0];
  x10 <= x11;
  x11 <= x12;
  x12 <= x13;
  x13 <= x14;
  x14 <= x15;
  x15 <= x16;
  x16 <= x17;
  x17 <= x18;
  x18 <= tap1[29:0];
  x20 <= x21;
  x21 <= x22;
  x22 <= x23;
  x23 <= x24;
  x24 <= x25;
  x25 <= x26;
  x26 <= x27;
  x27 <= x28;
  x28 <= tap2[29:0];
  x30 <= x31;
  x31 <= x32;
  x32 <= x33;
  x33 <= x34;
  x34 <= x35;
  x35 <= x36;
  x36 <= x37;
  x37 <= x38;
  x38 <= tap3[29:0];
  x40 <= x41;
  x41 <= x42;
  x42 <= x43;
  x43 <= x44;
  x44 <= x45;
  x45 <= x46;
  x46 <= x47;
  x47 <= x48;
  x48 <= tap4[29:0];
  x50 <= x51;
  x51 <= x52;
  x52 <= x53;
  x53 <= x54;
  x54 <= x55;
  x55 <= x56;
  x56 <= x57;
  x57 <= x58;
  x58 <= tap5[29:0];
  // x60 <= x61;
  // x61 <= x62;
  // x62 <= x63;
  // x63 <= x64;
  // x64 <= x65;
  // x65 <= x66;
  // x66 <= x67;
  // x67 <= x68;
  // x68 <= tap6[29:0];
  // x70 <= x71;
  // x71 <= x72;
  // x72 <= x73;
  // x73 <= x74;
  // x74 <= x75;
  // x75 <= x76;
  // x76 <= x77;
  // x77 <= x78;
  // x78 <= tap7[29:0];
end

reg [29:0] RGB1, RGB2;
wire [29:0] p0, p1, p2, p3, p4, p5, p6;

always @ (*)
begin
  if (effect1_en)
  begin
    case (effect1)
      3'b001: RGB1 = p0;
      3'b010: RGB1 = p1;
      3'b011: RGB1 = p2;
      3'b100: RGB1 = p3;
      3'b101: RGB1 = p4;
      3'b110: RGB1 = p5;
      3'b111: RGB1 = p6;
      default: RGB1 = x44;
    endcase
  end
  else RGB1 = x44;
end
always @ (*)
begin
  if (effect2_en)
  begin
    case (effect2)
      3'b001: RGB2 = p0;
      3'b010: RGB2 = p1;
      3'b011: RGB2 = p2;
      3'b100: RGB2 = p3;
      3'b101: RGB2 = p4;
      3'b110: RGB2 = p5;
      3'b111: RGB2 = p6;
      default: RGB2 = x44;
    endcase
  end
  else RGB2 = x44;
end

blur e0 (
    .x00(x00), .x01(x01), .x02(x02), .x03(x03), .x04(x04), .x05(x05), .x06(x06), .x07(x07), .x08(x08),
    .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14), .x15(x15), .x16(x16), .x17(x17), .x18(x18),
    .x20(x20), .x21(x21), .x22(x22), .x23(x23), .x24(x24), .x25(x25), .x26(x26), .x27(x27), .x28(x28),
    .x30(x30), .x31(x31), .x32(x32), .x33(x33), .x34(x34), .x35(x35), .x36(x36), .x37(x37), .x38(x38),
    .x40(x40), .x41(x41), .x42(x42), .x43(x43), .x44(x44), .x45(x45), .x46(x46), .x47(x47), .x48(x48),
    .x50(x50), .x51(x51), .x52(x52), .x53(x53), .x54(x54), .x55(x55), .x56(x56), .x57(x57), .x58(x58),
    // .x60(x60), .x61(x61), .x62(x62), .x63(x63), .x64(x64), .x65(x65), .x66(x66), .x67(x67), .x68(x68),
    // .x70(x70), .x71(x71), .x72(x72), .x73(x73), .x74(x74), .x75(x75), .x76(x76), .x77(x77), .x78(x78),
    .p(p0)
  );
  
sobel e1 (
    .clk(VGA_CLK),
    .x00(x33),
    .x01(x34),
    .x02(x35),
    .x10(x43),
    .x11(x44),
    .x12(x45),
    .x20(x53),
    .x21(x54),
    .x22(x55),
    .p(p1)
    // .thres(SW[17:10])
  );
  
edges e2 (
    .clk(VGA_CLK),
    .x00(x33),
    .x01(x34),
    .x02(x35),
    .x10(x43),
    .x11(x44),
    .x12(x45),
    .x20(x53),
    .x21(x54),
    .x22(x55),
    .p(p2)
  );
  
invert e3 (
    .clk(VGA_CLK),
    .x(x44),
    .p(p3)
  );
  
color_flip e4 (
    .clk(VGA_CLK),
    .x(x44),
    .p(p4)
  );
  
strobe e5 (
    .clk(VGA_CLK),
    .new_frame(VGA_VS),
    .x(x44),
    .p(p5)
  );
  
tunnel e6 (
    .clk(VGA_CLK),
    .vga_x(VGA_X),
    .x(x44),
    .p(p6)
  );
  
endmodule
