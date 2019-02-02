`include "header.vh"

/*
	Description
	Draw a line on x - iteration
	Assumes p1_x <= p2_x
	Limits color channel to increase at maximum 1 at a time
*/

module LineTriangleRenderer(
	
	input clock,
	input n_reset,
	input n_pause,
	
	input start,
	output wire completed,
	
	output reg[`pixel - 1 : 0] x,
	output reg[`pixel - 1 : 0] y,
	output reg[`z_size - 1 : 0] z,
	output reg[`color - 1 : 0] r, 
	output reg[`color - 1 : 0] g, 
	output reg[`color - 1 : 0] b,
	
	output wire newX,
	
	input [`pixel - 1 : 0] p1_x,
	input [`pixel - 1 : 0] p1_y,
	input [`z_size - 1 : 0] p1_z,
	input [`color - 1 : 0] p1_r,
	input [`color - 1 : 0] p1_g,
	input [`color - 1 : 0] p1_b,
	
	input [`pixel - 1 : 0] p2_x,
	input [`pixel - 1 : 0] p2_y,
	input [`z_size - 1 : 0] p2_z,
	input [`color - 1 : 0] p2_r,
	input [`color - 1 : 0] p2_g,
	input [`color - 1 : 0] p2_b
	/*
	,output [`pixel - 1 : 0] d_dx, d_dy, 
	output [`color - 1 : 0] d_z, d_r, d_g, d_g,
	output [`pixel + 1 : 0] d_ey
	*/
);

	parameter
		stIdle = 2'd0,
		stNewX = 2'd1,
		stDrawing = 2'd2,
		stCompleted = 2'd3;	
			
	reg[1:0] state;		
	
	assign newX = (state == stNewX);
		
	wire[`pixel - 1 : 0] dx, dy;
		assign dx = p2_x - p1_x;
		assign dy = (p2_y >= p1_y) ? (p2_y - p1_y) : (p1_y - p2_y);

	wire[`z_size - 1 : 0] dz;
		assign dz = (p2_z >= p1_z) ? (p2_z - p1_z) : (p1_z - p2_z);
	
	wire[`color - 1 : 0] dr, dg, db;
		assign dr = (p2_r >= p1_r) ? (p2_r - p1_r) : (p1_r - p2_r);
		assign dg = (p2_g >= p1_g) ? (p2_g - p1_g) : (p1_g - p2_g);
		assign db = (p2_b >= p1_b) ? (p2_b - p1_b) : (p1_b - p2_b);
	
	wire signed[`pixel - 1 : 0] sy;
		assign sy = (p2_y >= p1_y) ? (`pixel'b1) : (`pixel'b0 - `pixel'b1);
		
	wire signed[`z_size - 1 : 0] sz;
		assign sz = (p2_z >= p1_z) ? (`color'b1) : (`color'b0 - `color'b1);
		
	wire signed[`color - 1 : 0] sr, sg, sb;		
		assign sr = (p2_r >= p1_r) ? (`color'b1) : (`color'b0 - `color'b1);
		assign sg = (p2_g >= p1_g) ? (`color'b1) : (`color'b0 - `color'b1);
		assign sb = (p2_b >= p1_b) ? (`color'b1) : (`color'b0 - `color'b1);
	
	// 0 -> x
	// 1 -> y
	wire coordMax;
		assign coordMax = dx >= dy ? `false : `true;
		
	reg signed[`pixel + 1 : 0] ey, ez, er, eg, eb;
	
	/*
	assign d_dx = dx;
	assign d_dy = dy;
	
	assign d_z = z;
	assign d_r = r;
	assign d_g = g;
	assign d_b = b;
	assign d_a = a;
	
	assign d_ey = ey;
	*/
	
	assign completed = (state == stIdle);
		
	always@(posedge clock)begin
		if(n_reset)begin
			if(n_pause)begin
				case(state)
					stIdle:begin 
						if(start)begin
							state <= stNewX;							
							ey <= 1'b0;	
							ez <= 1'b0;
							er <= 1'b0;
							eg <= 1'b0;
							eb <= 1'b0;
													
							x <= p1_x;
							y <= p1_y;
							z <= p1_z;
							r <= p1_r;
							g <= p1_g;
							b <= p1_b;
						end
					end
					
					stNewX:begin
						state <= stDrawing;
					end
					
					stDrawing:begin
						if(coordMax==`false)begin
							if(x < p2_x)begin
								x <= x + `pixel'b1;
								if(ey > 0)begin
									y <= y + sy;
									ey <= ey - (dx << 1) + (dy << 1);
								end else begin
									y <= y;
									ey <= ey + (dy << 1);
								end
								if(ez > 0)begin
									z <= z + sz;
									ez <= ez - (dx << 1) + (dz << 1);
								end else begin
									z <= z;
									ez <= ez + (dz << 1);
								end
								if(er > 0)begin
									r <= r + sr;
									er <= er - (dx << 1) + (dr << 1);
								end else begin
									r <= r;
									er <= er + (dr << 1);
								end
								if(eg > 0)begin
									g <= g + sg;
									eg <= eg - (dx << 1) + (dg << 1);
								end else begin
									g <= g;
									eg <= eg + (dg << 1);
								end
								if(eb > 0)begin
									b <= b + sb;
									eb <= eb - (dx << 1) + (db << 1);
								end else begin
									b <= b;
									eb <= eb + (db << 1);
								end
								state <= stNewX;
							end else begin
								state <= stCompleted;
							end
						end else begin
							if(~sy[`pixel - 1])begin
								if(y < p2_y)begin
									y <= y + `pixel'b1;
									if(ey > 0)begin
										x <= x + `pixel'b1;
										ey <= ey - (dy << 1) + (dx << 1);
										state <= stNewX;
									end else begin
										x <= x;
										ey <= ey + (dx << 1);
									end
									if(ez > 0)begin
										z <= z + sz;
										ez <= ez - (dy << 1) + (dz << 1);
									end else begin
										z <= z;
										ez <= ez + (dz << 1);
									end
									if(er > 0)begin
										r <= r + sr;
										er <= er - (dy << 1) + (dr << 1);
									end else begin
										r <= r;
										er <= er + (dr << 1);
									end
									if(eg > 0)begin
										g <= g + sg;
										eg <= eg - (dy << 1) + (dg << 1);
									end else begin
										g <= g;
										eg <= eg + (dg << 1);
									end
									if(eb > 0)begin
										b <= b + sb;
										eb <= eb - (dy << 1) + (db << 1);
									end else begin
										b <= b;
										eb <= eb + (db << 1);
									end
								end else begin
									state <= stCompleted;
								end
							end else begin
								if(y > p2_y)begin
									y <= y - `pixel'b1;
									if(ey > 0)begin
										x <= x + `pixel'b1;
										ey <= ey - (dy << 1) + (dx << 1);
										state <= stNewX;
									end else begin
										x <= x;
										ey <= ey + (dx << 1);
									end
									if(ez > 0)begin
										z <= z + sz;
										ez <= ez - (dy << 1) + (dz << 1);
									end else begin
										z <= z;
										ez <= ez + (dz << 1);
									end
									if(er > 0)begin
										r <= r + sr;
										er <= er - (dy << 1) + (dr << 1);
									end else begin
										r <= r;
										er <= er + (dr << 1);
									end	
									if(eg > 0)begin
										g <= g + sg;
										eg <= eg - (dy << 1) + (dg << 1);
									end else begin
										g <= g;
										eg <= eg + (dg << 1);
									end	
									if(eb > 0)begin
										b <= b + sb;
										eb <= eb - (dy << 1) + (db << 1);
									end else begin
										b <= b;
										eb <= eb + (db << 1);
									end
								end else begin
									state <= stCompleted;
								end
							end
						end
					end
					
					stCompleted:begin
						if(~start)
							state <= stIdle;
					end
				endcase
			end
		end else
		  state <= stIdle;
	end

endmodule
