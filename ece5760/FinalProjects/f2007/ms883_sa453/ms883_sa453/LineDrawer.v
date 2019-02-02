module LineDrawer(iClk,
				  iDrawEnable,
				  iX1,
				  iY1,
				  iX2,
				  iY2,
				  iColor,
				  oReady,
				  iVGA_HS,
				  iVGA_VS,
				  oAddrReg,
				  oWe,
				  oDataReg,
				  oCoord_X,
				  oCoord_Y,
				  iReset,
				  //LEDG
				);
input iClk;
input iDrawEnable;
input [9:0] iX1,iY1,iX2,iY2;
input [15:0] iColor;
output oReady;
input iVGA_VS,iVGA_HS;
input iReset;

//output reg [8:0] LEDG;
output [17:0] oAddrReg; //memory address register for SRAM
output [15:0] oDataReg; //memory data register  for SRAM
output oWe ;		//write enable for SRAM

reg [17:0] oAddrReg; //memory address register for SRAM
reg [15:0] oDataReg; //memory data register  for SRAM
reg oWe ;		//write enable for SRAM
reg oReady;

input [10:0]  oCoord_X, oCoord_Y;	//display coods


reg lock;
reg [2:0] state;
reg [9:0] x1,y1,x2,y2,temp,e,dx,dy,x,y;
reg dec_y;
reg LastEnable;
parameter [2:0] IDLE=3'd0,INIT=3'd1,DRAW_INIT=3'd2,test1=3'd3,draw_line_m_lt_1=3'd4,draw_line_m_gt_1=3'd5;

always @ (posedge iClk)
begin
	if (iReset) begin
		//clear screen
		oAddrReg <= {oCoord_X[8:0],oCoord_Y[8:0]} ;	// [17:0]
		oWe <= 1'b0;								//write some memory
		oDataReg <= 16'h0000;
		state <= IDLE;
		oReady <= 1'b1;
		LastEnable <= 1'b0;
		lock <= 1'b1;
		x <= 10'd0;
		y <= 10'd0;
		e <= 10'd0;
	end
	else if (~iVGA_HS | ~iVGA_VS) begin
		
		case (state)
			IDLE: begin
				if (iDrawEnable & !LastEnable) begin
					LastEnable <= 1'b1;
					oReady <= 1'b0;
					state <= INIT;
					end				
				else if (!iDrawEnable & LastEnable)	begin
					LastEnable <= 1'b0;
					oReady <= 1'b1;
					state <= IDLE;				
				end
				else
				begin
					oReady <= 1'b1;	
					//LEDG <=	8'hAA;	
					state <= IDLE;	
				end
			end
			
			INIT: begin
				oReady <= 1'b0;			 
				x1 <= iX1;
				y1 <= iY1;
				x2 <= iX2;
				y2 <= iY2;
				state <= DRAW_INIT;
				//LEDG <=	8'h00;
			end
		
			DRAW_INIT: begin
				//LEDG <=	8'hFF;
				lock <= 1'b1;
				if( x1 > x2)begin
					temp = x1;
					x1 = x2;
					x2 = temp;
					temp = y1;
					y1 = y2;
					y2 = temp;
					end
				else begin
					x1 = x1;
					x2 = x2;
				end
				if ( y1 > y2) begin
					dec_y =1'b1;
				end
				else begin
					dec_y = 1'b0;
				end
				dx <= x2 - x1;
				if(dec_y) begin
					dy <= y1 - y2;
				end
				else begin
					dy <= y2-y1;
				end
				x <= x1;
				y <= y1;
				state <= test1;
			end
			
			test1: begin
					//LEDG <=	8'hFF;
					//oReady <= 1'b0;			
					lock <= 1'b1;
					oWe <= 1'b1;
					if ( dy > dx ) begin
						e <= dx - dy;
						state <= draw_line_m_gt_1;
					end
					else begin
						e <= dy - dx;
						state <= draw_line_m_lt_1;
					end 
				end
					
			draw_line_m_lt_1:
					begin
					//LEDG <=	8'hFF;
					//oReady <= 1'b0;						
					if (lock) begin
						oAddrReg <= {x[8:0],y[8:0]};
						oWe <= 1'b0;
						oDataReg <= iColor;
						if ((e[9] == 0) || (e == 0)) begin
							if(dec_y)begin
								y <= y - 1;
							end
							else begin
								y <= y + 1;
							end
							x <= x + 1;
							e <= e - dx + dy;
						end
						else begin
							x <= x + 1;
							e <= e + dy;					
						end

						if (x < x2) begin
							state <= draw_line_m_lt_1;
						end
						else begin
							state <= IDLE;
						end
					 end
					lock <= 1'b1;
						
					end
		
				draw_line_m_gt_1:
					begin
						//LEDG <=	8'hFF;
						//oReady <= 1'b0;						
						if (lock) begin
							oAddrReg <= {x[8:0],y[8:0]};
							oWe <= 1'b0;
							oDataReg <= iColor;
							if ((e[9] == 0)||(e ==0)) begin
								x <= x + 1;
								if(dec_y)begin
								y <= y - 1;		
								end
								else begin
								y <= y + 1;
								end
								e <= e + dx - dy;
							end
							else begin
								if(dec_y)begin
								y <= y - 1;
								end
								else begin
								y <= y + 1;
								end
								e <= e + dx;
							end
							
							if(dec_y) begin
								if (y > y2) begin
								state <= draw_line_m_gt_1;
								end
								else begin
								state <= IDLE;
								end
							end
							else begin
							if (y < y2) begin
								state <= draw_line_m_gt_1;
								end
								else begin
								state <= IDLE;
								end
							end
							
						end
						lock <= 1'b1;
					end

		endcase
	end
	else
	begin
		lock <= 1'b0; //clear lock if display starts because this destroys mem oAddrReg
		
		oAddrReg <= {oCoord_X[8:0],oCoord_Y[8:0]} ;
		
		oWe <= 1'b1;
	end
end

endmodule