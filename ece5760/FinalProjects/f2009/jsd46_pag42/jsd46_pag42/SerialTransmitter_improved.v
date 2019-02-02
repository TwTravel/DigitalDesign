module SerialTransmitter_improved( 
	input CLOCK_50, //50MHz clock
	output  UART_TXD, //Serial transmitter
	input [7:0] toTransmit, //Byte to transmit
	input reset, //reset signal
	output dataSent_out, //was the data sent completely?
	input sendNew, //should we send the new data?
	input [17:0] SW, //switches for debugging
	output idle, //are we currently in idle transmit mode?
	input goBackToIdle, //should be move back to idle mode?
	output [7:0] lastTransmit, //the last byte transmitted
	input timeout_send, //should we send a timeout error
	input baud_clock //the baud clock
	);
	
	
	
	reg clk_new = 0; //changes the state of an led every time a bit is sent
	
	reg [7:0] txd, last_txd; //transmitted byte registers
		
	reg [3:0] currBit; //current bit of byte to transmit
	
	reg [3:0] transmitState;  //the transmit state
	
	parameter [3:0] idleWait = 4'd0, //transmit is idel
					sendStartBit = 4'd1, //sending start bit
					sendData = 4'd2, //sending 8 bits of data
					sendStopBit = 4'd3; //sending stop bit
					
	reg errorFlag; //did an error happen?
	reg dataSent; //was the data sent?
	reg txd_out; //the current bit being send over UART
	reg should_send; //should we now start a transfer
	
	assign idle = (transmitState == idleWait) ? 1'b1 : 1'b0;
	
	assign UART_TXD = txd_out;
	
	assign dataSent_out = dataSent;
	
	assign lastTransmit = last_txd;
	
	reg isTimeoutWaiting; //did a timeout occur?
	
		
	always @(posedge CLOCK_50)
	begin
		//if we got a send request and we are currently idle, then begin send
		if(sendNew & ~reset & (transmitState == idleWait)) begin
			dataSent <= 0;
			should_send <= 1'b1;
			isTimeoutWaiting <= 1'b0;
		end
		//if we got a timeout error and we are idle, then begine timeout error send
		if(timeout_send & (transmitState == idleWait)) begin
			dataSent <= 0;
			isTimeoutWaiting <= 1'b1;
			should_send <= 1'b1;
		end
		//reset all important variables
		if(reset) begin
			transmitState <= 4'd0;
			dataSent <= 0;
			currBit <= 0;
			txd <= 0;
			txd_out <= 1;
			should_send <= 0;
			isTimeoutWaiting <= 0;
		end
		else begin
			if (baud_clock) //if a baud tick has occured
			begin
				
				
				case(transmitState)
					idleWait: begin
						txd_out <= 1'b1;
						if(should_send) begin
							//if a timeout error occured, then send that error byte
							if(isTimeoutWaiting) begin
								txd <= 8'd128;
								last_txd <=  8'd128;
							end //else send other information
							else begin
								txd <= toTransmit;
								last_txd <= toTransmit;
							end
							
							transmitState <= sendStartBit; //begin transfer by entering send start bit state
							dataSent <= 0;
							should_send <= 0;
						end
					end
					//send the start bit
					sendStartBit: begin
						txd_out <= 1'b0; //the start bit
						transmitState <= sendData;
						currBit <= 4'd0; //reset the current data indice bit
					end
					//send all 8 bits of data
					sendData: begin
						txd_out <= txd[currBit];
						currBit <= currBit + 4'd1;
						//if all data was sent then enter the send stop bit state
						if(currBit == 4'd7) begin 
							transmitState <= sendStopBit;
						end
					end
					//send the stop bit
					sendStopBit: begin
						txd_out <= 1'b1;
						dataSent <= 1;
						//if a timeout occured
						if(isTimeoutWaiting) begin
							//and we have reset the send timeout signal, then go back to idle
							if(~timeout_send) begin
								transmitState <= idleWait;
								isTimeoutWaiting <= 1'b0;
							end
						end
						else begin //else if we should go back to idle, enter idle wait
							if(goBackToIdle) begin
								transmitState <= idleWait;
							end
						end
					end
					
										
				endcase
				
				
			end
			
		end
		
	end
endmodule
