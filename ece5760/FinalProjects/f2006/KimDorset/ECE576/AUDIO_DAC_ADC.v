module AUDIO_DAC_ADC (
					//	Audio Side
					oAUD_BCK,
					oAUD_DATA,
					oAUD_LRCK,
					iAUD_ADCDAT,
					//	Control Signals
					iSrc_Select,
				    iCLK_18_4,
					iRST_N,
					iCLK50, iHardReset, oADDR, oBA, oCAS_N, oCKE, oCS_N, iDQ, oDQM,
					oRAS_N, oWE_N,
					
					oledg,
					isw8,
					isw9
					);				

parameter	REF_CLK			=	16934400;	//	16.9344	MHz
parameter	SAMPLE_RATE		=	44100;		//	44.1		KHz
parameter	DATA_WIDTH		=	16;			//	16		Bits
parameter	CHANNEL_NUM		=	2;			//	Dual Channel

////////////	Input Source Number	//////////////
parameter	ADC_loop		=	0;
parameter	FLASH_DATA		=	1;
parameter	SDRAM_DATA		=	2;
parameter	SRAM_DATA		=	3;
//	Audio Side
output			oAUD_DATA;
output			oAUD_LRCK;
output	reg		oAUD_BCK;
input			iAUD_ADCDAT;
//	Control Signals
input	[7:0]	iSrc_Select;
input			iCLK_18_4;
input			iRST_N;
input 			iCLK50;
input 			iHardReset;
//  DRAM Signals
output 	[11:0]	oADDR;
output 	[1:0]	oBA;
output 			oCAS_N;
output 			oCKE;
output 			oCS_N;
inout signed [15:0]	iDQ;
output 	[1:0]	oDQM;
output			oRAS_N;
output			oWE_N;

output 	[7:0] 	oledg;

input			isw8;
input			isw9;

//	Internal Registers and Wires
reg		[3:0]	BCK_DIV;
reg		[8:0]	LRCK_1X_DIV;
reg		[3:0]	SEL_Cont;
////////////////////////////////////
reg signed	[DATA_WIDTH-1:0]	AUD_outL, AUD_outR ;
reg	signed  [DATA_WIDTH-1:0]	AUD_in;
reg							LRCK_1X;
wire	[3:0]				bit_in;
//////////////////////////////////////////////////
////////////	AUD_BCK Generator	//////////////
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		BCK_DIV		<=	0;
		oAUD_BCK	<=	0;
	end
	else
	begin
		if(BCK_DIV >= REF_CLK/(SAMPLE_RATE*DATA_WIDTH*CHANNEL_NUM*2)-1 )
		begin
			BCK_DIV		<=	0;
			oAUD_BCK	<=	~oAUD_BCK;
		end
		else
		BCK_DIV		<=	BCK_DIV+1;
	end
end

//////////////////////////////////////////////////
////////////	AUD_LRCK Generator	//////////////
//oAUD_LRCK is high for left and low for right
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LRCK_1X_DIV	<=	0;
		LRCK_1X		<=	0;
	end
	else
	begin
		//	LRCK 1X
		if(LRCK_1X_DIV >= REF_CLK/(SAMPLE_RATE*2)-1 )
		begin
			LRCK_1X_DIV	<=	0;
			LRCK_1X	<=	~LRCK_1X;
		end
		else
		LRCK_1X_DIV		<=	LRCK_1X_DIV+1;	
	end
end

assign oAUD_LRCK = LRCK_1X;

//initialization of delayed versions of input
reg signed [DATA_WIDTH-1:0] input1,input2,input3,input4,input5,input6,input7,input8,input9,input10,
input11,input12,input13,input14,input15,input16,input17,input18,input19,input20,
input21,input22,input23,input24,input25,input26,input27,input28,input29,input30,
input31,input32,input33,input34,input35,input36,input37,input38,input39,input40,
input41,input42,input43,input44,input45,input46,input47,input48,input49,input50,
input51,input52,input53,input54,input55,input56,input57,input58,input59,input60,
input61,input62,input63,input64,input65,input66,input67,input68,input69,input70,
input71,input72,input73,input74,input75,input76,input77,input78,input79,input80,
input81,input82,input83,input84,input85,input86,input87,input88,input89,input90,
input91,input92,input93,input94,input95,input96,input97,input98,input99,input100,
input101,input102,input103,input104,input105,input106,input107,input108,input109,input110,
input111,input112,input113,input114,input115,input116,input117,input118,input119,input120,
input121,input122,input123,input124,input125,input126,input127,input128;

reg signed [15:0] finalsumL, finalsumR;
reg signed [40:0] tempsumL, tempsumR, max;

wire [7:0] addycpu;  //memory address to write to
wire signed [15:0] leftdatacpu;  //data to be written to memory for left channel
wire signed [15:0] rightdatacpu;  //data to be written to memory for right channel
wire signed [15:0] leftdatamem;  //data from memory for left channel
wire signed [15:0] rightdatamem;  //data from memory for right channel
wire [7:0] address;  //address to be sent to memory
reg [7:0] addymem;  //memory address to read from
wire we;  //controls read/write of memory
reg signed [15:0] mult1, mult2L, mult2R;  //16-bit numbers to multiply
wire signed [31:0] multanswerL, multanswerR;  //32-bit numbers answers from multipliers
reg [7:0] state;  //variable for state machine
wire [7:0] oledg;

//////////////////////////////////////////////////
////////Instantiating CPU
nios_system CPU (iCLK50, iHardReset, addycpu, oledg, leftdatacpu, rightdatacpu, 
	oADDR, oBA, oCAS_N, oCKE, oCS_N, iDQ, oDQM, oRAS_N, oWE_N, iSrc_Select, isw8, isw9, we);
//////////////////////////////////////////////////
////////Instantiate RAM for left and right channels
ram_infer L0 (leftdatamem,address,leftdatacpu,we,iCLK50);
ram_infer R0 (rightdatamem,address,rightdatacpu,we,iCLK50);
//////////////////////////////////////////////////
////////Instantiate Multiplier for left and right channels
multiplier ML0 (mult1,mult2L,multanswerL,iCLK50);
multiplier MR0 (mult1,mult2R,multanswerR,iCLK50);

assign address = (we) ? addycpu : addymem;  //address sent to memory depends on read or write

// output the DAC bit-stream						
assign oAUD_DATA = (LRCK_1X)? AUD_outL[~SEL_Cont]: AUD_outR[~SEL_Cont];

//initialize values on startup
initial
begin
	state = 8'h00;
	addymem <= 8'd10;
	max <= 0;
end

//////////////////////////////////////////////////
//////////	16 Bits - MSB First	//////////////////
/// Clocks in the ADC input
/// and sets up the output bit selector
//////////////////////////////////////////////////
always@(negedge oAUD_BCK or negedge iRST_N)
begin
	if(!iRST_N) SEL_Cont <= 0;
	else
	begin
		SEL_Cont <= SEL_Cont+1; //4 bit counter, so it wraps at 16
		AUD_in[~(SEL_Cont)] <= iAUD_ADCDAT;
	end
end
																			
// Filter the input sample and register output	
always@(negedge LRCK_1X)
begin
	AUD_outR <= finalsumR[15:0];
	AUD_outL <= finalsumL[15:0];
	
	input128<=input127;input127<=input126;input126<=input125;input125<=input124;input124<=input123;input123<=input122;input122<=input121;
	input121<=input120;input120<=input119;input119<=input118;input118<=input117;input117<=input116;input116<=input115;input115<=input114;
	input114<=input113;input113<=input112;input112<=input111;input111<=input110;input110<=input109;input109<=input108;input108<=input107;
	input107<=input106;input106<=input105;input105<=input104;input104<=input103;input103<=input102;input102<=input101;input101<=input100;
	input100<=input99;input99<=input98;input98<=input97;input97<=input96;input96<=input95;input95<=input94;input94<=input93;input93<=input92;
	input92<=input91;input91<=input90;input90<=input89;input89<=input88;input88<=input87;input87<=input86;input86<=input85;input85<=input84;
	input84<=input83;input83<=input82;input82<=input81;input81<=input80;input80<=input79;input79<=input78;input78<=input77;input77<=input76;
	input76<=input75;input75<=input74;input74<=input73;input73<=input72;input72<=input71;input71<=input70;input70<=input69;input69<=input68;
	input68<=input67;input67<=input66;input66<=input65;input65<=input64;input64<=input63;input63<=input62;input62<=input61;input61<=input60;
	input60<=input59;input59<=input58;input58<=input57;input57<=input56;input56<=input55;input55<=input54;input54<=input53;input53<=input52;
	input52<=input51;input51<=input50;input50<=input49;input49<=input48;input48<=input47;input47<=input46;input46<=input45;input45<=input44;
	input44<=input43;input43<=input42;input42<=input41;input41<=input40;input40<=input39;input39<=input38;input38<=input37;input37<=input36;
	input36<=input35;input35<=input34;input34<=input33;input33<=input32;input32<=input31;input31<=input30;input30<=input29;input29<=input28;
	input28<=input27;input27<=input26;input26<=input25;input25<=input24;input24<=input23;input23<=input22;input22<=input21;input21<=input20;
	input20<=input19;input19<=input18;input18<=input17;input17<=input16;input16<=input15;input15<=input14;input14<=input13;input13<=input12;
	input12<=input11;input11<=input10;input10<=input9;input9<=input8;input8<=input7;input7<=input6;input6<=input5;input5<=input4;input4<=input3;
	input3<=input2;input2<=input1;
	
	if ((AUD_in < 8) && (AUD_in > -8)) input1<=0;
	else input1<=AUD_in;
end

always@(posedge iCLK50)  //set HRIR variables, multiply with proper input and accumulate
begin
	if (we == 0)  //only update HRIR values when m4k not being written to
	begin
		case (state)
			8'd0:
			begin
				addymem<=state+8'd10;
				state<=8'd1;
			end
			8'd1:
			begin
				addymem<=state+8'd10;
				state<=8'd2;
			end
			8'd2:
			begin
				mult1<=input1;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd3;
			end
			8'd3:
			begin
				mult1<=input2;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd4;
			end
			8'd4:
			begin
				tempsumL<=multanswerL;
				tempsumR<=multanswerR;
				mult1<=input3;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd5;
			end
			8'd5:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input4;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd6;
			end
			8'd6:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input5;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd7;
			end
			8'd7:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input6;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd8;
			end
			8'd8:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input7;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd9;
			end
			8'd9:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input8;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd10;
			end
			8'd10:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input9;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd11;
			end
			8'd11:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input10;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd12;
			end
			8'd12:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input11;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd13;
			end
			8'd13:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input12;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd14;
			end
			8'd14:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input13;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd15;
			end
			8'd15:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input14;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd16;
			end
			8'd16:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input15;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd17;
			end
			8'd17:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input16;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd18;
			end
			8'd18:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input17;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd19;
			end
			8'd19:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input18;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd20;
			end
			8'd20:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input19;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd21;
			end
			8'd21:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input20;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd22;
			end
			8'd22:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input21;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd23;
			end
			8'd23:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input22;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd24;
			end
			8'd24:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input23;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd25;
			end
			8'd25:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input24;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd26;
			end
			8'd26:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input25;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd27;
			end
			8'd27:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input26;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd28;
			end
			8'd28:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input27;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd29;
			end
			8'd29:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input28;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd30;
			end
			8'd30:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input29;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd31;
			end
			8'd31:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input30;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd32;
			end
			8'd32:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input31;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd33;
			end
			8'd33:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input32;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd34;
			end
			8'd34:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input33;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd35;
			end
			8'd35:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input34;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd36;
			end
			8'd36:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input35;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd37;
			end
			8'd37:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input36;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd38;
			end
			8'd38:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input37;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd39;
			end
			8'd39:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input38;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd40;
			end
			8'd40:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input39;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd41;
			end
			8'd41:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input40;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd42;
			end
			8'd42:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input41;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd43;
			end
			8'd43:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input42;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd44;
			end
			8'd44:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input43;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd45;
			end
			8'd45:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input44;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd46;
			end
			8'd46:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input45;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd47;
			end
			8'd47:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input46;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd48;
			end
			8'd48:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input47;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd49;
			end
			8'd49:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input48;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd50;
			end
			8'd50:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input49;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd51;
			end
			8'd51:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input50;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd52;
			end
			8'd52:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input51;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd53;
			end
			8'd53:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input52;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd54;
			end
			8'd54:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input53;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd55;
			end
			8'd55:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input54;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd56;
			end
			8'd56:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input55;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd57;
			end
			8'd57:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input56;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd58;
			end
			8'd58:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input57;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd59;
			end
			8'd59:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input58;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd60;
			end
			8'd60:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input59;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd61;
			end
			8'd61:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input60;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd62;
			end
			8'd62:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input61;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd63;
			end
			8'd63:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input62;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd64;
			end
			8'd64:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input63;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd65;
			end
			8'd65:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input64;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd66;
			end
			8'd66:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input65;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd67;
			end
			8'd67:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input66;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd68;
			end
			8'd68:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input67;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd69;
			end
			8'd69:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input68;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd70;
			end
			8'd70:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input69;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd71;
			end
			8'd71:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input70;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd72;
			end
			8'd72:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input71;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd73;
			end
			8'd73:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input72;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd74;
			end
			8'd74:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input73;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd75;
			end
			8'd75:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input74;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd76;
			end
			8'd76:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input75;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd77;
			end
			8'd77:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input76;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd78;
			end
			8'd78:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input77;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd79;
			end
			8'd79:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input78;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd80;
			end
			8'd80:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input79;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd81;
			end
			8'd81:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input80;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd82;
			end
			8'd82:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input81;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd83;
			end
			8'd83:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input82;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd84;
			end
			8'd84:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input83;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd85;
			end
			8'd85:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input84;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd86;
			end
			8'd86:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input85;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd87;
			end
			8'd87:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input86;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd88;
			end
			8'd88:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input87;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd89;
			end
			8'd89:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input88;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd90;
			end
			8'd90:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input89;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd91;
			end
			8'd91:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input90;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd92;
			end
			8'd92:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input91;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd93;
			end
			8'd93:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input92;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd94;
			end
			8'd94:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input93;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd95;
			end
			8'd95:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input94;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd96;
			end
			8'd96:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input95;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd97;
			end
			8'd97:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input96;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd98;
			end
			8'd98:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input97;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd99;
			end
			8'd99:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input98;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd100;
			end
			8'd100:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input99;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd101;
			end
			8'd101:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input100;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd102;
			end
			8'd102:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input101;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd103;
			end
			8'd103:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input102;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd104;
			end
			8'd104:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input103;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd105;
			end
			8'd105:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input104;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd106;
			end
			8'd106:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input105;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd107;
			end
			8'd107:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input106;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd108;
			end
			8'd108:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input107;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd109;
			end
			8'd109:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input108;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd110;
			end
			8'd110:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input109;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd111;
			end
			8'd111:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input110;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd112;
			end
			8'd112:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input111;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd113;
			end
			8'd113:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input112;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd114;
			end
			8'd114:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input113;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd115;
			end
			8'd115:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input114;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd116;
			end
			8'd116:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input115;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd117;
			end
			8'd117:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input116;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd118;
			end
			8'd118:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input117;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd119;
			end
			8'd119:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input118;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd120;
			end
			8'd120:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input119;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd121;
			end
			8'd121:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input120;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd122;
			end
			8'd122:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input121;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd123;
			end
			8'd123:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input122;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd124;
			end
			8'd124:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input123;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd125;
			end
			8'd125:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input124;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd126;
			end
			8'd126:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input125;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd127;
			end
			8'd127:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input126;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=state+8'd10;
				state<=8'd128;
			end
			8'd128:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input127;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=8'd10;
				state<=8'd129;
			end
			8'd129:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input128;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=8'd11;
				state<=8'd130;
			end
			8'd130:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input1;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=8'd12;
				state<=8'd131;
			end
			8'd131:
			begin
				tempsumL<=tempsumL+multanswerL;
				tempsumR<=tempsumR+multanswerR;
				mult1<=input2;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem<=8'd13;
				state<=8'd132;								
			end
			8'd132:
			begin	
				if ((~tempsumL+1) > max)  //determine normalization value
				begin
					max <= ((~tempsumL)+1'b1) + 35;
				end	
				if ((~tempsumR+1) > max)  //determine normalization value
				begin
					max <= ((~tempsumR)+1'b1) + 35;
				end	
				finalsumL <= (tempsumL<<(4'd15))/max;  //normalize output
				finalsumR <= (tempsumR<<(4'd15))/max;
				tempsumL<=multanswerL;
				tempsumR<=multanswerR;
				mult1<=input3;
				mult2L<=leftdatamem;
				mult2R<=rightdatamem;
				addymem <= 8'd14;
				state<=8'd5;	
			end
			
			default:
			begin
				state<=8'd0;
			end			
		endcase
	end
end

endmodule
			
module ram_infer (q, a, d, we, clk);
	output signed [15:0] q;
	input signed [15:0] d;
	input [7:0] a;
	input we, clk;
	reg [7:0] read_add;
	reg signed [15:0] mem [138:0];
	always @ (posedge clk) 
	begin
		if (we) mem[a] <= d;
		read_add <= a;
	end
	assign q = mem[read_add];
endmodule 		
		
module multiplier (a, b, out, clk);
	input signed [15:0] a;
	input signed [15:0] b;
	input clk;
	output signed [31:0] out;
	reg signed [31:0] answer;
	always @ (posedge clk)
	begin
		answer <= a*b;
	end
	assign out = answer;
endmodule