

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

// =====================================================
// route 16-bit signal to HEX display
// no output currently
reg [15:0] hex3_hex0 = 0;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
// trigger value (16 bits)
HexDigit Digit0(HEX0, hex3_hex0[3:0]);
HexDigit Digit1(HEX1, hex3_hex0[7:4]);
HexDigit Digit2(HEX2, hex3_hex0[11:8]);
HexDigit Digit3(HEX3, hex3_hex0[15:12]);

//=======================================================
//  Device under test
//=======================================================
// --- a counter ---
reg [31:0] count ;
// DUT_state is only used as an example state variable 
reg [3:0] DUT_state  /* synthesis preserve */;
//
always @(posedge CLOCK_100) begin
	if (DUT_state==4'd0) begin
		count <= count + 32'd1 ;
		DUT_state <= 4'd1;
	end
	if (DUT_state==4'd1) begin
		count <= count + 32'd1 ;
		DUT_state <= 4'd2;
	end
	if (DUT_state==4'd2) begin
		count <= count + 32'd1 ;
		DUT_state <= 4'd0;
	end
end

// ======================================================
// connect the logic analyser to DUT and to Qsys
// ======================================================
// There are two inputs to the logic analyzer
// which you need to connect HERE
// the data to analyse AND a trigger source
wire [31:0] data_input, ext_trigger_source ;
// (1) data to be logged, in this case:
//      "count"  
//      the state variable
// (2) a trigger to indicate when to log the data
assign data_input = {DUT_state, count[27:0]} ;
// if the trigger mask=h8000_0000 and trigger value=0 
//    then the pushbutton will trigger the data capture
assign ext_trigger_source = { KEY[3], count[30:0]} ;

// data memory (from Qsys)
wire [31:0] sram_readdata ;
wire [31:0] sram_writedata ;
wire [9:0] sram_address ;
wire sram_write ;

// control memory (from Qsys)
wire [31:0] control_readdata ;
wire [31:0] control_writedata ;
wire [7:0] control_address; 
wire control_write ;

// clock from Qsys
wire CLOCK_100 ;

// the analyzer module
logic_analyser la1(
	.data_input(data_input), 
	.ext_trigger_source(ext_trigger_source),
	.sram_readdata(sram_readdata), 
	.sram_writedata(sram_writedata), 
	.sram_address(sram_address), 
	.sram_write(sram_write),
	.control_readdata(control_readdata), 
	.control_writedata(control_writedata), 
	.control_address(control_address), 
	.control_write(control_write),
	.clock(CLOCK_100),
	.reset(~KEY[0])
);

//=======================================================
//  Structural coding
//=======================================================
// From Qsys
Computer_System The_System (
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////

	// Global signals
	.system_pll_ref_clk_clk				(CLOCK_50),
	.system_pll_ref_reset_reset		(1'b0),
	.sdram_clk_clk                   (CLOCK_100), 
	
	// analyser SRAM shared block with HPS
	.logic_analyser_sram_address     (sram_address),    
	.logic_analyser_sram_clken       (1'b1),      
	.logic_analyser_sram_chipselect  (1'b1),  
	.logic_analyser_sram_write       (sram_write),       
	.logic_analyser_sram_readdata    (sram_readdata),    
	.logic_analyser_sram_writedata   (sram_writedata),   
	.logic_analyser_sram_byteenable  (4'b1111),  
	
	// controller SRAM shared block with HPS
	.control_sram_address            (control_address),            
	.control_sram_clken              (1'b1),              
	.control_sram_chipselect         (1'b1),         
	.control_sram_write              (control_write),       
	.control_sram_readdata           (control_readdata),        
	.control_sram_writedata          (control_writedata),      
	.control_sram_byteenable         (4'b1111), 
	
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

//=======================================================
// Logic analyser
//=======================================================
// the controller memory block
// -- addr 0 -- new data? yes==1
// -- addr 1 -- allow capture to occur -- arm 
// -- addr 2 -- trigger count (after trigger event)
// -- addr 250 -- data capture complete == 1
// -- addr 251 -- addr_complete (sram addr of trigger sample)
// read trigger mask -- two 32 bit words 
// -- addr 254 dont care mask
// -- addr 255 actual bits
//
// The analyzer data block logs the data input at 100 MHz.
// The memory wraps at 1024 words
//
// There are three state machines running:
// (1) The data capture machine which logs one 32-bit word/cycle
//    all the time. When the trigger event occurs, it grabs a set
//    number more of samples, then signals the HPS and waits.
// (2) The trigger state machine just waits to set the trigger on EACH cycle
// (3) The control state machine gets parameters from the HPS, and when the
//    logic samples are logged, signals the HPS to dump them, then waits.

module logic_analyser(
   // the logical inputs
	data_input, 
	ext_trigger_source,
	// data memory
	sram_readdata, sram_writedata, sram_address, sram_write,
	// control memory
	control_readdata, control_writedata, control_address, control_write,
	clock, reset
);
// DUT inputs
input wire [31:0] data_input, ext_trigger_source ;
// data memory
input wire [31:0] sram_readdata ;
output reg [31:0] sram_writedata ;
output reg [9:0] sram_address ;
output reg sram_write ;
// control memory
input wire [31:0] control_readdata ;
output reg [31:0] control_writedata ;
output reg [7:0] control_address; 
output reg control_write ;

// the 100 MHz clock
input clock;
input reset;

//=======================================================
// Controls for analyser sram slave exported in system 
//=======================================================
reg [9:0] sram_write_addr, sram_read_addr; 
reg [7:0] analyser_state ;

//=======================================================
// Controls for controller sram slave exported in system 
//=======================================================
reg [7:0] control_state ;
//reg [3:0] trigger_time_mode, trigger_source_mode;
// desired number of samples after trigger
reg [9:0] trigger_count ;
// actual current count
reg [9:0] current_count ;
// setting this enables the trigger
// --set by HPS--
reg capture_arm ;
// analyser complete signal to HPS
reg complete ;
// value of data address when trigger occurs
reg [9:0] addr_complete ;

//=======================================================
// controls for analyser to/from fpga
//=======================================================
// signal to store data
wire  ext_trigger ;
reg [7:0] trigger_state ;
reg trigger ;

// trigger processing
// mask and trigger value set by HPS
reg [31:0] trig_mask, trig_value ;
assign ext_trigger = ((ext_trigger_source & trig_mask) == (trig_value & trig_mask))? 1'b1 : 1'b0 ;

//=======================================================
// Logic analyzer state machinedo the work outlined above
//=======================================================
// CLOCK_100 is the sdram clock from Qsys

always @(posedge clock) begin // CLOCK_100

	//=====================================
   // reset state machine and read/write controls
	//=====================================
	if (reset) begin
		// the state machines
		analyser_state <= 8'd0 ;
		control_state <= 8'd0 ;
		trigger_state <= 8'd0 ;
		// analyzer sram
		sram_write <= 1'b0 ;
		sram_address <= 12'd0 ;
		// control sram
		control_write <= 1'b0; 
		capture_arm <= 1'b0 ;
		complete <= 0 ;
		addr_complete <= 0;
		trigger <= 0;
	end
	// not reset
	else begin
	//=====================================
	// Analyser state machine
	//=====================================
	// fill a circular buffer with data 
	// once/cycle
	// until a trigger event occurs
	if (analyser_state == 8'd0) begin
		sram_writedata <= data_input ;
		sram_address <= sram_write_addr;
		sram_write <= 1'b1 ;
		sram_write_addr <= sram_write_addr + 10'd1 ;
		if (trigger) begin
			trigger <= 0 ;
			analyser_state <= 8'd2;
			// record the trigger address for the 
			// HPS to use
			addr_complete <= sram_write_addr ;
			// record the trigger on the hex display
			//hex3_hex0 <= data_input ;
			// reset the post-trigger sample count 
			current_count <= 10'b0 ; // the # samples after trigger
		end
	end
	
	// must take 100, take 500 samples more, or
	// 900 samples more.
	// corresponding to trigger_count from HPS
	if (analyser_state == 8'd2) begin
		sram_writedata <= data_input ;
		sram_address <= sram_write_addr;
		sram_write <= 1'b1 ;
		sram_write_addr <= sram_write_addr + 10'd1 ;
		// have we gotten the request # samples 
		// after the trigger
		if (current_count<=trigger_count) begin
			current_count <= current_count + 10'd1;	
		end
		else begin
			// allow the HPS to read the data
			// set complete flag
			analyser_state <= 8'd3;
			complete <= 1'b1 ;
			// reset for next time
			//current_count <= 12'b0;
		end	
	end
	
	// wait for HPS to read all the data points
	// then restart aqusition of data
	if (analyser_state == 8'd3) begin
		if (complete==1'b0) begin
			analyser_state <= 8'd0;
		end
	end
	
	//=====================================
	// Trigger state machine
	//=====================================
	if (trigger_state == 8'd0) begin
		if (ext_trigger==1'b1 && capture_arm ) begin
			trigger <= 8'd1;
			// record the trigger on the hex display
			//hex3_hex0 <= data_input ;
			// and clear the arming signal
			// until set again by HPS
			capture_arm <= 0 ;
		end
	end
	
	//=====================================
	// Control state machine
	//=====================================
	// Is there new data from the HPS
	// If so, read it, and set control
	// signals
	
	//=====================================
	// check for new data from HPS
	// AND send complete data, if any
	// "complete" flag is set in analyser state machine
	if (control_state == 8'd0) begin	
		if (complete) begin
			control_state <= 8'd200 ;
			control_write <= 1'b0 ;
		end
		// get HPS signal for new data
		else begin
			control_address <= 8'd0 ;
			control_write <= 1'b0 ;
			control_state <= 8'd1 ;
		end
	end
	
	// wait
	if (control_state == 8'd1) begin
		control_state <= 8'd2 ;
	end
	
	// read determine if there is new data
	if (control_state == 8'd2) begin
		if (control_readdata > 0) begin
			// get the new data
			control_state <= 8'd7 ;
		end
		else begin
			control_state <= 8'd0 ;
		end
	end
	//=====================================
	
	// === read the arm command ===========
	// do this LAST !!!
	if (control_state == 8'd4) begin
		control_address <= 8'd1 ;
		control_write <= 1'b0 ;
		control_state <= 8'd5 ;
	end
	
	// wait
	if (control_state == 8'd5) begin
		control_state <= 8'd6 ;
	end
	
	// read arm_control
	if (control_state == 8'd6) begin
		capture_arm <= control_readdata ;
		control_state <= 8'd100 ;
	end
	//=====================================
	
	// === read the trigger time mode =====
	if (control_state == 8'd7) begin
		control_address <= 8'd2 ;
		control_write <= 1'b0 ;
		control_state <= 8'd8 ;
	end
	
	// wait
	if (control_state == 8'd8) begin
		control_state <= 8'd9 ;
	end
	
	// read trigger_count
	// number of samples AFTER trigger
	if (control_state == 8'd9) begin
		trigger_count <= control_readdata ;
		control_state <= 8'd10 ;
	end
	
	// === read the trigger mask  ========
	if (control_state == 8'd10) begin
		control_address <= 8'd254 ;
		control_write <= 1'b0 ;
		control_state <= 8'd11 ;
	end
	
	// wait
	if (control_state == 8'd11) begin
		control_state <= 8'd12 ;
	end
	
	// read trigger_mask
	if (control_state == 8'd12) begin
		trig_mask <= control_readdata ;
		control_state <= 8'd13 ;
	end
	
	// === read the trigger value  ======
	if (control_state == 8'd13) begin
		control_address <= 8'd255 ;
		control_write <= 1'b0 ;
		control_state <= 8'd14 ;
	end
	
	// wait
	if (control_state == 8'd14) begin
		control_state <= 8'd15 ;
	end
	
	// read trigger_value
	if (control_state == 8'd15) begin
		trig_value <= control_readdata ;
		control_state <= 8'd4 ;
	end
	
	//=====================================
	
	// === clear the complete-flag 
	// should be after the data readback
	//if (control_state == 8'd10) begin
		//control_address <= 8'd250 ;
		//control_writedata <= 1'b0;
		//control_write <= 1'b1 ;
		//control_state <= 8'd100 ;
	//end
	
	// === clear the "new data" flag ======
	// === and return to idle state
	if (control_state == 8'd100) begin
		control_address <= 8'd0 ;
		control_writedata <= 1'b0;
		control_write <= 1'b1 ;
		control_state <= 8'd0 ;
	end
	//=====================================
	
	// === send the addr_complete value to HPS
	// and send done command
	if (control_state == 8'd200) begin
		control_address <= 8'd251 ;
		control_writedata <= addr_complete ;
		control_write <= 1'b1 ;
		control_state <= 8'd201 ;
	end
	// now send done/complete signal
	// back to HPS
	if (control_state == 8'd201) begin
		control_address <= 8'd250 ;
		control_writedata <= 1'b1 ;
		control_write <= 1'b1 ;
		control_state <= 8'd202 ;
	end
	// and wait for HPS rsponse
	// read back HPS done with data readback
	if (control_state == 8'd202) begin
		control_address <= 8'd250 ;
		control_write <= 1'b0 ;
		control_state <= 8'd203 ;
	end
	// wait
	if (control_state == 8'd203) begin
		control_state <= 8'd204 ;
	end
	// wait
	if (control_state == 8'd204) begin
		if (control_readdata==0) begin
			// and clear the flag
			//complete <= 1'b0 ;
			control_state <= 8'd0 ;
			complete <= 1'b0 ;
		end
		else begin // try again
			control_state <= 8'd202 ;
		end
	end
	end // reset else
end // always @(posedge state_clock)

endmodule // module logic_analyser

/// end /////////////////////////////////////////////////////////////////////