////////////////////////////////////////////////////
// AudioCodecController                           //
//   For use with DE2 Board Codec                 //
//   Settings: 48KHz Sampling Rate                //
//             48KHz Deemphasis                   //
//             USB Mode - 12MHz MCLK              //
////////////////////////////////////////////////////

module AudioCodecController (
	output reg oAUD_BCK,
	output reg oAUD_DATA,
	output reg oAUD_LRCK,
	output [15:0] oAUD_inL,
	output [15:0] oAUD_inR,
	input iAUD_ADCDAT,
	input [15:0] iAUD_extR,
	input [15:0] iAUD_extL,
	input iCLK,
	input iRST_N	
);

// Registers for audio in and out
reg [15:0] audInL, audInR;
reg [15:0] audOutL, audOutR;

assign oAUD_inL = audInL;
assign oAUD_inR = audInR;

// Counting register
reg [8:0] count;

// Register for state
reg [6:0] state;

// Define the states
parameter SETUP_L_1 = 7'd0;
parameter SEND_L_1 = 7'd1;
parameter SETUP_L_2 = 7'd2;
parameter SEND_L_2 = 7'd3;
parameter SETUP_L_3 = 7'd4;
parameter SEND_L_3 = 7'd5;
parameter SETUP_L_4 = 7'd6;
parameter SEND_L_4 = 7'd7;
parameter SETUP_L_5 = 7'd8;
parameter SEND_L_5 = 7'd9;
parameter SETUP_L_6 = 7'd10;
parameter SEND_L_6 = 7'd11;
parameter SETUP_L_7 = 7'd12;
parameter SEND_L_7 = 7'd13;
parameter SETUP_L_8 = 7'd14;
parameter SEND_L_8 = 7'd15;
parameter SETUP_L_9 = 7'd16;
parameter SEND_L_9 = 7'd17;
parameter SETUP_L_10 = 7'd18;
parameter SEND_L_10 = 7'd19;
parameter SETUP_L_11 = 7'd20;
parameter SEND_L_11 = 7'd21;
parameter SETUP_L_12 = 7'd22;
parameter SEND_L_12 = 7'd23;
parameter SETUP_L_13 = 7'd24;
parameter SEND_L_13 = 7'd25;
parameter SETUP_L_14 = 7'd26;
parameter SEND_L_14 = 7'd27;
parameter SETUP_L_15 = 7'd28;
parameter SEND_L_15 = 7'd29;
parameter SETUP_L_16 = 7'd30;
parameter SEND_L_16 = 7'd31;
parameter WAIT_L = 7'd32;
parameter SETUP_R_1 = 7'd33;
parameter SEND_R_1 = 7'd34;
parameter SETUP_R_2 = 7'd35;
parameter SEND_R_2 = 7'd36;
parameter SETUP_R_3 = 7'd37;
parameter SEND_R_3 = 7'd38;
parameter SETUP_R_4 = 7'd39;
parameter SEND_R_4 = 7'd40;
parameter SETUP_R_5 = 7'd41;
parameter SEND_R_5 = 7'd42;
parameter SETUP_R_6 = 7'd43;
parameter SEND_R_6 = 7'd44;
parameter SETUP_R_7 = 7'd45;
parameter SEND_R_7 = 7'd46;
parameter SETUP_R_8 = 7'd47;
parameter SEND_R_8 = 7'd48;
parameter SETUP_R_9 = 7'd49;
parameter SEND_R_9 = 7'd50;
parameter SETUP_R_10 = 7'd51;
parameter SEND_R_10 = 7'd52;
parameter SETUP_R_11 = 7'd53;
parameter SEND_R_11 = 7'd54;
parameter SETUP_R_12 = 7'd55;
parameter SEND_R_12 = 7'd56;
parameter SETUP_R_13 = 7'd57;
parameter SEND_R_13 = 7'd58;
parameter SETUP_R_14 = 7'd59;
parameter SEND_R_14 = 7'd60;
parameter SETUP_R_15 = 7'd61;
parameter SEND_R_15 = 7'd62;
parameter SETUP_R_16 = 7'd63;
parameter SEND_R_16 = 7'd64;
parameter WAIT_R = 7'd65;

always @ (posedge iCLK or negedge iRST_N)
begin
	if (!iRST_N)
	begin
		state <= SETUP_L_1;
		audInL <= 16'b0;
		audInR <= 16'b0;
		audOutL <= 16'b0;
		audOutR <= 16'b0;
		oAUD_LRCK <= 1'b0;
		oAUD_BCK <= 1'b0;
		oAUD_DATA <= 1'b0;
	end
	else
	begin
		case (state)
			SETUP_L_1: begin
				oAUD_LRCK <= 1'b1;
				oAUD_DATA <= iAUD_extL[15];
				audOutL <= iAUD_extL;
				state <= SEND_L_1;
			end
			SEND_L_1: begin
				oAUD_BCK <= 1'b1;
				audInL[15] <= iAUD_ADCDAT;
				state <= SETUP_L_2;
			end
			SETUP_L_2: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[14];
				state <= SEND_L_2;
			end
			SEND_L_2: begin
				oAUD_BCK <= 1'b1;
				audInL[14] <= iAUD_ADCDAT;
				state <= SETUP_L_3;
			end
			SETUP_L_3: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[13];
				state <= SEND_L_3;
			end
			SEND_L_3: begin
				oAUD_BCK <= 1'b1;
				audInL[13] <= iAUD_ADCDAT;
				state <= SETUP_L_4;
			end
			SETUP_L_4: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[12];
				state <= SEND_L_4;
			end
			SEND_L_4: begin
				oAUD_BCK <= 1'b1;
				audInL[12] <= iAUD_ADCDAT;
				state <= SETUP_L_5;
			end
			SETUP_L_5: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[11];
				state <= SEND_L_5;
			end
			SEND_L_5: begin
				oAUD_BCK <= 1'b1;
				audInL[11] <= iAUD_ADCDAT;
				state <= SETUP_L_6;
			end
			SETUP_L_6: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[10];
				state <= SEND_L_6;
			end
			SEND_L_6: begin
				oAUD_BCK <= 1'b1;
				audInL[10] <= iAUD_ADCDAT;
				state <= SETUP_L_7;
			end
			SETUP_L_7: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[9];
				state <= SEND_L_7;
			end
			SEND_L_7: begin
				oAUD_BCK <= 1'b1;
				audInL[9] <= iAUD_ADCDAT;
				state <= SETUP_L_8;
			end
			SETUP_L_8: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[8];
				state <= SEND_L_8;
			end
			SEND_L_8: begin
				oAUD_BCK <= 1'b1;
				audInL[8] <= iAUD_ADCDAT;
				state <= SETUP_L_9;
			end
			SETUP_L_9: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[7];
				state <= SEND_L_9;
			end
			SEND_L_9: begin
				oAUD_BCK <= 1'b1;
				audInL[7] <= iAUD_ADCDAT;
				state <= SETUP_L_10;
			end
			SETUP_L_10: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[6];
				state <= SEND_L_10;
			end
			SEND_L_10: begin
				oAUD_BCK <= 1'b1;
				audInL[6] <= iAUD_ADCDAT;
				state <= SETUP_L_11;
			end
			SETUP_L_11: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[5];
				state <= SEND_L_11;
			end
			SEND_L_11: begin
				oAUD_BCK <= 1'b1;
				audInL[5] <= iAUD_ADCDAT;
				state <= SETUP_L_12;
			end
			SETUP_L_12: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[4];
				state <= SEND_L_12;
			end
			SEND_L_12: begin
				oAUD_BCK <= 1'b1;
				audInL[4] <= iAUD_ADCDAT;
				state <= SETUP_L_13;
			end
			SETUP_L_13: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[3];
				state <= SEND_L_13;
			end
			SEND_L_13: begin
				oAUD_BCK <= 1'b1;
				audInL[3] <= iAUD_ADCDAT;
				state <= SETUP_L_14;
			end
			SETUP_L_14: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[2];
				state <= SEND_L_14;
			end
			SEND_L_14: begin
				oAUD_BCK <= 1'b1;
				audInL[2] <= iAUD_ADCDAT;
				state <= SETUP_L_15;
			end
			SETUP_L_15: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[1];
				state <= SEND_L_15;
			end
			SEND_L_15: begin
				oAUD_BCK <= 1'b1;
				audInL[1] <= iAUD_ADCDAT;
				state <= SETUP_L_16;
			end
			SETUP_L_16: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutL[0];
				state <= SEND_L_16;
			end
			SEND_L_16: begin
				oAUD_BCK <= 1'b1;
				audInL[0] <= iAUD_ADCDAT;
				state <= WAIT_L;
			end
			WAIT_L: begin
				if (count == 9'd92)
				begin
					state <= SETUP_R_1;
					count <= 9'd0;
				end
				else
					count <= count + 9'd1;
			end
			SETUP_R_1: begin
				oAUD_LRCK <= 1'b0;
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= iAUD_extR[15];
				audOutR <= iAUD_extR;
				state <= SEND_R_1;
			end
			SEND_R_1: begin
				oAUD_BCK <= 1'b1;
				audInR[15] <= iAUD_ADCDAT;
				state <= SETUP_R_2;
			end
			SETUP_R_2: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[14];
				state <= SEND_R_2;
			end
			SEND_R_2: begin
				oAUD_BCK <= 1'b1;
				audInR[14] <= iAUD_ADCDAT;
				state <= SETUP_R_3;
			end
			SETUP_R_3: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[13];
				state <= SEND_R_3;
			end
			SEND_R_3: begin
				oAUD_BCK <= 1'b1;
				audInR[13] <= iAUD_ADCDAT;
				state <= SETUP_R_4;
			end
			SETUP_R_4: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[12];
				state <= SEND_R_4;
			end
			SEND_R_4: begin
				oAUD_BCK <= 1'b1;
				audInR[12] <= iAUD_ADCDAT;
				state <= SETUP_R_5;
			end
			SETUP_R_5: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[11];
				state <= SEND_R_5;
			end
			SEND_R_5: begin
				oAUD_BCK <= 1'b1;
				audInR[11] <= iAUD_ADCDAT;
				state <= SETUP_R_6;
			end
			SETUP_R_6: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[10];
				state <= SEND_R_6;
			end
			SEND_R_6: begin
				oAUD_BCK <= 1'b1;
				audInR[10] <= iAUD_ADCDAT;
				state <= SETUP_R_7;
			end
			SETUP_R_7: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[9];
				state <= SEND_R_7;
			end
			SEND_R_7: begin
				oAUD_BCK <= 1'b1;
				audInR[9] <= iAUD_ADCDAT;
				state <= SETUP_R_8;
			end
			SETUP_R_8: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[8];
				state <= SEND_R_8;
			end
			SEND_R_8: begin
				oAUD_BCK <= 1'b1;
				audInR[8] <= iAUD_ADCDAT;
				state <= SETUP_R_9;
			end
			SETUP_R_9: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[7];
				state <= SEND_R_9;
			end
			SEND_R_9: begin
				oAUD_BCK <= 1'b1;
				audInR[7] <= iAUD_ADCDAT;
				state <= SETUP_R_10;
			end
			SETUP_R_10: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[6];
				state <= SEND_R_10;
			end
			SEND_R_10: begin
				oAUD_BCK <= 1'b1;
				audInR[6] <= iAUD_ADCDAT;
				state <= SETUP_R_11;
			end
			SETUP_R_11: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[5];
				state <= SEND_R_11;
			end
			SEND_R_11: begin
				oAUD_BCK <= 1'b1;
				audInR[5] <= iAUD_ADCDAT;
				state <= SETUP_R_12;
			end
			SETUP_R_12: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[4];
				state <= SEND_R_12;
			end
			SEND_R_12: begin
				oAUD_BCK <= 1'b1;
				audInR[4] <= iAUD_ADCDAT;
				state <= SETUP_R_13;
			end
			SETUP_R_13: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[3];
				state <= SEND_R_13;
			end
			SEND_R_13: begin
				oAUD_BCK <= 1'b1;
				audInR[3] <= iAUD_ADCDAT;
				state <= SETUP_R_14;
			end
			SETUP_R_14: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[2];
				state <= SEND_R_14;
			end
			SEND_R_14: begin
				oAUD_BCK <= 1'b1;
				audInR[2] <= iAUD_ADCDAT;
				state <= SETUP_R_15;
			end
			SETUP_R_15: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[1];
				state <= SEND_R_15;
			end
			SEND_R_15: begin
				oAUD_BCK <= 1'b1;
				audInR[1] <= iAUD_ADCDAT;
				state <= SETUP_R_16;
			end
			SETUP_R_16: begin
				oAUD_BCK <= 1'b0;
				oAUD_DATA <= audOutR[0];
				state <= SEND_R_16;
			end
			SEND_R_16: begin
				oAUD_BCK <= 1'b1;
				audInR[0] <= iAUD_ADCDAT;
				state <= WAIT_R;
			end
			WAIT_R: begin
				if (count == 9'd92)
				begin
					state <= SETUP_L_1;
					count <= 9'd0;
				end
				else
					count <= count + 9'd1;
			end
		endcase
	end
end

endmodule
