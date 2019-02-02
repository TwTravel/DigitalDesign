// Filter module is simply a wrapper of the FIR filter itself, as well as 2 banks of Coefficient RAMs.
// Upon reset, the FIR filter will be reading from Coefficient ram 0 (or Bank 0).
// After a Coefficient Update cycle is complete, the CoeffRamSelect signal will be inverted.
// At the completion of a filter cycle, the internal selection latch will take the value of the select signal.
// This internal selection latch acts as the mux control for Coefficient rams.
// When Select = 0, Bank0 is being Read by the FIR module, and Bank1 will be written if the Coefficient Update logic is working.
// When Select = 1, it is just the opposite.


module filter(
  Clock,
  Reset,
// Coeff Ram Update
  CoeffRamAddr,
  CoeffRamData,
  CoeffRamWE,


//Filter control 
  CoeffRamSelect,
  Start,
  In,
  Out,
  Done
);
 
input Clock;
input Reset;

input  [7:0]  CoeffRamAddr;
input [16:0]  CoeffRamData;
input         CoeffRamWE;
input         CoeffRamSelect;

input         Start;
input [15:0]  In;
output [15:0] Out;
output        Done;


wire  [7:0] c0_addr,c1_addr;
wire [16:0] c0_in,c0_out,c1_in,c1_out;
wire        c0_we,c1_we;
 
wire  [7:0] fir_coeff_ram_addr;
wire [16:0] fir_coeff_ram_data;

reg         CoeffRamSelect_L;

assign  c0_addr = (CoeffRamSelect) ? CoeffRamAddr       : fir_coeff_ram_addr;
assign  c0_we   = (CoeffRamSelect) ? CoeffRamWE         : 1'b0;
assign  c0_in   = CoeffRamData;


assign  c1_addr = (CoeffRamSelect) ? fir_coeff_ram_addr : CoeffRamAddr;
assign  c1_we   = (CoeffRamSelect) ? 1'b0               : CoeffRamWE;
assign  c1_in   = CoeffRamData;

always@(posedge Clock) begin
  CoeffRamSelect_L <= (Done) ? CoeffRamSelect : CoeffRamSelect_L;
end

assign fir_coeff_ram_data = (CoeffRamSelect_L) ? c1_out : c0_out;

fir hrtf_l(
  .CLK(Clock),
  .Reset(Reset),
  .CoeffRAM_Addr(fir_coeff_ram_addr),
  .CoeffRAM_Data(fir_coeff_ram_data),
  .Start(Start),
  .In(In),
  .Out(Out),
  .Done(Done)
);


CoeffRAM c0 (
	.address(c0_addr),
	.clock(Clock),
	.data(c0_in),
	.wren(c0_we),
	.q(c0_out)
	);
	
	
CoeffRAM c1 (
	.address(c1_addr),
	.clock(Clock),
	.data(c1_in),
	.wren(c1_we),
	.q(c1_out)
	);
	
	
endmodule