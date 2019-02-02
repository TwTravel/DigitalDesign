module GRAPHICS_CARD(
  input CLK,
  input RESET,
  input [4:0] X,
  input [4:0] Y,
  input [11:0] COLOR, 
  input VGA_VS,
  output [17:0] SRAM_ADDR,
  output reg [15:0] SRAM_DATA,
  output reg WE_L,
  output reg READY
  );
  //used to initialize variables before clearing screen
  reg resetPressed;
  //keeps track of state
  reg [2:0]state;
  //color latch
  reg [11:0] regColor;
  //remembers x start location for when moving to next line
  reg [8:0] regX;
  //current point to write two
  reg [8:0]writeX,writeY;
  //keeps track of where in rectangle the state machine is at
  reg [3:0] xCount,yCount;
  //the address to clear during a reset
  reg [17:0] addr_reg;
  //when reseting use the addr_reg instead of the point
  assign SRAM_ADDR = (RESET)? addr_reg: {writeX,writeY};
  
  
  //state names
parameter init=3'd0,writing=3'd1;
  
  always @ (posedge CLK) begin
     resetPressed<=1'b0;
     READY<=1'b1;
     WE_L <= 1'b1;
     //if reseting initialize vars then clear screen
     if(RESET) begin
      //clear the screen
      addr_reg <= (resetPressed)?addr_reg+18'b1:18'b0;	// [17:0]
      WE_L <= 1'b0;								//write some memory
      SRAM_DATA <= 16'h0;						//write all zeros (black)		
      state<=init;
      resetPressed<=1'b1;
     end
	else if(VGA_VS) begin
		case(state)
		  init: begin
      //draw first point
			WE_L <= 1'b0;
      //pulse ready
			READY<=1'b0;
      //latch and initialize values
			regX[3:0]<=0;
			writeX[8:0]<=0;
			writeY[8:0]<=0;
			regX[8:3]<={X[4],X}+6'd18;
			writeX[7:3]<={X[4],X}+6'd18;
			writeY[7:3]<={Y[4],Y}+6'd14;
			xCount<=0;
			yCount<=0;
			regColor<=COLOR;
			state<=writing;
		  end
		  writing: begin
			WE_L <= 1'b0;
			//draw next point
      SRAM_DATA <= {regColor, 4'b0};
			//figure out where next point in rectangle is
			if(xCount==4'd15) begin
				if(yCount==4'd15)begin
					state<=init;
				end
				else begin
					xCount<=0;
					yCount<=yCount+4'b1;
					writeY<=writeY+5'b1;
					writeX<=regX;
				end
			end
			else begin
				xCount<=xCount+4'b1;
				writeX<=writeX+5'b1;
			end
		  end
		  default:begin
			state<=init;
          end
		endcase
     end
  end
  
endmodule 