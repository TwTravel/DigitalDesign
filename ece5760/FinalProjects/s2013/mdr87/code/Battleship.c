/*** ECE 5760 Final Project
 *** Battleship Game Code
 *** NIOS II Processor running on Altera DE2 FPGA Development Board
 *** By Joshua Schwartz and Michael Ross
 ***/


/*** Standard Includes ***/
#include <stdio.h>
#include <stdlib.h>

/*** Altera Includes ***/
#include "sys/alt_stdio.h"
#include "altera_avalon_pio_regs.h"

/*** System Include ***/
#include "system.h"


/*** IO Functions ***/
#define readIO(base) IORD_ALTERA_AVALON_PIO_DATA(base)
#define writeIO(base,data) IOWR_ALTERA_AVALON_PIO_DATA(base, data)
#define readEdge(base) IORD_ALTERA_AVALON_PIO_EDGE_CAP(base)
#define clearEdge(base) IOWR_ALTERA_AVALON_PIO_EDGE_CAP(base, 0xFF)


/*** Peripheral Addresses ***/
//#define LEDs		GREEN_LEDS_BASE
#define X_out		X_COORD_BASE		// x-coordinate for pixel to be drawn on screen
#define Y_out		Y_COORD_BASE		// y-coordinate for pixel to be drawn on screen
#define COLOR		COLOR_BASE			// Color coded HSI values
#define Wait		SRAM_ACCESS_BASE	// Wait until NIOS has SRAM access
#define Data_Ready	DATA_READY_BASE		// Tell hardware that valid data can be read from NIOS
#define Play_out	PLAYER_OUT_BASE		// Tell hardware which screen to write to (0=player1, 1=player2)
#define PlayIn1		PLAY_IN_1_BASE		// Player 1 User Input
#define PlayIn2		PLAY_IN_2_BASE		// Player 2 User Input

/* Input Button Layout
      _
     |U|
      -
    _   _    _
   |L| |R| |F/S|
    -   -    -
	  _      _
	 |D|    |Ro|
      -      -

F/S	= Fire/Select	Input Pin 0		Bit Mask 0x01
Ro	= Rotate		Input Pin 1		Bit Mask 0x02
D	= Down			Input Pin 2		Bit Mask 0x04
R	= Right			Input Pin 3		Bit Mask 0x08
U	= Up			Input Pin 4		Bit Mask 0x10	(16)
L	= Left			Input Pin 5		Bit Mask 0x20	(32)
*/

/*** Button Bit Masks ***/
#define BM0	0x01	// Fire/Select
#define BM1	0x02	// Rotate
#define BM2	0x04	// Down
#define BM3	0x08	// Right
#define BM4	0x10	// Up
#define BM5	0x20	// Left


/*** Color Definitions ***/
// Hue			0-360 degrees	0-14
// Saturation	0-1				0-127
// Intensity	0-255			0-255

/*   Color      Value     YIQ      HSI */
unsigned int BLACK	= 0;
//char BLACK_H 	= 0;	// 0		0
//char BLACK_S 	= 0;	// 0		0
//char BLACK_I 	= 0;	// 0		0

unsigned int WHITE	= 65024;
//char WHITE_H 	= 0;	// 1		0
//char WHITE_S 	= 0;	// 0		0
//char WHITE_I 	= 255;	// 0		255

unsigned int RED	= 22514;
//char RED_H 		= 2;	// .114		0
//char RED_S 		= 255;	//-.322		1
//char RED_I 		= 85;	// .311		85

unsigned int BLUE	= 22520;
//char BLUE_H 	= 8;	// .299		240
//char BLUE_S 	= 255;	// .596		1
//char BLUE_I 	= 85;	// .212		85

unsigned int GREEN	= 11261;
//char GREEN_H 	= 0xD;	// .295		120
//char GREEN_S 	= 255;	//-.138		1
//char GREEN_I 	= 43;	//-.263		43

unsigned int YELLOW	= 59376;
//char YELLOW_H	= 0;	//			60
//char YELLOW_S	= 255;	//			1
//char YELLOW_I	= 230;	//			170

unsigned int SILVER	= 32314;
//char SILVER_H	= 0xA;	//			0
//char SILVER_S	= 30;	//			0
//char SILVER_I	= 127;	//			192


/*** Function Prototypes ***/
void initialize(void);			// Initialize the variables in the system
void clearScreen(void);			// Clears the screen
void drawGrid(void);			// Draw 2 10x10 game grids: one for own field display, one for opponent field display
void enterShips(void);			// Enter coordinates for ships (4 destroyers (l=2), 3 cruisers (l=3), 2 battleships (l=4), 1 aircraft carrier (l=5)
	void enterShip2(void);		// Enter ship length 2
	void enterShip3(void);		// Enter ship length 3
	void enterShip4(void);		// Enter ship length 4
	void enterShip5(void);		// Enter ship length 5
void player1Strike(void);		// Player 1's turn to enter a new strike
void player2Strike(void);		// Player 2's turn to enter a new strike
void enterStrike1(void);		// Enter coordinates for missile strike (player 1)
void enterStrike2(void);		// Enter coordinates for missile strike (player 2)
unsigned int checkHit(void);	// Check to see if the current strike is a hit or a miss
void checkCell(unsigned int x, unsigned int y, unsigned int cur, unsigned int player);	// Draw a red cell (cell taken), yellow cell (current cell), or silver cell (trailing cell)
unsigned int checkTaken(unsigned int x, unsigned int y, unsigned int player);			// Check to see if cell in shot matrix is taken when entering strikes
unsigned int checkTaken3(unsigned int x, unsigned int y, unsigned int player);			// Check to see if any cell in ship length=3 is in a taken cell
unsigned int checkTaken4(unsigned int x, unsigned int y, unsigned int player);			// Check to see if any cell in ship length=4 is in a taken cell
unsigned int checkTaken5(unsigned int x, unsigned int y, unsigned int player);			// Check to see if any cell in ship length=5 is in a taken cell
void drawShips1(void);			// Draw player 1 ships
void drawShips2(void);			// Draw player 2 ships
void drawShots1(void);			// Draw misses and hits (player 1 ships) when player 2 is striking
void drawShots2(void);			// Draw misses and hits (player 2 ships) when player 1 is striking
unsigned int checkTaken(unsigned int x, unsigned int y, unsigned int player);	// Check to see if cell in shot matrix is taken when entering strikes
unsigned int gameOver(void);	// Check to see if game has ended (all of opponents battleships are destroyed
void displayWinLose(void);		// Display WIN and LOSE on appropriate screens based on who won game
void playAgain(void);	// Return 0 for no (enter appropriate done message, 1 for yes (reset game)


/*** Draw Functions ***/
void drawPixel(unsigned int x, unsigned int y, unsigned int colorVal, unsigned char player);
void drawCell(unsigned int cellX, unsigned int cellY, unsigned int type, unsigned char player);
void drawVLine(unsigned int x0, unsigned int y0, unsigned int length, unsigned int player);
void drawHLine(unsigned int x0, unsigned int y0, unsigned int length, unsigned int player);


/*** Battleship Parameters ***/
unsigned int L1[10][10];	// Player 1 location grid for own ships
unsigned int L2[10][10];	// Player 2 location grid for own ships
unsigned int S1[10][10];	// Player 1 shot grid for strikes against opponents and hits/misses
unsigned int S2[10][10];	// Player 2 shot grid for strikes against opponents and hits/misses
unsigned int read1;			// Read input for player 1 button presses
unsigned int read2;			// Read input for player 2 button presses
unsigned int curCellX1;		// Cursor for current cell x location for player 1
unsigned int curCellY1;		// Cursor for current cell y location for player 1
unsigned int curCellX2;		// Cursor for current cell x location for player 2
unsigned int curCellY2;		// Cursor for current cell y location for player 2
unsigned int orientation1;	// current orientation of ships for player 1 when entering ship locations (0=right, 1=down, 2=left, 3=up)
unsigned int orientation2;	// current orientation of ships for player 2 when entering ship locations (0=right, 1=down, 2=left, 3=up)
unsigned int hitCount1;		// count for number of hits for player 1 strikes (used to decide if player has won the game or not
unsigned int hitCount2;		// count for number of hits for player 2 strikes (used to decide if player has won the game or not
unsigned int turn;			// Determines which player is currently ready to enter a coordinate strike
unsigned int play;			// Initialize play to 1 to allow first game to execute -> update using playAgain() function


/*** Draw Grid Parameters for Both Grids ***/
#define VLINE1_START 35		// Grid 1 - Vertical Lines -> x-coordinates of vertical lines for grid 1
#define HLINE_START 40		// Grid 1 and 2 - Horizontal Lines
#define VLINE2_START 160	// Grid 2 - Vertical Lines

/*** Screen Resolution Parameters ***/
#define SCREEN_RES_X 315	// TV screen resolution in the x-direction
#define SCREEN_RES_Y 242	// TV screen resolution in the y-direction


int main()
{
	play = 1;		// allow system to enter gameplay loop for first time
	
	while(play)		// play initialized to 1 for initial gameplay, reset by playAgain() function
	{
		initialize();	// initialize the system variables
		clearScreen();	// clears the screen to all black
		drawGrid();		// draws the two grids on each of the two screens (one for each player)		
		enterShips();	// enter ship lengths of 2, 3 (2), 4, and 5
		
		// Enter gameplay here
		while(!gameOver())
		{
			if(!turn)
				player1Strike();
			else
				player2Strike();
				
			turn = !turn;
		}
		
		clearScreen();
		
		displayWinLose();
		
		playAgain();
	}
	
	return 0;
}


/*** Initialize all of the system variables ***/
void initialize(void)
{
	int i;
	int j;
	for(i=0; i<10; i++)
	{
		for(j=0; j<10; j++)
		{
			L1[i][j]=0;
			L2[i][j]=0;
			S1[i][j]=0;
			S2[i][j]=0;
		}
	}
	
	read1=0;
	read2=0;
	curCellX1=0;
	curCellY1=0;
	curCellX2=0;
	curCellY2=0;
	orientation1=0;
	orientation2=0;
	hitCount1=0;
	hitCount2=0;
	turn=0;
	play=1;
}


/*** Draw a black dot in every pixel on the screen to clear the screen ***/
void clearScreen(void)
{
	int i;
	int j;
	for(i=0;i<SCREEN_RES_Y;i++)
	{
		for(j=0;j<SCREEN_RES_X;j++)
		{
			drawPixel(j,i,BLUE,0);	// Player 1 screen -> black pixel
			drawPixel(j,i,BLUE,1);	// Player 2 screen -> black pixel
		}
	}
}


/*** Draw a 10x10 grid for each screen ***/
void drawGrid(void)
{
	int i;
	int j;
	for(i=0;i<11;i++)
	{
		for(j=0;j<200;j++)
		{
			// Player 1
			drawPixel(VLINE1_START+(i*20), HLINE_START+j, WHITE, 0);	// Vertical grid line 1
			drawPixel(VLINE1_START+(i*20)+1, HLINE_START+j, WHITE, 0);	// Vertical grid line 2
			drawPixel(VLINE1_START+j, HLINE_START+(i*20), WHITE, 0);	// Horizontal grid line 1
			drawPixel(VLINE1_START+j, HLINE_START+(i*20)+1, WHITE, 0);	// Horizontal grid line 2
			
			// Player 2
			drawPixel(VLINE1_START+(i*20), HLINE_START+j, WHITE, 1);	// Vertical grid line 1
			drawPixel(VLINE1_START+(i*20)+1, HLINE_START+j, WHITE, 1);	// Vertical grid line 2
			drawPixel(VLINE1_START+j, HLINE_START+(i*20), WHITE, 1);	// Horizontal grid line 1
			drawPixel(VLINE1_START+j, HLINE_START+(i*20)+1, WHITE, 1);	// Horizontal grid line 2
		}
	}
}


/*** Enter ship locations for both player 1 and 2 ***/
void enterShips(void)
{
	/* Enter Destroyer (length = 2) */
	enterShip2();
	
	/* Enter Submarine (lenght = 3) */
	enterShip3();
	
	/* Enter Cruiser (length = 3) */
	enterShip3();
	
	/* Enter Battleship (length = 4) */
	enterShip4();
	
	/* Enter Aircraft Carrier (length = 5) */
	enterShip5();
}


/*** Enter Destroyer (length = 2) ***/
void enterShip2(void)
{
	/* Enter initial cell locations */
	drawCell(curCellX1,curCellY1,1,0);		// player 1 current cell
	drawCell(curCellX1+1,curCellY1,2,0);	// player 1 cell 2
	drawCell(curCellX2,curCellY2,1,1);		// player 2 current cell
	drawCell(curCellX2+1,curCellY2,2,1);	// player 2 cell 2
	
	while(read1 != 1 && read2 !=1)	// while neither player has pressed select
	{
		read1 = readEdge(PlayIn1);
		clearEdge(PlayIn1);
		read2 = readEdge(PlayIn2);
		clearEdge(PlayIn2);
		
		/* Rotate Player 1 */
		if(read1 == 2)		// Rotate 1
		{
			/* Rotate */
			if(orientation1==0)			// right
			{
				if(curCellY1<9)			// cannot rotate from right to down if current cell is in bottom row
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1+1,curCellY1,0,0);
					
					// draw new cells
					drawCell(curCellX1,curCellY1,1,0);
					drawCell(curCellX1,curCellY1+1,2,0);
				}
			}
			else if(orientation1==1)		// down
			{
				if(curCellX1>0)		// cannot rotate from down to left if current cell is in first column
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1,curCellY1+1,0,0);
					
					// draw new cells
					drawCell(curCellX1,curCellY1,1,0);
					drawCell(curCellX1-1,curCellY1,2,0);
				}
			}
			else if(orientation1==2)		// left
			{
				if(curCellY1>0)
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1-1,curCellY1,0,0);
					
					// draw new cells
					drawCell(curCellX1,curCellY1,1,0);
					drawCell(curCellX1,curCellY1-1,2,0);
				}
			}
			else						// up
			{
				if(curCellX1<9)
				{
					// update orientation
					orientation1=0;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1,curCellY1-1,0,0);
					
					// draw new cells
					drawCell(curCellX1,curCellY1,1,0);
					drawCell(curCellX1+1,curCellY1,2,0);
				}
			}
		}
		
		/* Rotate Player 2 */
		if(read2 == 2)		// Rotate 2
		{
			/* Rotate */
			if(orientation2==0)			// right
			{
				if(curCellY2<9)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2+1,curCellY2,0,1);
					
					// draw new cells
					drawCell(curCellX2,curCellY2,1,1);
					drawCell(curCellX2,curCellY2+1,2,1);
				}
			}
			else if(orientation2==1)		// down
			{
				if(curCellX2>0)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2,curCellY2+1,0,1);
					
					// draw new cells
					drawCell(curCellX2,curCellY2,1,1);
					drawCell(curCellX2-1,curCellY2,2,1);
				}
			}
			else if(orientation2==2)		// left
			{
				if(curCellY2>0)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2-1,curCellY2,0,1);
					
					// draw new cells
					drawCell(curCellX2,curCellY2,1,1);
					drawCell(curCellX2,curCellY2-1,2,1);
				}
			}
			else						// up
			{
				if(curCellX2<9)
				{
					// update orientation
					orientation2=0;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2,curCellY2-1,0,1);
					
					// draw new cells
					drawCell(curCellX2,curCellY2,1,1);
					drawCell(curCellX2+1,curCellY2,2,1);
				}
			}
		}
		
		/* Player 1 Down */
		if(read1 == 4)		// Down 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,0,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,0,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,0,0);
			else
				drawCell(curCellX1,curCellY1-1,0,0);
			
			/* Move cursor down */
			curCellY1+=1;
			if(curCellY1>8 && orientation1==1)	curCellY1-=1;
			else if(curCellY1>9)	curCellY1-=1;
			
			/* Draw current cell */
			drawCell(curCellX1,curCellY1,1,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,2,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,2,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,2,0);
			else
				drawCell(curCellX1,curCellY1-1,2,0);
				
		}
		
		/* Player 2 Down */
		if(read2 == 4)		// Down 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,0,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,0,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,0,1);
			else
				drawCell(curCellX2,curCellY2-1,0,1);
			
			/* Move cursor down */
			curCellY2+=1;
			if(curCellY2>8 && orientation2==1)	curCellY2-=1;
			else if(curCellY2>9)	curCellY2-=1;
			
			/* Draw current cell */
			drawCell(curCellX2,curCellY2,1,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,2,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,2,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,2,1);
			else
				drawCell(curCellX2,curCellY2-1,2,1);
		}
		
		/* Player 1 Right */
		if(read1 == 8)		// Right 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,0,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,0,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,0,0);
			else
				drawCell(curCellX1,curCellY1-1,0,0);
			
			/* Move cursor right */
			curCellX1+=1;
			if(curCellX1>8 && orientation1==0)	curCellX1-=1;
			else if(curCellX1>9)	curCellX1-=1;
			
			/* Draw current cell */
			drawCell(curCellX1,curCellY1,1,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,2,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,2,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,2,0);
			else
				drawCell(curCellX1,curCellY1-1,2,0);
		}
		
		/* Player 2 Right */
		if(read2 == 8)		// Right 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,0,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,0,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,0,1);
			else
				drawCell(curCellX2,curCellY2-1,0,1);
			
			/* Move cursor right */
			curCellX2+=1;
			if(curCellX2>8 && orientation2==0)	curCellX2-=1;
			else if(curCellX2>9)	curCellX2-=1;
			
			/* Draw current cell */
			drawCell(curCellX2,curCellY2,1,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,2,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,2,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,2,1);
			else
				drawCell(curCellX2,curCellY2-1,2,1);
		}
		
		/* Player 1 Up */
		if(read1 == 16)		// Up 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,0,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,0,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,0,0);
			else
				drawCell(curCellX1,curCellY1-1,0,0);
			
			/* Move cursor up */
			curCellY1-=1;
			if(curCellY1<1 && orientation1==3)	curCellY1+=1;
			else if(curCellY1>10)	curCellY1=0;
			
			/* Draw current cell */
			drawCell(curCellX1,curCellY1,1,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,2,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,2,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,2,0);
			else
				drawCell(curCellX1,curCellY1-1,2,0);
		}
		
		/* Player 2 Up */
		if(read2 == 16)		// Up 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,0,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,0,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,0,1);
			else
				drawCell(curCellX2,curCellY2-1,0,1);
			
			/* Move cursor up */
			curCellY2-=1;
			if(curCellY2<1 && orientation2==3)	curCellY2+=1;
			else if(curCellY2>10)	curCellY2=0;
			
			/* Draw current cell */
			drawCell(curCellX2,curCellY2,1,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,2,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,2,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,2,1);
			else
				drawCell(curCellX2,curCellY2-1,2,1);
		}
		
		/* Player 1 Left */
		if(read1 == 32)		// Left 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,0,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,0,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,0,0);
			else
				drawCell(curCellX1,curCellY1-1,0,0);
			
			/* Move cursor left */
			curCellX1-=1;
			if(curCellX1<1 && orientation1==2)	curCellX1+=1;
			else if(curCellX1>10)	curCellX1=0;
			
			/* Draw current cell */
			drawCell(curCellX1,curCellY1,1,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,2,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,2,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,2,0);
			else
				drawCell(curCellX1,curCellY1-1,2,0);
		}
		
		/* Player 2 Left */
		if(read2 == 32)		// Left 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,0,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,0,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,0,1);
			else
				drawCell(curCellX2,curCellY2-1,0,1);
			
			/* Move cursor left */
			curCellX2-=1;
			if(curCellX2<1 && orientation2==2)	curCellX2+=1;
			else if(curCellX2>10)	curCellX2=0;
			
			/* Draw current cell */
			drawCell(curCellX2,curCellY2,1,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,2,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,2,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,2,1);
			else
				drawCell(curCellX2,curCellY2-1,2,1);
		}
	}	
		
		/* Enter selected ship location into player location matrix */
		if(read1 == 1)	// if player 1 pressed select then allow player 1 to finish entering ship length=2
		{
			/* Clear current cells */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,0,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,0,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,0,0);
			else
				drawCell(curCellX1,curCellY1-1,0,0);
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX1,curCellY1,5,0);
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,5,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,5,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,5,0);
			else
				drawCell(curCellX1,curCellY1-1,5,0);
			
			/* Enter ship cell locations into location matrix */
			L1[curCellX1][curCellY1]=1;
			if(orientation1==0)
				L1[curCellX1+1][curCellY1]=1;
			else if(orientation1==1)
				L1[curCellX1][curCellY1+1]=1;
			else if(orientation1==2)
				L1[curCellX1-1][curCellY1]=1;
			else
				L1[curCellX1][curCellY1-1]=1;
			
			
			while(read2 != 1)		// while player 2 does not press select
			{
				read2 = readEdge(PlayIn2);
				clearEdge(PlayIn2);
				/* Rotate Player 2 */
				if(read2 == 2)		// Rotate 2
				{
					/* Rotate */
					if(orientation2==0)			// right
					{
						if(curCellY2<9)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2+1,curCellY2,0,1);
							
							// draw new cells
							drawCell(curCellX2,curCellY2,1,1);
							drawCell(curCellX2,curCellY2+1,2,1);
						}
					}
					else if(orientation2==1)		// down
					{
						if(curCellX2>0)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2,curCellY2+1,0,1);
							
							// draw new cells
							drawCell(curCellX2,curCellY2,1,1);
							drawCell(curCellX2-1,curCellY2,2,1);
						}
					}
					else if(orientation2==2)		// left
					{
						if(curCellY2>0)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2-1,curCellY2,0,1);
							
							// draw new cells
							drawCell(curCellX2,curCellY2,1,1);
							drawCell(curCellX2,curCellY2-1,2,1);
						}
					}
					else						// up
					{
						if(curCellX2<9)
						{
							// update orientation
							orientation2=0;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2,curCellY2-1,0,1);
							
							// draw new cells
							drawCell(curCellX2,curCellY2,1,1);
							drawCell(curCellX2+1,curCellY2,2,1);
						}
					}
				}
				
				/* Player 2 Down */
				if(read2 == 4)		// Down 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
						drawCell(curCellX2+1,curCellY2,0,1);
					else if(orientation2==1)
						drawCell(curCellX2,curCellY2+1,0,1);
					else if(orientation2==2)
						drawCell(curCellX2-1,curCellY2,0,1);
					else
						drawCell(curCellX2,curCellY2-1,0,1);
					
					/* Move cursor down */
					curCellY2+=1;
					if(curCellY2>8 && orientation2==1)	curCellY2-=1;
					else if(curCellY2>9)	curCellY2-=1;
					
					/* Draw current cell */
					drawCell(curCellX2,curCellY2,1,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
						drawCell(curCellX2+1,curCellY2,2,1);
					else if(orientation2==1)
						drawCell(curCellX2,curCellY2+1,2,1);
					else if(orientation2==2)
						drawCell(curCellX2-1,curCellY2,2,1);
					else
						drawCell(curCellX2,curCellY2-1,2,1);
				}
				
				/* Player 2 Right */
				if(read2 == 8)		// Right 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
						drawCell(curCellX2+1,curCellY2,0,1);
					else if(orientation2==1)
						drawCell(curCellX2,curCellY2+1,0,1);
					else if(orientation2==2)
						drawCell(curCellX2-1,curCellY2,0,1);
					else
						drawCell(curCellX2,curCellY2-1,0,1);
					
					/* Move cursor right */
					curCellX2+=1;
					if(curCellX2>8 && orientation2==0)	curCellX2-=1;
					else if(curCellX2>9)	curCellX2-=1;
					
					/* Draw current cell */
					drawCell(curCellX2,curCellY2,1,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
						drawCell(curCellX2+1,curCellY2,2,1);
					else if(orientation2==1)
						drawCell(curCellX2,curCellY2+1,2,1);
					else if(orientation2==2)
						drawCell(curCellX2-1,curCellY2,2,1);
					else
						drawCell(curCellX2,curCellY2-1,2,1);
				}
				
				/* Player 2 Up */
				if(read2 == 16)		// Up 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
						drawCell(curCellX2+1,curCellY2,0,1);
					else if(orientation2==1)
						drawCell(curCellX2,curCellY2+1,0,1);
					else if(orientation2==2)
						drawCell(curCellX2-1,curCellY2,0,1);
					else
						drawCell(curCellX2,curCellY2-1,0,1);
					
					/* Move cursor up */
					curCellY2-=1;
					if(curCellY2<1 && orientation2==3)	curCellY2+=1;
					else if(curCellY2>10)	curCellY2=0;
					
					/* Draw current cell */
					drawCell(curCellX2,curCellY2,1,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
						drawCell(curCellX2+1,curCellY2,2,1);
					else if(orientation2==1)
						drawCell(curCellX2,curCellY2+1,2,1);
					else if(orientation2==2)
						drawCell(curCellX2-1,curCellY2,2,1);
					else
						drawCell(curCellX2,curCellY2-1,2,1);
				}
				
				/* Player 2 Left */
				if(read2 == 32)		// Left 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
						drawCell(curCellX2+1,curCellY2,0,1);
					else if(orientation2==1)
						drawCell(curCellX2,curCellY2+1,0,1);
					else if(orientation2==2)
						drawCell(curCellX2-1,curCellY2,0,1);
					else
						drawCell(curCellX2,curCellY2-1,0,1);
					
					/* Move cursor left */
					curCellX2-=1;
					if(curCellX2<1 && orientation2==2)	curCellX2+=1;
					else if(curCellX2>10)	curCellX2=0;
					
					/* Draw current cell */
					drawCell(curCellX2,curCellY2,1,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
						drawCell(curCellX2+1,curCellY2,2,1);
					else if(orientation2==1)
						drawCell(curCellX2,curCellY2+1,2,1);
					else if(orientation2==2)
						drawCell(curCellX2-1,curCellY2,2,1);
					else
						drawCell(curCellX2,curCellY2-1,2,1);
				}
			}
			
			/* Clear current cells */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,0,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,0,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,0,1);
			else
				drawCell(curCellX2,curCellY2-1,0,1);
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX2,curCellY2,5,1);
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,5,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,5,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,5,1);
			else
				drawCell(curCellX2,curCellY2-1,5,1);
			
			/* Enter ship cell locations into location matrix */
			L2[curCellX2][curCellY2] = 1;
			if(orientation2==0)
				L2[curCellX2+1][curCellY2]=1;
			else if(orientation2==1)
				L2[curCellX2][curCellY2+1]=1;
			else if(orientation2==2)
				L2[curCellX2-1][curCellY2]=1;
			else
				L2[curCellX2][curCellY2-1]=1;
		}
		
		else						// if player 2 pressed select then allow player 1 to finish entering ship length=2
		{
			/* Clear current cells */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,0,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,0,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,0,1);
			else
				drawCell(curCellX2,curCellY2-1,0,1);
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX2,curCellY2,5,1);
			if(orientation2==0)
				drawCell(curCellX2+1,curCellY2,5,1);
			else if(orientation2==1)
				drawCell(curCellX2,curCellY2+1,5,1);
			else if(orientation2==2)
				drawCell(curCellX2-1,curCellY2,5,1);
			else
				drawCell(curCellX2,curCellY2-1,5,1);
			
			/* Enter ship cell locations into location matrix */
			L2[curCellX2][curCellY2] = 1;
			if(orientation2==0)
				L2[curCellX2+1][curCellY2]=1;
			else if(orientation2==1)
				L2[curCellX2][curCellY2+1]=1;
			else if(orientation2==2)
				L2[curCellX2-1][curCellY2]=1;
			else
				L2[curCellX2][curCellY2-1]=1;
				
			while(read1 != 1)
			{
				read1 = readEdge(PlayIn1);
				clearEdge(PlayIn1);
				/* Rotate Player 1 */
				if(read1 == 2)		// Rotate 1
				{
					/* Rotate */
					if(orientation1==0)			// right
					{
						if(curCellY1<9)			// cannot rotate from right to down if current cell is in bottom row
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1+1,curCellY1,0,0);
							
							// draw new cells
							drawCell(curCellX1,curCellY1,1,0);
							drawCell(curCellX1,curCellY1+1,2,0);
						}
					}
					else if(orientation1==1)		// down
					{
						if(curCellX1>0)		// cannot rotate from down to left if current cell is in first column
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1,curCellY1+1,0,0);
							
							// draw new cells
							drawCell(curCellX1,curCellY1,1,0);
							drawCell(curCellX1-1,curCellY1,2,0);
						}
					}
					else if(orientation1==2)		// left
					{
						if(curCellY1>0)
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1-1,curCellY1,0,0);
							
							// draw new cells
							drawCell(curCellX1,curCellY1,1,0);
							drawCell(curCellX1,curCellY1-1,2,0);
						}
					}
					else						// up
					{
						if(curCellX1<9)
						{
							// update orientation
							orientation1=0;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1,curCellY1-1,0,0);
							
							// draw new cells
							drawCell(curCellX1,curCellY1,1,0);
							drawCell(curCellX1+1,curCellY1,2,0);
						}
					}
				}
				
				/* Player 1 Down */
				if(read1 == 4)		// Down 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
						drawCell(curCellX1+1,curCellY1,0,0);
					else if(orientation1==1)
						drawCell(curCellX1,curCellY1+1,0,0);
					else if(orientation1==2)
						drawCell(curCellX1-1,curCellY1,0,0);
					else
						drawCell(curCellX1,curCellY1-1,0,0);
					
					/* Move cursor down */
					curCellY1+=1;
					if(curCellY1>8 && orientation1==1)	curCellY1-=1;
					else if(curCellY1>9)	curCellY1-=1;
					
					/* Draw current cell */
					drawCell(curCellX1,curCellY1,1,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
						drawCell(curCellX1+1,curCellY1,2,0);
					else if(orientation1==1)
						drawCell(curCellX1,curCellY1+1,2,0);
					else if(orientation1==2)
						drawCell(curCellX1-1,curCellY1,2,0);
					else
						drawCell(curCellX1,curCellY1-1,2,0);
				}
				
				/* Player 1 Right */
				if(read1 == 8)		// Right 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
						drawCell(curCellX1+1,curCellY1,0,0);
					else if(orientation1==1)
						drawCell(curCellX1,curCellY1+1,0,0);
					else if(orientation1==2)
						drawCell(curCellX1-1,curCellY1,0,0);
					else
						drawCell(curCellX1,curCellY1-1,0,0);
					
					/* Move cursor right */
					curCellX1+=1;
					if(curCellX1>8 && orientation1==0)	curCellX1-=1;
					else if(curCellX1>9)	curCellX1-=1;
					
					/* Draw current cell */
					drawCell(curCellX1,curCellY1,1,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
						drawCell(curCellX1+1,curCellY1,2,0);
					else if(orientation1==1)
						drawCell(curCellX1,curCellY1+1,2,0);
					else if(orientation1==2)
						drawCell(curCellX1-1,curCellY1,2,0);
					else
						drawCell(curCellX1,curCellY1-1,2,0);
				}
				
				/* Player 1 Up */
				if(read1 == 16)		// Up 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
						drawCell(curCellX1+1,curCellY1,0,0);
					else if(orientation1==1)
						drawCell(curCellX1,curCellY1+1,0,0);
					else if(orientation1==2)
						drawCell(curCellX1-1,curCellY1,0,0);
					else
						drawCell(curCellX1,curCellY1-1,0,0);
					
					/* Move cursor up */
					curCellY1-=1;
					if(curCellY1<1 && orientation1==3)	curCellY1+=1;
					else if(curCellY1>10)	curCellY1=0;
					
					/* Draw current cell */
					drawCell(curCellX1,curCellY1,1,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
						drawCell(curCellX1+1,curCellY1,2,0);
					else if(orientation1==1)
						drawCell(curCellX1,curCellY1+1,2,0);
					else if(orientation1==2)
						drawCell(curCellX1-1,curCellY1,2,0);
					else
						drawCell(curCellX1,curCellY1-1,2,0);
				}
				
				/* Player 1 Left */
				if(read1 == 32)		// Left 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
						drawCell(curCellX1+1,curCellY1,0,0);
					else if(orientation1==1)
						drawCell(curCellX1,curCellY1+1,0,0);
					else if(orientation1==2)
						drawCell(curCellX1-1,curCellY1,0,0);
					else
						drawCell(curCellX1,curCellY1-1,0,0);
					
					/* Move cursor left */
					curCellX1-=1;
					if(curCellX1<1 && orientation1==2)	curCellX1+=1;
					else if(curCellX1>10)	curCellX1=0;
					
					/* Draw current cell */
					drawCell(curCellX1,curCellY1,1,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
						drawCell(curCellX1+1,curCellY1,2,0);
					else if(orientation1==1)
						drawCell(curCellX1,curCellY1+1,2,0);
					else if(orientation1==2)
						drawCell(curCellX1-1,curCellY1,2,0);
					else
						drawCell(curCellX1,curCellY1-1,2,0);
				}
			}
			
			/* Clear current cells */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,0,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,0,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,0,0);
			else
				drawCell(curCellX1,curCellY1-1,0,0);
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX1,curCellY1,5,0);
			if(orientation1==0)
				drawCell(curCellX1+1,curCellY1,5,0);
			else if(orientation1==1)
				drawCell(curCellX1,curCellY1+1,5,0);
			else if(orientation1==2)
				drawCell(curCellX1-1,curCellY1,5,0);
			else
				drawCell(curCellX1,curCellY1-1,5,0);
			
			/* Enter ship cell locations into location matrix */
			L1[curCellX1][curCellY1]=1;
			if(orientation1==0)
				L1[curCellX1+1][curCellY1]=1;
			else if(orientation1==1)
				L1[curCellX1][curCellY1+1]=1;
			else if(orientation1==2)
				L1[curCellX1-1][curCellY1]=1;
			else
				L1[curCellX1][curCellY1-1]=1;
		}
}


/*** Enter Submarine/Cruiser (length = 3) ***/
void enterShip3(void)
{
	// Enter initial orientation, read input, and cell locations
	curCellX1=0;							// set player 1 x-coordinate to 0
	curCellY1=0;							// set player 1 y-coordinate to 0
	curCellX2=0;							// set player 2 x-coordinate to 0
	curCellY2=0;							// set player 2 y-coordinate to 0
	orientation1=0;							// set player 1 orientation to 0 (right)
	orientation2=0;							// set player 2 orientation to 0 (right)
	read1=0;								// set player 1 input to nothing read
	read2=0;								// set player 2 input to nothing read
	checkCell(curCellX1,curCellY1,0,0);		// draw player 1 current cell
	checkCell(curCellX1+1,curCellY1,1,0);	// draw player 1 cell 2
	checkCell(curCellX1+2,curCellY1,1,0);	// draw player 1 cell 3
	checkCell(curCellX2,curCellY2,0,1);		// draw player 2 current cell
	checkCell(curCellX2+1,curCellY2,1,1);	// draw player 2 cell 2
	checkCell(curCellX2+2,curCellY2,1,1);	// draw player 2 cell 3
	
	while((read1!=1 || checkTaken3(curCellX1,curCellY1,0)) && (read2!=1 || checkTaken3(curCellX2,curCellY2,1)))	// while neither player has pressed select and player who pressed select has taken cells
	{
		read1 = readEdge(PlayIn1);
		clearEdge(PlayIn1);
		read2 = readEdge(PlayIn2);
		clearEdge(PlayIn2);
		
		/* Rotate Player 1 */
		if(read1 == 2)		// Rotate 1
		{
			/* Rotate */
			if(orientation1==0)			// right
			{
				if(curCellY1<8)			// cannot rotate from right to down if current cell is in bottom two rows
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1+1,curCellY1,0,0);
					drawCell(curCellX1+2,curCellY1,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1,curCellY1+1,1,0);
					checkCell(curCellX1,curCellY1+2,1,0);
				}
			}
			else if(orientation1==1)		// down
			{
				if(curCellX1>1)		// cannot rotate from down to left if current cell is in first column
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1,curCellY1+1,0,0);
					drawCell(curCellX1,curCellY1+2,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1-1,curCellY1,1,0);
					checkCell(curCellX1-2,curCellY1,1,0);
				}
			}
			else if(orientation1==2)		// left
			{
				if(curCellY1>1)
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1-1,curCellY1,0,0);
					drawCell(curCellX1-2,curCellY1,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1,curCellY1-1,1,0);
					checkCell(curCellX1,curCellY1-2,1,0);
				}
			}
			else						// up
			{
				if(curCellX1<8)
				{
					// update orientation
					orientation1=0;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1,curCellY1-1,0,0);
					drawCell(curCellX1,curCellY1-2,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1+1,curCellY1,1,0);
					checkCell(curCellX1+2,curCellY1,1,0);
				}
			}
		}
		
		/* Rotate Player 2 */
		if(read2 == 2)		// Rotate 2
		{
			/* Rotate */
			if(orientation2==0)			// right
			{
				if(curCellY2<8)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2+1,curCellY2,0,1);
					drawCell(curCellX2+2,curCellY2,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2,curCellY2+1,1,1);
					checkCell(curCellX2,curCellY2+2,1,1);
				}
			}
			else if(orientation2==1)		// down
			{
				if(curCellX2>1)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2,curCellY2+1,0,1);
					drawCell(curCellX2,curCellY2+2,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2-1,curCellY2,1,1);
					checkCell(curCellX2-2,curCellY2,1,1);
				}
			}
			else if(orientation2==2)		// left
			{
				if(curCellY2>1)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2-1,curCellY2,0,1);
					drawCell(curCellX2-2,curCellY2,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2,curCellY2-1,1,1);
					checkCell(curCellX2,curCellY2-2,1,1);
				}
			}
			else						// up
			{
				if(curCellX2<8)
				{
					// update orientation
					orientation2=0;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2,curCellY2-1,0,1);
					drawCell(curCellX2,curCellY2-2,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2+1,curCellY2,1,1);
					checkCell(curCellX2+2,curCellY2,1,1);
				}
			}
		}
		
		/* Player 1 Down */
		if(read1 == 4)		// Down 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
			}
			
			/* Move cursor down */
			curCellY1+=1;
			if(curCellY1>7 && orientation1==1)	curCellY1-=1;
			else if(curCellY1>9)	curCellY1-=1;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
			}
		}
		
		/* Player 2 Down */
		if(read2 == 4)		// Down 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
			}
			
			/* Move cursor down */
			curCellY2+=1;
			if(curCellY2>7 && orientation2==1)	curCellY2-=1;
			else if(curCellY2>9)	curCellY2-=1;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
			}
		}
		
		/* Player 1 Right */
		if(read1 == 8)		// Right 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
			}
			
			/* Move cursor right */
			curCellX1+=1;
			if(curCellX1>7 && orientation1==0)	curCellX1-=1;
			else if(curCellX1>9)	curCellX1-=1;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
			}
		}
		
		/* Player 2 Right */
		if(read2 == 8)		// Right 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
			}
			
			/* Move cursor right */
			curCellX2+=1;
			if(curCellX2>7 && orientation2==0)	curCellX2-=1;
			else if(curCellX2>9)	curCellX2-=1;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
			}
		}
		
		/* Player 1 Up */
		if(read1 == 16)		// Up 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
			}
			
			/* Move cursor up */
			curCellY1-=1;
			if(curCellY1<2 && orientation1==3)	curCellY1+=1;
			else if(curCellY1>10)	curCellY1=0;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
			}
		}
		
		/* Player 2 Up */
		if(read2 == 16)		// Up 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
			}
			
			/* Move cursor up */
			curCellY2-=1;
			if(curCellY2<2 && orientation2==3)	curCellY2+=1;
			else if(curCellY2>10)	curCellY2=0;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
			}
		}
		
		/* Player 1 Left */
		if(read1 == 32)		// Left 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
			}
			
			/* Move cursor left */
			curCellX1-=1;
			if(curCellX1<2 && orientation1==2)	curCellX1+=1;
			else if(curCellX1>10)	curCellX1=0;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
			}
		}
		
		/* Player 2 Left */
		if(read2 == 32)		// Left 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
			}
			
			/* Move cursor left */
			curCellX2-=1;
			if(curCellX2<2 && orientation2==2)	curCellX2+=1;
			else if(curCellX2>10)	curCellX2=0;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
			}
		}
	}	
		
		
		// Redraw Ships
		drawShips1();
		drawShips2();
		
		
		/* Enter selected ship location into player location matrix */
		if(read1 == 1)	// if player 1 pressed select then allow player 1 to finish entering ship length=2
		{
			/* Clear current cells */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX1,curCellY1,5,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,5,0);
				drawCell(curCellX1+2,curCellY1,5,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,5,0);
				drawCell(curCellX1,curCellY1+2,5,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,5,0);
				drawCell(curCellX1-2,curCellY1,5,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,5,0);
				drawCell(curCellX1,curCellY1-2,5,0);
			}
			
			/* Enter ship cell locations into location matrix */
			L1[curCellX1][curCellY1]=1;
			if(orientation1==0)
			{
				L1[curCellX1+1][curCellY1]=1;
				L1[curCellX1+2][curCellY1]=1;
			}
			else if(orientation1==1)
			{
				L1[curCellX1][curCellY1+1]=1;
				L1[curCellX1][curCellY1+2]=1;
			}
			else if(orientation1==2)
			{
				L1[curCellX1-1][curCellY1]=1;
				L1[curCellX1-2][curCellY1]=1;
			}
			else
			{
				L1[curCellX1][curCellY1-1]=1;
				L1[curCellX1][curCellY1-2]=1;
			}
			
			
			while((read2 != 1) || checkTaken3(curCellX2,curCellY2,1))		// while player 2 does not press select and is on taken cells
			{
				read2 = readEdge(PlayIn2);
				clearEdge(PlayIn2);
				
				/* Rotate Player 2 */
				if(read2 == 2)		// Rotate 2
				{
					/* Rotate */
					if(orientation2==0)			// right
					{
						if(curCellY2<8)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2+1,curCellY2,0,1);
							drawCell(curCellX2+2,curCellY2,0,1);
							
							
							// Redraw Ships
							drawShips2();
			
							
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2,curCellY2+1,1,1);
							checkCell(curCellX2,curCellY2+2,1,1);
						}
					}
					else if(orientation2==1)		// down
					{
						if(curCellX2>1)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2,curCellY2+1,0,1);
							drawCell(curCellX2,curCellY2+2,0,1);
							
							
							// Redraw Ships
							drawShips2();
							
							
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2-1,curCellY2,1,1);
							checkCell(curCellX2-2,curCellY2,1,1);
						}
					}
					else if(orientation2==2)		// left
					{
						if(curCellY2>1)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2-1,curCellY2,0,1);
							drawCell(curCellX2-2,curCellY2,0,1);
							
			
							// Redraw Ships
							drawShips2();
			
			
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2,curCellY2-1,1,1);
							checkCell(curCellX2,curCellY2-2,1,1);
						}
					}
					else						// up
					{
						if(curCellX2<8)
						{
							// update orientation
							orientation2=0;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2,curCellY2-1,0,1);
							drawCell(curCellX2,curCellY2-2,0,1);
							
			
							// Redraw Ships
							drawShips2();
			
			
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2+1,curCellY2,1,1);
							checkCell(curCellX2+2,curCellY2,1,1);
						}
					}
				}
				
				/* Player 2 Down */
				if(read2 == 4)		// Down 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
					}
					
					/* Move cursor down */
					curCellY2+=1;
					if(curCellY2>7 && orientation2==1)	curCellY2-=1;
					else if(curCellY2>9)	curCellY2-=1;
					
			
					// Redraw Ships
					drawShips2();
			
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
					}
				}
				
				/* Player 2 Right */
				if(read2 == 8)		// Right 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
					}
					
					/* Move cursor right */
					curCellX2+=1;
					if(curCellX2>7 && orientation2==0)	curCellX2-=1;
					else if(curCellX2>9)	curCellX2-=1;
					
			
					// Redraw Ships
					drawShips2();
			
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
					}
				}
				
				/* Player 2 Up */
				if(read2 == 16)		// Up 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
					}
					
					/* Move cursor up */
					curCellY2-=1;
					if(curCellY2<2 && orientation2==3)	curCellY2+=1;
					else if(curCellY2>10)	curCellY2=0;
					
			
					// Redraw Ships
					drawShips2();
			
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
					}
				}
				
				/* Player 2 Left */
				if(read2 == 32)		// Left 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
					}
					
					/* Move cursor left */
					curCellX2-=1;
					if(curCellX2<2 && orientation2==2)	curCellX2+=1;
					else if(curCellX2>10)	curCellX2=0;
					
			
					// Redraw Ships
					drawShips2();
			
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
					}
				}
			}
			
			/* Clear current cells */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX2,curCellY2,5,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,5,1);
				drawCell(curCellX2+2,curCellY2,5,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,5,1);
				drawCell(curCellX2,curCellY2+2,5,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,5,1);
				drawCell(curCellX2-2,curCellY2,5,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,5,1);
				drawCell(curCellX2,curCellY2-2,5,1);
			}
			
			/* Enter ship cell locations into location matrix */
			L2[curCellX2][curCellY2] = 1;
			if(orientation2==0)
			{
				L2[curCellX2+1][curCellY2]=1;
				L2[curCellX2+2][curCellY2]=1;
			}
			else if(orientation2==1)
			{
				L2[curCellX2][curCellY2+1]=1;
				L2[curCellX2][curCellY2+2]=1;
			}
			else if(orientation2==2)
			{
				L2[curCellX2-1][curCellY2]=1;
				L2[curCellX2-2][curCellY2]=1;
			}
			else
			{
				L2[curCellX2][curCellY2-1]=1;
				L2[curCellX2][curCellY2-2]=1;
			}
		}
		
		else						// if player 2 pressed select then allow player 1 to finish entering ship length=2
		{
			/* Clear current cells */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX2,curCellY2,5,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,5,1);
				drawCell(curCellX2+2,curCellY2,5,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,5,1);
				drawCell(curCellX2,curCellY2+2,5,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,5,1);
				drawCell(curCellX2-2,curCellY2,5,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,5,1);
				drawCell(curCellX2,curCellY2-2,5,1);
			}
			
			/* Enter ship cell locations into location matrix */
			L2[curCellX2][curCellY2] = 1;
			if(orientation2==0)
			{
				L2[curCellX2+1][curCellY2]=1;
				L2[curCellX2+2][curCellY2]=1;
			}
			else if(orientation2==1)
			{
				L2[curCellX2][curCellY2+1]=1;
				L2[curCellX2][curCellY2+2]=1;
			}
			else if(orientation2==2)
			{
				L2[curCellX2-1][curCellY2]=1;
				L2[curCellX2-2][curCellY2]=1;
			}
			else
			{
				L2[curCellX2][curCellY2-1]=1;
				L2[curCellX2][curCellY2-2]=1;
			}
				
			while(read1 != 1 || checkTaken3(curCellX1,curCellY1,0))
			{
				read1 = readEdge(PlayIn1);
				clearEdge(PlayIn1);
				
				/* Rotate Player 1 */
				if(read1 == 2)		// Rotate 1
				{
					/* Rotate */
					if(orientation1==0)			// right
					{
						if(curCellY1<8)			// cannot rotate from right to down if current cell is in bottom two rows
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1+1,curCellY1,0,0);
							drawCell(curCellX1+2,curCellY1,0,0);
							
			
							// Redraw Ships
							drawShips1();
			
					
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1,curCellY1+1,1,0);
							checkCell(curCellX1,curCellY1+2,1,0);
						}
					}
					else if(orientation1==1)		// down
					{
						if(curCellX1>1)		// cannot rotate from down to left if current cell is in first column
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1,curCellY1+1,0,0);
							drawCell(curCellX1,curCellY1+2,0,0);
							
			
							// Redraw Ships
							drawShips1();
			
					
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1-1,curCellY1,1,0);
							checkCell(curCellX1-2,curCellY1,1,0);
						}
					}
					else if(orientation1==2)		// left
					{
						if(curCellY1>1)
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1-1,curCellY1,0,0);
							drawCell(curCellX1-2,curCellY1,0,0);
							
			
							// Redraw Ships
							drawShips1();
			
					
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1,curCellY1-1,1,0);
							checkCell(curCellX1,curCellY1-2,1,0);
						}
					}
					else						// up
					{
						if(curCellX1<8)
						{
							// update orientation
							orientation1=0;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1,curCellY1-1,0,0);
							drawCell(curCellX1,curCellY1-2,0,0);
							
			
							// Redraw Ships
							drawShips1();
			
					
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1+1,curCellY1,1,0);
							checkCell(curCellX1+2,curCellY1,1,0);
						}
					}
				}
				
				/* Player 1 Down */
				if(read1 == 4)		// Down 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
					}
					
					/* Move cursor down */
					curCellY1+=1;
					if(curCellY1>7 && orientation1==1)	curCellY1-=1;
					else if(curCellY1>9)	curCellY1-=1;
					
			
					// Redraw Ships
					drawShips1();
			
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
					}
				}
				
				/* Player 1 Right */
				if(read1 == 8)		// Right 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
					}
					
					/* Move cursor right */
					curCellX1+=1;
					if(curCellX1>7 && orientation1==0)	curCellX1-=1;
					else if(curCellX1>9)	curCellX1-=1;
					
			
					// Redraw Ships
					drawShips1();
			
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
					}
				}
				
				/* Player 1 Up */
				if(read1 == 16)		// Up 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
					}
					
					/* Move cursor up */
					curCellY1-=1;
					if(curCellY1<2 && orientation1==3)	curCellY1+=1;
					else if(curCellY1>10)	curCellY1=0;
					
			
					// Redraw Ships
					drawShips1();
			
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
					}
				}
				
				/* Player 1 Left */
				if(read1 == 32)		// Left 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
					}
					
					/* Move cursor left */
					curCellX1-=1;
					if(curCellX1<2 && orientation1==2)	curCellX1+=1;
					else if(curCellX1>10)	curCellX1=0;
					
			
					// Redraw Ships
					drawShips1();
			
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
					}
				}
			}
			
			/* Clear current cells */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX1,curCellY1,5,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,5,0);
				drawCell(curCellX1+2,curCellY1,5,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,5,0);
				drawCell(curCellX1,curCellY1+2,5,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,5,0);
				drawCell(curCellX1-2,curCellY1,5,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,5,0);
				drawCell(curCellX1,curCellY1-2,5,0);
			}
			
			/* Enter ship cell locations into location matrix */
			L1[curCellX1][curCellY1]=1;
			if(orientation1==0)
			{
				L1[curCellX1+1][curCellY1]=1;
				L1[curCellX1+2][curCellY1]=1;
			}
			else if(orientation1==1)
			{
				L1[curCellX1][curCellY1+1]=1;
				L1[curCellX1][curCellY1+2]=1;
			}
			else if(orientation1==2)
			{
				L1[curCellX1-1][curCellY1]=1;
				L1[curCellX1-2][curCellY1]=1;
			}
			else
			{
				L1[curCellX1][curCellY1-1]=1;
				L1[curCellX1][curCellY1-2]=1;
			}
		}
}


/*** Enter Battleship (length = 4) ***/
void enterShip4(void)
{
	// Enter initial orientation, read input, and cell locations
	curCellX1=0;							// set player 1 x-coordinate to 0
	curCellY1=0;							// set player 1 y-coordinate to 0
	curCellX2=0;							// set player 2 x-coordinate to 0
	curCellY2=0;							// set player 2 y-coordinate to 0
	orientation1=0;							// set player 1 orientation to 0 (right)
	orientation2=0;							// set player 2 orientation to 0 (right)
	read1=0;								// set player 1 input to nothing read
	read2=0;								// set player 2 input to nothing read
	checkCell(curCellX1,curCellY1,0,0);		// draw player 1 current cell
	checkCell(curCellX1+1,curCellY1,1,0);	// draw player 1 cell 2
	checkCell(curCellX1+2,curCellY1,1,0);	// draw player 1 cell 3
	checkCell(curCellX1+3,curCellY1,1,0);	// draw player 1 cell 4
	checkCell(curCellX2,curCellY2,0,1);		// draw player 2 current cell
	checkCell(curCellX2+1,curCellY2,1,1);	// draw player 2 cell 2
	checkCell(curCellX2+2,curCellY2,1,1);	// draw player 2 cell 3
	checkCell(curCellX2+3,curCellY2,1,1);	// draw player 2 cell 4
	
	while((read1!=1 || checkTaken4(curCellX1,curCellY1,0)) && (read2!=1 || checkTaken4(curCellX2,curCellY2,1)))	// while neither player has pressed select and player who pressed select has taken cells
	{
		read1 = readEdge(PlayIn1);
		clearEdge(PlayIn1);
		read2 = readEdge(PlayIn2);
		clearEdge(PlayIn2);
		
		/* Rotate Player 1 */
		if(read1 == 2)		// Rotate 1
		{
			/* Rotate */
			if(orientation1==0)			// right
			{
				if(curCellY1<7)			// cannot rotate from right to down if current cell is in bottom two rows
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1+1,curCellY1,0,0);
					drawCell(curCellX1+2,curCellY1,0,0);
					drawCell(curCellX1+3,curCellY1,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1,curCellY1+1,1,0);
					checkCell(curCellX1,curCellY1+2,1,0);
					checkCell(curCellX1,curCellY1+3,1,0);
				}
			}
			else if(orientation1==1)		// down
			{
				if(curCellX1>2)		// cannot rotate from down to left if current cell is in first column
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1,curCellY1+1,0,0);
					drawCell(curCellX1,curCellY1+2,0,0);
					drawCell(curCellX1,curCellY1+3,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1-1,curCellY1,1,0);
					checkCell(curCellX1-2,curCellY1,1,0);
					checkCell(curCellX1-3,curCellY1,1,0);
				}
			}
			else if(orientation1==2)		// left
			{
				if(curCellY1>2)
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1-1,curCellY1,0,0);
					drawCell(curCellX1-2,curCellY1,0,0);
					drawCell(curCellX1-3,curCellY1,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1,curCellY1-1,1,0);
					checkCell(curCellX1,curCellY1-2,1,0);
					checkCell(curCellX1,curCellY1-3,1,0);
				}
			}
			else						// up
			{
				if(curCellX1<7)
				{
					// update orientation
					orientation1=0;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1,curCellY1-1,0,0);
					drawCell(curCellX1,curCellY1-2,0,0);
					drawCell(curCellX1,curCellY1-3,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1+1,curCellY1,1,0);
					checkCell(curCellX1+2,curCellY1,1,0);
					checkCell(curCellX1+3,curCellY1,1,0);
				}
			}
		}
		
		/* Rotate Player 2 */
		if(read2 == 2)		// Rotate 2
		{
			/* Rotate */
			if(orientation2==0)			// right
			{
				if(curCellY2<7)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2+1,curCellY2,0,1);
					drawCell(curCellX2+2,curCellY2,0,1);
					drawCell(curCellX2+3,curCellY2,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2,curCellY2+1,1,1);
					checkCell(curCellX2,curCellY2+2,1,1);
					checkCell(curCellX2,curCellY2+3,1,1);
				}
			}
			else if(orientation2==1)		// down
			{
				if(curCellX2>2)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2,curCellY2+1,0,1);
					drawCell(curCellX2,curCellY2+2,0,1);
					drawCell(curCellX2,curCellY2+3,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2-1,curCellY2,1,1);
					checkCell(curCellX2-2,curCellY2,1,1);
					checkCell(curCellX2-3,curCellY2,1,1);
				}
			}
			else if(orientation2==2)		// left
			{
				if(curCellY2>2)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2-1,curCellY2,0,1);
					drawCell(curCellX2-2,curCellY2,0,1);
					drawCell(curCellX2-3,curCellY2,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2,curCellY2-1,1,1);
					checkCell(curCellX2,curCellY2-2,1,1);
					checkCell(curCellX2,curCellY2-3,1,1);
				}
			}
			else						// up
			{
				if(curCellX2<7)
				{
					// update orientation
					orientation2=0;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2,curCellY2-1,0,1);
					drawCell(curCellX2,curCellY2-2,0,1);
					drawCell(curCellX2,curCellY2-3,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2+1,curCellY2,1,1);
					checkCell(curCellX2+2,curCellY2,1,1);
					checkCell(curCellX2+3,curCellY2,1,1);
				}
			}
		}
		
		/* Player 1 Down */
		if(read1 == 4)		// Down 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
			}
			
			/* Move cursor down */
			curCellY1+=1;
			if(curCellY1>6 && orientation1==1)	curCellY1-=1;
			else if(curCellY1>9)	curCellY1-=1;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
				checkCell(curCellX1+3,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
				checkCell(curCellX1,curCellY1+3,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
				checkCell(curCellX1-3,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
				checkCell(curCellX1,curCellY1-3,1,0);
			}
		}
		
		/* Player 2 Down */
		if(read2 == 4)		// Down 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
			}
			
			/* Move cursor down */
			curCellY2+=1;
			if(curCellY2>6 && orientation2==1)	curCellY2-=1;
			else if(curCellY2>9)	curCellY2-=1;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
				checkCell(curCellX2+3,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
				checkCell(curCellX2,curCellY2+3,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
				checkCell(curCellX2-3,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
				checkCell(curCellX2,curCellY2-3,1,1);
			}
		}
		
		/* Player 1 Right */
		if(read1 == 8)		// Right 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
			}
			
			/* Move cursor right */
			curCellX1+=1;
			if(curCellX1>6 && orientation1==0)	curCellX1-=1;
			else if(curCellX1>9)	curCellX1-=1;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
				checkCell(curCellX1+3,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
				checkCell(curCellX1,curCellY1+3,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
				checkCell(curCellX1-3,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
				checkCell(curCellX1,curCellY1-3,1,0);
			}
		}
		
		/* Player 2 Right */
		if(read2 == 8)		// Right 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
			}
			
			/* Move cursor right */
			curCellX2+=1;
			if(curCellX2>6 && orientation2==0)	curCellX2-=1;
			else if(curCellX2>9)	curCellX2-=1;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
				checkCell(curCellX2+3,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
				checkCell(curCellX2,curCellY2+3,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
				checkCell(curCellX2-3,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
				checkCell(curCellX2,curCellY2-3,1,1);
			}
		}
		
		/* Player 1 Up */
		if(read1 == 16)		// Up 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
			}
			
			/* Move cursor up */
			curCellY1-=1;
			if(curCellY1<3 && orientation1==3)	curCellY1+=1;
			else if(curCellY1>10)	curCellY1=0;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
				checkCell(curCellX1+3,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
				checkCell(curCellX1,curCellY1+3,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
				checkCell(curCellX1-3,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
				checkCell(curCellX1,curCellY1-3,1,0);
			}
		}
		
		/* Player 2 Up */
		if(read2 == 16)		// Up 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
			}
			
			/* Move cursor up */
			curCellY2-=1;
			if(curCellY2<3 && orientation2==3)	curCellY2+=1;
			else if(curCellY2>10)	curCellY2=0;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
				checkCell(curCellX2+3,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
				checkCell(curCellX2,curCellY2+3,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
				checkCell(curCellX2-3,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
				checkCell(curCellX2,curCellY2-3,1,1);
			}
		}
		
		/* Player 1 Left */
		if(read1 == 32)		// Left 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
			}
			
			/* Move cursor left */
			curCellX1-=1;
			if(curCellX1<3 && orientation1==2)	curCellX1+=1;
			else if(curCellX1>10)	curCellX1=0;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
				checkCell(curCellX1+3,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
				checkCell(curCellX1,curCellY1+3,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
				checkCell(curCellX1-3,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
				checkCell(curCellX1,curCellY1-3,1,0);
			}
		}
		
		/* Player 2 Left */
		if(read2 == 32)		// Left 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
			}
			
			/* Move cursor left */
			curCellX2-=1;
			if(curCellX2<3 && orientation2==2)	curCellX2+=1;
			else if(curCellX2>10)	curCellX2=0;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
				checkCell(curCellX2+3,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
				checkCell(curCellX2,curCellY2+3,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
				checkCell(curCellX2-3,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
				checkCell(curCellX2,curCellY2-3,1,1);
			}
		}
	}	
		
		
		// Redraw Ships
		drawShips1();
		drawShips2();
		
		
		/* Enter selected ship location into player location matrix */
		if(read1 == 1)	// if player 1 pressed select then allow player 1 to finish entering ship length=2
		{
			/* Clear current cells */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX1,curCellY1,5,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,5,0);
				drawCell(curCellX1+2,curCellY1,5,0);
				drawCell(curCellX1+3,curCellY1,5,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,5,0);
				drawCell(curCellX1,curCellY1+2,5,0);
				drawCell(curCellX1,curCellY1+3,5,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,5,0);
				drawCell(curCellX1-2,curCellY1,5,0);
				drawCell(curCellX1-3,curCellY1,5,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,5,0);
				drawCell(curCellX1,curCellY1-2,5,0);
				drawCell(curCellX1,curCellY1-3,5,0);
			}
			
			/* Enter ship cell locations into location matrix */
			L1[curCellX1][curCellY1]=1;
			if(orientation1==0)
			{
				L1[curCellX1+1][curCellY1]=1;
				L1[curCellX1+2][curCellY1]=1;
				L1[curCellX1+3][curCellY1]=1;
			}
			else if(orientation1==1)
			{
				L1[curCellX1][curCellY1+1]=1;
				L1[curCellX1][curCellY1+2]=1;
				L1[curCellX1][curCellY1+3]=1;
			}
			else if(orientation1==2)
			{
				L1[curCellX1-1][curCellY1]=1;
				L1[curCellX1-2][curCellY1]=1;
				L1[curCellX1-3][curCellY1]=1;
			}
			else
			{
				L1[curCellX1][curCellY1-1]=1;
				L1[curCellX1][curCellY1-2]=1;
				L1[curCellX1][curCellY1-3]=1;
			}
			
			
			while((read2 != 1) || checkTaken4(curCellX2,curCellY2,1))		// while player 2 does not press select and is on taken cells
			{
				read2 = readEdge(PlayIn2);
				clearEdge(PlayIn2);
				
				/* Rotate Player 2 */
				if(read2 == 2)		// Rotate 2
				{
					/* Rotate */
					if(orientation2==0)			// right
					{
						if(curCellY2<7)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2+1,curCellY2,0,1);
							drawCell(curCellX2+2,curCellY2,0,1);
							drawCell(curCellX2+3,curCellY2,0,1);
							
							
							// Redraw Ships
							drawShips2();
							
							
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2,curCellY2+1,1,1);
							checkCell(curCellX2,curCellY2+2,1,1);
							checkCell(curCellX2,curCellY2+3,1,1);
						}
					}
					else if(orientation2==1)		// down
					{
						if(curCellX2>2)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2,curCellY2+1,0,1);
							drawCell(curCellX2,curCellY2+2,0,1);
							drawCell(curCellX2,curCellY2+3,0,1);
							
							
							// Redraw Ships
							drawShips2();
							
							
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2-1,curCellY2,1,1);
							checkCell(curCellX2-2,curCellY2,1,1);
							checkCell(curCellX2-3,curCellY2,1,1);
						}
					}
					else if(orientation2==2)		// left
					{
						if(curCellY2>2)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2-1,curCellY2,0,1);
							drawCell(curCellX2-2,curCellY2,0,1);
							drawCell(curCellX2-3,curCellY2,0,1);
							
							
							// Redraw Ships
							drawShips2();
							
							
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2,curCellY2-1,1,1);
							checkCell(curCellX2,curCellY2-2,1,1);
							checkCell(curCellX2,curCellY2-3,1,1);
						}
					}
					else						// up
					{
						if(curCellX2<7)
						{
							// update orientation
							orientation2=0;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2,curCellY2-1,0,1);
							drawCell(curCellX2,curCellY2-2,0,1);
							drawCell(curCellX2,curCellY2-3,0,1);
							
							
							// Redraw Ships
							drawShips2();
							
							
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2+1,curCellY2,1,1);
							checkCell(curCellX2+2,curCellY2,1,1);
							checkCell(curCellX2+3,curCellY2,1,1);
						}
					}
				}
				
				/* Player 2 Down */
				if(read2 == 4)		// Down 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
						drawCell(curCellX2+3,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
						drawCell(curCellX2,curCellY2+3,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
						drawCell(curCellX2-3,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
						drawCell(curCellX2,curCellY2-3,0,1);
					}
					
					/* Move cursor down */
					curCellY2+=1;
					if(curCellY2>6 && orientation2==1)	curCellY2-=1;
					else if(curCellY2>9)	curCellY2-=1;
					
					
					// Redraw Ships
					drawShips2();
					
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
						checkCell(curCellX2+3,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
						checkCell(curCellX2,curCellY2+3,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
						checkCell(curCellX2-3,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
						checkCell(curCellX2,curCellY2-3,1,1);
					}
				}
				
				/* Player 2 Right */
				if(read2 == 8)		// Right 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
						drawCell(curCellX2+3,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
						drawCell(curCellX2,curCellY2+3,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
						drawCell(curCellX2-3,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
						drawCell(curCellX2,curCellY2-3,0,1);
					}
					
					/* Move cursor right */
					curCellX2+=1;
					if(curCellX2>6 && orientation2==0)	curCellX2-=1;
					else if(curCellX2>9)	curCellX2-=1;
					
					
					// Redraw Ships
					drawShips2();
					
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
						checkCell(curCellX2+3,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
						checkCell(curCellX2,curCellY2+3,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
						checkCell(curCellX2-3,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
						checkCell(curCellX2,curCellY2-3,1,1);
					}
				}
				
				/* Player 2 Up */
				if(read2 == 16)		// Up 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
						drawCell(curCellX2+3,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
						drawCell(curCellX2,curCellY2+3,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
						drawCell(curCellX2-3,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
						drawCell(curCellX2,curCellY2-3,0,1);
					}
					
					/* Move cursor up */
					curCellY2-=1;
					if(curCellY2<3 && orientation2==3)	curCellY2+=1;
					else if(curCellY2>10)	curCellY2=0;
					
					
					// Redraw Ships
					drawShips2();
					
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
						checkCell(curCellX2+3,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
						checkCell(curCellX2,curCellY2+3,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
						checkCell(curCellX2-3,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
						checkCell(curCellX2,curCellY2-3,1,1);
					}
				}
				
				/* Player 2 Left */
				if(read2 == 32)		// Left 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
						drawCell(curCellX2+3,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
						drawCell(curCellX2,curCellY2+3,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
						drawCell(curCellX2-3,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
						drawCell(curCellX2,curCellY2-3,0,1);
					}
					
					/* Move cursor left */
					curCellX2-=1;
					if(curCellX2<3 && orientation2==2)	curCellX2+=1;
					else if(curCellX2>10)	curCellX2=0;
					
					
					// Redraw Ships
					drawShips2();
					
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
						checkCell(curCellX2+3,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
						checkCell(curCellX2,curCellY2+3,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
						checkCell(curCellX2-3,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
						checkCell(curCellX2,curCellY2-3,1,1);
					}
				}
			}
			
			/* Clear current cells */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX2,curCellY2,5,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,5,1);
				drawCell(curCellX2+2,curCellY2,5,1);
				drawCell(curCellX2+3,curCellY2,5,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,5,1);
				drawCell(curCellX2,curCellY2+2,5,1);
				drawCell(curCellX2,curCellY2+3,5,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,5,1);
				drawCell(curCellX2-2,curCellY2,5,1);
				drawCell(curCellX2-3,curCellY2,5,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,5,1);
				drawCell(curCellX2,curCellY2-2,5,1);
				drawCell(curCellX2,curCellY2-3,5,1);
			}
			
			/* Enter ship cell locations into location matrix */
			L2[curCellX2][curCellY2] = 1;
			if(orientation2==0)
			{
				L2[curCellX2+1][curCellY2]=1;
				L2[curCellX2+2][curCellY2]=1;
				L2[curCellX2+3][curCellY2]=1;
			}
			else if(orientation2==1)
			{
				L2[curCellX2][curCellY2+1]=1;
				L2[curCellX2][curCellY2+2]=1;
				L2[curCellX2][curCellY2+3]=1;
			}
			else if(orientation2==2)
			{
				L2[curCellX2-1][curCellY2]=1;
				L2[curCellX2-2][curCellY2]=1;
				L2[curCellX2-3][curCellY2]=1;
			}
			else
			{
				L2[curCellX2][curCellY2-1]=1;
				L2[curCellX2][curCellY2-2]=1;
				L2[curCellX2][curCellY2-3]=1;
			}
		}
		
		else						// if player 2 pressed select then allow player 1 to finish entering ship length=2
		{
			/* Clear current cells */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX2,curCellY2,5,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,5,1);
				drawCell(curCellX2+2,curCellY2,5,1);
				drawCell(curCellX2+3,curCellY2,5,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,5,1);
				drawCell(curCellX2,curCellY2+2,5,1);
				drawCell(curCellX2,curCellY2+3,5,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,5,1);
				drawCell(curCellX2-2,curCellY2,5,1);
				drawCell(curCellX2-3,curCellY2,5,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,5,1);
				drawCell(curCellX2,curCellY2-2,5,1);
				drawCell(curCellX2,curCellY2-3,5,1);
			}
			
			/* Enter ship cell locations into location matrix */
			L2[curCellX2][curCellY2] = 1;
			if(orientation2==0)
			{
				L2[curCellX2+1][curCellY2]=1;
				L2[curCellX2+2][curCellY2]=1;
				L2[curCellX2+3][curCellY2]=1;
			}
			else if(orientation2==1)
			{
				L2[curCellX2][curCellY2+1]=1;
				L2[curCellX2][curCellY2+2]=1;
				L2[curCellX2][curCellY2+3]=1;
			}
			else if(orientation2==2)
			{
				L2[curCellX2-1][curCellY2]=1;
				L2[curCellX2-2][curCellY2]=1;
				L2[curCellX2-3][curCellY2]=1;
			}
			else
			{
				L2[curCellX2][curCellY2-1]=1;
				L2[curCellX2][curCellY2-2]=1;
				L2[curCellX2][curCellY2-3]=1;
			}
				
			while(read1 != 1 || checkTaken4(curCellX1,curCellY1,0))
			{
				read1 = readEdge(PlayIn1);
				clearEdge(PlayIn1);
				
				/* Rotate Player 1 */
				if(read1 == 2)		// Rotate 1
				{
					/* Rotate */
					if(orientation1==0)			// right
					{
						if(curCellY1<7)			// cannot rotate from right to down if current cell is in bottom two rows
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1+1,curCellY1,0,0);
							drawCell(curCellX1+2,curCellY1,0,0);
							drawCell(curCellX1+3,curCellY1,0,0);
							
							
							// Redraw Ships
							drawShips1();
							
							
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1,curCellY1+1,1,0);
							checkCell(curCellX1,curCellY1+2,1,0);
							checkCell(curCellX1,curCellY1+3,1,0);
						}
					}
					else if(orientation1==1)		// down
					{
						if(curCellX1>2)		// cannot rotate from down to left if current cell is in first column
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1,curCellY1+1,0,0);
							drawCell(curCellX1,curCellY1+2,0,0);
							drawCell(curCellX1,curCellY1+3,0,0);
							
							
							// Redraw Ships
							drawShips1();
							
							
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1-1,curCellY1,1,0);
							checkCell(curCellX1-2,curCellY1,1,0);
							checkCell(curCellX1-3,curCellY1,1,0);
						}
					}
					else if(orientation1==2)		// left
					{
						if(curCellY1>2)
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1-1,curCellY1,0,0);
							drawCell(curCellX1-2,curCellY1,0,0);
							drawCell(curCellX1-3,curCellY1,0,0);
							
							
							// Redraw Ships
							drawShips1();
							
							
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1,curCellY1-1,1,0);
							checkCell(curCellX1,curCellY1-2,1,0);
							checkCell(curCellX1,curCellY1-3,1,0);
						}
					}
					else						// up
					{
						if(curCellX1<7)
						{
							// update orientation
							orientation1=0;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1,curCellY1-1,0,0);
							drawCell(curCellX1,curCellY1-2,0,0);
							drawCell(curCellX1,curCellY1-3,0,0);
							
							
							// Redraw Ships
							drawShips1();
							
							
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1+1,curCellY1,1,0);
							checkCell(curCellX1+2,curCellY1,1,0);
							checkCell(curCellX1+3,curCellY1,1,0);
						}
					}
				}
				
				/* Player 1 Down */
				if(read1 == 4)		// Down 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
						drawCell(curCellX1+3,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
						drawCell(curCellX1,curCellY1+3,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
						drawCell(curCellX1-3,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
						drawCell(curCellX1,curCellY1-3,0,0);
					}
					
					/* Move cursor down */
					curCellY1+=1;
					if(curCellY1>6 && orientation1==1)	curCellY1-=1;
					else if(curCellY1>9)	curCellY1-=1;
					
					
					// Redraw Ships
					drawShips1();
					
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
						checkCell(curCellX1+3,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
						checkCell(curCellX1,curCellY1+3,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
						checkCell(curCellX1-3,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
						checkCell(curCellX1,curCellY1-3,1,0);
					}
				}
				
				/* Player 1 Right */
				if(read1 == 8)		// Right 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
						drawCell(curCellX1+3,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
						drawCell(curCellX1,curCellY1+3,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
						drawCell(curCellX1-3,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
						drawCell(curCellX1,curCellY1-3,0,0);
					}
					
					/* Move cursor right */
					curCellX1+=1;
					if(curCellX1>6 && orientation1==0)	curCellX1-=1;
					else if(curCellX1>9)	curCellX1-=1;
					
					
					// Redraw Ships
					drawShips1();
					
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
						checkCell(curCellX1+3,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
						checkCell(curCellX1,curCellY1+3,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
						checkCell(curCellX1-3,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
						checkCell(curCellX1,curCellY1-3,1,0);
					}
				}
				
				/* Player 1 Up */
				if(read1 == 16)		// Up 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
						drawCell(curCellX1+3,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
						drawCell(curCellX1,curCellY1+3,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
						drawCell(curCellX1-3,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
						drawCell(curCellX1,curCellY1-3,0,0);
					}
					
					/* Move cursor up */
					curCellY1-=1;
					if(curCellY1<3 && orientation1==3)	curCellY1+=1;
					else if(curCellY1>10)	curCellY1=0;
					
					
					// Redraw Ships
					drawShips1();
					
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
						checkCell(curCellX1+3,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
						checkCell(curCellX1,curCellY1+3,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
						checkCell(curCellX1-3,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
						checkCell(curCellX1,curCellY1-3,1,0);
					}
				}
				
				/* Player 1 Left */
				if(read1 == 32)		// Left 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
						drawCell(curCellX1+3,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
						drawCell(curCellX1,curCellY1+3,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
						drawCell(curCellX1-3,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
						drawCell(curCellX1,curCellY1-3,0,0);
					}
					
					/* Move cursor left */
					curCellX1-=1;
					if(curCellX1<3 && orientation1==2)	curCellX1+=1;
					else if(curCellX1>10)	curCellX1=0;
					
					
					// Redraw Ships
					drawShips1();
					
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
						checkCell(curCellX1+3,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
						checkCell(curCellX1,curCellY1+3,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
						checkCell(curCellX1-3,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
						checkCell(curCellX1,curCellY1-3,1,0);
					}
				}
			}
			
			/* Clear current cells */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX1,curCellY1,5,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,5,0);
				drawCell(curCellX1+2,curCellY1,5,0);
				drawCell(curCellX1+3,curCellY1,5,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,5,0);
				drawCell(curCellX1,curCellY1+2,5,0);
				drawCell(curCellX1,curCellY1+3,5,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,5,0);
				drawCell(curCellX1-2,curCellY1,5,0);
				drawCell(curCellX1-3,curCellY1,5,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,5,0);
				drawCell(curCellX1,curCellY1-2,5,0);
				drawCell(curCellX1,curCellY1-3,5,0);
			}
			
			/* Enter ship cell locations into location matrix */
			L1[curCellX1][curCellY1]=1;
			if(orientation1==0)
			{
				L1[curCellX1+1][curCellY1]=1;
				L1[curCellX1+2][curCellY1]=1;
				L1[curCellX1+3][curCellY1]=1;
			}
			else if(orientation1==1)
			{
				L1[curCellX1][curCellY1+1]=1;
				L1[curCellX1][curCellY1+2]=1;
				L1[curCellX1][curCellY1+3]=1;
			}
			else if(orientation1==2)
			{
				L1[curCellX1-1][curCellY1]=1;
				L1[curCellX1-2][curCellY1]=1;
				L1[curCellX1-3][curCellY1]=1;
			}
			else
			{
				L1[curCellX1][curCellY1-1]=1;
				L1[curCellX1][curCellY1-2]=1;
				L1[curCellX1][curCellY1-3]=1;
			}
		}
}


/*** Enter Aircraft Carrier (length = 5) ***/
void enterShip5(void)
{
	// Enter initial orientation, read input, and cell locations
	curCellX1=0;							// set player 1 x-coordinate to 0
	curCellY1=0;							// set player 1 y-coordinate to 0
	curCellX2=0;							// set player 2 x-coordinate to 0
	curCellY2=0;							// set player 2 y-coordinate to 0
	orientation1=0;							// set player 1 orientation to 0 (right)
	orientation2=0;							// set player 2 orientation to 0 (right)
	read1=0;								// set player 1 input to nothing read
	read2=0;								// set player 2 input to nothing read
	checkCell(curCellX1,curCellY1,0,0);		// draw player 1 current cell
	checkCell(curCellX1+1,curCellY1,1,0);	// draw player 1 cell 2
	checkCell(curCellX1+2,curCellY1,1,0);	// draw player 1 cell 3
	checkCell(curCellX1+3,curCellY1,1,0);	// draw player 1 cell 4
	checkCell(curCellX1+4,curCellY1,1,0);	// draw player 1 cell 5
	checkCell(curCellX2,curCellY2,0,1);		// draw player 2 current cell
	checkCell(curCellX2+1,curCellY2,1,1);	// draw player 2 cell 2
	checkCell(curCellX2+2,curCellY2,1,1);	// draw player 2 cell 3
	checkCell(curCellX2+3,curCellY2,1,1);	// draw player 2 cell 4
	checkCell(curCellX2+4,curCellY2,1,1);	// draw player 2 cell 5
	
	while((read1!=1 || checkTaken5(curCellX1,curCellY1,0)) && (read2!=1 || checkTaken5(curCellX2,curCellY2,1)))	// while neither player has pressed select and player who pressed select has taken cells
	{
		read1 = readEdge(PlayIn1);
		clearEdge(PlayIn1);
		read2 = readEdge(PlayIn2);
		clearEdge(PlayIn2);
		
		/* Rotate Player 1 */
		if(read1 == 2)		// Rotate 1
		{
			/* Rotate */
			if(orientation1==0)			// right
			{
				if(curCellY1<6)			// cannot rotate from right to down if current cell is in bottom two rows
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1+1,curCellY1,0,0);
					drawCell(curCellX1+2,curCellY1,0,0);
					drawCell(curCellX1+3,curCellY1,0,0);
					drawCell(curCellX1+4,curCellY1,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1,curCellY1+1,1,0);
					checkCell(curCellX1,curCellY1+2,1,0);
					checkCell(curCellX1,curCellY1+3,1,0);
					checkCell(curCellX1,curCellY1+4,1,0);
				}
			}
			else if(orientation1==1)		// down
			{
				if(curCellX1>3)		// cannot rotate from down to left if current cell is in first column
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1,curCellY1+1,0,0);
					drawCell(curCellX1,curCellY1+2,0,0);
					drawCell(curCellX1,curCellY1+3,0,0);
					drawCell(curCellX1,curCellY1+4,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1-1,curCellY1,1,0);
					checkCell(curCellX1-2,curCellY1,1,0);
					checkCell(curCellX1-3,curCellY1,1,0);
					checkCell(curCellX1-4,curCellY1,1,0);
				}
			}
			else if(orientation1==2)		// left
			{
				if(curCellY1>3)
				{
					// update orientation
					orientation1+=1;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1-1,curCellY1,0,0);
					drawCell(curCellX1-2,curCellY1,0,0);
					drawCell(curCellX1-3,curCellY1,0,0);
					drawCell(curCellX1-4,curCellY1,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1,curCellY1-1,1,0);
					checkCell(curCellX1,curCellY1-2,1,0);
					checkCell(curCellX1,curCellY1-3,1,0);
					checkCell(curCellX1,curCellY1-4,1,0);
				}
			}
			else						// up
			{
				if(curCellX1<6)
				{
					// update orientation
					orientation1=0;
					
					// clear current cells
					drawCell(curCellX1,curCellY1,0,0);
					drawCell(curCellX1,curCellY1-1,0,0);
					drawCell(curCellX1,curCellY1-2,0,0);
					drawCell(curCellX1,curCellY1-3,0,0);
					drawCell(curCellX1,curCellY1-4,0,0);
					
					
					// Redraw Ships
					drawShips1();
					
					
					// draw new cells
					checkCell(curCellX1,curCellY1,0,0);
					checkCell(curCellX1+1,curCellY1,1,0);
					checkCell(curCellX1+2,curCellY1,1,0);
					checkCell(curCellX1+3,curCellY1,1,0);
					checkCell(curCellX1+4,curCellY1,1,0);
				}
			}
		}
		
		/* Rotate Player 2 */
		if(read2 == 2)		// Rotate 2
		{
			/* Rotate */
			if(orientation2==0)			// right
			{
				if(curCellY2<6)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2+1,curCellY2,0,1);
					drawCell(curCellX2+2,curCellY2,0,1);
					drawCell(curCellX2+3,curCellY2,0,1);
					drawCell(curCellX2+4,curCellY2,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2,curCellY2+1,1,1);
					checkCell(curCellX2,curCellY2+2,1,1);
					checkCell(curCellX2,curCellY2+3,1,1);
					checkCell(curCellX2,curCellY2+4,1,1);
				}
			}
			else if(orientation2==1)		// down
			{
				if(curCellX2>3)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2,curCellY2+1,0,1);
					drawCell(curCellX2,curCellY2+2,0,1);
					drawCell(curCellX2,curCellY2+3,0,1);
					drawCell(curCellX2,curCellY2+4,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2-1,curCellY2,1,1);
					checkCell(curCellX2-2,curCellY2,1,1);
					checkCell(curCellX2-3,curCellY2,1,1);
					checkCell(curCellX2-4,curCellY2,1,1);
				}
			}
			else if(orientation2==2)		// left
			{
				if(curCellY2>3)
				{
					// update orientation
					orientation2+=1;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2-1,curCellY2,0,1);
					drawCell(curCellX2-2,curCellY2,0,1);
					drawCell(curCellX2-3,curCellY2,0,1);
					drawCell(curCellX2-4,curCellY2,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2,curCellY2-1,1,1);
					checkCell(curCellX2,curCellY2-2,1,1);
					checkCell(curCellX2,curCellY2-3,1,1);
					checkCell(curCellX2,curCellY2-4,1,1);
				}
			}
			else						// up
			{
				if(curCellX2<6)
				{
					// update orientation
					orientation2=0;
					
					// clear current cells
					drawCell(curCellX2,curCellY2,0,1);
					drawCell(curCellX2,curCellY2-1,0,1);
					drawCell(curCellX2,curCellY2-2,0,1);
					drawCell(curCellX2,curCellY2-3,0,1);
					drawCell(curCellX2,curCellY2-4,0,1);
					
					
					// Redraw Ships
					drawShips2();
					
					
					// draw new cells
					checkCell(curCellX2,curCellY2,0,1);
					checkCell(curCellX2+1,curCellY2,1,1);
					checkCell(curCellX2+2,curCellY2,1,1);
					checkCell(curCellX2+3,curCellY2,1,1);
					checkCell(curCellX2+4,curCellY2,1,1);
				}
			}
		}
		
		/* Player 1 Down */
		if(read1 == 4)		// Down 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
				drawCell(curCellX1+4,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
				drawCell(curCellX1,curCellY1+4,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
				drawCell(curCellX1-4,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
				drawCell(curCellX1,curCellY1-4,0,0);
			}
			
			/* Move cursor down */
			curCellY1+=1;
			if(curCellY1>5 && orientation1==1)	curCellY1-=1;
			else if(curCellY1>9)	curCellY1-=1;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
				checkCell(curCellX1+3,curCellY1,1,0);
				checkCell(curCellX1+4,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
				checkCell(curCellX1,curCellY1+3,1,0);
				checkCell(curCellX1,curCellY1+4,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
				checkCell(curCellX1-3,curCellY1,1,0);
				checkCell(curCellX1-4,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
				checkCell(curCellX1,curCellY1-3,1,0);
				checkCell(curCellX1,curCellY1-4,1,0);
			}
		}
		
		/* Player 2 Down */
		if(read2 == 4)		// Down 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
				drawCell(curCellX2+4,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
				drawCell(curCellX2,curCellY2+4,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
				drawCell(curCellX2-4,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
				drawCell(curCellX2,curCellY2-4,0,1);
			}
			
			/* Move cursor down */
			curCellY2+=1;
			if(curCellY2>5 && orientation2==1)	curCellY2-=1;
			else if(curCellY2>9)	curCellY2-=1;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
				checkCell(curCellX2+3,curCellY2,1,1);
				checkCell(curCellX2+4,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
				checkCell(curCellX2,curCellY2+3,1,1);
				checkCell(curCellX2,curCellY2+4,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
				checkCell(curCellX2-3,curCellY2,1,1);
				checkCell(curCellX2-4,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
				checkCell(curCellX2,curCellY2-3,1,1);
				checkCell(curCellX2,curCellY2-4,1,1);
			}
		}
		
		/* Player 1 Right */
		if(read1 == 8)		// Right 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
				drawCell(curCellX1+4,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
				drawCell(curCellX1,curCellY1+4,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
				drawCell(curCellX1-4,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
				drawCell(curCellX1,curCellY1-4,0,0);
			}
			
			/* Move cursor right */
			curCellX1+=1;
			if(curCellX1>5 && orientation1==0)	curCellX1-=1;
			else if(curCellX1>9)	curCellX1-=1;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
				checkCell(curCellX1+3,curCellY1,1,0);
				checkCell(curCellX1+4,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
				checkCell(curCellX1,curCellY1+3,1,0);
				checkCell(curCellX1,curCellY1+4,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
				checkCell(curCellX1-3,curCellY1,1,0);
				checkCell(curCellX1-4,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
				checkCell(curCellX1,curCellY1-3,1,0);
				checkCell(curCellX1,curCellY1-4,1,0);
			}
		}
		
		/* Player 2 Right */
		if(read2 == 8)		// Right 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
				drawCell(curCellX2+4,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
				drawCell(curCellX2,curCellY2+4,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
				drawCell(curCellX2-4,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
				drawCell(curCellX2,curCellY2-4,0,1);
			}
			
			/* Move cursor right */
			curCellX2+=1;
			if(curCellX2>5 && orientation2==0)	curCellX2-=1;
			else if(curCellX2>9)	curCellX2-=1;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
				checkCell(curCellX2+3,curCellY2,1,1);
				checkCell(curCellX2+4,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
				checkCell(curCellX2,curCellY2+3,1,1);
				checkCell(curCellX2,curCellY2+4,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
				checkCell(curCellX2-3,curCellY2,1,1);
				checkCell(curCellX2-4,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
				checkCell(curCellX2,curCellY2-3,1,1);
				checkCell(curCellX2,curCellY2-4,1,1);
			}
		}
		
		/* Player 1 Up */
		if(read1 == 16)		// Up 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
				drawCell(curCellX1+4,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
				drawCell(curCellX1,curCellY1+4,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
				drawCell(curCellX1-4,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
				drawCell(curCellX1,curCellY1-4,0,0);
			}
			
			/* Move cursor up */
			curCellY1-=1;
			if(curCellY1<4 && orientation1==3)	curCellY1+=1;
			else if(curCellY1>10)	curCellY1=0;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
				checkCell(curCellX1+3,curCellY1,1,0);
				checkCell(curCellX1+4,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
				checkCell(curCellX1,curCellY1+3,1,0);
				checkCell(curCellX1,curCellY1+4,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
				checkCell(curCellX1-3,curCellY1,1,0);
				checkCell(curCellX1-4,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
				checkCell(curCellX1,curCellY1-3,1,0);
				checkCell(curCellX1,curCellY1-4,1,0);
			}
		}
		
		/* Player 2 Up */
		if(read2 == 16)		// Up 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
				drawCell(curCellX2+4,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
				drawCell(curCellX2,curCellY2+4,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
				drawCell(curCellX2-4,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
				drawCell(curCellX2,curCellY2-4,0,1);
			}
			
			/* Move cursor up */
			curCellY2-=1;
			if(curCellY2<4 && orientation2==3)	curCellY2+=1;
			else if(curCellY2>10)	curCellY2=0;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
				checkCell(curCellX2+3,curCellY2,1,1);
				checkCell(curCellX2+4,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
				checkCell(curCellX2,curCellY2+3,1,1);
				checkCell(curCellX2,curCellY2+4,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
				checkCell(curCellX2-3,curCellY2,1,1);
				checkCell(curCellX2-4,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
				checkCell(curCellX2,curCellY2-3,1,1);
				checkCell(curCellX2,curCellY2-4,1,1);
			}
		}
		
		/* Player 1 Left */
		if(read1 == 32)		// Left 1
		{
			/* Clear current cell */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
				drawCell(curCellX1+4,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
				drawCell(curCellX1,curCellY1+4,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
				drawCell(curCellX1-4,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
				drawCell(curCellX1,curCellY1-4,0,0);
			}
			
			/* Move cursor left */
			curCellX1-=1;
			if(curCellX1<4 && orientation1==2)	curCellX1+=1;
			else if(curCellX1>10)	curCellX1=0;
			
			
			// Redraw Ships
			drawShips1();
			
			
			/* Draw current cell */
			checkCell(curCellX1,curCellY1,0,0);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation1==0)
			{
				checkCell(curCellX1+1,curCellY1,1,0);
				checkCell(curCellX1+2,curCellY1,1,0);
				checkCell(curCellX1+3,curCellY1,1,0);
				checkCell(curCellX1+4,curCellY1,1,0);
			}
			else if(orientation1==1)
			{
				checkCell(curCellX1,curCellY1+1,1,0);
				checkCell(curCellX1,curCellY1+2,1,0);
				checkCell(curCellX1,curCellY1+3,1,0);
				checkCell(curCellX1,curCellY1+4,1,0);
			}
			else if(orientation1==2)
			{
				checkCell(curCellX1-1,curCellY1,1,0);
				checkCell(curCellX1-2,curCellY1,1,0);
				checkCell(curCellX1-3,curCellY1,1,0);
				checkCell(curCellX1-4,curCellY1,1,0);
			}
			else
			{
				checkCell(curCellX1,curCellY1-1,1,0);
				checkCell(curCellX1,curCellY1-2,1,0);
				checkCell(curCellX1,curCellY1-3,1,0);
				checkCell(curCellX1,curCellY1-4,1,0);
			}
		}
		
		/* Player 2 Left */
		if(read2 == 32)		// Left 2
		{
			/* Clear current cell */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
				drawCell(curCellX2+4,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
				drawCell(curCellX2,curCellY2+4,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
				drawCell(curCellX2-4,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
				drawCell(curCellX2,curCellY2-4,0,1);
			}
			
			/* Move cursor left */
			curCellX2-=1;
			if(curCellX2<4 && orientation2==2)	curCellX2+=1;
			else if(curCellX2>10)	curCellX2=0;
			
			
			// Redraw Ships
			drawShips2();
			
			
			/* Draw current cell */
			checkCell(curCellX2,curCellY2,0,1);
			
			/* Draw rest of ship location based on current orientation */
			if(orientation2==0)
			{
				checkCell(curCellX2+1,curCellY2,1,1);
				checkCell(curCellX2+2,curCellY2,1,1);
				checkCell(curCellX2+3,curCellY2,1,1);
				checkCell(curCellX2+4,curCellY2,1,1);
			}
			else if(orientation2==1)
			{
				checkCell(curCellX2,curCellY2+1,1,1);
				checkCell(curCellX2,curCellY2+2,1,1);
				checkCell(curCellX2,curCellY2+3,1,1);
				checkCell(curCellX2,curCellY2+4,1,1);
			}
			else if(orientation2==2)
			{
				checkCell(curCellX2-1,curCellY2,1,1);
				checkCell(curCellX2-2,curCellY2,1,1);
				checkCell(curCellX2-3,curCellY2,1,1);
				checkCell(curCellX2-4,curCellY2,1,1);
			}
			else
			{
				checkCell(curCellX2,curCellY2-1,1,1);
				checkCell(curCellX2,curCellY2-2,1,1);
				checkCell(curCellX2,curCellY2-3,1,1);
				checkCell(curCellX2,curCellY2-4,1,1);
			}
		}
	}	
		
		
		// Redraw Ships
		drawShips1();
		drawShips2();
		
		
		/* Enter selected ship location into player location matrix */
		if(read1 == 1)	// if player 1 pressed select then allow player 1 to finish entering ship length=2
		{
			/* Clear current cells */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
				drawCell(curCellX1+4,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
				drawCell(curCellX1,curCellY1+4,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
				drawCell(curCellX1-4,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
				drawCell(curCellX1,curCellY1-4,0,0);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX1,curCellY1,5,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,5,0);
				drawCell(curCellX1+2,curCellY1,5,0);
				drawCell(curCellX1+3,curCellY1,5,0);
				drawCell(curCellX1+4,curCellY1,5,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,5,0);
				drawCell(curCellX1,curCellY1+2,5,0);
				drawCell(curCellX1,curCellY1+3,5,0);
				drawCell(curCellX1,curCellY1+4,5,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,5,0);
				drawCell(curCellX1-2,curCellY1,5,0);
				drawCell(curCellX1-3,curCellY1,5,0);
				drawCell(curCellX1-4,curCellY1,5,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,5,0);
				drawCell(curCellX1,curCellY1-2,5,0);
				drawCell(curCellX1,curCellY1-3,5,0);
				drawCell(curCellX1,curCellY1-4,5,0);
			}
			
			/* Enter ship cell locations into location matrix */
			L1[curCellX1][curCellY1]=1;
			if(orientation1==0)
			{
				L1[curCellX1+1][curCellY1]=1;
				L1[curCellX1+2][curCellY1]=1;
				L1[curCellX1+3][curCellY1]=1;
				L1[curCellX1+4][curCellY1]=1;
			}
			else if(orientation1==1)
			{
				L1[curCellX1][curCellY1+1]=1;
				L1[curCellX1][curCellY1+2]=1;
				L1[curCellX1][curCellY1+3]=1;
				L1[curCellX1][curCellY1+4]=1;
			}
			else if(orientation1==2)
			{
				L1[curCellX1-1][curCellY1]=1;
				L1[curCellX1-2][curCellY1]=1;
				L1[curCellX1-3][curCellY1]=1;
				L1[curCellX1-4][curCellY1]=1;
			}
			else
			{
				L1[curCellX1][curCellY1-1]=1;
				L1[curCellX1][curCellY1-2]=1;
				L1[curCellX1][curCellY1-3]=1;
				L1[curCellX1][curCellY1-4]=1;
			}
			
			
			while((read2 != 1) || checkTaken5(curCellX2,curCellY2,1))		// while player 2 does not press select and is on taken cells
			{
				read2 = readEdge(PlayIn2);
				clearEdge(PlayIn2);
				
				/* Rotate Player 2 */
				if(read2 == 2)		// Rotate 2
				{
					/* Rotate */
					if(orientation2==0)			// right
					{
						if(curCellY2<6)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2+1,curCellY2,0,1);
							drawCell(curCellX2+2,curCellY2,0,1);
							drawCell(curCellX2+3,curCellY2,0,1);
							drawCell(curCellX2+4,curCellY2,0,1);
							
							
							// Redraw Ships
							drawShips2();
							
							
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2,curCellY2+1,1,1);
							checkCell(curCellX2,curCellY2+2,1,1);
							checkCell(curCellX2,curCellY2+3,1,1);
							checkCell(curCellX2,curCellY2+4,1,1);
						}
					}
					else if(orientation2==1)		// down
					{
						if(curCellX2>3)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2,curCellY2+1,0,1);
							drawCell(curCellX2,curCellY2+2,0,1);
							drawCell(curCellX2,curCellY2+3,0,1);
							drawCell(curCellX2,curCellY2+4,0,1);
							
							
							// Redraw Ships
							drawShips2();
							
							
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2-1,curCellY2,1,1);
							checkCell(curCellX2-2,curCellY2,1,1);
							checkCell(curCellX2-3,curCellY2,1,1);
							checkCell(curCellX2-4,curCellY2,1,1);
						}
					}
					else if(orientation2==2)		// left
					{
						if(curCellY2>3)
						{
							// update orientation
							orientation2+=1;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2-1,curCellY2,0,1);
							drawCell(curCellX2-2,curCellY2,0,1);
							drawCell(curCellX2-3,curCellY2,0,1);
							drawCell(curCellX2-4,curCellY2,0,1);
							
							
							// Redraw Ships
							drawShips2();
							
							
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2,curCellY2-1,1,1);
							checkCell(curCellX2,curCellY2-2,1,1);
							checkCell(curCellX2,curCellY2-3,1,1);
							checkCell(curCellX2,curCellY2-4,1,1);
						}
					}
					else						// up
					{
						if(curCellX2<6)
						{
							// update orientation
							orientation2=0;
							
							// clear current cells
							drawCell(curCellX2,curCellY2,0,1);
							drawCell(curCellX2,curCellY2-1,0,1);
							drawCell(curCellX2,curCellY2-2,0,1);
							drawCell(curCellX2,curCellY2-3,0,1);
							drawCell(curCellX2,curCellY2-4,0,1);
							
							
							// Redraw Ships
							drawShips2();
							
							
							// draw new cells
							checkCell(curCellX2,curCellY2,0,1);
							checkCell(curCellX2+1,curCellY2,1,1);
							checkCell(curCellX2+2,curCellY2,1,1);
							checkCell(curCellX2+3,curCellY2,1,1);
							checkCell(curCellX2+4,curCellY2,1,1);
						}
					}
				}
				
				/* Player 2 Down */
				if(read2 == 4)		// Down 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
						drawCell(curCellX2+3,curCellY2,0,1);
						drawCell(curCellX2+4,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
						drawCell(curCellX2,curCellY2+3,0,1);
						drawCell(curCellX2,curCellY2+4,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
						drawCell(curCellX2-3,curCellY2,0,1);
						drawCell(curCellX2-4,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
						drawCell(curCellX2,curCellY2-3,0,1);
						drawCell(curCellX2,curCellY2-4,0,1);
					}
					
					/* Move cursor down */
					curCellY2+=1;
					if(curCellY2>5 && orientation2==1)	curCellY2-=1;
					else if(curCellY2>9)	curCellY2-=1;
					
					
					// Redraw Ships
					drawShips2();
					
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
						checkCell(curCellX2+3,curCellY2,1,1);
						checkCell(curCellX2+4,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
						checkCell(curCellX2,curCellY2+3,1,1);
						checkCell(curCellX2,curCellY2+4,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
						checkCell(curCellX2-3,curCellY2,1,1);
						checkCell(curCellX2-4,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
						checkCell(curCellX2,curCellY2-3,1,1);
						checkCell(curCellX2,curCellY2-4,1,1);
					}
				}
				
				/* Player 2 Right */
				if(read2 == 8)		// Right 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
						drawCell(curCellX2+3,curCellY2,0,1);
						drawCell(curCellX2+4,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
						drawCell(curCellX2,curCellY2+3,0,1);
						drawCell(curCellX2,curCellY2+4,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
						drawCell(curCellX2-3,curCellY2,0,1);
						drawCell(curCellX2-4,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
						drawCell(curCellX2,curCellY2-3,0,1);
						drawCell(curCellX2,curCellY2-4,0,1);
					}
					
					/* Move cursor right */
					curCellX2+=1;
					if(curCellX2>5 && orientation2==0)	curCellX2-=1;
					else if(curCellX2>9)	curCellX2-=1;
					
					
					// Redraw Ships
					drawShips2();
					
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
						checkCell(curCellX2+3,curCellY2,1,1);
						checkCell(curCellX2+4,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
						checkCell(curCellX2,curCellY2+3,1,1);
						checkCell(curCellX2,curCellY2+4,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
						checkCell(curCellX2-3,curCellY2,1,1);
						checkCell(curCellX2-4,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
						checkCell(curCellX2,curCellY2-3,1,1);
						checkCell(curCellX2,curCellY2-4,1,1);
					}
				}
				
				/* Player 2 Up */
				if(read2 == 16)		// Up 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
						drawCell(curCellX2+3,curCellY2,0,1);
						drawCell(curCellX2+4,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
						drawCell(curCellX2,curCellY2+3,0,1);
						drawCell(curCellX2,curCellY2+4,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
						drawCell(curCellX2-3,curCellY2,0,1);
						drawCell(curCellX2-4,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
						drawCell(curCellX2,curCellY2-3,0,1);
						drawCell(curCellX2,curCellY2-4,0,1);
					}
					
					/* Move cursor up */
					curCellY2-=1;
					if(curCellY2<4 && orientation2==3)	curCellY2+=1;
					else if(curCellY2>10)	curCellY2=0;
					
					
					// Redraw Ships
					drawShips2();
					
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
						checkCell(curCellX2+3,curCellY2,1,1);
						checkCell(curCellX2+4,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
						checkCell(curCellX2,curCellY2+3,1,1);
						checkCell(curCellX2,curCellY2+4,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
						checkCell(curCellX2-3,curCellY2,1,1);
						checkCell(curCellX2-4,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
						checkCell(curCellX2,curCellY2-3,1,1);
						checkCell(curCellX2,curCellY2-4,1,1);
					}
				}
				
				/* Player 2 Left */
				if(read2 == 32)		// Left 2
				{
					/* Clear current cell */
					drawCell(curCellX2,curCellY2,0,1);
					if(orientation2==0)
					{
						drawCell(curCellX2+1,curCellY2,0,1);
						drawCell(curCellX2+2,curCellY2,0,1);
						drawCell(curCellX2+3,curCellY2,0,1);
						drawCell(curCellX2+4,curCellY2,0,1);
					}
					else if(orientation2==1)
					{
						drawCell(curCellX2,curCellY2+1,0,1);
						drawCell(curCellX2,curCellY2+2,0,1);
						drawCell(curCellX2,curCellY2+3,0,1);
						drawCell(curCellX2,curCellY2+4,0,1);
					}
					else if(orientation2==2)
					{
						drawCell(curCellX2-1,curCellY2,0,1);
						drawCell(curCellX2-2,curCellY2,0,1);
						drawCell(curCellX2-3,curCellY2,0,1);
						drawCell(curCellX2-4,curCellY2,0,1);
					}
					else
					{
						drawCell(curCellX2,curCellY2-1,0,1);
						drawCell(curCellX2,curCellY2-2,0,1);
						drawCell(curCellX2,curCellY2-3,0,1);
						drawCell(curCellX2,curCellY2-4,0,1);
					}
					
					/* Move cursor left */
					curCellX2-=1;
					if(curCellX2<4 && orientation2==2)	curCellX2+=1;
					else if(curCellX2>10)	curCellX2=0;
					
					
					// Redraw Ships
					drawShips2();
					
					
					/* Draw current cell */
					checkCell(curCellX2,curCellY2,0,1);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation2==0)
					{
						checkCell(curCellX2+1,curCellY2,1,1);
						checkCell(curCellX2+2,curCellY2,1,1);
						checkCell(curCellX2+3,curCellY2,1,1);
						checkCell(curCellX2+4,curCellY2,1,1);
					}
					else if(orientation2==1)
					{
						checkCell(curCellX2,curCellY2+1,1,1);
						checkCell(curCellX2,curCellY2+2,1,1);
						checkCell(curCellX2,curCellY2+3,1,1);
						checkCell(curCellX2,curCellY2+4,1,1);
					}
					else if(orientation2==2)
					{
						checkCell(curCellX2-1,curCellY2,1,1);
						checkCell(curCellX2-2,curCellY2,1,1);
						checkCell(curCellX2-3,curCellY2,1,1);
						checkCell(curCellX2-4,curCellY2,1,1);
					}
					else
					{
						checkCell(curCellX2,curCellY2-1,1,1);
						checkCell(curCellX2,curCellY2-2,1,1);
						checkCell(curCellX2,curCellY2-3,1,1);
						checkCell(curCellX2,curCellY2-4,1,1);
					}
				}
			}
			
			/* Clear current cells */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
				drawCell(curCellX2+4,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
				drawCell(curCellX2,curCellY2+4,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
				drawCell(curCellX2-4,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
				drawCell(curCellX2,curCellY2-4,0,1);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX2,curCellY2,5,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,5,1);
				drawCell(curCellX2+2,curCellY2,5,1);
				drawCell(curCellX2+3,curCellY2,5,1);
				drawCell(curCellX2+4,curCellY2,5,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,5,1);
				drawCell(curCellX2,curCellY2+2,5,1);
				drawCell(curCellX2,curCellY2+3,5,1);
				drawCell(curCellX2,curCellY2+4,5,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,5,1);
				drawCell(curCellX2-2,curCellY2,5,1);
				drawCell(curCellX2-3,curCellY2,5,1);
				drawCell(curCellX2-4,curCellY2,5,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,5,1);
				drawCell(curCellX2,curCellY2-2,5,1);
				drawCell(curCellX2,curCellY2-3,5,1);
				drawCell(curCellX2,curCellY2-4,5,1);
			}
			
			/* Enter ship cell locations into location matrix */
			L2[curCellX2][curCellY2] = 1;
			if(orientation2==0)
			{
				L2[curCellX2+1][curCellY2]=1;
				L2[curCellX2+2][curCellY2]=1;
				L2[curCellX2+3][curCellY2]=1;
				L2[curCellX2+4][curCellY2]=1;
			}
			else if(orientation2==1)
			{
				L2[curCellX2][curCellY2+1]=1;
				L2[curCellX2][curCellY2+2]=1;
				L2[curCellX2][curCellY2+3]=1;
				L2[curCellX2][curCellY2+4]=1;
			}
			else if(orientation2==2)
			{
				L2[curCellX2-1][curCellY2]=1;
				L2[curCellX2-2][curCellY2]=1;
				L2[curCellX2-3][curCellY2]=1;
				L2[curCellX2-4][curCellY2]=1;
			}
			else
			{
				L2[curCellX2][curCellY2-1]=1;
				L2[curCellX2][curCellY2-2]=1;
				L2[curCellX2][curCellY2-3]=1;
				L2[curCellX2][curCellY2-4]=1;
			}
		}
		
		else						// if player 2 pressed select then allow player 1 to finish entering ship length=2
		{
			/* Clear current cells */
			drawCell(curCellX2,curCellY2,0,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,0,1);
				drawCell(curCellX2+2,curCellY2,0,1);
				drawCell(curCellX2+3,curCellY2,0,1);
				drawCell(curCellX2+4,curCellY2,0,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,0,1);
				drawCell(curCellX2,curCellY2+2,0,1);
				drawCell(curCellX2,curCellY2+3,0,1);
				drawCell(curCellX2,curCellY2+4,0,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,0,1);
				drawCell(curCellX2-2,curCellY2,0,1);
				drawCell(curCellX2-3,curCellY2,0,1);
				drawCell(curCellX2-4,curCellY2,0,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,0,1);
				drawCell(curCellX2,curCellY2-2,0,1);
				drawCell(curCellX2,curCellY2-3,0,1);
				drawCell(curCellX2,curCellY2-4,0,1);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX2,curCellY2,5,1);
			if(orientation2==0)
			{
				drawCell(curCellX2+1,curCellY2,5,1);
				drawCell(curCellX2+2,curCellY2,5,1);
				drawCell(curCellX2+3,curCellY2,5,1);
				drawCell(curCellX2+4,curCellY2,5,1);
			}
			else if(orientation2==1)
			{
				drawCell(curCellX2,curCellY2+1,5,1);
				drawCell(curCellX2,curCellY2+2,5,1);
				drawCell(curCellX2,curCellY2+3,5,1);
				drawCell(curCellX2,curCellY2+4,5,1);
			}
			else if(orientation2==2)
			{
				drawCell(curCellX2-1,curCellY2,5,1);
				drawCell(curCellX2-2,curCellY2,5,1);
				drawCell(curCellX2-3,curCellY2,5,1);
				drawCell(curCellX2-4,curCellY2,5,1);
			}
			else
			{
				drawCell(curCellX2,curCellY2-1,5,1);
				drawCell(curCellX2,curCellY2-2,5,1);
				drawCell(curCellX2,curCellY2-3,5,1);
				drawCell(curCellX2,curCellY2-4,5,1);
			}
			
			/* Enter ship cell locations into location matrix */
			L2[curCellX2][curCellY2] = 1;
			if(orientation2==0)
			{
				L2[curCellX2+1][curCellY2]=1;
				L2[curCellX2+2][curCellY2]=1;
				L2[curCellX2+3][curCellY2]=1;
				L2[curCellX2+4][curCellY2]=1;
			}
			else if(orientation2==1)
			{
				L2[curCellX2][curCellY2+1]=1;
				L2[curCellX2][curCellY2+2]=1;
				L2[curCellX2][curCellY2+3]=1;
				L2[curCellX2][curCellY2+4]=1;
			}
			else if(orientation2==2)
			{
				L2[curCellX2-1][curCellY2]=1;
				L2[curCellX2-2][curCellY2]=1;
				L2[curCellX2-3][curCellY2]=1;
				L2[curCellX2-4][curCellY2]=1;
			}
			else
			{
				L2[curCellX2][curCellY2-1]=1;
				L2[curCellX2][curCellY2-2]=1;
				L2[curCellX2][curCellY2-3]=1;
				L2[curCellX2][curCellY2-4]=1;
			}
				
			while(read1 != 1 || checkTaken4(curCellX1,curCellY1,0))
			{
				read1 = readEdge(PlayIn1);
				clearEdge(PlayIn1);
				
				/* Rotate Player 1 */
				if(read1 == 2)		// Rotate 1
				{
					/* Rotate */
					if(orientation1==0)			// right
					{
						if(curCellY1<6)			// cannot rotate from right to down if current cell is in bottom two rows
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1+1,curCellY1,0,0);
							drawCell(curCellX1+2,curCellY1,0,0);
							drawCell(curCellX1+3,curCellY1,0,0);
							drawCell(curCellX1+4,curCellY1,0,0);
							
							
							// Redraw Ships
							drawShips1();
							
							
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1,curCellY1+1,1,0);
							checkCell(curCellX1,curCellY1+2,1,0);
							checkCell(curCellX1,curCellY1+3,1,0);
							checkCell(curCellX1,curCellY1+4,1,0);
						}
					}
					else if(orientation1==1)		// down
					{
						if(curCellX1>3)		// cannot rotate from down to left if current cell is in first column
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1,curCellY1+1,0,0);
							drawCell(curCellX1,curCellY1+2,0,0);
							drawCell(curCellX1,curCellY1+3,0,0);
							drawCell(curCellX1,curCellY1+4,0,0);
							
							
							// Redraw Ships
							drawShips1();
							
							
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1-1,curCellY1,1,0);
							checkCell(curCellX1-2,curCellY1,1,0);
							checkCell(curCellX1-3,curCellY1,1,0);
							checkCell(curCellX1-4,curCellY1,1,0);
						}
					}
					else if(orientation1==2)		// left
					{
						if(curCellY1>3)
						{
							// update orientation
							orientation1+=1;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1-1,curCellY1,0,0);
							drawCell(curCellX1-2,curCellY1,0,0);
							drawCell(curCellX1-3,curCellY1,0,0);
							drawCell(curCellX1-4,curCellY1,0,0);
							
							
							// Redraw Ships
							drawShips1();
							
							
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1,curCellY1-1,1,0);
							checkCell(curCellX1,curCellY1-2,1,0);
							checkCell(curCellX1,curCellY1-3,1,0);
							checkCell(curCellX1,curCellY1-4,1,0);
						}
					}
					else						// up
					{
						if(curCellX1<6)
						{
							// update orientation
							orientation1=0;
							
							// clear current cells
							drawCell(curCellX1,curCellY1,0,0);
							drawCell(curCellX1,curCellY1-1,0,0);
							drawCell(curCellX1,curCellY1-2,0,0);
							drawCell(curCellX1,curCellY1-3,0,0);
							drawCell(curCellX1,curCellY1-4,0,0);
							
							
							// Redraw Ships
							drawShips1();
							
							
							// draw new cells
							checkCell(curCellX1,curCellY1,0,0);
							checkCell(curCellX1+1,curCellY1,1,0);
							checkCell(curCellX1+2,curCellY1,1,0);
							checkCell(curCellX1+3,curCellY1,1,0);
							checkCell(curCellX1+4,curCellY1,1,0);
						}
					}
				}
				
				/* Player 1 Down */
				if(read1 == 4)		// Down 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
						drawCell(curCellX1+3,curCellY1,0,0);
						drawCell(curCellX1+4,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
						drawCell(curCellX1,curCellY1+3,0,0);
						drawCell(curCellX1,curCellY1+4,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
						drawCell(curCellX1-3,curCellY1,0,0);
						drawCell(curCellX1-4,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
						drawCell(curCellX1,curCellY1-3,0,0);
						drawCell(curCellX1,curCellY1-4,0,0);
					}
					
					/* Move cursor down */
					curCellY1+=1;
					if(curCellY1>5 && orientation1==1)	curCellY1-=1;
					else if(curCellY1>9)	curCellY1-=1;
					
					
					// Redraw Ships
					drawShips1();
					
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
						checkCell(curCellX1+3,curCellY1,1,0);
						checkCell(curCellX1+4,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
						checkCell(curCellX1,curCellY1+3,1,0);
						checkCell(curCellX1,curCellY1+4,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
						checkCell(curCellX1-3,curCellY1,1,0);
						checkCell(curCellX1-4,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
						checkCell(curCellX1,curCellY1-3,1,0);
						checkCell(curCellX1,curCellY1-4,1,0);
					}
				}
				
				/* Player 1 Right */
				if(read1 == 8)		// Right 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
						drawCell(curCellX1+3,curCellY1,0,0);
						drawCell(curCellX1+4,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
						drawCell(curCellX1,curCellY1+3,0,0);
						drawCell(curCellX1,curCellY1+4,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
						drawCell(curCellX1-3,curCellY1,0,0);
						drawCell(curCellX1-4,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
						drawCell(curCellX1,curCellY1-3,0,0);
						drawCell(curCellX1,curCellY1-4,0,0);
					}
					
					/* Move cursor right */
					curCellX1+=1;
					if(curCellX1>5 && orientation1==0)	curCellX1-=1;
					else if(curCellX1>9)	curCellX1-=1;
					
					
					// Redraw Ships
					drawShips1();
					
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
						checkCell(curCellX1+3,curCellY1,1,0);
						checkCell(curCellX1+4,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
						checkCell(curCellX1,curCellY1+3,1,0);
						checkCell(curCellX1,curCellY1+4,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
						checkCell(curCellX1-3,curCellY1,1,0);
						checkCell(curCellX1-4,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
						checkCell(curCellX1,curCellY1-3,1,0);
						checkCell(curCellX1,curCellY1-4,1,0);
					}
				}
				
				/* Player 1 Up */
				if(read1 == 16)		// Up 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
						drawCell(curCellX1+3,curCellY1,0,0);
						drawCell(curCellX1+4,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
						drawCell(curCellX1,curCellY1+3,0,0);
						drawCell(curCellX1,curCellY1+4,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
						drawCell(curCellX1-3,curCellY1,0,0);
						drawCell(curCellX1-4,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
						drawCell(curCellX1,curCellY1-3,0,0);
						drawCell(curCellX1,curCellY1-4,0,0);
					}
					
					/* Move cursor up */
					curCellY1-=1;
					if(curCellY1<4 && orientation1==3)	curCellY1+=1;
					else if(curCellY1>10)	curCellY1=0;
					
					
					// Redraw Ships
					drawShips1();
					
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
						checkCell(curCellX1+3,curCellY1,1,0);
						checkCell(curCellX1+4,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
						checkCell(curCellX1,curCellY1+3,1,0);
						checkCell(curCellX1,curCellY1+4,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
						checkCell(curCellX1-3,curCellY1,1,0);
						checkCell(curCellX1-4,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
						checkCell(curCellX1,curCellY1-3,1,0);
						checkCell(curCellX1,curCellY1-4,1,0);
					}
				}
				
				/* Player 1 Left */
				if(read1 == 32)		// Left 1
				{
					/* Clear current cell */
					drawCell(curCellX1,curCellY1,0,0);
					if(orientation1==0)
					{
						drawCell(curCellX1+1,curCellY1,0,0);
						drawCell(curCellX1+2,curCellY1,0,0);
						drawCell(curCellX1+3,curCellY1,0,0);
						drawCell(curCellX1+4,curCellY1,0,0);
					}
					else if(orientation1==1)
					{
						drawCell(curCellX1,curCellY1+1,0,0);
						drawCell(curCellX1,curCellY1+2,0,0);
						drawCell(curCellX1,curCellY1+3,0,0);
						drawCell(curCellX1,curCellY1+4,0,0);
					}
					else if(orientation1==2)
					{
						drawCell(curCellX1-1,curCellY1,0,0);
						drawCell(curCellX1-2,curCellY1,0,0);
						drawCell(curCellX1-3,curCellY1,0,0);
						drawCell(curCellX1-4,curCellY1,0,0);
					}
					else
					{
						drawCell(curCellX1,curCellY1-1,0,0);
						drawCell(curCellX1,curCellY1-2,0,0);
						drawCell(curCellX1,curCellY1-3,0,0);
						drawCell(curCellX1,curCellY1-4,0,0);
					}
					
					/* Move cursor left */
					curCellX1-=1;
					if(curCellX1<4 && orientation1==2)	curCellX1+=1;
					else if(curCellX1>10)	curCellX1=0;
					
					
					// Redraw Ships
					drawShips1();
					
					
					/* Draw current cell */
					checkCell(curCellX1,curCellY1,0,0);
					
					/* Draw rest of ship location based on current orientation */
					if(orientation1==0)
					{
						checkCell(curCellX1+1,curCellY1,1,0);
						checkCell(curCellX1+2,curCellY1,1,0);
						checkCell(curCellX1+3,curCellY1,1,0);
						checkCell(curCellX1+4,curCellY1,1,0);
					}
					else if(orientation1==1)
					{
						checkCell(curCellX1,curCellY1+1,1,0);
						checkCell(curCellX1,curCellY1+2,1,0);
						checkCell(curCellX1,curCellY1+3,1,0);
						checkCell(curCellX1,curCellY1+4,1,0);
					}
					else if(orientation1==2)
					{
						checkCell(curCellX1-1,curCellY1,1,0);
						checkCell(curCellX1-2,curCellY1,1,0);
						checkCell(curCellX1-3,curCellY1,1,0);
						checkCell(curCellX1-4,curCellY1,1,0);
					}
					else
					{
						checkCell(curCellX1,curCellY1-1,1,0);
						checkCell(curCellX1,curCellY1-2,1,0);
						checkCell(curCellX1,curCellY1-3,1,0);
						checkCell(curCellX1,curCellY1-4,1,0);
					}
				}
			}
			
			/* Clear current cells */
			drawCell(curCellX1,curCellY1,0,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,0,0);
				drawCell(curCellX1+2,curCellY1,0,0);
				drawCell(curCellX1+3,curCellY1,0,0);
				drawCell(curCellX1+4,curCellY1,0,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,0,0);
				drawCell(curCellX1,curCellY1+2,0,0);
				drawCell(curCellX1,curCellY1+3,0,0);
				drawCell(curCellX1,curCellY1+4,0,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,0,0);
				drawCell(curCellX1-2,curCellY1,0,0);
				drawCell(curCellX1-3,curCellY1,0,0);
				drawCell(curCellX1-4,curCellY1,0,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,0,0);
				drawCell(curCellX1,curCellY1-2,0,0);
				drawCell(curCellX1,curCellY1-3,0,0);
				drawCell(curCellX1,curCellY1-4,0,0);
			}
				
			/* Draw current cells as selected ship locations */
			drawCell(curCellX1,curCellY1,5,0);
			if(orientation1==0)
			{
				drawCell(curCellX1+1,curCellY1,5,0);
				drawCell(curCellX1+2,curCellY1,5,0);
				drawCell(curCellX1+3,curCellY1,5,0);
				drawCell(curCellX1+4,curCellY1,5,0);
			}
			else if(orientation1==1)
			{
				drawCell(curCellX1,curCellY1+1,5,0);
				drawCell(curCellX1,curCellY1+2,5,0);
				drawCell(curCellX1,curCellY1+3,5,0);
				drawCell(curCellX1,curCellY1+4,5,0);
			}
			else if(orientation1==2)
			{
				drawCell(curCellX1-1,curCellY1,5,0);
				drawCell(curCellX1-2,curCellY1,5,0);
				drawCell(curCellX1-3,curCellY1,5,0);
				drawCell(curCellX1-4,curCellY1,5,0);
			}
			else
			{
				drawCell(curCellX1,curCellY1-1,5,0);
				drawCell(curCellX1,curCellY1-2,5,0);
				drawCell(curCellX1,curCellY1-3,5,0);
				drawCell(curCellX1,curCellY1-4,5,0);
			}
			
			/* Enter ship cell locations into location matrix */
			L1[curCellX1][curCellY1]=1;
			if(orientation1==0)
			{
				L1[curCellX1+1][curCellY1]=1;
				L1[curCellX1+2][curCellY1]=1;
				L1[curCellX1+3][curCellY1]=1;
				L1[curCellX1+4][curCellY1]=1;
			}
			else if(orientation1==1)
			{
				L1[curCellX1][curCellY1+1]=1;
				L1[curCellX1][curCellY1+2]=1;
				L1[curCellX1][curCellY1+3]=1;
				L1[curCellX1][curCellY1+4]=1;
			}
			else if(orientation1==2)
			{
				L1[curCellX1-1][curCellY1]=1;
				L1[curCellX1-2][curCellY1]=1;
				L1[curCellX1-3][curCellY1]=1;
				L1[curCellX1-4][curCellY1]=1;
			}
			else
			{
				L1[curCellX1][curCellY1-1]=1;
				L1[curCellX1][curCellY1-2]=1;
				L1[curCellX1][curCellY1-3]=1;
				L1[curCellX1][curCellY1-4]=1;
			}
		}
}


/*** Player 1 enter new strike ***/
void player1Strike(void)
{
	clearScreen();		// clear both screens
	drawGrid();			// draw grid on both screens
	drawShips2();		// draw player 2 ships on player 2 screen
	drawShots1();		// draw player 1 shots on player 2 ships on both screens
	enterStrike1();		// player 1 enter new strike coordinates
}


/*** Player 2 enter new strike ***/
void player2Strike(void)
{
	clearScreen();		// clear both screens
	drawGrid();			// draw grid on both screens
	drawShips1();		// draw player 1 ships on player 1 screen
	drawShots2();		// draw player 2 shots on player 1 ships on both screens
	enterStrike2();		// player 2 enter new strike coordinates
}


/*** Player 1's turn to enter a new strike ***/
void enterStrike1(void)
{
	curCellX1=0;	// set player 1 current cell x-coordinate to 0
	curCellY1=0;	// set player 1 current cell y-coordinate to 0
	read1=0;		// set read1 to nothing read yet
	drawCell(curCellX1,curCellY1,1,0);	// draw current cell
	
	while( (read1 != 1) || checkTaken(curCellX1, curCellY1, 0) )
	{
		read1 = readEdge(PlayIn1);
		clearEdge(PlayIn1);
		
		// Down
		if(read1 == 4)
		{
			if(curCellY1<9)
			{
				// clear current cell
				drawCell(curCellX1,curCellY1,0,0);
				
				// update coordinates
				curCellY1+=1;
				
				// draw shots
				drawShots1();
				
				// draw new cell
				drawCell(curCellX1,curCellY1,1,0);
			}
		}
		
		// Right
		else if(read1 == 8)
		{
			if(curCellX1<9)
			{
				// clear current cell
				drawCell(curCellX1,curCellY1,0,0);
				
				// update coordinates
				curCellX1+=1;
				
				// draw shots
				drawShots1();
				
				// draw new cell
				drawCell(curCellX1,curCellY1,1,0);
			}
		}
		
		// Up
		else if(read1 == 16)
		{
			if(curCellY1>0)
			{
				// clear current cell
				drawCell(curCellX1,curCellY1,0,0);
				
				// update coordinates
				curCellY1-=1;
				
				// draw shots
				drawShots1();
				
				// draw new cell
				drawCell(curCellX1,curCellY1,1,0);
			}
		}
		
		// Left
		else if(read1 == 32)
		{
			if(curCellX1>0)
			{
				// clear current cell
				drawCell(curCellX1,curCellY1,0,0);
				
				// update coordinates
				curCellX1-=1;
				
				// draw shots
				drawShots1();
				
				// draw new cell
				drawCell(curCellX1,curCellY1,1,0);
			}
		}
	}
	
	
	// clear current cell
	drawCell(curCellX1,curCellY1,0,0);
	
	
	// check if hit or miss and update accordingly
	if(checkHit())
	{
		drawCell(curCellX1,curCellY1,4,0);
		drawCell(curCellX1,curCellY1,4,1);
		S1[curCellX1][curCellY1] = 1;
		hitCount1+=1;
	}
	else
	{
		drawCell(curCellX1,curCellY1,3,0);
		drawCell(curCellX1,curCellY1,3,1);
		S1[curCellX1][curCellY1] = 2;
	}
	
	
	
	unsigned long count1 = 5;
	unsigned long count2 = 50000000;
	int i=0;
	int j=0;
	while(i<count1)
	{
		i++;
		while(j<count2)
		{
			j++;
		}
	}
	
	// wait for player 2 to be ready to input strike
	/*read2=0;	// clear player 2 read input
	while(read2 != 2)
	{
		read2 = readEdge(PlayIn2);
		clearEdge(PlayIn2);
	}*/
}


/*** Player 2's turn to enter a new strike ***/
void enterStrike2(void)
{
	curCellX2=0;	// set player 1 current cell x-coordinate to 0
	curCellY2=0;	// set player 1 current cell y-coordinate to 0
	read2=0;		// set read1 to nothing read yet
	drawCell(curCellX2,curCellY2,1,1);	// draw current cell
	
	while( (read2 != 1) || checkTaken(curCellX2, curCellY2, 1) )
	{
		read2 = readEdge(PlayIn2);
		clearEdge(PlayIn2);
		
		// Down
		if(read2 == 4)
		{
			if(curCellY2<9)
			{
				// clear current cell
				drawCell(curCellX2,curCellY2,0,1);
				
				// update coordinates
				curCellY2+=1;
				
				// draw shots
				drawShots2();
				
				// draw new cell
				drawCell(curCellX2,curCellY2,1,1);
			}
		}
		
		// Right
		else if(read2 == 8)
		{
			if(curCellX2<9)
			{
				// clear current cell
				drawCell(curCellX2,curCellY2,0,1);
				
				// update coordinates
				curCellX2+=1;
				
				// draw shots
				drawShots2();
				
				// draw new cell
				drawCell(curCellX2,curCellY2,1,1);
			}
		}
		
		// Up
		else if(read2 == 16)
		{
			if(curCellY2>0)
			{
				// clear current cell
				drawCell(curCellX2,curCellY2,0,1);
				
				// update coordinates
				curCellY2-=1;
				
				// draw shots
				drawShots2();
				
				// draw new cell
				drawCell(curCellX2,curCellY2,1,1);
			}
		}
		
		// Left
		else if(read2 == 32)
		{
			if(curCellX2>0)
			{
				// clear current cell
				drawCell(curCellX2,curCellY2,0,1);
				
				// update coordinates
				curCellX2-=1;
				
				// draw shots
				drawShots2();
				
				// draw new cell
				drawCell(curCellX2,curCellY2,1,1);
			}
		}
	}
	
	
	// clear current cell
	drawCell(curCellX2,curCellY2,0,0);
	
	
	// check if hit or miss and update accordingly
	if(checkHit())
	{
		drawCell(curCellX2,curCellY2,4,0);
		drawCell(curCellX2,curCellY2,4,1);
		S2[curCellX2][curCellY2] = 1;
		hitCount2+=1;
	}
	else
	{
		drawCell(curCellX2,curCellY2,3,0);
		drawCell(curCellX2,curCellY2,3,1);
		S2[curCellX2][curCellY2] = 2;
	}
	
	
	unsigned long count1 = 5;
	unsigned long count2 = 50000000;
	int i=0;
	int j=0;
	while(i<count1)
	{
		i++;
		while(j<count2)
		{
			j++;
		}
	}
	
	// wait for player 2 to be ready to input strike
	/*read1=0;	// clear player 2 read input
	while(read1 != 2)
	{
		read1 = readEdge(PlayIn1);
		clearEdge(PlayIn1);
	}*/
}


/*** Check to see if strike coordinates are a hit or a miss ***/
unsigned int checkHit(void)
{
	if(turn==0)
	{
		if(L2[curCellX1][curCellY1])
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else
	{
		if(L1[curCellX2][curCellY2])
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
}


/*** Draw a red cell (cell taken), yellow cell (current cell), or silver cell (trailing cell) ***/
void checkCell(unsigned int x, unsigned int y, unsigned int cur, unsigned int player)	// curCellX, curCellY, current cell (0) or trailing cell (1), player 1 or 2
{
	if(player == 0)		// player 1
	{
		if(!L1[x][y])	// if cell is not taken
		{
			if(!cur)	// if cell is current cell
			{
				drawCell(x,y,1,0);	// draw player 1 current cell
			}
			else
			{
				drawCell(x,y,2,0);	// draw player 1 trailing cell
			}
		}
		else			// if cell is taken
		{
			drawCell(x,y,4,0);
		}
	}
	else
	{
		if(!L2[x][y])	// if cell is not taken
		{
			if(!cur)	// if cell is current cell
			{
				drawCell(x,y,1,1);	// draw player 1 current cell
			}
			else
			{
				drawCell(x,y,2,1);	// draw player 1 trailing cell
			}
		}
		else			// if cell is taken
		{
			drawCell(x,y,4,1);
		}
	}
}


/*** Check to see if cell in shot matrix is taken when entering strikes ***/
unsigned int checkTaken(unsigned int x, unsigned int y, unsigned int player)
{
	if(!player)
	{
		if(S1[x][y])
			return 1;
		else
			return 0;
	}
	else
	{
		if(S2[x][y])
			return 1;
		else
			return 0;
	}
}


/*** Check to see if any cell in ship length=3 is in a taken cell ***/
unsigned int checkTaken3(unsigned int x, unsigned int y, unsigned int player)
{
	if(!player)
	{
		if(orientation1==0)
			return L1[x][y] || L1[x+1][y] || L1[x+2][y];
		else if(orientation1==1)
			return L1[x][y] || L1[x][y+1] || L1[x][y+2];
		else if(orientation1==2)
			return L1[x][y] || L1[x-1][y] || L1[x-2][y];
		else
			return L1[x][y] || L1[x][y-1] || L1[x][y-2];
	}
	else
	{
		if(orientation2==0)
			return L2[x][y] || L2[x+1][y] || L2[x+2][y];
		else if(orientation2==1)
			return L2[x][y] || L2[x][y+1] || L2[x][y+2];
		else if(orientation2==2)
			return L2[x][y] || L2[x-1][y] || L2[x-2][y];
		else
			return L2[x][y] || L2[x][y-1] || L2[x][y-2];
	}
}


/*** Check to see if any cell in ship length=4 is in a taken cell ***/
unsigned int checkTaken4(unsigned int x, unsigned int y, unsigned int player)
{
	if(!player)
	{
		if(orientation1==0)
			return L1[x][y] || L1[x+1][y] || L1[x+2][y] || L1[x+3][y];
		else if(orientation1==1)
			return L1[x][y] || L1[x][y+1] || L1[x][y+2] || L1[x][y+3];
		else if(orientation1==2)
			return L1[x][y] || L1[x-1][y] || L1[x-2][y] || L1[x-3][y];
		else
			return L1[x][y] || L1[x][y-1] || L1[x][y-2] || L1[x][y-3];
	}
	else
	{
		if(orientation2==0)
			return L2[x][y] || L2[x+1][y] || L2[x+2][y] || L2[x+3][y];
		else if(orientation2==1)
			return L2[x][y] || L2[x][y+1] || L2[x][y+2] || L2[x][y+3];
		else if(orientation2==2)
			return L2[x][y] || L2[x-1][y] || L2[x-2][y] || L2[x-3][y];
		else
			return L2[x][y] || L2[x][y-1] || L2[x][y-2] || L2[x][y-3];
	}
}


/*** Check to see if any cell in ship length=5 is in a taken cell ***/
unsigned int checkTaken5(unsigned int x, unsigned int y, unsigned int player)
{
	if(!player)
	{
		if(orientation1==0)
			return L1[x][y] || L1[x+1][y] || L1[x+2][y] || L1[x+3][y] || L1[x+4][y];
		else if(orientation1==1)
			return L1[x][y] || L1[x][y+1] || L1[x][y+2] || L1[x][y+3] || L1[x][y+4];
		else if(orientation1==2)
			return L1[x][y] || L1[x-1][y] || L1[x-2][y] || L1[x-3][y] || L1[x-4][y];
		else
			return L1[x][y] || L1[x][y-1] || L1[x][y-2] || L1[x][y-3] || L1[x][y-3];
	}
	else
	{
		if(orientation2==0)
			return L2[x][y] || L2[x+1][y] || L2[x+2][y] || L2[x+3][y] || L2[x+4][y];
		else if(orientation2==1)
			return L2[x][y] || L2[x][y+1] || L2[x][y+2] || L2[x][y+3] || L2[x][y+4];
		else if(orientation2==2)
			return L2[x][y] || L2[x-1][y] || L2[x-2][y] || L2[x-3][y] || L2[x-4][y];
		else
			return L2[x][y] || L2[x][y-1] || L2[x][y-2] || L2[x][y-3] || L2[x][y-4];
	}
}


/*** Draw player 1's ships on screen 1 ***/
void drawShips1(void)
{
	int i;
	int j;
	for(i=0;i<10;i++)
	{
		for(j=0;j<10;j++)
		{
			if(L1[i][j])
				drawCell(i,j,5,0);
		}
	}
}


/*** Draw player 2's ships on screen 2 ***/
void drawShips2(void)
{
	int i;
	int j;
	for(i=0;i<10;i++)
	{
		for(j=0;j<10;j++)
		{
			if(L2[i][j])
				drawCell(i,j,5,1);
		}
	}
}


/*** Draw misses and hits (player 1 ships) when player 2 is striking ***/
void drawShots1(void)
{
	int i;
	int j;
	for(i=0; i<10; i++)
	{
		for(j=0; j<10; j++)
		{
			if(S1[i][j] == 1)
			{
				drawCell(i,j,4,0);
				drawCell(i,j,4,1);
			}
			else if(S1[i][j] == 2)
			{
				drawCell(i,j,3,0);
				drawCell(i,j,3,1);
			}
		}
	}
}


/*** Draw misses and hits (player 2 ships) when player 1 is striking ***/
void drawShots2(void)
{
	int i;
	int j;
	for(i=0; i<10; i++)
	{
		for(j=0; j<10; j++)
		{
			if(S2[i][j] == 1)
			{
				drawCell(i,j,4,0);
				drawCell(i,j,4,1);
			}
			else if(S2[i][j] == 2)
			{
				drawCell(i,j,3,0);
				drawCell(i,j,3,1);
			}
		}
	}
}


/*** Return 1 when one player has obtained 17 hit strikes, return 0 otherwise ***/
unsigned int gameOver(void)
{
	if(hitCount1 >= 17 || hitCount2 >= 17)
		return 1;
	else
		return 0;
}


/*** Display red on loser's screen and red on winner's screen ***/
void displayWinLose(void)
{
	unsigned int winner;
	if(hitCount1 >= 17)
		winner=0;
	else
		winner=1;
	
	int i;
	int j;
	for(i=0;i<SCREEN_RES_Y;i++)
	{
		for(j=0;j<SCREEN_RES_X;j++)
		{
			drawPixel(j,i,GREEN,winner);	// winner screen -> green
			drawPixel(j,i,RED,!winner);		// loser screen -> red
		}
	}
	
	/*
	// Clear both screens
	//clearScreen();
	
	// Display WIN on winner's screen
	
	// W
	drawVLine(67,21,200,winner);
	drawHLine(67,221,30,winner);
	drawVLine(97,21,200,winner);
	drawHLine(97,221,30,winner);
	drawVLine(127,21,200,winner);
	
	// I
	drawVLine(157,21,200,winner);
	
	// N
	drawVLine(186,21,200,winner);
	drawHLine(187,20,40,winner);
	drawVLine(228,21,200,winner);
	
	
	// Display LOSE on loser's screen
	
	// L
	drawVLine(20,21,200,!winner);
	drawHLine(20,221,25,!winner);
	
	// O
	drawVLine(75,21,200,!winner);
	drawVLine(100,21,200,!winner);
	drawHLine(75,21,25,!winner);
	drawHLine(75,221,25,!winner);
	
	// S
	drawHLine(125,21,25,!winner);
	drawVLine(125,21,100,!winner);
	drawVLine(150,121,100,!winner);
	drawHLine(125,121,25,!winner);
	drawHLine(125,221,25,!winner);
	
	// E
	drawVLine(175,21,200,!winner);
	drawHLine(175,21,25,!winner);
	drawHLine(175,121,25,!winner);
	drawHLine(175,221,25,!winner);*/
}


/*** Wait until either player presses any button then reset game ***/
void playAgain(void)
{
	read1 = 0;
	read2 = 0;
	while(!read1 && !read2)	// while neither player presses any button
	{
		read1 = readEdge(PlayIn1);
		read2 = readEdge(PlayIn2);
		clearEdge(PlayIn1);
		clearEdge(PlayIn2);
	}
}


/*** Draw a pixel of designated color and input x and y coordinates on chosen player's screen ***/
void drawPixel(unsigned int x, unsigned int y, unsigned int colorVal, unsigned char player)
{
	writeIO(X_out, x);
	writeIO(Y_out, y);
	writeIO(COLOR, colorVal);
	writeIO(Play_out, player);
	while(!(readIO(Wait)));
	writeIO(Data_Ready, 1);
	writeIO(Data_Ready, 0);
}


/*** Draw vertical line with designated length at x0 and y0 starting coordinates ***/
void drawVLine(unsigned int x0, unsigned int y0, unsigned int length, unsigned int player)
{
	int i;
	for(i=x0; i<length+y0; i++)
	{
		drawPixel(x0-1,y0+i,WHITE,player);
		drawPixel(x0,y0+i,WHITE,player);
	}
}


/*** Draw horizontal line with designated length at x0 and y0 starting coordinates ***/
void drawHLine(unsigned int x0, unsigned int y0, unsigned int length, unsigned int player)
{
	int i;
	for(i=y0; i<length+x0; i++)
	{
		drawPixel(x0+length,y0-1,WHITE,player);
		drawPixel(x0+length,y0,WHITE,player);
	}
}


/*** Draw a pixel of the designated color in every location of the 10x10 pixel grid cell ***/
void drawCell(unsigned int cellX, unsigned int cellY, unsigned int type, unsigned char player)
{
	// type: 0=clear (blue), 1=current cell (yellow), 2=ship location while entering (silver), 3=miss (green), 4=hit/cell taken (red), 5=ship location when set (black)
	int i;
	int j;
	for(i=(cellX*20)+VLINE1_START+2;i<(cellX*20)+VLINE1_START+20;i++)
	{
		for(j=(cellY*20)+HLINE_START+2;j<(cellY*20)+HLINE_START+20;j++)
		{
			if(type==0)
			{
				drawPixel(i,j,BLUE,player);
			}
			else if(type==1)
			{
				drawPixel(i,j,YELLOW,player);
			}
			else if(type==2)
			{
				drawPixel(i,j,SILVER,player);
			}
			else if(type==3)
			{
				drawPixel(i,j,GREEN,player);
			}
			else if(type==4)
			{
				drawPixel(i,j,RED,player);
			}
			else if(type==5)
			{
				drawPixel(i,j,BLACK,player);
			}
		}
	}	
}


