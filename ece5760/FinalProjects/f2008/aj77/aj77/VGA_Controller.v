//Slightly modified from the DE2 default design example
//
module	VGA_Controller(	//	Host Side
						iCursor_RGB_EN,
						iCursor_X,
						iCursor_Y,
						iCursor_R,
						iCursor_G,
						iCursor_B,
						iRed,
						iGreen,
						iBlue,
						oAddress,
						oCoord_X,
						oCoord_Y,
						//	VGA Side
						oVGA_R,
						oVGA_G,
						oVGA_B,
						oVGA_H_SYNC,
						oVGA_V_SYNC,
						oVGA_SYNC,
						oVGA_BLANK,
						oVGA_CLOCK,
						//	Control Signal
						iCLK,
						iRST_N,
						irow191817,
						irow161514,
						irow131211,
						irow1098,
						irow765,
						irow432,
						iscoreofplayer	);

`include "VGA_Param.h"

//	Host Side
output	reg	[19:0]	oAddress;
output	reg	[9:0]	oCoord_X;
output	reg	[9:0]	oCoord_Y;
input		[3:0]	iCursor_RGB_EN;
input		[9:0]	iCursor_X;
input		[9:0]	iCursor_Y;
input		[9:0]	iCursor_R;
input		[9:0]	iCursor_G;
input		[9:0]	iCursor_B;
input		[9:0]	iRed;
input		[9:0]	iGreen;
input		[9:0]	iBlue;

//rowinputs
input       [29:0]  irow191817 ; 
input       [29:0]  irow161514 ; 
input       [29:0]  irow131211 ; 
input       [29:0]  irow1098 ; 
input       [29:0]  irow765 ; 
input       [29:0]  irow432 ; 
input       [15:0]  iscoreofplayer ;




//	VGA Side
output		[9:0]	oVGA_R;
output		[9:0]	oVGA_G;
output		[9:0]	oVGA_B;
output	reg			oVGA_H_SYNC;
output	reg			oVGA_V_SYNC;
output				oVGA_SYNC;
output				oVGA_BLANK;
output				oVGA_CLOCK;
//	Control Signal
input				iCLK;
input				iRST_N;

//	Internal Registers and Wires
reg		[9:0]		H_Cont;
reg		[9:0]		V_Cont;
reg		[9:0]		Cur_Color_R;
reg		[9:0]		Cur_Color_G;
reg		[9:0]		Cur_Color_B;
wire				mCursor_EN;
wire				mRed_EN;
wire				mGreen_EN;
wire				mBlue_EN;

assign	oVGA_BLANK	=	oVGA_H_SYNC & oVGA_V_SYNC;
assign	oVGA_SYNC	=	1'b0;
assign	oVGA_CLOCK	=	iCLK;
assign	mCursor_EN	=	iCursor_RGB_EN[3];
assign	mRed_EN		=	iCursor_RGB_EN[2];
assign	mGreen_EN	=	iCursor_RGB_EN[1];
assign	mBlue_EN	=	iCursor_RGB_EN[0];

assign	oVGA_R	=	(	H_Cont>=X_START+9 	&& H_Cont<X_START+H_SYNC_ACT+9 &&
						V_Cont>=Y_START 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	(mRed_EN	?	Cur_Color_R	:	0)	:	0;
assign	oVGA_G	=	(	H_Cont>=X_START+9 	&& H_Cont<X_START+H_SYNC_ACT+9 &&
						V_Cont>=Y_START 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	(mGreen_EN	?	Cur_Color_G	:	0)	:	0;
assign	oVGA_B	=	(	H_Cont>=X_START+9 	&& H_Cont<X_START+H_SYNC_ACT+9 &&
						V_Cont>=Y_START 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	(mBlue_EN	?	Cur_Color_B	:	0)	:	0;


//my code
//digit logic calculation 
reg [6:0] digit1 , digit2, digit3 ;
wire [6:0] tdigit0 ,  tdigit1 , tdigit2 , tdigit3 , tdigit4 , tdigit5 , tdigit6 , tdigit7 , tdigit8 , tdigit9 ;

hexout u1(iscoreofplayer       , tdigit0) ; 
hexout u2(iscoreofplayer - 10  , tdigit1) ;
hexout u3(iscoreofplayer - 20  , tdigit2) ;
hexout u4(iscoreofplayer - 30  , tdigit3) ;
hexout u5(iscoreofplayer - 40  , tdigit4) ;
hexout u6(iscoreofplayer - 50  , tdigit5) ;
hexout u7(iscoreofplayer - 60  , tdigit6) ;
hexout u8(iscoreofplayer - 70  , tdigit7) ;
hexout u9(iscoreofplayer - 80  , tdigit8) ;
hexout u10(iscoreofplayer - 90  , tdigit9) ;



always @ (*)
begin
	if (iscoreofplayer < 10) 
	begin 
	digit1 = tdigit0  ; 
	digit2 = 7'b0111111 ;
	digit3 = 7'b0111111 ;  
	end

	else if (iscoreofplayer < 20) 
	begin
	digit1 = tdigit1  ; 
	digit2 = 7'b0000110 ;
	digit3 = 7'b0111111 ;
	end

	else if (iscoreofplayer < 30) 
	begin 
	digit1 = tdigit2  ; 
	digit2 = 7'b1011011 ; 
	digit3 = 7'b0111111 ;
	end

	else if (iscoreofplayer < 40) 
	begin 
	digit1 = tdigit3  ; 
	digit2 = 7'b1001111 ; 
	digit3 = 7'b0111111 ;
	end


	else if (iscoreofplayer < 50) 
	begin 
	digit1 = tdigit4  ; 
	digit2 = 7'b1100110 ;  
	digit3 = 7'b0111111 ;
	end


	else if (iscoreofplayer < 60) 
	begin 
	digit1 = tdigit5  ; 
	digit2 = 7'b1101101 ; 
	digit3 = 7'b0111111 ;
	end


	else if (iscoreofplayer < 70) 
	begin 
	digit1 = tdigit6  ; 
	digit2 = 7'b1111101 ;
	digit3 = 7'b0111111 ; 
	end

	else if (iscoreofplayer < 80) 
	begin 
	digit1 = tdigit7  ; 
	digit2 = 7'b0000111 ; 
	digit3 = 7'b0111111 ;
	end

	else if (iscoreofplayer < 90) 
	begin 
	digit1 = tdigit8  ; 
	digit2 = 7'b1111111 ;
	digit3 = 7'b0111111 ;
	end

	else if (iscoreofplayer < 100) 
	begin 
	digit1 = tdigit9  ; 
	digit2 = 7'b1100111 ; 
	digit3 = 7'b0111111 ;
	end

end



//one section of my code ends

















//	Pixel LUT Address Generator
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		oCoord_X	<=	0;
		oCoord_Y	<=	0;
		oAddress	<=	0;
	end
	else
	begin
		if(	H_Cont>=X_START && H_Cont<X_START+H_SYNC_ACT &&
			V_Cont>=Y_START && V_Cont<Y_START+V_SYNC_ACT )
		begin
			oCoord_X	<=	H_Cont-X_START;
			oCoord_Y	<=	V_Cont-Y_START;
			oAddress	<=	oCoord_Y*H_SYNC_ACT+oCoord_X-3;
		end
	end
end

//	Cursor Generator	
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		Cur_Color_R	<=	0;
		Cur_Color_G	<=	0;
		Cur_Color_B	<=	0;
	end
	else
	begin
		if(	H_Cont>=X_START+8 && H_Cont<X_START+H_SYNC_ACT+8 &&
			V_Cont>=Y_START && V_Cont<Y_START+V_SYNC_ACT )
		begin
			if( (	(H_Cont==X_START + 8 + iCursor_X) 	||
					(H_Cont==X_START + 8 + iCursor_X+1) ||
					(H_Cont==X_START + 8 + iCursor_X-1) ||
			 		(V_Cont==Y_START + iCursor_Y)	||
					(V_Cont==Y_START + iCursor_Y+1)	||
					(V_Cont==Y_START + iCursor_Y-1)	)
					&& mCursor_EN )
			begin
				Cur_Color_R	<=	iCursor_R;
				Cur_Color_G	<=	iCursor_G;
				Cur_Color_B	<=	iCursor_B;
			end
			
			//******************my code***************************
			//*************************************************
			else if( (((V_Cont - Y_START) > 420 ) && ((V_Cont - Y_START) < 440)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[9]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 420 ) && ((V_Cont - Y_START) < 440)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[8]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 420 ) && ((V_Cont - Y_START) < 440)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[7]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 420 ) && ((V_Cont - Y_START) < 440)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[6]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 420 ) && ((V_Cont - Y_START) < 440)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[5]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 420 ) && ((V_Cont - Y_START) < 440)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[4]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 420 ) && ((V_Cont - Y_START) < 440)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[3]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 420 ) && ((V_Cont - Y_START) < 440)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[2]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 420 ) && ((V_Cont - Y_START) < 440)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[1]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 420 ) && ((V_Cont - Y_START) < 440)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[0]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			
			//*************************************************************************************
			
			else if( (((V_Cont - Y_START) > 400 ) && ((V_Cont - Y_START) < 420)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[19]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 400 ) && ((V_Cont - Y_START) < 420)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[18]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 400 ) && ((V_Cont - Y_START) < 420)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[17]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 400 ) && ((V_Cont - Y_START) < 420)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[16]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 400 ) && ((V_Cont - Y_START) < 420)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[15]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 400 ) && ((V_Cont - Y_START) < 420)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[14]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 400 ) && ((V_Cont - Y_START) < 420)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[13]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 400 ) && ((V_Cont - Y_START) < 420)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[12]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 400 ) && ((V_Cont - Y_START) < 420)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[11]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 400 ) && ((V_Cont - Y_START) < 420)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[10]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			
			//**********************************************************************************************************
			
			
			else if( (((V_Cont - Y_START) > 380 ) && ((V_Cont - Y_START) < 400)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[29]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 380 ) && ((V_Cont - Y_START) < 400)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[28]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 380 ) && ((V_Cont - Y_START) < 400)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[27]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 380 ) && ((V_Cont - Y_START) < 400)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[26]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 380 ) && ((V_Cont - Y_START) < 400)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[25]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 380 ) && ((V_Cont - Y_START) < 400)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[24]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 380 ) && ((V_Cont - Y_START) < 400)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[23]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 380 ) && ((V_Cont - Y_START) < 400)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[22]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 380 ) && ((V_Cont - Y_START) < 400)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[21]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 380 ) && ((V_Cont - Y_START) < 400)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow191817[20]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			//**********************************************************************
			
			
			//*************************************************
			else if( (((V_Cont - Y_START) > 360 ) && ((V_Cont - Y_START) < 380)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[9]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 360 ) && ((V_Cont - Y_START) < 380)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[8]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 360 ) && ((V_Cont - Y_START) < 380)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[7]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 360 ) && ((V_Cont - Y_START) < 380)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[6]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 360 ) && ((V_Cont - Y_START) < 380)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[5]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 360 ) && ((V_Cont - Y_START) < 380)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[4]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 360 ) && ((V_Cont - Y_START) < 380)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[3]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 360 ) && ((V_Cont - Y_START) < 380)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[2]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 360 ) && ((V_Cont - Y_START) < 380)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[1]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 360 ) && ((V_Cont - Y_START) < 380)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[0]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			
			//*************************************************************************************
			
			else if( (((V_Cont - Y_START) > 340 ) && ((V_Cont - Y_START) < 360)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[19]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 340 ) && ((V_Cont - Y_START) < 360)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[18]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 340 ) && ((V_Cont - Y_START) < 360)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[17]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 340 ) && ((V_Cont - Y_START) < 360)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[16]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 340 ) && ((V_Cont - Y_START) < 360)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[15]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 340 ) && ((V_Cont - Y_START) < 360)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[14]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 340 ) && ((V_Cont - Y_START) < 360)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[13]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 340 ) && ((V_Cont - Y_START) < 360)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[12]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 340 ) && ((V_Cont - Y_START) < 360)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[11]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 340 ) && ((V_Cont - Y_START) < 360)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[10]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			
			//**********************************************************************************************************
			
			
			else if( (((V_Cont - Y_START) > 320 ) && ((V_Cont - Y_START) < 340)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[29]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 320 ) && ((V_Cont - Y_START) < 340)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[28]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 320 ) && ((V_Cont - Y_START) < 340)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[27]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 320 ) && ((V_Cont - Y_START) < 340)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[26]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 320 ) && ((V_Cont - Y_START) < 340)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[25]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 320 ) && ((V_Cont - Y_START) < 340)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[24]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 320 ) && ((V_Cont - Y_START) < 340)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[23]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 320 ) && ((V_Cont - Y_START) < 340)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[22]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 320 ) && ((V_Cont - Y_START) < 340)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[21]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 320 ) && ((V_Cont - Y_START) < 340)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow161514[20]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			//**********************************************************************
			
			
			//*************************************************
			else if( (((V_Cont - Y_START) > 300 ) && ((V_Cont - Y_START) < 320)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[9]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 300 ) && ((V_Cont - Y_START) < 320)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[8]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 300 ) && ((V_Cont - Y_START) < 320)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[7]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 300 ) && ((V_Cont - Y_START) < 320)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[6]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 300 ) && ((V_Cont - Y_START) < 320)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[5]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 300 ) && ((V_Cont - Y_START) < 320)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[4]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 300 ) && ((V_Cont - Y_START) < 320)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[3]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 300 ) && ((V_Cont - Y_START) < 320)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[2]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 300 ) && ((V_Cont - Y_START) < 320)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[1]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 300 ) && ((V_Cont - Y_START) < 320)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[0]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			
			//*************************************************************************************
			
			else if( (((V_Cont - Y_START) > 280 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[19]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 280 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[18]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 280 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[17]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 280 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[16]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 280 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[15]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 280 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[14]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 280 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[13]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 280 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[12]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 280 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[11]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 280 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[10]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			
			//**********************************************************************************************************
			
			
			else if( (((V_Cont - Y_START) > 260 ) && ((V_Cont - Y_START) < 280)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[29]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 260 ) && ((V_Cont - Y_START) < 280)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[28]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 260 ) && ((V_Cont - Y_START) < 280)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[27]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 260 ) && ((V_Cont - Y_START) < 280)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[26]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 260 ) && ((V_Cont - Y_START) < 280)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[25]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 260 ) && ((V_Cont - Y_START) < 280)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[24]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 260 ) && ((V_Cont - Y_START) < 280)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[23]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 260 ) && ((V_Cont - Y_START) < 280)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[22]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 260 ) && ((V_Cont - Y_START) < 280)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[21]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 260 ) && ((V_Cont - Y_START) < 280)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow131211[20]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			//**********************************************************************
			
			
			
			//*************************************************
			else if( (((V_Cont - Y_START) > 240 ) && ((V_Cont - Y_START) < 260)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[9]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 240 ) && ((V_Cont - Y_START) < 260)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[8]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 240 ) && ((V_Cont - Y_START) < 260)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[7]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 240 ) && ((V_Cont - Y_START) < 260)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[6]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 240 ) && ((V_Cont - Y_START) < 260)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[5]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 240 ) && ((V_Cont - Y_START) < 260)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[4]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 240 ) && ((V_Cont - Y_START) < 260)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[3]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 240 ) && ((V_Cont - Y_START) < 260)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[2]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 240 ) && ((V_Cont - Y_START) < 260)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[1]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 240 ) && ((V_Cont - Y_START) < 260)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[0]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			
			//*************************************************************************************
			
			else if( (((V_Cont - Y_START) > 220 ) && ((V_Cont - Y_START) < 240)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[19]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 220 ) && ((V_Cont - Y_START) < 240)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[18]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 220 ) && ((V_Cont - Y_START) < 240)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[17]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 220 ) && ((V_Cont - Y_START) < 240)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[16]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 220 ) && ((V_Cont - Y_START) < 240)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[15]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 220 ) && ((V_Cont - Y_START) < 240)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[14]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 220 ) && ((V_Cont - Y_START) < 240)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[13]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 220 ) && ((V_Cont - Y_START) < 240)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[12]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 220 ) && ((V_Cont - Y_START) < 240)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[11]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 220 ) && ((V_Cont - Y_START) < 240)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[10]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			
			//**********************************************************************************************************
			
			
			else if( (((V_Cont - Y_START) > 200 ) && ((V_Cont - Y_START) < 220)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[29]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 200 ) && ((V_Cont - Y_START) < 220)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[28]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 200 ) && ((V_Cont - Y_START) < 220)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[27]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 200 ) && ((V_Cont - Y_START) < 220)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[26]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 200 ) && ((V_Cont - Y_START) < 220)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[25]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 200 ) && ((V_Cont - Y_START) < 220)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[24]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 200 ) && ((V_Cont - Y_START) < 220)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[23]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 200 ) && ((V_Cont - Y_START) < 220)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[22]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 200 ) && ((V_Cont - Y_START) < 220)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[21]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 200 ) && ((V_Cont - Y_START) < 220)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow1098[20]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			//**********************************************************************
			
			
			
			//*************************************************
			else if( (((V_Cont - Y_START) > 180 ) && ((V_Cont - Y_START) < 200)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[9]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 180 ) && ((V_Cont - Y_START) < 200)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[8]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 180 ) && ((V_Cont - Y_START) < 200)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[7]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 180 ) && ((V_Cont - Y_START) < 200)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[6]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 180 ) && ((V_Cont - Y_START) < 200)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[5]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 180 ) && ((V_Cont - Y_START) < 200)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[4]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 180 ) && ((V_Cont - Y_START) < 200)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[3]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 180 ) && ((V_Cont - Y_START) < 200)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[2]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 180 ) && ((V_Cont - Y_START) < 200)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[1]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 180 ) && ((V_Cont - Y_START) < 200)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[0]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			
			//*************************************************************************************
			
			else if( (((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 180)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[19]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 180)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[18]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 180)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[17]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 180)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[16]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 180)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[15]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 180)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[14]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 180)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[13]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 180)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[12]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 180)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[11]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 180)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[10]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			
			//**********************************************************************************************************
			
			
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 160)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[29]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 160)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[28]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 160)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[27]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 160)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[26]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 160)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[25]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 160)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[24]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 160)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[23]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 160)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[22]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 160)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[21]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 160)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow765[20]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			//**********************************************************************
			
			
			else if( (((V_Cont - Y_START) > 120 ) && ((V_Cont - Y_START) < 140)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[9]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 120 ) && ((V_Cont - Y_START) < 140)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[8]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 120 ) && ((V_Cont - Y_START) < 140)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[7]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 120 ) && ((V_Cont - Y_START) < 140)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[6]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 120 ) && ((V_Cont - Y_START) < 140)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[5]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 120 ) && ((V_Cont - Y_START) < 140)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[4]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 120 ) && ((V_Cont - Y_START) < 140)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[3]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 120 ) && ((V_Cont - Y_START) < 140)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[2]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 120 ) && ((V_Cont - Y_START) < 140)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[1]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 120 ) && ((V_Cont - Y_START) < 140)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[0]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			//**********************************************************************
			
			else if( (((V_Cont - Y_START) > 100 ) && ((V_Cont - Y_START) < 120)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[19]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 100 ) && ((V_Cont - Y_START) < 120)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[18]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 100 ) && ((V_Cont - Y_START) < 120)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[17]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 100 ) && ((V_Cont - Y_START) < 120)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[16]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 100 ) && ((V_Cont - Y_START) < 120)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[15]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 100 ) && ((V_Cont - Y_START) < 120)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[14]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 100 ) && ((V_Cont - Y_START) < 120)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[13]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 100 ) && ((V_Cont - Y_START) < 120)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[12]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 100 ) && ((V_Cont - Y_START) < 120)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[11]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 100 ) && ((V_Cont - Y_START) < 120)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[10]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			//**********************************************************************
			
			else if( (((V_Cont - Y_START) > 80 ) && ((V_Cont - Y_START) < 100)) && (((H_Cont - X_START) > 380 ) && ((H_Cont - X_START) < 400)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[29]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 80 ) && ((V_Cont - Y_START) < 100)) && (((H_Cont - X_START) > 400 ) && ((H_Cont - X_START) < 420)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[28]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 80 ) && ((V_Cont - Y_START) < 100)) && (((H_Cont - X_START) > 420 ) && ((H_Cont - X_START) < 440)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[27]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 80 ) && ((V_Cont - Y_START) < 100)) && (((H_Cont - X_START) > 440 ) && ((H_Cont - X_START) < 460)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[26]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 80 ) && ((V_Cont - Y_START) < 100)) && (((H_Cont - X_START) > 460 ) && ((H_Cont - X_START) <480)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[25]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 80 ) && ((V_Cont - Y_START) < 100)) && (((H_Cont - X_START) > 480 ) && ((H_Cont - X_START) < 500)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[24]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 80 ) && ((V_Cont - Y_START) < 100)) && (((H_Cont - X_START) > 500 ) && ((H_Cont - X_START) < 520)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[23]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 80 ) && ((V_Cont - Y_START) < 100)) && (((H_Cont - X_START) > 520 ) && ((H_Cont - X_START) < 540)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[22]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 80 ) && ((V_Cont - Y_START) < 100)) && (((H_Cont - X_START) > 540 ) && ((H_Cont - X_START) < 560)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[21]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			else if( (((V_Cont - Y_START) > 80 ) && ((V_Cont - Y_START) < 100)) && (((H_Cont - X_START) > 560 ) && ((H_Cont - X_START) < 580)) )
			begin
				
				Cur_Color_R	<=	{10{irow432[20]}} ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
			end
			
			//**********************************************************************
			//********************the score generation*****************************
			else if( (((V_Cont - Y_START) > 140 ) && ((V_Cont - Y_START) < 300)) && (((H_Cont - X_START) > 270 ) && ((H_Cont - X_START) < 370)) )
			begin
				if((((H_Cont - X_START) > 280 ) && ((H_Cont - X_START) < 300)))
				begin
					 if(((V_Cont - Y_START) == 150 ))
					 begin
					 Cur_Color_R	<=	{10{digit3[0]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if(((V_Cont - Y_START) == 160 ))
					 begin
				     Cur_Color_R	<=	{10{digit3[6]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if(((V_Cont - Y_START) == 170 ))
					 begin
				     Cur_Color_R	<=	{10{digit3[3]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 150 ) && ((V_Cont - Y_START) < 160)) && ((H_Cont - X_START) == 281 ))
					 begin
				     Cur_Color_R	<=	{10{digit3[5]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 150 ) && ((V_Cont - Y_START) < 160)) && ((H_Cont - X_START) == 299 ))
					 begin
				     Cur_Color_R	<=	{10{digit3[1]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 170)) && ((H_Cont - X_START) == 281 ))
					 begin
				     Cur_Color_R	<=	{10{digit3[4]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 170)) && ((H_Cont - X_START) == 299 ))
					 begin
				     Cur_Color_R	<=	{10{digit3[2]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else
					 begin
					 Cur_Color_R	<=	0 ;
				     Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0;
				     end

				end
				
				else if((((H_Cont - X_START) > 310 ) && ((H_Cont - X_START) < 330)))
				begin
				if(((V_Cont - Y_START) == 150 ))
					 begin
					 Cur_Color_R	<=	{10{digit2[0]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if(((V_Cont - Y_START) == 160 ))
					 begin
				     Cur_Color_R	<=	{10{digit2[6]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if(((V_Cont - Y_START) == 170 ))
					 begin
				     Cur_Color_R	<=	{10{digit2[3]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 150 ) && ((V_Cont - Y_START) < 160)) && ((H_Cont - X_START) == 311 ))
					 begin
				     Cur_Color_R	<=	{10{digit2[5]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 150 ) && ((V_Cont - Y_START) < 160)) && ((H_Cont - X_START) == 329 ))
					 begin
				     Cur_Color_R	<=	{10{digit2[1]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 170)) && ((H_Cont - X_START) == 311 ))
					 begin
				     Cur_Color_R	<=	{10{digit2[4]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 170)) && ((H_Cont - X_START) == 329 ))
					 begin
				     Cur_Color_R	<=	{10{digit2[2]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else
					 begin
					 Cur_Color_R	<=	0 ;
				     Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0;
				     end
				end
				
				else if((((H_Cont - X_START) > 340 ) && ((H_Cont - X_START) < 360)))
				begin
				if(((V_Cont - Y_START) == 150 ))
					 begin
					 Cur_Color_R	<=	{10{digit1[0]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if(((V_Cont - Y_START) == 160 ))
					 begin
				     Cur_Color_R	<=	{10{digit1[6]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if(((V_Cont - Y_START) == 170 ))
					 begin
				     Cur_Color_R	<=	{10{digit1[3]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 150 ) && ((V_Cont - Y_START) < 160)) && ((H_Cont - X_START) == 341 ))
					 begin
				     Cur_Color_R	<=	{10{digit1[5]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 150 ) && ((V_Cont - Y_START) < 160)) && ((H_Cont - X_START) == 359 ))
					 begin
				     Cur_Color_R	<=	{10{digit1[1]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 170)) && ((H_Cont - X_START) == 341 ))
					 begin
				     Cur_Color_R	<=	{10{digit1[4]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else if ((((V_Cont - Y_START) > 160 ) && ((V_Cont - Y_START) < 170)) && ((H_Cont - X_START) == 359 ))
					 begin
				     Cur_Color_R	<=	{10{digit1[2]}} ;
					 Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0 ; 
					 end
					 
					 else
					 begin
					 Cur_Color_R	<=	0 ;
				     Cur_Color_G	<=	0 ;
					 Cur_Color_B	<=	0;
				     end

			
				end
				
				else 
				begin
				Cur_Color_R	<=	0 ;
				Cur_Color_G	<=	0 ;
				Cur_Color_B	<=	0;
				end
			end 
			 
			//***************************************************************************
			else
			begin
				Cur_Color_R	<=	iRed;
				Cur_Color_G	<=	iGreen;
				Cur_Color_B	<=	iBlue;
			end			
		end
	end
end

//	H_Sync Generator, Ref. 25.175 MHz Clock
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		H_Cont		<=	0;
		oVGA_H_SYNC	<=	0;
	end
	else
	begin
		//	H_Sync Counter
		if( H_Cont < H_SYNC_TOTAL )
		H_Cont	<=	H_Cont+1;
		else
		H_Cont	<=	0;
		//	H_Sync Generator
		if( H_Cont < H_SYNC_CYC )
		oVGA_H_SYNC	<=	0;
		else
		oVGA_H_SYNC	<=	1;
	end
end

//	V_Sync Generator, Ref. H_Sync
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		V_Cont		<=	0;
		oVGA_V_SYNC	<=	0;
	end
	else
	begin
		//	When H_Sync Re-start
		if(H_Cont==0)
		begin
			//	V_Sync Counter
			if( V_Cont < V_SYNC_TOTAL )
			V_Cont	<=	V_Cont+1;
			else
			V_Cont	<=	0;
			//	V_Sync Generator
			if(	V_Cont < V_SYNC_CYC )
			oVGA_V_SYNC	<=	0;
			else
			oVGA_V_SYNC	<=	1;
		end
	end
end

endmodule




//***************************for the scoring display**************************************************
module hexout(
input wire [15:0] value , 
output reg  [6:0] outvalue
);

wire [3:0] tempvalue ; 
assign tempvalue = value[3:0] ; 


always @ (value)
 case(tempvalue)
	4'd0 : outvalue = 7'b0111111 ; 
	4'd1 : outvalue = 7'b0000110 ; 
	4'd2 : outvalue = 7'b1011011 ; 
	4'd3 : outvalue = 7'b1001111 ; 
	4'd4 : outvalue = 7'b1100110 ; 
	4'd5 : outvalue = 7'b1101101 ; 
	4'd6 : outvalue = 7'b1111101 ; 
	4'd7 : outvalue = 7'b0000111 ; 
	4'd8 : outvalue = 7'b1111111 ; 
	4'd9 : outvalue = 7'b1100111 ; 
    default : outvalue = 7'b0111111 ;
 endcase 

endmodule 

//mycode ends