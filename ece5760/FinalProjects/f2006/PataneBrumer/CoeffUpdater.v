// Coefficient Updater logic
// Connects to the External RAM which contains the entire set of Coefficients (for 25 Elevations and 25 Azimuths)
// Control logic sets Azimuth/Elevation/Stream and pulses Start
// This loads the appropriate Coefficients from the main RAM, and writes them into each of the Coefficient RAMs for that stream.
// Upon completion of Updating the Coefficient ram, the Filter Select for that stream is inverted. 
// This indicates to the Filter logic that it should read from the other coefficient RAM after the current sample is done being processed.


module CoeffUpdater(
  Clock,
  Reset,
  Azimuth,
  Elevation,
  Stream,
  Start,
  Busy,

// External RAM which holds the entire set of Coefficients
// Originally planned to use the SDRAM, but decided to use the SRAM (never bothered to change the signal names)
  SDRAM_Addr,
  SDRAM_ReadData,
  SDRAM_ReadEnable,

// This is the Addr/Data for all writes to the Coefficient RAMs.  These connect to all RAMs and the Write Enables determine which RAM will make use of it.
  CoeffRam_Addr,
  CoeffRam_Data,

// Write Enable signals for the 4 Coefficient RAMs
  CoeffRam0_L_WE,
  CoeffRam0_R_WE,
  CoeffRam1_L_WE,
  CoeffRam1_R_WE,

// Select signals to determin which Coefficient RAM Bank is being read from, as well as which is being updated.
  Filter0Select,
  Filter1Select,
 
  Filter0Done

  );
  
  input       Clock;
  input       Reset;
  input [4:0] Azimuth;
  input [5:0] Elevation;
  input [3:0] Stream;
  input       Start;
  output      Busy;

  output [17:0] SDRAM_Addr;
  input  [16:0] SDRAM_ReadData;
  output        SDRAM_ReadEnable;

  output  [7:0] CoeffRam_Addr;
  output [16:0] CoeffRam_Data;
  output        CoeffRam0_R_WE;
  output        CoeffRam0_L_WE;
  output        CoeffRam1_L_WE;
  output        CoeffRam1_R_WE;
  output       Filter0Select;
  output       Filter1Select;

  input        Filter0Done;

  parameter    NUM_TAPS = 200;

  reg  Start_L;
  
  reg  StateIdle;
  reg  StateStartUpdateL;
  reg  StateUpdateL;
  reg  StateStartUpdateR;
  reg  StateUpdateR;


  reg [7:0] Count;

  reg  [7:0] CoeffRam_Addr;
  reg [17:0] SDRAM_Addr;
  reg        Filter0Select;
  reg        Filter1Select;

  wire UpdateDone = (CoeffRam_Addr == (NUM_TAPS-1));
  
  wire [17:0] sram_addr_computed_l,sram_addr_computed_r;

  

  wire StartPulse = Start & ~Start_L;
  always@(posedge Clock) begin
    Start_L <= Start;
  end

 
// Coefficient Updater State Machine
  always@(posedge Clock) begin
    if(Reset) begin
      StateIdle               <= 1'b1;
      StateStartUpdateL       <= 1'b0;
      StateUpdateL            <= 1'b0;
      StateStartUpdateR       <= 1'b0;
      StateUpdateR            <= 1'b0;
    end
    else begin
      StateIdle              <= StateIdle & ~StartPulse ||
                                StateUpdateR & UpdateDone;
  
      StateStartUpdateL      <= StateIdle & StartPulse;

      StateUpdateL           <= StateStartUpdateL ||
                                StateUpdateL & ~UpdateDone;

      StateStartUpdateR      <= StateUpdateL & UpdateDone;

      StateUpdateR           <= StateStartUpdateR ||
                                StateUpdateR * ~UpdateDone;
    end   
  end
  
  
  assign sram_addr_computed_l = (5000 * Azimuth) + (200 * Elevation);
  assign sram_addr_computed_r = 125000 + sram_addr_computed_l;

  assign SDRAM_ReadEnable   = ~StateIdle;

  assign CoeffRam0_L_WE = StateUpdateL & (Stream == 0);
  assign CoeffRam0_R_WE = StateUpdateR & (Stream == 0);
  assign CoeffRam1_L_WE = StateUpdateL & (Stream == 1);
  assign CoeffRam1_R_WE = StateUpdateR & (Stream == 1);

  assign CoeffRam_Data = SDRAM_ReadData;

  always@(posedge Clock) begin 

    SDRAM_Addr     <= (StateStartUpdateL)               ? sram_addr_computed_l :
                      (StateStartUpdateR)               ? sram_addr_computed_r : SDRAM_Addr + 1;

    CoeffRam_Addr <= (StateStartUpdateL | StateStartUpdateR | StateIdle) ?                    0 : CoeffRam_Addr + 1;

    Filter0Select <= (Reset)                     ? 0 : 
                     (StateUpdateR & UpdateDone & (Stream == 0)) ? ~Filter0Select :   Filter0Select;
    Filter1Select <= (Reset)                     ? 0 : 
                     (StateUpdateR & UpdateDone & (Stream == 1)) ? ~Filter1Select :   Filter1Select;
  end

endmodule