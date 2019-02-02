//Sobel edge algorithm
//version 1.0
//By Gladys Chan & Andrew Chin

module sobel
(
	iReset,
	iClock,
	oLED,
	//the images from the SDRAM
	oSDRAM_READ_CLOCK,  //data clock on the sdram (each cycle gets a new word)
	oSDRAM_READ_LOGIC,  //set high when data is wanted
	iSDRAM_IMAGE1,		   //data from image 1
	iSDRAM_IMAGE2,		   //data from image 2
	//the output to the VGA
	oVGASRAM_ADDR,	//address of VGA output SRAM (320x240)
	oVGASRAM_DATA,	//data for		 "			"
	iVGA_OK_TO_WRITE,		//signal indicating it is OK to write to the SRAM	
	iVGA_CTRL_CLK,
	oStartEdgeDetect,
	isw
);
	input   		iReset;
	input 			iClock;
	output [17:0]	oLED;

	//the images from the SDRAM
	output 			oSDRAM_READ_CLOCK;  	//data clock on the sdram (each cycle gets a new word)
	output 			oSDRAM_READ_LOGIC; 		//set high when data is wanted
	input [15:0]	iSDRAM_IMAGE1;		   	//data from image 1
	input [15:0]	iSDRAM_IMAGE2;		   	//data from image 2

	//the output to the VGA
	output [17:0]	oVGASRAM_ADDR;		//address of VGA output SRAM (320x240)
	output [15:0]	oVGASRAM_DATA;		//data for		 "			"
	input 			iVGA_OK_TO_WRITE;		//signal indicating it is OK to write to the SRAM	
	input			iVGA_CTRL_CLK;
	output			oStartEdgeDetect;
	input [17:0]    isw;

//---------------------------------------------------------------------------------------------------------------------------
	
	
	reg [9:0] ImXcoord;	//the coordinates beeing read out of the sdram based images
	reg [9:0] ImYcoord;
		
	reg [17:0] rLED;

	reg [17:0] rVGASRAM_ADDR;
	reg [15:0] rVGASRAM_DATA;
	
	//indicator for beginning of each row
	reg [3:0]	state;	

	//read row counter
	reg [9:0]  SX;
	reg [9:0]  SY;
	reg [9:0]  SZ;

	//read from SDRAM when VGA is sync and load operation is high												
	assign oSDRAM_READ_LOGIC = iVGA_OK_TO_WRITE & load;
	//assignment SDRAM read clock 
	assign oSDRAM_READ_CLOCK = iVGA_CTRL_CLK;
	
	assign oVGASRAM_ADDR = rVGASRAM_ADDR;
	assign oVGASRAM_DATA = rVGASRAM_DATA;		
	assign  oLED = rLED;
	assign oStartEdgeDetect = run_edge;


//memory control
reg we0, we1, we2; //write enable--active high
wire [9:0] sr_data0, sr_data1, sr_data2; 
reg [9:0]  write_data0, write_data1, write_data2;
reg [9:0] addr_reg0, addr_reg1, addr_reg2;

reg [3:0] current_state;   //state variable for edge detection
reg [3:0] ramstate;		//state variable for SDRAM read
reg run_edge;			//signal for edge detection
reg load;				//signal for SDRAM read
reg [9:0] pixelx;		//edge pixel
reg [9:0] pixely;

reg [1:0] mem_add;		//to store location of previous M4K block
reg [9:0] a1,a2,a3,b1,b2,b3,c1,c2,c3;	//convolution table 


//edge gradient variables
reg unsigned[13:0] EdgeMax;
reg [3:0] DirMax;

reg [13:0]deriv_ne_sw, deriv_n_s, deriv_e_w, deriv_nw_se;
reg [13:0] edge1, edge2;
reg [13:0] edgeprep, prep1,prep2;
reg [13:0] sec1,sec2,sec3,sec4,sec5,sec6,sec7,sec8;
reg [17:0] comparevalue, threshold_sw;

reg [9:0] q;  //original image data
reg screen;	  //display screen control


//state names
parameter s0=4'd0, s1=4'd1, s2=4'd2, s3=4'd3, s4=4'd4, s5=4'd5, s6=4'd6, s7=4'd7, s8=4'd8,s9=4'd9,s10=4'd10,s11=4'd11,s12=4'd12;


	always @ (posedge iVGA_CTRL_CLK)
	begin
		//the ram is a FIFO buffer, so we will need to scan and selectively add the correct pixels.
		if (iReset)			
		begin
			ImXcoord=10'd0;
			ImYcoord=10'd0;		
			state<=s0;
			SX<=10'd0;
			SY<=10'd0;
			SZ<=10'd0;
			load <= 1'b1;
			run_edge <= 1'b0;
			ramstate <= s0;
			pixelx = 10'd0;
			pixely = 10'd1;
			current_state <= s0;
			screen <= 1'b0;			
			rLED[17:0]<=18'd0;
		end
		
		else if (iVGA_OK_TO_WRITE)  //modify display during sync
		begin
		if (load)
		begin					
				case(ramstate)
				s0:
				begin
					rLED[17:16]<=2'b11;		//for state debugging
					//if grayscale image data is less than threshold, write to black
					if (iSDRAM_IMAGE1[9:0] < isw[16:7])
						write_data0 <= 10'd0;
					else
						write_data0 <= 10'b1111111111;			
					addr_reg0 <= ImXcoord;	//address for M4K block #0
					we0 <= 1'b1;	//active high
					if (SX <10'd640)	//loop until whole row has been read
						ramstate <= s0;
					else
					begin
						if (state == s0)	//if beginning of screen, read three rows
							ramstate <= s1;
						else
						begin
							current_state <= s1;
							ramstate <= s3;
						end
						ImYcoord = ImYcoord + 10'd1;
					end
					SX = SX +10'd1;
				end		
				s1:			
				begin				
					rLED[15:14]<=2'b11;
				if (iSDRAM_IMAGE1[9:0] < isw[16:7])
					write_data1 <= 10'd0;
				else
					write_data1 <= 10'b1111111111;
				addr_reg1 <= ImXcoord;
				we1 <= 1'b1;
					if (SY <10'd640)
						ramstate <= s1;
					else
					begin
						if (state == s0)
							ramstate <= s2;
						else
						begin
							ramstate <= s3;
							current_state <= s2;	
						end	
						ImYcoord = ImYcoord + 10'd1;
					end
				SY = SY +10'd1; 
				end
				s2:
				begin
					rLED[13:12]<=2'b11;
				if (iSDRAM_IMAGE1[9:0] < isw[16:7])
					write_data2 <= 10'd0;
				else
					write_data2 <= 10'b1111111111;	
					addr_reg2 <= ImXcoord;
					we2 <= 1'b1;
					if (SZ <10'd640 )
					begin  
						ramstate <= s2;
					end
					else
					begin
						current_state <= s0;
						ramstate <= s3;
					ImYcoord = ImYcoord + 10'd1;						
					end

					SZ = SZ +10'd1; 
				end
				s3:
				begin
					state <= s1;	
					we2 <= 1'b0;
					we0 <= 1'b0;
					we1 <= 1'b0;
					rLED[17:0]<=18'd0;
					SX <= 10'd0;
					SY <= 10'd0;
					SZ <= 10'd0;
					addr_reg0 <= 10'd0;
					addr_reg1 <= 10'd0;
					addr_reg2 <= 10'd0;
					pixelx = 10'd0;
					load <= 1'b0;
					run_edge <= 1'b1;
				end
			endcase		
		
			if (ImXcoord == 10'd639)
			begin
				ImXcoord = 10'd0;
			end
			else
				ImXcoord = ImXcoord+10'd1;								

		end
		
		else if (run_edge)
		begin			
			case (current_state)
			s0:
			begin
			//populate convolution table
			rLED[11:10]<=2'b11;
			a1 <= a2;	//shift column to replace old data
			b1 <= b2;
			c1 <= c2;
			a2 <= a3;
			b2 <= b3;
			c2 <= c3;
			a3 <= sr_data0;		//read from M4K
			b3 <= sr_data1;
			c3 <= sr_data2;
			q <= sr_data1;		//store original image for display

			mem_add <= 2'd0;
			
			if (~isw[17])	//display original image is switch 17 is low
			begin		
				rVGASRAM_ADDR <= { (pixelx[9:1]-1),  pixely[9:1]};
				rVGASRAM_DATA <={q[9:0], 6'b000000};	
			end
			if (pixelx > 10'd1)		//start edge if 3 columns have been read
			begin
				current_state <= s5;
			end
			else
				current_state <= s4;
			pixelx = pixelx + 10'd1;
		end
		s1:
		begin
		rLED[9:8]<=2'b11;
		a1 <= a2;		//second case 
		b1 <= b2;
		c1 <= c2;
		a2 <= a3;
		b2 <= b3;
		c2 <= c3;
		a3 <= sr_data2;
		b3 <= sr_data0;
		c3 <= sr_data1;
		q <= sr_data1;
		mem_add <= 2'd1;

		if (~isw[17])
		begin		
			rVGASRAM_ADDR <= { (pixelx[9:1]-1),  pixely[9:1]};
			rVGASRAM_DATA <={q[9:0], 6'b000000};	
		end
		if (pixelx > 10'd1)
		begin
			current_state <= s5;
		end
		else
			current_state <= s4;
		pixelx = pixelx + 10'd1;
		end
	s2:
	begin
		rLED[7:6]<=2'b11;
		a1 <= a2;		//third case
		b1 <= b2;
		c1 <= c2;
		a2 <= a3;
		b2 <= b3;
		c2 <= c3;
		a3 <= sr_data1;
		b3 <= sr_data2;
		c3 <= sr_data0;
		q <= sr_data1;
		mem_add <= 2'd2;
		if (~isw[17])
		begin		
			rVGASRAM_ADDR <= { (pixelx[9:1]-1),  pixely[9:1]};
			rVGASRAM_DATA <={q[9:0], 6'b000000};	
		end
		if (pixelx > 10'd1)
		begin
			current_state <= s5;
		end
		else
			current_state <= s4;
		pixelx = pixelx + 10'd1;
	end
	s5:
	begin
	//start edge detection gradient calculation
	sec1 = (a2+a3<<1+b3);
	sec2 = (b1+c1<<1+c2);
	sec3 = (a1 + a2<<1+a3);
	sec4 = (c1+c2<<1+c3);
	sec5 = (a3 + b3<<1+c3);
	sec6 = (a1+b1<<1+c1);
	sec7 = (b1 + a1<<1+a2);
	sec8 = (c2+c3<<1+b3);
	current_state <= s6;
	end
	s6:	
	begin
	//compute absolute value subtraction
	if (sec1 > sec2)
		deriv_ne_sw = sec1 - sec2;
	else
		deriv_ne_sw = sec2 - sec1;
		
	if (sec3 > sec4)
		  deriv_n_s = sec3 - sec4;
	else
		deriv_n_s = sec4 - sec3;
		
	if (sec5 > sec6)	 
		deriv_e_w = sec5 - sec6;
	else 
		deriv_e_w = sec6 - sec5;  
	
	if (sec7 > sec8)
		deriv_nw_se = sec7 - sec8;
	else
		deriv_nw_se = sec8 - sec7;  
	current_state <= s7;
	end
	s7:		//find direction
	begin
	if (deriv_ne_sw > deriv_n_s)
	begin
	edge1 <= deriv_ne_sw;
	prep1 <= deriv_nw_se;
	end
	else
	begin 
	edge1 <= deriv_n_s;
	prep1 <= deriv_e_w;
	end
	
	if(deriv_e_w > deriv_nw_se)
	begin
	edge2 <= deriv_e_w;
	prep2 <= deriv_n_s;
	end
	else
	begin
	edge2 <= deriv_nw_se;
	prep2 <= deriv_ne_sw;
	end
	current_state<=s8;
	end
	s8:	//find max direction
	begin
	if (edge1> edge2)
	begin
	EdgeMax <= edge1;
	edgeprep <= prep1;
	end
	else
	begin
	EdgeMax <= edge2; 
	edgeprep <= prep2;
	end
	current_state<=s9;
	threshold_sw = {6'b000000,isw[6:0],5'b00000};	//edge threshold
	end
	s9:		//output edge decision
	begin
	if (((EdgeMax + edgeprep>>3) > threshold_sw) && isw[17])
	begin
	rVGASRAM_ADDR <= { (pixelx[9:1]-2),  pixely[9:1]};	//output pixel is the middle pixel of the convolution table
	rVGASRAM_DATA <= 16'hffff;
	end
	else if(isw[17])
	begin
	rVGASRAM_ADDR <= { (pixelx[9:1]-2),  pixely[9:1]};
	rVGASRAM_DATA <= 16'h0000;
	end	
	current_state<=s4;
	end
	s4:
	begin
		rLED[1:0]<=2'b11;
		if (pixelx == 10'd639)
		begin
			pixelx = 10'd0;
			if (~screen)
			begin
				if (pixely == 10'd477) //done				
				begin
				//reached end of FIFO buffer	
					//read in new image
					pixely=10'd1; 
					current_state <= s0;
					ImYcoord = 10'd0;	
					ramstate <= s0;
					state <= s0;	
					load <= 1'b1;
					run_edge <= 1'b0;	
					screen <= 1'b1;		
				end
				else
				begin
					//determine the oldest row of pixel and replace the M4K block with a new row
					pixely = pixely + 10'd1;
					if (mem_add == 2'd0)
						ramstate <= s0;
					else if (mem_add == 2'd1)
						ramstate <=s1;
					else
						ramstate <=s2;
					load <= 1'b1;
					run_edge <= 1'b0;
					we2 <= 1'b1;
					we0 <= 1'b1;
					we1 <= 1'b1;
				end
			end
			else 
			begin
					if (pixely == 10'd476) //done				
					begin
						pixely=10'd1; //reached end of FIFO buffer	
						current_state <= s0;
						ImYcoord = 10'd0;	
						ramstate <= s0;
						state <= s0;		
						load <= 1'b1;
						run_edge <= 1'b0;	
						screen <= 1'b0;		
					end
					else
					begin
						pixely = pixely + 10'd1;
						if (mem_add == 2'd0)
							ramstate <= s0;
						else if (mem_add == 2'd1)
							ramstate <=s1;
						else
							ramstate <=s2;
						load <= 1'b1;
						run_edge <= 1'b0;
						we2 <= 1'b1;
						we0 <= 1'b1;
						we1 <= 1'b1;
					end
			end		
		end

		else
		begin
			//continue to update convolution table
			if (mem_add == 2'd0)
				current_state <= s0;
			else if (mem_add == 2'd1)
				current_state <=s1;
			else
			begin
				current_state <=s2;
			end
			addr_reg0 <= pixelx;
			addr_reg1 <= pixelx;
			addr_reg2 <= pixelx;
		end
	end
	endcase
	end
	end
end


ram_infer #(10'd640) M4K_0(sr_data0, addr_reg0, write_data0, we0, iVGA_CTRL_CLK);	
ram_infer #(10'd640)M4K_1(sr_data1, addr_reg1, write_data1, we1, iVGA_CTRL_CLK);	
ram_infer #(10'd640)M4K_2(sr_data2, addr_reg2, write_data2, we2, iVGA_CTRL_CLK);	

endmodule

//////////////////////////////////////////////////
//// M4k ram for circular buffer /////////////////
//////////////////////////////////////////////////
// Synchronous RAM with Read-Through-Write Behavior
// and modified for 18 bit access
// of 109 words to tune for 440 Hz
module ram_infer (q, a, d, we, clk);
output  [9:0] q;
input [9:0] d;
input [9:0] a;
input we, clk;
reg [9:0] read_add;
//define the length of the shiftregister
parameter x_length = 639 ;   //640 pixels across in fifo
reg [15:0] mem [639:0];
	always @ (posedge clk) 
	begin
		if (we) mem[a] <= d;
		read_add <= a;
	end
	assign q = mem[read_add];
endmodule 
//////////////////////////////////////////////////