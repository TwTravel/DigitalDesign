////////////////////////////////
// for 1.8 unsigned fixed pt
// quotient / divisor = result
// ECE 5760 - Cornell University - Fall 2010
// Kerran Flanagan, Tom Gowing, Jeff Yates
////////////////////////////////

module ufpDiv (
	iQ,
	iD,
	oR );
	
	input unsigned	  [8:0] iQ, iD;
	// output  [8:0] oR;

	// wire [8:0] temp;
	
	// wire [3:0] shamt;
	
	// findHighOrderBit fhob0({1'b0,iD}, shamt);
	
	// assign temp = iQ >> shamt;
	
	// assign oR = temp[8:0];
	
	output reg unsigned [8:0] oR;

	wire unsigned [16:0] temp;
	
	assign temp = {iQ, 8'b0} / iD;
	
	//divide by 1.0 means shift right 8, this works
	
	// approx the division for 1.8
	always @(iD) begin
	
		oR <= temp[8:0]; //temp is 9.8, grab 1.8 from it
	
		// casex(iD)
			// 9'b1111xxxxx: oR= (iQ >> 1) + (iQ >> 5); //.5333
			// 9'b1110xxxxx: oR= (iQ >> 1) + (iQ >> 4); //.5714
			// 9'b1101xxxxx: oR= (iQ >> 1) + (iQ >> 3); //.6153
			// 9'b1100xxxxx: oR= (iQ >> 1) + (iQ >> 3) + (iQ >> 5); //.6667
			// 9'b1011xxxxx: oR= (iQ >> 1) + (iQ >> 2) - (iQ >> 5); //.7272
			// 9'b1010xxxxx: oR= (iQ >> 1) + (iQ >> 2) + (iQ >> 4); //.8000
			// 9'b1001xxxxx: oR= iQ - (iQ >> 3); //0.8888
			// 9'b1000xxxxx: oR= iQ; //1
			// 9'b0111xxxxx: oR= iQ + (iQ >> 3); //1.1428
			// 9'b0110xxxxx: oR= iQ + (iQ >> 2) + (iQ >> 4); //1.3333
			// 9'b0101xxxxx: oR= iQ + (iQ >> 1) + (iQ >> 3); //1.6000
			// 9'b0100xxxxx: oR= (iQ << 1); //2
			// 9'b0011xxxxx: oR= (iQ << 1) + (iQ >> 1) + (iQ >> 3); //2.6666
			// 9'b0010xxxxx: oR= (iQ << 2); //4
			// 9'b000000001: oR= (iQ << 8); //256
			// 9'b00000001x: oR= (iQ << 7); //128
			// 9'b0000001xx: oR= (iQ << 6); //64
			// 9'b000001xxx: oR= (iQ << 5); //32
			// 9'b00001xxxx: oR= (iQ << 4); //16
			// 9'b0001xxxxx: oR= (iQ << 3); //8
			// default:	  oR= 9'b111111111 ; // inf
		// endcase
	end
	
	
endmodule
	