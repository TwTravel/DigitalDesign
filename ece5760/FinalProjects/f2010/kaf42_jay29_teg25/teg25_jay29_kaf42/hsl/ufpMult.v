////////////////////////////////
// for 1.8 unsigned fixed pt
// ECE 5760 - Cornell University - Fall 2010
// Kerran Flanagan, Tom Gowing, Jeff Yates
////////////////////////////////

module ufpMult (
	iA,
	iB,
	oC );
	
	input unsigned	  [8:0] iA, iB;
	output unsigned [8:0] oC;

	wire unsigned [17:0] temp;
	
	assign temp = iA * iB;
	
	//result is 2.16, so drop top and take next 9
	assign oC = temp[16:8];
	
	
endmodule
	