//-------------Transform---------------
module Transform (iClk,
				  iReset,
				  iStart,
				  iLookFromI, 
				  iLookFromJ, 
				  iLookFromK, 
				  iLookToI,
				  iLookToJ,
				  iLookToK, 
				  iUpVectApproxI,
				  iUpVectApproxJ,
				  iUpVectApproxK, 
				  oDone,
				  nI,nJ,nK,
				  vI,vJ,vK,
				  uI,uJ,uK,
				 );
//LookFrom -- Camera position
//LookTo -- Camera Aim point
//UpVectApprox -- Approx up vector
//d -- dist from camera to near clip plane
//f -- dist from camera to far clip plane
//h -- height of view volume

input iClk;
input iReset;
input iStart;

input [17:0] iLookFromI,iLookFromJ,iLookFromK;
input [17:0] iLookToI, iLookToJ, iLookToK;
input [17:0] iUpVectApproxI, iUpVectApproxJ,iUpVectApproxK;


output oDone;


output [17:0] nI,nJ,nK;
output [17:0] vI,vJ,vK;
output [17:0] uI,uJ,uK;

wire nStart,nDone ;
wire vDone;
reg vStart,rvStart,rrvStart,rrrvStart;

wire [17:0] oUpVectApproxI,oUpVectApproxJ,oUpVectApproxK;
wire UpVectorStart,UpVectorDone;

assign nStart = iStart;

normalize calculateN( 
			.iClk(iClk),
			.iReset(iReset),
			.iStart(/*1'b1*/nStart),
			.iAi(iLookToI - iLookFromI),
			.iAj(iLookToJ - iLookFromJ),
			.iAk(iLookToK - iLookFromK),
			.oAi(nI),
			.oAj(nJ),
			.oAk(nK),
			.oDone(nDone)
			);

assign UpVectorStart = iStart;  //nDone & ( ~ResetAllControls );

normalize  calculateUpVectorApprox(
				.iClk(iClk),
				.iReset(iReset),
				.iStart(/*1'b1*/UpVectorStart),
				.iAi(iUpVectApproxI),
				.iAj(iUpVectApproxJ),
				.iAk(iUpVectApproxK),
				.oAi(oUpVectApproxI),
				.oAj(oUpVectApproxJ),
				.oAk(oUpVectApproxK),
				.oDone(UpVectorDone)
				);


// By now we have UpVectApprox as UpVectApproxI,UpVectApproxJ,UpVectApproxK
//UpVectApprox = UpVectApprox/norm(UpVectApprox) ; 
reg entered;
always @(posedge iClk)begin
    if(iReset) begin
		entered<=1'b0;
	end
	
	if ( UpVectorDone & nDone & ~entered) begin
		entered <= 1'b1;
		vStart <=1'b1;
	end	
	
	if( rrrvStart) begin
		vStart <= 1'b0;
	end
	
	rvStart<= vStart;
	rrvStart <= rvStart;
	rrrvStart <= rrvStart;
end



CalculateV CalculateV1(
				  .iClk(iClk),
				  .iReset(rrvStart),
				  .iStart(1'b1),
				  .iUpVectApproxI(oUpVectApproxI),
				  .iUpVectApproxJ(oUpVectApproxJ),
				  .iUpVectApproxK(oUpVectApproxK),
				  .nI(nI),
				  .nJ(nJ),
				  .nK(nK),
				  .oVi(vI),
				  .oVj(vJ),
				  .oVk(vK),
				  .oDone(vDone/**/),
				 );

assign oDone = vDone;
/*			
V = UpVectApprox - (UpVectApprox * N') * N ;
V = V/norm(V) ;				
*/

crossproduct c1(	
			.iAi(nI),
			.iAj(nJ),
			.iAk(nK),
			.iBi(vI),
			.iBj(vJ),
			.iBk(vK),
			.oCi(uI),
			.oCj(uJ),
			.oCk(uK)
					);
endmodule
//----------------------------------------


module CalculateV(
				  iClk,
				  iStart,
				  iReset,
				  iUpVectApproxI,
				  iUpVectApproxJ,
				  iUpVectApproxK,
				  nI,
				  nJ,
				  nK,
				  oVi,
				  oVj,
				  oVk,
				  oDone
				);
				
input iClk,iStart,iReset;
input signed [17:0] iUpVectApproxI, iUpVectApproxJ,iUpVectApproxK;
input signed [17:0] nI, nJ,nK;

output [17:0] oVi, oVj,oVk;
output oDone;

wire signed [17:0] P1,P2,P3,P,nI1,nJ1,nK1;
wire signed [17:0] vI,vJ,vK;

Multiplier	m1( .iA(iUpVectApproxI) ,
				.iB(nI) ,
				.oProduct(P1)
			  );
			
Multiplier	m2( .iA(iUpVectApproxJ) ,
				.iB(nJ) ,
				.oProduct(P2)
			  );

Multiplier	m3( .iA(iUpVectApproxK) ,
				.iB(nK) ,
				.oProduct(P3)
			  );
			
assign P = P1+P2+P3;

Multiplier	m4( .iA(nI) ,
				.iB(P) ,
				.oProduct(nI1)
			  );

Multiplier	m5( .iA(nJ) ,
				.iB(P) ,
				.oProduct(nJ1)
			  );

Multiplier	m6( .iA(nK) ,
				.iB(P) ,
				.oProduct(nK1)
			  );
			
assign vI = iUpVectApproxI - nI1;
assign vJ = iUpVectApproxJ - nJ1;
assign vK = iUpVectApproxK - nK1;
				
normalize  N1(
				.iClk(iClk),
				.iReset(iReset),
				.iAi(vI),
				.iAj(vJ),
				.iAk(vK),
				.oAi(oVi),
				.oAj(oVj),
				.oAk(oVk),
				.oDone(oDone),
				.iStart(iStart)
			);

endmodule
