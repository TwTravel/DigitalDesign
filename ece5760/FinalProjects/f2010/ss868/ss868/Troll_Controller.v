/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// altera message_off 10230

// Module that handles the troll behavior. Looks up the color of
// a pixel of the troll to draw to a given pixel on the VGA, and
// tells the CA which frames the troll is flaming the screen.
module Troll_Controller (
    input             iCLK,         // System clock signal
    input             iRESET,       // Reset signal, asserted for entire frame
    input             iSTALL,       // Stall signal to pause screen, asserted for entire frame
    input             iNewFrame,    // Asserted for one cycle to signal start of a new frame
    input             iTrollBegin,  // Asserted for a frame to signal a troll command
    input      [9:0]  iVGA_X,       // X location of pixel whose color is needed six cycles later
    input      [9:0]  iVGA_Y,       // Y location of pixel whose color is needed six cycles later
    output reg        oTrollFlame,  // Indicates that the troll is flaming this frame
    output reg [1:0]  oTrollColor   // Color of pixel requested 3 cycles ago (white, black, trans)
);
    
    reg [7:0] TrollCntr;      // Counts from 0 to 119, because troll animation lasts 2 seconds at 60Hz frames.
    reg [3:0] TrollFrameCntr; // Counts from 0 to 9, because each troll picture lasts 1/6 second.
    reg [1:0] TrollFrame;     // Counts from 0 to 3, because there are four pictures in the animation.
    always @(posedge iCLK) begin
        if(iRESET) begin
            // Upon screen reset, remove the troll.
            oTrollFlame <= 1'b0;
            TrollCntr   <= 8'hFF;
        end
        else if(iNewFrame & ~iSTALL) begin
            // Advance the troll animation.
            if(iTrollBegin) begin
                // A new troll command has been received from the user.
                // Reset the troll animation to the beginning.
                oTrollFlame    <= 1'b1;
                TrollCntr      <= 8'd0;
                TrollFrame     <= 2'd0;
                TrollFrameCntr <= 4'd0;
            end
            else if((TrollCntr == 8'hFF) || (TrollCntr == 8'd119)) begin
                // Animation is over - remove the troll.
                oTrollFlame <= 1'b0;
                TrollCntr   <= 8'hFF;
            end
            else begin
                // Troll animation in progress.
                // Flame every four frames.
                oTrollFlame <= (TrollFrameCntr == 4'd0);
                TrollCntr   <= TrollCntr + 8'd1;
                // Switch animation pictures every 10 frames.
                if(TrollFrameCntr == 4'd9) begin
                    TrollFrame     <= TrollFrame + 2'd1;
                    TrollFrameCntr <= 4'd0;
                end
                else begin
                    TrollFrameCntr <= TrollFrameCntr + 4'd1;
                end
            end
        end
    end
    
    // Use the requested X and Y pixels to lookup the color of the
    // current troll picture for that pixel.
    // In first cycle, calculate the address for the ROM and determine
    // which pixel of the eight returned pixels is the desired one.
    reg  [13:0] tROMaddr;
    reg  [2:0]  xSel;
    always @(posedge iCLK) begin
        tROMaddr <= (2400*TrollFrame) + (20*iVGA_Y[9:2]) + iVGA_X[9:5];
        xSel <= iVGA_X[4:2];
    end
    // In second cycle, use the calculated addr to lookup the ROM.
    // Also buffer the desired pixel specifier.
    wire [15:0] TrollColors;
    TrollROM tROM (
        .iCLK   (iCLK),
        .iAddr  (tROMaddr),
        .oData  (TrollColors)
    );
    reg  [2:0]  buf_xSel;
    always @(posedge iCLK) begin
        buf_xSel <= xSel;
    end
    // In the third cycle, extract from the eight-pixel word the
    // value of the one desired pixel.
    always @(posedge iCLK) begin
        if(TrollCntr != 8'hFF) begin
            case(buf_xSel)
                3'd0: oTrollColor <= TrollColors[1:0];
                3'd1: oTrollColor <= TrollColors[3:2];
                3'd2: oTrollColor <= TrollColors[5:4];
                3'd3: oTrollColor <= TrollColors[7:6];
                3'd4: oTrollColor <= TrollColors[9:8];
                3'd5: oTrollColor <= TrollColors[11:10];
                3'd6: oTrollColor <= TrollColors[13:12];
                3'd7: oTrollColor <= TrollColors[15:14];
            endcase
        end
        else begin
            // If troll animation is off, return transparent color.
            oTrollColor <= 2'b00;
        end
    end
    
endmodule
