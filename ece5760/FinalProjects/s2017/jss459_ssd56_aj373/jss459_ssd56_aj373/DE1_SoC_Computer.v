

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

// MAY need to cycle this switch on power-up to get video
assign TD_RESET_N = SW[1];

// get some signals exposed
// connect bus master signals to i/o for probes
assign GPIO_0[0] = TD_HS ;
assign GPIO_0[1] = TD_VS ;
assign GPIO_0[2] = TD_DATA[6] ;
assign GPIO_0[3] = TD_CLK27 ;
assign GPIO_0[4] = TD_RESET_N ;

//=======================================================
// Bus controller for AVALON bus-master
//=======================================================
wire [31:0] vga_bus_addr, video_in_bus_addr ; // Avalon addresses
reg  [31:0] bus_addr ;
wire [31:0] vga_out_base_address = 32'h0000_0000 ;  // Avalon address
wire [31:0] video_in_base_address = 32'h0800_0000 ;  // Avalon address
reg [3:0] bus_byte_enable ; // four bit byte read/write mask
reg bus_read  ;       // high when requesting data
reg bus_write ;      //  high when writing data
reg [31:0] bus_write_data ; //  data to send to Avalog bus
wire bus_ack  ;       //  Avalon bus raises this when done
wire [31:0] bus_read_data ; // data from Avalon bus
reg [31:0] timer ;
reg [3:0] state ;
reg last_vs, wait_one;
reg [19:0] vs_count ;
reg last_hs, wait_one_hs ;
reg [19:0] hs_count ;

// pixel address is
reg [9:0] vga_x_cood, vga_y_cood, video_in_x_cood, video_in_y_cood ;
reg [7:0] current_pixel_color1, current_pixel_color2 ;
// compute address
assign vga_bus_addr = vga_out_base_address + {22'b0,video_in_x_cood + vga_x_cood} + ({22'b0,video_in_y_cood + vga_y_cood}<<10) ;
assign video_in_bus_addr = video_in_base_address + {22'b0,video_in_x_cood} + ({22'b0,video_in_y_cood}<<9) ;	 


reg [31:0] x_accum, y_accum, x_accum_tot,y_accum_tot;
reg [31:0] z_accum; //# green pixels counted
reg [19:0] green_count; 
wire greenFlag;
//thresholding regs
wire [2:0] red_min,red_max,green_min,green_max;
wire [1:0] blue_min,blue_max;
reg [2:0] red_min_reg,red_max_reg,green_min_reg,green_max_reg;
reg [1:0] blue_min_reg,blue_max_reg;
assign red_min = red_min_reg;
assign red_max = red_max_reg;
assign blue_min = blue_min_reg;
assign blue_max = blue_max_reg;
assign green_min = green_min_reg;
assign green_max = green_max_reg;

/*assign red_min = 0;
assign red_max = 1;
assign blue_min = 0;
assign blue_max = 2;
assign green_min = 2;
assign green_max = 7;*/

//assign greenFlag = (bus_read_data[7:0]<=8'h33) && (bus_read_data[23:16] <= 8'h33) && (bus_read_data[15:8] >= 8'h44) && (bus_read_data <= 8'hff);
assign greenFlag = (current_pixel_color1[7:5] <= red_max) && (current_pixel_color1[4:2] >= green_min) && (current_pixel_color1[1:0] < blue_max) && (current_pixel_color1[7:5] >= red_min)  && (current_pixel_color1[4:2] <= green_max ) && (current_pixel_color1[1:0] > blue_min);
					


//Box Drawing
wire [9:0] center_x,center_y,radius;
wire isBox,isLeft,isRight,isBot,isTop;
reg [9:0] center_x_reg,center_y_reg,radius_reg;

//reg [7:0] red_reg;
//box drawing regs
//reg [9:0] center_x_reg,center_y_reg,radius_reg;
/*assign center_x = 100;
assign center_y = 100;
assign radius = 10;*/

assign center_x = center_x_reg;
assign center_y = center_y_reg;
assign radius = radius_reg;
assign isRight = (video_in_x_cood == center_x + radius) && (video_in_y_cood >= center_y-radius) && (video_in_y_cood <= center_y +radius);
assign isLeft = (video_in_x_cood == center_x - radius) && (video_in_y_cood >= center_y-radius) && (video_in_y_cood <= center_y +radius);
assign isBot = (video_in_y_cood == center_y + radius) && (video_in_x_cood >= center_x-radius) && (video_in_x_cood <= center_x +radius);
assign isTop = (video_in_y_cood == center_y - radius) && (video_in_x_cood >= center_x-radius) && (video_in_x_cood <= center_x +radius);
assign isBox = isRight || isLeft || isTop || isBot;


always @(posedge CLOCK2_50) begin //CLOCK_50

	// reset state machine and read/write controls
	if (~KEY[0]) begin
		state <= 0 ;
		bus_read <= 0 ; // set to one if a read opeation from bus
		bus_write <= 0 ; // set to on if a write operation to bus
		// base address of upper-left corner of the screen
		vga_x_cood <= 10'd0 ;
		vga_y_cood <= 10'd0 ;
		video_in_x_cood <= 0 ;
		video_in_y_cood <= 0 ;
	   bus_byte_enable <= 4'b0001;
		green_count <= 0;
		x_accum <= 0;
		y_accum <= 0;
		z_accum <= 0;
		timer <= 0;
	end
	else begin
		timer <= timer + 1;
	end
	
	// write to the bus-master
	// and put in a small delay to aviod bus hogging
	// timer delay can be set to 2**n-1, so 3, 7, 15, 31
	// bigger numbers mean slower frame update to VGA
	if (state==0 && SW[0] && (timer & 3)==0 ) begin //
		state <= 1;	
		
		// read all the pixels in the video input
		video_in_x_cood <= video_in_x_cood + 10'd1 ;
		if (video_in_x_cood > 10'd319) begin
			video_in_x_cood <= 0 ;
			video_in_y_cood <= video_in_y_cood + 10'd1 ;
			if (video_in_y_cood > 10'd239) begin
				video_in_y_cood <= 10'd0 ;
				z_accum <= green_count;
				x_accum_tot <= x_accum;
				y_accum_tot <= y_accum;
				green_count <= 0;
				x_accum <= 0;
				y_accum <= 0;
			end
		end
		// one byte data
		bus_byte_enable <= 4'b0001;
		// read first pixel
		bus_addr <= video_in_bus_addr ;
		// signal the bus that a read is requested
		bus_read <= 1'b1 ;	
	end
	
	// finish the  read
	// You MUST do this check
	if (state==1 && bus_ack==1) begin
		state <= 8 ; //state <= 2 ;
		bus_read <= 1'b0;
		current_pixel_color1 <= bus_read_data ;
	end
	
	// write a pixel to VGA memory
	if (state==8) begin
		state <= 10 ;
	//	bus_write <= 1'b1;
	//	bus_addr <= vga_bus_addr ;
		if (greenFlag) begin
		vga_x_cood <= 0;
		vga_y_cood <= 240;		
		//	bus_write_data <= 8'hff;
			green_count <= green_count + 1;
			//x and y position mean calculation
			x_accum <= x_accum + video_in_x_cood ;
			y_accum <= y_accum + video_in_y_cood ;	
		end
		else if (isBox) begin
			vga_x_cood <= 320;
			vga_y_cood <= 0;	
		//	bus_write_data <= 8'h1c;
		end
		else begin
			vga_x_cood <= 0;
			vga_y_cood <= 0;	
	//		bus_write_data <= current_pixel_color1  ;
		end
		bus_byte_enable <= 4'b0001;
	end
	
	if (state == 10) begin
		state <= 9;
		bus_write <= 1'b1;
		bus_addr <= vga_bus_addr ;
		if (greenFlag) begin
			bus_write_data <= 8'hff;
		end
		else if (isBox) begin	
			bus_write_data <= 8'h1c;
		end
		else begin
			bus_write_data <= current_pixel_color1  ;
		end
		bus_byte_enable <= 4'b0001;
	end
	
	// and finish write
	if (state==9 && bus_ack==1) begin
		state <= 0 ;
		bus_write <= 1'b0;
	end
	
end // always @(posedge state_clock)

//=======================================================
//  Structural coding
//=======================================================

Computer_System The_System (
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////

	// Global signals
	.system_pll_ref_clk_clk					(CLOCK_50),
	.system_pll_ref_reset_reset			(1'b0),

	// AV Config
	.av_config_SCLK							(FPGA_I2C_SCLK),
	.av_config_SDAT							(FPGA_I2C_SDAT),

	// Audio Subsystem
	.audio_pll_ref_clk_clk					(CLOCK3_50),
	.audio_pll_ref_reset_reset				(1'b0),
	.audio_clk_clk								(AUD_XCK),
	.audio_ADCDAT								(AUD_ADCDAT),
	.audio_ADCLRCK								(AUD_ADCLRCK),
	.audio_BCLK									(AUD_BCLK),
	.audio_DACDAT								(AUD_DACDAT),
	.audio_DACLRCK								(AUD_DACLRCK),

	// Slider Switches
	.slider_switches_export					(SW),
	
	// Box Coordinates
	.x_value_external_connection_export           (center_x_reg),           //      x_value_external_connection.export
	.y_value_external_connection_export           (center_y_reg),           //      y_value_external_connection.export
	.radius_value_external_connection_export      (radius_reg),      // radius_value_external_connection.export
	
	// Color Values
	.red_min_external_connection_export           (red_min_reg),           //      red_min_external_connection.export
	.green_min_external_connection_export         (green_min_reg),         //    green_min_external_connection.export
	.green_max_external_connection_export         (green_max_reg),         //    green_max_external_connection.export
	.blue_min_external_connection_export          (blue_min_reg),          //     blue_min_external_connection.export
	.blue_max_external_connection_export          (blue_max_reg),           //     blue_max_external_connection.export
	.red_max_external_connection_export           (red_max_reg),            //      red_max_external_connection.export
	
	//Output Values
			.x_accum_external_connection_export        (x_accum_tot),           //      x_accum_external_connection.export
		.y_accum_external_connection_export           (y_accum_tot),           //      y_accum_external_connection.export
		.z_accum_external_connection_export           (z_accum),            //      z_accum_external_connection.export
	
	// Pushbuttons (~KEY[3:0]),
	.pushbuttons_export						(~KEY[3:0]),

	// Expansion JP1
	//.expansion_jp1_export					({GPIO_0[35:19], GPIO_0[17], GPIO_0[15:3], GPIO_0[1]}),

	// Expansion JP2
	//.expansion_jp2_export					({GPIO_1[35:19], GPIO_1[17], GPIO_1[15:3], GPIO_1[1]}),

	// LEDs
	.leds_export								(LEDR),
	
	// Seven Segs
	.hex3_hex0_export							(hex3_hex0),
	//.hex5_hex4_export							(hex5_hex4),
	
	// PS2 Ports
	//.ps2_port_CLK								(PS2_CLK),
	//.ps2_port_DAT								(PS2_DAT),
	//.ps2_port_dual_CLK						(PS2_CLK2),
	//.ps2_port_dual_DAT						(PS2_DAT2),

	// IrDA
	//.irda_RXD									(IRDA_RXD),
	//.irda_TXD									(IRDA_TXD),

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
	
	// Video In Subsystem
	.video_in_TD_CLK27 						(TD_CLK27),
	.video_in_TD_DATA							(TD_DATA),
	.video_in_TD_HS							(TD_HS),
	.video_in_TD_VS							(TD_VS),
	.video_in_clk27_reset					(),
	.video_in_TD_RESET						(),
	.video_in_overflow_flag					(),
	
	.ebab_video_in_external_interface_address     (bus_addr),     // 
	.ebab_video_in_external_interface_byte_enable (bus_byte_enable), //  .byte_enable
	.ebab_video_in_external_interface_read        (bus_read),        //  .read
	.ebab_video_in_external_interface_write       (bus_write),       //  .write
	.ebab_video_in_external_interface_write_data  (bus_write_data),  //.write_data
	.ebab_video_in_external_interface_acknowledge (bus_ack), //  .acknowledge
	.ebab_video_in_external_interface_read_data   (bus_read_data),   
	// clock bridge for EBAb_video_in_external_interface_acknowledge
	.clock_bridge_0_in_clk_clk                    (CLOCK_50),
		
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


endmodule
