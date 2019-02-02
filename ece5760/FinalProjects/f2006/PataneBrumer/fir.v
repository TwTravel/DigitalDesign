// Operation: set start high & first input in for one clock cycle, then some time later the done signal will go high with the output
// Finite Impulse Response filter
// parameter NUM_TAPS = number of filter taps, this determins the amount of sample history kept in the sample ram, as well as how many 
// Coefficients are expected to be present in the Coefficient RAM.
// 1 <= NUM_TAPS <= 256
// CoeffRAM_Data and CoeffRAM_Addr must be hooked up to a 17b wide RAM



module fir(CLK, Reset, CoeffRAM_Addr, CoeffRAM_Data, Start, In, Out, Done);
    input CLK;
    input Reset;
    input Start;
    input signed [15:0] In;
    input [16:0] CoeffRAM_Data;
    output [7:0] CoeffRAM_Addr;
    output Done;
    output signed [15:0] Out;

    reg StateIdle;
    reg StateStart;
    reg StateStart2;
    reg StateStarted;

    reg [7:0] Count;
    reg [47:0] Accumulator;
    reg [15:0] InsertAddr;

    reg Start_L;
    wire StartPulse;  // detects rising edge of Start signal
    reg [15:0] In_L;  // hold latched version of Input sample when we receive start pulse

// signals for accessing the sample ram.
// Sample RAM holds NUM_TAPS worth of samples in it, organized in a circular queue.
// Each time a new sample arrives, the oldest sample is overwritten.

    reg   [7:0] SampleRAM_Addr;       
    wire [15:0] SampleRAM_WriteData;  
    wire        SampleRAM_WE;
    wire [15:0] SampleRAM_ReadData;
    reg [7:0] CurrSampleRAM_Addr;

    wire  [7:0] CoeffRAM_Addr;
    wire signed [16:0] MultOut;
    wire signed [47:0] NextAccum;

    parameter NUM_TAPS = 200;

// rising edge detection logic for Start.
    assign StartPulse = Start & ~Start_L;
    always@(posedge CLK) begin 
      Start_L <= Start;
    end 

// FIR State Machine
    always@(posedge CLK) begin
      if(Reset) begin
        StateIdle    <= 1'b1;
        StateStart   <= 1'b0;
        StateStart2  <= 1'b0;
        StateStarted <= 1'b0;
      end
      else begin
        StateIdle    <= StateIdle & ~StartPulse ||
                        StateStarted & Done;
        StateStart   <= StateIdle & StartPulse;
        StateStart2  <= StateStart;
        StateStarted <= StateStart2 ||
                        StateStarted & ~Done;
      end
    end    
	
    always@(posedge CLK) begin
      In_L           <= (Start) ? In : In_L;

      InsertAddr     <= (Reset)                        ?          16'b0 :
                        (StateStart & InsertAddr > 0)  ? InsertAddr - 1 :
                        (StateStart & InsertAddr == 0) ? NUM_TAPS       : InsertAddr;

      SampleRAM_Addr <= (StateIdle || StateStart)                                     ? InsertAddr :
                        ((StateStarted || StateStart2) && SampleRAM_Addr == (NUM_TAPS-1)) ?          0 : SampleRAM_Addr + 1;
 
      Count       <= (StateIdle || StateStart) ? 8'b0 : Count + 8'b1;
      Accumulator <= (StateStarted) ?  NextAccum      : 48'b0;
    end
	
    assign SampleRAM_WE        = StateStart;
    assign SampleRAM_WriteData = In_L;

    assign CoeffRAM_Addr = Count;
    assign NextAccum = Accumulator + {{32{MultOut[16]}},MultOut[16:1]} + (MultOut[0] ? 48'b1 : 48'b0);


    signed_mult multiplyer(
      .out(MultOut),
      .a(CoeffRAM_Data),
      .b({SampleRAM_ReadData[15],SampleRAM_ReadData}),
    );

    assign Out = NextAccum[15:0];

    assign Done = (Count == NUM_TAPS); // + 1
	
    SampleRAM Sample_RAM(
	.address(SampleRAM_Addr),
	.clock(CLK),
	.data(SampleRAM_WriteData),
	.wren(SampleRAM_WE),
	.q(SampleRAM_ReadData)
    );
endmodule


// signed multiplication unit for handling Coeff * Sample
// each number represented as 17b fixed point 0.16 (fractional) number

module signed_mult (out, a, b);
	output 		[16:0]	out;
	input 	signed	[16:0] 	a;
	input 	signed	[16:0] 	b;
	wire	signed	[16:0]	out;
	wire 	signed	[33:0]	mult_out;
	assign mult_out = a * b;
	assign out = {mult_out[33], mult_out[30:15]};
endmodule
