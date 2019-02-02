/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// Horizontal Parameter ( Pixel )
parameter H_SYNC_CYC   = 95;
parameter H_SYNC_BACK  = 60;
parameter H_SYNC_ACT   = 640; // 640 pixels of content
parameter H_SYNC_FRONT = 5;
parameter H_SYNC_MAX   = 799; // 800 effective pixels (cycles)

// Virtical Parameter ( Line )
parameter V_SYNC_CYC   = 2;
parameter V_SYNC_BACK  = 31;
parameter V_SYNC_ACT   = 480; // 480 lines of content
parameter V_SYNC_FRONT = 12;
parameter V_SYNC_MAX   = 524; // 525 effective lines

// Start Offset
parameter X_START      = H_SYNC_CYC + H_SYNC_BACK;
parameter Y_START      = V_SYNC_CYC + V_SYNC_BACK;

// Latency
// If you want to set iRed one 25.2MHz cycle after oAddress, oCoord_X, and
// Coord_Y are set, then choose 1. If you want to set iRed two cycles after
// oAddress etc. are set, then choose 2. If you instead want to set iRed as
// combinationally dependent on oAddress, then choose 0.
parameter X_LATENCY    = 3;

// About oSystemState:
// 
// If you store a pixel as 16 bits in SRAM, then whenever oSystemState[0] is
// 0, you need to read a new 16-bit word from SRAM. Otherwise the rest of the
// circuit can drive SRAM.
// 
// If you store a pixel as 8 bits in SRAM, then whenever oSystemState[1:0] is
// 0, you need to read a new 16-bit word from SRAM, which will last you for the
// next pixel as well. Otherwise the rest of the circuit can drive SRAM.
// 
// If you store a pixel as 4 bits in SRAM, then whenever oSystemState[2:0] is
// 0, you need to read a new 16-bit word from SRAM, which will last you for the
// next three pixels as well. Otherwise the rest of the circuit can drive SRAM.
// 
// If you store a pixel as 2 bits in SRAM, then whenever oSystemState[3:0] is
// 0, you need to read a new 16-bit word from SRAM, which will last you for the
// next seven pixels as well. Otherwise the rest of the circuit can drive SRAM.
// 
// If you store a pixel as 1 bit in SRAM, then whenever oSystemState[4:0] is
// 0, you need to read a new 16-bit word from SRAM, which will last you for the
// next fifteen pixels as well. Otherwise the rest of the circuit can drive SRAM.
// 
// NOTE THAT FOR ALL CASES WITH SRAM SHARING, you will need to buffer the value
// loaded from SRAM each time the low order bits of oSystemState are 0, so
// there will be at least one 25.2MHz cycle delay between oAddress and
// iRed, iGreen, and iBlue. This makes it impractical to set X_LATENCY to 0.
// 
// Also keep in mind that X_LATENCY counts in 25.2MHz ticks, whereas oSystemState
// updates at 50.4MHz. Make sure that the values of iRed, iGreen, and iBlue align
// in time such that they are held for two 50.4MHz cycles.
// 
// Timing example where X_LATENCY = 2 (don't view with wordwrap):
// 50.4MHz tick #: | -2 | -1 |  0 |  1 |  2 |  3 |  4 |  5 |  6 |  7 |  8 |  9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 | 32 | 33 | 34 | 35 | 36 | 37 |
// oSystemState:   | 30 | 31 |  0 |  1 |  2 |  3 |  4 |  5 |  6 |  7 |  8 |  9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 |  0 |  1 |  2 |  3 |  4 |  5 |
// oAddress:       |  ?      |  0      |  1      |  2      |  3      |  4      |  5      |  6      |  7      |  8      |  9      | 10      | 11      | 12      | 13      | 14      | 15      | 16      | 17      | 18      |
// oValidReq:      |  0      |  1      |  1      |  1      |  1      |  1      |  1      |  1      |  1      |  1      |  1      |  1      |  1      |  1      |  1      |  1      |  1      |
// iRed, iGreen,   
// iBlue contain   
// color info      
// for pixel #:    |  ?      |  ?      |  ?      |  0      |  1      |  2      |  3      |  4      |  5      |  6      |  7      |  8      |  9      | 10      | 11      | 12      | 13      | 14      | 15      | 16      |
// Designer is responsible for making iRed, iGreen, iBlue match timing in last row.
