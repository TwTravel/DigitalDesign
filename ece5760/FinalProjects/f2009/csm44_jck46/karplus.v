/*
* Modular version of Karplus strong hardware.
*
* Created 12/8/09
* csm44 and jck46
*
*/

module karplus(clock50,
			   m4Clock,
			   audiolrclk,
			   reset,
			   noteIn,
			   gain,
			   pluck,
			   audioOut,
			   alpha,
			   count,
			   vel_en
			   );

//*******inputs***********
//csm44
//define the length of the shiftregister
// from the input wires
input wire [8:0] noteIn ;

//Based on the inputted shift register length for a specific note pitch
//We prime two strings, slightly detuned from one another
wire [8:0] note, noteP ;
//csm44 get noteP and noteM from note input
assign note = noteIn[8:0] - 9'b1;		//The mixed freq of the two strings should be close
assign noteP = noteIn[8:0] + 9'd1;	//to the original with a slight beat frequency.
					
//state machine start up	
input wire reset; 		//Soft reset
input wire [17:0] gain ;	//Gain for the Karplus Strong
input wire clock50;
input wire m4Clock;		//M4K clock speed 150 MHz to speed access to mem in one 50 MHz cycle
input wire audiolrclk;		//48 KHz audio sample rate to trigger calculation of a new sample
input wire pluck;			//String hit flag
input wire [2:0] alpha;		//Initial smoothing (low pass filtering) of random noise to reduce string 
					//plucking sound.
input wire [25:0] count; 	//Velocity count, unused for demo project
input wire vel_en;		//Velocity enable flag, unused for demo project

//********outputs**************

output reg [17:0] audioOut;	//Resultant note audio

//*****************************

//pluck the string
reg last_pluck;
reg [11:0] pluck_count, pluck_countP;

// state variable 0=reset, 1=readinput,
// 2=readoutput, 3=writeinput, 4=write 5=updatepointers, 
// 9=stop
reg [3:0] state ;
reg last_clk ; //oneshot gen

		
//pointers into the shift register
reg [8:0] ptr_in, ptr_out;	//First String pointers
reg [8:0] ptr_inP, ptr_outP; 	//Second String pointers

//memory control - first string
reg weA, weB; //write enable--active high
wire [17:0] dataOutA, dataOutB; 
reg [17:0]  write_dataA, write_dataB;
reg [8:0] addrA_reg, addrB_reg;

//mem control - second string
reg weAP, weBP; //write enable--active high
wire [17:0] dataOutAP, dataOutBP; 
reg [17:0]  write_dataAP, write_dataBP;
reg [8:0] addrA_regP, addrB_regP;

//data registers for arithmetic
//1st string
reg [17:0] out, in_data, out_data ;
wire [17:0] new_out;
//2nd string
reg [17:0] outP, in_dataP, out_dataP ;
wire [17:0] new_outP;

//random number generator and lowpass filter
wire x_low_bit ; // random number gen low-order bit
reg [30:0] x_rand ;//  rand number


wire [17:0] new_lopass, new_lopassD, new_lopass2, new_lopass3, new_lopassSum ;
reg [17:0]  lopass, lopassDelay, lopass2, lopassDelay2, lopass3, lopassSum ;


//csm44 - changed pluck and reset control to module inputs
// reset control
//assign reset = ~KEY[0];

// pluck control
//assign pluck = ~KEY[3] ;

//generate a random number at audio rate
// --AUD_DACLRCK toggles once per left/right pair
// --so it is the start signal for a random number update
// --at audio sample rate
//right-most bit for rand number shift regs
assign x_low_bit = x_rand[8] ^ x_rand[30];
// newsample = (1-alpha)*oldsample + (random+/-1)*alpha
// rearranging:
// newsample = oldsample + ((random+/-1)-oldsample)*alpha
// alpha is set from 1 to 1/128 using switches
// alpha==1 means no lopass at all. 1/128 loses almost all the input bits
//***csm44*** changed SW[17:15] to alpha[2:0]
//Initial random value smoothing (low pass filtering) with two hammer interactions
assign new_lopass = lopass + ((( (x_low_bit)?18'h1_0000:18'h3_0000) - lopass)>>>alpha[2:0]);
assign new_lopass2 = lopass2 + ((( new_lopassD ) - lopass2)>>>alpha[2:0]);
assign new_lopassSum = ((new_lopass + new_lopass2)>>>1);

//delay of second hammer interaction
shifter testShift	(	.clock(audiolrclk),
						.shiftin(new_lopass),
						.shiftout(new_lopassD),
						.taps());
//your basic XOR random # gen
always @ (posedge audiolrclk)
begin
	if (reset)
	begin
		lopass <= 18'h0 ;
		lopassDelay <= 18'h0;
		lopass2 <= 18'h0;
		lopassDelay2 <= 18'h0;
	end
	else begin
		
		lopass <= new_lopass ;
		lopassDelay <= lopass;
		lopass2 <= new_lopass2;
		lopassSum <= new_lopassSum;
	end
end

//Run the state machine FAST so that it completes in one 
//audio cycle
always @ (posedge clock50)
begin
	if (reset)
	begin
	        x_rand <= 31'h55555555;
		
		ptr_out <= 12'h1 ; 
		ptr_in <= 12'h0 ;
		
		ptr_outP <= 12'h1;
		ptr_outP <= 12'h0;
		
		weA <= 1'h0 ; 
		weB <= 1'h0;
		
		weAP <= 1'h0;
		weBP <= 1'h0;
		
		state <= 4'd9 ; //turn off the update state machine	
		last_clk <= 1'h1;
	end
	
	else begin
	    x_rand <= {x_rand[29:0], x_low_bit} ; 	//Update random number fast 
									//so when we sample we get very 
									//different numbers
		case (state)
	
			1: 
			begin
				// set up read ptr_out/in data
				addrA_reg <= ptr_in;
				addrB_reg <= ptr_out;
				weA <= 1'h0;
				weB <= 1'h0;
				
				addrA_regP <= ptr_inP;
				addrB_regP <= ptr_outP;
				weAP <= 1'h0;
				weBP <= 1'h0;
				
				state <= 4'd2;
			end
	
			2: 
			begin
				//get ptr_out/in data
				in_data <= dataOutA;
				out_data <= dataOutB;
				
				in_dataP <= dataOutAP;
				out_dataP <= dataOutBP;
				
				state <= 4'd4;
			end
			
			4:
			begin
				//write ptr_in data:  
				// -- can be either computed feedback, or noise from pluck
				//New values
				out <= new_out;
				outP <= new_outP;
				//resultant audio
				audioOut <= outP + out;
				addrA_reg <= ptr_in;
				//Write enable
				weA <= 1'h1 ;
				weAP <= 1'h1;
				// feedback or new pluck
				if (pluck)
				begin 
					// is this a new pluck? (part of the debouncer)
					if (last_pluck==0)
					begin
						// if so, reset the count
						pluck_count <= 12'd0;
						// and debounce pluck
						last_pluck <= 1'd1;
						write_dataA <= lopassSum ;
					end
					// have the correct number of random numbers been loaded?
					else if (pluck_count<note)
					begin
						//if less, load lowpass output into memory
						pluck_count <= pluck_count + 12'd1 ;
						write_dataA <= lopassSum ;
					end
					//update feedback if not actually loading random numbers
					else 
						//slow human holds button down, but feedback is still necessary
						write_dataA <= out ;	//Uncoupled strings
					
					if (last_pluck==0)
					begin
						// if so, reset the count
						pluck_countP <= 12'd0;
						write_dataAP <= lopassSum;
					end
					else if (pluck_countP < noteP)
					begin
						pluck_countP <= pluck_countP + 12'd1;
						write_dataAP <= lopassSum;
					end
					else
						write_dataAP <= outP ;	//Uncoupled strings
				end
				else begin 
					// update feedback if pluck button is not pushed
					// and get ready for next pluck since the button is released
					last_pluck = 1'h0;
					//Uncoupled strings
					write_dataA <= out ;//+ (outP >>> 3);
					write_dataAP <= outP ;//+ (out >>> 3);
				end
				state <= 4'd5;
			end
			
			5: 
			begin
				//Turn off write enable
				weA <= 0;
				weAP <= 0;
				//update ptrs
				if (ptr_in == note)
					ptr_in <= 12'h0;
				else
					ptr_in <= ptr_in + 12'h1 ;
				
				if (ptr_out == note)
					ptr_out <= 12'h0;
				else
					ptr_out <= ptr_out + 12'h1 ;
				
				if (ptr_inP == noteP)
					ptr_inP <= 12'h0;
				else
					ptr_inP <= ptr_inP + 12'h1 ;
				
				if (ptr_outP == note)
					ptr_outP <= 12'h0;
				else
					ptr_outP <= ptr_outP + 12'h1 ;
				
				//next state is end state
				state <= 4'd9;
			end
			
			9:
			begin
				//Wait for next sample cycle
				if (audiolrclk && last_clk)
				begin
					state <= 4'd1 ;
					last_clk <= 1'h0 ;
				end
				else if (~audiolrclk)
				begin
					last_clk <= 1'h1 ;
				end	
			end
			
		endcase
	end
end	

//make the shift register from dual ported m4k mem structures
//1st String
ourM4	testNote	(	.address_a(addrA_reg),
						.address_b(addrB_reg),
						.clock(m4Clock),
						.data_a(write_dataA),
						.data_b(write_dataB),
						.wren_a(weA),
						.wren_b(weB),
						.q_a(dataOutA),
						.q_b(dataOutB) );
//2nd String
ourM4	testNoteP	(	.address_a(addrA_regP),
						.address_b(addrB_regP),
						.clock(m4Clock),
						.data_a(write_dataAP),
						.data_b(write_dataBP),
						.wren_a(weAP),
						.wren_b(weBP),
						.q_a(dataOutAP),
						.q_b(dataOutBP) );

//make a multiplier and compute gain*(in+out)
//signed_mult gainfactor(new_out, gain, (((out_data + out_dataP)>>>1) + ((in_data ))));
signed_mult gainfactor(new_out, gain, (out_data + in_data));

signed_mult gainfactorP(new_outP, gain, (out_dataP + in_dataP));

endmodule 