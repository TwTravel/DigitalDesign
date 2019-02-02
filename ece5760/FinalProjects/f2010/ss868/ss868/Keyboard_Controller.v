/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// Module that reads entire scan codes from the PS2 keyboard,
// translates them into 8-bit even codes, and exports the events.
module Keyboard_Controller (
    input             iPS2_CLK,    // PS2 clock input (20~30KHz)
    input             iPS2_DAT,    // PS2 data input
    input             iCLK,        // System clock
    input             iRESET,      // System reset
    output reg        oEventReady, // Event has been read from keyboard
    output reg  [7:0] oEventType   // Which event was read
);
    
    // Receive bytes from keyboard.
    wire        ScanReady;
    wire [7:0]  ScanByte;
    PS2_ScanCodeReader PS2_SCR (
        .iPS2_CLK   (iPS2_CLK),
        .iPS2_DAT   (iPS2_DAT),
        .iCLK       (iCLK),
        .iRESET     (iRESET),
        .iRead      (ScanReady),
        .oScanReady (ScanReady),
        .oScanByte  (ScanByte)
    );
    
    // Translate full scan codes into events.
    wire [63:0] ScanCode;
    wire        EventReady;
    wire [7:0]  EventType;
    ScanCodeToEvent scte (
        .iScanCode   (ScanCode),
        .oEventReady (EventReady),
        .oEventType  (EventType)
    );
    
    // Parse scan bytes into scan codes.
    reg  [7:0]  ScanBytes [7:0];
    reg  [2:0]  ScanByteCntr;
    assign ScanCode = {ScanBytes[0], ScanBytes[1], ScanBytes[2], ScanBytes[3],
                       ScanBytes[4], ScanBytes[5], ScanBytes[6], ScanBytes[7]};
    always @(posedge iCLK) begin
        if(iRESET) begin
            ScanBytes[0] <= 8'h00;
            ScanBytes[1] <= 8'h00;
            ScanBytes[2] <= 8'h00;
            ScanBytes[3] <= 8'h00;
            ScanBytes[4] <= 8'h00;
            ScanBytes[5] <= 8'h00;
            ScanBytes[6] <= 8'h00;
            ScanBytes[7] <= 8'h00;
            ScanByteCntr <= 3'd0;
            oEventReady  <= 1'b0;
            oEventType   <= 8'b0;
        end
        else begin
            oEventReady  <= EventReady;
            oEventType   <= EventType;
            if(EventReady) begin
                // ScanCode has been read - clear it.
                ScanBytes[0] <= 8'h00;
                ScanBytes[1] <= 8'h00;
                ScanBytes[2] <= 8'h00;
                ScanBytes[3] <= 8'h00;
                ScanBytes[4] <= 8'h00;
                ScanBytes[5] <= 8'h00;
                ScanBytes[6] <= 8'h00;
                ScanBytes[7] <= 8'h00;
                ScanByteCntr <= 3'd0;
            end
            else if(ScanReady) begin
                // Shift in new scan byte.
                ScanBytes[ScanByteCntr] <= ScanByte;
                ScanByteCntr <= ScanByteCntr + 3'd1;
            end
        end
    end
    
endmodule
