/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// altera message_off 10230

module VGA_Controller (
    // Control Signal
    input              iCLK,         // 50.4MHz Clock (PLL from 27MHz clock).
    input              iRESET,       // System reset signal.
    // Host Side
    input      [9:0]   iRed,         // Red color of requested pixel.
    input      [9:0]   iGreen,       // Green color of requested pixel.
    input      [9:0]   iBlue,        // Blue color of requested pixel.
    output reg [19:0]  oAddress,     // Address of pixel request
                                     // (0 to 640*480-1, top-left is 0).
    output reg [9:0]   oCoord_X,     // X of pixel request (0 to 639, left is 0).
    output reg [9:0]   oCoord_Y,     // Y of pixel request (0 to 479, top is 0)
    output reg         oValidReq,    // Pixel request is valid (rest of circuit
                                     // Need not reply with iRed, iGreen, iBlue
                                     // if oValidReq is 0).
    output reg [4:0]   oSystemState, // Low bit toggles every 50MHz cycle.
                                     // Top bits start at 0 when Coord_X is 0 and
                                     // increment every time oCoord_X increments
                                     // at 25.2MHz. See usage notes in VGA_Param.h.
    output reg         oNewFrame,    // This output is raised for one 50.4MHz cycle
                                     // during the last tick of the last row of
                                     // visible pixels. Can be used for purposes of
                                     // time synchronization to compute next frame
                                     // between drawing frames, or to implement a
                                     // synchronized prev frame/next frame construct
                                     // in two halves of SRAM.
    // VGA Side (connect directly to VGA output signals)
    output reg [9:0]   oVGA_R,
    output reg [9:0]   oVGA_G,
    output reg [9:0]   oVGA_B,
    output reg         oVGA_H_SYNC,
    output reg         oVGA_V_SYNC,
    output             oVGA_SYNC,
    output             oVGA_BLANK
);
    
    `include "VGA_Param.h"
    
    // Most VGA logic runs at 25.2MHz. Prevent updates (stall) during
    // first 50.4MHz cycle of each 25.2MHz cycle.
    wire stall;
    assign stall = ~oSystemState[0];
    
    // Compute next oSystemState.
    always @(posedge iCLK) begin
        if(iRESET) begin
            oSystemState <= 5'b0;
        end
        else begin
            if(stall) oSystemState <= oSystemState + 5'b1;
            else      oSystemState <= {lookahead_X[3:0], 1'b0}; // variable based on such and such here
        end
    end
    
    // Internal registers to count VGA virtual position.
    // H_Cont (horizontal/X) iterates from 0 to 799.
    // V_Cont (vertical/Y) iterates from 0 to 524.
    reg [9:0] H_Cont;
    reg [9:0] V_Cont;
    
    assign oVGA_BLANK = oVGA_H_SYNC & oVGA_V_SYNC;
    assign oVGA_SYNC  = 1'b0;
    
    // Output Color Generator
    always @(posedge iCLK) begin
        if(iRESET) begin
            oVGA_R <= 0;
            oVGA_G <= 0;
            oVGA_B <= 0;
        end
        else if(~stall) begin
            // When next H_Cont and V_Cont are within the visible region of the screen,
            // assert the color channels appropriately.
            if(((H_Cont+1) >= X_START) && ((H_Cont+1) < (X_START + H_SYNC_ACT)) &&
               (V_Cont     >= Y_START) && (V_Cont     < (Y_START + V_SYNC_ACT))) begin
                oVGA_R <= iRed;
                oVGA_G <= iGreen;
                oVGA_B <= iBlue;
            end
            else begin
                oVGA_R <= 0;
                oVGA_G <= 0;
                oVGA_B <= 0;
            end
        end
    end
    
    // Pixel LUT Address Generator
    wire [9:0] lookahead_X;
    wire [9:0] lookahead_Y;
    assign lookahead_X = (H_Cont + X_LATENCY + 2) - X_START;
    assign lookahead_Y = V_Cont - Y_START;
    always @(posedge iCLK) begin
        if(iRESET) begin
            oCoord_X  <= 0;
            oCoord_Y  <= 0;
            oAddress  <= 0;
            oValidReq <= 1'b0;
        end
        else if(~stall) begin
            oCoord_X  <= lookahead_X;
            oCoord_Y  <= lookahead_Y;
            oAddress  <= lookahead_Y * H_SYNC_ACT + lookahead_X;
            // If the lookahead pixel is in the visible region of memory,
            // the pixel color request is valid.
            if(((H_Cont+X_LATENCY+2) >= X_START) && ((H_Cont+X_LATENCY+2) < (X_START + H_SYNC_ACT)) &&
                (V_Cont              >= Y_START) && (V_Cont               < (Y_START + V_SYNC_ACT))) begin
                oValidReq <= 1'b1;
            end
            else begin
                oValidReq <= 1'b0;
            end
        end
    end
    
    // H_Sync Generator, Ref. 25.2 MHz Clock
    always @(posedge iCLK) begin
        if(iRESET) begin
            H_Cont      <= 0;
            oVGA_H_SYNC <= 0;
        end
        else if(~stall) begin
            // H_Sync Counter and Generator
            if(H_Cont < H_SYNC_MAX) begin
                if(H_Cont == (H_SYNC_CYC-1)) begin
                    oVGA_H_SYNC <= 1;
                end
                H_Cont <= H_Cont + 10'b1;
            end
            else begin
                H_Cont <= 0;
                oVGA_H_SYNC <= 0;
            end
        end
    end
    
    // V_Sync Generator, Ref. H_Sync
    always @(posedge iCLK) begin
        if(iRESET) begin
            V_Cont      <= 0;
            oVGA_V_SYNC <= 0;
        end
        else if(~stall) begin
            // When H_Sync restarts
            if(H_Cont == H_SYNC_MAX) begin
                // V_Sync Counter and Generator
                if(V_Cont < V_SYNC_MAX) begin
                    if(V_Cont == (V_SYNC_CYC-1)) begin
                        oVGA_V_SYNC <= 1;
                    end
                    V_Cont <= V_Cont + 10'b1;
                end
                else begin
                    V_Cont <= 0;
                    oVGA_V_SYNC <= 0;
                end
            end
        end
    end
    
    // Raise oNewFrame once per frame, after drawing last visible row.
    always @(posedge iCLK) begin
        oNewFrame <= (H_Cont == H_SYNC_MAX) && (V_Cont - Y_START == V_SYNC_ACT-1) && (~stall);
    end
    
endmodule
