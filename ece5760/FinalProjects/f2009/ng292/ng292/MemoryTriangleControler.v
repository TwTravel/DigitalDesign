`include "header.vh"

module MemoryTriangleControler(
	input clock,
	input n_pause,
	input n_reset,
	
	// Communication protocols
	input drawing,
	output wire completed,
	
	// Memory access
	output reg write,					// write enable for SRAM
	output reg [17:0] addr_reg,			// memory address register for SRAM
	output reg [15:0] data_reg,			// memory data register  for SRAM
	
	input [`pixel - 1 : 0] 
		p1_x, p1_y, 
		p2_x, p2_y, 
		p3_x, p3_y,

	input [`color - 1 : 0] 
		p1_z, p1_r, p1_g, p1_b,
		p2_z, p2_r, p2_g, p2_b,
		p3_z, p3_r, p3_g, p3_b,	
	
	// Z-Buffering consideration
	input z_enable,						// z_enable
	input z_existence,					// data from for z existence
	input [`z_size - 1 : 0] z_data,		// data from for z value
	
	// Lightening consideration
	input light_enable,	
	input [`light_rgb - 1 : 0] light_r, light_g, light_b,
	input [`light_rgb - 1 : 0] material_r, material_g, material_b, 
	input [`float - 1 : 0] light_n_x, light_n_y, light_n_z,

	input [`float - 1 : 0] n_x, n_y, n_z
	
	// Debug
	/*
	output wire [`pixel - 1 : 0] d_x, d_y,	
	output wire [`color - 1 : 0] d_z, d_r, d_g, d_b, d_a, 
	*/
);	
	
	parameter
		stIdle = 3'd0,
		stClearingMemory = 3'd1,
		stInitializeDrawing = 3'd2,
		stDrawing = 3'd3,
		stGetZWriteRGB = 3'd4,
		stWriteZ = 3'd5;
		
	reg[2:0] state = stIdle;
		assign completed = (state == stIdle);
	
	//	assign d_state = state;
	
	(* keep *) wire [`pixel - 1 : 0] x, y;		
	
	(* keep *) wire [`z_size - 1 : 0] z;
	
	(* keep *) wire [`color - 1 : 0] r, g, b;
	/*
		assign d_x = x;
		assign d_y = y;
		assign d_r = r;
		assign d_g = g;
		assign d_b = b;
	*/

	wire r_n_pause;
		assign r_n_pause = (state == stDrawing) | (state == stInitializeDrawing);
	
	wire r_start;
		assign r_start = (state == stInitializeDrawing);
		
	(* keep *) wire f_newPoint, f_completed;	
	
	TriangleRenderer render
	(
		.x(x),
		.y(y),
		.z(z),
		.r(r),
		.g(g),
		.b(b),		
		
		.clock(clock),
		.n_reset(n_reset),
		.n_pause(r_n_pause),
		
		.newPoint(f_newPoint),
		
		.start(r_start),
		.completed(f_completed),
		
		.p1_x(p1_x),
		.p1_y(p1_y),
		.p1_z(p1_z),
		.p1_r(p1_r),
		.p1_g(p1_g),
		.p1_b(p1_b),
		
		.p2_x(p2_x),
		.p2_y(p2_y),
		.p2_z(p2_z),
		.p2_r(p2_r),
		.p2_g(p2_g),
		.p2_b(p2_b),
		
		.p3_x(p3_x),
		.p3_y(p3_y),
		.p3_z(p3_z),
		.p3_r(p3_r),
		.p3_g(p3_g),
		.p3_b(p3_b)
	);
	
	(* preserve *) reg [`pixel - 1 : 0] m_x, m_y;
	(* preserve *) reg [`z_size - 1 : 0] m_z;
	(* preserve *) reg [`color - 1 : 0] m_r, m_g, m_b;
	
	(* keep *) wire lightened;	// Whether the object is lightened
	(* keep *) wire [2 * `float - 3 : 0] f_light_factor_p, f_light_factor_n, f_light_factor;
	
		assign f_light_factor_p = // Positive terms
			n_x[0] == light_n_x[0] ? (	// X same sign
				n_y[0] == light_n_y[0] ? (	// Y same sign
					n_z[0] == light_n_z[0] ? (	// Z same sign
						(		(light_n_x[`float - 2 : 0]) * (n_x[`float - 2 : 0]) 
							+ 	(light_n_y[`float - 2 : 0]) * (n_y[`float - 2 : 0]) 
							+ 	(light_n_z[`float - 2 : 0]) * (n_z[`float - 2 : 0])
						)
					) : (	// Z not same sign
								(light_n_x[`float - 2 : 0]) * (n_x[`float - 2 : 0]) 
							+ 	(light_n_y[`float - 2 : 0]) * (n_y[`float - 2 : 0])
					)
				) : (	// Y not same sign
					n_z[0] == light_n_z[0] ? (	// Z same sign
						(		(light_n_x[`float - 2 : 0]) * (n_x[`float - 2 : 0]) 
							+ 	(light_n_z[`float - 2 : 0]) * (n_z[`float - 2 : 0])
						)
					) : (	// Z not same sign
								(light_n_x[`float - 2 : 0]) * (n_x[`float - 2 : 0]) 
					)
				)
			) : (	// X not same sign
				n_y[0] == light_n_y[0] ? (	// Y same sign
					n_z[0] == light_n_z[0] ? (	// Z same sign
						(	 	(light_n_y[`float - 2 : 0]) * (n_y[`float - 2 : 0]) 
							+ 	(light_n_z[`float - 2 : 0]) * (n_z[`float - 2 : 0])
						)
					) : (	// Z not same sign
							 	(light_n_y[`float - 2 : 0]) * (n_y[`float - 2 : 0]) 							
					)
				) : (	// Y not same sign
					n_z[0] == light_n_z[0] ? (	// Z same sign
						(	(light_n_z[`float - 2 : 0]) * (n_z[`float - 2 : 0])
						)
					) : (	// Z not same sign
							`false
					)
				)
			);
			
		assign f_light_factor_n = // Negative terms
			n_x[0] == light_n_x[0] ? (	// X same sign
				n_y[0] == light_n_y[0] ? (	// Y same sign
					n_z[0] == light_n_z[0] ? (	// Z same sign
						(	`false
						)
					) : (	// Z not same sign
								(light_n_z[`float - 2 : 0]) * (n_z[`float - 2 : 0])
					)
				) : (	// Y not same sign
					n_z[0] == light_n_z[0] ? (	// Z same sign
						(		(light_n_y[`float - 2 : 0]) * (n_y[`float - 2 : 0]) 							
						)
					) : (	// Z not same sign
								(light_n_y[`float - 2 : 0]) * (n_y[`float - 2 : 0]) 
							+ 	(light_n_z[`float - 2 : 0]) * (n_z[`float - 2 : 0])
					)
				)
			) : (	// X not same sign
				n_y[0] == light_n_y[0] ? (	// Y same sign
					n_z[0] == light_n_z[0] ? (	// Z same sign
						(		(light_n_x[`float - 2 : 0]) * (n_x[`float - 2 : 0]) 
						)
					) : (	// Z not same sign
								(light_n_x[`float - 2 : 0]) * (n_x[`float - 2 : 0]) 							
							+ 	(light_n_z[`float - 2 : 0]) * (n_z[`float - 2 : 0])
					)
				) : (	// Y not same sign
					n_z[0] == light_n_z[0] ? (	// Z same sign
						(		(light_n_x[`float - 2 : 0]) * (n_x[`float - 2 : 0]) 
							+ 	(light_n_y[`float - 2 : 0]) * (n_y[`float - 2 : 0]) 
						)
					) : (	// Z not same sign
								(light_n_x[`float - 2 : 0]) * (n_x[`float - 2 : 0]) 
							+ 	(light_n_y[`float - 2 : 0]) * (n_y[`float - 2 : 0]) 
							+ 	(light_n_z[`float - 2 : 0]) * (n_z[`float - 2 : 0])
					)
				)
			);
		
		assign f_light_factor = f_light_factor_p - f_light_factor_n;
					
		assign lightened = f_light_factor_p > f_light_factor_n;		
		
	(* keep *) wire [`float - 2 : 0] light_factor;
			assign light_factor = f_light_factor[2 * `float - 3 : `float - 5];

	(* keep *) wire [`light_rgb + `float - 2 : 0] f_material_r_light, f_material_g_light, f_material_b_light;
		assign f_material_r_light = material_r * light_factor;
		assign f_material_g_light = material_g * light_factor;
		assign f_material_b_light = material_b * light_factor;
		
	(* keep *) wire [`color - 1 : 0] material_r_light, material_g_light, material_b_light;
		assign material_r_light = f_material_r_light[`light_rgb + `float - 2 : `light_rgb + `float - 2 - `color + 1];
		assign material_g_light = f_material_g_light[`light_rgb + `float - 2 : `light_rgb + `float - 2 - `color + 1];
		assign material_b_light = f_material_b_light[`light_rgb + `float - 2 : `light_rgb + `float - 2 - `color + 1];

	always@(posedge clock) if(n_pause) begin
		case(state)				
			stIdle:begin
				write <= `false;
				if(drawing)begin
					state <= stInitializeDrawing;
				end
			end			
			
			stInitializeDrawing:begin
				write <= `false;
				state <= stDrawing;
			end
			
			stDrawing:begin
				if(f_completed)begin
					state <= stIdle;
					write <= `false;
				end else if(f_newPoint)begin	
					if(~y[8])begin
						if(z_enable)begin
							addr_reg <= {`true, y[7 : 0], x};
							write <= `false;
							m_x <= x;
							m_y <= y;
							m_r <= r;
							m_g <= g;
							m_b <= b;
							m_z <= z;
							state <= stGetZWriteRGB;							
						end else begin
							addr_reg <= {y, x};
							if(light_enable)begin
								if(lightened)begin
									data_reg <= {	material_r_light, 
													material_g_light, 
													material_b_light,
													`true};
								end else begin
									data_reg <= {	{`color'b0}, 
													{`color'b0}, 
													{`color'b0},
													`true};
								end
							end else begin
								data_reg <= {r, g, b, `false};
							end
							write <= `true;
							state <= stWriteZ;
						end
					end else begin // Out of screen
						write <= `false;
						state <= stDrawing;
					end
				end else
					write <= `false;
			end	
			
			stGetZWriteRGB:begin					
				if((~z_existence)|(z_data < m_z))begin
					if(light_enable)begin
						if(lightened)begin
							data_reg <= {	material_r_light, 
											material_g_light, 
											material_b_light,
											`false};
						end else begin
							data_reg <= {	{`color'b0}, 
											{`color'b0}, 
											{`color'b0},
											`false};
						end
					end else begin
						data_reg <= {m_r, m_g, m_b, `false};
					end
					addr_reg <= {m_y, m_x};					
					write <= `true; 
					
					state <= stWriteZ;				
				end else begin				
					write <= `false;
					state <= stDrawing;
				end	
					
			end	
			
			stWriteZ:begin
				addr_reg <= {`true, m_y[7 : 0], m_x};	
				data_reg <= {{(16 - `z_size - 1){1'b0}}, m_z, `true};
				write <= `true; 									
				state <= stDrawing;
			end		
		endcase
	end

endmodule 