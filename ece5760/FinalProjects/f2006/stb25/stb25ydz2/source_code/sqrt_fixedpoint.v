module sqrt_fixedpoint_pipelined(N2,N,CLK,DONE,START,RESET);

//typedef long TFract; /* 2 integer bits, 30 fractional bits */
//TFract
//FFracSqrt(TFract x)
//{
//register unsigned long root, remHi, remLo, testDiv, count;
//root = 0; /* Clear root */
//remHi = 0; /* Clear high part of partial remainder */
//remLo = x; /* Get argument into low part of partial remainder */
//count = 21; /* Load loop counter */
//do {
//remHi = (remHi<<2) | (remLo>>30); remLo <<= 2; /* get 2 bits of arg */
//root <<= 1; /* Get ready for the next bit in the root */
//testDiv = (root << 1) + 1; /* Test radical */
//if (remHi >= testDiv) {
//remHi -= testDiv;
//root++;
//}
//} while (count-- != 0);
//return(root);
//}

input [23:0] N2;
output reg [23:0] N;
input CLK;
output reg DONE;
input START;
input RESET;

reg [4:0] count;
reg [31:0] HI,LI,RI;
wire [31:0] HO,LO,RO;
reg Prev_start,go;
wire [31:0] t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21;

sq_do A(HI,LI,RI,HO,LO,RO);
sq_do B(HO,LO,RO,t1,t2,t3);
sq_do C(t1,t2,t3,t4,t5,t6);
sq_do D(t4,t5,t6,t7,t8,t9);
sq_do E(t7,t8,t9,t10,t11,t12);
sq_do F(t10,t11,t12,t13,t14,t15);
//sq_do G(t13,t14,t15,t16,t17,t18);
//sq_do H(t16,t17,t18,t19,t20,t21);



always @(posedge CLK)begin
if(Prev_start == 0 && START)begin
	Prev_start <= START;
	go <= 1;
	DONE <= 0;
	count <= 0;
end
else begin
	Prev_start <= START;
end

if(RESET)begin
	count <= 4;
	DONE  <= 0;
	HI <= 0;
	LI <= 0;
	RI <= 0;
	N  <= 0;
	go <= 0;
	Prev_start <= 0;
end
else if(go) begin
	if(count == 0)begin
		HI <= 0; LI <= {8'b0,N2}; RI <= 0;
		count <= count + 1;
	end
	else if(count == 4) begin
		DONE <= 1;
		N <= t9[23:0];
		go <= 0;
	end
	else begin
		HI <= t13;
		LI <= t14;
		RI <= t15;
		count <= count + 1;
	end
end
end

endmodule

module sq_do(remHi_in,remLo_in,root_in,remHi_out,remLo_out,root_out);
input [31:0] remHi_in,remLo_in,root_in;
output [31:0] remHi_out,remLo_out,root_out;
wire [31:0] root_t,remHi_t,testDiv;

assign root_t = root_in << 1;
assign testDiv = (root_t << 1) + 1;
assign remHi_t = (remHi_in<<2) | (remLo_in>>30);

assign remLo_out = remLo_in << 2;
assign remHi_out = (remHi_t >= testDiv)? remHi_t - testDiv : remHi_t ;
assign root_out = (remHi_t >= testDiv)? root_t + 1 : root_t ;

endmodule

/*

input [23:0] N2;
output reg [23:0] N;
input CLK;
output reg DONE;
input START;
input RESET;

reg [4:0] count;
reg [31:0] HI,LI,RI;
wire [31:0] HO,LO,RO;
reg Prev_start,go;
wire [31:0] t1,t2,t3,t4,t5,t6,t7,t8,t9;

sq_do A(HI,LI,RI,t1,t2,t3);
sq_do B(t1,t2,t3,HO,LO,RO);
sq_do C(HO,LO,RO,t4,t5,t6);
sq_do D(t4,t5,t6,t7,t8,t9);


always @(posedge CLK)begin
if(Prev_start == 0 && START)begin
	Prev_start <= START;
	go <= 1;
	DONE <= 0;
	count <= 0;
end
else begin
	Prev_start <= START;
end

if(RESET)begin
	count <= 6;
	DONE  <= 0;
	HI <= 0;
	LI <= 0;
	RI <= 0;
	N  <= 0;
	go <= 0;
	Prev_start <= 0;
end
else if(go) begin
	if(count == 0)begin
		HI <= 0; LI <= {8'b0,N2}; RI <= 0;
		count <= count + 1;
	end
	else if(count == 6) begin
		DONE <= 1;
		N <= RO;
		go <= 0;
	end
	else begin
		HI <= t7;
		LI <= t8;
		RI <= t9;
		count <= count + 1;
	end
end
end

endmodule

module sq_do(remHi_in,remLo_in,root_in,remHi_out,remLo_out,root_out);
input [31:0] remHi_in,remLo_in,root_in;
output [31:0] remHi_out,remLo_out,root_out;
wire [31:0] root_t,remHi_t,testDiv;

assign root_t = root_in << 1;
assign testDiv = (root_t << 1) + 1;
assign remHi_t = (remHi_in<<2) | (remLo_in>>30);

assign remLo_out = remLo_in << 2;
assign remHi_out = (remHi_t >= testDiv)? remHi_t - testDiv : remHi_t ;
assign root_out = (remHi_t >= testDiv)? root_t + 1 : root_t ;

endmodule
*/