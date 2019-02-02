// Implements a  Nios II system with SDRAM and DDS control for the DE2 board.
// Inputs: SW7-0 are parallel port inputs to the Nios II system
// CLOCK_50 is the system clock
// KEY0 is the active-low system reset
// Outputs: LEDG7-0 are parallel port outputs from the Nios II system
module TimerSDRAM(SW, KEY, CLOCK_50,CLOCK_27, LEDG, 
	HEX3, HEX2, HEX1, HEX0, HEX5, HEX4, HEX6,HEX7,
	GPIO_0,
	DRAM_CLK, DRAM_CKE,
	DRAM_ADDR, DRAM_BA_1, DRAM_BA_0, DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N,
	DRAM_WE_N, DRAM_DQ, DRAM_UDQM, DRAM_LDQM,
	VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_R, VGA_G, VGA_B, 
	//addition
	LEDR,
	SRAM_DQ,						//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Address bus 18 Bits
		SRAM_UB_N,						//	SRAM High-byte Data Mask 
		SRAM_LB_N,						//	SRAM Low-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		   LCD_DATA,                //    LCD Data bus 8 bits
               LCD_ON,                    //    LCD Power ON/OFF
                LCD_BLON,                //    LCD Back Light ON/OFF
              LCD_RW,                    //    LCD Read/Write Select, 0 = Write, 1 = Read
            LCD_EN,                    //    LCD Enable
           LCD_RS                    //    LCD Command/Data Select, 0 = Command, 1 = Data
	);
	inout    [7:0]    LCD_DATA;
	output            LCD_ON;
	output            LCD_RW;
	output            LCD_RS;
	output            LCD_BLON;
	output            LCD_EN;
	//my addition
	inout	[15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
output	[17:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
output			SRAM_UB_N;				//	SRAM High-byte Data Mask
output			SRAM_LB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_WE_N;				//	SRAM Write Enable
output			SRAM_CE_N;				//	SRAM Chip Enable
output			SRAM_OE_N;				//	SRAM Output Enable
	



wire		VGA_CTRL_CLK;
wire		AUD_CTRL_CLK;
wire [9:0]	mVGA_R;
wire [9:0]	mVGA_G;
wire [9:0]	mVGA_B;
wire [19:0]	mVGA_ADDR;			//video memory address
wire [9:0]  Coord_X, Coord_Y;	//display coods
wire		DLY_RST;


assign    LCD_ON        =    1'b1;
assign    LCD_BLON    =    1'b1;

	input [15:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	input CLOCK_27;
	output [7:0] LEDG;
	output [17:0] LEDR;
	output [6:0] HEX3, HEX2, HEX1, HEX0, HEX5, HEX4,HEX6,HEX7;
	inout [35:0] GPIO_0;
	//SDRAM
	output [11:0] DRAM_ADDR;
	output DRAM_BA_1, DRAM_BA_0, DRAM_CAS_N, DRAM_RAS_N, DRAM_CLK;
	output DRAM_CKE, DRAM_CS_N, DRAM_WE_N, DRAM_UDQM, DRAM_LDQM;
	inout [15:0] DRAM_DQ;
	//VGA
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	reg [7:0] LCD_DATA_TEST;
	reg [15:0] pid_i;
	reg [19:0] pid_o;
	reg        my_clock = 1'b0;
	reg [13:0]  count;
	wire CPU_CLK ;
	assign LCD_DATA=LCD_DATA_TEST;
	NiosTimer nios2(CPU_CLK, KEY[0], LEDG[7:0], SW[7:0], DDS_incr,
			LCD_EN,
			LCD_RS,
			LCD_RW,
			LCD_DATA_TEST,
				pid_i, pid_o, HON, VAL,
				DRAM_ADDR,
				{DRAM_BA_1, DRAM_BA_0},
				DRAM_CAS_N,
				DRAM_CKE,
				DRAM_CS_N,
				DRAM_DQ,
				{DRAM_UDQM, DRAM_LDQM},
				DRAM_RAS_N,
				DRAM_WE_N);
	
	sdram_pll neg_3ns (CLOCK_50, DRAM_CLK, CPU_CLK);

	//PID output for heater 1
	HexDigit Digit2(HEX2, pid_o[9:8]);
	HexDigit Digit1(HEX1, pid_o[7:4]);
	HexDigit Digit0(HEX0, pid_o[3:0]);
	//PID output for heater 2
	HexDigit Digit5(HEX5, pid_o[19:18]);
	HexDigit Digit4(HEX4, pid_o[17:14]);
	HexDigit Digit3(HEX3, pid_o[13:10]);	
	
	wire reset;
reg [17:0] addr_reg; //memory address register for SRAM
reg [15:0] data_reg; //memory data register  for SRAM
reg we ;		//write enable for SRAM

assign SRAM_ADDR = addr_reg;
assign SRAM_DQ = (we)? 16'hzzzz : data_reg ;
assign SRAM_UB_N = 0;					// hi byte select enabled
assign SRAM_LB_N = 0;					// lo byte select enabled
assign SRAM_CE_N = 0;					// chip is enabled
assign SRAM_WE_N = we;					// write when ZERO
assign SRAM_OE_N = 0;					//output enable is overidden by WE
assign LEDR[15:0] = pid_i;	

assign  mVGA_R = {{SRAM_DQ[15:8]},{2{SRAM_DQ[8]}}} ;//8 bits for R
assign  mVGA_G = {{SRAM_DQ[7:1]},{3{SRAM_DQ[1]}}};  //7 bits for G
assign  mVGA_B = {10{SRAM_DQ[0]}} ;						 //1 bit  for B

reg [1:0] HON;
reg [7:0] VAL;
//VGA controls

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
							reg [9:0] ctr1;
							initial
							begin
							ctr1<=10'b0;
							end
							always @(posedge my_clock)
							begin
								ctr1<=ctr1+1;
							end
							always @(posedge CLOCK_50)
							begin
							pid_i[15:2]<=GPIO_0[23:10];//The inputs from the ADC assigned to the NIOS input
							pid_i[1:0]<=GPIO_0[7:6];
							count <= count + 1;
							if(count>8400)
							begin
							my_clock <= ~ (my_clock);  //Clock to control the PWM 
							count <= 10'b0;
							end
							end
							wire [9:0] po1,po2;
							assign po1=pid_o[9:0];
							assign po2=pid_o[19:10];
							assign GPIO_0[0]=(ctr1<po1)?1'b1:1'b0;//PWM outputs
							assign GPIO_0[1]=(ctr1<po2)?1'b1:1'b0;
							
						//VGA
					
				reg [9:0] x_walker;
				reg [8:0] y_walker;
				reg [3:0] state;
				parameter init=4'd0, test1=4'd1, test2=4'd2, test3=4'd3, test4=4'd4, test5=4'd5, test6=4'd6, 
						draw_walker=4'd7, update_walker=4'd8, new_walker=4'd9 ;
				initial 
				begin
					x_walker<=10'd0;
					y_walker<=9'd0;
					state<=draw_walker;
				end	
always @ (posedge VGA_CTRL_CLK)
begin	
if ((~VGA_VS | ~VGA_HS))  //sync is active low; KEY3 is pause
	begin
		case(state)			
			draw_walker: //draw the walker
			begin
				we <= 1'b0; // memory write 
				addr_reg <= {x_walker,y_walker};
				
				//The 'H' on the left
				if(x_walker>=10'd20 && x_walker<=10'd30 && y_walker>=9'd30 && y_walker<=9'd70)
					data_reg<=16'hffff;
				else if(x_walker>=10'd30 && x_walker<=10'd50 && y_walker>=9'd45 && y_walker<=9'd55)
					data_reg<=16'hffff;
				else if(x_walker>=10'd50 && x_walker<=10'd60 && y_walker>=9'd30 && y_walker<=9'd70)
					data_reg<=16'hffff;
				//The '1' on the left
				else if(x_walker>=10'd80 && x_walker<=10'd90 && y_walker>=9'd30 && y_walker<=9'd70)
					data_reg<=16'hffff;
				//The 'H' on the right
				else if(x_walker>=10'd210 && x_walker<=10'd220 && y_walker>=9'd30 && y_walker<=9'd70)
					data_reg<=16'hffff;
				else if(x_walker>=10'd220 && x_walker<=10'd240 && y_walker>=9'd45 && y_walker<=9'd55)
					data_reg<=16'hffff;
				else if(x_walker>=10'd240 && x_walker<=10'd250 && y_walker>=9'd30 && y_walker<=9'd70)
					data_reg<=16'hffff;
				//The '2' on the right
				else if(x_walker>=10'd270 && x_walker<=10'd300 && y_walker>=9'd30 && y_walker<=9'd35)
					data_reg<=16'hffff;
				else if(x_walker>=10'd270 && x_walker<=10'd300 && y_walker>=9'd47 && y_walker<=9'd53)
					data_reg<=16'hffff;
				else if(x_walker>=10'd270 && x_walker<=10'd300 && y_walker>=9'd65 && y_walker<=9'd70)
					data_reg<=16'hffff;
				else if(x_walker>=10'd295 && x_walker<=10'd300 && y_walker>=9'd35 && y_walker<=9'd47)
					data_reg<=16'hffff;
				else if(x_walker>=10'd270 && x_walker<=10'd275 && y_walker>=9'd53 && y_walker<=9'd65)
					data_reg<=16'hffff;
				//The square on the left
				else if(x_walker>=10'd35 && x_walker<=10'd75 && y_walker>=9'd90 && y_walker<=9'd130)
				begin
					if(HON[0])
						data_reg<=16'h00fe; //Green if heater is on
					else
						data_reg<=16'hff00; //Red if heater is off
				end
				//The square on the right
				else if(x_walker>=10'd235 && x_walker<=10'd275 && y_walker>=9'd90 && y_walker<=9'd130)
				begin
					if(HON[1])
						data_reg<=16'h00fe; //Green if heater is on
					else
						data_reg<=16'hff00; //Red if heater is off
				end
				//The progress bar
				else if(x_walker>=10'd120 && x_walker<=10'd200 && y_walker>=9'd200 && y_walker<=9'd220)
				begin
					if((x_walker-10'd120)<=VAL)//Till the progress point, give a color gradient
						data_reg<=16'hffff+(x_walker-10'd120);
					else
						data_reg<=16'h0000;  //For beyond the progress point
				end
				//Everywhere else
				else
					data_reg<=16'h0;
				state <= update_walker ;	
			end
			
			update_walker: //update the walker
			begin
				we <= 1'b1; //no mem write
				//inc/dec x while staying on screen
				if (x_walker<10'd319 )
					x_walker <= x_walker+1;
				//inc/dec y while staying on screen
				else if (y_walker<9'd239)
				begin
					x_walker <=10'd0;
					y_walker<=y_walker+9'd1;
				end
				//reset the screen
				else
				begin
					x_walker <=10'd0;
					y_walker<=9'd0;
				end
				state <= draw_walker ;	
			end
		endcase
	end
	//show display when not blanking, 
	//which implies we=1 (not enabled); and use VGA module address
	else
	begin
		addr_reg <= {Coord_X[9:1],Coord_Y[9:1]} ;
		we <= 1'b1;
	end
end
//END VGA	
							
							
endmodule

//////////////////////////////////////////////
// Decode one hex digit for LED 7-seg display
module HexDigit(segs, num);
	input [3:0] num	;		//the hex digit to be displayed
	output [6:0] segs ;		//actual LED segments
	reg [6:0] segs ;
	always @ (num)
	begin
		case (num)
				4'h0: segs = 7'b1000000;
				4'h1: segs = 7'b1111001;
				4'h2: segs = 7'b0100100;
				4'h3: segs = 7'b0110000;
				4'h4: segs = 7'b0011001;
				4'h5: segs = 7'b0010010;
				4'h6: segs = 7'b0000010;
				4'h7: segs = 7'b1111000;
				4'h8: segs = 7'b0000000;
				4'h9: segs = 7'b0010000;
				4'ha: segs = 7'b0001000;
				4'hb: segs = 7'b0000011;
				4'hc: segs = 7'b1000110;
				4'hd: segs = 7'b0100001;
				4'he: segs = 7'b0000110;
				4'hf: segs = 7'b0001110;
				default segs = 7'b1111111;
		endcase
	end
endmodule0: segs = 7'b1000000;
				4'h1: segs = 7'b1111001;
				4'h2: segs = 7'b0100100;
				4'h3: segs = 7'b0110000;
				4'h4: segs = 7'b0011001;
				4'h5: segs = 7'b0010010;
				4'h6: segs = 7'b0000010;
				4'h7: segs = 7'b1111000;
				4'h8: segs = 7'b0000000;
				4'h9: segs = 7'b0010000;
				4'ha: segs = 7'b0001000;
				4'hb: segs = 7'b0000011;
				4'hc: segs = 7'b1000110;
				4'hd: segs = 7'b0100001;
				4'he: segs = 7'b0000110;
				4'hf: segs = 7'b0001110;
				default segs = 7'b1111111;