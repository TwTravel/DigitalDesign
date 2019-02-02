/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// RAM that stores 256 16-bit values.
module RAM_256_16 (
    input              iCLK,    // Clock signal for reading/writing
    input      [7:0]   iAddr,   // Address to read or write
    input      [15:0]  iData,   // Data to write
    input              iWen,    // Write enable
    output reg [15:0]  oData    // Data that was read
);
    
    reg [15:0] RAM [255:0];
    
    always @(posedge iCLK) begin
        oData <= RAM[iAddr];
        if(iWen) begin
            RAM[iAddr] <= iData;
        end
    end
    
endmodule
