/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

`define SEED_0 {5{32'hDEADBEEF}}
`define SEED_1 {5{32'hC001C0DE}}
`define SEED_2 {5{32'hFEEDFACE}}
`define SEED_3 {5{32'hECE05760}}

// This is a module that generates a 4-bit random vector.
// It seeds four 160-bit LFSRs with different seeds and
// then updates them every clock cycle. At 50.4MHz, the
// repeat time is beyond the estimated universe lifetime.
module RNG_4b (
    input             iCLK,       // Clock signal
    input             iReset,     // Reset signal
    output     [3:0]  oRandomNum  // The random number
);
    
    wire [159:0] seed [3:0];
    assign seed[0] = `SEED_0;
    assign seed[1] = `SEED_1;
    assign seed[2] = `SEED_2;
    assign seed[3] = `SEED_3;
    
    // Generate the LFSRs.
    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin : LFSRgen
            // Always export a single bit from each LFSR.
            reg [159:0] LFSR;
            assign oRandomNum[i] = LFSR[0];
            
            // Calculate shift-in bit.
            wire shiftin;
            assign shiftin = ~(LFSR[159] ^ LFSR[158] ^ LFSR[141] ^ LFSR[140]);
            
            // Upon clock tick, update the LFSR.
            always @(posedge iCLK) begin
                if(iReset) LFSR <= seed[i];
                else       LFSR <= {LFSR[158:0], shiftin};
            end
        end
    endgenerate
    
endmodule
