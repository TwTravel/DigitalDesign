module control(iClk,
			   iReset,
			   oXw,oYw,oZw,
			   iXs,iYs,iZs,
			   oReady,
			   iDisplayAddress,
			   oDisplayVertexRead,
			   iCameraPosChanged
			 );

input iClk,iReset;
input iCameraPosChanged;
input [17:0] iXs,iYs,iZs;
input [4:0] iDisplayAddress;


output reg [17:0] oXw,oYw,oZw;
output reg oReady;
output [63:0] oDisplayVertexRead;
reg [4:0 ] WorldVertexAddress, ScreenVertexAddress,WorldFaceAddress,DisplayAddress;
reg SVRamWE,DisplayRamWE;
reg Done;
reg [1:0] Count;
wire [35:0] WorldVertex;
wire [11:0] WorldFace;
wire [55:0] ScreenVertexRead;
reg [55:0] ScreenVertexWrite;
wire [4:0] NoOfPoints,NoOfFaces;

assign NoOfPoints = 5'd8; // For Cube - Vertices = 8;
assign NoOfFaces = 5'd12; // For Cube - Faces = 12;


wire [63:0] DisplayVertexRead;
reg [63:0] DisplayVertexWrite;
reg  LastPos;

world_ram ram1(	.address(WorldVertexAddress),
				.clock(iClk),
				.q(WorldVertex)
				);

face_ram ram2(  .address(WorldFaceAddress),
				.clock(iClk),
				.q(WorldFace)
				);
				
screen_ram ram3( .address(ScreenVertexAddress),
				 .clock(iClk),
				 .data(ScreenVertexWrite),
				 .wren(SVRamWE),
				 .q(ScreenVertexRead)
				);

display_ram ram4( .address(DisplayAddress),
				  .clock(iClk),
				  .q(oDisplayVertexRead),
				  .wren(DisplayRamWE),
				  .data(DisplayVertexWrite)
				);

	
reg [1:0] state;
parameter [1:0] READ=2'b00,WRITE=2'b01,UPDATE=2'b10,IDLE=2'b11;

reg [2:0] state2;
parameter [2:0] READ_PT1_FROM_FACE=3'd0, WRITE_PT1_TO_SCREEN=3'd1, READ_PT2_FROM_FACE=3'd2, 
				WRITE_PT2_TO_SCREEN=3'd3, READ_PT3_FROM_FACE=3'd4, WRITE_PT3_TO_SCREEN=3'd5, IDLE2=3'd6;
always @( posedge iClk) begin
	DisplayAddress <= oReady ? iDisplayAddress : DisplayAddress;
	//oDisplayVertexRead <= oReady ? DisplayVertexRead : 64'd0;
	if(iReset) begin
		WorldVertexAddress <= 5'd0;
		WorldFaceAddress <= 5'd0;
		ScreenVertexAddress <= 5'b0;
		DisplayAddress <= 5'd0;  
		SVRamWE <= 1'b1;
		DisplayRamWE <= 1'b0;
		Count <= 2'd0;
		Done <= 1'b0;
		//oReady <= 1'b1;
		LastPos <= 1'b0;
		state <= READ;
	end
	else if (iCameraPosChanged/* & !LastPos*/) begin
		//LastPos <= 1'b1;
		 if (Done) begin
				SVRamWE <= 1'b0;
			case (state2)
				READ_PT1_FROM_FACE: begin
					ScreenVertexAddress<= WorldFace[11:8]- 1;	
					state2<= WRITE_PT1_TO_SCREEN;
				end
				WRITE_PT1_TO_SCREEN: begin
					DisplayVertexWrite[63:40] <={4'b0, ScreenVertexRead[53:44], ScreenVertexRead[35:26]};
					state2<= READ_PT2_FROM_FACE;
				end
				READ_PT2_FROM_FACE: begin
					ScreenVertexAddress<= WorldFace[7:4] -1;
					state2<= WRITE_PT2_TO_SCREEN;
				end
				WRITE_PT2_TO_SCREEN: begin
					DisplayVertexWrite[39:20] <= {ScreenVertexRead[53:44],ScreenVertexRead[35:26]};
					state2<= READ_PT3_FROM_FACE;
						end
				READ_PT3_FROM_FACE: begin
					ScreenVertexAddress<= WorldFace[3:0]-1;
					state2<= WRITE_PT3_TO_SCREEN;
				end
				WRITE_PT3_TO_SCREEN: begin		
					if(WorldFaceAddress > (NoOfFaces -2)) begin
						WorldVertexAddress <= 5'd0;
						WorldFaceAddress <= 5'd0;
						ScreenVertexAddress <= 5'd0;
						DisplayAddress <= 5'd0;  
						SVRamWE <= 1'b1;
						DisplayRamWE <= 1'b0;
						Count <= 2'd0;
						Done <= 1'b1;
						state2<= IDLE2;
					end else 
					begin
						DisplayVertexWrite[19:0] <= {ScreenVertexRead[53:44],ScreenVertexRead[35:26]};
						WorldFaceAddress <= WorldFaceAddress +1;
						DisplayAddress <= DisplayAddress +1;	
						state2 <=READ_PT1_FROM_FACE;	
					end
				end
				IDLE2 : begin
					oReady <= 1'b1;
					state2<= IDLE2;
				end
				
				
				endcase

		end
		else  begin
		/************************************************/
		case (state) 
		READ:begin
			SVRamWE <= 1'b1;
			oReady <= 1'b0;
			if(WorldVertexAddress >(NoOfPoints-1)) begin
				state<= IDLE;
				DisplayRamWE <= 1'b1;
				Done<= 1'b1;
				Count <= 2'd0;
				WorldFaceAddress <= 5'd0;
				state2<= READ_PT1_FROM_FACE;
			end 
			else begin
				WorldVertexAddress <= WorldVertexAddress + 1'b1;
				oXw <= WorldVertex[35:24];
				oYw <= WorldVertex[23:12];
				oZw <= WorldVertex[11:0];
				Done<= 1'b0;
				state <= WRITE;
			end
			end
		WRITE:begin
			ScreenVertexWrite[55:0] <= {2'b0,iXs,iYs,iZs};
			state <= UPDATE;
			end
		UPDATE:begin
			ScreenVertexAddress <= ScreenVertexAddress +1;
			state <= READ;
			end
		IDLE: begin
			state<= IDLE;
			end
		endcase
		/************************************************/
		end		//if (CamerPosChanged)
	
		end else if ( !iCameraPosChanged & LastPos) begin
			LastPos <= 1'b0;
		end
end	//always
endmodule

 