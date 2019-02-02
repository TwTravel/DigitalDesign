/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// Module that controls SRAM writes and reads. Every 8-cycle phase,
// there are two cycles allocated to handling the VGA read request,
// two cycles allocated to handling the CA read request, and two
// cycles allocated to handling the CA write request. Each SRAM
// transaction requires 5-15ns, so a one-cycle transaction at 50.4MHz
// can sometimes cause mistakes.
module SRAM_Controller (
    input             iCLK,          // System clock
    input             iRESET,        // System reset
    input      [2:0]  iSystemState,  // Current clock cycle within the 8-cycle phase
    input             iNewFrame,     // Asserted for one cycle to signal start of a new frame
    // VGA side
    input      [18:0] iVGA_ADDR,     // Pixel address of pixel whose color VGA is requesting in 6 cycles
    output     [3:0]  oVGA_Color,    // The color of the pixel requested 5 cycles ago
    // CA side
    input      [16:0] iCA_ReadAddr,  // The read address for reads by the Cellular Automaton
    output reg [15:0] oCA_ReadData,  // The read data returned to the Cellular Automaton
    input      [16:0] iCA_WriteAddr, // The write address for writes by the Cellular Automaton
    input      [15:0] iCA_WriteData, // The write data sent by the Cellular Automaton
    input             iCA_WriteEn,   // The write enable sent by the Cellular Automaton
    // SRAM signals
    inout      [15:0] SRAM_DQ,       // SRAM Data bus 16 Bits
    output reg [17:0] oSRAM_ADDR,    // SRAM Address bus 18 Bits
    output            oSRAM_UB_N,    // SRAM High-byte Data Mask 
    output            oSRAM_LB_N,    // SRAM Low-byte Data Mask 
    output reg        oSRAM_WE_N,    // SRAM Write Enable
    output            oSRAM_CE_N,    // SRAM Chip Enable
    output            oSRAM_OE_N     // SRAM Output Enable
);
    
    // Toggle memRegion every VGA frame. This alternates
    // between low and high memory for the old and new frames.
    reg memRegion;
    always @(posedge iCLK) begin
        if(iRESET) begin
            memRegion <= 1'b0;
        end
        else if(iNewFrame) begin
            memRegion <= ~memRegion;
        end
    end
    
    // Drive the address, data, and write enable of SRAM.
    reg [15:0] DQ_out;
    always @(posedge iCLK) begin
        if(iSystemState == 3'd0) begin
            // During cycles 1 and 2, the SRAM will perform
            // a load to handle the CA request.
            oSRAM_ADDR <= {memRegion, iCA_ReadAddr};
        end
        else if(iSystemState == 3'd2) begin
            // During cycles 3 and 4, the SRAM will perform
            // a load to handle the VGA request.
            oSRAM_ADDR <= {memRegion, iVGA_ADDR[18:2]};
        end
        else if(iSystemState == 3'd5) begin
            // During cycles 6 and 7, the SRAM will perform
            // a store to handle the CA request.
            oSRAM_ADDR <= {~memRegion, iCA_WriteAddr};
            oSRAM_WE_N <= ~iCA_WriteEn;
            DQ_out     <= iCA_WriteData;
        end
        else if(iSystemState == 3'd7) begin
            // Turn off the write enable after the write is done.
            oSRAM_WE_N <= 1'b1;
        end
    end
    
    // Only drive SRAM_DQ when writing to SRAM, not when reading.
    assign SRAM_DQ = oSRAM_WE_N ? 16'hzzzz : DQ_out;
    assign oSRAM_CE_N = 1'b0; // Chip enabled.
    assign oSRAM_LB_N = 1'b0; // Lower byte select enabled.
    assign oSRAM_OE_N = 1'b0; // Output enable is overidden by WE.
    assign oSRAM_UB_N = 1'b0; // Upper byte select enabled.
    
    /**************************************************
     * VGA Color Lookup Logic                         *
     **************************************************/
    
    reg [15:0] VGA_datareg;
    always @(posedge iCLK) begin
        if(iSystemState == 3'd4) begin
            // The VGA read happens during cycles 3 and 4,
            // so at the end of cycle 4, the VGA data is
            // ready to be buffered.
            VGA_datareg <= SRAM_DQ;
        end
        else if(~iSystemState[0]) begin
            // When the load from SRAM performs, VGA_datareg
            // had loaded pixel data for four pixels, with the
            // leftmost pixel in the lowest four bits. Every
            // two cycles after that, shift the next pixel
            // into the lowest four bits.
            VGA_datareg <= {4'b0, VGA_datareg[15:4]};
        end
    end
    
    // Output the lowest four bits of VGA_datareg as the value
    // of the pixel whose coordinates were requested 5 cycles ago.
    assign oVGA_Color = VGA_datareg[3:0];
    
    /**************************************************
     * CA Read Logic                                  *
     **************************************************/
    
    always @(posedge iCLK) begin
        if(iSystemState == 3'd2) begin
            // The CA read happens during cycles 1 and 2,
            // so at the end of cycle 2, the CA data is
            // ready to be buffered.
            oCA_ReadData <= SRAM_DQ;
        end
    end
    
endmodule
