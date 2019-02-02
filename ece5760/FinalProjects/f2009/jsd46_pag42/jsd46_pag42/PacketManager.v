//Packet Manager Module

module PacketManager(
										data_in,
										packet_out,
										timeout,
										dataAvailable_in,
										reset,
										packet_ready_out,
										idle,
										last_packet,
										fast_clock,
										timeout_in,
										timeout_count,
										data_index_out
										); 
							
input wire timeout_in;	//timeout that the packet manager sent is fed back in
input wire [7:0] data_in; //the current byte into the packet
output wire [127:0] packet_out; //the data of the current packet
output wire packet_ready_out; //we have received all 16 bytes and the packet is full and ready for use
output reg timeout; //when a timeout occurs
input wire reset; //a reset signal
input wire dataAvailable_in; //is data available for us to add to the packet?
input wire idle; //are we idle?
reg [3:0] data_index; //packet byte index
reg [127:0] packet; //a register to hold the packet
reg packet_ready; //signal if the packet is complete
output reg [127:0] last_packet; //the last packet that was packaged
input wire fast_clock; //a 50mhz clock
reg [127:0] sys_time; //the system time of the fpga used for generating a timestamp to detect timeouts

assign packet_out = packet;
assign packet_ready_out = packet_ready;
output wire [24:0] timeout_count;
output wire [3:0] data_index_out;

assign data_index_out = data_index;
assign timeout_count = (sys_time - start_time) << 104; //for debugging

reg [127:0] start_time, end_time;
reg inProgress; //register to hold if we are currently collecting a packet, aka we are in progress of packet collection

always @(posedge fast_clock) begin
	//if a reset is received, then reset system clock
	if(reset) begin
		sys_time <= 0;
	end
	else begin
		sys_time <= sys_time + 1; //increment sytem clock
		//if the elapsed time is > ~0.2 seconds and we are in progress, then signal a timeout error
		if( ((sys_time - start_time) > 128'd5000000 ) && (inProgress == 1'b1)) begin
			timeout <= 1'b1;
			
		end
		else begin
			timeout <= 1'b0; //otherwise, signal no timeout error
		end
	end
end

//always at we receive an indication that new data is available
always @ (posedge dataAvailable_in) begin
	//if a reset is received (not really likely to happen btw)
	if(reset) begin
		data_index <= 4'd0;
		packet_ready <= 1'b0;
		packet <= 128'd0;
		last_packet <= 128'd0;
		start_time <= 0;
		end_time <= 0;
		inProgress <= 0;
	end
	else begin
		//if we are in the process of sending a timeout error, then keep alles in ordnung
		if(timeout_in) begin
			packet <= {128'd0,data_in};
			inProgress <= 1;
			start_time <= sys_time;
			packet_ready <= 1'b0;
			data_index <= 4'b0001;
		end //otherwise collect data for packet
			else begin
			if(data_index < 4'd15) begin
				data_index <= data_index + 4'b0001; //increment data byte index
				packet_ready <= 1'b0; //the packet is not ready yet
				if(data_index == 4'd0) begin //on first byte reset some stuff
					packet <= {128'd0,data_in};
					inProgress <= 1;
					start_time <= sys_time; //set the start time
				end
				else begin //on subsequent data receipts shift packet data appropriately while adding new byte
					packet <= (packet << 8) | {120'd0,data_in};
				end
			end
			else begin //else all data is now collected and packet is ready
				packet_ready <= 1'b1;  //set packet to ready
				packet <= (packet << 8) | {120'd0,data_in}; //set final byte of data
				last_packet <= (packet << 8) | {120'd0,data_in}; //set last packet data
				data_index <= 4'd0; //reset the byte index
				inProgress <= 0; //we are no longer in process of creating a packet
			end
		end
		
		
		
	end
end

										
										
endmodule
