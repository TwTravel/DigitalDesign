//this module determines whether or not to color in a pixel
//because the pixel is part of a letter
module screenWriter(	input wire		 	iRESET,
						input wire			iSetL,
						input wire		 	iCLK50,
						input wire [8:0] 	iX,
						input wire [7:0] 	iY,
						input wire [17:0] 	iSW,
						input wire			next_key,
						input wire [8:0]	char,
						output wire [17:0]	oLEDR,
						output wire		 	letter	);

// NUM_LETTER_SIZE = 5 because we might use up to 2^5 different 
// characters in the cgen lookup table
parameter LETTER_WIDTH = 8, LETTER_HEIGHT = 8, NUM_LETTERS_SIZE = 5;

// Store 16 characters to write to the screen
parameter SCREEN_WIDTH = 16, SCREEN_WIDTH_SIZE = 4;

// wire [LETTER_WIDTH-1:0] letters[LETTER_HEIGHT-1:0][NUM_LETTERS-1:0];
wire [LETTER_WIDTH-1:0] letters;

// debugging
assign oLEDR[17:9] = sentences[0];
assign oLEDR[SCREEN_WIDTH_SIZE-1:0] = xCur;

// address is 12 bits
// pad sentences so that it's 8 bits, and then pad address so that it's 12 bits
cgen	characterGenerator(	.address(	{4'b0,(iY&8'h7)+
											{sentences[sX],3'b0}}),
								.clock(iCLK50),
								.data(0),
								.wren(0),
								.q(letters)	);

// Store 16 characters to write to the screen in sentences
// 0 = no letter
// 1 = A
// 2 = B
// etc..
reg [NUM_LETTERS_SIZE-1:0] sentences[SCREEN_WIDTH-1:0];

// position of text cursor
reg [SCREEN_WIDTH_SIZE-1:0] xCur;

// store keystrokes in sentences and increment position in which to store
always @(posedge next_key)
begin
	xCur <= xCur + 1;
	sentences[xCur] <= char;
end

// position of character in sentences
wire [SCREEN_WIDTH_SIZE-1:0] sX = iX[SCREEN_WIDTH_SIZE+2:3];

assign letter = (	(iX[8:3] > 10) &
			(iX[8:3] < 27) &
			(iY[7:3] == 15)  &
			(sentences[sX]/*[sY]*/ > 0) &
			(sentences[sX]/*[sY]*/<27)	) ?
			letters[LETTER_WIDTH-1-iX[2:0]] : 0;

endmodule
