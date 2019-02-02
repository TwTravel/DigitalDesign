/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// Module to control the VGA color outputs based on the requested
// pixel from the VGA controller, the particle data stored in SRAM,
// the location of the user's cursor, and whether or not the
// troll is on-screen.
module ColorSelector (
    input             iCLK,          // System clock signal
    input      [2:0]  iSystemState,  // Current clock cycle within the 8-cycle phase
    input      [9:0]  iVGA_X,        // X location of pixel whose color is needed six cycles later
    input      [9:0]  iVGA_Y,        // Y location of pixel whose color is needed six cycles later
    input      [3:0]  iSRAM_Color,   // The color of SRAM at the requested position 5 cycles ago
    input      [9:0]  iCursor_X,     // The user's cursor X position
    input      [9:0]  iCursor_Y,     // The user's cursor Y position
    input      [3:0]  iCursor_Size,  // The size of the user's cursor
    input      [1:0]  iTrollColor,   // Color to be drawn because of the troll (white, black, trans)
    output     [9:0]  oVGA_R,        // Red channel output to VGA
    output     [9:0]  oVGA_G,        // Green channel output to VGA
    output     [9:0]  oVGA_B         // Blue channel output to VGA
);
    
    // Signals prepended by SS<Z>_ are set based on the requested X, Y
    // coordinates <Z> cycles ago.
    
    // Determine distance from requested pixel and user's cursor.
    reg  [10:0] SS1_Xdiff;
    reg  [10:0] SS1_Ydiff;
    always @(posedge iCLK) begin
        SS1_Xdiff <= iCursor_X - iVGA_X;
        SS1_Ydiff <= iCursor_Y - iVGA_Y;
    end
    
    // Take absolute value of that distance.
    reg  [10:0] SS2_Xdiff_pos;
    reg  [10:0] SS2_Ydiff_pos;
    always @(posedge iCLK) begin
        SS2_Xdiff_pos <= SS1_Xdiff[10] ? -SS1_Xdiff : SS1_Xdiff;
        SS2_Ydiff_pos <= SS1_Ydiff[10] ? -SS1_Ydiff : SS1_Ydiff;
    end
    
    // Determine whether the requested pixel's coordinates are the
    // same as or close to the user's cursor coordinates.
    reg         SS3_Xsame;
    reg         SS3_Ysame;
    reg         SS3_Xclose;
    reg         SS3_Yclose;
    always @(posedge iCLK) begin
        SS3_Xsame  <= (SS2_Xdiff_pos == 11'b0);
        SS3_Ysame  <= (SS2_Ydiff_pos == 11'b0);
        SS3_Xclose <= (SS2_Xdiff_pos <= iCursor_Size);
        SS3_Yclose <= (SS2_Ydiff_pos <= iCursor_Size);
    end
    
    // Determine whether the requested pixel is in the cross drawn at
    // the user's cursor. Also propagate the troll color input.
    reg         SS4_inCross;
    reg         SS5_inCross;
    reg         SS6_inCross;
    reg  [1:0]  SS4_TrollColor;
    reg  [1:0]  SS5_TrollColor;
    reg  [1:0]  SS6_TrollColor;
    always @(posedge iCLK) begin
        SS4_inCross <= (SS3_Xsame & SS3_Yclose) | (SS3_Ysame & SS3_Xclose);
        SS5_inCross <= SS4_inCross;
        SS6_inCross <= SS5_inCross;
        SS4_TrollColor <= iTrollColor;
        SS5_TrollColor <= SS4_TrollColor;
        SS6_TrollColor <= SS5_TrollColor;
    end
    
    // Look up the color that would be drawn based on the SRAM screen if no
    // cursor or troll were drawn on top.
    wire [23:0] color;
    ColorROM colorROM (
        .iCLK  (iCLK),
        .iAddr (iSRAM_Color),
        .oData (color)
    );
    
    // Mux out whether the color should be white or black from the troll, or
    // if it should be purple from the cursor, or just the color of the
    // screen underneath that was loaded from SRAM.
    assign oVGA_R = (SS6_TrollColor == 2'b11) ? {8'd255, 2'b0} :
                    (SS6_TrollColor == 2'b10) ? {8'd0,   2'b0} :
                    SS6_inCross               ? {8'd255, 2'b0} :
                    {color[23:16], 2'b0};
    assign oVGA_G = (SS6_TrollColor == 2'b11) ? {8'd255, 2'b0} :
                    (SS6_TrollColor == 2'b10) ? {8'd0,   2'b0} :
                    SS6_inCross               ? {8'd0  , 2'b0} :
                    {color[15:8],  2'b0};
    assign oVGA_B = (SS6_TrollColor == 2'b11) ? {8'd255, 2'b0} :
                    (SS6_TrollColor == 2'b10) ? {8'd0,   2'b0} :
                    SS6_inCross               ? {8'd255, 2'b0} :
                    {color[7:0],   2'b0};
    
endmodule
