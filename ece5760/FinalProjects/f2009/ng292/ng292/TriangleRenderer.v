`include "header.vh"

module TriangleRenderer(

	output reg[`pixel - 1 : 0] x,
	output reg[`pixel - 1 : 0] y,
	output reg[`z_size - 1 : 0] z,
	output reg[`color - 1 : 0] r,
	output reg[`color - 1 : 0] g,
	output reg[`color - 1 : 0] b,
	
	input clock,
	input n_reset,
	input n_pause,
	
	output reg newPoint,
	
	input start,
	output wire completed,
	
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
	input [`color - 1 : 0] p2_b,
	
	input [`pixel - 1 : 0] p3_x,
	input [`pixel - 1 : 0] p3_y,
	input [`z_size - 1 : 0] p3_z,
	input [`color - 1 : 0] p3_r,
	input [`color - 1 : 0] p3_g,
	input [`color - 1 : 0] p3_b
	/*
	,output [`pixel - 1 : 0] 
		d_tx, d_ty, 
		d_bx, d_by
	,output d_second 
	,output d_corner 
	,output [`color - 1 : 0] 
		d_tz, d_tr, d_tg, d_tb, d_ta
		d_bz, d_br, d_bg, d_bb, d_ba
	,output d_tNewX, d_bNewX
	*/	
);

	parameter
		stIdle = 3'd0,
		stRbothNewX = 3'd1,
		stRtNewX = 3'd2,
		stRbNewX = 3'd3,
		stRecNewX = 3'd4,
		stDrawing = 3'd5,
		stCompleted = 3'd6;
		
	reg[2:0] state;

	reg second;
	
	assign completed = (state == stIdle);
	
	reg tUpdating, bUpdating;
	reg tStart, bStart;	
	reg tN_reset, bN_reset;
	
	// For left byte
	// 0 : bottom corner
	// 1 : top corner
	reg corner;
	
	reg [`pixel - 1 : 0] 
		tP1x, tP1y, 
		tP2x, tP2y, 
		
		bP1x, bP1y, 
		bP2x, bP2y;
	
	wire [`pixel - 1 : 0] 
		tx, ty, 
		bx, by;
	
	reg [`z_size - 1 : 0] 
		tP1z, tP2z, bP1z, bP2z;
	
	reg [`color - 1 : 0] 
		tP1r, tP1g, tP1b,
		tP2r, tP2g, tP2b,
		bP1r, bP1g, bP1b, 
		bP2r, bP2g, bP2b;
		
	wire [`z_size - 1 : 0] tz, bz;
		
	wire [`color - 1 : 0] 
		tr, tg, tb, 
		br, bg, bb;
		
	wire tNewX, bNewX;
	
	wire[`z_size - 1 : 0] dz;
		assign dz = (tz >= bz) ? (tz - bz) : (bz - tz);
		
	wire[`color - 1 : 0] dr, dg, db;		
		assign dr = (tr >= br) ? (tr - br) : (br - tr);
		assign dg = (tg >= bg) ? (tg - bg) : (bg - tg);
		assign db = (tb >= bb) ? (tb - bb) : (bb - tb);
	
	wire signed[`z_size - 1 : 0] sz;
		assign sz = (tz >= bz) ? (`color'b1) : (`color'b0 - `color'b1);
	
	wire signed[`color - 1 : 0] sr, sg, sb;		
		assign sr = (tr >= br) ? (`color'b1) : (`color'b0 - `color'b1);
		assign sg = (tg >= bg) ? (`color'b1) : (`color'b0 - `color'b1);
		assign sb = (tb >= bb) ? (`color'b1) : (`color'b0 - `color'b1);
	
	reg signed[`pixel + 1 : 0] ez, er, eg, eb;
	
	/*
	assign d_tx = tx;
	assign d_ty = ty;
	
	assign d_bx = bx;
	assign d_by = by;
	
	assign d_second = second;
	assign d_corner = corner;
	
	assign d_tNewX = tNewX;
	assign d_bNewX = bNewX;

	assign d_tz = tz;
	assign d_tr = tr;
	assign d_tg = tg;
	assign d_tb = tb;
	assign d_ta = ta;
	
	assign d_bz = bz;
	assign d_br = br;
	assign d_bg = bg;
	assign d_bb = bb;
	assign d_ba = ba;
	*/
	
	LineTriangleRenderer tLine(
		.clock(clock),
		.n_reset(tN_reset),
		.n_pause(tUpdating),
		.start(tStart),
		.x(tx),
		.y(ty),
		.z(tz),
		.r(tr),
		.g(tg),
		.b(tb),
		.newX(tNewX),
		
		.p1_x(tP1x),
		.p1_y(tP1y),
		.p1_z(tP1z),
		.p1_r(tP1r),
		.p1_g(tP1g),
		.p1_b(tP1b),
		
		.p2_x(tP2x),
		.p2_y(tP2y),
		.p2_z(tP2z),
		.p2_r(tP2r),
		.p2_g(tP2g),
		.p2_b(tP2b)
	);
	
	LineTriangleRenderer bLine(
		.clock(clock),
		.n_reset(bN_reset),
		.n_pause(bUpdating),
		.start(bStart),
		.x(bx),
		.y(by),
		.z(bz),
		.r(br),
		.g(bg),
		.b(bb),
		.newX(bNewX),
		
		.p1_x(bP1x),
		.p1_y(bP1y),
		.p1_z(bP1z),
		.p1_r(bP1r),
		.p1_g(bP1g),
		.p1_b(bP1b),
		
		.p2_x(bP2x),
		.p2_y(bP2y),
		.p2_z(bP2z),
		.p2_r(bP2r),
		.p2_g(bP2g),
		.p2_b(bP2b)
	);

	wire signed [`pixel : 0] y12 = p2_y - p1_y;
	wire signed [`pixel : 0] y23 = p3_y - p2_y;
	wire signed [`pixel : 0] y31 = p1_y - p3_y;
	wire signed [`pixel : 0] y21 = p1_y - p2_y;
	wire signed [`pixel : 0] y32 = p2_y - p3_y;
	wire signed [`pixel : 0] y13 = p3_y - p1_y;
	
	wire signed [`pixel : 0] x12 = p2_x - p1_x;
	wire signed [`pixel : 0] x23 = p3_x - p2_x;
	wire signed [`pixel : 0] x31 = p1_x - p3_x;
	wire signed [`pixel : 0] x21 = p1_x - p2_x;
	wire signed [`pixel : 0] x32 = p2_x - p3_x;
	wire signed [`pixel : 0] x13 = p3_x - p1_x;
	
	wire signed [2 * `pixel : 0] x12y13 = x12 * y13;
	wire signed [2 * `pixel : 0] y12x13 = y12 * x13;
	
	always@(posedge clock)begin
		if(n_reset)begin
			if(n_pause)begin
				case(state)
					stIdle:begin 
						if(start)begin
							state <= stRbothNewX;							
							tUpdating <= `true;
							bUpdating <= `true;
							
							tN_reset <= `true;
							bN_reset <= `true;
							
							tStart <= `true;
							bStart <= `true;
														
							second <= `false;
							
							newPoint <= `false;
							
							if((p1_x <= p2_x)&(p1_x <= p3_x))begin // 1 ? ?
								tP1x <= p1_x;
								tP1y <= p1_y;
								tP1z <= p1_z;
								tP1r <= p1_r;
								tP1g <= p1_g;
								tP1b <= p1_b;
								
								bP1x <= p1_x;
								bP1y <= p1_y;
								bP1z <= p1_z;
								bP1r <= p1_r;
								bP1g <= p1_g;
								bP1b <= p1_b;							
								if(p2_x <= p3_x)begin // 1 2 3	
									if(x12y13 >= y12x13)begin
										tP2x <= p3_x;
										tP2y <= p3_y;
										tP2z <= p3_z;
										tP2r <= p3_r;
										tP2g <= p3_g;
										tP2b <= p3_b;
										
										bP2x <= p2_x;
										bP2y <= p2_y;
										bP2z <= p2_z;
										bP2r <= p2_r;
										bP2g <= p2_g;
										bP2b <= p2_b;
										
										corner <= `false;
									end else begin
										tP2x <= p2_x;
										tP2y <= p2_y;
										tP2z <= p2_z;
										tP2r <= p2_r;
										tP2g <= p2_g;
										tP2b <= p2_b;
										
										bP2x <= p3_x;
										bP2y <= p3_y;
										bP2z <= p3_z;
										bP2r <= p3_r;
										bP2g <= p3_g;
										bP2b <= p3_b;
										
										corner <= `true;
									end
								end else begin // 1 3 2								
									if((p3_x - p1_x) * y12 >= y13* (p2_x - p1_x))begin
										tP2x <= p2_x;
										tP2y <= p2_y;
										tP2z <= p2_z;
										tP2r <= p2_r;
										tP2g <= p2_g;
										tP2b <= p2_b;
										
										bP2x <= p3_x;
										bP2y <= p3_y;
										bP2z <= p3_z;
										bP2r <= p3_r;
										bP2g <= p3_g;
										bP2b <= p3_b;
										
										corner <= `false;
									end else begin
										tP2x <= p3_x;
										tP2y <= p3_y;
										tP2z <= p3_z;
										tP2r <= p3_r;
										tP2g <= p3_g;
										tP2b <= p3_b;
										
										bP2x <= p2_x;
										bP2y <= p2_y;
										bP2z <= p2_z;
										bP2r <= p2_r;
										bP2g <= p2_g;
										bP2b <= p2_b;
										
										corner <= `true;
									end								
								end								
							end else if((p2_x <= p3_x)&(p2_x <= p1_x))begin // 2 ? ?
								tP1x <= p2_x;
								tP1y <= p2_y;
								tP1z <= p2_z;
								tP1r <= p2_r;
								tP1g <= p2_g;
								tP1b <= p2_b;
								
								bP1x <= p2_x;
								bP1y <= p2_y;
								bP1z <= p2_z;
								bP1r <= p2_r;
								bP1g <= p2_g;
								bP1b <= p2_b;
								
								if(p3_x <= p1_x)begin // 2 3 1
									if((p3_x - p2_x) * y21 >= y23 * (p1_x - p2_x))begin
										tP2x <= p1_x;
										tP2y <= p1_y;
										tP2z <= p1_z;
										tP2r <= p1_r;
										tP2g <= p1_g;
										tP2b <= p1_b;
										
										bP2x <= p3_x;
										bP2y <= p3_y;
										bP2z <= p3_z;
										bP2r <= p3_r;
										bP2g <= p3_g;
										bP2b <= p3_b;
										
										corner <= `false;
									end else begin
										tP2x <= p3_x;
										tP2y <= p3_y;
										tP2z <= p3_z;
										tP2r <= p3_r;
										tP2g <= p3_g;
										tP2b <= p3_b;
										
										bP2x <= p1_x;
										bP2y <= p1_y;
										bP2z <= p1_z;
										bP2r <= p1_r;
										bP2g <= p1_g;
										bP2b <= p1_b;
										
										corner <= `true;
									end
								end else begin // 2 1 3
									if((p1_x - p2_x) * y23 >= y21 * (p3_x - p2_x))begin
										tP2x <= p3_x;
										tP2y <= p3_y;
										tP2z <= p3_z;
										tP2r <= p3_r;
										tP2g <= p3_g;
										tP2b <= p3_b;
										
										bP2x <= p1_x;
										bP2y <= p1_y;
										bP2z <= p1_z;
										bP2r <= p1_r;
										bP2g <= p1_g;
										bP2b <= p1_b;
										
										corner <= `false;
									end else begin
										tP2x <= p1_x;
										tP2y <= p1_y;
										tP2z <= p1_z;
										tP2r <= p1_r;
										tP2g <= p1_g;
										tP2b <= p1_b;
										
										bP2x <= p3_x;
										bP2y <= p3_y;
										bP2z <= p3_z;
										bP2r <= p3_r;
										bP2g <= p3_g;
										bP2b <= p3_b;
										
										corner <= `true;
									end
								end
							end else begin // 3 ? ?
								tP1x <= p3_x;
								tP1y <= p3_y;
								tP1z <= p3_z;
								tP1r <= p3_r;
								tP1g <= p3_g;
								tP1b <= p3_b;
								
								bP1x <= p3_x;
								bP1y <= p3_y;
								bP1z <= p3_z;
								bP1r <= p3_r;
								bP1g <= p3_g;
								bP1b <= p3_b;
								
								if(p1_x <= p2_x)begin // 3 1 2
									if((p1_x - p3_x) * y32/*(p2_y - p3_y)*/ >= y31/*(p1_y - p3_y)*/ * (p2_x - p3_x))begin
										tP2x <= p2_x;
										tP2y <= p2_y;
										tP2z <= p2_z;
										tP2r <= p2_r;
										tP2g <= p2_g;
										tP2b <= p2_b;
										
										bP2x <= p1_x;
										bP2y <= p1_y;
										bP2z <= p1_z;
										bP2r <= p1_r;
										bP2g <= p1_g;
										bP2b <= p1_b;
										
										corner <= `false;
									end else begin
										tP2x <= p1_x;
										tP2y <= p1_y;
										tP2z <= p1_z;
										tP2r <= p1_r;
										tP2g <= p1_g;
										tP2b <= p1_b;
										
										bP2x <= p2_x;
										bP2y <= p2_y;
										bP2z <= p2_z;
										bP2r <= p2_r;
										bP2g <= p2_g;
										bP2b <= p2_b;
										
										corner <= `true;
									end
								end else begin // 3 2 1
									if((p2_x - p3_x) * y31 >= y32 * (p1_x - p3_x))begin
										tP2x <= p1_x;
										tP2y <= p1_y;
										tP2z <= p1_z;
										tP2r <= p1_r;
										tP2g <= p1_g;
										tP2b <= p1_b;
										
										bP2x <= p2_x;
										bP2y <= p2_y;
										bP2z <= p2_z;
										bP2r <= p2_r;
										bP2g <= p2_g;
										bP2b <= p2_b;
										
										corner <= `false;
									end else begin
										tP2x <= p2_x;
										tP2y <= p2_y;
										tP2z <= p2_z;
										tP2r <= p2_r;
										tP2g <= p2_g;
										tP2b <= p2_b;
										
										bP2x <= p1_x;
										bP2y <= p1_y;
										bP2z <= p1_z;
										bP2r <= p1_r;
										bP2g <= p1_g;
										bP2b <= p1_b;
										
										corner <= `true;
									end
								end
							end						
						end
					end
					
					stRbothNewX:begin
						bN_reset <= `true;
						tN_reset <= `true;
						if(tNewX)begin
							if(bNewX)begin
								state <= stRecNewX;
								tUpdating <= `false;
								bUpdating <= `false;
							end else begin
								state <= stRbNewX;
								tUpdating <= `false;
								bUpdating <= `true;
							end
						end else begin
							if(bNewX)begin
								state <= stRtNewX;
								tUpdating <= `true;
								bUpdating <= `false;
							end else begin
								state <= stRbothNewX;
								tUpdating <= `true;
								bUpdating <= `true;
							end
						end
					end
					
					stRtNewX:begin
						if(tNewX)begin
							state <= stRecNewX;
							tUpdating <= `false;
							bUpdating <= `false;						
						end else begin
							state <= stRtNewX;
							tUpdating <= `true;
							bUpdating <= `false;
						end
					end
					
					stRbNewX:begin
						if(bNewX)begin
							state <= stRecNewX;
							tUpdating <= `false;
							bUpdating <= `false;
						end else begin
							state <= stRbNewX;
							tUpdating <= `false;
							bUpdating <= `true;
						end						
					end
					
					stRecNewX:begin
						state <= stDrawing;
						x <= bx;
						y <= by;
						z <= bz;
						r <= br;
						g <= bg;
						b <= bb;
						
						newPoint <= `true;
						
						ez <= 1'b0;
						er <= 1'b0;
						eg <= 1'b0;
						eb <= 1'b0;
					end
					
					stDrawing:begin						
						if(y < ty)begin
							y <= y + `pixel'b1;
							if(ez > 0)begin
								z <= z + sz;								
								ez <= ez - ((ty - by) << 1) + (dz << 1);
							end else begin
								z <= z;
								ez <= ez + (dz << 1);								
							end	
							if(er > 0)begin
								r <= r + sr;								
								er <= er - ((ty - by) << 1) + (dr << 1);
							end else begin
								r <= r;
								er <= er + (dr << 1);								
							end	
							if(eg > 0)begin
								g <= g + sg;								
								eg <= eg - ((ty - by) << 1) + (dg << 1);
							end else begin
								g <= g;
								eg <= eg + (dg << 1);								
							end
							if(eb > 0)begin
								b <= b + sb;								
								eb <= eb - ((ty - by) << 1) + (db << 1);
							end else begin
								b <= b;
								eb <= eb + (db << 1);								
							end
							tUpdating <= `false;
							bUpdating <= `false;
						end else begin
							newPoint <= `false;
							if(~corner)begin
								if((x == bP2x - 1)&(second == `false))begin
									bP1x <= bP2x;
									bP1y <= bP2y;
									bP1z <= bP2z;
									bP1r <= bP2r;
									bP1g <= bP2g;
									bP1b <= bP2b;
									
									bP2x <= tP2x;
									bP2y <= tP2y;
									bP2z <= tP2z;
									bP2r <= tP2r;
									bP2g <= tP2g;
									bP2b <= tP2b;
									
									bN_reset <= `false;
									
									state <= stRbothNewX;
									tUpdating <= `true;
									bUpdating <= `true;
									second <= `true;
								end else if(x < tP2x)begin
									state <= stRbothNewX;
									tUpdating <= `true;
									bUpdating <= `true;
								end else
									state <= stCompleted;
							end else begin
								if((x == tP2x - 1)&(second == `false))begin
									tP1x <= tP2x;
									tP1y <= tP2y;
									tP1z <= tP2z;
									tP1r <= tP2r;
									tP1g <= tP2g;
									tP1b <= tP2b;
									
									tP2x <= bP2x;
									tP2y <= bP2y;
									tP2z <= bP2z;
									tP2r <= bP2r;
									tP2g <= bP2g;
									tP2b <= bP2b;
									
									tN_reset <= `false;
									
									state <= stRbothNewX;
									tUpdating <= `true;
									bUpdating <= `true;
									second <= `true;
								end else if(x < bP2x)begin
									state <= stRbothNewX;
									tUpdating <= `true;
									bUpdating <= `true;
								end else
									state <= stCompleted;
							end
						end
					end
					
					stCompleted:begin
						tStart <= `false;
						bStart <= `false;
						
						tN_reset <= `false;
						bN_reset <= `false;
						
						if(~start)
							state <= stIdle;
					end
				endcase
			end else begin
				tUpdating <= `false;
				bUpdating <= `false;
			end
		end else
			state <= stIdle;
	end

endmodule
