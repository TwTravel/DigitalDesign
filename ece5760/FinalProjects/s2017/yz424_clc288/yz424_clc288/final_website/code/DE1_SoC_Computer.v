/*********************************************************************************************************
Claire Chen and Mark Zhao
ECE 5760, Spring 2017

Attribution: Code modified from Altera University IP and Bruce Land Video-Input Example Code

Description: Top-level module for Candy Counter final project. Contains bus-master state machines.
*********************************************************************************************************/

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
//  PORT declarations
//=======================================================

////////////////////////////////////
// FPGA Pins
////////////////////////////////////

// Clock pins
input				CLOCK_50;
input				CLOCK2_50;
input				CLOCK3_50;
input				CLOCK4_50;

// ADC
inout				ADC_CS_N;
output				ADC_DIN;
input				ADC_DOUT;
output				ADC_SCLK;

// Audio
input				AUD_ADCDAT;
inout				AUD_ADCLRCK;
inout				AUD_BCLK;
output				AUD_DACDAT;
inout				AUD_DACLRCK;
output				AUD_XCK;

// SDRAM
output 		[12: 0]	DRAM_ADDR;
output		[ 1: 0]	DRAM_BA;
output				DRAM_CAS_N;
output				DRAM_CKE;
output				DRAM_CLK;
output				DRAM_CS_N;
inout		[15: 0]	DRAM_DQ;
output				DRAM_LDQM;
output				DRAM_RAS_N;
output				DRAM_UDQM;
output				DRAM_WE_N;

// I2C Bus for Configuration of the Audio and Video-In Chips
output				FPGA_I2C_SCLK;
inout				FPGA_I2C_SDAT;

// 40-pin headers
inout		[35: 0]	GPIO_0;
inout		[35: 0]	GPIO_1;

// Seven Segment Displays
output		[ 6: 0]	HEX0;
output		[ 6: 0]	HEX1;
output		[ 6: 0]	HEX2;
output		[ 6: 0]	HEX3;
output		[ 6: 0]	HEX4;
output		[ 6: 0]	HEX5;

// IR
input				IRDA_RXD;
output				IRDA_TXD;

// Pushbuttons
input		[ 3: 0]	KEY;

// LEDs
output		[ 9: 0]	LEDR;

// PS2 Ports
inout				PS2_CLK;
inout				PS2_DAT;

inout				PS2_CLK2;
inout				PS2_DAT2;

// Slider Switches
input		[ 9: 0]	SW;

// Video-In
input				TD_CLK27;
input		[ 7: 0]	TD_DATA;
input				TD_HS;
output				TD_RESET_N;
input				TD_VS;

// VGA
output		[ 7: 0]	VGA_B;
output				VGA_BLANK_N;
output				VGA_CLK;
output		[ 7: 0]	VGA_G;
output				VGA_HS;
output		[ 7: 0]	VGA_R;
output				VGA_SYNC_N;
output				VGA_VS;



////////////////////////////////////
// HPS Pins
////////////////////////////////////
	
// DDR3 SDRAM
output		[14: 0]	HPS_DDR3_ADDR;
output		[ 2: 0] HPS_DDR3_BA;
output				HPS_DDR3_CAS_N;
output				HPS_DDR3_CKE;
output				HPS_DDR3_CK_N;
output				HPS_DDR3_CK_P;
output				HPS_DDR3_CS_N;
output		[ 3: 0]	HPS_DDR3_DM;
inout		[31: 0]	HPS_DDR3_DQ;
inout		[ 3: 0]	HPS_DDR3_DQS_N;
inout		[ 3: 0]	HPS_DDR3_DQS_P;
output				HPS_DDR3_ODT;
output				HPS_DDR3_RAS_N;
output				HPS_DDR3_RESET_N;
input				HPS_DDR3_RZQ;
output				HPS_DDR3_WE_N;

// Ethernet
output				HPS_ENET_GTX_CLK;
inout				HPS_ENET_INT_N;
output				HPS_ENET_MDC;
inout				HPS_ENET_MDIO;
input				HPS_ENET_RX_CLK;
input		[ 3: 0]	HPS_ENET_RX_DATA;
input				HPS_ENET_RX_DV;
output		[ 3: 0]	HPS_ENET_TX_DATA;
output				HPS_ENET_TX_EN;

// Flash
inout		[ 3: 0]	HPS_FLASH_DATA;
output				HPS_FLASH_DCLK;
output				HPS_FLASH_NCSO;

// Accelerometer
inout				HPS_GSENSOR_INT;

// General Purpose I/O
inout		[ 1: 0]	HPS_GPIO;

// I2C
inout				HPS_I2C_CONTROL;
inout				HPS_I2C1_SCLK;
inout				HPS_I2C1_SDAT;
inout				HPS_I2C2_SCLK;
inout				HPS_I2C2_SDAT;

// Pushbutton
inout				HPS_KEY;

// LED
inout				HPS_LED;

// SD Card
output				HPS_SD_CLK;
inout				HPS_SD_CMD;
inout		[ 3: 0]	HPS_SD_DATA;

// SPI
output				HPS_SPIM_CLK;
input				HPS_SPIM_MISO;
output				HPS_SPIM_MOSI;
inout				HPS_SPIM_SS;

// UART
input				HPS_UART_RX;
output				HPS_UART_TX;

// USB
inout				HPS_CONV_USB_N;
input				HPS_USB_CLKOUT;
inout		[ 7: 0]	HPS_USB_DATA;
input				HPS_USB_DIR;
input				HPS_USB_NXT;
output				HPS_USB_STP;



//=======================================================
//  local parameters
//=======================================================

localparam			SE_DELTA = 3;
localparam			COLS		= 320;
localparam			ROWS 		= 240;


//=======================================================
//  REG/WIRE declarations
//=======================================================

wire 		[15: 0]	hex3_hex0;

assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;

HexDigit Digit0(HEX0, state[3:0]);
HexDigit Digit1(HEX1, {3'd0,state[4]});
HexDigit Digit2(HEX2, test_counter);
HexDigit Digit3(HEX3, hex3_hex0[15:12]);

// MAY need to cycle this switch on power-up to get video
assign TD_RESET_N = SW[1];

//=======================================================
// PWM Controller for Servo
//=======================================================
wire [31:0] high_cycle;
wire [31:0] low_cycle;
reg [31:0] pwm_counter;
reg pwm_state;

assign low_cycle = 32'd1000000;
assign GPIO_1[9] = pwm_state;

always @(posedge CLOCK2_50) begin
	if(~KEY[0]) begin
		pwm_state <= 0;
		pwm_counter <= 0;
		timer <= 0;
	end
	else begin
		timer 							<= timer + 1; 	// timer is always incrementing if not in
	end
	
	
	if(pwm_state == 1'b0) begin  //The output is low
		pwm_counter <= pwm_counter + 1;
		if(pwm_counter >= low_cycle) begin //Toggle it once we reach 20ms
			pwm_state <= 1'b1;
			pwm_counter <= 32'd0;
		end
	end
	else begin  //The output is high
		pwm_counter <= pwm_counter + 1;
		if(pwm_counter >= high_cycle) begin //Toggle it once we hit the high time limit
			pwm_state <= 1'b0;
			pwm_counter <= 32'd0;
		end
	end
	
end

//=======================================================
// Bus controller for AVALON bus-master
//=======================================================
wire 		[31:0] vga_bus_addr, video_in_bus_addr ; // Avalon addresses
wire 		[31:0] vga_bus_addr_from_RAM;
wire 		[31:0] vga_bus_addr_from_eroded_RAM;
wire 		[31:0] vga_bus_addr_from_opened_RAM;
wire 		[31:0] vga_bus_addr_from_processed_RAM;
reg  		[31:0] bus_addr ;
wire 		[31:0] vga_out_base_address = 32'h0000_0000 ;  // Avalon address
wire 		[31:0] video_in_base_address = 32'h0800_0000 ;  // Avalon address
reg 		[3:0]  bus_byte_enable ; // four bit byte read/write mask
reg 			   bus_read  ;       // high when requesting data
reg 			   bus_write ;      //  high when writing data
reg 		[31:0] bus_write_data ; //  data to send to Avalon bus
wire 			   bus_ack  ;       //  Avalon bus raises this when done
wire 		[31:0] bus_read_data ; // data from Avalon bus
reg 		[31:0] timer ;
reg 		[4:0]  state ;
reg 			   last_vs, wait_one;
reg 		[19:0] vs_count ;
reg 			   last_hs, wait_one_hs ;
reg 		[19:0] hs_count ;

// pixel coordinates for video-input and vga addresses
reg 		[9:0] vga_x_coord, vga_y_coord, video_in_x_coord, video_in_y_coord ;


// compute VGA addresses:
assign vga_bus_addr = vga_out_base_address + (({22'b0,video_in_x_coord + vga_x_coord} + ({22'b0,video_in_y_coord + vga_y_coord}<<10)) << 1);
assign video_in_bus_addr = video_in_base_address + (({22'b0,video_in_x_coord} + ({22'b0,video_in_y_coord}<<9)) << 1);	 
assign vga_bus_addr_from_RAM = vga_out_base_address + (({22'b0,video_in_x_coord + 10'd320} + ({22'b0,video_in_y_coord + vga_y_coord}<<10)) << 1);
assign vga_bus_addr_from_eroded_RAM = vga_out_base_address + (({22'b0,eroded_x_coord + 10'd0} + ({22'b0,eroded_y_coord + 240}<<10)) << 1) ;
assign vga_bus_addr_from_opened_RAM = vga_out_base_address + (({22'b0,opened_x_coord + 10'd320} + ({22'b0, opened_y_coord + 240}<<10)) << 1) ;
assign vga_bus_addr_from_processed_RAM = vga_out_base_address + (({22'b0,display_x_coord + 10'd320} + ({22'b0, display_y_coord + 240}<<10)) << 1) ;
// RAM addresses
assign color_RAM_write_address_wire = (video_in_x_coord) + (video_in_y_coord * 320);


reg 		[15:0] current_pixel_color;

// signals to and from color RAM (color RAM stores 5-color image)
wire 		[3:0]  color_RAM_data_out;
wire 		[19:0] color_RAM_write_address_wire;
reg 		[3:0]  color_RAM_data_in;
reg 		[19:0] color_RAM_write_address;
reg 		[19:0] color_RAM_read_address;
reg 		 	 	 color_RAM_we;

// signals to and from the eroded RAM
wire 		[3:0]  eroded_RAM_data_out;
wire 		[19:0] eroded_RAM_write_address_wire;
wire 	 	[3:0]  eroded_RAM_data_in;
reg 		[19:0] eroded_RAM_read_address;
reg 		[19:0] eroded_RAM_write_address;
reg 			   eroded_RAM_we;

// signals to and from the opened RAM
wire 		[3:0]  opened_RAM_data_out;
wire 		[19:0] opened_RAM_write_address_wire;
wire 	 	[3:0]  opened_RAM_data_in;
reg 		[19:0] opened_RAM_read_address;
reg 		[19:0] opened_RAM_write_address;
reg 			   opened_RAM_we;

// signals for erosion and opening
reg 			   edge_of_image;
reg 			   edge_of_image_opening;
reg 			   enable_opening;
reg 			   done_opening;
reg 			   enable_opening_ack; // from opening FSM
reg				   done_opening_ack; // from main FSM, after recieving done_opening 
reg 		[3:0]  opening_state;


// combinational logic for computing eroded and opened pixels based on SE bit vector
assign eroded_RAM_data_in = (edge_of_image) ? 4'b0 : 
							  (&(SE_erosion)) ? color_RAM_data_out :
							  4'b0;

assign opened_RAM_data_in = (edge_of_image_opening) ? 4'b0 : 
							  (|(SE_opening)) ? opening_pixel_color :
							  4'b0;


// wires from parallel io ports for color thresholds
wire 		[15:0] red_high, green_high, orange_high, yellow_high, purple_high;
wire 		[15:0] red_low, green_low, orange_low, yellow_low, purple_low;

// flags for specifying color (1 if true, 0 if false)
wire 			   is_red, is_green, is_orange, is_yellow, is_purple;

// combination block to perform all color thresholding
color_thresholds color_thresholds(
	.red_high(red_high),
	.red_low(red_low),
	.green_high(green_high),
	.green_low(green_low),
	.orange_high(orange_high),
	.orange_low(orange_low),
	.yellow_high(yellow_high),
	.yellow_low(yellow_low),
	.purple_high(purple_high),
	.purple_low(purple_low),
	.current_pixel_color(current_pixel_color),
	.is_red(is_red),
	.is_green(is_green),
	.is_orange(is_orange),
	.is_yellow(is_yellow),
	.is_purple(is_purple)
);

// RAM to hold video-in data (endoded with only 5 colors) from on-chip SRAM
vga_buffer #(.DATA_WIDTH(4)) color_RAM(	// single clock dual-port RAM
	.q(color_RAM_data_out),
	.d(color_RAM_data_in),
	.write_address(color_RAM_write_address),
	.read_address(color_RAM_read_address),
	.we(color_RAM_we),
	.clk(CLOCK2_50)
);

// RAM to hold eroded image (with all 5 colors)
vga_buffer #(.DATA_WIDTH(4)) eroded_RAM(	// single clock dual-port RAM
	.q(eroded_RAM_data_out),
	.d(eroded_RAM_data_in),
	.write_address(eroded_RAM_write_address),
	.read_address(eroded_RAM_read_address),
	.we(eroded_RAM_we),
	.clk(CLOCK2_50)
);

// RAM for opened (eroded then dilated) image
vga_buffer #(.DATA_WIDTH(4)) opened_RAM(	// single clock dual-port RAM
	.q(opened_RAM_data_out),
	.d(opened_RAM_data_in),
	.write_address(opened_RAM_write_address),
	.read_address(opened_RAM_read_address),
	.we(opened_RAM_we),
	.clk(CLOCK2_50)
);

// Wires and modules to decode 4 bit color from RAM into 16-bit color for VGA
wire 		[15:0] decoded_color_from_RAM;
wire        [15:0] decoded_color_from_eroded_RAM;
wire        [15:0] decoded_color_from_opened_RAM;

color_from_RAM_decoder color_decoder(
	.color_from_RAM(color_RAM_data_out),
	.decoded_color(decoded_color_from_RAM)
);

color_from_RAM_decoder color_from_eroded_RAM_decoder(
	.color_from_RAM(eroded_RAM_data_out),
	.decoded_color(decoded_color_from_eroded_RAM)
);

color_from_RAM_decoder color_from_opened_RAM_decoder(
	.color_from_RAM(opened_RAM_data_out),
	.decoded_color(decoded_color_from_opened_RAM)
);

// Coordinates for eroded_RAM
reg 		[9:0]  eroded_x_coord, eroded_y_coord;

// Coordinates for opened_RAM
reg 		[9:0]  opened_x_coord, opened_y_coord;

// Coordinates for processed image to be displayed on VGA
reg     	[9:0]  display_x_coord, display_y_coord;

// Structural element (SE) registers
reg 		[48:0] SE_erosion;
reg 		[7:0]  SE_erosion_index;
reg 		[19:0] SE_erosion_x_coord;
reg 		[19:0] SE_erosion_y_coord;

reg 		[48:0] SE_opening;
reg 		[7:0]  SE_opening_index;
reg 		[19:0] SE_opening_x_coord;
reg 		[19:0] SE_opening_y_coord;
reg      	[15:0] opening_pixel_color;

// For testing
reg 		[5:0] test_counter;


///=======================================================
//  Primary State Machine
//  	- VGA writes
//		- Reading video input
// 		- Erosion
//=======================================================

always @(posedge CLOCK2_50) begin //CLOCK_50

	// reset state machine and read/write controls
	if (~KEY[0]) begin
		state 						<= 0 ;
		bus_read 					<= 0 ;			// set to one if a read opeation from bus
		bus_write 					<= 0 ; 			// set to on if a write operation to bus
		vga_x_coord 				<= 10'd0 ;		// base x coord of upper-left corner of the screen
		vga_y_coord 				<= 10'd0 ;		// base y coord of upper-left corner of the screen
		video_in_x_coord 			<= 0 ;
		video_in_y_coord 			<= 0 ;
	   bus_byte_enable 			<= 4'b0011;


		color_RAM_data_in 			<= 0;
		color_RAM_write_address 	<= 0;
		color_RAM_read_address 		<= 0;
		color_RAM_we 					<= 0;

		
		eroded_RAM_write_address 	<= 0;
		eroded_RAM_we 					<= 0;

		SE_erosion 					<= 0;
		SE_erosion_index 			<= 0;
		SE_erosion_x_coord 			<= 0;
		SE_erosion_y_coord 			<= 0;


		eroded_x_coord				<= 0;
		eroded_y_coord 				<= 0;
		
		display_x_coord			<= 0;
		display_y_coord 			<= 0;

		edge_of_image 				<= 0;

		enable_opening 				<= 0;
		done_opening_ack 				<= 0;
		opened_RAM_read_address 	<= 0;
	end

	// write to the bus-master
	// and put in a small delay to aviod bus hogging
	// timer delay can be set to 2**n-1, so 3, 7, 15, 31
	// bigger numbers mean slower frame update to VGA
	else if (state == 0 && SW[0] && (timer & 15) == 0 ) begin //
		
		// read next pixel in frame of the video input
		if (video_in_x_coord > 10'd319) begin
			video_in_x_coord 		<= 0 ;
			if (video_in_y_coord > 10'd239) begin
				video_in_y_coord	<= 10'd0 ; 
				state 				<= 7; // have reached the end of a frame, now we process this frame
				bus_read 			<= 1'b0;
			end
			else begin
				video_in_y_coord 	<= video_in_y_coord + 10'd1 ;
				state 				<= 1;
				// signal the bus that a read is requested
				bus_read 			<= 1'b1 ;	
			end
		end
		else begin
			video_in_x_coord 		<= video_in_x_coord + 10'd1 ;
			state 					<= 1;
			// signal the bus that a read is requested
			bus_read 				<= 1'b1 ;	
		end
		
		// one byte data
		bus_byte_enable 		<= 4'b0011;
		// read first pixel
		bus_addr 				<= video_in_bus_addr;
		eroded_x_coord 		<= 10'b0;
		eroded_y_coord  		<= 10'b0;
		
	end
	
	// wait for bus_ack and finish the read
	else if (state == 1 && bus_ack == 1) begin
		state 					<= 2 ; 
		bus_read 				<= 1'b0;
		current_pixel_color 	<= bus_read_data ;
	end
	
	// write a pixel to VGA memory and also video-in RAM
	else if (state == 2) begin
		state 					<= 3;
		bus_write 				<= 1'b1;
		bus_addr 				<= vga_bus_addr ;
		bus_write_data 		<= current_pixel_color ;
		bus_byte_enable 		<= 4'b0011;
		
		// also write the encoded color video-in RAM
		color_RAM_we 			<= 1'b1;
		color_RAM_write_address <= color_RAM_write_address_wire;
		color_RAM_read_address 	<= color_RAM_write_address_wire;
		
		if (is_red == 1'b1) begin
			color_RAM_data_in 	<= 4'h1;
		end
		else if (is_green == 1'b1) begin
			color_RAM_data_in 	<= 4'h2;
		end 
		else if (is_orange == 1'b1) begin
			color_RAM_data_in 	<= 4'h3;
		end
		else if (is_yellow == 1'b1) begin
			color_RAM_data_in 	<= 4'h4;
		end
		else if (is_purple == 1'b1) begin
			color_RAM_data_in 	<= 4'h5;
		end
		else begin
			color_RAM_data_in 	<= 4'h0;
		end
	end
	
	else if(state == 3) begin
		color_RAM_we 			<= 1'b0;
		if(bus_ack == 1) begin
			state 				<= 5;
			bus_write 			<= 1'b0; //just in case bus_ack finishes in 1 cycle
			
		end
		else begin
			state 				<= 4;
		end
	end
	
	// Finish write to VGA SDRAM from SRAM
	else if (state == 4 && bus_ack==1) begin
		state 					<= 5;
		bus_write 				<= 1'b0;
	end
	
	// Next, write video-in data from color_RAM block to VGA
	else if (state == 5) begin
		state 					<= 6 ;
		bus_write 				<= 1'b1;
		bus_addr 				<= vga_bus_addr_from_RAM ;
		bus_write_data 		<= decoded_color_from_RAM;
		bus_byte_enable 		<= 4'b0011;
	end
	
	// Finish write to VGA SDRAM from RAM
	else if (state == 6 && bus_ack==1) begin
		state 					<= 0 ;
		bus_write 				<= 1'b0;
	end

	// do the image processing starting in this state, after one complete frame read from video input
	else if (state == 7) begin
		// Increment to next pixel in eroded_RAM
		done_opening_ack <= 0;
		if (eroded_x_coord > 10'd319) begin
			eroded_x_coord 			<= 0 ;
			if (eroded_y_coord > 10'd239) begin // done reading one frame
				eroded_y_coord 		<= 10'd0 ; 
				//Done eroding one frame. Go to state 13 where we wait for opoening to be done
				state <= 5'd13;
			end
			else begin
				eroded_y_coord 		<= eroded_y_coord + 10'd1 ;
				state 				<= 8;
			end
		end
		else begin
			eroded_x_coord 			<= eroded_x_coord + 10'd1;
			state 					<= 8;
		end

		if (eroded_x_coord > 7 && eroded_y_coord > 7) begin //Signal the other state machine to start.
			enable_opening 			<= 1'b1;
		end
	end

	// check pixel to see if it's at the edge, or compute the top-left pixel of SE
	else if (state == 8) begin
		if (eroded_x_coord < SE_DELTA || eroded_x_coord >= COLS-SE_DELTA || 
				 eroded_y_coord < SE_DELTA || eroded_y_coord >= ROWS-SE_DELTA ) begin
				//eroded_RAM_data_in 		<= 4'h0;
			edge_of_image 			<= 1'b1;
			state 					<= 11;
		end
		else begin
			SE_erosion_x_coord		<= eroded_x_coord - SE_DELTA;
			SE_erosion_y_coord 		<= eroded_y_coord - SE_DELTA;
			SE_erosion_index 		<= 0;
			state 					<= 9;
			edge_of_image 			<= 1'b0;
		end	
	end
	// now, read all of the pixels in the structural element
	else if (state == 9) begin
		color_RAM_read_address <= (SE_erosion_x_coord) + (SE_erosion_y_coord * 320);
		// need to read each pixel and store into bit vector, one read per cycle
		if(SE_erosion_x_coord < eroded_x_coord + SE_DELTA) begin
			SE_erosion_x_coord  	<= SE_erosion_x_coord + 1;
			SE_erosion_y_coord 		<= SE_erosion_y_coord;
			state 					<= 10;
		end
		else begin
			SE_erosion_x_coord  	<= eroded_x_coord - SE_DELTA;
			if(SE_erosion_y_coord < eroded_y_coord + SE_DELTA) begin
				SE_erosion_y_coord  <= SE_erosion_y_coord + 1;
				state 				<= 10;
			end
			else begin
				SE_erosion_y_coord 	<= eroded_y_coord - SE_DELTA;
				state 				<= 10;
			end
		end
	end

	// put pixel value into corresponding bit in bit vector
	else if (state == 10) begin
		if (color_RAM_data_out == 4'h0) begin
			SE_erosion[SE_erosion_index] 	<= 1'b0;
		end
		else begin
			SE_erosion[SE_erosion_index]	<= 1'b1;
		end

		if(SE_erosion_index <= 8'd47)begin
			SE_erosion_index 		<= SE_erosion_index + 1;
			state 				<= 9;
		end
		else begin
			SE_erosion_index 		<= SE_erosion_index;
			state 				<= 11;
			color_RAM_read_address <= (eroded_x_coord) + (eroded_y_coord * 320);
		end
	end
	
	else if (state == 11) begin
		state 						<= 12;
		eroded_RAM_we 				<= 1'b1;
		eroded_RAM_write_address 	<= (eroded_x_coord) + (eroded_y_coord * 320);
	end

	else if (state == 12) begin
		eroded_RAM_we         		<= 1'b0;
		state 				 	    <= 7;
	end

	else if (state == 13) begin // wait for opening to be done
		enable_opening <= 1'b0; //The opening loop already started, pull it low now and let it run.
		if (done_opening == 1'b1) begin
			state <= 14;
			done_opening_ack <= 1'b1;
			//enable_opening    		<= 1'b0;
		end
		else begin
			state <= 13; //Wait here until opening is done.
			//enable_opening    		<= 1'b1;
		end
	end
	
	// Draw image once finished opening a frame
	else if (state == 14) begin
		done_opening_ack 				<= 0;
		enable_opening 				<= 0;
		if (display_x_coord > 10'd319) begin
			display_x_coord 			<= 0 ;
			if (display_y_coord > 10'd239) begin // done displaying one frame
				display_y_coord 		<= 10'd0 ; 
				state 					<= 0;
			end
			else begin
				display_y_coord 		<= display_y_coord + 10'd1 ;
				state 				<= 15;
			end
		end
		else begin
			display_x_coord 			<= display_x_coord + 10'd1;
			state 					<= 15;
		end
		
		opened_RAM_read_address 	<= (display_x_coord) + (display_y_coord * 320);
	end
	
	// timer for VGA throttle
	else if (state == 15) begin
		if ((timer & 15) == 0) begin
			state 			<= 16;
		end
		else begin
			state 			<= 15;
		end
	end
	
	else if (state == 16) begin
		bus_write_data 			<= decoded_color_from_opened_RAM;
				
		state 					<= 17;
		
		bus_write				<= 1'b1;
		bus_addr 				<= vga_bus_addr_from_processed_RAM;
	end

	else if (state == 17 && bus_ack==1) begin
		state 					<= 14;
		bus_write 				<= 1'b0;
	end
	
	else begin
		state <= state;
	end
end // always @(posedge state_clock) main FSM



//=======================================================
//  Secondary (Opening) State Machine
//=======================================================

always @ (posedge CLOCK2_50) begin
	if (~KEY[0]) begin
		opened_RAM_write_address 		<= 0;
		opened_x_coord					<= 0;
		opened_y_coord 					<= 0;
		done_opening					<= 0;
		opening_state   				<= 4'd7;
		done_opening 					<= 0;
		edge_of_image_opening 			<= 0;
		SE_opening 						<= 0;
		SE_opening_index 				<= 0;
		SE_opening_x_coord 				<= 0;
		SE_opening_y_coord 				<= 0;
		eroded_RAM_read_address 		<= 0;
				
		test_counter					<= 0;
	
		opened_RAM_we 					<= 0;
	end
	else if(opening_state == 4'd7) begin //Wait until we get an enable signal before starting
		if(enable_opening == 1'b1) begin
			opening_state <= 4'd0;
		end
		else begin
			opening_state <= 4'd7;
		end
	end
	else if (opening_state == 0) begin
		// Iterate through all pixels of a frame, again, to open	
		if (opened_x_coord > 10'd319) begin
			opened_x_coord 			<= 10'd0 ;
			if (opened_y_coord > 10'd239) begin
				opened_y_coord 		<= 10'd0 ; 
				opening_state 		<= 6; // done opening one frame, now read in new frame from video-in\
				done_opening <= 1'd1; //We're done opening one frame. signal to the other FSM.
			end
			else begin
				opened_y_coord 		<= opened_y_coord + 10'd1 ;
				opening_state 		<= 1;
			end
		end
		else begin
			opened_x_coord 			<= opened_x_coord + 10'd1;
			opening_state 			<= 1;
		end
	end

	else if (opening_state == 1) begin
		if (opened_x_coord < SE_DELTA || opened_x_coord >= COLS-SE_DELTA || 
				 opened_y_coord < SE_DELTA || opened_y_coord >= ROWS-SE_DELTA ) begin
			edge_of_image_opening 	<= 1'b1;
			opening_state 			<= 4;
		end
		else begin
			SE_opening_x_coord		<= opened_x_coord - SE_DELTA;
			SE_opening_y_coord 		<= opened_y_coord - SE_DELTA;
			SE_opening_index 		<= 0;
			opening_state 			<= 2;
			edge_of_image_opening 	<= 1'b0;
		end
	end

	else if (opening_state == 2) begin
		eroded_RAM_read_address 	<= (SE_opening_x_coord) + (SE_opening_y_coord * 320);
		// need to read each pixel and store into bit vector, one read per cycle
		if(SE_opening_x_coord < opened_x_coord + SE_DELTA) begin
			SE_opening_x_coord  	<= SE_opening_x_coord + 1;
			SE_opening_y_coord 		<= SE_opening_y_coord;
			opening_state 			<= 3;
		end
		else begin
			SE_opening_x_coord  	<= opened_x_coord - SE_DELTA;
			if(SE_opening_y_coord < opened_y_coord + SE_DELTA) begin
				SE_opening_y_coord  <= SE_opening_y_coord + 1;
				opening_state 		<= 3;
			end
			else begin
				SE_opening_y_coord 	<= opened_y_coord - SE_DELTA;
				opening_state 		<= 3;
			end
		end
	end

	else if (opening_state == 3) begin
			
		if (eroded_RAM_data_out == 4'h0) begin
			SE_opening[SE_opening_index] 		<= 1'b0;
		end
		else begin
			SE_opening[SE_opening_index]		<= 1'b1;
			opening_pixel_color 				<= eroded_RAM_data_out;
		end
				
		if(SE_opening_index <= 8'd47)begin
			SE_opening_index 					<= SE_opening_index + 1;
			opening_state 						<= 2;
		end
		else begin
			SE_opening_index 					<= SE_opening_index;
			opening_state 						<= 4;
		end
				
				
		if(SW[8]) begin
			if(SE_opening_index == 8'd48) begin
				test_counter <= test_counter + 1;
			end
			else begin
				test_counter <= test_counter;
			end
		end
		else begin
			if(SE_opening_index == 8'd47) begin
				test_counter <= test_counter + 1;
			end
			else begin
				test_counter <= test_counter;
			end 
		end
	end

	else if (opening_state == 4) begin
		opening_state 				<= 5;
		opened_RAM_we 				<= 1'b1;
		opened_RAM_write_address 	<= (opened_x_coord) + (opened_y_coord * 320);
	end

	else if (opening_state == 5) begin
		opened_RAM_we         			<= 1'b0;
		opening_state 					<= 0;
	end
			
	else if (opening_state == 6) begin //Wait in this state until we get an ack.
		if(done_opening_ack == 1'd1) begin
			done_opening 	<= 1'd0;
			opening_state 	<= 4'd7; //Once we get an ack, go back to the initial state where we wait for enable signal again.
		end
		else begin
			done_opening 	<= 1'd1;
			opening_state 	<= 6;
		end
	end
	else begin
		opening_state <= opening_state;
	end
end // always block for opening state machine


//=======================================================
//  Structural coding
//=======================================================

Computer_System The_System (
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////

	// Global signals
	.system_pll_ref_clk_clk					(CLOCK_50),
	.system_pll_ref_reset_reset				(1'b0),

	// AV Config
	.av_config_SCLK							(FPGA_I2C_SCLK),
	.av_config_SDAT							(FPGA_I2C_SDAT),

	// Slider Switches
	.slider_switches_export					(SW),

	// Pushbuttons (~KEY[3:0]),
	.pushbuttons_export						(~KEY[3:0]),

	// LEDs
	.leds_export								(LEDR),
	
	// Seven Segs
	.hex3_hex0_export							(hex3_hex0),

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
	.hps_io_hps_io_usb1_inst_NXT		(HPS_USB_NXT),
	
	//  PARALLEL IO
	.red_high_parallel_port_external_interface_export (red_low), // red_high_parallel_port_external_interface.export
	.red_low_parallel_port_external_interface_export  (red_high),   //  red_low_parallel_port_external_interface.export
	.green_high_parallel_port_external_interface_export  (green_high),  //  green_high_parallel_port_external_interface.export
	.green_low_parallel_port_external_interface_export   (green_low),   //   green_low_parallel_port_external_interface.export
	.orange_high_parallel_port_external_interface_export (orange_high), // orange_high_parallel_port_external_interface.export
	.orange_low_parallel_port_external_interface_export  (orange_low),  //  orange_low_parallel_port_external_interface.export
	.yellow_high_parallel_port_external_interface_export (yellow_high), // yellow_high_parallel_port_external_interface.export
	.yellow_low_parallel_port_external_interface_export  (yellow_low),  //  yellow_low_parallel_port_external_interface.export
	.purple_parallel_port_high_external_interface_export (purple_high), // purple_parallel_port_high_external_interface.export
	.purple_low_parallel_port_external_interface_export  (purple_low),   //  purple_low_parallel_port_external_interface.export
	.pwm_timer_external_interface_export                 (high_cycle)//pwm_timer_external_interface.export
	);


endmodule
