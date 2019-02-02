/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

`include "project_params.h"
`include "scan_events.h"

// Module that receives user input in the form of switches, buttons,
// and keyboard scan events, and outputs user-controlled properties
// like cursor size, color, and position, faucet sizes, and reset,
// pause, and troll commands.
module Input_Controller (
    input             iCLK,              // System clock signal
    input             iRESET,            // System reset signal (power-on reset)
    input      [2:0]  iSystemState,      // Current clock cycle within the 8-cycle phase
    input             iNewFrame,         // Asserted for one cycle to signal start of a new frame
    input      [17:0] iSW,               // Board input switches
    input      [3:0]  iKEY,              // Board input pushbuttons
    input             iEventReady,       // Keyboard event ready
    input      [7:0]  iEventType,        // Type of keyboard event that is ready
    output reg [3:0]  oCursorColor,      // Controlled particle type to be drawn by cursor
    output reg [3:0]  oCursorSize,       // Controlled size of cursor
    output reg [9:0]  oCursorX,          // Controlled X position of cursor
    output reg [9:0]  oCursorY,          // Controlled Y position of cursor
    output reg        oCursorDraw,       // Asserted during frames when the cursor is drawing
    output reg [2:0]  oFaucetSize_SAND,  // Controlled size of sand faucet
    output reg [2:0]  oFaucetSize_WATER, // Controlled size of water faucet
    output reg [2:0]  oFaucetSize_SALT,  // Controlled size of salt faucet
    output reg [2:0]  oFaucetSize_OIL,   // Controlled size of oil faucet
    output reg        oFrameReset,       // Asserted for a frame to signal a reset command
    output reg        oFrameHold,        // Asserted for a frame to signal a screen pause
    output reg        oTrollBegin        // Asserted for a frame to signal a troll command
);
    
    // Buffer previous switch positions to make it possible to
    // detect changes from frame to frame.
    reg [17:0] SW_prev;
    always @(posedge iCLK) begin
        if(iNewFrame) begin
            SW_prev <= iSW;
        end
    end
    
    // Select input mode: 0 for keyboard, 1 for switches and buttons.
    reg InputByBoard;
    always @(posedge iCLK) begin
        InputByBoard <= iSW[16];
    end
    
    // Detect keyboard input during all cycles, but only act on it
    // once per frame at the iNewFrame signal.
    reg       PRESSED_RESET;
    reg       PRESSED_SAND_FAUCET;
    reg       PRESSED_WATER_FAUCET;
    reg       PRESSED_SALT_FAUCET;
    reg       PRESSED_OIL_FAUCET;
    reg       PRESSED_SIZE_MINUS;
    reg       PRESSED_SIZE_PLUS;
    reg       PRESSED_TROLL;
    reg       PRESSED_PAUSE;
    reg [3:0] CHOSEN_COLOR;
    reg       HOLDING_DRAW;
    reg       HOLDING_LEFT_ARROW;
    reg       HOLDING_RIGHT_ARROW;
    reg       HOLDING_UP_ARROW;
    reg       HOLDING_DOWN_ARROW;
    // Detect key presses.
    always @(posedge iCLK) begin
        if(iRESET | iNewFrame) begin
            PRESSED_RESET        <= (iEventType == `SC_MAKE_ESC);
            PRESSED_SAND_FAUCET  <= (iEventType == `SC_MAKE_1);
            PRESSED_WATER_FAUCET <= (iEventType == `SC_MAKE_2);
            PRESSED_SALT_FAUCET  <= (iEventType == `SC_MAKE_3);
            PRESSED_OIL_FAUCET   <= (iEventType == `SC_MAKE_4);
            PRESSED_SIZE_MINUS   <= (iEventType == `SC_MAKE_MINUS);
            PRESSED_SIZE_PLUS    <= (iEventType == `SC_MAKE_EQUALS);
            PRESSED_TROLL        <= (iEventType == `SC_MAKE_T);
            PRESSED_PAUSE        <= (iEventType == `SC_MAKE_P);
        end
        else begin
            if(iEventType == `SC_MAKE_ESC)    PRESSED_RESET        <= 1'b1;
            if(iEventType == `SC_MAKE_1)      PRESSED_SAND_FAUCET  <= 1'b1;
            if(iEventType == `SC_MAKE_2)      PRESSED_WATER_FAUCET <= 1'b1;
            if(iEventType == `SC_MAKE_3)      PRESSED_SALT_FAUCET  <= 1'b1;
            if(iEventType == `SC_MAKE_4)      PRESSED_OIL_FAUCET   <= 1'b1;
            if(iEventType == `SC_MAKE_MINUS)  PRESSED_SIZE_MINUS   <= 1'b1;
            if(iEventType == `SC_MAKE_EQUALS) PRESSED_SIZE_PLUS    <= 1'b1;
            if(iEventType == `SC_MAKE_T)      PRESSED_TROLL        <= 1'b1;
            if(iEventType == `SC_MAKE_P)      PRESSED_PAUSE        <= 1'b1;
        end
    end
    // Detect key presses that change the desired cursor color.
    always @(posedge iCLK) begin
        if(iRESET) begin
            CHOSEN_COLOR <= `PT_BLANK;
        end
        else if(iNewFrame & InputByBoard) begin
            CHOSEN_COLOR <= iSW[3:0];
        end
        else begin
            if     (iEventType == `SC_MAKE_A) CHOSEN_COLOR <= `PT_BLANK;
            else if(iEventType == `SC_MAKE_S) CHOSEN_COLOR <= `PT_FIRE0;
            else if(iEventType == `SC_MAKE_D) CHOSEN_COLOR <= `PT_TORCH;
            else if(iEventType == `SC_MAKE_F) CHOSEN_COLOR <= `PT_WATER;
            else if(iEventType == `SC_MAKE_G) CHOSEN_COLOR <= `PT_SAND;
            else if(iEventType == `SC_MAKE_H) CHOSEN_COLOR <= `PT_OIL;
            else if(iEventType == `SC_MAKE_Z) CHOSEN_COLOR <= `PT_SALT;
            else if(iEventType == `SC_MAKE_X) CHOSEN_COLOR <= `PT_CONC;
            else if(iEventType == `SC_MAKE_C) CHOSEN_COLOR <= `PT_WALL;
            else if(iEventType == `SC_MAKE_V) CHOSEN_COLOR <= `PT_PLANT;
            else if(iEventType == `SC_MAKE_B) CHOSEN_COLOR <= `PT_WAX;
            else if(iEventType == `SC_MAKE_N) CHOSEN_COLOR <= `PT_SPOUT;
        end
    end
    // Detect key holds.
    always @(posedge iCLK) begin
        if(iRESET) begin
            HOLDING_DRAW         <= 1'b0;
            HOLDING_LEFT_ARROW   <= 1'b0;
            HOLDING_RIGHT_ARROW  <= 1'b0;
            HOLDING_UP_ARROW     <= 1'b0;
            HOLDING_DOWN_ARROW   <= 1'b0;
        end
        else begin
            if(iEventType == `SC_MAKE_SPACE)             HOLDING_DRAW        <= 1'b1;
            else if(iEventType == `SC_BREAK_SPACE)       HOLDING_DRAW        <= 1'b0;
            if(iEventType == `SC_MAKE_LEFT_ARROW)        HOLDING_LEFT_ARROW  <= 1'b1;
            else if(iEventType == `SC_BREAK_LEFT_ARROW)  HOLDING_LEFT_ARROW  <= 1'b0;
            if(iEventType == `SC_MAKE_RIGHT_ARROW)       HOLDING_RIGHT_ARROW <= 1'b1;
            else if(iEventType == `SC_BREAK_RIGHT_ARROW) HOLDING_RIGHT_ARROW <= 1'b0;
            if(iEventType == `SC_MAKE_UP_ARROW)          HOLDING_UP_ARROW    <= 1'b1;
            else if(iEventType == `SC_BREAK_UP_ARROW)    HOLDING_UP_ARROW    <= 1'b0;
            if(iEventType == `SC_MAKE_DOWN_ARROW)        HOLDING_DOWN_ARROW  <= 1'b1;
            else if(iEventType == `SC_BREAK_DOWN_ARROW)  HOLDING_DOWN_ARROW  <= 1'b0;
        end
    end
    
    // Manage faucet size.
    always @(posedge iCLK) begin
        if(iRESET) begin
            oFaucetSize_SAND  <= 3'd1;
            oFaucetSize_WATER <= 3'd1;
            oFaucetSize_SALT  <= 3'd1;
            oFaucetSize_OIL   <= 3'd1;
        end
        else if(iNewFrame) begin
            if(InputByBoard) begin
                // When receiving input from the board, the faucet size is
                // increased by selecting a faucet with SW[5:4] and then
                // flicking SW[6] up.
                if((iSW[5:4] == 2'd0) & iSW[6] & ~SW_prev[6]) begin
                    oFaucetSize_SAND <= oFaucetSize_SAND + 3'd1;
                end
                if((iSW[5:4] == 2'd1) & iSW[6] & ~SW_prev[6]) begin
                    oFaucetSize_WATER <= oFaucetSize_WATER + 3'd1;
                end
                if((iSW[5:4] == 2'd2) & iSW[6] & ~SW_prev[6]) begin
                    oFaucetSize_SALT <= oFaucetSize_SALT + 3'd1;
                end
                if((iSW[5:4] == 2'd3) & iSW[6] & ~SW_prev[6]) begin
                    oFaucetSize_OIL <= oFaucetSize_OIL + 3'd1;
                end
            end
            else begin
                // When receiving input from the keyboard, the faucet size is
                // increased by pressing the appropriate faucet key.
                if(PRESSED_SAND_FAUCET) begin
                    oFaucetSize_SAND <= oFaucetSize_SAND + 3'd1;
                end
                if(PRESSED_WATER_FAUCET) begin
                    oFaucetSize_WATER <= oFaucetSize_WATER + 3'd1;
                end
                if(PRESSED_SALT_FAUCET) begin
                    oFaucetSize_SALT <= oFaucetSize_SALT + 3'd1;
                end
                if(PRESSED_OIL_FAUCET) begin
                    oFaucetSize_OIL <= oFaucetSize_OIL + 3'd1;
                end
            end
        end
    end
    
    // Detect screen reset command.
    always @(posedge iCLK) begin
        if(iNewFrame) begin
            if(InputByBoard) begin
                // When receiving input from the board, a reset command is
                // the first cycle when SW[16], SW[15], and SW[14] are all
                // asserted.
                oFrameReset <= iSW[16] & iSW[15] & iSW[14] & ~(SW_prev[16] & SW_prev[15] & SW_prev[14]);
            end
            else begin
                // When receiving input from the keyboard, a reset command is
                // just the reset key.
                oFrameReset <= PRESSED_RESET;
            end
        end
    end
    
    // Detect troll command.
    always @(posedge iCLK) begin
        if(iNewFrame) begin
            if(InputByBoard) begin
                // When receiving input from the board, a troll command is
                // the first cycle when SW[16], SW[15], and SW[13] are all
                // asserted.
                oTrollBegin <= iSW[16] & iSW[15] & iSW[13] & ~(SW_prev[16] & SW_prev[15] & SW_prev[13]);
            end
            else begin
                // When receiving input from the keyboard, a troll command is
                // just the troll key.
                oTrollBegin <= PRESSED_TROLL;
            end
        end
    end
    
    // Detect pauses and resumes.
    always @(posedge iCLK) begin
        if(iNewFrame) begin
            if(InputByBoard) begin
                // When receiving input from the board, the system is paused
                // when SW[14] is high, and unpaused when SW[14] is low.
                oFrameHold <= iSW[14];
            end
            else begin
                // When receiving input from the keyboard, pressing the pause
                // key will toggle whether the system is paused or not.
                if(PRESSED_PAUSE) begin
                    oFrameHold <= ~oFrameHold;
                end
            end
        end
    end
    
    // Manage cursor size.
    always @(posedge iCLK) begin
        if(iRESET) begin
            oCursorSize <= 4'd0;
        end
        else if(iNewFrame) begin
            if(InputByBoard) begin
                // When receiving input from the board, the cursor size is
                // determined directly by SW[11:8].
                oCursorSize <= iSW[11:8];
            end
            else begin
                // When receiving input from the keyboard, cursor size
                // goes up or down when the corresponding keys are pressed.
                if(PRESSED_SIZE_PLUS & (oCursorSize != 4'hF)) begin
                    oCursorSize <= oCursorSize + 4'd1;
                end
                else if(PRESSED_SIZE_MINUS & (oCursorSize != 4'd0)) begin
                    oCursorSize <= oCursorSize - 4'd1;
                end
            end
        end
    end
    
    // Manage cursor color.
    always @(posedge iCLK) begin
        if(iNewFrame) begin
            if(InputByBoard) begin
                // When receiving input from the board, the cursor color is
                // determined directly by SW[3:0].
                oCursorColor <= iSW[3:0];
            end
            else begin
                // When receiving input from the keyboard, cursor color
                // is the one chosen by pressing keys.
                oCursorColor <= CHOSEN_COLOR;
            end
        end
    end
    
    // Detect draw command.
    always @(posedge iCLK) begin
        if(iNewFrame) begin
            if(InputByBoard) begin
                // When receiving input from the board, the system will
                // draw as long as SW[17] is asserted.
                oCursorDraw <= iSW[17];
            end
            else begin
                // When receiving input from the keyboard, the system will
                // draw if the space bar is held.
                oCursorDraw <= HOLDING_DRAW;
            end
        end
    end
    
    // Manage cursor position.
    always @(posedge iCLK) begin
        if(iRESET) begin
            oCursorX <= 10'd320;
            oCursorY <= 10'd240;
        end
        else if(iNewFrame) begin
            if(InputByBoard) begin
                // When receiving input from the board, use the KEY
                // inputs to move the cursor.
                if(iKEY[0] & ~iKEY[3] & (oCursorX != 10'd0)) begin
                    oCursorX <= oCursorX - 10'd1;
                end
                else if(iKEY[3] & ~iKEY[0] & (oCursorX != 10'd639)) begin
                    oCursorX <= oCursorX + 10'd1;
                end
                if(iKEY[2] & ~iKEY[1] & (oCursorY != 10'd0)) begin
                    oCursorY <= oCursorY - 10'd1;
                end
                else if(iKEY[1] & ~iKEY[2] & (oCursorY != 10'd479)) begin
                    oCursorY <= oCursorY + 10'd1;
                end
            end
            else begin
                // When receiving input from the keyboard, use the
                // held arrow keys to move the cursor.
                if(HOLDING_LEFT_ARROW & ~HOLDING_RIGHT_ARROW & (oCursorX != 10'd0)) begin
                    oCursorX <= oCursorX - 10'd1;
                end
                else if(HOLDING_RIGHT_ARROW & ~HOLDING_LEFT_ARROW & (oCursorX != 10'd639)) begin
                    oCursorX <= oCursorX + 10'd1;
                end
                if(HOLDING_UP_ARROW & ~HOLDING_DOWN_ARROW & (oCursorY != 10'd0)) begin
                    oCursorY <= oCursorY - 10'd1;
                end
                else if(HOLDING_DOWN_ARROW & ~HOLDING_UP_ARROW & (oCursorY != 10'd479)) begin
                    oCursorY <= oCursorY + 10'd1;
                end
            end
        end
    end
    
endmodule
