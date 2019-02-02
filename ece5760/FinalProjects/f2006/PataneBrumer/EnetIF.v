// Ethernet Interface logic
// When StartInit is raised, we run through the Ethernet PHY/MAC Initialization Routine 
//      and then settle in WaitForPacket.
// Once the Interrupt line goes high, we know a packet has arrived and enter the NewPacket state.
// Here we process the header (setting the DataCount equal to the length of the Packet pulled from the header
//      and immediately read the first word from the packet, and go back to Waitforpacket.
// After this, each time StartRead pulses, we read the next word and it is output as AudioStream.
// Because the StartRead signal is connected to AudioInReady, we are guaranteed to read one word at a rate of 48kHz.
// No flow control has been implemented, and so it is up to software to ensure that data is written to the ethernet device
//      at a rate of 48k samples/second.


module EnetIF(
  Clock,
  Reset,
  StartInit,
  StartRead,
  DriveZ,

  ENET_DATAw,
  ENET_DATAr,
  ENET_CMD,
  ENET_CS_N,
  ENET_WR_N,
  ENET_RD_N,
  ENET_RST_N,
  ENET_INT,
  ENET_CLK,
  
  AudioStream,

  );

  input Clock;
  input Reset;
  input StartInit;
  input StartRead;
  output DriveZ;

  output [15:0] ENET_DATAw;
  input  [15:0] ENET_DATAr;
  output       ENET_CMD;
  output       ENET_CS_N;
  output       ENET_WR_N;
  output       ENET_RD_N;
  output       ENET_RST_N=~Reset;
  input        ENET_INT;
  output       ENET_CLK=Clock;
  
  output [15:0] AudioStream;

  wire FifoWriteReq;
  wire FifoFull;

  reg [15:0] AudioStream;

reg StateReset;
reg StateInit0;
reg StateInit1;
reg StateWaitForDone;
reg StateDelay;
reg StateWaitForPacket;
reg StateNewPacket;
reg StateGetData;
reg StateWaitData;
reg StateFlushByte;
reg StateWaitFlush;

reg [2:0] StartRead_L;
reg [7:0] InitCounter;
reg [9:0] ResetCounter;
reg [9:0] DelayCounter;

wire [7:0]  InitRamAddr;
wire [17:0] InitRamData; // 17 = Cmd, 16 = RW, [15:0] = Data/Addr
wire InitDone = (InitCounter == 14);
reg [3:0] Iteration;
reg [15:0] DataCount;
wire DataDone = (DataCount == 0);
reg [3:0] NPC;  // Substate while in State NewPacket (New Packet Counter)... handles sequencing of Packet Header Processing

wire StartReadPulse = StartRead_L[1] & ~StartRead_L[2];

always@(posedge Clock) begin
  StartRead_L <= {StartRead_L[1:0],StartRead};
end

always@(posedge Clock) begin
  if(Reset) begin
    StateReset         <= 1'b1;
    StateInit0         <= 1'b0;
    StateInit1         <= 1'b0; 
    StateWaitForDone   <= 1'b0;
    StateDelay         <= 1'b0;
    StateWaitForPacket <= 1'b0;
    StateNewPacket     <= 1'b0;
    StateGetData       <= 1'b0;
    StateWaitData      <= 1'b0;
    StateFlushByte     <= 1'b0;
    StateWaitFlush     <= 1'b0;
    
  end
  else begin
    StateReset     <= StateReset & ~StartInit;
    StateInit0     <= (StateReset & StartInit) |
                      StateWaitForDone & (DelayCounter == 300) & ~InitDone |
                      StateDelay & (DelayCounter == 300) & ~InitDone |
                      StateWaitForPacket & StartInit;
    StateInit1     <= StateInit0;
    StateWaitForDone <= StateInit1 & ~InitRamData[11] | 
                        StateWaitForDone & ~(DelayCounter == 300);

    StateDelay     <= StateInit1 & InitRamData[11] |
                      StateDelay & ~(DelayCounter == 300);

    StateWaitForPacket <= StateWaitForDone & (DelayCounter == 300) & InitDone |
                          StateDelay & InitDone |
                          StateWaitForPacket & ~(StartReadPulse & (ENET_INT | ~(DataCount == 0) ) ) & ~StartInit |
                          StateWaitData & RawDone & (DataCount > 4) |
                          StateWaitFlush & (DataCount == 0);
   
    StateNewPacket   <= StateWaitForPacket & StartReadPulse & ENET_INT & DataCount == 0 |
                        StateNewPacket & ~(NPC == 15);

    StateGetData     <= StateWaitForPacket & StartReadPulse & (DataCount > 4) |
                        StateNewPacket & (NPC == 15);

    StateWaitData    <= StateGetData |
                        StateWaitData & ~RawDone;

    StateFlushByte   <= StateWaitData & RawDone & (DataCount <= 4) |
                        StateWaitFlush & (DataCount > 0) & RawDone;
    StateWaitFlush   <= StateFlushByte | 
                        StateWaitFlush & ~RawDone;

  end
end

always@(posedge Clock) begin
  InitCounter <= (Reset | StateWaitForPacket) ? 0 : StateInit1  ? InitCounter + 1 : InitCounter;
  DelayCounter <= (StateInit1) ? 0 : DelayCounter + 1;
  ResetCounter <= (Reset) ? 0 : ResetCounter+1;
  Iteration <= (Reset) ? 0 : (StateWaitForPacket) ? Iteration + 1 : Iteration;

  RawStart <= StateInit1 | (StateNewPacket & (NPC[0]==0) & ~(NPC == 14) ) | StateGetData | StateFlushByte;

  RawRW    <= (StateInit1)       ? InitRamData[8] : 
              (StateNewPacket) ?  
                 (NPC == 0)  ? 1 :
                 (NPC == 2)  ? 0 :
                 (NPC == 8)  ? 1 :
                 (NPC == 10)  ? 0 :
                 (NPC == 12)  ? 0 : 
                 (NPC == 4) ? 0 :
                 (NPC == 6) ? 0 : RawRW :
              (StateGetData) ? 0 : RawRW;

  RawAD    <= (StateInit1)       ? InitRamData[9] : 
              (StateNewPacket) ?
                  (NPC == 0) ? 0 :
                  (NPC == 2) ? 1 :
                  (NPC == 8) ? 0 :
                  (NPC == 10) ? 1 :
                  (NPC == 12) ? 1 : 
                  (NPC == 4) ? 0 :
                  (NPC == 6) ? 1 : RawAD : 
              (StateGetData) ? 1 : RawAD;

  RawWriteData <= (StateInit1)   ? {8'b0,InitRamData[7:0]} : 
                  (StateNewPacket) ?
                      (NPC == 0)   ? 16'hF0 :
                      (NPC == 8)   ? 16'hF2 : 
                      (NPC == 4)  ? 16'hFE :
                      (NPC == 6)  ? 16'h3F : RawWriteData :
                       RawWriteData;
 
  DataCount <= (StateReset)                    ? 0 :
               (StateNewPacket & (NPC == 13))  ? RawReadData :
               (StateGetData | StateFlushByte) ? DataCount - 2 : DataCount;

  NPC <= (StateWaitForPacket) ? 0 : 
         (StateNewPacket & (~NPC[0] | RawDone) )     ? NPC + 1 : NPC;


end

always@(posedge Clock) begin
  AudioStream <= (StateWaitData & RawDone) ? {RawReadData[7:0],RawReadData[15:8]} : AudioStream;
end


// Raw Logic handles actual access to the Ethernet Phy...
// This way the other state machine simply sets RawRW/RawAD/RawWriteData and pulses RawStart... and then waits for RawDone.
reg RawStart;
wire RawDone;
reg  RawRW;  // 0 = Read, 1 = Write
reg  RawAD;  // 0 = Address , 1 = Data
reg  [15:0] RawWriteData;
reg  [15:0] RawReadData;


reg RawIdle;
reg RawSetup;
reg RawIssue;
reg RawHold0;
reg RawHold1;

always@(posedge Clock) begin
  if(Reset) begin
    RawIdle <= 1'b1;
    RawSetup<= 1'b0;
    RawIssue <= 1'b0;
    RawHold0 <= 1'b0;
    RawHold1 <= 1'b0;
  end
  else begin
    RawIdle  <= RawIdle & ~RawStart | 
                RawHold1;
    RawSetup <= RawIdle & RawStart;
    RawIssue <= RawSetup;
    RawHold0 <= RawIssue;
    RawHold1 <= RawHold0;
  end
end

always@(posedge Clock) begin
  RawReadData <= (RawHold0) ? ENET_DATAr : RawReadData;
end   

assign RawDone = RawHold1;

assign ENET_DATAw = RawWriteData;  //Initialization Phase, coming from RAM
assign ENET_CMD =  (RawIdle) ? 0 : RawAD;
assign ENET_CS_N =  (RawIdle) ? 1 : 0 ;
assign ENET_WR_N = (RawIssue) ? ~RawRW : 1;
assign ENET_RD_N = (RawIssue) ? RawRW : 1;
assign DriveZ = ~(RawRW & ~RawIdle);


assign InitRamAddr = InitCounter;

EnetInit EnetInitRam(
	.address(InitRamAddr),
	.clock(Clock),
	.q(InitRamData)
);


endmodule