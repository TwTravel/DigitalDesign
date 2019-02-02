/*********************************************
 *	NTSC Color Video Generator						*
 *	Michael Ross and Joshua Schwartz				*
 *	ECE 5760												*
 *********************************************/
 /***** Module Information *****/
 /*	The Color NTSC Generator module is designed to maximize the functionality
 of the DE2 board for generating color NTSC outputs through the VGA connector.
 The color is specified in HSV encoding.  The input frequency is the closest 
 to a multiple of the colorburst frequency that can be achieved by the PLL on the
 FPGA.  Because it is roughly 15x the colorburst frequency, there are 15 possible
 hues for the output. A hue input of 15 will wrap to zero.
	The oLookupClk output is used to inform external hardware of when a data point is
requested. Exactly 9 cycles later, valid data is expected on the iIntensity, iHue, and
iSaturation inputs. Using the input clock to control SRAM, this allows for a full 9 
SRAM accesses.  If memory were large enough, this would allow hue, saturation, and
value to be stored as full words for three NTSC generators operating simultaneously.
	The only connection needed to the VGA hardware is oVGA, which should be connected
to the red, green, or blue channel of the DAC. Sync outputs are used only to control
memory access.	*/
 module NTSC_Color_Generator(
	// Control Signals
	input iClk,			// 50MHz * 29/27 = 53.7037037MHz ~15x Colorburst
	input iRST_N,
	// Host Connections
	input [8:0] iIntensity,			// Input range 0-512
	input [3:0] iHue,					// Input range 0-14 - 15 wraps to 0
	input [6:0] iSaturation,		// Input range 0-127
	output reg [17:0] oAddress,
	output reg [8:0] oCoord_X,
	output wire [7:0] oCoord_Y,
	output wire oSync,
	output wire oV_Sync,
	output wire oH_Sync,
	output wire oLookupClk,
	// VGA Encoder Connections
	output reg [9:0] oVGA
);

// File contains timing and counting parameters for NTSC video
`include "NTSC_Param_Square.h"

// Internal Registers and Wires
reg [12:0] LineCounter;		// Tracks the point on the line
reg [8:0] LineNumber;		// Tracks the line in the frame
reg [8:0] HoldIntensity;
reg [3:0] HoldHue;
reg [6:0] HoldSaturation;
reg [9:0] OutLevel;
reg [9:0] BurstLevel;

assign oSync = oV_Sync || oH_Sync;
assign oCoord_Y = (LineNumber < RES_Y)?LineNumber[7:0]:8'h0;
assign oV_Sync = (LineNumber >= RES_Y);
assign oH_Sync = !oV_Sync && (LineCounter < (BACK_PORCH_T - PIXEL_T - 1));
assign oLookupClk = LookupClk && !oH_Sync && !oV_Sync;

/*** Burst Oscillator ***/
reg [3:0] BurstAccumulator;
reg LookupClk;
always @(posedge iClk or negedge iRST_N) begin
	if(!iRST_N) BurstAccumulator <= 4'h0;
	else if (BurstAccumulator < 4'h7) begin
		BurstLevel <= ZERO_LEVEL + BURST_LEVEL;
		LookupClk <= 1'b1;
		BurstAccumulator <= BurstAccumulator + 4'h1;
	end
	else begin
		BurstLevel <= ZERO_LEVEL - BURST_LEVEL;
		LookupClk <= 1'b0;
		if(BurstAccumulator >= 4'hE) BurstAccumulator <= 4'h0;
		else BurstAccumulator <= BurstAccumulator + 4'h1;
	end
end

/*** Color Oscillator ***/
reg [3:0] PhaseAccumulator;
always @(posedge iClk) begin
	if(BurstAccumulator == HoldHue) begin
		PhaseAccumulator <= 4'h0;
		OutLevel <= ZERO_LEVEL + OFFSET + HoldIntensity + {3'h0,HoldSaturation};
	end
	else begin
		if(PhaseAccumulator <= 4'h7) begin
			OutLevel <= ZERO_LEVEL + OFFSET + HoldIntensity + {3'h0,HoldSaturation};
			PhaseAccumulator <= PhaseAccumulator + 4'h1;
		end
		else if (PhaseAccumulator <= 4'hE) begin
			OutLevel <= ZERO_LEVEL + OFFSET + HoldIntensity - {3'h0,HoldSaturation};
			PhaseAccumulator <= PhaseAccumulator + 4'h1;
		end
		else OutLevel <= ZERO_LEVEL + OFFSET + HoldIntensity + {3'h0,HoldSaturation};
	end
end

/*** Color Lock-in ***/
always @(posedge oLookupClk) begin
	HoldIntensity <= iIntensity;
	HoldHue <= iHue;
	HoldSaturation <= iSaturation;
end

/*** X-coordinate and Address generator ***/
reg [3:0] PixelCount;
always @(posedge iClk) begin
	if((LineCounter < (BACK_PORCH_T-PIXEL_T - 1)) && (LineNumber < RES_Y)) begin
		oCoord_X <= 9'h0;
		PixelCount <= 4'h0;
		if(LineNumber == 9'h0) oAddress <= 18'h0;
	end
	else if(LineCounter < VIDEO_T - 1) begin
		if(PixelCount < PIXEL_T) begin
			PixelCount <= PixelCount + 4'h1;
		end
		else begin
			oCoord_X <= oCoord_X + 9'h1;
			oAddress <= oAddress + 18'h1;
			PixelCount <= 4'h0;
		end
	end
end

/*** NTSC Drawing State Machine ***/
always @(posedge iClk or negedge iRST_N) begin
	if(!iRST_N) begin
		LineCounter <= 13'h0;
		LineNumber <= 9'h0;
	end
	else begin
		if(LineNumber < RES_Y) begin
			if(LineCounter < FRONT_PORCH_T) begin
				oVGA <= ZERO_LEVEL;
				LineCounter <= LineCounter + 13'h1;
			end
			else if(LineCounter < H_SYNC_T) begin
				oVGA <= SYNC_LEVEL;
				LineCounter <= LineCounter + 13'h1;
			end
			else if(LineCounter < BREEZEWAY_T) begin
				oVGA <= ZERO_LEVEL;
				LineCounter <= LineCounter + 13'h1;
			end
			else if(LineCounter < COLORBURST_T) begin
				oVGA <= BurstLevel;
				LineCounter <= LineCounter + 13'h1;
			end
			else if(LineCounter < BACK_PORCH_T) begin
				oVGA <= ZERO_LEVEL;
				LineCounter <= LineCounter + 13'h1;
			end
			else if(LineCounter < VIDEO_T) begin
				oVGA <= OutLevel;
				if(LineCounter == (VIDEO_T - 1)) begin
					LineCounter <= 13'h0;
					LineNumber <= LineNumber + 9'h1;
				end else LineCounter <= LineCounter + 13'h1;
			end
		end
		// V.Sync
		else if(LineNumber < RES_Y + BLANK_LINES) begin
			if(LineCounter < FRONT_PORCH_T) begin
				oVGA <= ZERO_LEVEL;
				LineCounter <= LineCounter + 13'h1;
			end
			else if(LineCounter < H_SYNC_T) begin
				oVGA <= SYNC_LEVEL;
				LineCounter <= LineCounter + 13'h1;
			end
			else if(LineCounter < VIDEO_T) begin
				oVGA <= ZERO_LEVEL;
				if(LineCounter == (VIDEO_T - 1)) begin
					LineCounter <= 13'h0;
					LineNumber <= LineNumber + 9'h1;
				end else LineCounter <= LineCounter + 13'h1;
			end
		end
		else if(LineNumber < RES_Y + SYNC_LINES) begin
			if(LineCounter < (2 * V_SYNC_T)) begin
				oVGA <= ZERO_LEVEL;
				LineCounter <= LineCounter + 13'h1;
			end
			else if (LineCounter < VIDEO_T) begin
				oVGA <= SYNC_LEVEL;
				if(LineCounter == (VIDEO_T - 1)) begin
					LineCounter <= 13'h0;
					LineNumber <= LineNumber + 9'h1;
				end else LineCounter <= LineCounter + 13'h1;
			end
		end
		else  begin
			if(LineCounter < FRONT_PORCH_T) begin
				oVGA <= ZERO_LEVEL;
				LineCounter <= LineCounter + 13'h1;
			end
			else if(LineCounter < H_SYNC_T) begin
				oVGA <= SYNC_LEVEL;
				LineCounter <= LineCounter + 13'h1;
			end
			else if(LineCounter < VIDEO_T) begin
				oVGA <= ZERO_LEVEL;
				if(LineCounter == (VIDEO_T - 1)) begin
					LineCounter <= 13'h0;
					if(LineNumber == (TOTAL_Y - 1))	LineNumber <= 9'h0;
					else LineNumber <= LineNumber + 9'h1;
				end else LineCounter <= LineCounter + 13'h1;
			end
		end		
	end
end

endmodule
