// Ray intersection module
module rayIntersectionModule(clk, clken, fx, fy, fz, ox, oy, oz,
					p1x, p1y, p1z, p2x, p2y, p2z,
					p3x, p3y, p3z, ux, uy, uz, 
					pixelX, pixelY, hit_out, nx_out, ny_out, nz_out,
					interx_out, intery_out, interz_out, pixelX_out, pixelY_out,
					t_out, debug);

parameter BusWidth = 0;
parameter DecimalWidth = 0;

// Ports
input clk, clken;
input signed [BusWidth-1:0] fx, fy, fz, ox, oy, oz,
					p1x, p1y, p1z, p2x, p2y, p2z,
					p3x, p3y, p3z, ux, uy, uz;
input [8:0] pixelX, pixelY;

output hit_out;
output signed [BusWidth-1:0] nx_out, ny_out, nz_out, interx_out, intery_out, interz_out, t_out;
output [8:0] pixelX_out, pixelY_out;

// Pipeline registers
// The double width ones are used to store multiplication results
reg signed [BusWidth-1:0]	
	p2x_minus_p1x, p2y_minus_p1y, p2z_minus_p1z,
	p3x_minus_p1x, p3y_minus_p1y, p3z_minus_p1z,
	
	p2x_minus_p1x_26,p2y_minus_p1y_26,p2z_minus_p1z_26,
	p3x_minus_p1x_26,p3y_minus_p1y_26,p3z_minus_p1z_26,
	p3x_minus_p2x_26,p3y_minus_p2y_26,p3z_minus_p2z_26,
	
	ox_minus_p2x,  oy_minus_p2y, oz_minus_p2z,
	raydx, raydy, raydz,
	o_minus_p2_dot_n, negative_o_minus_p2_dot_n, raydx_dot_n,
	interx,	intery,	interz,
	interx_minus_p1x, intery_minus_p1y,	interz_minus_p1z,
	interx_minus_p2x, intery_minus_p2y,	interz_minus_p2z,
	interx_minus_p3x, intery_minus_p3y, interz_minus_p3z,
	test1_mul1,	test1_mul2,	test1_mul3,
	test2_mul1,	test2_mul2, test2_mul3,
	test3_mul1,	test3_mul2,	test3_mul3,
	t,nx_normalised,ny_normalised,nz_normalised,
	n_mag;
	
wire signed [BusWidth-1:0]
	n_magnitude;
	
reg signed [BusWidth*2-DecimalWidth-1:0]
	test1, test2, test3;
	
reg signed [2*BusWidth-1:0] 
	fx_times_uy, fx_times_uz, fy_times_ux, fy_times_uz, fz_times_ux, fz_times_uy, 
	rx_shift, ry_shift, rz_shift,
	nx_shift, ny_shift, nz_shift,
	p2y_minus_p1y_times_p3z_minus_p1z, 
	p2z_minus_p1z_times_p3x_minus_p1x,
	p2x_minus_p1x_times_p3y_minus_p1y,
	p2z_minus_p1z_times_p3y_minus_p1y,
	p2x_minus_p1x_times_p3z_minus_p1z,
	p2y_minus_p1y_times_p3x_minus_p1x,
	rx_times_pixelX_minus_160_div_320_shift,
	ry_times_pixelX_minus_160_div_320_shift,
	rz_times_pixelX_minus_160_div_320_shift,
	ux_times_pixelY_minus_120_div_240_shift,
	uy_times_pixelY_minus_120_div_240_shift,
	uz_times_pixelY_minus_120_div_240_shift,
	ox_minus_p2x_times_nx_shift, oy_minus_p2y_times_ny_shift, oz_minus_p2z_times_nz_shift,	
	raydx_times_nx_shift, raydy_times_ny_shift, raydz_times_nz_shift,
	t_times_fx_shift, t_times_fy_shift, t_times_fz_shift,
	test1_mul1_a_shift,	test1_mul1_b_shift,
	test1_mul2_a_shift,	test1_mul2_b_shift,
	test1_mul3_a_shift,	test1_mul3_b_shift,
	test2_mul1_a_shift,	test2_mul1_b_shift,
	test2_mul2_a_shift,	test2_mul2_b_shift,
	test2_mul3_a_shift,	test2_mul3_b_shift,
	test3_mul1_a_shift,	test3_mul1_b_shift,
	test3_mul2_a_shift,	test3_mul2_b_shift,
	test3_mul3_a_shift,	test3_mul3_b_shift,
	test1_x_shift, test1_y_shift, test1_z_shift,
	test2_x_shift, test2_y_shift, test2_z_shift,
	test3_x_shift, test3_y_shift, test3_z_shift,
	nx_square,ny_square,nz_square, n_sum_of_squares;
				
reg hit_out;

wire signed [BusWidth-1:0]
	rx, ry, rz, nx, ny, nz, 
	rx_times_pixelX_minus_160_div_320,
	ry_times_pixelX_minus_160_div_320, 
	rz_times_pixelX_minus_160_div_320, 
	ux_times_pixelY_minus_120_div_240, 
	uy_times_pixelY_minus_120_div_240, 
	uz_times_pixelY_minus_120_div_240, 
	t_times_fx, t_times_fy,	t_times_fz,
	ox_minus_p2x_times_nx,
	oy_minus_p2y_times_ny,
	oz_minus_p2z_times_nz,	
	raydx_times_nx,	raydy_times_ny,	raydz_times_nz,
	test1_mul1_a, test1_mul1_b, test1_mul2_a,
	test1_mul2_b, test1_mul3_a, test1_mul3_b,
	test2_mul1_a, test2_mul1_b, test2_mul2_a,
	test2_mul2_b, test2_mul3_a, test2_mul3_b,
	test3_mul1_a, test3_mul1_b, test3_mul2_a,
	test3_mul2_b, test3_mul3_a, test3_mul3_b,
	pixelX_minus_160_div_320, pixelY_minus_120_div_240;
	
	
wire signed [BusWidth+DecimalWidth-1:0] tdivout,nx_divout,ny_divout,nz_divout;
wire signed [BusWidth*2-DecimalWidth-1:0]
	test1_x, test1_y, test1_z,
	test2_x, test2_y, test2_z,
	test3_x, test3_y, test3_z;

reg signed [BusWidth-1:0]
	p1x_reg[1:31],
	p1y_reg[1:31],
	p1z_reg[1:31],	
	p2x_reg[1:31],
	p2y_reg[1:31],
	p2z_reg[1:31],
	p3x_reg[1:31],
	p3y_reg[1:31],
	p3z_reg[1:31],
	ox_reg[1:24],
	oy_reg[1:24],
	oz_reg[1:24],
	fx_reg[1:14],
	fy_reg[1:14],
	fz_reg[1:14],
	nx_reg[4:8],
	ny_reg[4:8],
	nz_reg[4:8],
	raydx_reg[16:23],
	raydy_reg[16:23],
	raydz_reg[16:23],
	interx_reg[26:31],
	intery_reg[26:31],
	interz_reg[26:31],
	t_reg[24:31],
	ux_reg[1:2],
	uy_reg[1:2],
	uz_reg[1:2],
	rx_times_pixelX_minus_160_div_320_reg[4:14],
	ry_times_pixelX_minus_160_div_320_reg[4:14],
	rz_times_pixelX_minus_160_div_320_reg[4:14],
	ux_times_pixelY_minus_120_div_240_reg[4:14],
	uy_times_pixelY_minus_120_div_240_reg[4:14],
	uz_times_pixelY_minus_120_div_240_reg[4:14],
	nx_normalised_reg[15:31],
	ny_normalised_reg[15:31],
	nz_normalised_reg[15:31];
	
reg [8:0]
	pixelX_reg[1:31], pixelY_reg[1:31];

assign rx = rx_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign ry = ry_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign rz = rz_shift[BusWidth+DecimalWidth-1:DecimalWidth];

assign nx = nx_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign ny = ny_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign nz = nz_shift[BusWidth+DecimalWidth-1:DecimalWidth];

assign rx_times_pixelX_minus_160_div_320 = rx_times_pixelX_minus_160_div_320_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign ry_times_pixelX_minus_160_div_320 = ry_times_pixelX_minus_160_div_320_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign rz_times_pixelX_minus_160_div_320 = rz_times_pixelX_minus_160_div_320_shift[BusWidth+DecimalWidth-1:DecimalWidth];
	
assign ux_times_pixelY_minus_120_div_240 = ux_times_pixelY_minus_120_div_240_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign uy_times_pixelY_minus_120_div_240 = uy_times_pixelY_minus_120_div_240_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign uz_times_pixelY_minus_120_div_240 = uz_times_pixelY_minus_120_div_240_shift[BusWidth+DecimalWidth-1:DecimalWidth];
	
assign t_times_fx = t_times_fx_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign t_times_fy = t_times_fy_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign t_times_fz = t_times_fz_shift[BusWidth+DecimalWidth-1:DecimalWidth];

assign ox_minus_p2x_times_nx = ox_minus_p2x_times_nx_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign oy_minus_p2y_times_ny = oy_minus_p2y_times_ny_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign oz_minus_p2z_times_nz = oz_minus_p2z_times_nz_shift[BusWidth+DecimalWidth-1:DecimalWidth];

assign raydx_times_nx = raydx_times_nx_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign raydy_times_ny = raydy_times_ny_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign raydz_times_nz = raydz_times_nz_shift[BusWidth+DecimalWidth-1:DecimalWidth];

assign test1_mul1_a = test1_mul1_a_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test1_mul1_b = test1_mul1_b_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test1_mul2_a = test1_mul2_a_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test1_mul2_b = test1_mul2_b_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test1_mul3_a = test1_mul3_a_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test1_mul3_b = test1_mul3_b_shift[BusWidth+DecimalWidth-1:DecimalWidth];
		
assign test2_mul1_a = test2_mul1_a_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test2_mul1_b = test2_mul1_b_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test2_mul2_a = test2_mul2_a_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test2_mul2_b = test2_mul2_b_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test2_mul3_a = test2_mul3_a_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test2_mul3_b = test2_mul3_b_shift[BusWidth+DecimalWidth-1:DecimalWidth];

assign test3_mul1_a = test3_mul1_a_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test3_mul1_b = test3_mul1_b_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test3_mul2_a = test3_mul2_a_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test3_mul2_b = test3_mul2_b_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test3_mul3_a = test3_mul3_a_shift[BusWidth+DecimalWidth-1:DecimalWidth];
assign test3_mul3_b = test3_mul3_b_shift[BusWidth+DecimalWidth-1:DecimalWidth];

assign test1_x = test1_x_shift[2*BusWidth-1:DecimalWidth];
assign test1_y = test1_y_shift[2*BusWidth-1:DecimalWidth];
assign test1_z = test1_z_shift[2*BusWidth-1:DecimalWidth];

assign test2_x = test2_x_shift[2*BusWidth-1:DecimalWidth];
assign test2_y = test2_y_shift[2*BusWidth-1:DecimalWidth];
assign test2_z = test2_z_shift[2*BusWidth-1:DecimalWidth];

assign test3_x = test3_x_shift[2*BusWidth-1:DecimalWidth];
assign test3_y = test3_y_shift[2*BusWidth-1:DecimalWidth]; 
assign test3_z = test3_z_shift[2*BusWidth-1:DecimalWidth]; 

assign nx_out = nx_normalised_reg[31];
assign ny_out = ny_normalised_reg[31];
assign nz_out = nz_normalised_reg[31];

assign interx_out = interx_reg[31];
assign intery_out = intery_reg[31];
assign interz_out = interz_reg[31];

assign t_out = t_reg[31];

assign pixelX_out = pixelX_reg[31];
assign pixelY_out = pixelY_reg[31];

// Instantiate ray lookup table
pixelRayScaleTable
  #(.BusWidth(BusWidth),
	.DecimalWidth(DecimalWidth))
   (.clk(clk), 
	.pixelX(pixelX_reg[1]), 
	.pixelX_minus_160_div_320(pixelX_minus_160_div_320), 
	.pixelY(pixelY_reg[1]), 
	.pixelY_minus_120_div_240(pixelY_minus_120_div_240));

// Dividers and square roots
divider5stage 
  #(.BusWidth(BusWidth),
	.DecimalWidth(DecimalWidth))
   (.clock(clk),
	.clken(clken),
	.denom(raydx_dot_n),
	.numer({negative_o_minus_p2_dot_n, {(DecimalWidth){1'b0}}}),
	.quotient(tdivout),
	.remain());


sqrt2stage
  #(.BusWidth(BusWidth),
	.DecimalWidth(DecimalWidth))
	(.clk(clk),
	.radical(n_sum_of_squares),
	.q(n_magnitude),
	.remainder());


divider5stage 
  #(.BusWidth(BusWidth),
	.DecimalWidth(DecimalWidth))
   (.clock(clk),
	.clken(clken),
	.denom(n_mag),
	.numer({nx_reg[8], {(DecimalWidth){1'b0}}}),
	.quotient(nx_divout),
	.remain());
	
divider5stage 
  #(.BusWidth(BusWidth),
	.DecimalWidth(DecimalWidth))
   (.clock(clk),
	.clken(clken),
	.denom(n_mag),
	.numer({ny_reg[8], {(DecimalWidth){1'b0}}}),
	.quotient(ny_divout),
	.remain());
	
	
divider5stage 
  #(.BusWidth(BusWidth),
	.DecimalWidth(DecimalWidth))
   (.clock(clk),
	.clken(clken),
	.denom(n_mag),
	.numer({nz_reg[8], {(DecimalWidth){1'b0}}}),
	.quotient(nz_divout),
	.remain());

// Main pipeline update logic
always @(posedge clk)
if (clken) begin
	// Stage 1
	fx_times_uy <= fx*uy;
	fx_times_uz <= fx*uz;
	fy_times_ux <= fy*ux;
	fy_times_uz <= fy*uz;
	fz_times_ux <= fz*ux;
	fz_times_uy <= fz*uy;
	
	p2x_minus_p1x <= p2x - p1x;
	p2y_minus_p1y <= p2y - p1y;
	p2z_minus_p1z <= p2z - p1z;

	p3x_minus_p1x <= p3x - p1x;
	p3y_minus_p1y <= p3y - p1y;
	p3z_minus_p1z <= p3z - p1z;
		
	// Stage 2	
	rx_shift <= fy_times_uz - fz_times_uy;
	ry_shift <= fz_times_ux - fx_times_uz;
	rz_shift <= fx_times_uy - fy_times_ux;
		
	p2y_minus_p1y_times_p3z_minus_p1z <= p2y_minus_p1y * p3z_minus_p1z;
	p2z_minus_p1z_times_p3x_minus_p1x <= p2z_minus_p1z * p3x_minus_p1x;
	p2x_minus_p1x_times_p3y_minus_p1y <= p2x_minus_p1x * p3y_minus_p1y;

	p2z_minus_p1z_times_p3y_minus_p1y <= p2z_minus_p1z * p3y_minus_p1y;
	p2x_minus_p1x_times_p3z_minus_p1z <= p2x_minus_p1x * p3z_minus_p1z;
	p2y_minus_p1y_times_p3x_minus_p1x <= p2y_minus_p1y * p3x_minus_p1x;

	// Stage 3
	nx_shift <= p2y_minus_p1y_times_p3z_minus_p1z - p2z_minus_p1z_times_p3y_minus_p1y;
	ny_shift <= p2z_minus_p1z_times_p3x_minus_p1x - p2x_minus_p1x_times_p3z_minus_p1z;
	nz_shift <= p2x_minus_p1x_times_p3y_minus_p1y - p2y_minus_p1y_times_p3x_minus_p1x;

	rx_times_pixelX_minus_160_div_320_shift <= rx * pixelX_minus_160_div_320;
	ry_times_pixelX_minus_160_div_320_shift <= ry * pixelX_minus_160_div_320;
	rz_times_pixelX_minus_160_div_320_shift <= rz * pixelX_minus_160_div_320;
	
	ux_times_pixelY_minus_120_div_240_shift <= ux_reg[2] * pixelY_minus_120_div_240;
	uy_times_pixelY_minus_120_div_240_shift <= uy_reg[2] * pixelY_minus_120_div_240;
	uz_times_pixelY_minus_120_div_240_shift <= uz_reg[2] * pixelY_minus_120_div_240;
	

 	// Stage 4 multiply normals
	nx_square <= 	nx*nx;
	ny_square <=	ny*ny;
	nz_square <=	nz*nz;
	
	// Stage 5 add
	n_sum_of_squares <= nx_square + ny_square + nz_square;

	// Stage 6-7 Sqrt
	
	// Stage 8
	n_mag <= n_magnitude;
	
	// Stage 9-13 Divide
	
	// Stage 14
	nx_normalised <= nx_divout[BusWidth-1:0];
	ny_normalised <= ny_divout[BusWidth-1:0];
	nz_normalised <= nz_divout[BusWidth-1:0];

	ox_minus_p2x <= ox_reg[13] - p2x_reg[13];
    oy_minus_p2y <= oy_reg[13] - p2y_reg[13];
	oz_minus_p2z <= oz_reg[13] - p2z_reg[13];

	// Stage 15
	raydx <= fx_reg[14] + rx_times_pixelX_minus_160_div_320_reg[14] - ux_times_pixelY_minus_120_div_240_reg[14];
	raydy <= fy_reg[14] + ry_times_pixelX_minus_160_div_320_reg[14] - uy_times_pixelY_minus_120_div_240_reg[14];
	raydz <= fz_reg[14] + rz_times_pixelX_minus_160_div_320_reg[14] - uz_times_pixelY_minus_120_div_240_reg[14];

	ox_minus_p2x_times_nx_shift <= ox_minus_p2x * nx_normalised;
	oy_minus_p2y_times_ny_shift <= oy_minus_p2y * ny_normalised;
	oz_minus_p2z_times_nz_shift <= oz_minus_p2z * nz_normalised;
	
	// Stage 16
	o_minus_p2_dot_n <= ox_minus_p2x_times_nx + oy_minus_p2y_times_ny + oz_minus_p2z_times_nz;
	
	raydx_times_nx_shift <= raydx * nx_normalised_reg[15];
	raydy_times_ny_shift <= raydy * ny_normalised_reg[15];
	raydz_times_nz_shift <= raydz * nz_normalised_reg[15];
	
	// Stage 17
	negative_o_minus_p2_dot_n <= ~o_minus_p2_dot_n + {{(BusWidth-1){1'b0}},1'b1};
	raydx_dot_n <= raydx_times_nx + raydy_times_ny + raydz_times_nz; 

	// Stage 18-22 Divide
	
	// Stage 23
	t <= tdivout[BusWidth-1:0];
	
	// Stage 24
	t_times_fx_shift <= t * raydx_reg[23];
	t_times_fy_shift <= t * raydy_reg[23];
	t_times_fz_shift <= t * raydz_reg[23];
	
	// Stage 25
	interx <= t_times_fx + ox_reg[24];
	intery <= t_times_fy + oy_reg[24];
	interz <= t_times_fz + oz_reg[24];
	
	// Stage 26
	interx_minus_p1x <= (interx - p1x_reg[25]);
	intery_minus_p1y <= (intery - p1y_reg[25]);
	interz_minus_p1z <= (interz - p1z_reg[25]);
	
	interx_minus_p2x <= (interx - p2x_reg[25]);
	intery_minus_p2y <= (intery - p2y_reg[25]);
	interz_minus_p2z <= (interz - p2z_reg[25]);

	interx_minus_p3x <= (interx - p3x_reg[25]);
	intery_minus_p3y <= (intery - p3y_reg[25]);
	interz_minus_p3z <= (interz - p3z_reg[25]);

	p2x_minus_p1x_26 <= p2x_reg[25] - p1x_reg[25];
	p3x_minus_p2x_26 <= p3x_reg[25] - p2x_reg[25];
	p3x_minus_p1x_26 <= p3x_reg[25] - p1x_reg[25];
	
	p2y_minus_p1y_26 <= p2y_reg[25] - p1y_reg[25];
	p3y_minus_p2y_26 <= p3y_reg[25] - p2y_reg[25];
	p3y_minus_p1y_26 <= p3y_reg[25] - p1y_reg[25];
	
	p2z_minus_p1z_26 <= p2z_reg[25] - p1z_reg[25];
	p3z_minus_p2z_26 <= p3z_reg[25] - p2z_reg[25];
	p3z_minus_p1z_26 <= p3z_reg[25] - p1z_reg[25];
	
	// Stage 27
	test1_mul1_a_shift <= p2y_minus_p1y_26 * interz_minus_p1z;
	test1_mul1_b_shift <= p2z_minus_p1z_26 * intery_minus_p1y;
	test1_mul2_a_shift <= p2z_minus_p1z_26 * interx_minus_p1x;
	test1_mul2_b_shift <= p2x_minus_p1x_26 * interz_minus_p1z;
	test1_mul3_a_shift <= p2x_minus_p1x_26 * intery_minus_p1y;
	test1_mul3_b_shift <= p2y_minus_p1y_26 * interx_minus_p1x;
	
	test2_mul1_a_shift <= p3y_minus_p2y_26 * interz_minus_p2z;
	test2_mul1_b_shift <= p3z_minus_p2z_26 * intery_minus_p2y;
	test2_mul2_a_shift <= p3z_minus_p2z_26 * interx_minus_p2x;
	test2_mul2_b_shift <= p3x_minus_p2x_26 * interz_minus_p2z;
	test2_mul3_a_shift <= p3x_minus_p2x_26 * intery_minus_p2y;
	test2_mul3_b_shift <= p3y_minus_p2y_26 * interx_minus_p2x;
	
	test3_mul1_a_shift <= p3y_minus_p1y_26 * interz_minus_p3z;
	test3_mul1_b_shift <= p3z_minus_p1z_26 * intery_minus_p3y;
	test3_mul2_a_shift <= p3z_minus_p1z_26 * interx_minus_p3x;
	test3_mul2_b_shift <= p3x_minus_p1x_26 * interz_minus_p3z;
	test3_mul3_a_shift <= p3x_minus_p1x_26 * intery_minus_p3y;
	test3_mul3_b_shift <= p3y_minus_p1y_26 * interx_minus_p3x;
	
	// Stage 28
	test1_mul1 <= test1_mul1_a - test1_mul1_b;
	test1_mul2 <= test1_mul2_a - test1_mul2_b;
	test1_mul3 <= test1_mul3_a - test1_mul3_b;	
	
	test2_mul1 <= test2_mul1_a - test2_mul1_b;
	test2_mul2 <= test2_mul2_a - test2_mul2_b;
	test2_mul3 <= test2_mul3_a - test2_mul3_b;

	test3_mul1 <= test3_mul1_a - test3_mul1_b;
	test3_mul2 <= test3_mul2_a - test3_mul2_b;
	test3_mul3 <= test3_mul3_a - test3_mul3_b;
	
	// Stage 29
	test1_x_shift <= test1_mul1 * nx_normalised_reg[28];
	test1_y_shift <= test1_mul2 * ny_normalised_reg[28];
	test1_z_shift <= test1_mul3 * nz_normalised_reg[28];
	
	test2_x_shift <= test2_mul1 * nx_normalised_reg[28];
	test2_y_shift <= test2_mul2 * ny_normalised_reg[28];
	test2_z_shift <= test2_mul3 * nz_normalised_reg[28];

	test3_x_shift <= test3_mul1 * nx_normalised_reg[28];
	test3_y_shift <= test3_mul2 * ny_normalised_reg[28];
	test3_z_shift <= test3_mul3 * nz_normalised_reg[28];

	// Stage 30
	test1 <= test1_x + test1_y + test1_z;
	test2 <= test2_x + test2_y + test2_z;
	test3 <= test3_x + test3_y + test3_z;

	// Stage 31
	hit_out <= (!test1[2*BusWidth-DecimalWidth-1]) && (!test2[2*BusWidth-DecimalWidth-1]) && (test3[2*BusWidth-DecimalWidth-1]);
end

integer a;

// Shift register update logic
always @(posedge clk)
if (clken) begin
	p1x_reg[1] <= p1x;
	p1y_reg[1] <= p1y;
	p1z_reg[1] <= p1z;
	
	p2x_reg[1] <= p2x;
	p2y_reg[1] <= p2y;
	p2z_reg[1] <= p2z;
	
	p3x_reg[1] <= p3x;
	p3y_reg[1] <= p3y;
	p3z_reg[1] <= p3z;
	
	for (a = 2; a <= 31; a = a + 1)
	begin
		p1x_reg[a] <= p1x_reg[a-1];
		p1y_reg[a] <= p1y_reg[a-1];
		p1z_reg[a] <= p1z_reg[a-1];
		
		p2x_reg[a] <= p2x_reg[a-1];
		p2y_reg[a] <= p2y_reg[a-1];
		p2z_reg[a] <= p2z_reg[a-1];
		
		p3x_reg[a] <= p3x_reg[a-1];
		p3y_reg[a] <= p3y_reg[a-1];
		p3z_reg[a] <= p3z_reg[a-1];
	end
	
	ox_reg[1] <= ox;
	oy_reg[1] <= oy;
	oz_reg[1] <= oz;

	for (a = 2; a <= 24; a = a + 1)
	begin
		ox_reg[a] <= ox_reg[a-1];
		oy_reg[a] <= oy_reg[a-1];
		oz_reg[a] <= oz_reg[a-1];
	end
	
	fx_reg[1] <= fx;
	fy_reg[1] <= fy;
	fz_reg[1] <= fz;
	
	for (a = 2; a <= 14; a = a + 1)
	begin
		fx_reg[a] <= fx_reg[a-1];
		fy_reg[a] <= fy_reg[a-1];
		fz_reg[a] <= fz_reg[a-1];
	end
	
	nx_reg[4] <= nx;
	ny_reg[4] <= ny;
	nz_reg[4] <= nz;
	
	for (a = 5; a <= 8; a = a + 1)
	begin
		nx_reg[a] <= nx_reg[a-1];
		ny_reg[a] <= ny_reg[a-1];
		nz_reg[a] <= nz_reg[a-1];
	end
	
	
	nx_normalised_reg[15] <= nx_normalised;
	ny_normalised_reg[15] <= ny_normalised;
	nz_normalised_reg[15] <= nz_normalised;
	
	for (a = 16; a <= 31; a = a + 1)
	begin
		nx_normalised_reg[a] <= nx_normalised_reg[a-1];
		ny_normalised_reg[a] <= ny_normalised_reg[a-1];
		nz_normalised_reg[a] <= nz_normalised_reg[a-1];
	end
	
	raydx_reg[16] <= raydx;
	raydy_reg[16] <= raydy;
	raydz_reg[16] <= raydz;
	
	for (a = 17; a <= 23; a = a + 1)
	begin
		raydx_reg[a] <= raydx_reg[a-1];
		raydy_reg[a] <= raydy_reg[a-1];
		raydz_reg[a] <= raydz_reg[a-1];
	end
	
	interx_reg[26] <= interx;
	intery_reg[26] <= intery;
	interz_reg[26] <= interz;
	
	for (a = 27; a <= 31; a = a + 1)
	begin
		interx_reg[a] <= interx_reg[a-1];
		intery_reg[a] <= intery_reg[a-1];
		interz_reg[a] <= interz_reg[a-1];
	end
	
	t_reg[24] <= t;
	for (a = 25; a <= 31; a = a + 1)
	begin
		t_reg[a] <= t_reg[a-1];
	end
	
	pixelX_reg[1] <= pixelX;
	pixelY_reg[1] <= pixelY;
	for (a = 2; a <= 31; a = a + 1)
	begin
		pixelX_reg[a] <= pixelX_reg[a-1];
		pixelY_reg[a] <= pixelY_reg[a-1];
	end	
	
	ux_reg[1] <= ux;
	uy_reg[1] <= uy;
	uz_reg[1] <= uz;
	for (a = 2; a <= 2; a = a + 1)
	begin
		ux_reg[a] <= ux_reg[a-1];
		uy_reg[a] <= uy_reg[a-1];
		uz_reg[a] <= uz_reg[a-1];
	end	
	
	rx_times_pixelX_minus_160_div_320_reg[4] <= rx_times_pixelX_minus_160_div_320;
	ry_times_pixelX_minus_160_div_320_reg[4] <= ry_times_pixelX_minus_160_div_320;
	rz_times_pixelX_minus_160_div_320_reg[4] <= rz_times_pixelX_minus_160_div_320;
	
	for (a = 5; a <= 14; a = a + 1)
	begin
		rx_times_pixelX_minus_160_div_320_reg[a]<=rx_times_pixelX_minus_160_div_320_reg[a-1];
		ry_times_pixelX_minus_160_div_320_reg[a]<=ry_times_pixelX_minus_160_div_320_reg[a-1];
		rz_times_pixelX_minus_160_div_320_reg[a]<=rz_times_pixelX_minus_160_div_320_reg[a-1];
	end	
	
	
	ux_times_pixelY_minus_120_div_240_reg[4] <= ux_times_pixelY_minus_120_div_240;
	uy_times_pixelY_minus_120_div_240_reg[4] <= uy_times_pixelY_minus_120_div_240;
	uz_times_pixelY_minus_120_div_240_reg[4] <= uz_times_pixelY_minus_120_div_240;
	
	for (a = 5; a <= 14; a = a + 1)
	begin
		ux_times_pixelY_minus_120_div_240_reg[a]<=ux_times_pixelY_minus_120_div_240_reg[a-1];
		uy_times_pixelY_minus_120_div_240_reg[a]<=uy_times_pixelY_minus_120_div_240_reg[a-1];
		uz_times_pixelY_minus_120_div_240_reg[a]<=uz_times_pixelY_minus_120_div_240_reg[a-1];	
	end
end

// Debugging
output [BusWidth*5-1:0] debug;

assign debug = {16'hffff, negative_o_minus_p2_dot_n, raydx_dot_n};


endmodule