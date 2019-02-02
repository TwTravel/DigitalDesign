module full_cpu (
    // Clock Input
    input         CLOCK_27,    // 27 MHz
    input         CLOCK_50,    // 50 MHz
    input         EXT_CLOCK,   // External Clock
    // Push Button
    input  [3:0]  KEY,         // Pushbutton[3:0]
    // DPDT Switch
    input  [17:0] SW,          // Toggle Switch[17:0]
    // 7-SEG Dispaly
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

// Turn on all display
assign HEX0      = 7'h00;
assign HEX1      = 7'h00;
assign HEX2      = 7'h00;
assign HEX3      = 7'h00;
assign HEX4      = 7'h00;
assign HEX5      = 7'h00;
assign HEX6      = 7'h00;
assign HEX7      = 7'h00;
//assign LEDR      = 18'h00000;
//assign LEDG      = 9'h1FF;
assign LCD_ON    = 1'b1;
assign LCD_BLON  = 1'b1;

// All inout port turn to tri-state
assign DRAM_DQ   = 16'hzzzz;
assign FL_DQ     = 8'hzz;
assign SRAM_DQ   = 16'hzzzz;
assign OTG_DATA  = 16'hzzzz;
assign LCD_DATA  = 8'hzz;
assign SD_DAT    = 1'bz;
assign ENET_DATA = 16'hzzzz;
assign GPIO_0    = 36'hzzzzzzzzz;
assign GPIO_1    = 36'hzzzzzzzzz;

///////////////////////////////////////////////////////////////////////////////
// PROJECT NAME
///////////////////////////////////////////////////////////////////////////////
//state machine reset, aka system_reset
wire state_reset;
assign state_reset = ~KEY[0];

//BRC CPU signals
wire debug_clk, ext_clk, int_clk, ext_adc_clk;
reg reset, clk_reset, cont_en_f, scan_en_f, scan_in_f;
wire scan_out;
reg clk_scan_en_f, clk_scan_in_f;
wire clk_scan_out;
reg sc_over_f, reset_br_f;
wire ready;
wire [`DADDR_WIDTH-2:0] cont_addr_f;
reg [`DATA_WIDTH-1:0] cont_wdata_f;
wire [`DATA_WIDTH-1:0] cont_rdata;
wire  chip_en = 1'b1;
reg cont_rw_sel_f;
wire cont_di_sel_f;
reg cont_c_en_f;
reg	clk_sel, adc_clk_sel;
reg adc_in,adc_cnt;
wire VSS, VDD;

//Assign ADC
always @(posedge int_clk) begin
	adc_cnt = ~adc_cnt;
	if(adc_cnt == 1)
		adc_in = ~adc_in;
end

//NIOS control signals
wire nios_boot;
assign nios_boot = SW[0];
wire nios_cont_c_en_f;
wire continueboot = SW[1];

// Assign Clocks
wire nios_clk;

clk_pll	clk_pll_inst (
	.inclk0 (CLOCK_50),
	.c0 (DRAM_CLK),
	.c1 (int_clk),
	.c2 (nios_clk)
	);

assign ext_clk = int_clk;
assign debug_clk = int_clk; //SW[17];
assign ext_adc_clk = 1'b0;


// Assign Rails
assign VSS = 1'b1;
assign VDD = 1'b1;


// Boot sequence state machine
reg [5:0] state;
parameter boot0 = 6'd0, boot1 = 6'd1, boot2 = 6'd2, boot3 = 6'd3;
parameter boot4 = 6'd4, boot5 = 6'd5, boot6 = 6'd6, boot7 = 6'd7;
parameter boot8 = 6'd8, boot9 = 6'd9, boot10 = 6'd10, boot11 = 6'd11;
parameter boot12 = 6'd12, boot13 = 6'd13, boot14 = 6'd14, boot15 = 6'd15;
parameter debug0 = 6'd16, debug1 = 6'd17, debug2 = 6'd18, debug3 = 6'd19;
parameter debug4 = 6'd20, debug5 = 6'd21, debug6 = 6'd22, debug7 = 6'd23;
parameter debug8 = 6'd24, debug9 = 6'd25, debug10 = 6'd26, debug11 = 6'd27;
parameter debug12 = 6'd28, debug13 = 6'd29, debug14 = 6'd30, debug15 = 6'd31;
parameter readmem0 = 6'd32, readmem1 = 6'd33, readmem2 = 6'd34, readmem3 = 6'd35;
parameter restart0 = 6'd36, restart1 = 6'd37, restart2 = 6'd38, restart3 = 6'd39;
parameter restart4 = 6'd40, restart5 = 6'd41, restart6 = 6'd42, restart7 = 6'd43;


//Scan Chain
reg [8:0] clk_scan;


always @ (posedge int_clk)
begin
	if(state_reset)
	begin
		state				<= boot0;
		trigger 			<= 1'b0;
	end
	else
	begin
		case(state)
		boot0:  begin
					reset            	   	<= 1'b1;
					clk_reset               <= 1'b1;
					cont_en_f               <= 1'b1;
					scan_en_f               <= 1'b0;
					scan_in_f               <= 1'b0;
					clk_scan_en_f  		  	<= 1'b0;
					clk_scan_in_f   		<= 1'b0;
					sc_over_f               <= 1'b0;
					reset_br_f              <= 1'b0;
					//cont_addr_f             <= 13'h0;
					cont_wdata_f   		   	<= 16'h0;
					cont_rw_sel_f  		   	<= 1'b1;
					//cont_di_sel_f   		<= 1'b0;
					cont_c_en_f             <= 1'b0;
					clk_sel                 <= 1'b0;
					adc_clk_sel             <= 1'b0;
					if(nios_boot)
						state				<= boot1;	
					else
						state				<= boot0;
			   end
		boot1: begin
					//initialize clock state machine
					clk_reset				<= 1'b0;
					state				  	<= boot2;
			   end
		boot2: begin
					//wait one cycle
					state				  	<= boot3;
			   end
		boot3: begin
					//START THE PROGRAM
					//give core control of memory
					//if(nios_cont_c_en_f)
					if(1)
						begin
						cont_c_en_f             <= 1'b1;
						state				  	<= boot4;
						end
					else
					begin
						state				  	<= boot3;
					end
			   end
		boot4: begin
					//wait one cycle
					state				  	<= boot5;					
			   end
		boot5: begin
					//stop reseting the registers
					reset            	   	<= 1'b0;
					state				  	<= boot6;
			   end
		boot6: begin
					//wait one cycle
					state				  	<= boot7;
			   end	 
		boot7: begin
					//reset break, turns break off
					reset_br_f       		<= 1'b1;
					state				  	<= boot8;

			   end	
		boot8: begin
					//wait one cycle
					state				  	<= boot9;
			   end	
		boot9: begin
					//wait for ready to deassert
					//deassert reset_br_f
					if(~ready)
					begin
						//if(continueboot)begin
						reset_br_f       	<= 1'b0;
						state				<= boot10;
						trigger 			<= 1'b1;
						//end
					end
					else
					begin
						state				<= boot9;						
					end	
				end	
		boot10: begin
					//wait one cycle
					state				  	<= boot11;
			   end
		boot11: begin
					//wait one cycle
					state				  	<= boot12;
			   end
		boot12: begin
					//wait one cycle
					state				  	<= boot13;
			   end			   
		boot13: begin
					//wait one cycle
					state				  	<= boot14;
			   end
		boot14: begin
					//wait one cycle
					state				  	<= boot15;
			   end
		boot15: begin
					//wait one cycle
					state				  	<= debug0;
					trigger 				<= 1'b0;
			   end			   			   			   
		//ENTER DEBUG MODE
		debug0: begin
					//wait for ready to be asserted
					if(ready)
					begin
						state				<= debug1;
					end
					else
					begin
						state				<= debug0;
					end
			   end
		debug1: begin
					//deassert cont_en_f
					cont_en_f				<= 1'b0;
					//SKIP scan chain for now
					state				  	<= readmem0;
					
			   end
		debug2: begin
					//wait one cycle
					state				  	<= debug3;
			   end
		debug3: begin
					//ENABLE CLOCK SCAN CHAIN
					//clk_scan_en_f			<= 1'b1;
					clk_scan[8]				<= clk_scan_out;
					state				  	<= debug4;
			   end
		debug4: begin
					clk_scan[7]				<= clk_scan_out;
					state				  	<= debug5;
			   end
		debug5: begin
					clk_scan[6]				<= clk_scan_out;
					state				  	<= debug6;
			   end			   
		debug6: begin
					clk_scan[5]				<= clk_scan_out;
					state				  	<= debug7;
			   end			   
		debug7: begin
					clk_scan[4]				<= clk_scan_out;
					state				  	<= debug8;
			   end			   
		debug8: begin
					clk_scan[3]				<= clk_scan_out;
					state				  	<= debug9;
			   end
		debug9: begin
					clk_scan[2]				<= clk_scan_out;
					state				  	<= debug10;
			   end
		debug10: begin
					clk_scan[1]				<= clk_scan_out;
					state				  	<= debug11;
			   end			   
		debug11: begin
					clk_scan[0]				<= clk_scan_out;
					state				  	<= debug12;
			   end			   
		debug12: begin
					//FINISHED READING SCAN
					clk_scan_en_f			<= 1'b0;
			   end
		readmem0: begin
					if(~nios_cont_c_en_f)
					begin
					cont_c_en_f             <= nios_cont_c_en_f;
					state					<= readmem1;
					end
					else
					begin
					state					<= readmem0;
					end
			   end	
		readmem1: begin
					if(nios_cont_c_en_f)
					begin
					cont_c_en_f             <= nios_cont_c_en_f;
					state					<= restart0;
					end
					else
					begin
					state					<= readmem1;
					end					
			   end
		restart0: begin
			   		//wait one cycle
					state				  	<= restart1;					
			   end	
		restart1: begin
			   		//reset = 0
					reset				  	<= 1'b0;
					state				  	<= restart2;					
			   end
		restart2: begin
			   		//wait one cycle
					state				  	<= restart3;
					
			   end
		restart3: begin
					//reset break, turns break off
					reset_br_f       		<= 1'b1;
					state				  	<= restart4;					
			   end			   
		restart4: begin
			   		//wait one cycle
					state				  	<= restart5;
					
			   end
		restart5: begin
					//wait for ready to deassert
					//deassert reset_br_f
					if(~ready)
					begin
						reset_br_f       	<= 1'b0;
						cont_en_f			<= 1'b1;
						state				<= debug0;
					end
					else
					begin
						state				<= restart5;						
					end	
				end				   
			   			   		   		   		   
		default: begin
					state				  	<= boot0;
				end
		endcase
		
	end//end else

end	//end always





//NIOS II CONTROL CPU
debug_control niosII(
                       // 1) global signals:
                        .clk(nios_clk),
                        .reset_n(KEY[0]),
                       // the_boot
							//.out_port_from_the_boot(nios_boot),
                       // the_cont_addr
                        .out_port_from_the_cont_addr(cont_addr_f),
                       // the_cont_c_en
                        .out_port_from_the_cont_c_en(nios_cont_c_en_f),
                       // the_cont_di_sel
                        .out_port_from_the_cont_di_sel(cont_di_sel_f),
                       // the_cont_rdata
                        .in_port_to_the_cont_rdata(cont_rdata),
                       // the_ready
                        .in_port_to_the_ready(ready),
                       //the_debug_clk
						.in_port_to_the_debug_clk(debug_clk),
                       // the_sdram  
                        .zs_addr_from_the_sdram(DRAM_ADDR),
                        .zs_ba_from_the_sdram({DRAM_BA_1, DRAM_BA_0}),
                        .zs_cas_n_from_the_sdram(DRAM_CAS_N),
                        .zs_cke_from_the_sdram(DRAM_CKE),
                        .zs_cs_n_from_the_sdram(DRAM_CS_N),
                        .zs_dq_to_and_from_the_sdram(DRAM_DQ),
                        .zs_dqm_from_the_sdram({DRAM_UDQM, DRAM_LDQM}),
                        .zs_ras_n_from_the_sdram(DRAM_RAS_N),
                        .zs_we_n_from_the_sdram(DRAM_WE_N),
                       // the_uart
                        .rxd_to_the_uart(UART_RXD),
                        .txd_from_the_uart(UART_TXD)
                     );






brc_cpu cpu_inst(
       .debug_clk(debug_clk),
       .ext_clk(ext_clk),
       .int_clk(int_clk),
       .ext_adc_clk(ext_adc_clk),
       .reset(reset),
       .clk_reset(clk_reset),
       .cont_en_f(cont_en_f),
       .scan_en_f(scan_en_f),
       .scan_in_f(scan_in_f),
       .clk_scan_en_f(clk_scan_en_f),
       .clk_scan_in_f(clk_scan_in_f),
       .sc_over_f(sc_over_f),
       .scan_out(scan_out),
       .clk_scan_out(clk_scan_out),
       .reset_br_f(reset_br_f),
       .ready(ready),
       .cont_addr_f(cont_addr_f),
       .cont_wdata_f(cont_wdata_f),
       .cont_rdata(cont_rdata),
       .cont_rw_sel_f(cont_rw_sel_f),
       .cont_di_sel_f(cont_di_sel_f),
       .cont_c_en_f(cont_c_en_f),
       .chip_en(chip_en),
       .clk_sel(clk_sel),
       .adc_clk_sel(adc_clk_sel),
       .adc_in(adc_in),
	   .VSS(VSS),
       .VDD(VDD),
       .o_system_clock(system_clock),
       	////added for debug fac24 11/24/08////
	   .system_clock_clkdiv(system_clock_clkdiv),
	   .trigger(trigger)
       );

// EXTRA Debug Outputs
wire system_clock, system_clock_clkdiv;
//assign GPIO_0[0] = CLOCK_50;
//assign GPIO_0[1] = int_clk;
//assign GPIO_0[2] = ext_clk;
//assign GPIO_0[3] = system_clock;
//assign GPIO_0[4] = system_clock_clkdiv;
reg trigger;

assign LEDG[8] = ready;
assign LEDG[7:0] = state;
assign LEDR[8:0] = clk_scan;
assign LEDR[17] = cont_en_f;

endmodule
