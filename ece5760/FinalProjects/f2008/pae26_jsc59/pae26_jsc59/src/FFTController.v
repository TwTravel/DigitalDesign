module FFTController (
    input                         iReset,
    input                         iStart,
    input                         iStateClk,
    output            [LBITS-1:0] oSampAddr,
    input      signed [BITS-1:0]  iSamp,
    input             [LBITS-2:0] iReadAddr,
    input                         iReadClock,
    output     signed [BITS-1:0]  oPower,
    output reg signed [EBITS-1:0] oExp,
    output reg                    oDone,
    output reg        [2:0]       instate
);

parameter BITS  = 16;
parameter EBITS = 6;
parameter LEN   = 1024;
parameter LBITS = 10;

reg              sink_valid;
wire             sink_ready;
reg              sink_sop;
reg              sink_eop;
reg  [BITS-1:0]  sink_real;
wire [BITS-1:0]  sink_imag;
wire [BITS-1:0]  source_real;
wire [BITS-1:0]  source_imag;
wire [EBITS-1:0] source_exp;
wire             source_ready;
wire             source_valid;
wire             source_sop;
wire             source_eop;
wire [1:0]       source_error;
wire [1:0]       sink_error;

// always ready to receive data
assign source_ready = 1'b1;
// no input sink
assign sink_error = 2'b00;
// no imaginary input
assign sink_imag = 16'b0;

//reg [2:0] instate;
reg [LBITS-1:0] incount, outcount;
reg inshot, reshot;

assign oSampAddr = incount;

parameter INWAIT = 3'd0;
parameter INSOP  = 3'd1;
parameter INMID  = 3'd2;
parameter INEOP  = 3'd3;

// look for start signal
always @ (posedge iStart or posedge reshot)
begin
    if (iStart) inshot <= 1'b1;
    else inshot <= 1'b0;
end

// Input TO FFT state machine
always @ (posedge iStateClk)
begin
    if (iReset)
    begin
        sink_real <= 16'b0;
        sink_valid <= 1'b0;
        incount <= 0;
        instate <= INSOP;
    end
    else
    begin
        case (instate)
            INSOP:
            begin
                reshot <= 1'b0;
                // this is the start of a packet
                sink_sop <= 1'b1;
                // indicate to FFT that valid data is ready
                sink_valid <= 1'b1;
                // load up the first (real, imag) pair
                sink_real <= iSamp;
                // initialize index counter
                incount <= 1;
                instate <= INMID;
            end
            
            INMID:
            begin
                // de-assert sop flag
                sink_sop <= 1'b0;
                // load up next (real, imag) pair
                sink_real <= iSamp;
                // if this is the second to last pair in the input vector, move to end of packet
                incount <= incount + 1;
                if (incount == LEN-2)
                    instate <= INEOP;
                else
                    instate <= INMID;
            end
            
            INEOP:
            begin
                // this is the end of a packet
                sink_eop <= 1'b1;
                // load up last (real, imag) pair
                sink_real <= iSamp;
                instate <= INWAIT;
            end
            
            INWAIT:
            begin
                sink_real <= 16'b0;
                sink_eop <= 1'b0;
                sink_valid <= 1'b0;
                if (inshot == 1'b1)
                begin
                    reshot <= 1'b1;
                    incount <= 0;
                    instate <= INSOP;
                end
                else
                    instate <= INWAIT;
            end
        endcase
    end
end

// Output FROM FFT state machine
wire signed [BITS-1:0] power, realAbs, imagAbs;

assign realAbs = (source_real[BITS-1] == 1'b1) ? ~source_real : source_real;
assign imagAbs = (source_imag[BITS-1] == 1'b1) ? ~source_imag : source_imag;
assign power = (realAbs > imagAbs) ? (realAbs + (imagAbs >> 1)) : (imagAbs + (realAbs >> 1));

reg wren;

always @ (posedge iStateClk)
begin
    if (sink_sop == 1'b1 || iReset == 1'b1)
        oDone <= 1'b0;
    else if (source_eop == 1'b1)
        oDone <= 1'b1;
    
    if (source_valid == 1'b1)
    begin
        if (outcount < 512)
            wren <= 1'b1;
        else
            wren <= 1'b0;
        
        if (source_eop == 1'b1)
            outcount <= 0;
        else
            outcount <= outcount + 1;
        oExp <= source_exp;
    end
    else
        wren <= 1'b0;
end

ram512x16 fftpow (
    .data(power),
    .rdaddress(iReadAddr),
    .rdclock(iReadClock),
    .wraddress(outcount),
    .wrclock(iStateClk),
    .wren(wren),
    .q(oPower)
);

FFT2 afft (
    .clk(iStateClk),
    .reset_n(~iReset),
    .inverse(1'b0),
    .sink_valid(sink_valid),
    .sink_sop(sink_sop),
    .sink_eop(sink_eop),
    .sink_real(sink_real),
    .sink_imag(sink_imag),
    .sink_error(sink_error),
    .source_ready(source_ready),
    .sink_ready(sink_ready),
    .source_error(source_error),
    .source_sop(source_sop),
    .source_eop(source_eop),
    .source_valid(source_valid),
    .source_exp(source_exp),
    .source_real(source_real),
    .source_imag(source_imag)
);

endmodule
