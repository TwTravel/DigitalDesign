/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

`include "project_params.h"

`define TR_L 0 // Left
`define TR_M 1 // Middle
`define TR_R 2 // Right
`define TR_T 0 // Top
`define TR_B 2 // Bottom

// Manages the 2D array that buffers the immediate 3x12 pixel sized
// Temp Region. Receives data from the three rows of RAM in the
// CA controller, then iterates over the center 4 pixels of the Temp
// Region, modifying them and their neighbors, then sends back the
// data to be written to the RAM rows. As the system iterates across
// an entire row of pixels in the screen, this module only loads
// the forwardmost 4-pixel blocks from the RAM rows and writes back
// only the backmost 4-pixel blocks to the RAM rows, and shifts the
// remaining blocks around, so as to minimize the read/write
// communication per phase. This is similar to how the CA controller
// minimizes the read/write communication with SRAM to only one
// block per phase. There is also an equivalent Old Region that stores
// the previous frame's pixel values, similar to OLD and RAM from the
// CA controller. 
module TempRegion_Controller (
    input             iCLK,              // System clock
    input             iRESET,            // Reset signal, asserted for entire frame
    input             iSTALL,            // Stall signal to pause screen, asserted for entire frame
    input      [2:0]  iSystemState,      // Current clock cycle within the 8-cycle phase
    input      [3:0]  iRand4,            // A random 4-bit number that changes every cycle
    input             iTrollFlame,       // Indicates that the troll is flaming this frame
    input             iRowIsOdd,         // Center of the Temp Region is on an odd-numbered row
    input      [3:0]  iCursorColor,      // The color of the user's cursor (particle type to draw)
    input      [3:0]  iCursorSize,       // Size of the user's cursor
    input      [9:0]  iCursorX,          // X position of the user's cursor
    input      [9:0]  iCursorY,          // Y position of the user's cursor
    input             iCursorDraw,       // Indicates that the user is drawing this frame
    input      [2:0]  iFaucetSize_SAND,  // Size of the sand faucet
    input      [2:0]  iFaucetSize_WATER, // Size of the water faucet
    input      [2:0]  iFaucetSize_SALT,  // Size of the salt faucet
    input      [2:0]  iFaucetSize_OIL,   // Size of the oil faucet
    input      [9:0]  iPixelX,           // X of pixel two cycles from now
    input      [9:0]  iPixelY,           // Y of pixel two cycles from now
    input      [15:0] iRAMoDataT,        // Current value loaded from the top row of RAM
    input      [15:0] iRAMoDataM,        // Current value loaded from the mid row of RAM
    input      [15:0] iRAMoDataB,        // Current value loaded from the bot row of RAM
    input      [15:0] iOLDoDataT,        // Current value loaded from the top row of OLD
    input      [15:0] iOLDoDataM,        // Current value loaded from the mid row of OLD
    input      [15:0] iOLDoDataB,        // Current value loaded from the bot row of OLD
    input             iOffScreenL,       // Left neighbor of the current pixel is off-screen
    input             iOffScreenR,       // Right neighbor of the current pixel is off-screen
    input             iOffScreenU,       // Up neighbor of the current pixel is off-screen
    input             iOffScreenD,       // Down neighbor of the current pixel is off-screen
    input             iValidPix,         // Current pixel is on-screen
    output     [15:0] oTR_TL,            // Top-left block of the Temp Region
    output     [15:0] oTR_TM,            // Top-mio block of the Temp Region
    output     [15:0] oTR_TR,            // Top-right block of the Temp Region
    output     [15:0] oTR_ML,            // Mid-left block of the Temp Region
    output     [15:0] oTR_MM,            // Mid-mid block of the Temp Region
    output     [15:0] oTR_MR,            // Mid-right block of the Temp Region
    output     [15:0] oTR_BL,            // Bot-left block of the Temp Region
    output     [15:0] oTR_BM,            // Bot-mid block of the Temp Region
    output     [15:0] oTR_BR             // Bot-right block of the Temp Region
);
    
    // Buffer previous random number.
    reg [3:0] Rand4Prev;
    always @(posedge iCLK) begin
        Rand4Prev <= iRand4;
    end
    
    /**************************************************
     * Maintain Temp Region Registers                 *
     **************************************************/
    
    // Declare the Temp Region.
    reg  [15:0] tempRegion [2:0][2:0];
    assign oTR_TL = tempRegion[`TR_T][`TR_L];
    assign oTR_TM = tempRegion[`TR_T][`TR_M];
    assign oTR_TR = tempRegion[`TR_T][`TR_R];
    assign oTR_ML = tempRegion[`TR_M][`TR_L];
    assign oTR_MM = tempRegion[`TR_M][`TR_M];
    assign oTR_MR = tempRegion[`TR_M][`TR_R];
    assign oTR_BL = tempRegion[`TR_B][`TR_L];
    assign oTR_BM = tempRegion[`TR_B][`TR_M];
    assign oTR_BR = tempRegion[`TR_B][`TR_R];
    // Declare the Old Region.
    reg  [15:0] oldRegion [2:0][2:0];
    wire [15:0] OR_TL, OR_TM, OR_TR;
    wire [15:0] OR_ML, OR_MM, OR_MR;
    wire [15:0] OR_BL, OR_BM, OR_BR;
    assign OR_TL = oldRegion[`TR_T][`TR_L];
    assign OR_TM = oldRegion[`TR_T][`TR_M];
    assign OR_TR = oldRegion[`TR_T][`TR_R];
    assign OR_ML = oldRegion[`TR_M][`TR_L];
    assign OR_MM = oldRegion[`TR_M][`TR_M];
    assign OR_MR = oldRegion[`TR_M][`TR_R];
    assign OR_BL = oldRegion[`TR_B][`TR_L];
    assign OR_BM = oldRegion[`TR_B][`TR_M];
    assign OR_BR = oldRegion[`TR_B][`TR_R];
    
    // Synchronous update to Temp Region.
    always @(posedge iCLK) begin
        if(iSystemState == 3'd2) begin
            // Load from the three rows in CA_Controller.
            if(iRowIsOdd) begin
                tempRegion[`TR_T][`TR_L] <= iRAMoDataT;
                tempRegion[`TR_M][`TR_L] <= iRAMoDataM;
                tempRegion[`TR_B][`TR_L] <= iRAMoDataB;
                tempRegion[`TR_T][`TR_M] <= tempRegion[`TR_T][`TR_L];
                tempRegion[`TR_M][`TR_M] <= tempRegion[`TR_M][`TR_L];
                tempRegion[`TR_B][`TR_M] <= tempRegion[`TR_B][`TR_L];
                tempRegion[`TR_T][`TR_R] <= tempRegion[`TR_T][`TR_M];
                tempRegion[`TR_M][`TR_R] <= tempRegion[`TR_M][`TR_M];
                tempRegion[`TR_B][`TR_R] <= tempRegion[`TR_B][`TR_M];
                oldRegion[`TR_T][`TR_L]  <= iOLDoDataT;
                oldRegion[`TR_M][`TR_L]  <= iOLDoDataM;
                oldRegion[`TR_B][`TR_L]  <= iOLDoDataB;
                oldRegion[`TR_T][`TR_M]  <= oldRegion[`TR_T][`TR_L];
                oldRegion[`TR_M][`TR_M]  <= oldRegion[`TR_M][`TR_L];
                oldRegion[`TR_B][`TR_M]  <= oldRegion[`TR_B][`TR_L];
                oldRegion[`TR_T][`TR_R]  <= oldRegion[`TR_T][`TR_M];
                oldRegion[`TR_M][`TR_R]  <= oldRegion[`TR_M][`TR_M];
                oldRegion[`TR_B][`TR_R]  <= oldRegion[`TR_B][`TR_M];
            end
            else begin
                tempRegion[`TR_T][`TR_R] <= iRAMoDataT;
                tempRegion[`TR_M][`TR_R] <= iRAMoDataM;
                tempRegion[`TR_B][`TR_R] <= iRAMoDataB;
                tempRegion[`TR_T][`TR_M] <= tempRegion[`TR_T][`TR_R];
                tempRegion[`TR_M][`TR_M] <= tempRegion[`TR_M][`TR_R];
                tempRegion[`TR_B][`TR_M] <= tempRegion[`TR_B][`TR_R];
                tempRegion[`TR_T][`TR_L] <= tempRegion[`TR_T][`TR_M];
                tempRegion[`TR_M][`TR_L] <= tempRegion[`TR_M][`TR_M];
                tempRegion[`TR_B][`TR_L] <= tempRegion[`TR_B][`TR_M];
                oldRegion[`TR_T][`TR_R]  <= iOLDoDataT;
                oldRegion[`TR_M][`TR_R]  <= iOLDoDataM;
                oldRegion[`TR_B][`TR_R]  <= iOLDoDataB;
                oldRegion[`TR_T][`TR_M]  <= oldRegion[`TR_T][`TR_R];
                oldRegion[`TR_M][`TR_M]  <= oldRegion[`TR_M][`TR_R];
                oldRegion[`TR_B][`TR_M]  <= oldRegion[`TR_B][`TR_R];
                oldRegion[`TR_T][`TR_L]  <= oldRegion[`TR_T][`TR_M];
                oldRegion[`TR_M][`TR_L]  <= oldRegion[`TR_M][`TR_M];
                oldRegion[`TR_B][`TR_L]  <= oldRegion[`TR_B][`TR_M];
            end
        end
        else if(iSystemState == 3'd3) begin
            // Update neighborhood of the first pixel.
            if(iRowIsOdd) begin
                tempRegion[`TR_T][`TR_R] <= {oTR_TR[15:4], pu_oTopL};
                tempRegion[`TR_M][`TR_R] <= {oTR_MR[15:4], pu_oMidL};
                tempRegion[`TR_B][`TR_R] <= {oTR_BR[15:4], pu_oBotL};
                tempRegion[`TR_T][`TR_M] <= {pu_oTopM, pu_oTopR, oTR_TM[7:0]};
                tempRegion[`TR_M][`TR_M] <= {pu_oMidM, pu_oMidR, oTR_MM[7:0]};
                tempRegion[`TR_B][`TR_M] <= {pu_oBotM, pu_oBotR, oTR_BM[7:0]};
            end
            else begin
                tempRegion[`TR_T][`TR_L] <= {pu_oTopL, oTR_TL[11:0]};
                tempRegion[`TR_M][`TR_L] <= {pu_oMidL, oTR_ML[11:0]};
                tempRegion[`TR_B][`TR_L] <= {pu_oBotL, oTR_BL[11:0]};
                tempRegion[`TR_T][`TR_M] <= {oTR_TM[15:8], pu_oTopR, pu_oTopM};
                tempRegion[`TR_M][`TR_M] <= {oTR_MM[15:8], pu_oMidR, pu_oMidM};
                tempRegion[`TR_B][`TR_M] <= {oTR_BM[15:8], pu_oBotR, pu_oBotM};
            end
        end
        else if(iSystemState == 3'd4) begin
            // Update neighborhood of the second pixel.
            if(iRowIsOdd) begin
                tempRegion[`TR_T][`TR_M] <= {pu_oTopL, pu_oTopM, pu_oTopR, oTR_TM[3:0]};
                tempRegion[`TR_M][`TR_M] <= {pu_oMidL, pu_oMidM, pu_oMidR, oTR_MM[3:0]};
                tempRegion[`TR_B][`TR_M] <= {pu_oBotL, pu_oBotM, pu_oBotR, oTR_BM[3:0]};
            end
            else begin
                tempRegion[`TR_T][`TR_M] <= {oTR_TM[15:12], pu_oTopR, pu_oTopM, pu_oTopL};
                tempRegion[`TR_M][`TR_M] <= {oTR_MM[15:12], pu_oMidR, pu_oMidM, pu_oMidL};
                tempRegion[`TR_B][`TR_M] <= {oTR_BM[15:12], pu_oBotR, pu_oBotM, pu_oBotL};
            end
        end
        else if(iSystemState == 3'd5) begin
            // Update neighborhood of the third pixel.
            if(iRowIsOdd) begin
                tempRegion[`TR_T][`TR_M] <= {oTR_TM[15:12], pu_oTopL, pu_oTopM, pu_oTopR};
                tempRegion[`TR_M][`TR_M] <= {oTR_MM[15:12], pu_oMidL, pu_oMidM, pu_oMidR};
                tempRegion[`TR_B][`TR_M] <= {oTR_BM[15:12], pu_oBotL, pu_oBotM, pu_oBotR};
            end
            else begin
                tempRegion[`TR_T][`TR_M] <= {pu_oTopR, pu_oTopM, pu_oTopL, oTR_TM[3:0]};
                tempRegion[`TR_M][`TR_M] <= {pu_oMidR, pu_oMidM, pu_oMidL, oTR_MM[3:0]};
                tempRegion[`TR_B][`TR_M] <= {pu_oBotR, pu_oBotM, pu_oBotL, oTR_BM[3:0]};
            end
        end
        else if(iSystemState == 3'd6) begin
            // Update neighborhood of the fourth pixel.
            if(iRowIsOdd) begin
                tempRegion[`TR_T][`TR_L] <= {pu_oTopR, oTR_TL[11:0]};
                tempRegion[`TR_M][`TR_L] <= {pu_oMidR, oTR_ML[11:0]};
                tempRegion[`TR_B][`TR_L] <= {pu_oBotR, oTR_BL[11:0]};
                tempRegion[`TR_T][`TR_M] <= {oTR_TM[15:8], pu_oTopL, pu_oTopM};
                tempRegion[`TR_M][`TR_M] <= {oTR_MM[15:8], pu_oMidL, pu_oMidM};
                tempRegion[`TR_B][`TR_M] <= {oTR_BM[15:8], pu_oBotL, pu_oBotM};
            end
            else begin
                tempRegion[`TR_T][`TR_R] <= {oTR_TR[15:4], pu_oTopR};
                tempRegion[`TR_M][`TR_R] <= {oTR_MR[15:4], pu_oMidR};
                tempRegion[`TR_B][`TR_R] <= {oTR_BR[15:4], pu_oBotR};
                tempRegion[`TR_T][`TR_M] <= {pu_oTopM, pu_oTopL, oTR_TM[7:0]};
                tempRegion[`TR_M][`TR_M] <= {pu_oMidM, pu_oMidL, oTR_MM[7:0]};
                tempRegion[`TR_B][`TR_M] <= {pu_oBotM, pu_oBotL, oTR_BM[7:0]};
            end
        end
    end
    
    /**************************************************
     * Calculate Inputs For Particle Update Module    *
     **************************************************/
    
    // Determine whether or not the user has drawn over the current pixel.
    // Note that iPixelX and iPixelY refer to the pixel two cycles from now.
    // First cycle - calculate absolute value of distance between the pixel
    // and the center of the user's cursor. Also buffer the pixel X and Y.
    wire [10:0] Xdiff;
    wire [10:0] Ydiff;
    reg  [9:0]  bufPixelX;
    reg  [9:0]  bufPixelY;
    reg  [10:0] Xdiff_pos;
    reg  [10:0] Ydiff_pos;
    assign Xdiff = iCursorX - iPixelX;
    assign Ydiff = iCursorY - iPixelY;
    always @(posedge iCLK) begin
        bufPixelX <= iPixelX;
        bufPixelY <= iPixelY;
        Xdiff_pos <= Xdiff[10] ? -Xdiff : Xdiff;
        Ydiff_pos <= Ydiff[10] ? -Ydiff : Ydiff;
    end
    // Second cycle - determine whether the pixel is close enough to the
    // cursor to be drawn, and look up whether its within a circle of
    // specified radius to the user's cursor, in which case it should be
    // drawn.
    reg         diff_small;
    wire        cirROMout;
    always @(posedge iCLK) begin
        diff_small <= (Xdiff_pos[10:4] == 7'b0) && (Ydiff_pos[10:4] == 7'b0);
    end
    CircleROM circleROM (
        .iCLK  (iCLK),
        .iAddr ({iCursorSize, Xdiff_pos[3:0], Ydiff_pos[3:0]}),
        .oData (cirROMout)
    );
    // Combinationally assign results after lookup is complete.
    wire        pu_CursorDraw;
    assign pu_CursorDraw = iCursorDraw & diff_small & cirROMout;
    
    // Determine if the pixel is an input point for faucet particles.
    reg        pu_FaucetPix;
    reg  [3:0] pu_FaucetType;
    wire [8:0] distToFaucet [3:0]; // Distance to sand, water, salt, and oil faucets
    wire       inFaucet [3:0];     // Whether the current pixel is being drawn by the faucets
    assign distToFaucet[0] = bufPixelX[9:2] - 9'd30;
    assign distToFaucet[1] = bufPixelX[9:2] - 9'd62;
    assign distToFaucet[2] = bufPixelX[9:2] - 9'd94;
    assign distToFaucet[3] = bufPixelX[9:2] - 9'd126;
    assign inFaucet[0] = (bufPixelY == 10'd0) && (distToFaucet[0] >= 9'd0) && (distToFaucet[0] < iFaucetSize_SAND);
    assign inFaucet[1] = (bufPixelY == 10'd0) && (distToFaucet[1] >= 9'd0) && (distToFaucet[1] < iFaucetSize_WATER);
    assign inFaucet[2] = (bufPixelY == 10'd0) && (distToFaucet[2] >= 9'd0) && (distToFaucet[2] < iFaucetSize_SALT);
    assign inFaucet[3] = (bufPixelY == 10'd0) && (distToFaucet[3] >= 9'd0) && (distToFaucet[3] < iFaucetSize_OIL);
    always @(posedge iCLK) begin
        pu_FaucetPix  <= inFaucet[0] | inFaucet[1] | inFaucet[2] | inFaucet[3];
        pu_FaucetType <= inFaucet[0] ? `PT_SAND  :
                         inFaucet[1] ? `PT_WATER :
                         inFaucet[2] ? `PT_SALT  :
                         inFaucet[3] ? `PT_OIL   :
                         `PT_BLANK;
    end
    
    // Combinationally mux the inputs of the Particle_Update module
    // based on which pixel from the central 4-pixel block is being updated.
    reg  [3:0] pu_iTopL;
    reg  [3:0] pu_iTopM;
    reg  [3:0] pu_iTopR;
    reg  [3:0] pu_iMidL;
    reg  [3:0] pu_iMidM;
    reg  [3:0] pu_iMidR;
    reg  [3:0] pu_iBotL;
    reg  [3:0] pu_iBotM;
    reg  [3:0] pu_iBotR;
    reg  [3:0] pu_iOldTL;
    reg  [3:0] pu_iOldTM;
    reg  [3:0] pu_iOldTR;
    reg  [3:0] pu_iOldML;
    reg  [3:0] pu_iOldMM;
    reg  [3:0] pu_iOldMR;
    reg  [3:0] pu_iOldBL;
    reg  [3:0] pu_iOldBM;
    reg  [3:0] pu_iOldBR;
    always @(*) begin
        if(iSystemState == 3'd3) begin
            // First pixel.
            if(iRowIsOdd) begin
                pu_iTopL  = oTR_TR[3:0];
                pu_iMidL  = oTR_MR[3:0];
                pu_iBotL  = oTR_BR[3:0];
                pu_iTopM  = oTR_TM[15:12];
                pu_iMidM  = oTR_MM[15:12];
                pu_iBotM  = oTR_BM[15:12];
                pu_iTopR  = oTR_TM[11:8];
                pu_iMidR  = oTR_MM[11:8];
                pu_iBotR  = oTR_BM[11:8];
                pu_iOldTL = OR_TR[3:0];
                pu_iOldML = OR_MR[3:0];
                pu_iOldBL = OR_BR[3:0];
                pu_iOldTM = OR_TM[15:12];
                pu_iOldMM = OR_MM[15:12];
                pu_iOldBM = OR_BM[15:12];
                pu_iOldTR = OR_TM[11:8];
                pu_iOldMR = OR_MM[11:8];
                pu_iOldBR = OR_BM[11:8];
            end
            else begin
                pu_iTopL  = oTR_TL[15:12];
                pu_iMidL  = oTR_ML[15:12];
                pu_iBotL  = oTR_BL[15:12];
                pu_iTopM  = oTR_TM[3:0];
                pu_iMidM  = oTR_MM[3:0];
                pu_iBotM  = oTR_BM[3:0];
                pu_iTopR  = oTR_TM[7:4];
                pu_iMidR  = oTR_MM[7:4];
                pu_iBotR  = oTR_BM[7:4];
                pu_iOldTL = OR_TL[15:12];
                pu_iOldML = OR_ML[15:12];
                pu_iOldBL = OR_BL[15:12];
                pu_iOldTM = OR_TM[3:0];
                pu_iOldMM = OR_MM[3:0];
                pu_iOldBM = OR_BM[3:0];
                pu_iOldTR = OR_TM[7:4];
                pu_iOldMR = OR_MM[7:4];
                pu_iOldBR = OR_BM[7:4];
            end
        end
        else if(iSystemState == 3'd4) begin
            // Second pixel.
            if(iRowIsOdd) begin
                pu_iTopL  = oTR_TM[15:12];
                pu_iMidL  = oTR_MM[15:12];
                pu_iBotL  = oTR_BM[15:12];
                pu_iTopM  = oTR_TM[11:8];
                pu_iMidM  = oTR_MM[11:8];
                pu_iBotM  = oTR_BM[11:8];
                pu_iTopR  = oTR_TM[7:4];
                pu_iMidR  = oTR_MM[7:4];
                pu_iBotR  = oTR_BM[7:4];
                pu_iOldTL = OR_TM[15:12];
                pu_iOldML = OR_MM[15:12];
                pu_iOldBL = OR_BM[15:12];
                pu_iOldTM = OR_TM[11:8];
                pu_iOldMM = OR_MM[11:8];
                pu_iOldBM = OR_BM[11:8];
                pu_iOldTR = OR_TM[7:4];
                pu_iOldMR = OR_MM[7:4];
                pu_iOldBR = OR_BM[7:4];
            end
            else begin
                pu_iTopL  = oTR_TM[3:0];
                pu_iMidL  = oTR_MM[3:0];
                pu_iBotL  = oTR_BM[3:0];
                pu_iTopM  = oTR_TM[7:4];
                pu_iMidM  = oTR_MM[7:4];
                pu_iBotM  = oTR_BM[7:4];
                pu_iTopR  = oTR_TM[11:8];
                pu_iMidR  = oTR_MM[11:8];
                pu_iBotR  = oTR_BM[11:8];
                pu_iOldTL = OR_TM[3:0];
                pu_iOldML = OR_MM[3:0];
                pu_iOldBL = OR_BM[3:0];
                pu_iOldTM = OR_TM[7:4];
                pu_iOldMM = OR_MM[7:4];
                pu_iOldBM = OR_BM[7:4];
                pu_iOldTR = OR_TM[11:8];
                pu_iOldMR = OR_MM[11:8];
                pu_iOldBR = OR_BM[11:8];
            end
        end
        else if(iSystemState == 3'd5) begin
            // Third pixel.
            if(iRowIsOdd) begin
                pu_iTopL  = oTR_TM[11:8];
                pu_iMidL  = oTR_MM[11:8];
                pu_iBotL  = oTR_BM[11:8];
                pu_iTopM  = oTR_TM[7:4];
                pu_iMidM  = oTR_MM[7:4];
                pu_iBotM  = oTR_BM[7:4];
                pu_iTopR  = oTR_TM[3:0];
                pu_iMidR  = oTR_MM[3:0];
                pu_iBotR  = oTR_BM[3:0];
                pu_iOldTL = OR_TM[11:8];
                pu_iOldML = OR_MM[11:8];
                pu_iOldBL = OR_BM[11:8];
                pu_iOldTM = OR_TM[7:4];
                pu_iOldMM = OR_MM[7:4];
                pu_iOldBM = OR_BM[7:4];
                pu_iOldTR = OR_TM[3:0];
                pu_iOldMR = OR_MM[3:0];
                pu_iOldBR = OR_BM[3:0];
            end
            else begin
                pu_iTopL  = oTR_TM[7:4];
                pu_iMidL  = oTR_MM[7:4];
                pu_iBotL  = oTR_BM[7:4];
                pu_iTopM  = oTR_TM[11:8];
                pu_iMidM  = oTR_MM[11:8];
                pu_iBotM  = oTR_BM[11:8];
                pu_iTopR  = oTR_TM[15:12];
                pu_iMidR  = oTR_MM[15:12];
                pu_iBotR  = oTR_BM[15:12];
                pu_iOldTL = OR_TM[7:4];
                pu_iOldML = OR_MM[7:4];
                pu_iOldBL = OR_BM[7:4];
                pu_iOldTM = OR_TM[11:8];
                pu_iOldMM = OR_MM[11:8];
                pu_iOldBM = OR_BM[11:8];
                pu_iOldTR = OR_TM[15:12];
                pu_iOldMR = OR_MM[15:12];
                pu_iOldBR = OR_BM[15:12];
            end
        end
        else if(iSystemState == 3'd6) begin
            // Fourth pixel.
            if(iRowIsOdd) begin
                pu_iTopL  = oTR_TM[7:4];
                pu_iMidL  = oTR_MM[7:4];
                pu_iBotL  = oTR_BM[7:4];
                pu_iTopM  = oTR_TM[3:0];
                pu_iMidM  = oTR_MM[3:0];
                pu_iBotM  = oTR_BM[3:0];
                pu_iTopR  = oTR_TL[15:12];
                pu_iMidR  = oTR_ML[15:12];
                pu_iBotR  = oTR_BL[15:12];
                pu_iOldTL = OR_TM[7:4];
                pu_iOldML = OR_MM[7:4];
                pu_iOldBL = OR_BM[7:4];
                pu_iOldTM = OR_TM[3:0];
                pu_iOldMM = OR_MM[3:0];
                pu_iOldBM = OR_BM[3:0];
                pu_iOldTR = OR_TL[15:12];
                pu_iOldMR = OR_ML[15:12];
                pu_iOldBR = OR_BL[15:12];
            end
            else begin
                pu_iTopL  = oTR_TM[11:8];
                pu_iMidL  = oTR_MM[11:8];
                pu_iBotL  = oTR_BM[11:8];
                pu_iTopM  = oTR_TM[15:12];
                pu_iMidM  = oTR_MM[15:12];
                pu_iBotM  = oTR_BM[15:12];
                pu_iTopR  = oTR_TR[3:0];
                pu_iMidR  = oTR_MR[3:0];
                pu_iBotR  = oTR_BR[3:0];
                pu_iOldTL = OR_TM[11:8];
                pu_iOldML = OR_MM[11:8];
                pu_iOldBL = OR_BM[11:8];
                pu_iOldTM = OR_TM[15:12];
                pu_iOldMM = OR_MM[15:12];
                pu_iOldBM = OR_BM[15:12];
                pu_iOldTR = OR_TR[3:0];
                pu_iOldMR = OR_MR[3:0];
                pu_iOldBR = OR_BR[3:0];
            end
        end
        else begin
            // No pixel.
            pu_iTopL = 4'b0;
            pu_iMidL = 4'b0;
            pu_iBotL = 4'b0;
            pu_iTopM = 4'b0;
            pu_iMidM = 4'b0;
            pu_iBotM = 4'b0;
            pu_iTopR = 4'b0;
            pu_iMidR = 4'b0;
            pu_iBotR = 4'b0;
            pu_iOldTL = 4'b0;
            pu_iOldML = 4'b0;
            pu_iOldBL = 4'b0;
            pu_iOldTM = 4'b0;
            pu_iOldMM = 4'b0;
            pu_iOldBM = 4'b0;
            pu_iOldTR = 4'b0;
            pu_iOldMR = 4'b0;
            pu_iOldBR = 4'b0;
        end
    end
    
    // Instantiate the Particle_Update module.
    wire [3:0] pu_oTopL;
    wire [3:0] pu_oTopM;
    wire [3:0] pu_oTopR;
    wire [3:0] pu_oMidL;
    wire [3:0] pu_oMidM;
    wire [3:0] pu_oMidR;
    wire [3:0] pu_oBotL;
    wire [3:0] pu_oBotM;
    wire [3:0] pu_oBotR;
    Particle_Update pu0 (
        .iRESET       (iRESET),
        .iSTALL       (iSTALL),
        .iRand4       (iRand4),
        .iRand4Prev   (Rand4Prev),
        .iTrollFlame  (iTrollFlame),
        .iCursorColor (iCursorColor),
        .iCursorDraw  (pu_CursorDraw),
        .iValidPix    (iValidPix),
        .iFaucetPix   (pu_FaucetPix),
        .iFaucetType  (pu_FaucetType),
        .iTopL        (iOffScreenL ? `PT_WALL : iOffScreenU ? `PT_BLANK : pu_iTopL),
        .iTopM        (                         iOffScreenU ? `PT_BLANK : pu_iTopM),
        .iTopR        (iOffScreenR ? `PT_WALL : iOffScreenU ? `PT_BLANK : pu_iTopR),
        .iMidL        (iOffScreenL ? `PT_WALL :                           pu_iMidL),
        .iMidM        (                                                   pu_iMidM),
        .iMidR        (iOffScreenR ? `PT_WALL :                           pu_iMidR),
        .iBotL        (iOffScreenL ? `PT_WALL : iOffScreenD ? `PT_BLANK : pu_iBotL),
        .iBotM        (                         iOffScreenD ? `PT_BLANK : pu_iBotM),
        .iBotR        (iOffScreenR ? `PT_WALL : iOffScreenD ? `PT_BLANK : pu_iBotR),
        .iOldTL       (iOffScreenL ? `PT_WALL : iOffScreenU ? `PT_BLANK : pu_iOldTL),
        .iOldTM       (                         iOffScreenU ? `PT_BLANK : pu_iOldTM),
        .iOldTR       (iOffScreenR ? `PT_WALL : iOffScreenU ? `PT_BLANK : pu_iOldTR),
        .iOldML       (iOffScreenL ? `PT_WALL :                           pu_iOldML),
        .iOldMM       (                                                   pu_iOldMM),
        .iOldMR       (iOffScreenR ? `PT_WALL :                           pu_iOldMR),
        .iOldBL       (iOffScreenL ? `PT_WALL : iOffScreenD ? `PT_BLANK : pu_iOldBL),
        .iOldBM       (                         iOffScreenD ? `PT_BLANK : pu_iOldBM),
        .iOldBR       (iOffScreenR ? `PT_WALL : iOffScreenD ? `PT_BLANK : pu_iOldBR),
        .oTopL        (pu_oTopL),
        .oTopM        (pu_oTopM),
        .oTopR        (pu_oTopR),
        .oMidL        (pu_oMidL),
        .oMidM        (pu_oMidM),
        .oMidR        (pu_oMidR),
        .oBotL        (pu_oBotL),
        .oBotM        (pu_oBotM),
        .oBotR        (pu_oBotR)
    );
    
endmodule
