module rayLightingModule(clk, clken, lx, ly, lz, interx, intery, interz, nx, ny, nz, 
color, light,pixelX,pixelY,pixelX_out,pixelY_out,rayHit,rayHit_out,t_out,t,useshading);

//parameters
parameter BusWidth = 24;
parameter DecimalWidth = 12;

//  inputs to the module  
input clk, clken, rayHit,useshading;
input signed [BusWidth-1:0] lx, ly, lz, interx, intery, interz, nx, ny, nz, t;
input [11:0] color;
input [8:0] pixelX, pixelY;

//output signals
output signed [BusWidth-1:0] t_out;
output [11:0] light;
output [8:0] pixelX_out, pixelY_out;
output rayHit_out;

//register arrays for our pipeline
reg rayHit_reg[1:13]; 
reg [8:0] pixelX_reg[1:13], pixelY_reg[1:13];

//registers to store the intermdeiate results from our pipeline
reg signed [BusWidth-1:0] 	
	lx_minus_interx, ly_minus_intery, lz_minus_interz,
	l_minus_inter_mag,
	l_minus_inter_dot_n,
	l_minus_inter_dot_n_reg[4:6], t_reg[1:13], nx_reg[1:1], ny_reg[1:1], nz_reg[1:1],
	light_r, light_g, light_b;

//output signed [BusWidth-1:0] l_minus_inter_mag ;

reg signed [BusWidth-1:0] 	l_div;	
//output signed [BusWidth-1:0] l_div;	

//register array to pipeline the color value passed in
reg [11:0] color_reg[1:13];

//wires for intermediate results
wire signed [BusWidth-1:0]
	lx_minus_interx_times_nx,
	ly_minus_intery_times_ny,
	lz_minus_interz_times_nz,
	l_minus_inter_magnitude;

wire signed [BusWidth+DecimalWidth-1:0] l_divout;

//registers to store the multiplication results 
reg signed [2*BusWidth-1:0] 
	l_minus_inter_sum_of_squares,
	lx_minus_interx_square,
	ly_minus_intery_square,
	lz_minus_interz_square,
	lx_minus_interx_times_nx_shift,
	ly_minus_intery_times_ny_shift,
	lz_minus_interz_times_nz_shift;

//output signed [2*BusWidth-1:0] 
//	l_minus_inter_sum_of_squares;

	
//shifting the results to make them Buswidth size

assign lx_minus_interx_times_nx = lx_minus_interx_times_nx_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign ly_minus_intery_times_ny = ly_minus_intery_times_ny_shift[BusWidth+DecimalWidth-1:DecimalWidth];	
assign lz_minus_interz_times_nz = lz_minus_interz_times_nz_shift[BusWidth+DecimalWidth-1:DecimalWidth];

// outputs from the final stage
assign pixelX_out = pixelX_reg[13];
assign pixelY_out = pixelY_reg[13];
assign rayHit_out = rayHit_reg[13];	
assign t_out = t_reg[13];

//final color value either shaded or the original
assign light =(useshading)? {light_r[15:12],light_g[15:12],light_b[15:12]}:color_reg[13]; 

integer a;	

//sqare root to calculate the magnitude of the (light - intersection) vector
sqrt2stage
  #(.BusWidth(BusWidth),
	.DecimalWidth(DecimalWidth))
	(.clk(clk),
	.radical(l_minus_inter_sum_of_squares),
	.q(l_minus_inter_magnitude),
	.remainder());

// dividing the  vector by its magnitude
divider5stage 
  #(.BusWidth(BusWidth),
	.DecimalWidth(DecimalWidth))
   (.clock(clk),
	.clken(clken),
	.denom(l_minus_inter_mag),
	.numer({l_minus_inter_dot_n_reg[6], {(DecimalWidth){1'b0}}}),
	.quotient(l_divout),
	.remain());

always @(posedge clk)
if (clken) begin
	// Stage 1 	calculating l-x vector
	lx_minus_interx <= lx - interx;
	ly_minus_intery <= ly - intery;
	lz_minus_interz <= lz - interz;
	
	// Stage 2	//multiplying by the normal( first part of the dot product of l.n)
	lx_minus_interx_times_nx_shift <= lx_minus_interx * nx_reg[1];  
	ly_minus_intery_times_ny_shift <= ly_minus_intery * ny_reg[1];
	lz_minus_interz_times_nz_shift <= lz_minus_interz * nz_reg[1];
	
	// squaring the x y z components of (l-x) 
	lx_minus_interx_square <= lx_minus_interx * lx_minus_interx;
	ly_minus_intery_square <= ly_minus_intery * ly_minus_intery;
	lz_minus_interz_square <= lz_minus_interz * lz_minus_interz;
	
	// Stage 3	taking the dot product of l-x with the normal and adding the squared terms from the last stage
	l_minus_inter_dot_n <= lx_minus_interx_times_nx + ly_minus_intery_times_ny + lz_minus_interz_times_nz;
	l_minus_inter_sum_of_squares <= lx_minus_interx_square + ly_minus_intery_square +lz_minus_interz_square;
	
	// Stage 4-5 sqrt
	
	// Stage 6	storing the magnitude coming out of the square root module
	l_minus_inter_mag <= l_minus_inter_magnitude;
	

	// Stage 7-11 divide
	
	// Stage 12	// storing the divider output of (l-x).n/(l magnitude)
		l_div 	 <=	l_divout[BusWidth-1:0];
	
	// Stage 13	calculating the lighting coeeficient
	
	if (l_div <= 0)
	begin
	  light_r <= 0;
	  light_g <= 0;
	  light_b <= 0;
	end
	else begin
	 light_r <= l_div*{12'b0,color_reg[12][11:8]};
	 light_g <=	l_div*{12'b0,color_reg[12][7:4]};
	 light_b <=	l_div*{12'b0,color_reg[12][3:0]};
	end
end


//pipelining various inputs and outputs so that
// they have the correct value for each stage

always @(posedge clk)
if (clken) begin
	l_minus_inter_dot_n_reg[4] = l_minus_inter_dot_n;

	for(a = 5; a <= 6; a = a + 1)
	begin
		l_minus_inter_dot_n_reg[a]=l_minus_inter_dot_n_reg[a-1];
	end
	
	pixelX_reg[1] <= pixelX;
    pixelY_reg[1] <= pixelY;
	
	for(a = 2; a <= 13; a = a + 1)
	begin
		pixelX_reg[a] <= pixelX_reg[a-1];
		pixelY_reg[a] <= pixelY_reg[a-1];
	end
	
	rayHit_reg[1] <= rayHit;
	
	for(a = 2; a <= 13; a = a + 1)
	begin
		rayHit_reg[a] <= rayHit_reg[a-1];
	end
	
	color_reg[1] <= color;
	
	for(a=2; a <= 13; a = a + 1)
	begin
		color_reg[a] <= color_reg[a-1];
	end
	
	t_reg[1] <= t;
	
	for(a=2; a <= 13; a = a + 1)
	begin
		t_reg[a] <= t_reg[a-1];
	end
	
	nx_reg[1] <= nx;
	ny_reg[1] <= ny;
	nz_reg[1] <= nz;
		
end
endmodule