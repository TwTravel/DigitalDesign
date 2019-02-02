/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// altera message_off 10762

`include "scan_events.h"

// Module that combinationally translates scan codes into events.
module ScanCodeToEvent (
    input      [63:0] iScanCode,   // Scan code that has been read so far
    output reg        oEventReady, // Asserted if the scan code is valid
    output reg [7:0]  oEventType   // Type of event triggered by scan code
);
    
    always @(*) begin
        oEventReady = 1'b1;
        casex(iScanCode)
            
            // MAKE CODES
            
            64'h76xxxxxxxxxxxxxx : begin // make ESC
                oEventType = `SC_MAKE_ESC;
            end
            64'h05xxxxxxxxxxxxxx : begin // make F1
                oEventType = `SC_MAKE_F1;
            end
            64'h06xxxxxxxxxxxxxx : begin // make F2
                oEventType = `SC_MAKE_F2;
            end
            64'h04xxxxxxxxxxxxxx : begin // make F3
                oEventType = `SC_MAKE_F3;
            end
            64'h0Cxxxxxxxxxxxxxx : begin // make F4
                oEventType = `SC_MAKE_F4;
            end
            64'h03xxxxxxxxxxxxxx : begin // make F5
                oEventType = `SC_MAKE_F5;
            end
            64'h0Bxxxxxxxxxxxxxx : begin // make F6
                oEventType = `SC_MAKE_F6;
            end
            64'h83xxxxxxxxxxxxxx : begin // make F7
                oEventType = `SC_MAKE_F7;
            end
            64'h0Axxxxxxxxxxxxxx : begin // make F8
                oEventType = `SC_MAKE_F8;
            end
            64'h01xxxxxxxxxxxxxx : begin // make F9
                oEventType = `SC_MAKE_F9;
            end
            64'h09xxxxxxxxxxxxxx : begin // make F10
                oEventType = `SC_MAKE_F10;
            end
            64'h78xxxxxxxxxxxxxx : begin // make F11
                oEventType = `SC_MAKE_F11;
            end
            64'h07xxxxxxxxxxxxxx : begin // make F12
                oEventType = `SC_MAKE_F12;
            end
            64'hE012E07Cxxxxxxxx : begin // make Prt Scr
                oEventType = `SC_MAKE_PRT_SCR;
            end
            64'h7Exxxxxxxxxxxxxx : begin // make Scroll Lock
                oEventType = `SC_MAKE_SCR_LOCK;
            end
            64'hE11477E1F014E077 : begin // make Pause/Break
                oEventType = `SC_MAKE_PAUSE;
            end
            64'h0Exxxxxxxxxxxxxx : begin // make `
                oEventType = `SC_MAKE_TILDE;
            end
            64'h16xxxxxxxxxxxxxx : begin // make 1
                oEventType = `SC_MAKE_1;
            end
            64'h1Exxxxxxxxxxxxxx : begin // make 2
                oEventType = `SC_MAKE_2;
            end
            64'h26xxxxxxxxxxxxxx : begin // make 3
                oEventType = `SC_MAKE_3;
            end
            64'h25xxxxxxxxxxxxxx : begin // make 4
                oEventType = `SC_MAKE_4;
            end
            64'h2Exxxxxxxxxxxxxx : begin // make 5
                oEventType = `SC_MAKE_5;
            end
            64'h36xxxxxxxxxxxxxx : begin // make 6
                oEventType = `SC_MAKE_6;
            end
            64'h3Dxxxxxxxxxxxxxx : begin // make 7
                oEventType = `SC_MAKE_7;
            end
            64'h3Exxxxxxxxxxxxxx : begin // make 8
                oEventType = `SC_MAKE_8;
            end
            64'h46xxxxxxxxxxxxxx : begin // make 9
                oEventType = `SC_MAKE_9;
            end
            64'h45xxxxxxxxxxxxxx : begin // make 0
                oEventType = `SC_MAKE_0;
            end
            64'h4Exxxxxxxxxxxxxx : begin // make -
                oEventType = `SC_MAKE_MINUS;
            end
            64'h55xxxxxxxxxxxxxx : begin // make =
                oEventType = `SC_MAKE_EQUALS;
            end
            64'h66xxxxxxxxxxxxxx : begin // make BackSpace
                oEventType = `SC_MAKE_BACKSPACE;
            end
            64'h0Dxxxxxxxxxxxxxx : begin // make Tab
                oEventType = `SC_MAKE_TAB;
            end
            64'h15xxxxxxxxxxxxxx : begin // make Q
                oEventType = `SC_MAKE_Q;
            end
            64'h1Dxxxxxxxxxxxxxx : begin // make W
                oEventType = `SC_MAKE_W;
            end
            64'h24xxxxxxxxxxxxxx : begin // make E
                oEventType = `SC_MAKE_E;
            end
            64'h2Dxxxxxxxxxxxxxx : begin // make R
                oEventType = `SC_MAKE_R;
            end
            64'h2Cxxxxxxxxxxxxxx : begin // make T
                oEventType = `SC_MAKE_T;
            end
            64'h35xxxxxxxxxxxxxx : begin // make Y
                oEventType = `SC_MAKE_Y;
            end
            64'h3Cxxxxxxxxxxxxxx : begin // make U
                oEventType = `SC_MAKE_U;
            end
            64'h43xxxxxxxxxxxxxx : begin // make I
                oEventType = `SC_MAKE_I;
            end
            64'h44xxxxxxxxxxxxxx : begin // make O
                oEventType = `SC_MAKE_O;
            end
            64'h4Dxxxxxxxxxxxxxx : begin // make P
                oEventType = `SC_MAKE_P;
            end
            64'h54xxxxxxxxxxxxxx : begin // make [
                oEventType = `SC_MAKE_LF_BRACKET;
            end
            64'h5Bxxxxxxxxxxxxxx : begin // make ]
                oEventType = `SC_MAKE_RT_BRACKET;
            end
            64'h5Dxxxxxxxxxxxxxx : begin // make "\"
                oEventType = `SC_MAKE_BACKSLASH;
            end
            64'h58xxxxxxxxxxxxxx : begin // make Caps Lock
                oEventType = `SC_MAKE_CAPS_LOCK;
            end
            64'h1Cxxxxxxxxxxxxxx : begin // make A
                oEventType = `SC_MAKE_A;
            end
            64'h1Bxxxxxxxxxxxxxx : begin // make S
                oEventType = `SC_MAKE_S;
            end
            64'h23xxxxxxxxxxxxxx : begin // make D
                oEventType = `SC_MAKE_D;
            end
            64'h2Bxxxxxxxxxxxxxx : begin // make F
                oEventType = `SC_MAKE_F;
            end
            64'h34xxxxxxxxxxxxxx : begin // make G
                oEventType = `SC_MAKE_G;
            end
            64'h33xxxxxxxxxxxxxx : begin // make H
                oEventType = `SC_MAKE_H;
            end
            64'h3Bxxxxxxxxxxxxxx : begin // make J
                oEventType = `SC_MAKE_J;
            end
            64'h42xxxxxxxxxxxxxx : begin // make K
                oEventType = `SC_MAKE_K;
            end
            64'h4Bxxxxxxxxxxxxxx : begin // make L 
                oEventType = `SC_MAKE_L;
            end
            64'h4Cxxxxxxxxxxxxxx : begin // make ;
                oEventType = `SC_MAKE_SEMICOLON;
            end
            64'h52xxxxxxxxxxxxxx : begin // make '
                oEventType = `SC_MAKE_APOSTROPHE;
            end
            64'h5Axxxxxxxxxxxxxx : begin // make Enter
                oEventType = `SC_MAKE_ENTER;
            end
            64'h12xxxxxxxxxxxxxx : begin // make Shift
                oEventType = `SC_MAKE_LF_SHIFT;
            end
            64'h1Axxxxxxxxxxxxxx : begin // make Z
                oEventType = `SC_MAKE_Z;
            end
            64'h22xxxxxxxxxxxxxx : begin // make X
                oEventType = `SC_MAKE_X;
            end
            64'h21xxxxxxxxxxxxxx : begin // make C
                oEventType = `SC_MAKE_C;
            end
            64'h2Axxxxxxxxxxxxxx : begin // make V
                oEventType = `SC_MAKE_V;
            end
            64'h32xxxxxxxxxxxxxx : begin // make B
                oEventType = `SC_MAKE_B;
            end
            64'h31xxxxxxxxxxxxxx : begin // make N
                oEventType = `SC_MAKE_N;
            end
            64'h3Axxxxxxxxxxxxxx : begin // make M
                oEventType = `SC_MAKE_M;
            end
            64'h41xxxxxxxxxxxxxx : begin // make ,
                oEventType = `SC_MAKE_COMMA;
            end
            64'h49xxxxxxxxxxxxxx : begin // make .
                oEventType = `SC_MAKE_PERIOD;
            end
            64'h4Axxxxxxxxxxxxxx : begin // make /
                oEventType = `SC_MAKE_FRONTSLASH;
            end
            64'h59xxxxxxxxxxxxxx : begin // make Right Shift
                oEventType = `SC_MAKE_RT_SHIFT;
            end
            64'h14xxxxxxxxxxxxxx : begin // make Ctrl
                oEventType = `SC_MAKE_LF_CTRL;
            end
            64'hE01Fxxxxxxxxxxxx : begin // make Windows
                oEventType = `SC_MAKE_LF_WINDOWS;
            end
            64'h11xxxxxxxxxxxxxx : begin // make Alt
                oEventType = `SC_MAKE_LF_ALT;
            end
            64'h29xxxxxxxxxxxxxx : begin // make Spacebar
                oEventType = `SC_MAKE_SPACE;
            end
            64'hE011xxxxxxxxxxxx : begin // make Right Alt
                oEventType = `SC_MAKE_RT_ALT;
            end
            64'hE027xxxxxxxxxxxx : begin // make Right Windows
                oEventType = `SC_MAKE_RT_WINDOWS;
            end
            64'hE02Fxxxxxxxxxxxx : begin // make Menus
                oEventType = `SC_MAKE_MENUS;
            end
            64'hE014xxxxxxxxxxxx : begin // make Right Ctrl
                oEventType = `SC_MAKE_RT_CTRL;
            end
            64'hE070xxxxxxxxxxxx : begin // make Insert
                oEventType = `SC_MAKE_INSERT;
            end
            64'hE06Cxxxxxxxxxxxx : begin // make Home
                oEventType = `SC_MAKE_HOME;
            end
            64'hE07Dxxxxxxxxxxxx : begin // make Page Up
                oEventType = `SC_MAKE_PAGE_UP;
            end
            64'hE071xxxxxxxxxxxx : begin // make Delete
                oEventType = `SC_MAKE_DEL;
            end
            64'hE069xxxxxxxxxxxx : begin // make End
                oEventType = `SC_MAKE_END;
            end
            64'hE07Axxxxxxxxxxxx : begin // make Page Down
                oEventType = `SC_MAKE_PAGE_DOWN;
            end
            64'hE075xxxxxxxxxxxx : begin // make Up Arrow
                oEventType = `SC_MAKE_UP_ARROW;
            end
            64'hE06Bxxxxxxxxxxxx : begin // make Left Arrow
                oEventType = `SC_MAKE_LEFT_ARROW;
            end
            64'hE072xxxxxxxxxxxx : begin // make Down Arrow
                oEventType = `SC_MAKE_DOWN_ARROW;
            end
            64'hE074xxxxxxxxxxxx : begin // make Right Arrow
                oEventType = `SC_MAKE_RIGHT_ARROW;
            end
            64'h77xxxxxxxxxxxxxx : begin // make Num Lock
                oEventType = `SC_MAKE_NUM_LOCK;
            end
            64'hE04Axxxxxxxxxxxx : begin // make Right /
                oEventType = `SC_MAKE_NUMPAD_FRONTSLASH;
            end
            64'h7Cxxxxxxxxxxxxxx : begin // make Right *
                oEventType = `SC_MAKE_NUMPAD_ASTERISK;
            end
            64'h7Bxxxxxxxxxxxxxx : begin // make Right -
                oEventType = `SC_MAKE_NUMPAD_MINUS;
            end
            64'h6Cxxxxxxxxxxxxxx : begin // make Right 7
                oEventType = `SC_MAKE_NUMPAD_7;
            end
            64'h75xxxxxxxxxxxxxx : begin // make Right 8
                oEventType = `SC_MAKE_NUMPAD_8;
            end
            64'h7Dxxxxxxxxxxxxxx : begin // make Right 9
                oEventType = `SC_MAKE_NUMPAD_9;
            end
            64'h79xxxxxxxxxxxxxx : begin // make Right +
                oEventType = `SC_MAKE_NUMPAD_PLUS;
            end
            64'h6Bxxxxxxxxxxxxxx : begin // make Right 4
                oEventType = `SC_MAKE_NUMPAD_4;
            end
            64'h73xxxxxxxxxxxxxx : begin // make Right 5
                oEventType = `SC_MAKE_NUMPAD_5;
            end
            64'h74xxxxxxxxxxxxxx : begin // make Right 6
                oEventType = `SC_MAKE_NUMPAD_6;
            end
            64'h69xxxxxxxxxxxxxx : begin // make Right 1
                oEventType = `SC_MAKE_NUMPAD_1;
            end
            64'h72xxxxxxxxxxxxxx : begin // make Right 2
                oEventType = `SC_MAKE_NUMPAD_2;
            end
            64'h7Axxxxxxxxxxxxxx : begin // make Right 3
                oEventType = `SC_MAKE_NUMPAD_3;
            end
            64'h70xxxxxxxxxxxxxx : begin // make Right 0
                oEventType = `SC_MAKE_NUMPAD_0;
            end
            64'h71xxxxxxxxxxxxxx : begin // make Right .
                oEventType = `SC_MAKE_NUMPAD_PERIOD;
            end
            64'hE05Axxxxxxxxxxxx : begin // make Right Enter
                oEventType = `SC_MAKE_NUMPAD_ENTER;
            end
            
            // BREAK CODES
            
            64'hF076xxxxxxxxxxxx : begin // break ESC
                oEventType = `SC_BREAK_ESC;
            end
            64'hF005xxxxxxxxxxxx : begin // break F1
                oEventType = `SC_BREAK_F1;
            end
            64'hF006xxxxxxxxxxxx : begin // break F2
                oEventType = `SC_BREAK_F2;
            end
            64'hF004xxxxxxxxxxxx : begin // break F3
                oEventType = `SC_BREAK_F3;
            end
            64'hF00Cxxxxxxxxxxxx : begin // break F4
                oEventType = `SC_BREAK_F4;
            end
            64'hF003xxxxxxxxxxxx : begin // break F5
                oEventType = `SC_BREAK_F5;
            end
            64'hF00Bxxxxxxxxxxxx : begin // break F6
                oEventType = `SC_BREAK_F6;
            end
            64'hF083xxxxxxxxxxxx : begin // break F7
                oEventType = `SC_BREAK_F7;
            end
            64'hF00Axxxxxxxxxxxx : begin // break F8
                oEventType = `SC_BREAK_F8;
            end
            64'hF001xxxxxxxxxxxx : begin // break F9
                oEventType = `SC_BREAK_F9;
            end
            64'hF009xxxxxxxxxxxx : begin // break F10
                oEventType = `SC_BREAK_F10;
            end
            64'hF078xxxxxxxxxxxx : begin // break F11
                oEventType = `SC_BREAK_F11;
            end
            64'hF007xxxxxxxxxxxx : begin // break F12
                oEventType = `SC_BREAK_F12;
            end
            64'hE0F07CE0F012xxxx : begin // break Prt Scr
                oEventType = `SC_BREAK_PRT_SCR;
            end
            64'hF07Exxxxxxxxxxxx : begin // break Scroll Lock
                oEventType = `SC_BREAK_SCR_LOCK;
            end
            64'hF00Exxxxxxxxxxxx : begin // break `
                oEventType = `SC_BREAK_TILDE;
            end
            64'hF016xxxxxxxxxxxx : begin // break 1
                oEventType = `SC_BREAK_1;
            end
            64'hF01Exxxxxxxxxxxx : begin // break 2
                oEventType = `SC_BREAK_2;
            end
            64'hF026xxxxxxxxxxxx : begin // break 3
                oEventType = `SC_BREAK_3;
            end
            64'hF025xxxxxxxxxxxx : begin // break 4
                oEventType = `SC_BREAK_4;
            end
            64'hF02Exxxxxxxxxxxx : begin // break 5
                oEventType = `SC_BREAK_5;
            end
            64'hF036xxxxxxxxxxxx : begin // break 6
                oEventType = `SC_BREAK_6;
            end
            64'hF03Dxxxxxxxxxxxx : begin // break 7
                oEventType = `SC_BREAK_7;
            end
            64'hF03Exxxxxxxxxxxx : begin // break 8
                oEventType = `SC_BREAK_8;
            end
            64'hF046xxxxxxxxxxxx : begin // break 9
                oEventType = `SC_BREAK_9;
            end
            64'hF045xxxxxxxxxxxx : begin // break 0
                oEventType = `SC_BREAK_0;
            end
            64'hF04Exxxxxxxxxxxx : begin // break -
                oEventType = `SC_BREAK_MINUS;
            end
            64'hF055xxxxxxxxxxxx : begin // break =
                oEventType = `SC_BREAK_EQUALS;
            end
            64'hF066xxxxxxxxxxxx : begin // break BackSpace
                oEventType = `SC_BREAK_BACKSPACE;
            end
            64'hF00Dxxxxxxxxxxxx : begin // break Tab
                oEventType = `SC_BREAK_TAB;
            end
            64'hF015xxxxxxxxxxxx : begin // break Q
                oEventType = `SC_BREAK_Q;
            end
            64'hF01Dxxxxxxxxxxxx : begin // break W
                oEventType = `SC_BREAK_W;
            end
            64'hF024xxxxxxxxxxxx : begin // break E
                oEventType = `SC_BREAK_E;
            end
            64'hF02Dxxxxxxxxxxxx : begin // break R
                oEventType = `SC_BREAK_R;
            end
            64'hF02Cxxxxxxxxxxxx : begin // break T
                oEventType = `SC_BREAK_T;
            end
            64'hF035xxxxxxxxxxxx : begin // break Y
                oEventType = `SC_BREAK_Y;
            end
            64'hF03Cxxxxxxxxxxxx : begin // break U
                oEventType = `SC_BREAK_U;
            end
            64'hF043xxxxxxxxxxxx : begin // break I
                oEventType = `SC_BREAK_I;
            end
            64'hF044xxxxxxxxxxxx : begin // break O
                oEventType = `SC_BREAK_O;
            end
            64'hF04Dxxxxxxxxxxxx : begin // break P
                oEventType = `SC_BREAK_P;
            end
            64'hF054xxxxxxxxxxxx : begin // break [
                oEventType = `SC_BREAK_LF_BRACKET;
            end
            64'hF05Bxxxxxxxxxxxx : begin // break ]
                oEventType = `SC_BREAK_RT_BRACKET;
            end
            64'hF05Dxxxxxxxxxxxx : begin // break "\"
                oEventType = `SC_BREAK_BACKSLASH;
            end
            64'hF058xxxxxxxxxxxx : begin // break Caps Lock
                oEventType = `SC_BREAK_CAPS_LOCK;
            end
            64'hF01Cxxxxxxxxxxxx : begin // break A
                oEventType = `SC_BREAK_A;
            end
            64'hF01Bxxxxxxxxxxxx : begin // break S
                oEventType = `SC_BREAK_S;
            end
            64'hF023xxxxxxxxxxxx : begin // break D
                oEventType = `SC_BREAK_D;
            end
            64'hF02Bxxxxxxxxxxxx : begin // break F
                oEventType = `SC_BREAK_F;
            end
            64'hF034xxxxxxxxxxxx : begin // break G
                oEventType = `SC_BREAK_G;
            end
            64'hF033xxxxxxxxxxxx : begin // break H
                oEventType = `SC_BREAK_H;
            end
            64'hF03Bxxxxxxxxxxxx : begin // break J
                oEventType = `SC_BREAK_J;
            end
            64'hF042xxxxxxxxxxxx : begin // break K
                oEventType = `SC_BREAK_K;
            end
            64'hF04Bxxxxxxxxxxxx : begin // break L
                oEventType = `SC_BREAK_L;
            end
            64'hF04Cxxxxxxxxxxxx : begin // break ;
                oEventType = `SC_BREAK_SEMICOLON;
            end
            64'hF052xxxxxxxxxxxx : begin // break '
                oEventType = `SC_BREAK_APOSTROPHE;
            end
            64'hF05Axxxxxxxxxxxx : begin // break Enter
                oEventType = `SC_BREAK_ENTER;
            end
            64'hF012xxxxxxxxxxxx : begin // break Shift
                oEventType = `SC_BREAK_LF_SHIFT;
            end
            64'hF01Axxxxxxxxxxxx : begin // break Z
                oEventType = `SC_BREAK_Z;
            end
            64'hF022xxxxxxxxxxxx : begin // break X
                oEventType = `SC_BREAK_X;
            end
            64'hF021xxxxxxxxxxxx : begin // break C
                oEventType = `SC_BREAK_C;
            end
            64'hF02Axxxxxxxxxxxx : begin // break V
                oEventType = `SC_BREAK_V;
            end
            64'hF032xxxxxxxxxxxx : begin // break B
                oEventType = `SC_BREAK_B;
            end
            64'hF031xxxxxxxxxxxx : begin // break N
                oEventType = `SC_BREAK_N;
            end
            64'hF03Axxxxxxxxxxxx : begin // break M
                oEventType = `SC_BREAK_M;
            end
            64'hF041xxxxxxxxxxxx : begin // break ,
                oEventType = `SC_BREAK_COMMA;
            end
            64'hF049xxxxxxxxxxxx : begin // break .
                oEventType = `SC_BREAK_PERIOD;
            end
            64'hF04Axxxxxxxxxxxx : begin // break /
                oEventType = `SC_BREAK_FRONTSLASH;
            end
            64'hF059xxxxxxxxxxxx : begin // break Right Shift
                oEventType = `SC_BREAK_RT_SHIFT;
            end
            64'hF014xxxxxxxxxxxx : begin // break Ctrl
                oEventType = `SC_BREAK_LF_CTRL;
            end
            64'hE0F01Fxxxxxxxxxx : begin // break Windows
                oEventType = `SC_BREAK_LF_WINDOWS;
            end
            64'hF011xxxxxxxxxxxx : begin // break Alt
                oEventType = `SC_BREAK_LF_ALT;
            end
            64'hF029xxxxxxxxxxxx : begin // break Spacebar
                oEventType = `SC_BREAK_SPACE;
            end
            64'hE0F011xxxxxxxxxx : begin // break Right Alt
                oEventType = `SC_BREAK_RT_ALT;
            end
            64'hE0F027xxxxxxxxxx : begin // break Right Windows
                oEventType = `SC_BREAK_RT_WINDOWS;
            end
            64'hE0F02Fxxxxxxxxxx : begin // break Menus
                oEventType = `SC_BREAK_MENUS;
            end
            64'hE0F014xxxxxxxxxx : begin // break Right Ctrl
                oEventType = `SC_BREAK_RT_CTRL;
            end
            64'hE0F070xxxxxxxxxx : begin // break Insert
                oEventType = `SC_BREAK_INSERT;
            end
            64'hE0F06Cxxxxxxxxxx : begin // break Home
                oEventType = `SC_BREAK_HOME;
            end
            64'hE0F07Dxxxxxxxxxx : begin // break Page Up
                oEventType = `SC_BREAK_PAGE_UP;
            end
            64'hE0F071xxxxxxxxxx : begin // break Delete
                oEventType = `SC_BREAK_DEL;
            end
            64'hE0F069xxxxxxxxxx : begin // break End
                oEventType = `SC_BREAK_END;
            end
            64'hE0F07Axxxxxxxxxx : begin // break Page Down
                oEventType = `SC_BREAK_PAGE_DOWN;
            end
            64'hE0F075xxxxxxxxxx : begin // break Up Arrow
                oEventType = `SC_BREAK_UP_ARROW;
            end
            64'hE0F06Bxxxxxxxxxx : begin // break Left Arrow
                oEventType = `SC_BREAK_LEFT_ARROW;
            end
            64'hE0F072xxxxxxxxxx : begin // break Down Arrow
                oEventType = `SC_BREAK_DOWN_ARROW;
            end
            64'hE0F074xxxxxxxxxx : begin // break Right Arrow
                oEventType = `SC_BREAK_RIGHT_ARROW;
            end
            64'hF077xxxxxxxxxxxx : begin // break Num Lock
                oEventType = `SC_BREAK_NUM_LOCK;
            end
            64'hE0F04Axxxxxxxxxx : begin // break Right /
                oEventType = `SC_BREAK_NUMPAD_FRONTSLASH;
            end
            64'hF07Cxxxxxxxxxxxx : begin // break Right *
                oEventType = `SC_BREAK_NUMPAD_ASTERISK;
            end
            64'hF07Bxxxxxxxxxxxx : begin // break Right -
                oEventType = `SC_BREAK_NUMPAD_MINUS;
            end
            64'hF06Cxxxxxxxxxxxx : begin // break Right 7
                oEventType = `SC_BREAK_NUMPAD_7;
            end
            64'hF075xxxxxxxxxxxx : begin // break Right 8
                oEventType = `SC_BREAK_NUMPAD_8;
            end
            64'hF07Dxxxxxxxxxxxx : begin // break Right 9
                oEventType = `SC_BREAK_NUMPAD_9;
            end
            64'hF079xxxxxxxxxxxx : begin // break Right +
                oEventType = `SC_BREAK_NUMPAD_PLUS;
            end
            64'hF06Bxxxxxxxxxxxx : begin // break Right 4
                oEventType = `SC_BREAK_NUMPAD_4;
            end
            64'hF073xxxxxxxxxxxx : begin // break Right 5
                oEventType = `SC_BREAK_NUMPAD_5;
            end
            64'hF074xxxxxxxxxxxx : begin // break Right 6
                oEventType = `SC_BREAK_NUMPAD_6;
            end
            64'hF069xxxxxxxxxxxx : begin // break Right 1
                oEventType = `SC_BREAK_NUMPAD_1;
            end
            64'hF072xxxxxxxxxxxx : begin // break Right 2
                oEventType = `SC_BREAK_NUMPAD_2;
            end
            64'hF07Axxxxxxxxxxxx : begin // break Right 3
                oEventType = `SC_BREAK_NUMPAD_3;
            end
            64'hF070xxxxxxxxxxxx : begin // break Right 0
                oEventType = `SC_BREAK_NUMPAD_0;
            end
            64'hF071xxxxxxxxxxxx : begin // break Right .
                oEventType = `SC_BREAK_NUMPAD_PERIOD;
            end
            64'hE0F05Axxxxxxxxxx : begin // break Right Enter
                oEventType = `SC_BREAK_NUMPAD_ENTER;
            end
            
            // DEFAULT CASE
            
            default : begin // not a match - need more
                oEventType  = `SC_NONE;
                oEventReady = 1'b0;
            end
            
        endcase
    end
    
endmodule
