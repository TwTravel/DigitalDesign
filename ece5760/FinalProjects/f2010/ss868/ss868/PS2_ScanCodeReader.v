/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// Module that reads bytes from the PS2 input and report them to
// some external module / system.
module PS2_ScanCodeReader (
    input            iPS2_CLK,   // PS2 clock input (20~30KHz)
    input            iPS2_DAT,   // PS2 data input
    input            iCLK,       // System clock
    input            iRESET,     // System reset
    input            iRead,      // System accepts scan byte
    output reg       oScanReady, // Asserted when a scan byte is ready
    output reg [7:0] oScanByte   // The scan byte that was read
);
    
    reg       ReadingChar;
    
    reg [3:0] BitCntr;
    reg [8:0] ShiftIn;
    
    reg [7:0] PS2_CLK_buffer;
    reg       PS2_CLK_debounced;
    reg       PS2_CLK_debounced_prev;
    wire      PS2_CLK_POSEDGE;
    
    assign PS2_CLK_POSEDGE = PS2_CLK_debounced & ~PS2_CLK_debounced_prev;
    
    // This process reads in serial data coming from the terminal.
    always @(posedge iCLK) begin
        if(iRESET) begin
            PS2_CLK_buffer         <= 8'b0;
            PS2_CLK_debounced      <= 1'b0;
            PS2_CLK_debounced_prev <= 1'b0;
            BitCntr                <= 4'd0;
            ReadingChar            <= 1'b0;
            oScanReady             <= 1'b0;
        end
        else begin
            // Debounce the PS2_CLK.
            PS2_CLK_buffer <= {iPS2_CLK, PS2_CLK_buffer[7:1]};
            if(PS2_CLK_buffer == 8'hFF) begin
                PS2_CLK_debounced <= 1'b1;
            end
            else if(PS2_CLK_buffer == 8'h00) begin
                PS2_CLK_debounced <= 1'b0;
            end
            PS2_CLK_debounced_prev <= PS2_CLK_debounced;
            
            if(PS2_CLK_POSEDGE) begin
                // PS2_CLK has risen.
                if(~ReadingChar) begin
                    // Catch trigger to start assembling a scan byte.
                    if(~iPS2_DAT) ReadingChar <= 1'b1;
                end
                else begin
                    // Shift in 8 data bits to assemble a scan byte.
                    if(BitCntr == 4'd9) begin
                        // Already received eight bits - output scan byte.
                        BitCntr     <= 4'd0;
                        oScanByte   <= ShiftIn[7:0];
                        ReadingChar <= 1'b0;
                    end
                    else begin
                        BitCntr     <= BitCntr + 4'd1;
                        ShiftIn     <= {iPS2_DAT, ShiftIn[8:1]};
                    end
                end
            end
            
            // oScanReady is raised when a scan byte has been assembled,
            // and it is cleared the next time the clock ticks and iRead is asserted.
            if (PS2_CLK_POSEDGE & ReadingChar & (BitCntr == 4'd9)) begin
                oScanReady <= 1'b1;
            end
            else if(iRead) begin
                oScanReady <= 1'b0;
            end
            
        end
    end
    
endmodule
