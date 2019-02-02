module TriangleDrawer( 	
				iClk,
			   	iReset, 
			   	oDrawEnable,
				oX1,
				oY1,
				oX2,
				oY2,
				iReady,
				oAddress,
				iRamData,
				iControlReady
				);

input iClk,iReset,iReady; 
input iControlReady;

output  reg oDrawEnable;
output reg [9:0] oX1,oY1,oX2,oY2;
parameter [2:0]UPDATE = 3'd1,DRAW=3'd2,ENABLE_HIGH=3'd3,ENABLE_LOW=3'd4,WAIT_FOR_HIGH_READY=3'd5,WAIT_FOR_LOW_READY=3'd6;
reg [2:0] state;

reg [9:0] P1X,P1Y,P2X,P2Y,P3X,P3Y;
reg [1:0] Count;
//wire [59:0] RamData={10'd100,10'd200,10'd130,10'd70,10'd50,10'd60};

//ram ScreenRam(
//	.address(address),
//	.clock(iClk),
//	.q(RamData)
//	);

//


output reg [4:0]  oAddress;
input  [63:0] iRamData;
reg [7:0] Delay_Count1,Delay_Count2;
always @ (posedge iClk) begin
	
	if( iReset) begin
		state <= UPDATE;
		oAddress <= 0;
		Delay_Count1<= 8'd0;
		Delay_Count2<= 8'd0;
	end
	else 
	case (state)

	UPDATE: begin
			if( iControlReady ) begin
				if ( oAddress == 5'd11) begin
					oAddress <= 0;
				end
				else begin
					oAddress <= oAddress +1'b1;
				end
				P1X <= iRamData[59:50];
				P1Y <= iRamData[49:40];
				P2X <= iRamData[39:30];
				P2Y <= iRamData[29:20];
				P3X <= iRamData[19:10];
				P3Y	<= iRamData[9:0];
				Count <= 2'd1;
				state <= DRAW;
			end
			else begin
				state <= UPDATE;
			end
		end
	DRAW: begin
			if(Count == 2'd1) begin
				oX1<=P1X;
				oY1<=P1Y;
				oX2<=P2X;
				oY2<=P2Y;
				state <= ENABLE_HIGH;
			end
			else 
			if( Count == 2'd2) begin
				oX1<=P1X;
				oY1<=P1Y;
				oX2<=P3X;
				oY2<=P3Y;
				state <= ENABLE_HIGH;
			end
			else
			if( Count == 2'd3) begin
				oX1<=P3X;
				oY1<=P3Y;
				oX2<=P2X;
				oY2<=P2Y;
				state <= ENABLE_HIGH;
			end
			else
				state <= UPDATE;
	end
	
	ENABLE_HIGH : begin
		oDrawEnable <= 1'b1;
		state <= WAIT_FOR_LOW_READY;
	end
	
	ENABLE_LOW : begin
		oDrawEnable <= 1'b0;
		Count <= Count + 2'd1;
		state <= WAIT_FOR_HIGH_READY;
	end
	
	WAIT_FOR_HIGH_READY: begin
		if( iReady )begin
			state <= DRAW;
		end
		else
		begin
			state <= WAIT_FOR_HIGH_READY;
		end
	end
	
//	WAIT_FOR_HIGH_READY : begin
//			if(Delay_Count1 < 8'd2)begin
//				Delay_Count1 <= 8'd0;
//				state <= DRAW;
//			end 
//			else begin
//				Delay_Count1 <= Delay_Count1+1;
//				state <= WAIT_FOR_HIGH_READY; 
//			end
//		
//	end		
	WAIT_FOR_LOW_READY:
		if (!iReady)begin
			state <= ENABLE_LOW;
		end
		else
		begin
				state <= WAIT_FOR_LOW_READY;
		end
//	WAIT_FOR_LOW_READY : begin
//			if(Delay_Count2 < 8'd50)begin
//				Delay_Count2<= 8'd0;
//				state <= ENABLE_LOW;
//			end 
//			else begin
//				Delay_Count2 <= Delay_Count2+1;
//				state <= WAIT_FOR_LOW_READY; 
//			end
//	end
	endcase
end	
endmodule
				
						