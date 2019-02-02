//-----------MULTIPLIER-----------------
module Multiplier( iA , iB , oProduct);

input signed   [17:0] iA,iB;
output [17:0] oProduct;
wire signed [17:0] oProduct;

wire signed [35:0] temp;

assign temp = iA * iB ;
 
assign oProduct = {temp[35],temp[24:8]};  

endmodule
//---------------------------------------

//-----------DIVIDER-----------------
module Divider( iA, iB , oResult);

input signed [17:0] iA,iB;
output signed [17:0] oResult;


wire signed [35:0] temp;
wire signed [17:0] temp2;

assign temp = iA << 8 ;
assign temp2 = temp/iB;

//assign oResult = {temp2[35],temp2[23:8]};
assign oResult = temp2;

endmodule
//---------------------------------------

//-----------SQUARE ROOT-----------------
module SquareRoot(iClk,iNum,oR,iStart,oDone,iReset);

input iClk;
input iReset;
input iStart;
input [17:0] iNum;

output [17:0] oR;
output oDone;
//reg [17:0] oR;
reg oDone;

wire [31:0] SqTemp;
reg [31:0] remHi;
reg [31:0] remLo;
reg [31:0] root;
reg [31:0] testDiv;

reg [2:0] state;
reg last_start;
reg [4:0] Count;
wire [17:0] Div;

parameter [2:0] INIT= 3'd0,ONE = 3'd1, TWO = 3'd2,THREE = 3'd3, IDLE = 3'd4; 

wire signed [35:0] temp;
wire Div1,Div4,Div16,Div64;
wire [17:0] SqI;

assign Div1 = iNum < 18'h2_00;
assign Div4 = ((iNum >> 2) < 18'h2_00);
assign Div16 = ((iNum >> 4) < 18'h2_00);
assign Div64 = ((iNum >> 8) < 18'h2_00);

assign Div = Div1? 18'h1_00 :
			 (Div4? 18'h2_00 :
			 (Div16? 18'h4_00 : 18'h10_00));

assign SqI =  Div1? iNum :			
			 (Div4? (iNum >> 2) :
			 (Div16? (iNum >> 4) : (iNum >> 8)));  

assign SqTemp = { 1'b0,SqI[8:0],22'b0};


assign temp = oDone?  Div * {8'b0,root[30:21]}: 36'd0;
assign oR = /*oDone? root[31:13]: 18'h0;*/{temp[35],temp[24:8]};  

always @ (posedge iClk)begin
	if ( iReset ) begin
		root <= 0; /* Clear root */
		remHi <= 0; /* Clear high part of partial remainder */
//		state <= IDLE;
		state <= INIT;
		oDone <= 1'b0;
		Count <= 5'd0;
		last_start <= 1'b0;
	end
	
	case (state)
	
	IDLE : begin
			if( iStart && ~last_start ) begin
				last_start <=1'b1;
				state<= INIT;
				oDone <= 1'b0;
			end 
			else if ( ~iStart && last_start )begin
				last_start <= 1'b0;
				state <= IDLE;
			end
			else
			begin
				state <= IDLE;
			end
		   end
	INIT: begin
		    root <= 0; /* Clear root */
			remHi <= 0; /* Clear high part of partial remainder */
			remLo <= SqTemp; /* Get argument into low part of partial remainder */
			state <= ONE;
			Count <= 5'd0;
		  end
	ONE: begin
			if( Count  < 5'd30 ) begin
		     	remHi <= (remHi << 2'd2) | (remLo >> 5'd30); 
				root <= root << 1'b1;
				Count <= Count + 1'b1;
				state <= TWO;
			end
			else begin
				state <= IDLE;
//				oR <= root;
				oDone <= 1'b1;
			end	
		 end
	TWO:begin
			remLo <= remLo << 2'd2;
			testDiv <= (root << 1'b1) + 1'b1;
			state <= THREE;
	    end
	THREE: begin
		if (remHi >= testDiv) begin
			remHi <= remHi - testDiv;
			root <= root + 2'd1;
		end	
		else begin
			remHi <= remHi;
			root <= root ;
		end	
		state <= ONE;
	end
  endcase
end

endmodule
//---------------------------------------

//-------------NORM----------------------
module norm ( iClk,
			  iReset,
			  iStart,
			  iI1,
			  iJ1,
			  iK1,
			  oN,
			  oDone
			);

input iClk;
input iReset;
input iStart;
			
input [17:0] iI1;
input [17:0] iJ1;
input [17:0] iK1;
output [17:0] oN;
output oDone;

wire [17:0] sqrI, sqrJ, sqrK;
wire [17:0] sqrSum;
wire [17:0] tempRoot;

Multiplier sq1( .iA(iI1) ,
 			   .iB(iI1) , 
			   .oProduct(sqrI)
			  );

Multiplier sq2( .iA(iJ1) ,
 			   .iB(iJ1) , 
			   .oProduct(sqrJ)
			  );
			
Multiplier sq3( .iA(iK1) ,
 			   .iB(iK1) , 
			   .oProduct(sqrK)
			  );

assign sqrSum = sqrI + sqrJ + sqrK;
			
SquareRoot	s1(.iClk(iClk),
			   .iNum(sqrSum),
			   .oR(tempRoot), 
			   .iStart(/*1'h1*/iStart), 
			   .oDone(oDone), 
			   .iReset(iReset)
			);
			
assign oN = oDone? tempRoot : 18'd0;
			
endmodule
//--------------------------------------


//-------------NORMALIZE-------------
module  normalize(  iClk,
					iReset,
					iStart,
					iAi,
					iAj,
					iAk,
					oAi,
					oAj,
					oAk,
					oDone
					);
					
input iClk,iReset;
input [17:0] iAi,iAj,iAk;
input iStart;

output [17:0] oAi,oAj,oAk;
output oDone;

wire [17:0] normA;

norm n1 ( .iClk(iClk),
		  .iReset(iReset),
		  .iI1(iAi),
		  .iJ1(iAj),
		  .iK1(iAk),
		  .oN(normA),
		  .oDone(oDone),
		  .iStart(iStart)
		);
			
Divider  d1 ( .iA(iAi),
			  .iB(normA) ,
			  .oResult(oAi)
			);
			
Divider  d2 ( .iA(iAj),
			  .iB(normA) ,
			  .oResult(oAj)
			);
			
Divider  d3 ( .iA(iAk),
			  .iB(normA) ,
			  .oResult(oAk)
			);

endmodule

//--------------------------------------


//-------------CROSS PRODUCT-------------
module crossproduct(
					iAi,iAj,iAk,
					iBi,iBj,iBk,
					oCi,oCj,oCk
					);
					
input signed [17:0] iAi,iAj,iAk;
input signed [17:0] iBi,iBj,iBk;

output signed [17:0] oCi,oCj,oCk;

wire signed [17:0]  AiBj,AiBk,AjBi,AjBk,AkBi,AkBj;

Multiplier m1( .iA(iAi) ,
 			   .iB(iBj) , 
			   .oProduct(AiBj)
			  );
			
Multiplier m2( .iA(iAi) ,
 			   .iB(iBk) , 
			   .oProduct(AiBk)
			  );
			
Multiplier m3( .iA(iAj) ,
 			   .iB(iBi) , 
			   .oProduct(AjBi)
			  );
			
Multiplier m4( .iA(iAj) ,
 			   .iB(iBk) , 
			   .oProduct(AjBk)
			  );
			
Multiplier m5( .iA(iAk) ,
 			   .iB(iBi) , 
			   .oProduct(AkBi)
			  );
			
Multiplier m6( .iA(iAk) ,
 			   .iB(iBj) , 
			   .oProduct(AkBj)
			  );
			
assign oCi = AjBk - AkBj;
assign oCj = AkBi - AiBk;
assign oCk = AiBj - AjBi;

endmodule

//--------------------------------------
