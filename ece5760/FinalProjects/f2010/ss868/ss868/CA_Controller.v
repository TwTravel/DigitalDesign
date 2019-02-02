/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// altera message_off 10230

// High-level module that, along with its submodules, handles the
// particle cellular automaton. This module in specific manages
// the RAM modules that cyclically store the three most local rows.
module CA_Controller (
    input             iCLK,              // System clock
    input             iRESET,            // Reset signal, asserted for entire frame
    input             iSTALL,            // Stall signal to pause screen, asserted for entire frame
    input      [2:0]  iSystemState,      // Current clock cycle within the 8-cycle phase
    input             iNewFrame,         // Asserted for one cycle to signal start of a new frame
    input      [3:0]  iRand4,            // A random 4-bit number that changes every cycle
    input             iTrollFlame,       // Indicates that the troll is flaming this frame
    input      [3:0]  iCursorColor,      // The color of the user's cursor (particle type to draw)
    input      [3:0]  iCursorSize,       // Size of the user's cursor
    input      [9:0]  iCursorX,          // X position of the user's cursor
    input      [9:0]  iCursorY,          // Y position of the user's cursor
    input             iCursorDraw,       // Indicates that the user is drawing this frame
    input      [2:0]  iFaucetSize_SAND,  // Size of the sand faucet
    input      [2:0]  iFaucetSize_WATER, // Size of the water faucet
    input      [2:0]  iFaucetSize_SALT,  // Size of the salt faucet
    input      [2:0]  iFaucetSize_OIL,   // Size of the oil faucet
    output     [16:0] oReadAddr,         // Address to read from SRAM
    input      [15:0] iReadData,         // Data that was read from SRAM
    output     [16:0] oWriteAddr,        // Address to write to SRAM during this phase
    output reg [15:0] oWriteData,        // Data to write to SRAM during this phase
    output reg        oWriteEn           // Enables write to SRAM during this phase
);
    
    /**************************************************
     * Positional Calculations                        *
     **************************************************/
    
    // Compute which block of the screen the center of the Temp Region is this phase.
    reg  [8:0] xBlock;
    reg  [9:0] yBlock;
    // Also compute which row of RAM is the top, middle, and bottom row, because
    // they cycle every tow.
    reg  [1:0] rowT;
    reg  [1:0] rowM;
    reg  [1:0] rowB;
    // Determine whether current row is odd or even.
    wire       RowIsOdd;
    assign RowIsOdd = yBlock[0];
    always @(posedge iCLK) begin
        if(iNewFrame) begin
            // Upon new frame signal, start at bottom of screen and traverse up.
            xBlock <= 9'd161;
            yBlock <= 10'd481;
            rowT   <= 2'd0;
            rowM   <= 2'd1;
            rowB   <= 2'd2;
        end
        else if(iSystemState == 3'd7) begin
            // Move Temp Region.
            // When y == -2, done, so don't go anywhere.
            if(yBlock != 10'h3FE) begin
                if(RowIsOdd) begin
                    // On an odd row, moving right to left.
                    if(xBlock == 9'h1FE) begin
                        // Off screen at x = -2. Go up a row.
                        yBlock <= yBlock - 10'd1;
                        rowT <= (rowT == 2'd0) ? 2'd2 : rowT - 2'd1;
                        rowM <= (rowM == 2'd0) ? 2'd2 : rowM - 2'd1;
                        rowB <= (rowB == 2'd0) ? 2'd2 : rowB - 2'd1;
                    end
                    else begin
                        // Go left a block.
                        xBlock <= xBlock - 9'd1;
                    end
                end
                else begin
                    // On an even row, moving left to right.
                    if(xBlock == 9'd161) begin
                        // Off screen at x = 161. Go up a row.
                        yBlock <= yBlock - 10'd1;
                        rowT <= (rowT == 2'd0) ? 2'd2 : rowT - 2'd1;
                        rowM <= (rowM == 2'd0) ? 2'd2 : rowM - 2'd1;
                        rowB <= (rowB == 2'd0) ? 2'd2 : rowB - 2'd1;
                    end
                    else begin
                        // Go right a block.
                        xBlock <= xBlock + 9'd1;
                    end
                end
            end
        end
    end
    
    // Calculate positions based on xBlock and yBlock, which are the position
    // of the center of the Temp Region. For example, LookAhead1 is one block
    // ahead of the current center of Temp Region, which would be one block to
    // the right during an even row and one block to the left during an odd row.
    wire [8:0] xBplus1;
    wire [8:0] xBminus1;
    wire [8:0] xLookAhead1;
    wire [8:0] xLookBack1;
    wire [8:0] xBplus2;
    wire [8:0] xBminus2;
    wire [8:0] xLookAhead2;
    wire [8:0] xLookBack2;
    wire [9:0] yBplus1;
    wire [9:0] yBminus1;
    assign xBplus1 = xBlock + 9'd1;
    assign xBminus1 = xBlock - 9'd1;
    assign xLookAhead1 = RowIsOdd ? xBminus1 : xBplus1;
    assign xLookBack1 = RowIsOdd ? xBplus1 : xBminus1;
    assign xBplus2 = xBlock + 9'd2;
    assign xBminus2 = xBlock - 9'd2;
    assign xLookAhead2 = RowIsOdd ? xBminus2 : xBplus2;
    assign xLookBack2 = RowIsOdd ? xBplus2 : xBminus2;
    assign yBplus1 = yBlock + 10'd1;
    assign yBminus1 = yBlock - 10'd1;
    
    // For the Temp Region, calculate the current pixel location for each
    // clock cycle based on the center block location and the current
    // cycle within a phase (iSystemState).
    reg [9:0] pixelX;
    reg [9:0] pixelY;
    always @(posedge iCLK) begin
        pixelX <= RowIsOdd ? {xBlock[7:0], ~iSystemState[1:0]} : {xBlock[7:0], iSystemState[1:0]};
        pixelY <= yBlock;
    end
    
    /**************************************************
     * RAMs to Buffer 3 Pixel Rows                    *
     **************************************************/
    
    // These ones, prefixed RAM, are writable by pixel updates and represent
    // the values of the pixels during the next frame (after calculation).
    reg  [7:0]  RAMaddr  [2:0];
    reg  [15:0] RAMiData [2:0];
    reg  [15:0] RAMwen   [2:0];
    wire [15:0] RAMoData [2:0];
    
    // These ones, prefixed OLD, are only writable when loaded from SRAM, not
    // by pixel updaates. They represent the values of the pixels during the
    // previous frame.
    reg  [7:0]  OLDaddr  [2:0];
    reg  [15:0] OLDiData [2:0];
    reg  [15:0] OLDwen   [2:0];
    wire [15:0] OLDoData [2:0];
    
    // Generate the actual RAM modules and driving logic for input signals.
    genvar i;
    generate
        for(i = 0; i < 3; i = i + 1) begin : RAMgen
            RAM_256_16 RAM (
                .iCLK  (iCLK),
                .iAddr (RAMaddr[i]),
                .iData (RAMiData[i]),
                .iWen  (RAMwen[i]),
                .oData (RAMoData[i])
            );
            RAM_256_16 OLD (
                .iCLK  (iCLK),
                .iAddr (OLDaddr[i]),
                .iData (OLDiData[i]),
                .iWen  (OLDwen[i]),
                .oData (OLDoData[i])
            );
            
            // Combinational input select.
            always @(*) begin
                if(iSystemState == 3'd0) begin
                    // During this cycle, read from the bottom row two
                    // phases back so that the value can be written
                    // to SRAM during a later clock cycle.
                    RAMaddr[i]  = xLookBack2[7:0];
                    RAMiData[i] = 16'b0;
                    RAMwen[i]   = 1'b0;
                    // OLD doesn't need to be readed, since only RAM
                    // contains the state update that needs to be
                    // written back to SRAM.
                    OLDaddr[i]  = 8'b0;
                    OLDiData[i] = 16'b0;
                    OLDwen[i]   = 1'b0;
                end
                else if(iSystemState == 3'd1) begin
                    // During this cycle, read from the rop row one
                    // phase forward so that the value can be written
                    // to the Temp Region.
                    RAMaddr[i]  = xLookAhead1[7:0];
                    RAMiData[i] = 16'b0;
                    RAMwen[i]   = 1'b0;
                    // Read from OLD to Temp Region as well.
                    OLDaddr[i]  = xLookAhead1[7:0];
                    OLDiData[i] = 16'b0;
                    OLDwen[i]   = 1'b0;
                end
                else if(iSystemState == 3'd3) begin
                    // During this cycle, write from SRAM to the
                    // top row two phases forward.
                    RAMaddr[i]  = xLookAhead2[7:0];
                    RAMiData[i] = iReadData;
                    RAMwen[i]   = (rowT == i);
                    // Write into OLD as well.
                    OLDaddr[i]  = xLookAhead2[7:0];
                    OLDiData[i] = iReadData;
                    OLDwen[i]   = (rowT == i);
                end
                else if(iSystemState == 3'd7) begin
                    // During this cycle, write from the Temp Region
                    // (after changes) to the RAM one phase back.
                    RAMaddr[i]  = xLookBack1[7:0];
                    RAMiData[i] = RowIsOdd ?
                                  ((rowT == i) ? wTR_TR : (rowM == i) ? wTR_MR : wTR_BR):
                                  ((rowT == i) ? wTR_TL : (rowM == i) ? wTR_ML : wTR_BL);
                    RAMwen[i]   = 1'b1;
                    // OLD is not written, since it stores the old
                    // status from the previous frame and does not
                    // experience the system update.
                    OLDaddr[i]  = 8'b0;
                    OLDiData[i] = 16'b0;
                    OLDwen[i]   = 1'b0;
                end
                else begin
                    // RAM and OLD not being used this cycle.
                    RAMaddr[i]  = 8'b0;
                    RAMiData[i] = 16'b0;
                    RAMwen[i]   = 1'b0;
                    OLDaddr[i]  = 8'b0;
                    OLDiData[i] = 16'b0;
                    OLDwen[i]   = 1'b0;
                end
            end
        end
    endgenerate
    
    // Mux out which are the top, middle, and bottom row from the three SRAM rows,
    // which cycle between top, middle, and bottom after each line of pixels.
    wire [15:0] RAMoDataT;
    wire [15:0] RAMoDataM;
    wire [15:0] RAMoDataB;
    wire [15:0] OLDoDataT;
    wire [15:0] OLDoDataM;
    wire [15:0] OLDoDataB;
    assign RAMoDataT = (rowT == 2'd0) ? RAMoData[0] : (rowT == 2'd1) ? RAMoData[1] : RAMoData[2];
    assign RAMoDataM = (rowM == 2'd0) ? RAMoData[0] : (rowM == 2'd1) ? RAMoData[1] : RAMoData[2];
    assign RAMoDataB = (rowB == 2'd0) ? RAMoData[0] : (rowB == 2'd1) ? RAMoData[1] : RAMoData[2];
    assign OLDoDataT = (rowT == 2'd0) ? OLDoData[0] : (rowT == 2'd1) ? OLDoData[1] : OLDoData[2];
    assign OLDoDataM = (rowM == 2'd0) ? OLDoData[0] : (rowM == 2'd1) ? OLDoData[1] : OLDoData[2];
    assign OLDoDataB = (rowB == 2'd0) ? OLDoData[0] : (rowB == 2'd1) ? OLDoData[1] : OLDoData[2];
    
    // Select the data to write back from RAM to SRAM during this phase.
    always @(posedge iCLK) begin
        if(iSystemState == 3'd1) begin
            oWriteData <= RAMoDataB;
        end
    end
    
    // Drive the communication with SRAM. During each phase, read one block
    // that is two phases ahead in the top row, and write back one block
    // that was two phases behind in the bottom row. Only write (oWriteEn)
    // if the write block is actually on-screen.
    assign oReadAddr  = yBminus1 * 160 + xLookAhead2;
    assign oWriteAddr = yBplus1 * 160 + xLookBack2;
    always @(posedge iCLK) begin
        if(RowIsOdd) begin
            if(xBlock == 9'd161)      oWriteEn <= 1'b0;
            else if(xBlock == 9'd157) oWriteEn <= 1'b1;
        end
        else begin
            if(xBlock == 9'h1FE)      oWriteEn <= 1'b0;
            else if(xBlock == 9'd2)   oWriteEn <= 1'b1;
        end
    end
    
    /**************************************************
     * 2D Array to Buffer 3x12 Pixel Temp Region      *
     **************************************************/
    
    wire [15:0] wTR_TL, wTR_TM, wTR_TR; // Temp Region top-left, top-mid, top-right.
    wire [15:0] wTR_ML, wTR_MM, wTR_MR; // Temp Region mid-left, mid-mid, mid-right.
    wire [15:0] wTR_BL, wTR_BM, wTR_BR; // Temp Region bot-left, bot-mid, bot-right.
    
    // Determine if neighboring pixels are off-screen.
    reg  offScreenL; // Left neighbor is off-screen.
    reg  offScreenR; // Right neighbor is off-screen.
    reg  offScreenU; // Up neighbor is off-screen.
    reg  offScreenD; // Down neighbor is off-screen.
    reg  validPix;   // Assert if this pixel is on-screen.
    always @(posedge iCLK) begin
        if(RowIsOdd) begin
            // Note that when row is odd, the concept of left and right neighbors
            // is reversed, so offScreenL refers to the screen-wise right neighbor.
            // If row is odd, progressing from right to left. That means right
            // neighbor is off-screen if we're dealing with the first pixel at
            // the rightmost block. The left neighbor is off-screen if we're
            // dealing with the last pixel at the leftmost block.
            offScreenL <= (iSystemState == 3'd2) && (xBlock == 9'd159);
            offScreenR <= (iSystemState == 3'd5) && (xBlock == 9'd0);
        end
        else begin
            // If row is even, progressing from left to right. That means left
            // neighbor is off-screen if we're dealing with the first pixel at
            // the leftmost block. The right neighbor is off-screen if we're
            // dealing with the last pixel at the rightmost block.
            offScreenL <= (iSystemState == 3'd2) && (xBlock == 9'd0);
            offScreenR <= (iSystemState == 3'd5) && (xBlock == 9'd159);
        end
        // Up neighbor is off-screen if we're in the top row.
        offScreenU <= (yBlock == 10'd0);
        // Down neighbor is off-screen if we're in the bottom row,
        offScreenD <= (yBlock == 10'd479);
        // The center pixel is valid if we're within the screen boundaries.
        validPix   <= (xBlock >= 9'd0)  && (xBlock < 9'd160) &&
                      (yBlock >= 10'd0) && (yBlock < 10'd480);
    end
    
    // Instantiate a controller for the Temp Region.
    TempRegion_Controller trc0 (
        .iCLK              (iCLK),
        .iRESET            (iRESET),
        .iSTALL            (iSTALL),
        .iSystemState      (iSystemState),
        .iRand4            (iRand4),
        .iTrollFlame       (iTrollFlame),
        .iRowIsOdd         (RowIsOdd),
        .iCursorColor      (iCursorColor),
        .iCursorSize       (iCursorSize),
        .iCursorX          (iCursorX),
        .iCursorY          (iCursorY),
        .iCursorDraw       (iCursorDraw),
        .iFaucetSize_SAND  (iFaucetSize_SAND),
        .iFaucetSize_WATER (iFaucetSize_WATER),
        .iFaucetSize_SALT  (iFaucetSize_SALT),
        .iFaucetSize_OIL   (iFaucetSize_OIL),
        .iPixelX           (pixelX),
        .iPixelY           (pixelY),
        .iRAMoDataT        (RAMoDataT),
        .iRAMoDataM        (RAMoDataM),
        .iRAMoDataB        (RAMoDataB),
        .iOLDoDataT        (OLDoDataT),
        .iOLDoDataM        (OLDoDataM),
        .iOLDoDataB        (OLDoDataB),
        .iOffScreenL       (offScreenL),
        .iOffScreenR       (offScreenR),
        .iOffScreenU       (offScreenU),
        .iOffScreenD       (offScreenD),
        .iValidPix         (validPix),
        .oTR_TL            (wTR_TL),
        .oTR_TM            (wTR_TM),
        .oTR_TR            (wTR_TR),
        .oTR_ML            (wTR_ML),
        .oTR_MM            (wTR_MM),
        .oTR_MR            (wTR_MR),
        .oTR_BL            (wTR_BL),
        .oTR_BM            (wTR_BM),
        .oTR_BR            (wTR_BR)
    );
    
endmodule
