module SerialReceiver_improved_fastClock( 
	input CLOCK_50, //50 MHz clock
	input  UART_RXD, //serial receive bit
	output [7:0] lastReceived, //last received byte of data
	input reset, //reset signal
	output errorFlag_out, //error flag outputted
	output dataReady_out, //is the data received and ready?
	output [7:0] dataCounter, //counter for how many bytes have been received, mainly for slow debugging
	output [17:0] bigCounter, //big counter for how many bytes have been received
	output [6:0] errs, //number of errors incurred, useful for debugging
	output [3:0] state_out, //the current receive state, useful for debugging
	output [8:0] error_check, //the bits received while in error, useful for debugging or external error correction
	input timeout, //did a timeout occur externally?
	input baud_clock, //the standard baud clock
	input baud_8_clock //the 8X as fast baud clock
	);
	
	assign errs = errs_reg;
	assign bigCounter = bigCounter_reg;
	reg [6:0] errs_reg; //number of errors incurred
	
	
	reg clk_new = 0; //changes the state of an led every time a bit is sent
	
	reg [7:0] rxd; //the received byte
		
	reg [3:0] currBit; //current index of received byte
	reg [8:0] errorCheck; //error check bits of data
	reg [3:0] errorBit; //index for the errorCheck data
	
	assign lastReceived = rxd;
	reg [17:0] bigCounter_reg; //big counter to hold number of received bytes
	reg [3:0] receiveState; //the receive state machine index
	
	assign error_check = errorCheck;
	
	parameter [3:0] waitForStartBit = 4'd0, //waiting to hear a start bit
					collectData = 4'd1, //collecting bits of data
					waitForStopBit = 4'd2, //waiting to hear a stop bit
					error_1 = 4'd3; //an error occured, detect and corect state
					
	assign state_out = receiveState[3:0];
					
	reg errorFlag; //flag when an error occurs
	reg dataReady; //flag for when the data byte is fully received
	
	assign dataReady_out = dataReady;
	assign errorFlag_out = errorFlag;
	
	reg [7:0] dataCounter_reg;
	assign dataCounter = dataCounter_reg;
	
	reg [4:0] bitClock;
	wire internalBaudClock;
	
	assign internalBaudClock = (bitClock==4'd10);

	always @(posedge CLOCK_50)
	if(receiveState==waitForStartBit)
		bitClock <= 4'b0000;
	else
	if(baud_8_clock)
		bitClock <= {bitClock[2:0] + 4'b0001} | {bitClock[3], 3'b000};
		
	reg [1:0] RxD_sync_inv;
	always @(posedge CLOCK_50) if(baud_8_clock) RxD_sync_inv <= {RxD_sync_inv[0], ~UART_RXD};
	// we invert RxD, so that the idle becomes "0", to prevent a phantom character to be received at startup

	reg [1:0] RxD_cnt_inv; //not actually inverted
	reg RxD_bit_inv;

	//this state machine is responsible for ignoring signal spikes at high baud rate
	//taken from fpga4fun.com
	//this isn't needed, but it helps reduce some errors, so was implemented
	//It's very simple, the idea is that you receive a 0 when you receive two 0's in a row
	//and you receive a 1 when you receive two 1's in a row, this way a spike of 0->0->1->0->0
	//does not affect data, since everything should be 0's.
	//It runs at the fast clock, so it is able to detect these errors
	always @(posedge CLOCK_50)
	if(baud_8_clock)
	begin
		if( RxD_sync_inv[1] && RxD_cnt_inv!=2'b11) RxD_cnt_inv <= RxD_cnt_inv + 2'h1;
		else 
		if(~RxD_sync_inv[1] && RxD_cnt_inv!=2'b00) RxD_cnt_inv <= RxD_cnt_inv - 2'h1;

		if(RxD_cnt_inv==2'b00) RxD_bit_inv <= 1'b1;//was 0
		else
		if(RxD_cnt_inv==2'b11) RxD_bit_inv <= 1'b0;//was 1
	end


	
	always @ (posedge CLOCK_50)
	begin
		//if a reset signal is asserted
		if(reset) begin
			receiveState <= 4'd0;
			dataReady <= 0;
			errorFlag <= 0;
			currBit <= 0;
			rxd <= 0;
			dataCounter_reg <= 0;
			bigCounter_reg <= 0;
			errs_reg <= 0;
		end
		else begin
			//when in the wait for start bit state we used the fast baud clock
			if(receiveState == waitForStartBit && baud_8_clock) begin
				//if we get a start bit, then start!
				if(~RxD_bit_inv) begin
					currBit <= 4'd0;
					receiveState <= collectData;
					errorFlag <= 0;
					dataReady <= 0;
				end
			end
			//we now collect data and switch to slow baud clock and sync it with edge of fast baud clock
			if(receiveState != waitForStartBit && internalBaudClock && baud_8_clock) begin
				case(receiveState)
					collectData: begin
						rxd[currBit] <= RxD_bit_inv;
						currBit <= currBit + 4'd1;
						if(currBit == 4'd7) begin
							receiveState <= waitForStopBit;
						end
					end
					//wait for a stop bit
					waitForStopBit: begin
						//if we receive a valid stop bit, then go back to the wait state and
						//set data ready for output
						if(RxD_bit_inv) begin
							errorFlag <= 0;
							receiveState <= waitForStartBit;
							dataReady <= 1;
							dataCounter_reg <= dataCounter_reg + 8'd1;
							bigCounter_reg <= bigCounter_reg + 1;
							errorCheck <= 0;
							errorBit <= 0;
						end
						//else no stop bit recieved, so alert error and start correction process
						else begin
							errorFlag <= 1;
							errs_reg <= errs_reg + 1;
							receiveState <= error_1;
							errorCheck <= {rxd,RxD_bit_inv};
							errorBit <= 0;
							//dataReady <= 1;
						end
						
					end
					//the error correction state,
					//attempts to resync receive module with whatever is transmitting
					//to the FPGA
					error_1: begin
						//create a bit string of the bits received during error correction
						errorCheck <= {errorCheck[7:0], RxD_bit_inv};
						
						if(errorBit < 7) begin
							errorBit <= errorBit + 1;
							dataReady <= 0;
						end
						else begin
							if(errorCheck == 9'h1FF) //all idle bits, which means we can return to idle and we have resynched
							begin
								receiveState <= waitForStartBit;
								errorFlag <= 0;
								dataReady <= 1; //set the data ready so that we don't miss a data cycle, and let CRC take care of fixing byte errors
							end
							//this indicates that we received a valid pairint of start-data-stop bits, so we are in sync
							//the data here is lost, but we have resynced and can let the timeout mechanism or CRC
							//account for this missed data
							if(errorCheck[7] == 1'b0 && RxD_bit_inv == 1'b1) begin
								receiveState <= waitForStartBit;
								errorFlag <= 0;
								dataReady <= 1;//set the data ready so that we don't miss a data cycle, and let CRC take care of fixing byte errors
							end
						end
					end
				endcase
			end
		end
	end
	
endmodule
