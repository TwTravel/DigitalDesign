module Mirror_Col(	//	Input Side
					iCCD_R,
					iCCD_G,
					iCCD_B,
					iCCD_DVAL,
					iCCD_PIXCLK,
					iRST_N,
					//	Output Side
					oCCD_BW,
					oCCD_DVAL,
//					oLED	
);
//	Input Side					
input	[9:0]	iCCD_R;
input	[9:0]	iCCD_G;
input	[9:0]	iCCD_B;
input			iCCD_DVAL;
input			iCCD_PIXCLK;
input			iRST_N;
//	Output Side
output	[9:0]	oCCD_BW;
output			oCCD_DVAL;
//	Internal Registers
reg		[9:0]	Z_Cont;
reg				mCCD_DVAL;

//output [17:0]	oLED;

assign	oCCD_DVAL	=	mCCD_DVAL;

//calculate grayscale image
wire [9:0] greyscale = (iCCD_R) + (iCCD_G<<1) + (iCCD_B);


always@(posedge iCCD_PIXCLK or negedge iRST_N)
begin
	

	if(!iRST_N)
	begin
		mCCD_DVAL	<=	0;
		Z_Cont		<=	0;
	end
	else
	begin
		mCCD_DVAL	<=	iCCD_DVAL;
		if(Z_Cont<640)
		begin
			if(iCCD_DVAL)
			Z_Cont	<=	Z_Cont+1'b1; //counter to mirror image 
		end
		else
		Z_Cont	<=	0;
	end
end


Stack_RAM (
			.clock(iCCD_PIXCLK),
			.data(greyscale),  //convert to grayscale
			.rdaddress(639-Z_Cont),  //revere the address to mirror image
			.wraddress(Z_Cont),
			.wren(iCCD_DVAL),
			.q(oCCD_BW));

