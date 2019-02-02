// High Speed Hardware Raytracer
// ECE 576 Final Project
// Daniel Beer (dbb28), Kashif Javed (kj49)

// Top Level Module
module rayTracerSystem(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_27,						//	27 MHz
		CLOCK_50,						//	50 MHz
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,						//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Address bus 18 Bits
		SRAM_UB_N,						//	SRAM High-byte Data Mask 
		SRAM_LB_N,						//	SRAM Low-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		////////////////////	VGA		////////////////////////////
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		TD_RESET,
		KEY,
		LEDG,
		LEDR,
		SW);

////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_27;				//	27 MHz
input			CLOCK_50;				//	50 MHz
////////////////////////	SRAM Interface	////////////////////////
inout	[15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
output	[17:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
output			SRAM_UB_N;				//	SRAM High-byte Data Mask
output			SRAM_LB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_WE_N;				//	SRAM Write Enable
output			SRAM_CE_N;				//	SRAM Chip Enable
output			SRAM_OE_N;				//	SRAM Output Enable
////////////////////////	VGA			////////////////////////////
output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK;				//	VGA BLANK
output			VGA_SYNC;				//	VGA SYNC
output	[9:0]	VGA_R;   				//	VGA Red[9:0]
output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
output			TD_RESET;

input	[3:0]	KEY;					//	Pushbutton[3:0]
output  [8:0]  LEDG;
output  [17:0] LEDR;
input   [17:0] SW;

// Parameters
parameter BusWidth = 24; // Width of numbers in out system
parameter DecimalWidth = 12; // Placement of decimal point
parameter PixelBufSize = 128; // Circular buffer size
parameter PixelBufSizeWidth = 7; // Log circular buffer size

assign TD_RESET = 1'b1;

wire reset;
reg [17:0] addr_reg; //memory address register for SRAM
reg [15:0] data_reg; //memory data register  for SRAM
reg we ;		//write enable for SRAM

assign LEDG = {{7{reset}},1'b1,1'b0};

wire		VGA_CTRL_CLK;
wire		AUD_CTRL_CLK;
wire [9:0]	mVGA_R;
wire [9:0]	mVGA_G;
wire [9:0]	mVGA_B;
wire [19:0]	mVGA_ADDR;			//video memory address
wire [9:0]  Coord_X, Coord_Y;	//display coods
wire		DLY_RST;

Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);


VGA_Controller		u1	(	//	Host Side
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

assign reset = ~KEY[3];

// SRAM_control
assign SRAM_ADDR = addr_reg;
assign SRAM_DQ = (we)? 16'hzzzz : data_reg ;
assign SRAM_UB_N = 0;					// hi byte select enabled
assign SRAM_LB_N = 0;					// lo byte select enabled
assign SRAM_CE_N = 0;					// chip is enabled
assign SRAM_WE_N = we;					// write when ZERO
assign SRAM_OE_N = 0;					//output enable is overidden by WE

// Show SRAM on the VGA
assign  mVGA_R = {SRAM_DQ[15:12], {6{SRAM_DQ[15:12]!=6'b0}}} ;
assign  mVGA_G = {SRAM_DQ[11:8], {6{SRAM_DQ[11:8]!=6'b0}}} ;
assign  mVGA_B = {SRAM_DQ[7:4], {6{SRAM_DQ[7:4]!=6'b0}}} ;

// Counters and registers for ray tracer logic
reg [8:0] rayPixelX, rayPixelY;
reg signed [BusWidth-1:0] p1x, p1y, p1z, p2x, p2y, p2z, p3x, p3y, p3z, ox, oy, oz;

wire [8:0] rayPixelX_out, rayPixelY_out, rayPixelX_lm_out, rayPixelY_lm_out;
reg [8:0] rayPixelX_lm_out_R, rayPixelY_lm_out_R;

wire rayCLK, rayCLKen;
wire rayHit;
wire rayHit_lm;

wire syncing;
reg signed [BusWidth-1:0] curT;
wire signed [BusWidth-1:0] t, interx, intery, interz, nx, ny, nz,
					 t_lm;
wire [BusWidth-1:0] light;

reg [11:0]	color_lm;
wire [11:0]	light_out;

reg [11:0] curColor;
reg [31:0] frameCount;

// Circular Pixel Buffer
reg [11:0] pixelColor[PixelBufSize-1:0];
reg [8:0] pixelX[PixelBufSize-1:0], pixelY[PixelBufSize-1:0];
reg [PixelBufSizeWidth-1:0] curWriteIndex, curReadIndex;

assign syncing = (~VGA_VS | ~VGA_HS);
assign rayCLK = ~VGA_CTRL_CLK;
assign rayCLKen = 1'b1;

assign LEDR = frameCount[17:0];

reg [6:0] tROMaddr;
wire [227:0] tROMdata;
triangleROM (
	.address(tROMaddr),
	.clock(VGA_CTRL_CLK),
	.q(tROMdata));

integer a;
reg [11:0] pixelColor_reg[0:31];
reg [5:0] pipeCount;

// Ray tracer logic
always @ (posedge VGA_CTRL_CLK)
begin
	if (reset)
	begin
		rayPixelX <= 9'd0;
		rayPixelY <= 9'd0;
		rayPixelX_lm_out_R <= 9'd0;
		rayPixelY_lm_out_R <= 9'd0;
		curT <={SW[17:7],{(BusWidth-11){1'b0}}}; //{1'b0,{(BusWidth-1){1'b1}}};
		curWriteIndex <= {(PixelBufSizeWidth){1'b0}};
		tROMaddr <= 7'b0;
		curColor <= 12'b0;
		
		ox	<= 24'hfc4000;
		oy	<= 24'hfc4000;
		oz	<= 24'h0;
		
		frameCount <= 32'b0;
	end
	else begin
		// Store last pixel location
		rayPixelX_lm_out_R <= rayPixelX_lm_out;
		rayPixelY_lm_out_R <= rayPixelY_lm_out;
		
		// Read triangle data from ROM
		p1x <= {{4{tROMdata[23]}}, tROMdata[23:0]};
		p1y <= {{4{tROMdata[47]}}, tROMdata[47:24]};
		p1z <= {{4{tROMdata[71]}}, tROMdata[71:48]};
		p2x <= {{4{tROMdata[95]}}, tROMdata[95:72]};
		p2y <= {{4{tROMdata[119]}}, tROMdata[119:96]};
		p2z <= {{4{tROMdata[143]}}, tROMdata[143:120]};
		p3x <= {{4{tROMdata[167]}}, tROMdata[167:144]};
		p3y <= {{4{tROMdata[191]}}, tROMdata[191:168]};
		p3z <= {{4{tROMdata[215]}}, tROMdata[215:192]};
		pixelColor_reg[0] <= tROMdata[227:216];	
		
		// Loop through triangles
		if (tROMaddr < 7'd11)
			tROMaddr <= tROMaddr + 7'd1;
		else begin	
			tROMaddr <= 7'd0;
			
			// After passing all triangles, increment pixel
			if (rayPixelX < 9'd319)
				rayPixelX <= rayPixelX + 9'd1;
			else if (rayPixelY < 9'd239) begin
				rayPixelX <= 9'd0;
				rayPixelY <= rayPixelY + 9'd1;
			end
			else begin
				// At the end of the frame, reset pixel and move camera
				rayPixelX <= 9'd0;
				rayPixelY <= 9'd0;
				if (SW[0]) ox <=  ox + 24'h1000;
				else if (SW[1]) ox <=  ox - 24'h1000;
				
				if (SW[2]) oy <=  oy + 24'h1000;
				else if (SW[3]) oy <=  oy - 24'h1000;
				
				if (SW[4]) oz <=  oz + 24'h1000;
				else if (SW[5]) oz <=  oz - 24'h1000;
				
				frameCount <= frameCount + 1;
			end	
		end
		
		// Shift register logic
		for (a = 1; a <= 31; a = a + 1)
			pixelColor_reg[a] <= pixelColor_reg[a-1];

		// If we are still on the same pixel
		if (rayPixelX_lm_out_R == rayPixelX_lm_out &&
			rayPixelY_lm_out_R == rayPixelY_lm_out)
		begin		
			// Check if we just got a closer intersection than the current closest
			// If so, update variables
			if (rayHit_lm && t_lm > 0 && t_lm <= curT) 
			begin
				curT <= t_lm;
				curColor <= light_out;
			end		
		end
		
		// If we have moved to another pixel
		else begin
			// Write last pixel data to circular buffer
			pixelX[curWriteIndex] <= rayPixelX_lm_out_R;
			pixelY[curWriteIndex] <= rayPixelY_lm_out_R;
			pixelColor[curWriteIndex] <= curColor;
			curWriteIndex <= curWriteIndex + {{(PixelBufSizeWidth-1){1'b0}},1'b1};
				
			// Reset variables while checking newest pixel
			if (rayHit_lm && t_lm > 0 && t_lm <= {SW[17:7],{(BusWidth-11){1'b0}}}) 
			begin
				curT <= t_lm;
				curColor <= light_out;
			end	
			else begin	
				curT <= {SW[17:7],{(BusWidth-11){1'b0}}}; 
				curColor <= 12'b0;				
			end
		end
	end

	if (reset)		
	begin
		//clear the screen
		addr_reg <= {Coord_X[9:1],Coord_Y[9:1]} ;	// [17:0]
		we <= 1'b0;								//write some memory
		data_reg <= 16'h0000;
		curReadIndex <= {(PixelBufSizeWidth){1'b0}};
	end
	
	//modify display during sync
	else if (syncing)
	begin
		// When the VGA controller doesn't need SRAM, write pixels at max speed
		addr_reg <= {pixelX[curReadIndex],pixelY[curReadIndex]};
		we <= 1'b0;	
		data_reg <= {pixelColor[curReadIndex],4'b0};	
		curReadIndex <= curReadIndex + {{(PixelBufSizeWidth-1){1'b0}},1'b1};
	end
	
	//show display when not blanking, 
	//which implies we=1 (not enabled); and use VGA module address
	else
	begin
		addr_reg <= {Coord_X[9:1],Coord_Y[9:1]} ;
		we <= 1'b1;
	end
end

// Instantiation of shading module
rayLightingModule
#(.BusWidth(BusWidth),
.DecimalWidth(DecimalWidth))
		(.clk(rayCLK),.clken(rayCLKen), .lx(24'hfc4000), .ly(24'hfc4000), .lz(10<<DecimalWidth), 
				.interx(interx), .intery(intery), 
			    .interz(interz), .nx(nx), .ny(ny), .nz(nz), .color(pixelColor_reg[31]),
				.light(light_out),
				.pixelX(rayPixelX_out),.pixelY(rayPixelY_out),
				.pixelX_out(rayPixelX_lm_out),.pixelY_out(rayPixelY_lm_out),
				.rayHit(rayHit), .t(t), .rayHit_out(rayHit_lm), .t_out(t_lm),.useshading(SW[6])
				);
				

// Instantiation of intersection module
rayIntersectionModule
	#(.BusWidth(BusWidth),
	  .DecimalWidth(DecimalWidth))
	 (.clk(rayCLK), .fx(1<<DecimalWidth), .fy(1<<DecimalWidth), .fz(0<<DecimalWidth), 
	  .ox(ox), .oy(oy), .oz(oz),
	  .p1x(p1x), .p1y(p1y), .p1z(p1z), .p2x(p2x), .p2y(p2y), .p2z(p2z),
	  .p3x(p3x), .p3y(p3y), .p3z(p3z), .ux(0), .uy(0), .uz(1<<DecimalWidth), 
	  .pixelX(rayPixelX), .pixelY(rayPixelY), .hit_out(rayHit), 
	  .nx_out(nx), .ny_out(ny), .nz_out(nz), .t_out(t),
	  .interx_out(interx), .intery_out(intery), .interz_out(interz), 
	  .pixelX_out(rayPixelX_out), .pixelY_out(rayPixelY_out),
	  .clken(rayCLKen));
	
					
endmodule