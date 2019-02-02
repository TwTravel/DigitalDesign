/****************************************
 *	NTSC Parameters (square wave)			*
 *	Michael Ross and Joshua Schwartz		*
 *	ECE 5760										*
 ****************************************/ 

// Output Level Parameters
parameter SYNC_LEVEL	=	10'h0;		// 0 - -40 IRE
parameter ZERO_LEVEL	=	10'hD1;		// 209 - 0 IRE
parameter BLACK_LEVEL	=	10'hF8;		// 248 - 7.5 IRE
parameter WHITE_LEVEL	=	10'h2DB;	// 731 - 100 IRE
parameter OFFSET			= 10'hB;		// Allows intensity (0-511) to be added directly into Zero Level
parameter BURST_LEVEL	= 10'h68;	// 104 - 20 IRE
// Horizontal Parameters: total = 3420
parameter FRONT_PORCH_T	=	81;
parameter H_SYNC_T		=	252 + FRONT_PORCH_T;
parameter BACK_PORCH_T	=	252 + H_SYNC_T;
parameter BREEZEWAY_T	=	62 + H_SYNC_T;
parameter COLORBURST_T	= 135 + BREEZEWAY_T;
parameter VIDEO_T		=	2835 + BACK_PORCH_T;
parameter HALF_T		=	1709;
// V.Sync Parameters
parameter EQ_T			=	136;	// .04H (low, x2)
parameter V_SYNC_T		=	239;	// .07H (high, x2)
parameter BLANK_LINES	=	4;
parameter SYNC_LINES	=	3 + BLANK_LINES;

// Screen Size
parameter RES_X			=	315;
parameter PIXEL_T		=	9;
parameter RES_Y			=	242;
parameter TOTAL_Y		=	262;

// Color Bar Test
parameter CB_SIZE			= 40*PIXEL_T;
parameter C_SIZE			= 189;
