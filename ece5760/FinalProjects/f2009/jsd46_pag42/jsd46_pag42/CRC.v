//CRC Module

//NOTE DOESN"T ACTUALLY DO A CRC, just does an xor on almost all bytes to check for errors,
//basically, accurate enough

module CRC(
					packet_in,
					packet_ready_in,
					crc_result_out,
					reset,
					crc_out
					);
					
output wire crc_result_out; //result of the CRC check
input wire [127:0] packet_in; //the incoming packet
input wire packet_ready_in; //is the packet ready to be CRC'ed?
input wire reset; // a reset signal
 
wire [7:0] xor_result, weird_result;
output wire [7:0] crc_out;
wire one_true, two_true;

//we XOR bytes 15-1 of the packet and create the xor-result
assign xor_result = packet_in[127:120] ^ packet_in[119:112] ^ packet_in[111:104] ^
										packet_in[103:96]  ^ packet_in[95:88]   ^ packet_in[87:80] ^
										packet_in[79:72]   ^ packet_in[71:64]   ^ packet_in[63:56] ^
										packet_in[55:48]   ^ packet_in[47:40]   ^ packet_in[39:32] ^
										packet_in[31:24]   ^ packet_in[23:16]   ^ packet_in[15:8];



//compare the xor_result to the checksum that was sent to the packet
assign one_true = (xor_result == packet_in[7:0]) ? 1'b1 : 1'b0;

//as long as we aren't in reset mode then output the CRC result
assign crc_result_out = one_true /*& two_true*/ & ~reset;
assign crc_out = xor_result;




endmodule
