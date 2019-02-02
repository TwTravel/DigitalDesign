

module DE1_SoC_Computer (
	////////////////////////////////////
	// FPGA Pins
	////////////////////////////////////

	// Clock pins
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,
	CLOCK4_50,

	// ADC
	ADC_CS_N,
	ADC_DIN,
	ADC_DOUT,
	ADC_SCLK,

	// Audio
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	AUD_XCK,

	// SDRAM
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_LDQM,
	DRAM_RAS_N,
	DRAM_UDQM,
	DRAM_WE_N,

	// I2C Bus for Configuration of the Audio and Video-In Chips
	FPGA_I2C_SCLK,
	FPGA_I2C_SDAT,

	// 40-Pin Headers
	GPIO_0,
	GPIO_1,
	
	// Seven Segment Displays
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,

	// IR
	IRDA_RXD,
	IRDA_TXD,

	// Pushbuttons
	KEY,

	// LEDs
	LEDR,

	// PS2 Ports
	PS2_CLK,
	PS2_DAT,
	
	PS2_CLK2,
	PS2_DAT2,

	// Slider Switches
	SW,

	// Video-In
	TD_CLK27,
	TD_DATA,
	TD_HS,
	TD_RESET_N,
	TD_VS,

	// VGA
	VGA_B,
	VGA_BLANK_N,
	VGA_CLK,
	VGA_G,
	VGA_HS,
	VGA_R,
	VGA_SYNC_N,
	VGA_VS,

	////////////////////////////////////
	// HPS Pins
	////////////////////////////////////
	
	// DDR3 SDRAM
	HPS_DDR3_ADDR,
	HPS_DDR3_BA,
	HPS_DDR3_CAS_N,
	HPS_DDR3_CKE,
	HPS_DDR3_CK_N,
	HPS_DDR3_CK_P,
	HPS_DDR3_CS_N,
	HPS_DDR3_DM,
	HPS_DDR3_DQ,
	HPS_DDR3_DQS_N,
	HPS_DDR3_DQS_P,
	HPS_DDR3_ODT,
	HPS_DDR3_RAS_N,
	HPS_DDR3_RESET_N,
	HPS_DDR3_RZQ,
	HPS_DDR3_WE_N,

	// Ethernet
	HPS_ENET_GTX_CLK,
	HPS_ENET_INT_N,
	HPS_ENET_MDC,
	HPS_ENET_MDIO,
	HPS_ENET_RX_CLK,
	HPS_ENET_RX_DATA,
	HPS_ENET_RX_DV,
	HPS_ENET_TX_DATA,
	HPS_ENET_TX_EN,

	// Flash
	HPS_FLASH_DATA,
	HPS_FLASH_DCLK,
	HPS_FLASH_NCSO,

	// Accelerometer
	HPS_GSENSOR_INT,
		
	// General Purpose I/O
	HPS_GPIO,
		
	// I2C
	HPS_I2C_CONTROL,
	HPS_I2C1_SCLK,
	HPS_I2C1_SDAT,
	HPS_I2C2_SCLK,
	HPS_I2C2_SDAT,

	// Pushbutton
	HPS_KEY,

	// LED
	HPS_LED,
		
	// SD Card
	HPS_SD_CLK,
	HPS_SD_CMD,
	HPS_SD_DATA,

	// SPI
	HPS_SPIM_CLK,
	HPS_SPIM_MISO,
	HPS_SPIM_MOSI,
	HPS_SPIM_SS,

	// UART
	HPS_UART_RX,
	HPS_UART_TX,

	// USB
	HPS_CONV_USB_N,
	HPS_USB_CLKOUT,
	HPS_USB_DATA,
	HPS_USB_DIR,
	HPS_USB_NXT,
	HPS_USB_STP
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

////////////////////////////////////
// FPGA Pins
////////////////////////////////////

// Clock pins
input						CLOCK_50;
input						CLOCK2_50;
input						CLOCK3_50;
input						CLOCK4_50;

// ADC
inout						ADC_CS_N;
output					ADC_DIN;
input						ADC_DOUT;
output					ADC_SCLK;

// Audio
input						AUD_ADCDAT;
inout						AUD_ADCLRCK;
inout						AUD_BCLK;
output					AUD_DACDAT;
inout						AUD_DACLRCK;
output					AUD_XCK;

// SDRAM
output 		[12: 0]	DRAM_ADDR;
output		[ 1: 0]	DRAM_BA;
output					DRAM_CAS_N;
output					DRAM_CKE;
output					DRAM_CLK;
output					DRAM_CS_N;
inout			[15: 0]	DRAM_DQ;
output					DRAM_LDQM;
output					DRAM_RAS_N;
output					DRAM_UDQM;
output					DRAM_WE_N;

// I2C Bus for Configuration of the Audio and Video-In Chips
output					FPGA_I2C_SCLK;
inout						FPGA_I2C_SDAT;

// 40-pin headers
inout			[35: 0]	GPIO_0;
inout			[35: 0]	GPIO_1;

// Seven Segment Displays
output		[ 6: 0]	HEX0;
output		[ 6: 0]	HEX1;
output		[ 6: 0]	HEX2;
output		[ 6: 0]	HEX3;
output		[ 6: 0]	HEX4;
output		[ 6: 0]	HEX5;

// IR
input						IRDA_RXD;
output					IRDA_TXD;

// Pushbuttons
input			[ 3: 0]	KEY;

// LEDs
output		[ 9: 0]	LEDR;

// PS2 Ports
inout						PS2_CLK;
inout						PS2_DAT;

inout						PS2_CLK2;
inout						PS2_DAT2;

// Slider Switches
input			[ 9: 0]	SW;

// Video-In
input						TD_CLK27;
input			[ 7: 0]	TD_DATA;
input						TD_HS;
output					TD_RESET_N;
input						TD_VS;

// VGA
output		[ 7: 0]	VGA_B;
output					VGA_BLANK_N;
output					VGA_CLK;
output		[ 7: 0]	VGA_G;
output					VGA_HS;
output		[ 7: 0]	VGA_R;
output					VGA_SYNC_N;
output					VGA_VS;



////////////////////////////////////
// HPS Pins
////////////////////////////////////
	
// DDR3 SDRAM
output		[14: 0]	HPS_DDR3_ADDR;
output		[ 2: 0]  HPS_DDR3_BA;
output					HPS_DDR3_CAS_N;
output					HPS_DDR3_CKE;
output					HPS_DDR3_CK_N;
output					HPS_DDR3_CK_P;
output					HPS_DDR3_CS_N;
output		[ 3: 0]	HPS_DDR3_DM;
inout			[31: 0]	HPS_DDR3_DQ;
inout			[ 3: 0]	HPS_DDR3_DQS_N;
inout			[ 3: 0]	HPS_DDR3_DQS_P;
output					HPS_DDR3_ODT;
output					HPS_DDR3_RAS_N;
output					HPS_DDR3_RESET_N;
input						HPS_DDR3_RZQ;
output					HPS_DDR3_WE_N;

// Ethernet
output					HPS_ENET_GTX_CLK;
inout						HPS_ENET_INT_N;
output					HPS_ENET_MDC;
inout						HPS_ENET_MDIO;
input						HPS_ENET_RX_CLK;
input			[ 3: 0]	HPS_ENET_RX_DATA;
input						HPS_ENET_RX_DV;
output		[ 3: 0]	HPS_ENET_TX_DATA;
output					HPS_ENET_TX_EN;

// Flash
inout			[ 3: 0]	HPS_FLASH_DATA;
output					HPS_FLASH_DCLK;
output					HPS_FLASH_NCSO;

// Accelerometer
inout						HPS_GSENSOR_INT;

// General Purpose I/O
inout			[ 1: 0]	HPS_GPIO;

// I2C
inout						HPS_I2C_CONTROL;
inout						HPS_I2C1_SCLK;
inout						HPS_I2C1_SDAT;
inout						HPS_I2C2_SCLK;
inout						HPS_I2C2_SDAT;

// Pushbutton
inout						HPS_KEY;

// LED
inout						HPS_LED;

// SD Card
output					HPS_SD_CLK;
inout						HPS_SD_CMD;
inout			[ 3: 0]	HPS_SD_DATA;

// SPI
output					HPS_SPIM_CLK;
input						HPS_SPIM_MISO;
output					HPS_SPIM_MOSI;
inout						HPS_SPIM_SS;

// UART
input						HPS_UART_RX;
output					HPS_UART_TX;

// USB
inout						HPS_CONV_USB_N;
input						HPS_USB_CLKOUT;
inout			[ 7: 0]	HPS_USB_DATA;
input						HPS_USB_DIR;
input						HPS_USB_NXT;
output					HPS_USB_STP;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire			[15: 0]	hex3_hex0;
//wire			[15: 0]	hex5_hex4;

//assign HEX0 = ~hex3_hex0[ 6: 0]; // hex3_hex0[ 6: 0]; 
//assign HEX1 = ~hex3_hex0[14: 8];
//assign HEX2 = ~hex3_hex0[22:16];
//assign HEX3 = ~hex3_hex0[30:24];
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;

HexDigit Digit0(HEX0, hex3_hex0[3:0]);
HexDigit Digit1(HEX1, hex3_hex0[7:4]);
HexDigit Digit2(HEX2, hex3_hex0[11:8]);
HexDigit Digit3(HEX3, hex3_hex0[15:12]);

//=======================================================
// SRAM/VGA state machine
//=======================================================
// --Check for sram address=0 nonzero, which means that
//   HPS wrote some new data.
//
// --Read sram address 1 and 2 to get x1, y1 
//   left-most x, upper-most y
// --Read sram address 3 and 4 to get x2, y2
//   right-most x, lower-most y
// --Read sram address 5 to get color
// --write a rectangle to VGA
//
// --clear sram address=0 to signal HPS
//=======================================================
// Controls for Qsys sram slave exported in system module
//=======================================================
wire [31:0] sram_readdata ;
reg [31:0] data_buffer, sram_writedata ;
reg [7:0] sram_address; 
reg sram_write ;
wire sram_clken = 1'b1;
wire sram_chipselect = 1'b1;
reg [7:0] state ;

// rectangle corners
reg [9:0] x1, y1, x2, y2 ;
reg [31:0] timer ; // may need to throttle write-rate
//=======================================================
// Controls for VGA memory
//=======================================================
wire [31:0] vga_out_base_address = 32'h0000_0000 ;  // vga base addr
reg [7:0] vga_sram_writedata ;
reg [31:0] vga_sram_address; 
reg vga_sram_write ;
wire vga_sram_clken = 1'b1;
wire vga_sram_chipselect = 1'b1;

//=======================================================
// pixel address is
reg [9:0] vga_x_cood, vga_y_cood ;
reg [7:0] pixel_color ;

//=======================================================
// do the work outlined above
always @(posedge CLOCK_50) begin // CLOCK_50

   // reset state machine and read/write controls
	if (~KEY[0]) begin
		state <= 0 ;
		vga_sram_write <= 1'b0 ; // set to on if a write operation to bus
		sram_write <= 1'b0 ;
		timer <= 0;
	end
	else begin
		// general purpose tick counter
		timer <= timer + 1;
	end
	
	// --------------------------------------
	// did the HPS send a command
	// --- set up read for HPS data-ready ---
	if (state == 8'd0) begin
		sram_address <= 8'd0 ;
		sram_write <= 1'b0 ;
		state <= 8'd1 ;
	end
	// wait 1 for read
	if (state == 8'd1) begin
		state <= 8'd2 ;
	end
	// do data-read read
	if (state == 8'd2) begin
		data_buffer <= sram_readdata ;
		sram_write <= 1'b0 ;
		state <= 8'd3 ;
	end 
	
	// --------------------------------------
	// --- is there new command? --- 
	if (state == 8'd3) begin
		// if (addr 0)==0 try again
		if (data_buffer==0) state <= 8'd0 ;
		// if nonzero, do the add
		else state <= 8'd4 ;
	end 
	
	// --------------------------------------
	// --- read first Qsys sram: x1 ---
	if (state == 8'd4) begin
		sram_address <= 8'd1 ;
		sram_write <= 1'b0 ;
		state <= 8'd5 ;
	end
	// wait 1
	if (state == 8'd5) begin
		state <= 8'd6 ;
	end
	// do data-read x1 
	if (state == 8'd6) begin
		x1 <= sram_readdata ;
		sram_write <= 1'b0 ;
		state <= 8'd7 ;
	end 
	
	// --------------------------------------
	// --- read second Qsys sram: y1 ---
	if (state == 8'd7) begin
		sram_address <= 8'd2 ;
		sram_write <= 1'b0 ;
		state <= 8'd8 ;
	end
	// wait 1
	if (state == 8'd8) begin
		state <= 8'd9 ;
	end
	// do data-read y1
	if (state == 8'd9) begin
		y1 <= sram_readdata ;
		sram_write <= 1'b0 ;
		state <= 8'd10 ;
	end 
	
	// --------------------------------------
	// --- read third Qsys sram: x2 ---
	if (state == 8'd10) begin
		sram_address <= 8'd3 ;
		sram_write <= 1'b0 ;
		state <= 8'd11 ;
	end
	// wait 1
	if (state == 8'd11) begin
		state <= 8'd12 ;
	end
	// do data-read x2
	if (state == 8'd12) begin
		x2 <= sram_readdata ;
		sram_write <= 1'b0 ;
		state <= 8'd13 ;
	end 
	
	// --------------------------------------
	// --- read fourth Qsys sram: y2 ---
	if (state == 8'd13) begin
		sram_address <= 8'd4 ;
		sram_write <= 1'b0 ;
		state <= 8'd14 ;
	end
	// wait 1
	if (state == 8'd14) begin
		state <= 8'd15 ;
	end
	// do data-read y2
	if (state == 8'd15) begin
		y2 <= sram_readdata ;
		sram_write <= 1'b0 ;
		state <= 8'd16 ;
	end 
	
	// --------------------------------------
	// --- read fifth Qsys sram: color ---
	if (state == 8'd16) begin
		sram_address <= 8'd5 ;
		sram_write <= 1'b0 ;
		state <= 8'd17 ;
	end
	// wait 1
	if (state == 8'd17) begin
		state <= 8'd18 ;
	end
	// do data-read y2
	if (state == 8'd18) begin
		pixel_color <= sram_readdata ;
		sram_write <= 1'b0 ;
		state <= 8'd19 ;
		// initialize pixel state machine
		// for the next phase of the state machine
		vga_x_cood <= x1 ;
		vga_y_cood <= y1 ;
	end 
	

	// --------------------------------------
	// Now have all info, so:
	// write to the VGA sram

	if (state==8'd19) begin // && ((timer & 15)==0)
		vga_sram_write <= 1'b1;
		// compute address
	   vga_sram_address <= vga_out_base_address + {22'b0, vga_x_cood} + ({22'b0,vga_y_cood}*640) ; 
		// data
		vga_sram_writedata <= pixel_color  ;
		// iterate through all x for each y in the list
		if (vga_x_cood < x2) begin
			vga_x_cood <= vga_x_cood + 10'd1 ;
		end
		else begin
			vga_x_cood <= x1 ;
			vga_y_cood <= vga_y_cood + 10'd1 ;	
		end
		if (vga_x_cood>=x2 && vga_y_cood>=y2) state <= 8'd22 ; // ending
		else state  <= 8'd19 ;
		// write a point
		//state <= 8'd20 ; 
	end
	
	// write a pixel to VGA memory
//	if (state==20) begin
//		vga_sram_write <= 1'b1;
//		// vga_sram_address is combinatorial;
//		vga_sram_writedata <= pixel_color  ;
//		// done?
//		if (vga_x_cood>=x2 && vga_y_cood>=y2) state <= 8'd22 ; // ending
//		else state  <= 8'd19 ;
//	end
	
	
	// -- finished: --
	// -- set up done flag to Qsys sram 0 ---
	if (state == 8'd22) begin
		// end vga write
		vga_sram_write <= 1'b0;
		// signal the HPS we are done
		sram_address <= 8'd0 ;
		sram_writedata <= 32'b0 ;
		sram_write <= 1'b1 ;
		state <= 8'd0 ;
	end  
	
end // always @(posedge state_clock)


//=======================================================
//  Structural coding
//=======================================================
// From Qsys

Computer_System The_System (
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////

	// Global signals
	.system_pll_ref_clk_clk					(CLOCK_50),
	.system_pll_ref_reset_reset			(1'b0),
	
	// SRAM shared block with HPS
	.onchip_sram_s1_address               (sram_address),               
	.onchip_sram_s1_clken                 (sram_clken),                 
	.onchip_sram_s1_chipselect            (sram_chipselect),            
	.onchip_sram_s1_write                 (sram_write),                 
	.onchip_sram_s1_readdata              (sram_readdata),              
	.onchip_sram_s1_writedata             (sram_writedata),             
	.onchip_sram_s1_byteenable            (4'b1111), 
	
	//  sram to video
	.onchip_vga_buffer_s1_address    (vga_sram_address),    
	.onchip_vga_buffer_s1_clken      (vga_sram_clken),      
	.onchip_vga_buffer_s1_chipselect (vga_sram_chipselect), 
	.onchip_vga_buffer_s1_write      (vga_sram_write),      
	.onchip_vga_buffer_s1_readdata   (),   // never read from vga here
	.onchip_vga_buffer_s1_writedata  (vga_sram_writedata),   

	// AV Config
	.av_config_SCLK							(FPGA_I2C_SCLK),
	.av_config_SDAT							(FPGA_I2C_SDAT),

	// 50 MHz clock bridge
	.clock_bridge_0_in_clk_clk            (CLOCK_50), //(CLOCK_50), 
	
	// VGA Subsystem
	.vga_pll_ref_clk_clk 					(CLOCK2_50),
	.vga_pll_ref_reset_reset				(1'b0),
	.vga_CLK										(VGA_CLK),
	.vga_BLANK									(VGA_BLANK_N),
	.vga_SYNC									(VGA_SYNC_N),
	.vga_HS										(VGA_HS),
	.vga_VS										(VGA_VS),
	.vga_R										(VGA_R),
	.vga_G										(VGA_G),
	.vga_B										(VGA_B),
		
	// SDRAM
	.sdram_clk_clk								(DRAM_CLK),
   .sdram_addr									(DRAM_ADDR),
	.sdram_ba									(DRAM_BA),
	.sdram_cas_n								(DRAM_CAS_N),
	.sdram_cke									(DRAM_CKE),
	.sdram_cs_n									(DRAM_CS_N),
	.sdram_dq									(DRAM_DQ),
	.sdram_dqm									({DRAM_UDQM,DRAM_LDQM}),
	.sdram_ras_n								(DRAM_RAS_N),
	.sdram_we_n									(DRAM_WE_N),
	
	////////////////////////////////////
	// HPS Side
	////////////////////////////////////
	// DDR3 SDRAM
	.memory_mem_a			(HPS_DDR3_ADDR),
	.memory_mem_ba			(HPS_DDR3_BA),
	.memory_mem_ck			(HPS_DDR3_CK_P),
	.memory_mem_ck_n		(HPS_DDR3_CK_N),
	.memory_mem_cke		(HPS_DDR3_CKE),
	.memory_mem_cs_n		(HPS_DDR3_CS_N),
	.memory_mem_ras_n		(HPS_DDR3_RAS_N),
	.memory_mem_cas_n		(HPS_DDR3_CAS_N),
	.memory_mem_we_n		(HPS_DDR3_WE_N),
	.memory_mem_reset_n	(HPS_DDR3_RESET_N),
	.memory_mem_dq			(HPS_DDR3_DQ),
	.memory_mem_dqs		(HPS_DDR3_DQS_P),
	.memory_mem_dqs_n		(HPS_DDR3_DQS_N),
	.memory_mem_odt		(HPS_DDR3_ODT),
	.memory_mem_dm			(HPS_DDR3_DM),
	.memory_oct_rzqin		(HPS_DDR3_RZQ),
		  
	// Ethernet
	.hps_io_hps_io_gpio_inst_GPIO35	(HPS_ENET_INT_N),
	.hps_io_hps_io_emac1_inst_TX_CLK	(HPS_ENET_GTX_CLK),
	.hps_io_hps_io_emac1_inst_TXD0	(HPS_ENET_TX_DATA[0]),
	.hps_io_hps_io_emac1_inst_TXD1	(HPS_ENET_TX_DATA[1]),
	.hps_io_hps_io_emac1_inst_TXD2	(HPS_ENET_TX_DATA[2]),
	.hps_io_hps_io_emac1_inst_TXD3	(HPS_ENET_TX_DATA[3]),
	.hps_io_hps_io_emac1_inst_RXD0	(HPS_ENET_RX_DATA[0]),
	.hps_io_hps_io_emac1_inst_MDIO	(HPS_ENET_MDIO),
	.hps_io_hps_io_emac1_inst_MDC		(HPS_ENET_MDC),
	.hps_io_hps_io_emac1_inst_RX_CTL	(HPS_ENET_RX_DV),
	.hps_io_hps_io_emac1_inst_TX_CTL	(HPS_ENET_TX_EN),
	.hps_io_hps_io_emac1_inst_RX_CLK	(HPS_ENET_RX_CLK),
	.hps_io_hps_io_emac1_inst_RXD1	(HPS_ENET_RX_DATA[1]),
	.hps_io_hps_io_emac1_inst_RXD2	(HPS_ENET_RX_DATA[2]),
	.hps_io_hps_io_emac1_inst_RXD3	(HPS_ENET_RX_DATA[3]),

	// Flash
	.hps_io_hps_io_qspi_inst_IO0	(HPS_FLASH_DATA[0]),
	.hps_io_hps_io_qspi_inst_IO1	(HPS_FLASH_DATA[1]),
	.hps_io_hps_io_qspi_inst_IO2	(HPS_FLASH_DATA[2]),
	.hps_io_hps_io_qspi_inst_IO3	(HPS_FLASH_DATA[3]),
	.hps_io_hps_io_qspi_inst_SS0	(HPS_FLASH_NCSO),
	.hps_io_hps_io_qspi_inst_CLK	(HPS_FLASH_DCLK),

	// Accelerometer
	.hps_io_hps_io_gpio_inst_GPIO61	(HPS_GSENSOR_INT),

	//.adc_sclk                        (ADC_SCLK),
	//.adc_cs_n                        (ADC_CS_N),
	//.adc_dout                        (ADC_DOUT),
	//.adc_din                         (ADC_DIN),

	// General Purpose I/O
	.hps_io_hps_io_gpio_inst_GPIO40	(HPS_GPIO[0]),
	.hps_io_hps_io_gpio_inst_GPIO41	(HPS_GPIO[1]),

	// I2C
	.hps_io_hps_io_gpio_inst_GPIO48	(HPS_I2C_CONTROL),
	.hps_io_hps_io_i2c0_inst_SDA		(HPS_I2C1_SDAT),
	.hps_io_hps_io_i2c0_inst_SCL		(HPS_I2C1_SCLK),
	.hps_io_hps_io_i2c1_inst_SDA		(HPS_I2C2_SDAT),
	.hps_io_hps_io_i2c1_inst_SCL		(HPS_I2C2_SCLK),

	// Pushbutton
	.hps_io_hps_io_gpio_inst_GPIO54	(HPS_KEY),

	// LED
	.hps_io_hps_io_gpio_inst_GPIO53	(HPS_LED),

	// SD Card
	.hps_io_hps_io_sdio_inst_CMD	(HPS_SD_CMD),
	.hps_io_hps_io_sdio_inst_D0	(HPS_SD_DATA[0]),
	.hps_io_hps_io_sdio_inst_D1	(HPS_SD_DATA[1]),
	.hps_io_hps_io_sdio_inst_CLK	(HPS_SD_CLK),
	.hps_io_hps_io_sdio_inst_D2	(HPS_SD_DATA[2]),
	.hps_io_hps_io_sdio_inst_D3	(HPS_SD_DATA[3]),

	// SPI
	.hps_io_hps_io_spim1_inst_CLK		(HPS_SPIM_CLK),
	.hps_io_hps_io_spim1_inst_MOSI	(HPS_SPIM_MOSI),
	.hps_io_hps_io_spim1_inst_MISO	(HPS_SPIM_MISO),
	.hps_io_hps_io_spim1_inst_SS0		(HPS_SPIM_SS),

	// UART
	.hps_io_hps_io_uart0_inst_RX	(HPS_UART_RX),
	.hps_io_hps_io_uart0_inst_TX	(HPS_UART_TX),

	// USB
	.hps_io_hps_io_gpio_inst_GPIO09	(HPS_CONV_USB_N),
	.hps_io_hps_io_usb1_inst_D0		(HPS_USB_DATA[0]),
	.hps_io_hps_io_usb1_inst_D1		(HPS_USB_DATA[1]),
	.hps_io_hps_io_usb1_inst_D2		(HPS_USB_DATA[2]),
	.hps_io_hps_io_usb1_inst_D3		(HPS_USB_DATA[3]),
	.hps_io_hps_io_usb1_inst_D4		(HPS_USB_DATA[4]),
	.hps_io_hps_io_usb1_inst_D5		(HPS_USB_DATA[5]),
	.hps_io_hps_io_usb1_inst_D6		(HPS_USB_DATA[6]),
	.hps_io_hps_io_usb1_inst_D7		(HPS_USB_DATA[7]),
	.hps_io_hps_io_usb1_inst_CLK		(HPS_USB_CLKOUT),
	.hps_io_hps_io_usb1_inst_STP		(HPS_USB_STP),
	.hps_io_hps_io_usb1_inst_DIR		(HPS_USB_DIR),
	.hps_io_hps_io_usb1_inst_NXT		(HPS_USB_NXT)
);
endmodule // end top level

//============================================================
// M10K module for testing
//============================================================
// See example 12-16 in 
// http://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/HDL_style_qts_qii51007.pdf
//============================================================

module M10K_256_32( 
    output reg [31:0] q,
    input [31:0] d,
    input [7:0] write_address, read_address,
    input we, clk
);
	 // force M10K ram style
	 // 256 words of 32 bits
    reg [31:0] mem [255:0]  /* synthesis ramstyle = "no_rw_check, M10K" */;
	 
    always @ (posedge clk) begin
        if (we) begin
            mem[write_address] <= d;
		  end
        q <= mem[read_address]; // q doesn't get d in this clock cycle
    end
endmodule

//============================================================
// MLAB module for testing
//============================================================
// See example 12-16 in 
// http://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/HDL_style_qts_qii51007.pdf
//============================================================
module MLAB_20_32(
	output reg signed [31:0] q,
	input  [31:0] data,
	input [7:0] readaddr, writeaddr,
	input wren, clock
);
	// force MLAB ram style
	// 20 words of 32 bits
	reg signed [31:0] mem [19:0] /* synthesis ramstyle = "no_rw_check, MLAB" */;
	
	always @ (posedge clock)
	begin
		if (wren) begin
			mem[writeaddr] <= data;
		end
		q <= mem[readaddr];
	end
endmodule

/**************************************************************************
 * Following floating point modules written by Bruce Land                                       
 * March 2017      
 *************************************************************************/
/**************************************************************************
 * Floating Point to 16-bit integer                                             *
 * Combinational      
 * Numbers with mag > than +/-32768 get clipped to 32768 or -32768
 *************************************************************************/
 module Int2Fp(
		input signed [15:0]	iInteger,
		output[26:0]	oA		
 );
		// output fields
    wire        A_s;
    wire [7:0]  A_e;
    wire [17:0] A_f;
    
	 wire [15:0] abs_input ;
	 // get output sign bit
	 assign A_s = (iInteger < 0);
	 // remove sign from input
	 assign abs_input = (iInteger < 0)? -iInteger : iInteger ;
	 
	 // find the most significant (nonzero) bit
	 wire [7:0]  shft_amt;
	 assign shft_amt = abs_input[15] ? 8'd3 :
                      abs_input[14] ? 8'd4 : abs_input[13] ? 8'd5 :
                      abs_input[12] ? 8'd6 : abs_input[11] ? 8'd7 :
                      abs_input[10] ? 8'd8 : abs_input[9]  ? 8'd9 :
                      abs_input[8]  ? 8'd10 : abs_input[7]  ? 8'd11 :
                      abs_input[6]  ? 8'd12 : abs_input[5]  ? 8'd13 :
                      abs_input[4]  ? 8'd14 : abs_input[3]  ? 8'd15 :
                      abs_input[2]  ? 8'd16 : abs_input[1]  ? 8'd17 :
                      abs_input[0]  ? 8'd18 : 8'd19;	
	 // exponent 127 + (18-shift_amt)
	 // 127 is 2^0
	 // 18 is amount '1' is shifted
	 assign A_e = 127 + 18 - shft_amt ;
	 // where the intermediate value is formed
	 wire [33:0] shift_buffer ;
	 // remember that the high-order '1' is not stored,
	 // but is shifted to bit 18
	 assign shift_buffer = {16'b0, abs_input} << shft_amt ;
	 assign A_f = shift_buffer[17:0];
	 assign oA = (iInteger==0)? 27'b0 : {A_s, A_e, A_f};
	 
 endmodule //Int2Fp
 
 /**************************************************************************
 * Floating Point to 16-bit integer                                             *
 * Combinational      
 * Numbers with mag > than +/-32768 get clipped to 32768 or -32768
 *************************************************************************/
 module Fp2Int(
		input	 [26:0]	iA,
		output reg [15:0]	oInteger
 );
		// Extract fields of A and B.
    wire        A_s;
    wire [7:0]  A_e;
    wire [17:0] A_f;
    assign A_s = iA[26];
    assign A_e = iA[25:18];
    assign A_f = iA[17:0];
	 
	 wire [15:0] max_int = 16'h7fff ; //32768
	 wire [33:0] shift_buffer ;
	 // form (1.A_f) and shift it to postiion
	 assign shift_buffer = {15'b0, 1'b1, A_f}<<(A_e-127) ;
	 
	 // If exponent less than 127, oInteger=0
	 // If exponent greater than 127+14 oInteger=max value
	 // Between these two values:
	 //	set up input mantissa with 1.mantissa 
	 //	   and the "1." in the lowest bit of an extended word.
	 // 	shift-left by A_e-127
	 // If the sign bit is set, negate oInteger
	 	
	 always @(*) begin
			if (A_e < 127) oInteger = 16'b0;
			else if (A_e > 141) begin
				if (A_s) oInteger = -max_int;
				else     oInteger = max_int;
			end
			else begin
				if (A_s) oInteger = -shift_buffer[33:18];
				else     oInteger = shift_buffer[33:18];
			end
	 end
	 
 endmodule //Fp2Int
 
/**************************************************************************
 * Floating Point shift                                             *
 * Combinational      
 * Negative shift input is right shift
 *************************************************************************/
 module FpShift(
		input	 [26:0]	iA,
		input   [7:0] 	iShift,
		output [26:0]	oShifted
 );
		// Extract fields of A and B.
    wire        A_s;
    wire [7:0]  A_e;
    wire [17:0] A_f;
    assign A_s = iA[26];
    assign A_e = iA[25:18];
    assign A_f = iA[17:0];
	 // Flip bit 26
	 // zero the output if underflow/overflow
//    assign oShifted = (A_e+iShift<8'd254 && A_e+iShift>8'd2)? 
//									{A_s, A_e+iShift, A_f} 
	 assign oShifted = {A_s, A_e+iShift, A_f} ;	
 endmodule //FpShift
 
/**************************************************************************
 * Floating Point sign negation                                             *
 * Combinational                                                          *
 *************************************************************************/
 module FpNegate(
		input	 [26:0]	iA,
		output [26:0]	oNegative
 );
		// Extract fields of A and B.
    wire        A_s;
    wire [7:0]  A_e;
    wire [17:0] A_f;
    assign A_s = iA[26];
    assign A_e = iA[25:18];
    assign A_f = iA[17:0];
	 // Flip bit 26
    assign oNegative = {~A_s, A_e, A_f};	
 endmodule //FpNegate

 /**************************************************************************
 * Floating Point absolute                                             *
 * Combinational                                                          *
 *************************************************************************/
 module FpAbs(
		input	 [26:0]	iA,
		output [26:0]	oAbs
 );
		// Extract fields of A and B.
    wire        A_s;
    wire [7:0]  A_e;
    wire [17:0] A_f;
    assign A_s = iA[26];
    assign A_e = iA[25:18];
    assign A_f = iA[17:0];
	 // zero bit 26
    assign oAbs = {1'b0, A_e, A_f};	
 endmodule //Fp absolute
 
 /**************************************************************************
 * Floating Point compare                                             *
 * Combinational     
 * output=1 if A>=B
 *************************************************************************/
 module FpCompare(
		input	 [26:0]	iA,
		input	 [26:0]	iB,
		output reg oA_larger
 );
		// Extract fields of A and B.
    wire        A_s;
    wire [7:0]  A_e;
    wire [17:0] A_f;
	 wire        B_s;
    wire [7:0]  B_e;
    wire [17:0] B_f;
    
    assign A_s = iA[26];
    assign A_e = iA[25:18];
    assign A_f = iA[17:0];
	 assign B_s = iB[26];
    assign B_e = iB[25:18];
    assign B_f = iB[17:0];
	 
	 // Determine which of A, B is larger
	 wire A_mag_larger ;
    assign A_mag_larger =(A_e > B_e)                   ? 1'b1  :
                         ((A_e == B_e) && (A_f >= B_f)) ? 1'b1  :
                         1'b0;
								 
	 // now do the sign checks
	 always @(*) begin
			if (A_s==0 && B_s==1) begin  // A positive, B negative
				oA_larger = 1'b1 ;
			end
			else if (A_s==1 && B_s==0) begin  // A negative, B positive
				oA_larger = 1'b0 ;
			end
			else if (A_s==0 && B_s==0) begin  // A positive, B positive
				oA_larger = A_mag_larger ;
			end
			else if (A_s==1 && B_s==1) begin  // A negative, B negative
				oA_larger = ~A_mag_larger ;
			end
			else oA_larger  = 0; // make sure no inferred latch
	 end
 endmodule //FpCompare
 
/**************************************************************************
 * Following floating point written by Mark Eiding mje56                                                      *
 * ECE 5760                                                               *
 * Modified IEEE single precision FP                                      *
 * bit 26:      Sign     (0: pos, 1: neg)                                 *
 * bits[25:18]: Exponent (unsigned)                                       *
 * bits[17:0]:  Fraction (unsigned)                                       *
 *  (-1)^SIGN * 2^(EXP-127) * (1+.FRAC)                                   *
 * (http://en.wikipedia.org/wiki/Single-precision_floating-point_format)  *
 * Adapted from Skyler Schneider ss868                                    *
 *************************************************************************/
/**************************************************************************
 * Floating Point Fast Inverse Square Root                                *
 * 5-stage pipeline                                                       *
 * http://en.wikipedia.org/wiki/Fast_inverse_square_root                  *
 * Magic number 27'd49920718                                              *
 * 1.5 = 27'd33423360                                                     *
 *************************************************************************/
module FpInvSqrt (
    input             iCLK,
    input      [26:0] iA,
    output     [26:0] oInvSqrt
);

    // Extract fields of A and B.
    wire        A_s;
    wire [7:0]  A_e;
    wire [17:0] A_f;
    assign A_s = iA[26];
    assign A_e = iA[25:18];
    assign A_f = iA[17:0];

    //Stage 1
    wire [26:0] y_1, y_1_out, half_iA_1;
    assign y_1 = 27'd49920718 - (iA>>1);
    assign half_iA_1 = {A_s, A_e-8'd1,A_f};
    FpMul s1_mult ( .iA(y_1), .iB(y_1), .oProd(y_1_out) );
    //Stage 2
    reg [26:0] y_2, mult_2_in, half_iA_2;
    wire [26:0] y_2_out;
    FpMul s2_mult ( .iA(half_iA_2), .iB(mult_2_in), .oProd(y_2_out) );
    //Stage 3
    reg [26:0] y_3, add_3_in;
    wire [26:0] y_3_out;
    FpAdd s3_add ( .iCLK(iCLK), .iA({~add_3_in[26],add_3_in[25:0]}), .iB(27'd33423360), .oSum(y_3_out) );
    //Stage 4
    reg [26:0] y_4;
    //Stage 5
    reg [26:0] y_5, mult_5_in;
    FpMul s5_mult ( .iA(y_5), .iB(mult_5_in), .oProd(oInvSqrt) );

    always @(posedge iCLK) begin
    //Stage 1 to 2
    y_2 <= y_1;
    mult_2_in <= y_1_out;
    half_iA_2 <= half_iA_1;
    //Stage 2 to 3
    y_3 <= y_2;
    add_3_in <= y_2_out;
    //Stage 3 to 4
    y_4 <= y_3;
    //Stage 4 to 5
    y_5 <= y_4;
    mult_5_in <= y_3_out;
    end
endmodule

/**************************************************************************
 * Floating Point Multiplier                                              *
 * Combinational                                                          *
 *************************************************************************/
module FpMul (
    input      [26:0] iA,    // First input
    input      [26:0] iB,    // Second input
    output     [26:0] oProd  // Product
);

    // Extract fields of A and B.
    wire        A_s;
    wire [7:0]  A_e;
    wire [17:0] A_f;
    wire        B_s;
    wire [7:0]  B_e;
    wire [17:0] B_f;
    assign A_s = iA[26];
    assign A_e = iA[25:18];
    assign A_f = {1'b1, iA[17:1]};
    assign B_s = iB[26];
    assign B_e = iB[25:18];
    assign B_f = {1'b1, iB[17:1]};

    // XOR sign bits to determine product sign.
    wire        oProd_s;
    assign oProd_s = A_s ^ B_s;

    // Multiply the fractions of A and B
    wire [35:0] pre_prod_frac;
    assign pre_prod_frac = A_f * B_f;

    // Add exponents of A and B
    wire [8:0]  pre_prod_exp;
    assign pre_prod_exp = A_e + B_e;

    // If top bit of product frac is 0, shift left one
    wire [7:0]  oProd_e;
    wire [17:0] oProd_f;
    assign oProd_e = pre_prod_frac[35] ? (pre_prod_exp-9'd126) : (pre_prod_exp - 9'd127);
    assign oProd_f = pre_prod_frac[35] ? pre_prod_frac[34:17] : pre_prod_frac[33:16];

    // Detect underflow
    wire        underflow;
    assign underflow = pre_prod_exp < 9'h80;

    // Detect zero conditions (either product frac doesn't start with 1, or underflow)
    assign oProd = underflow        ? 27'b0 :
                   (B_e == 8'd0)    ? 27'b0 :
                   (A_e == 8'd0)    ? 27'b0 :
                   {oProd_s, oProd_e, oProd_f};

endmodule


/**************************************************************************
 * Floating Point Adder                                                   *
 * 2-stage pipeline                                                       *
 *************************************************************************/
module FpAdd (
    input             iCLK,
    input      [26:0] iA,
    input      [26:0] iB,
    output reg [26:0] oSum
);

    // Extract fields of A and B.
    wire        A_s;
    wire [7:0]  A_e;
    wire [17:0] A_f;
    wire        B_s;
    wire [7:0]  B_e;
    wire [17:0] B_f;
    assign A_s = iA[26];
    assign A_e = iA[25:18];
    assign A_f = {1'b1, iA[17:1]};
    assign B_s = iB[26];
    assign B_e = iB[25:18];
    assign B_f = {1'b1, iB[17:1]};
    wire A_larger;

    // Shift fractions of A and B so that they align.
    wire [7:0]  exp_diff_A;
    wire [7:0]  exp_diff_B;
    wire [7:0]  larger_exp;
    wire [36:0] A_f_shifted;
    wire [36:0] B_f_shifted;

    assign exp_diff_A = B_e - A_e; // if B bigger
    assign exp_diff_B = A_e - B_e; // if A bigger

    assign larger_exp = (B_e > A_e) ? B_e : A_e;

    assign A_f_shifted = A_larger             ? {1'b0,  A_f, 18'b0} :
                         (exp_diff_A > 9'd35) ? 37'b0 :
                         ({1'b0, A_f, 18'b0} >> exp_diff_A);
    assign B_f_shifted = ~A_larger            ? {1'b0,  B_f, 18'b0} :
                         (exp_diff_B > 9'd35) ? 37'b0 :
                         ({1'b0, B_f, 18'b0} >> exp_diff_B);

    // Determine which of A, B is larger
    assign A_larger =    (A_e > B_e)                   ? 1'b1  :
                         ((A_e == B_e) && (A_f > B_f)) ? 1'b1  :
                         1'b0;

    // Calculate sum or difference of shifted fractions.
    wire [36:0] pre_sum;
    assign pre_sum = ((A_s^B_s) &  A_larger) ? A_f_shifted - B_f_shifted :
                     ((A_s^B_s) & ~A_larger) ? B_f_shifted - A_f_shifted :
                     A_f_shifted + B_f_shifted;

    // buffer midway results
    reg  [36:0] buf_pre_sum;
    reg  [7:0]  buf_larger_exp;
    reg         buf_A_e_zero;
    reg         buf_B_e_zero;
    reg  [26:0] buf_A;
    reg  [26:0] buf_B;
    reg         buf_oSum_s;
    always @(posedge iCLK) begin
        buf_pre_sum    <= pre_sum;
        buf_larger_exp <= larger_exp;
        buf_A_e_zero   <= (A_e == 8'b0);
        buf_B_e_zero   <= (B_e == 8'b0);
        buf_A          <= iA;
        buf_B          <= iB;
        buf_oSum_s     <= A_larger ? A_s : B_s;
    end

    // Convert to positive fraction and a sign bit.
    wire [36:0] pre_frac;
    assign pre_frac = buf_pre_sum;

    // Determine output fraction and exponent change with position of first 1.
    wire [17:0] oSum_f;
    wire [7:0]  shft_amt;
    assign shft_amt = pre_frac[36] ? 8'd0  : pre_frac[35] ? 8'd1  :
                      pre_frac[34] ? 8'd2  : pre_frac[33] ? 8'd3  :
                      pre_frac[32] ? 8'd4  : pre_frac[31] ? 8'd5  :
                      pre_frac[30] ? 8'd6  : pre_frac[29] ? 8'd7  :
                      pre_frac[28] ? 8'd8  : pre_frac[27] ? 8'd9  :
                      pre_frac[26] ? 8'd10 : pre_frac[25] ? 8'd11 :
                      pre_frac[24] ? 8'd12 : pre_frac[23] ? 8'd13 :
                      pre_frac[22] ? 8'd14 : pre_frac[21] ? 8'd15 :
                      pre_frac[20] ? 8'd16 : pre_frac[19] ? 8'd17 :
                      pre_frac[18] ? 8'd18 : pre_frac[17] ? 8'd19 :
                      pre_frac[16] ? 8'd20 : pre_frac[15] ? 8'd21 :
                      pre_frac[14] ? 8'd22 : pre_frac[13] ? 8'd23 :
                      pre_frac[12] ? 8'd24 : pre_frac[11] ? 8'd25 :
                      pre_frac[10] ? 8'd26 : pre_frac[9]  ? 8'd27 :
                      pre_frac[8]  ? 8'd28 : pre_frac[7]  ? 8'd29 :
                      pre_frac[6]  ? 8'd30 : pre_frac[5]  ? 8'd31 :
                      pre_frac[4]  ? 8'd32 : pre_frac[3]  ? 8'd33 :
                      pre_frac[2]  ? 8'd34 : pre_frac[1]  ? 8'd35 :
                      pre_frac[0]  ? 8'd36 : 8'd37;

    wire [53:0] pre_frac_shft, uflow_shift;
	 // the shift +1 is because high order bit is not stored, but implied
    assign pre_frac_shft = {pre_frac, 17'b0} << (shft_amt+1); //? shft_amt+1
	 assign uflow_shift = {pre_frac, 17'b0} << (shft_amt); //? shft_amt for overflow
    assign oSum_f = pre_frac_shft[53:36];

    wire [7:0] oSum_e;
    assign oSum_e = buf_larger_exp - shft_amt + 8'b1;

    // Detect underflow
    wire underflow;
	 // this incorrectly sets uflow for 10-10.1
    //assign underflow = ~oSum_e[7] && buf_larger_exp[7] && (shft_amt != 8'b0);
	 
	 // if top bit of matissa is not set, then denorm
	 assign underflow = ~uflow_shift[53]; 
	 
	 always @(posedge iCLK) begin
			oSum <= (buf_A_e_zero && buf_B_e_zero)    ? 27'b0 :
                  buf_A_e_zero                     ? buf_B :
                  buf_B_e_zero                     ? buf_A :
                  underflow                        ? 27'b0 :
                  (pre_frac == 0)                  ? 27'b0 :
                  {buf_oSum_s, oSum_e, oSum_f};
	 end //output update
endmodule

/// end /////////////////////////////////////////////////////////////////////