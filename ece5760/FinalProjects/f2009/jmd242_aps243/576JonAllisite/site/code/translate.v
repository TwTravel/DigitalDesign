// Slopes for Microphones
// 22-bit fraction shifted left by 15 bits
`define mRight	22'h29E3FF  
`define mLeft	22'h2B77B9  
`define mMiddle	22'h2ED453
// Intercepts for Microphones
// 5-bit integer, 17-bit fraction
`define bRight	22'h08BD2F
`define bLeft	22'h099717
`define bMiddle	22'h0BED6A

module translate ( input clk, // Clock
				   input start, // Start translate
				   input [21:0] timeL, // 22-bit integer
				   input [21:0] timeR, // 22-bit integer
				   input [21:0] timeB, // 22-bit integer
				   output reg [21:0] distanceL, //5-bit integer 17-bit fraction
				   output reg [21:0] distanceR, //5-bit integer 17-bit fraction
				   output reg [21:0] distanceB, //5-bit integer 17-bit fraction
				   output reg ready	// Translate complete
				   );
				   
reg [2:0] state;
wire[21:0] multIn1, multIn2;
wire[21:0] multOut;

// Multiplication Unit
unsigned_mult mu (.out(multOut), .a(multIn1), .b(multIn2));

assign multIn1 = (state == distL) ? timeL: (state == distR) ? timeR: timeB;
assign multIn2 = (state == distL) ? `mLeft: (state == distR) ? `mRight: `mMiddle;

parameter distL = 3'd1, distR = 3'd2, distB = 3'd3, mult1 = 3'd4,
		  complete = 3'd5;

always @ (posedge clk) begin
  if (~start) begin
    distanceL <= 22'b0;
    distanceR <= 22'b0;
    distanceB <= 22'b0;
    ready <= 1'b0;
    state <= mult1;
  end
  else begin
    case (state)
		mult1: begin
		  if(!timeL||!timeR||!timeB) begin
			state <= complete;
		  end
		  else if(timeL==22'h3FFFFF||timeR==22'h3FFFFF||timeB==22'h3FFFFF)begin
			state <= complete;
			distanceL <= 22'h3FFFFF;
			distanceR <= 22'h3FFFFF;
			distanceB <= 22'h3FFFFF;
		  end
		  else begin
			state <= distL;
		  end
        end
		distL: begin
          state <= distR;
		  distanceL <= multOut - `bLeft;
        end
        distR: begin
		  state <= distB;
		  distanceR <= multOut - `bRight;
        end
        distB: begin
          state <= complete;
          distanceB <= multOut - `bMiddle;
        end
        complete: begin
          ready <= 1'b1;
        end
        default: state <= complete;
    endcase
  end
end

endmodule
