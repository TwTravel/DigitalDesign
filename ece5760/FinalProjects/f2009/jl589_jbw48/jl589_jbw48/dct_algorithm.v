module dct_algorithm(clk, reset, in0, in1, in2, in3, in4, in5, in6, in7,
                     out0, out1, out2, out3, out4, out5, out6, out7);
                
   parameter A1 = 30'hb5; // cos(4*pi/16)
   parameter A2 = 30'h8b; // cos(2*pi/16) - cos(6*pi/16)
   parameter A4 = 30'h14e; // cos(2*pi/16) + cos(6*pi/16)
   parameter A5 = 30'h62; // cos(6*pi/16)

   input clk, reset;
   input signed [21:0] in0, in1, in2, in3, in4, in5, in6, in7; // fixed point inputs (8 bit fraction)
   output reg signed [21:0] out0, out1, out2, out3, out4, out5, out6, out7; // fixed point outputs
   
   // intermediate math operations
   wire signed [21:0] a0, a1, a2, a3, a4, a5, a6, a7,
      b0, b1, b2, b3, b4, b5, b6, b7, 
      c0, c1, c2, c3, c4, c5, c6, c7, c8, 
      d0, d1, d2, d3, d4, d5, d6, d7, d8,
      e0, e1, e2, e3, e4, e5, e6, e7,
      f0, f1, f2, f3, f4, f5, f6, f7,
      g0, g1, g2, g3, g4, g5, g6, g7;
   
   // pipelined registers
   reg signed [21:0] areg0, areg1, areg2, areg3, areg4, areg5, areg6, areg7,
      breg0, breg1, breg2, breg3, /*breg4, breg5, breg6,*/ breg7, 
      creg0, creg1, creg2, creg3, creg4, creg5, creg6, creg7, //creg8,
      dreg0, dreg1, /*dreg2,*/ dreg3, dreg4, dreg5, dreg6, dreg7, dreg8,
      ereg0, ereg1, ereg2, ereg3, ereg4, ereg5, ereg6, ereg7, 
      freg0, freg1, freg2, freg3, freg4, freg5, freg6, freg7,
      greg0, greg1, greg2, greg3, greg4, greg5, greg6, greg7;
   reg signed [29:0] breg4, breg5, breg6, creg8, dreg2; // these registers are extended because they will be used in a multiply
   
   // performs the steps of the algorithm
   assign a0=in0+in7;
   assign a1=in1+in6;
   assign a2=in2+in5;
   assign a3=in3+in4;
   assign a4=-in4+in3;
   assign a5=-in5+in2;
   assign a6=-in6+in1;
   assign a7=-in7+in0;

   assign b0=areg0+areg3;
   assign b1=areg1+areg2;
   assign b2=-areg2+areg1;
   assign b3=-areg3+areg0;
   assign b4=-areg4-areg5;
   assign b5=areg5+areg6;
   assign b6=areg6+areg7;
   assign b7=areg7;

   assign c0=breg0+breg1;
   assign c1=breg0-breg1;
   assign c2=breg2+breg3;
   assign c3=breg3;
   assign c4=(breg4*A2)>>8;
   assign c5=(breg5*A1)>>8;
   assign c6=(breg6*A4)>>8;
   /*assign c4=((breg4<<7)+(breg4<<3)+(breg4<<1)+(breg4))>>8;
   assign c5=((breg5<<7)+(breg5<<5)+(breg5<<4)+(breg5<<2)+(breg5))>>8;
   assign c6=((breg6<<8)+(breg6<<6)+(breg6<<3)+(breg6<<2)+(breg4<<1))>>8;*/
   assign c7=breg7;
   assign c8=breg4+breg6;

   assign d0=creg0;
   assign d1=creg1;
   assign d2=creg2;
   assign d3=creg3;
   assign d4=creg4;
   assign d5=creg5;
   assign d6=creg6;
   assign d7=creg7;
   assign d8=(creg8*A5)>>8;
   //assign d8=((creg8<<6)+(creg8<<5)+(creg8<<1))>>8;

   assign e0=dreg0;
   assign e1=dreg1;
   assign e2=(dreg2*A1)>>8;
   //assign e2=((dreg2<<7)+(dreg2<<5)+(dreg2<<4)+(dreg2<<2)+(dreg2))>>8;
   assign e3=dreg3;
   assign e4=-dreg4-dreg8;
   assign e5=dreg5;
   assign e6=dreg6-dreg8;
   assign e7=dreg7;

   assign f0=ereg0;
   assign f1=ereg1;
   assign f2=ereg2+ereg3;
   assign f3=ereg3-ereg2;
   assign f4=ereg4;
   assign f5=ereg5+ereg7;
   assign f6=ereg6;
   assign f7=ereg7-ereg5;
   
   assign g0=freg0;
   assign g4=freg1;
   assign g2=freg2;
   assign g6=freg3;
   assign g5=freg4+freg7;
   assign g1=freg5+freg6;
   assign g7=freg5-freg6;
   assign g3=freg7-freg4;

   // POSSIBLE PROBLEM: SHOULD BE CLOCKED ON THE POSITIVE EDGE, OTHERWISE TIMING IS VERY CONSTRAINED (found after demo of project, so it was never tested)
   always @(negedge clk) begin
      // latch the pipeline registers
      areg0 <= a0; areg1 <= a1; areg2 <= a2; areg3 <= a3; areg4 <= a4; areg5 <= a5; areg6 <= a6; areg7 <= a7; 
      breg0 <= b0; breg1 <= b1; breg2 <= b2; breg3 <= b3; breg4 <= {{8{b4[21]}},b4}; breg5 <= {{8{b5[21]}},b5}; breg6 <= {{8{b6[21]}},b6}; breg7 <= b7; 
      creg0 <= c0; creg1 <= c1; creg2 <= c2; creg3 <= c3; creg4 <= c4; creg5 <= c5; creg6 <= c6; creg7 <= c7; creg8 <= {{8{c8[21]}},c8};
      dreg0 <= d0; dreg1 <= d1; dreg2 <= {{8{d2[21]}},d2}; dreg3 <= d3; dreg4 <= d4; dreg5 <= d5; dreg6 <= d6; dreg7 <= d7; dreg8 <= d8;
      //breg0 <= b0; breg1 <= b1; breg2 <= b2; breg3 <= b3; breg4 <= b4; breg5 <= b5; breg6 <= b6; breg7 <= b7; 
      //creg0 <= c0; creg1 <= c1; creg2 <= c2; creg3 <= c3; creg4 <= c4; creg5 <= c5; creg6 <= c6; creg7 <= c7; creg8 <= c8;
      //dreg0 <= d0; dreg1 <= d1; dreg2 <= d2; dreg3 <= d3; dreg4 <= d4; dreg5 <= d5; dreg6 <= d6; dreg7 <= d7; dreg8 <= d8;
      ereg0 <= e0; ereg1 <= e1; ereg2 <= e2; ereg3 <= e3; ereg4 <= e4; ereg5 <= e5; ereg6 <= e6; ereg7 <= e7; 
      freg0 <= f0; freg1 <= f1; freg2 <= f2; freg3 <= f3; freg4 <= f4; freg5 <= f5; freg6 <= f6; freg7 <= f7; 
      greg0 <= g0; greg1 <= g1; greg2 <= g2; greg3 <= g3; greg4 <= g4; greg5 <= g5; greg6 <= g6; greg7 <= g7; 
      
      // the algorithm is extended to 8 cycles to allow for ease of timing when runnning DCTs on two blocks at a time
      out0 <= greg0; out1 <= greg1; out2 <= greg2; out3 <= greg3; out4 <= greg4; out5 <= greg5; out6 <= greg6; out7 <= greg7;  
   end

endmodule
