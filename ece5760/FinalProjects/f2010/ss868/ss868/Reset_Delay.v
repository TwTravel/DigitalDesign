/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

// Module that implements a 21ms startup reset.
module Reset_Delay (
    input             iCLK,
    output reg        oRESET
);
    reg        [19:0] Cont;
    
    always @(posedge iCLK) begin
        if(Cont != 20'hFFFFF) begin
            Cont   <= Cont + 20'b1;
            oRESET <= 1'b0;
        end
        else begin
            oRESET <= 1'b1;
        end
    end
    
endmodule
