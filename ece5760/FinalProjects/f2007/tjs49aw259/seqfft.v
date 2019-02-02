// Fast Fourier Transform (64 pt)
// fft64pt_seq.v
//
// ECE 576, Fall 2007 - Cornell University
//
// Revision History:
//
// v1.0		Adrian Wong		2007.11.18		Initial revision (combinatorially)
// v2.0		Adrian Wong		2007.11.20		Sequential version with M4K blocks

module fft64pt_seq (reset, sample_clk, sample_data, system_clk, mag_addr, vga_hold, fft_ready, mag_data, LEDR, toggle);


// Audio Codec Signals
input	sample_clk;					// Audio CODEC ADC Clock
input	[15:0] sample_data;			// Audio CODEC ADC Sample

// FFT Operation Signals
input   reset;
input	system_clk;					// FFT System Clock
input	[5:0] mag_addr;				// VGA Magnitude Address Request
input	vga_hold;					// VGA Hold Request
output	fft_ready;					// FFT Ready Flag
output	[7:0] mag_data;				// VGA Magnitude Data
output  [17:0] LEDR;				// Debugging LED
input	toggle;						// Debugging toggle switch

/////////////////////////////////////////////////////////////////////////////////

// --- FFT Control Registers ---
reg			fft_ready;				// FFT Ready Flag
reg [3:0]	program_state;			// FFT FSM state
reg [5:0]	dft_index;				// DFT counter
reg 	   	UP_select;				// Mux between {x0,x1} or {x2, x3}
reg			DFT_select;				// Mux between DFT or ADC
reg			FFT_start;				// Start FFT

// --- Audio CODEC Sampling ---
reg	 [5:0] audio_sample_addr;
wire [35:0] audio_sample_data;

// --- DFT Input Signal Registers ---
reg signed [17:0]	dft_x0_r, dft_x1_r, dft_x2_r, dft_x3_r,
					dft_x0_c, dft_x1_c, dft_x2_c, dft_x3_c;

// --- DFT Output Signals ---
wire signed [35:0]  dft_data_f0, dft_data_f1, dft_data_f2, dft_data_f3;
wire signed [17:0]	dft_f0_r, dft_f1_r, dft_f2_r, dft_f3_r,
					dft_f0_c, dft_f1_c, dft_f2_c, dft_f3_c;

	assign dft_data_f0 = {dft_f0_r, dft_f0_c};
	assign dft_data_f1 = {dft_f1_r, dft_f1_c};
	assign dft_data_f2 = {dft_f2_r, dft_f2_c};
	assign dft_data_f3 = {dft_f3_r, dft_f3_c};

// --- Twiddle ROM ---
wire [107:0] twiddle_data;
wire [17:0]	dft_t1_r, dft_t1_c, dft_t2_r, dft_t2_c, dft_t3_r, dft_t3_c;

	assign dft_t1_r = twiddle_data[107:90];
	assign dft_t1_c = twiddle_data[89:72];
	assign dft_t2_r = twiddle_data[71:54];
	assign dft_t2_c = twiddle_data[53:36];
	assign dft_t3_r = twiddle_data[35:18];
	assign dft_t3_c = twiddle_data[17:0];

// --- Signal RAM Addressing ---
wire [5:0] dft_addr_a, dft_addr_b;
wire [5:0] fft_addr_a, fft_addr_b;
wire [5:0] sig_addr_a, sig_addr_b;
wire [5:0] dft_addr_x0, dft_addr_x1, dft_addr_x2, dft_addr_x3;

	// Choose between upper and lower words for FFT butterfly.
	assign dft_addr_a = (UP_select) ? dft_addr_x0 : dft_addr_x2;
	assign dft_addr_b = (UP_select) ? dft_addr_x1 : dft_addr_x3;

	// Choose between Signal RAM access for DFT and ADC.
	assign fft_addr_a = (DFT_select) ? dft_addr_a : audio_sample_addr;
	assign fft_addr_b = (DFT_select) ? dft_addr_b : audio_sample_addr;

	// Choose between Signal RAM access for VGA and FFT.
	assign sig_addr_a = (fft_ready) ? mag_addr : fft_addr_a;
	assign sig_addr_b = (fft_ready) ? mag_addr : fft_addr_b;

// --- Signal RAM Data Input ---
wire [35:0] dft_data_a, dft_data_b;
wire [35:0]	sig_data_a, sig_data_b;
reg			wren_sig_a, wren_sig_b;

	// Choose between upper and lower words for FFT butterfly.
	assign dft_data_a = (UP_select) ? dft_data_f0 : dft_data_f2;
	assign dft_data_b = (UP_select) ? dft_data_f1 : dft_data_f3;

	// Choose between Signal RAM access for DFT and ADC.
	assign sig_data_a = (DFT_select) ? dft_data_a : audio_sample_data;
	assign sig_data_b = (DFT_select) ? dft_data_b : audio_sample_data;

// --- Signal RAM Data Output ---
wire [35:0] sig_q_a, sig_q_b;
wire [17:0] sig_out_a_r, sig_out_a_c, sig_out_b_r, sig_out_b_c;

	// Split into real and complex components for FFT
	assign sig_out_a_r = sig_q_a[35:18];
	assign sig_out_a_c = sig_q_a[17:0];
	assign sig_out_b_r = sig_q_b[35:18];
	assign sig_out_b_c = sig_q_b[17:0];

// --- FFT Finite State Machine ---
// FFT FSM State table
parameter	state_hold = 4'd0,
			state_loadAB = 4'd1,
			state_loadCD = 4'd2,
			state_storeAB = 4'd3,
			state_storeCD = 4'd4,
			state_sample_setup = 4'd5,
			state_sample_write = 4'd6,
			state_sample_write_wait = 4'd11,
			
			state_loadAB_wait = 4'd7,
			state_loadCD_wait = 4'd8,
			state_storeAB_wait = 4'd9,
			state_storeCD_wait = 4'd10;
			
reg [2:0] counter;

always @ (posedge system_clk)
begin
	if (reset) begin
		fft_ready <= 0;
		program_state <= state_hold;
		dft_index <= 0;
		FFT_start <= 0;
		UP_select <= 0;
		DFT_select <= 0;
	end else begin
	case (program_state)
		state_hold:
				if (vga_hold) begin
					// VGA would like to read out data.
					program_state <= state_hold;
					fft_ready <= 1;
				end else begin
					// TODO: Check for the availability of audio samples.
					// TODO: Load in the next sequence of audio samples.
					fft_ready <= 0;
					
					if (FFT_start)
					begin
						// Set the program counter to start at first DFT.
						program_state <= state_loadAB_wait;
						UP_select <= 1;
						DFT_select <= 1;
						
						dft_index <= 6'd0;
						FFT_start <= 0;
						counter <= 0;
					end else begin
						// Need to grab values from ADC shift register.
						DFT_select <= 0;
						program_state <= state_sample_setup;
					end
			end
		state_loadAB_wait: begin
				counter <= counter + 1'b1;
				
				if (counter == 3)
					program_state <= state_loadAB;
				else
					program_state <= state_loadAB_wait;
			end
		state_loadAB: begin
				// Load x0 and x1 values into DFT registers.
				dft_x0_r <= sig_out_a_r;
				dft_x0_c <= sig_out_a_c;
				
				dft_x1_r <= sig_out_b_r;
				dft_x1_c <= sig_out_b_c;
				
				program_state <= state_loadCD_wait;
				counter <= 0;
				UP_select <= 0;
			end
		state_loadCD_wait: begin
				counter <= counter + 1'b1;
				if (counter == 3)
					program_state <= state_loadCD;
				else
					program_state <= state_loadCD_wait;
			end
		state_loadCD: begin
				// Load x2 and x3 values into DFT registers.
				dft_x2_r <= sig_out_a_r;
				dft_x2_c <= sig_out_a_c;
				
				dft_x3_r <= sig_out_b_r;
				dft_x3_c <= sig_out_b_c;
				
				UP_select <= 1;
				
				program_state <= state_storeAB_wait;

				counter <= 0;
			end
		state_storeAB_wait: begin
				wren_sig_a <= 1;
				wren_sig_b <= 1;
				counter <= counter + 1'b1;
				if (counter == 4)
					program_state <= state_storeAB;
				else
					program_state <= state_storeAB_wait;
			end
		state_storeAB: begin
				program_state <= state_storeCD_wait;
				UP_select <= 0;
				wren_sig_a <= 0;
				wren_sig_b <= 0;
				counter <= 0;
			end
		state_storeCD_wait: begin
				wren_sig_a <= 1;
				wren_sig_b <= 1;
				counter <= counter + 1'b1;
				if (counter == 3)
					program_state <= state_storeCD;
				else
					program_state <= state_storeCD_wait;
			end
		state_storeCD: begin
				// Writing is now complete.
				wren_sig_a <= 0;
				wren_sig_b <= 0;

				if (dft_index < 6'd47) begin
					// DFTs are still remaining
					UP_select <= 1;
					program_state <= state_loadAB;
				end
				else begin
					program_state <= state_hold;
				end
				
				// Increment dft_indexs on each cycle
				dft_index <= dft_index + 1'b1;
			end
		state_sample_setup: begin
				audio_sample_addr <= audio_sample_addr + 1'b1;
				if (audio_sample_addr < 6'd63) begin
					program_state <= state_sample_write;					
				end else begin
					program_state <= state_hold;
					FFT_start <= 1;
					wren_sig_a <= 0;
				end
			end
		state_sample_write: begin
				wren_sig_a <= 1;
				program_state <= state_sample_setup;
				counter <= 0;
			end
		state_sample_write_wait: begin
				counter <= counter + 1'b1;
				
				if (counter == 2)
					wren_sig_a <= 0;
				else if (counter == 3)
					program_state <= state_sample_setup;
				else
					program_state <= state_sample_write_wait;
			end
	endcase
	end
end

// --- Audio CODEC ADC Sampling ---
wire [15:0] audio_shiftreg_data;

reg [15:0] samples [63:0];
integer n;

always @ (negedge sample_clk)
begin
	// Shift in values from ADC when FFT is in operation
	if (DFT_select == 1'b1)
	begin
		for (n = 63; n > 0; n = n - 1)
		begin
			samples[n] <= samples[n - 1];
		end
		
		samples[0] <= sample_data;
	end
end

assign audio_shiftreg_data = samples[audio_sample_addr];
assign audio_sample_data = {audio_shiftreg_data[15], audio_shiftreg_data[15], audio_shiftreg_data[15:0], 18'b0};

programseq	programseq_inst (
	.address ( dft_index ),
	.clock ( system_clk ),
	.q ( {dft_addr_x0, dft_addr_x1, dft_addr_x2, dft_addr_x3} )
	);

twiddlerom	twiddlerom_inst (
	.address ( dft_index ),
	.clock ( system_clk ),
	.q ( twiddle_data )
	);

signalram	signalram_inst (
	.address_a ( sig_addr_a ),
	.address_b ( sig_addr_b ),
	.clock ( system_clk ),
	.data_a ( sig_data_a ),
	.data_b ( sig_data_b ),
	.wren_a ( wren_sig_a ),
	.wren_b ( wren_sig_b ),
	.q_a ( sig_q_a ),
	.q_b ( sig_q_b )
	);

radix4dft   butterfly (
	dft_t1_r, dft_t1_c,
	dft_t2_r, dft_t2_c,
	dft_t3_r, dft_t3_c,
	
	dft_x0_r, dft_x1_r, dft_x2_r, dft_x3_r,
	dft_x0_c, dft_x1_c, dft_x2_c, dft_x3_c,
	
	dft_f0_r, dft_f1_r, dft_f2_r, dft_f3_r,
	dft_f0_c, dft_f1_c, dft_f2_c, dft_f3_c
	);

//freqnormal normalization(sig_out_a_r, sig_out_a_c, mag_data);

wire [35:0] a_r_sq, a_c_sq;
wire [36:0] sum;
wire [19:0]	mag; // (last few bits are not used [17:0] is real data

squaring sq1 (sig_out_a_r, a_r_sq);
squaring sq2 (sig_out_a_c, a_c_sq);
assign sum = a_r_sq + a_c_sq;

sqrt 	 sq3 (sum, mag);
assign mag_data = toggle ? sum[19:12] : mag[7:0];

//assign freq = mag[19:12];

endmodule