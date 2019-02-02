module ComputeScreenCoord(
						iXv,iYv,iZv,
						iUi,iUj,iUk,
						iVi,iVj,iVk,
						iNi,iNj,iNk,
						iLookFromI, 
						iLookFromJ, 
				  		iLookFromK, 
						iD, 
				  		iF, 
				  		iH,
						oX,oY,oZ,
					  );
					
					
input signed [17:0] iXv,iYv,iZv;
input signed [17:0] iUi,iUj,iUk;
input signed [17:0] iVi,iVj,iVk;
input signed [17:0] iNi,iNj,iNk;
input signed [17:0] iLookFromI,iLookFromJ,iLookFromK;
input signed [17:0] iD,iF,iH;

output signed [17:0] oX,oY,oZ;

wire signed [17:0] D_H,F_FD;
wire signed [17:0] Xs,Ys,Zs,W;
wire signed [17:0] Tcam00, Tcam01, Tcam02, Tcam03,
			Tcam10, Tcam11, Tcam12, Tcam13,
			Tcam20, Tcam21, Tcam22, Tcam23,
			Tcam30, Tcam31, Tcam32, Tcam33;
			
Divider d1( .iA(iD) , 
			.iB(iH) , 
			.oResult(D_H)
		);
			
Divider d2( .iA(iF) , 
			.iB(iF-iD) , 
			.oResult(F_FD)
			);
			
			
Multiplier m1( .iA(iUi) , 
			   .iB(D_H) , 
			   .oProduct(Tcam00)
		);
		
Multiplier m2( .iA(iUj) , 
			.iB(D_H) , 
			.oProduct(Tcam10)
		);
		
Multiplier m3( .iA(iUk) , 
			.iB(D_H) , 
			.oProduct(Tcam20)
		);
		
Multiplier m4( .iA(iVi) , 
			   .iB(D_H) , 
			   .oProduct(Tcam01)
		);
		
Multiplier m5( .iA(iVj) , 
			.iB(D_H) , 
			.oProduct(Tcam11)
		);
		
Multiplier m6( .iA(iVk) , 
			.iB(D_H) , 
			.oProduct(Tcam21)
		);
		
Multiplier m7( .iA(iNi) , 
			.iB(F_FD) , 
			.oProduct(Tcam02)
		);
		
Multiplier m8( .iA(iNj) , 
			.iB(F_FD) , 
			.oProduct(Tcam12)
		);
		
Multiplier m9( .iA(iNk) , 
			.iB(F_FD) , 
			.oProduct(Tcam22)
		);

wire signed [17:0] t1,t2,t3;
		
Multiplier m10( .iA(iLookFromI) , 
			.iB(Tcam00) , 
			.oProduct(t1)
		);
		
Multiplier m11( .iA(iLookFromJ) , 
			.iB(Tcam10) , 
			.oProduct(t2)
		);
		
Multiplier m12( .iA(iLookFromK) , 
			.iB(Tcam20) , 
			.oProduct(t3)
		);
		
assign Tcam30 = -(t1+t2+t3);


wire signed [17:0] tt1,tt2,tt3;
		
Multiplier m13( .iA(iLookFromI) , 
			.iB(Tcam01) , 
			.oProduct(tt1)
		);
		
Multiplier m14( .iA(iLookFromJ) , 
			.iB(Tcam11) , 
			.oProduct(tt2)
		);
		
Multiplier m15( .iA(iLookFromK) , 
			.iB(Tcam21) , 
			.oProduct(tt3)
		);
		
assign Tcam31 = -(tt1+tt2+tt3);

wire signed [17:0] ttt1,ttt2,ttt3,ttt4;
		
Multiplier m16( .iA(iLookFromI) , 
			.iB(Tcam02) , 
			.oProduct(ttt1)
		);
		
Multiplier m17( .iA(iLookFromJ) , 
			.iB(Tcam12) , 
			.oProduct(ttt2)
		);
		
Multiplier m18( .iA(iLookFromK) , 
			.iB(Tcam22) , 
			.oProduct(ttt3)
		);
		
Multiplier m_t( .iA(iD) , 
			.iB(F_FD) , 
			.oProduct(ttt4)
		);		

assign Tcam32 = -(ttt1+ttt2+ttt3+ttt4);

assign Tcam03 =iNi;
assign Tcam13 =iNj;
assign Tcam23 =iNk;


wire signed [17:0] t_1,t_2,t_3;
		
Multiplier m19( .iA(iLookFromI) , 
			.iB(Tcam03) , 
			.oProduct(t_1)
		);
		
Multiplier m20( .iA(iLookFromJ) , 
			.iB(Tcam13) , 
			.oProduct(t_2)
		);
		
Multiplier m21( .iA(iLookFromK) , 
			.iB(Tcam23) , 
			.oProduct(t_3)
		);
		
assign Tcam33 = -(t_1+t_2+t_3);

wire signed [17:0] a,b,c,d,e,f,g,h,i,j,k,l,m;
	
Multiplier m22( .iA(Tcam00) , 
			.iB(iXv) , 
			.oProduct(a)
		);
		
Multiplier m23( .iA(Tcam10) , 
			.iB(iYv) , 
			.oProduct(b)
		);
		
Multiplier m24( .iA(Tcam20) , 
			.iB(iZv) , 
			.oProduct(c)
		);

assign Xs = a + b +c + Tcam30;

Multiplier m25( .iA(Tcam01) , 
			.iB(iXv) , 
			.oProduct(d)
		);
		
Multiplier m26( .iA(Tcam11) , 
			.iB(iYv) , 
			.oProduct(e)
		);
		
Multiplier m27( .iA(Tcam21) , 
			.iB(iZv) , 
			.oProduct(f)
		);
assign Ys = d + e + f + Tcam31;
 
Multiplier m28( .iA(Tcam02) , 
			.iB(iXv) , 
			.oProduct(g)
		);
		
Multiplier m29( .iA(Tcam12) , 
			.iB(iYv) , 
			.oProduct(h)
		);
		
Multiplier m30( .iA(Tcam22) , 
			.iB(iZv) , 
			.oProduct(i)
		);
assign Zs = g + h + i + Tcam32;

Multiplier m31( .iA(Tcam03) , 
			    .iB(iXv) , 
			    .oProduct(j)
		);
		
Multiplier m32( .iA(Tcam13) , 
			.iB(iYv) , 
			.oProduct(k)
		);
		
Multiplier m33( .iA(Tcam23) , 
			.iB(iZv) , 
			.oProduct(l)
		);
assign W = j + k + l + Tcam33;

Divider  d3( .iA(Xs) , 
			 .iB(W) , 
			 .oResult(oX)
			);

Divider  d4( .iA(Ys), 
			 .iB(W) , 
			 .oResult(oY)
			);

Divider  d5( .iA(Zs), 
			 .iB(W) , 
			 .oResult(oZ)
			);
endmodule
