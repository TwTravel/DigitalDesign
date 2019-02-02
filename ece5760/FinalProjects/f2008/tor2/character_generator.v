module character_generator (clock,
							char_ascii, 
							char_col,
							char_row,
							pixel_out); 
 
input		clock;
input [7:0] char_ascii;
input [2:0] char_col;
input [2:0] char_row;
output 		pixel_out;

wire [10:0]	char_address;
wire [7:0]	char_data;


assign char_address = 	{char_ascii[7:0], char_row[2:0]};
assign pixel_out 	=	char_data[(~char_col[2:0])];	  	

charrom c1(
		char_address,
		~clock,
		char_data);



endmodule 
