module MemoryModule (
    input                 iReset,
    input                 iStartLoad,
    input                 iWriteClock,
    input      [15:0]     iSample,
    input                 iReadClock,
    input      [7:0]      iReadAddr,
    output     [15:0]     oValue,
    output reg            oLoadComplete,
    output reg            state,
	output 	   [15:0]     oNum,
	output     [3:0]      oLED
);

assign oNum    = {samplecount,wraddr[7:0]};
assign oLED[3] = rego;
assign oLED[2] = go;
assign oLED[1] = wren;
assign oLED[0] = oLoadComplete;

parameter WAIT  = 1'b0;
parameter WRITE = 1'b1;

reg [8:0] wraddr;
reg wren, go, rego;

// wait for start
always @ (posedge iStartLoad or posedge rego)
begin
    if (iStartLoad) go <= 1'b1;
    else go <= 1'b0;
end

always @ (posedge iWriteClock)
begin
    if (iReset)
    begin
        state  <= WAIT;
        wraddr <= 9'b0;
        wren   <= 1'b0;
        oLoadComplete <= 1'b0;
		samplecount <= 8'b0;
    end
    else
    begin
        case (state)
            WAIT:
            begin
                wren <= 1'b0;
                if (go == 1'b1)
                begin
                    rego <= 1'b1;
                    wraddr <= 9'b0;
                    state <= WRITE;
                end
                else
                    state <= WAIT;
            end
            
            WRITE:
            begin
                rego <= 1'b0;
                if (wraddr < 254)
                begin
                    wren   <= 1'b1;
                    wraddr <= wraddr + 1'b1;
                    state  <= WRITE;
                    oLoadComplete <= 1'b0;
                end
                else
                begin
                    wren  <= 1'b0;
                    state <= WAIT;
                    oLoadComplete <= 1'b1;
					samplecount <= samplecount + 1'b1;
                end
            end
        endcase
    end
end

reg [7:0] samplecount;

ramaudio_256x16 audiosamples (
    .data(iSample),
    .rdaddress(iReadAddr),
    .rdclock(iReadClock),
    .wraddress(wraddr),
    .wrclock(iWriteClock),
    .wren(wren),
    .q(oValue)
);

endmodule
1'b0;
                end
                else
                begin
                    wren  <= 1'b0;
                    state <= WAIT;
                    oLoadComplete <= 1'b1;
					samplecount <= samplecount + 1'b1;
                end
            end
        endcase
    end
end

reg [7:0] samplecount;

ramaudio_256x16 audiosamples (
    .data(iSample),
    .rdaddress(iReadAddr),
    .rdclock(iReadClock),
    .wraddress(