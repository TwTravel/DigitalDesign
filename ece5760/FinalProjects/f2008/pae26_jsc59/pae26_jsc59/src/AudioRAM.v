module AudioRAM (
    input                  iReset,
    input                  iStartLoad,
    input                  iWriteClock,
    input      [BITS-1:0]  iSample,
    input                  iReadClock,
    input      [LBITS-1:0] iReadAddr,
    input                  iWindow,
    output     [BITS-1:0]  oValue,
    output reg             oLoadComplete,
    output reg             state
);

parameter BITS = 16;
parameter LBITS = 10;

//reg state;
parameter WAIT  = 1'b0;
parameter WRITE = 1'b1;

reg [LBITS:0] wraddr;
reg wren, shot, reshot;

// look for start signal
always @ (posedge iStartLoad or posedge reshot)
begin
    if (iStartLoad) shot <= 1'b1;
    else shot <= 1'b0;
end

// write state machine
always @ (posedge iWriteClock)
begin
    if (iReset)
    begin
        state  <= WAIT;
        wraddr <= 0;
        wren   <= 1'b0;
        oLoadComplete <= 1'b0;
    end
    else
    begin
        case (state)
            WAIT:
            begin
                wren <= 1'b0;
                if (shot == 1'b1)
                begin
                    reshot <= 1'b1;
                    wraddr <= 0;
                    state <= WRITE;
                end
                else
                    state <= WAIT;
            end
            
            WRITE:
            begin
                reshot <= 1'b0;
                if (wraddr < 1024)
                begin
                    wren   <= 1'b1;
                    wraddr <= wraddr + 11'b1;
                    state  <= WRITE;
                    oLoadComplete <= 1'b0;
                end
                else
                begin
                    wren  <= 1'b0;
                    state <= WAIT;
                    oLoadComplete <= 1'b1;
                end
            end
        endcase
    end
end

wire [31:0] hammval, hannval;
wire [15:0] hamm, hann, hammtop, hanntop, datain;
assign hammval = hamm * iSample;
assign hannval = hann * iSample;
assign hammtop = {hammval[31], hammval[27:13]};
assign hanntop = {hannval[31], hannval[27:13]};
assign datain  = (iWindow == 1'b1) ? hanntop : hammtop;

hammingrom hammrom (
    .iAddress(wraddr),
    .oHamming(hamm)
);

hanningrom hannrom (
    .iAddress(wraddr),
    .oHanning(hann)
);

ram1024x16 audsamp (
    .data(iSample),
    .rdaddress(iReadAddr),
    .rdclock(iReadClock),
    .wraddress(wraddr),
    .wrclock(iWriteClock),
    .wren(wren),
    .q(oValue)
);

endmodule
