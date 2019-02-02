module FFTModule (
    input                         iReset,
    input                         iStart,
    input                         iStateClk,
    output            [7:0]       oSampAddr,
    input      signed [15:0]      iSamp,
    input             [7:0]       iReadAddr,
    input                         iReadClock,
    output     signed [15:0]      oPower,
    output reg signed [5:0]       oExp,
    output reg                    oDone,
    output reg        [2:0]       instate
);

parameter LEN      = 256;
parameter WAIT     = 3'd0;
parameter SOP  	   = 3'd1;
parameter COLLECT  = 3'd2;
parameter EOP      = 3'd3;

reg              sink_valid;
wire             sink_ready;
reg              sink_sop;
reg              sink_eop;
reg  [15:0]      sink_real;
wire [15:0]      sink_imag;
wire [15:0]      source_real;
wire [15:0]      source_imag;
wire [5:0]       source_exp;
wire             source_ready;
wire             source_valid;
wire             source_sop;
wire             source_eop;
wire [1:0]       source_error;
wire [1:0]       sink_error;

assign source_ready = 1'b1;
assign sink_error = 2'b00;
assign sink_imag = 16'b0;  //no imaginary input

reg [7:0] incount, outcount;
reg go, rego;

wire signed [15:0] power, realAbs, imagAbs; //FFT output

assign oSampAddr = incount;

// look for start signal
always @ (posedge iStart or posedge rego)
begin
    if (iStart) go <= 1'b1;
    else go <= 1'b0;
end

//FFT state machine
always @ (posedge iStateClk)
begin
    if (iReset)
    begin
        sink_real <= 16'b0;
        sink_valid <= 1'b0;
        incount <= 0;
        instate <= SOP;
    end
    else
    begin
        case (instate)
            SOP:
            begin
                rego <= 1'b0;
                sink_sop <= 1'b1; //start of a packet
                sink_valid <= 1'b1; //valid data is ready for FFT
                sink_real <= iSamp;
                incount <= 1;
                instate <= COLLECT;
            end
            
            COLLECT:
            begin
                sink_sop <= 1'b0; 
                sink_real <= iSamp; //next sample
                incount <= incount + 1;
                if (incount == LEN-2)
                    instate <= EOP;
                else
                    instate <= COLLECT;
            end
            
            EOP:
            begin
                sink_eop <= 1'b1; //end of a packet
                sink_real <= iSamp;
                instate <= WAIT;
            end
            
            WAIT:
            begin
                sink_real <= 16'b0;
                sink_eop <= 1'b0;
                sink_valid <= 1'b0;
                if (go == 1'b1)
                begin
                    rego <= 1'b1;
                    incount <= 0;
                    instate <= SOP;
                end
                else
                    instate <= WAIT;
            end
        endcase
    end
end

assign realAbs = (source_real[15] == 1'b1) ? ~source_real : source_real;
assign imagAbs = (source_imag[15] == 1'b1) ? ~source_imag : source_imag;
assign power = (realAbs > imagAbs) ? (realAbs + (imagAbs >> 1)) : (imagAbs + (realAbs >> 1));

reg wren;

always @ (posedge iStateClk)
begin
    if (sink_sop == 1'b1 || iReset == 1'b1)
        oDone <= 1'b0;
    else if (source_eop == 1'b1)
        oDone <= 1'b1;
   // else
	//   oDone <= 1'b0;
	   
    if (source_valid == 1'b1)
    begin
        if (outcount < 256)
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

ramaudio_256x16 fftcoeff (
    .data(power),
    .rdaddress(iReadAddr),
    .rdclock(iReadClock),
    .wraddress(outcount),
    .wrclock(iStateClk),
    .wren(wren),
    .q(oPower)
);

fft FFTHandler (
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
.clk(iStateClk),
    .reset_n(~iReset),
    .inverse(1'b0),
    .sink_valid(sink_valid),
    .sink_sop(sink_sop),
    .sink_eop(sink_eop),
    .sink_real(sink_real),
    .sink_imag(sink_imag),
    .sink_er