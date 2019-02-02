// DE2 Top level module declaration removed for copyright reasons.
module sirds ();


// Link buffers
reg [9:0] link1 [0:639];
reg [9:0] link2 [0:639];

// SIRDS variables
wire [7:0] separation;
reg  [7:0] random_color;
wire       rand_out;
wire signed [31:0] height;

// SRAM Signals
reg           ub;
reg           lb;
reg  [17:0]   addr_reg;
reg  [15:0]   data_reg;
reg           we;

wire          reset;

// Line buffer signals
reg  [9:0] lb_ra, lb_wa;
reg  [7:0] lb_d;
reg        lb_we;
wire [7:0] lb_q;

// VGA Signals
wire [ 9:0]   mVGA_R, mVGA_G, mVGA_B;
wire [19:0]	  mVGA_ADDR;
wire          DLY_RST;
wire          VGA_CTRL_CLK;
wire          AUD_CTRL_CLK;
reg           reg_VGA_VS;
reg           reg_VGA_HS;
wire [ 9:0]   Coord_X, Coord_Y;	//display coords
reg  [ 9:0]   reg_Coord_X;
reg  [ 9:0]   y_pos;
reg  [ 9:0]   x_pos;
reg  [9:0]    reg_mVGA_R [6:0];
reg  [9:0]    reg_mVGA_G [6:0];
reg  [9:0]    reg_mVGA_B [6:0];

// Pipeline registers
reg [9:0] x0, x1, x2, x3, x4, x5;
reg [9:0] y0, y1, y2, y3, y4, y5;
reg [8:0] z1, z2, z3, z4, z5;
reg [9:0] link_x4, link_x5;
reg [7:0] sep;
reg signed [10:0] left, right;

// Movement signals
reg [7:0] level;
reg [7:0] depth;
reg reg_KEY2, reg_KEY3;
reg [31:0] accum;
wire dir;
wire [8:0] box_x;

// Turn on all display
assign	HEX0		=	7'hFF;
assign	HEX1		=	7'hFF;
assign	HEX2		=	7'hFF;
assign	HEX3		=	7'hFF;
assign	HEX4		=	7'hFF;
assign	HEX5		=	7'hFF;
assign	HEX6		=	7'hFF;
assign	HEX7		=	7'hFF;
assign	LEDG	    =	9'h000;
assign	LEDR		=	18'h0;
assign	LCD_ON		=	1'b1;
assign	LCD_BLON	=	1'b1;

// All inout port turn to tri-state
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ		=	8'hzz;
assign	OTG_DATA	=	16'hzzzz;
assign	LCD_DATA	=	8'hzz;
assign	SD_DAT		=	1'bz;
assign	I2C_SDAT	=	1'bz;
assign	ENET_DATA	=	16'hzzzz;
assign	AUD_ADCLRCK	=	1'bz;
assign	AUD_DACLRCK	=	1'bz;
assign	AUD_BCLK	=	1'bz;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;

// Enable CLOCK_27
assign TD_RESET = 1'b1;

// Connect module to SRAM
assign SRAM_DQ   = (~we) ? data_reg : 16'hzzzz;
assign SRAM_ADDR = addr_reg;
assign SRAM_UB_N = ub;
assign SRAM_LB_N = lb;
assign SRAM_WE_N = we;
assign SRAM_CE_N = 0;
assign SRAM_OE_N = 0;

// Connect module to other signals
assign mVGA_R = (VGA_HS && VGA_VS) ? {lb_d,2'b0} : 0;
assign mVGA_G = (VGA_HS && VGA_VS) ? {lb_d,2'b0} : 0;
assign mVGA_B = (VGA_HS && VGA_VS) ? {lb_d,2'b0} : 0;
assign reset = ~KEY[0];

// Bouncing box variables
assign box_x = accum[25:17];
assign dir = accum[26];

// Picture parameters
parameter WIDTH    = 640;
parameter HEIGHT   = 480;
parameter BKDEPTH  = -800;
parameter OBSERVER = 350;
parameter EYE_SEP  = 80;

// Ccolor parameters
parameter NUMCOLORS = 64;


//Instantiate VGA control modules
Reset_Delay		r0	(.iCLK(CLOCK_50),.oRESET(DLY_RST));

VGA_Audio_PLL 	p1	(.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK));

VGA_Controller	u1	(	//	Host Side
							.iCursor_RGB_EN(4'b0111),
							.oAddress(mVGA_ADDR),
							.oCoord_X(Coord_X),
							.oCoord_Y(Coord_Y),
							.iRed(mVGA_R),
							.iGreen(mVGA_G),
							.iBlue(mVGA_B),
							//	VGA Side
							.oVGA_R(VGA_R),
							.oVGA_G(VGA_G),
							.oVGA_B(VGA_B),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC),
							.oVGA_BLANK(VGA_BLANK),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(DLY_RST)	);

// Random number generator							
Random31    rand1 (.iCLK(VGA_CTRL_CLK), .oRand(rand_out));

// ROM to map heights to separation values
sep_rom     sep1 (.ADDR(z1), .DATA_OUT(separation));

// RAM to store the pixel values for linking
line_buffer line (
						.ra(lb_ra),
						.wa(lb_wa),
						.clk(VGA_CTRL_CLK),
						.d(lb_d),
						.we(lb_we),
						.q(lb_q));

// Bouncing Box position accumulator
always @ (posedge VGA_CTRL_CLK)
begin
	if (reset)
		accum <= 0;
	else
		accum <= accum+1;
end

// Adjustable box height control routine
always @ (posedge VGA_CTRL_CLK)
begin
	if (reset)
	begin
		reg_KEY2 <= 1;
		reg_KEY3 <= 1;
		level <= 0;
	end
	else
	begin
		// On falling edges of the switches, increment the box height index up or down
		reg_KEY2 <= KEY[2];
		reg_KEY3 <= KEY[3];
		if      (reg_KEY3 && ~KEY[3] && level > 0) level <= level-1;
		else if (reg_KEY2 && ~KEY[2] && level < 27) level <= level+1;
		else if (level > 27) level <= 27;
	end
end

// Map from adjustable box height index to displayable height value
always @ (level)
begin
	case (level)
		8'h00: depth = 8'h00;
		8'h01: depth = 8'h09;
		8'h02: depth = 8'h17;
		8'h03: depth = 8'h24;
		8'h04: depth = 8'h30;
		8'h05: depth = 8'h3C;
		8'h06: depth = 8'h48;
		8'h07: depth = 8'h53;
		8'h08: depth = 8'h5E;
		8'h09: depth = 8'h69;
		8'h0A: depth = 8'h73;
		8'h0B: depth = 8'h7D;
		8'h0C: depth = 8'h87;
		8'h0D: depth = 8'h90;
		8'h0E: depth = 8'h99;
		8'h0F: depth = 8'hA2;
		8'h10: depth = 8'hAA;
		8'h11: depth = 8'hB3;
		8'h12: depth = 8'hBB;
		8'h13: depth = 8'hC2;
		8'h14: depth = 8'hCA;
		8'h15: depth = 8'hD1;
		8'h16: depth = 8'hD9;
		8'h17: depth = 8'hE0;
		8'h18: depth = 8'hE7;
		8'h19: depth = 8'hED;
		8'h1A: depth = 8'hF4;
		8'h1B: depth = 8'hFA;
		default: depth = 8'h00;
	endcase
end

// Update the random color once each cycle
always @ (posedge VGA_CTRL_CLK)
begin
	random_color <= {random_color[6:0],rand_out};
end

// Pipelined registers update
always @ (posedge VGA_CTRL_CLK)
begin
	// Gen depth stage
	x0 <= Coord_X[9:0];
	y0 <= Coord_Y[9:0];
		
	// Gen separation stage
	x1 <= x0;
	y1 <= y0;
	
	// Gen L&R stage
	x2 <= x1;
	y2 <= y1;
	z2 <= z1;
	
	// Link stage
	x3 <= x2;
	y3 <= y2;
	z3 <= z2;
	
	// Read color stage
	x4 <= x3;
	y4 <= y3;
	z4 <= z3;

	// Write color stage
	x5 <= x4;
	y5 <= y4;
	z5 <= z4;
	link_x5 <= link_x4;
end

// Gen depth stage
always @ (posedge VGA_CTRL_CLK)
begin
	// Create seesaw
	if (y0 >= 60 && y0 < 100)
	begin
		if (x0 < 552)
			z1 <= (accum[25]) ? ((x0[8:1])*accum[24:17])/256 :
								((255-accum[24:17])*(x0[8:1]))/256;
		else z1 <= 8'h00;
	end
	// Create static and adjustable boxes
	else if (y0 >= 190 && y0 < 290)
	begin
		
		if      (x0 >= 170 && x0 < 270) z1 <= 8'h90;
		else if (x0 >= 370 && x0 < 470) z1 <= depth;
		else z1 <= 8'h00;
	end
	// Create bouncing square
	else if (y0 >= 380 && y0 < 420)
	begin
		if (dir)
		begin
			if (x0 >= 44+box_x && x0 < 44+40+box_x) z1 <= 8'h90;
			else z1 <= 8'h00;
		end
		else
		begin
			if (x0 >= 44+(511-box_x) && x0 < 44+40+(511-box_x)) z1 <= 8'h90;
			else z1 <= 8'h00;
		end
	end
	else z1 <= 8'h00;
end

// Gen separation stage
always @ (posedge VGA_CTRL_CLK)
begin
	// Read the seperation value to which the current height maps
	sep <= separation;
end

// Gen L&R stage
always @ (posedge VGA_CTRL_CLK)
begin
	// calculate the left and right indices of the current pixel
	left  <= x2 - (sep>>1);
	right <= x2 + (sep>>1) + sep[0];
end

// Link stage
always @ (posedge VGA_CTRL_CLK)
begin
	// Build two link buffers so that one is initialized as the other is processed
	if (y3[0])
	begin
		// Initialize other link buffer
		link1[x3] <= x3;
		// Assign rightmost elements the values of their linked elements
		// Capture the index of the element to which the current element is linked
		if ((left >= 0) && (right < WIDTH))
		begin
			link2[right[9:0]] <= left[9:0];
			link_x4 <= (x3 == right[9:0]) ? left[9:0] : link2[x3];
		end
		else
		begin
			link_x4 <= link2[x3];
		end
	end
	else
	begin
		// Initialize other link buffer
		link2[x3] <= x3;
		// Assign rightmost element the value of its linked element
		// Capture the index of the element to which the current element is linked
		if ((left >= 0) && (right < WIDTH))
		begin
			link1[right[9:0]] <= left[9:0];
			link_x4 <= (x3 == right[9:0]) ? left[9:0] : link1[x3];
		end
		else
		begin
			link_x4 <= link1[x3];
		end
	end
end

// Read color stage
always @ (posedge VGA_CTRL_CLK)
begin
	// Read the color of the linked element
	lb_ra <= link_x4;
end

// Write color stage
always @ (posedge VGA_CTRL_CLK)
begin
	// Write the color of the current pixel to the line buffer RAM
	lb_we <= 1;
	lb_wa <= x5;
	// Toggle depth map display on and off
	if (SW[17])
	begin
		lb_d <= z5;
	end
	// Toggle between displaying the linked value and the stereogram
	else if (SW[0])
	begin
		if (link_x5 == x5)
			lb_d <= random_color;
		else
			lb_d <= lb_q;
	end
	else
	begin
		lb_d <= link_x5[9:2];
	end
end

endmodule

//////////////////////////////////////////////////
//// M4k ram for line buffer /////////////////////
//////////////////////////////////////////////////
module line_buffer (q, wa, ra, d, we, clk);
output reg  [7:0] q;
input [7:0] d;
input [9:0] ra;
input [9:0] wa;
input we, clk;
 
reg [7:0] mem [639:0];
	always @ (negedge clk) 
	begin
		if (we) mem[wa] <= d;
		q <= mem[ra];
	end
endmodule 
//////////////////////////////////////////////////
