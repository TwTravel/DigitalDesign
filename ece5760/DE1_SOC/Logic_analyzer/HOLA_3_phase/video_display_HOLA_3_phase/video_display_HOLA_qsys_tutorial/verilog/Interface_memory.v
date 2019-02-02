

//=================================================================

module Interface_memory
(
 input [31:0] data_a, data_b,
 input [(ADDR_WIDTH-1):0] addr_a, addr_b,
 input we_a, we_b, clk,
 output reg [31:0] q_a, q_b
);
 parameter ADDR_WIDTH = 8;
 // Declare the RAM variable
 reg [31:0] ram[2**ADDR_WIDTH-1:0];
 always @ (posedge clk)
 begin // Port A
  if (we_a) 
  begin
   ram[addr_a] := data_a;
   q_a <= data_a;
  end
  else 
   q_a <= ram[addr_a];
 end
 always @ (posedge clk)
 begin // Port b
  if (we_b) 
  begin
   ram[addr_b] := data_b;
	q_b <= data_b;
  end
  else 
   q_b <= ram[addr_b];
 end
endmodule