/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

`include "project_params.h"

// Completely combinational module. Handles particle update assuming
// an even row (left to right traversal). To implement odd rows
// (right to left traversal), flip the left and right inputs and outputs.
// Inputs the modified and previous values of the surrounding 9x9 pixels,
// along with system state variables, and outputs the next value of the
// 9x9 pixels. Mostly concerned with determining the value of the
// middle pixel, but may swap positions with surrounding pixels.
module Particle_Update (
    input             iRESET,       // Reset signal, asserted for entire frame
    input             iSTALL,       // Stall signal to pause screen, asserted for entire frame
    input      [3:0]  iRand4,       // A random 4-bit number that changes every cycle
    input      [3:0]  iRand4Prev,   // The previous cycle's Rand4, can make 8-bit pseudorandom number
    input             iTrollFlame,  // Indicates that the troll is flaming this frame
    input      [3:0]  iCursorColor, // The color of the user's cursor (particle type to draw)
    input             iCursorDraw,  // Does cursor draw over this particle?
    input             iValidPix,    // Current pixel is on-screen
    input             iFaucetPix,   // Is this pixel being fauceted (drawn over by a faucet)?
    input      [3:0]  iFaucetType,  // What particle type is being fauceted?
    input      [3:0]  iTopL,        // Top left input pixel
    input      [3:0]  iTopM,        // Top mid input pixel
    input      [3:0]  iTopR,        // Top right input pixel
    input      [3:0]  iMidL,        // Mid left input pixel
    input      [3:0]  iMidM,        // Mid mid input pixel
    input      [3:0]  iMidR,        // Mid right input pixel
    input      [3:0]  iBotL,        // Bot left input pixel
    input      [3:0]  iBotM,        // Bot mid input pixel
    input      [3:0]  iBotR,        // Bot right input pixel
    input      [3:0]  iOldTL,       // Top left pixel from previous frame
    input      [3:0]  iOldTM,       // Top mid pixel from previous frame
    input      [3:0]  iOldTR,       // Top right pixel from previous frame
    input      [3:0]  iOldML,       // Mid left pixel from previous frame
    input      [3:0]  iOldMM,       // Mid mid pixel from previous frame
    input      [3:0]  iOldMR,       // Mid right pixel from previous frame
    input      [3:0]  iOldBL,       // Bot left pixel from previous frame
    input      [3:0]  iOldBM,       // Bot mid pixel from previous frame
    input      [3:0]  iOldBR,       // Bot right pixel from previous frame
    output     [3:0]  oTopL,        // Top left output pixel
    output     [3:0]  oTopM,        // Top mid output pixel
    output     [3:0]  oTopR,        // Top right output pixel
    output     [3:0]  oMidL,        // Mid left output pixel
    output     [3:0]  oMidM,        // Mid mid output pixel
    output     [3:0]  oMidR,        // Mid right output pixel
    output     [3:0]  oBotL,        // Bot left output pixel
    output     [3:0]  oBotM,        // Bot mid output pixel
    output     [3:0]  oBotR         // Bot right output pixel
);
    
    // Top left pixel
    reg TL_isBLANK;
    reg TL_isWATER;
    reg TL_isSPOUT;
    reg TL_wasFIRE1;
    reg TL_wasFIRE0;
    reg TL_wasTORCH;
    reg TL_wasPLANT;
    reg TL_wasHot;
    // Top mid pixel
    reg TM_isBLANK;
    reg TM_isWATER;
    reg TM_isSPOUT;
    reg TM_wasFIRE1;
    reg TM_wasFIRE0;
    reg TM_wasTORCH;
    reg TM_wasPLANT;
    reg TM_wasHot;
    // Top right pixel
    reg TR_isBLANK;
    reg TR_isWATER;
    reg TR_isSPOUT;
    reg TR_wasFIRE1;
    reg TR_wasFIRE0;
    reg TR_wasTORCH;
    reg TR_wasPLANT;
    reg TR_wasHot;
    // Mid left pixel
    reg ML_isBLANK;
    reg ML_isWATER;
    reg ML_isSAND;
    reg ML_isSALT;
    reg ML_isWALL;
    reg ML_isWAX;
    reg ML_isSPOUT;
    reg ML_solid;
    reg ML_wasFIRE1;
    reg ML_wasFIRE0;
    reg ML_wasTORCH;
    reg ML_wasPLANT;
    reg ML_wasHot;
    // Mid mid pixel
    reg MM_isBLANK;
    reg MM_isWATER;
    reg MM_isSAND;
    reg MM_isOIL;
    reg MM_isSALT;
    reg MM_isCONC;
    reg MM_isSALTW;
    reg MM_isWALL;
    reg MM_insolu;
    reg MM_mobile;
    reg MM_wasFIRE3;
    reg MM_wasFIRE2;
    reg MM_wasFIRE1;
    reg MM_wasFIRE0;
    reg MM_wasPLANT;
    reg MM_wasWAX;
    // Mid right pixel
    reg MR_isBLANK;
    reg MR_isWATER;
    reg MR_isSAND;
    reg MR_isSALT;
    reg MR_isWALL;
    reg MR_isWAX;
    reg MR_isSPOUT;
    reg MR_solid;
    reg MR_wasFIRE1;
    reg MR_wasFIRE0;
    reg MR_wasTORCH;
    reg MR_wasPLANT;
    reg MR_wasHot;
    // Bot left pixel
    reg BL_isBLANK;
    reg BL_isWATER;
    reg BL_isSAND;
    reg BL_isOIL;
    reg BL_isSALT;
    reg BL_isWALL;
    reg BL_isWAX;
    reg BL_isSPOUT;
    reg BL_solid;
    reg BL_wasFIRE1;
    reg BL_wasFIRE0;
    reg BL_wasTORCH;
    reg BL_wasPLANT;
    reg BL_wasHot;
    // Bot mid pixel
    reg BM_isBLANK;
    reg BM_isWATER;
    reg BM_isSAND;
    reg BM_isOIL;
    reg BM_isSALT;
    reg BM_isWALL;
    reg BM_isWAX;
    reg BM_isSPOUT;
    reg BM_solid;
    reg BM_wasFIRE1;
    reg BM_wasFIRE0;
    reg BM_wasTORCH;
    reg BM_wasPLANT;
    reg BM_wasHot;
    // Bot right pixel
    reg BR_isBLANK;
    reg BR_isWATER;
    reg BR_isSAND;
    reg BR_isOIL;
    reg BR_isSALT;
    reg BR_isWALL;
    reg BR_isWAX;
    reg BR_isSPOUT;
    reg BR_solid;
    reg BR_wasFIRE1;
    reg BR_wasFIRE0;
    reg BR_wasTORCH;
    reg BR_wasPLANT;
    reg BR_wasHot;
    
    // Neighborhood properties
    reg latNeighborHot;    // At least one lateral neighbor was hot
    reg diagNeighborHot;   // At least one diagonal neighbor was hot
    reg neighborWater;     // At least one neighbor is water
    reg latNeighborPlant;  // At least one lateral neighbor was plant
    reg diagNeighborPlant; // At least one diagonal neighbor was plant
    reg neighborSpout;     // At least one neighbor is spout
    reg neighborSolid;     // At least one side or downward neighbor is solid
    
    // Cursor properties
    reg CC_isBLANK;
    reg CC_wasFIRE0;
    reg CC_wasTORCH;
    reg [3:0] drawnColor;
    
    // Proximity transforms (ex: oil to fire when near fire)
    reg toPlant;
    reg toSaltW;
    reg toWall;
    reg toFire3;
    reg toFire2;
    reg toFire1;
    reg toFire0;
    reg toBlank;
    reg proxTrans;
    
    // "Draw-over" transforms
    reg fauceted;
    reg spouted;
    reg trolled;
    
    // Available movements
    reg sftPresL; // Pressure to shift left
    reg sftPresR; // Pressure to shift right
    reg canShftL; // Can shift left
    reg canShftR; // Can shift right
    reg canFallM; // Can fall straight down
    reg canFallL; // Can shift-fall left
    reg canFallR; // Can shift-fall right
    
    // Actual movements
    reg shftL;
    reg shftR;
    reg fallM;
    reg fallL;
    reg fallR;
    
    // Next positions
    reg [3:0]  nTopL;
    reg [3:0]  nTopM;
    reg [3:0]  nTopR;
    reg [3:0]  nMidL;
    reg [3:0]  nMidM;
    reg [3:0]  nMidR;
    reg [3:0]  nBotL;
    reg [3:0]  nBotM;
    reg [3:0]  nBotR;
    
    always @(*) begin
        
        /**************************************************
         * Determine Properties of Pixels                 *
         **************************************************/
        
        // Top left pixel
        TL_isBLANK  = (iTopL == `PT_BLANK);
        TL_isWATER  = (iTopL == `PT_WATER);
        TL_isSPOUT  = (iTopL == `PT_SPOUT);
        TL_wasFIRE1 = (iOldTL == `PT_FIRE1);
        TL_wasFIRE0 = (iOldTL == `PT_FIRE0);
        TL_wasTORCH = (iOldTL == `PT_TORCH);
        TL_wasPLANT = (iOldTL == `PT_PLANT);
        TL_wasHot   = TL_wasFIRE1 | TL_wasFIRE0 | TL_wasTORCH;
        
        // Top mid pixel
        TM_isBLANK  = (iTopM == `PT_BLANK);
        TM_isWATER  = (iTopM == `PT_WATER);
        TM_isSPOUT  = (iTopM == `PT_SPOUT);
        TM_wasFIRE1 = (iOldTM == `PT_FIRE1);
        TM_wasFIRE0 = (iOldTM == `PT_FIRE0);
        TM_wasTORCH = (iOldTM == `PT_TORCH);
        TM_wasPLANT = (iOldTM == `PT_PLANT);
        TM_wasHot   = TM_wasFIRE1 | TM_wasFIRE0 | TM_wasTORCH;
        
        // Top right pixel
        TR_isBLANK  = (iTopR == `PT_BLANK);
        TR_isWATER  = (iTopR == `PT_WATER);
        TR_isSPOUT  = (iTopR == `PT_SPOUT);
        TR_wasFIRE1 = (iOldTR == `PT_FIRE1);
        TR_wasFIRE0 = (iOldTR == `PT_FIRE0);
        TR_wasTORCH = (iOldTR == `PT_TORCH);
        TR_wasPLANT = (iOldTR == `PT_PLANT);
        TR_wasHot   = TR_wasFIRE1 | TR_wasFIRE0 | TR_wasTORCH;
        
        // Mid left pixel
        ML_isBLANK  = (iMidL == `PT_BLANK);
        ML_isWATER  = (iMidL == `PT_WATER);
        ML_isSAND   = (iMidL == `PT_SAND);
        ML_isSALT   = (iMidL == `PT_SALT);
        ML_isWALL   = (iMidL == `PT_WALL);
        ML_isWAX    = (iMidL == `PT_WAX);
        ML_isSPOUT  = (iMidL == `PT_SPOUT);
        ML_solid    = ML_isSAND | ML_isSALT | ML_isWALL | ML_isWAX | ML_wasPLANT;
        ML_wasFIRE1 = (iOldML == `PT_FIRE1);
        ML_wasFIRE0 = (iOldML == `PT_FIRE0);
        ML_wasTORCH = (iOldML == `PT_TORCH);
        ML_wasPLANT = (iOldML == `PT_PLANT);
        ML_wasHot   = ML_wasFIRE1 | ML_wasFIRE0 | ML_wasTORCH;
        
        // Mid mid pixel
        MM_isBLANK  = (iMidM == `PT_BLANK);
        MM_isWATER  = (iMidM == `PT_WATER);
        MM_isSAND   = (iMidM == `PT_SAND );
        MM_isOIL    = (iMidM == `PT_OIL);
        MM_isSALT   = (iMidM == `PT_SALT);
        MM_isCONC   = (iMidM == `PT_CONC);
        MM_isSALTW  = (iMidM == `PT_SALTW);
        MM_isWALL   = (iMidM == `PT_WALL);
        MM_insolu   = MM_isSAND  | MM_isSALTW | MM_isCONC;
        MM_mobile   = MM_isWATER | MM_isSAND | MM_isOIL | MM_isSALT | MM_isCONC | MM_isSALTW;
        MM_wasFIRE3 = (iOldMM == `PT_FIRE3);
        MM_wasFIRE2 = (iOldMM == `PT_FIRE2);
        MM_wasFIRE1 = (iOldMM == `PT_FIRE1);
        MM_wasFIRE0 = (iOldMM == `PT_FIRE0);
        MM_wasPLANT = (iOldMM == `PT_PLANT);
        MM_wasWAX   = (iOldMM == `PT_WAX);
        
        // Mid right pixel
        MR_isBLANK  = (iMidR == `PT_BLANK);
        MR_isWATER  = (iMidR == `PT_WATER);
        MR_isSAND   = (iMidR == `PT_SAND);
        MR_isSALT   = (iMidR == `PT_SALT);
        MR_isWALL   = (iMidR == `PT_WALL);
        MR_isWAX    = (iMidR == `PT_WAX);
        MR_isSPOUT  = (iMidR == `PT_SPOUT);
        MR_solid    = MR_isSAND | MR_isSALT | MR_isWALL | MR_isWAX | MR_wasPLANT;
        MR_wasFIRE1 = (iOldMR == `PT_FIRE1);
        MR_wasFIRE0 = (iOldMR == `PT_FIRE0);
        MR_wasTORCH = (iOldMR == `PT_TORCH);
        MR_wasPLANT = (iOldMR == `PT_PLANT);
        MR_wasHot   = MR_wasFIRE1 | MR_wasFIRE0 | MR_wasTORCH;
        
        // Bot left pixel
        BL_isBLANK  = (iBotL == `PT_BLANK);
        BL_isWATER  = (iBotL == `PT_WATER);
        BL_isSAND   = (iBotL == `PT_SAND);
        BL_isOIL    = (iBotL == `PT_OIL);
        BL_isSALT   = (iBotL == `PT_SALT);
        BL_isWALL   = (iBotL == `PT_WALL);
        BL_isWAX    = (iBotL == `PT_WAX);
        BL_isSPOUT  = (iBotL == `PT_SPOUT);
        BL_solid    = BL_isSAND | BL_isSALT | BL_isWALL | BL_isWAX | BL_wasPLANT;
        BL_wasFIRE1 = (iOldBL == `PT_FIRE1);
        BL_wasFIRE0 = (iOldBL == `PT_FIRE0);
        BL_wasTORCH = (iOldBL == `PT_TORCH);
        BL_wasPLANT = (iOldBL == `PT_PLANT);
        BL_wasHot   = BL_wasFIRE1 | BL_wasFIRE0 | BL_wasTORCH;
        
        // Bot mid pixel
        BM_isBLANK  = (iBotM == `PT_BLANK);
        BM_isWATER  = (iBotM == `PT_WATER);
        BM_isSAND   = (iBotM == `PT_SAND);
        BM_isOIL    = (iBotM == `PT_OIL);
        BM_isSALT   = (iBotM == `PT_SALT);
        BM_isWALL   = (iBotM == `PT_WALL);
        BM_isWAX    = (iBotM == `PT_WAX);
        BM_isSPOUT  = (iBotM == `PT_SPOUT);
        BM_solid    = BM_isSAND | BM_isSALT | BM_isWALL | BM_isWAX | BM_wasPLANT;
        BM_wasFIRE1 = (iOldBM == `PT_FIRE1);
        BM_wasFIRE0 = (iOldBM == `PT_FIRE0);
        BM_wasTORCH = (iOldBM == `PT_TORCH);
        BM_wasPLANT = (iOldBM == `PT_PLANT);
        BM_wasHot   = BM_wasFIRE1 | BM_wasFIRE0 | BM_wasTORCH;
        
        // Bot right pixel
        BR_isBLANK  = (iBotR == `PT_BLANK);
        BR_isWATER  = (iBotR == `PT_WATER);
        BR_isSAND   = (iBotR == `PT_SAND);
        BR_isOIL    = (iBotR == `PT_OIL);
        BR_isSALT   = (iBotR == `PT_SALT);
        BR_isWALL   = (iBotR == `PT_WALL);
        BR_isWAX    = (iBotR == `PT_WAX);
        BR_isSPOUT  = (iBotR == `PT_SPOUT);
        BR_solid    = BR_isSAND | BR_isSALT | BR_isWALL | BR_isWAX | BR_wasPLANT;
        BR_wasFIRE1 = (iOldBR == `PT_FIRE1);
        BR_wasFIRE0 = (iOldBR == `PT_FIRE0);
        BR_wasTORCH = (iOldBR == `PT_TORCH);
        BR_wasPLANT = (iOldBR == `PT_PLANT);
        BR_wasHot   = BR_wasFIRE1 | BR_wasFIRE0 | BR_wasTORCH;
        
        /**************************************************
         * Determine Properties of Neighborhood           *
         **************************************************/
        
        latNeighborHot  = TM_wasHot | ML_wasHot | MR_wasHot | BM_wasHot;
        diagNeighborHot = TL_wasHot | TR_wasHot | BL_wasHot | BR_wasHot;
        neighborWater   = TL_isWATER | TM_isWATER | TR_isWATER | ML_isWATER | MR_isWATER | BL_isWATER | BM_isWATER | BR_isWATER;
        latNeighborPlant = TM_wasPLANT | ML_wasPLANT | MR_wasPLANT | BM_wasPLANT;
        diagNeighborPlant = TL_wasPLANT | TR_wasPLANT | BL_wasPLANT | BR_wasPLANT;
        neighborSpout = TL_isSPOUT | TM_isSPOUT | TR_isSPOUT | ML_isSPOUT | MR_isSPOUT | BL_isSPOUT | BM_isSPOUT | BR_isSPOUT;
        neighborSolid = ML_solid | MR_solid | BL_solid | BM_solid | BR_solid;
        
        /**************************************************
         * Properties of Cursor                           *
         **************************************************/
        
        CC_isBLANK = (iCursorColor == `PT_BLANK);
        CC_wasFIRE0 = (iCursorColor == `PT_FIRE0);
        CC_wasTORCH = (iCursorColor == `PT_TORCH);
        
        // When drawing FIRE0, 1/4 chance of drawing blank
        // When drawing TORCH, 1/2 change of drawing blank
        drawnColor = (CC_wasFIRE0 & (iRand4[1:0] == 2'b0)) ? `PT_BLANK :
                     (CC_wasTORCH & (iRand4[0] == 1'b0))   ? `PT_BLANK :
                     iCursorColor;
        
        /**************************************************
         * Proximity Transforms                           *
         **************************************************/
        
        // Plants grow in a circular pattern in water - probability 1 of
        // propagating laterally, probability 0.25 of propagating diagonally.
        toPlant = MM_isWATER & (latNeighborPlant | (diagNeighborPlant && (iRand4[1:0] == 2'b0)));
        
        // Any salt that comes into contact with water becomes salt water.
        toSaltW = MM_isSALT & neighborWater;
        
        // Concrete becomes a wall with probability 0.5 when falling on something solid.
        toWall = MM_isCONC & neighborSolid & (iRand4 == 4'b0);
        
        // Wax becomes fire 3 when touching something hot. Fire propagates in a circular
        // pattern in wax, meaning probability 1 of lateral propagation and probability
        // 0.25 of diagonal propagation.
        toFire3 = MM_wasWAX & (latNeighborHot | (diagNeighborHot && (iRand4[1:0] == 2'b0)));
        
        // Fire 3 has a low probability of becoming fire 2. Plants also become fire 2
        // when touching something hot. When all lateral neighbors are plants, fire
        // propagates circularly. However, when at least one lateral neighbor isn't a
        // plant, the fire always spreads, so that plants that grew diagonally always
        // catch fire completely.
        toFire2 = (MM_wasFIRE3 & (iRand4 == 4'b0))
                   | (MM_wasPLANT & (latNeighborHot | (diagNeighborHot &
                       ((iRand4 == 4'b0) | ~TM_wasPLANT | ~ML_wasPLANT | ~MR_wasPLANT | ~BM_wasPLANT))));
        
        // Fire 2 becomes fire 1. Oil may also become fire 1 when touching something hot,
        // and the fire propagates circularly (lateral prob 1, diag prob 0.25). Fire 1 may
        // also appear in blank spaces above fire 0 to simulate fire rising, or above or
        // beside torches onto anything but walls.
        toFire1 = (MM_isOIL & (latNeighborHot | (diagNeighborHot && (iRand4[1:0] == 2'b0))))
                | (MM_isBLANK & BM_wasFIRE0 & (iRand4[1:0] != 2'b0))
                | (~MM_isWALL & (BM_wasTORCH | ML_wasTORCH | MR_wasTORCH) & (iRand4[1:0] != 2'b0))
                | MM_wasFIRE2;
        
        // Fire 1 may become fire 0 with probability 0.5.
        toFire0 = MM_wasFIRE1 && (iRand4[0] == 1'b0);
        
        // Fire 0 disappears and becomes blank. Water, when in contact with something hot,
        // evaporates and becomes blank.
        toBlank = MM_wasFIRE0
                | (MM_isWATER & (latNeighborHot | (diagNeighborHot && (iRand4[1:0] == 2'b0))));
        
        // Detect any proximity transforms. Includes all the above, as well as when drawing
        // blank or fire, which will be needed to override falling behavior.
        proxTrans = (iCursorDraw & (CC_isBLANK | CC_wasFIRE0))
                  | toPlant | toSaltW | toWall | toFire3 | toFire2 | toFire1 | toFire0 | toBlank;
        
        // These are transitions that are like drawing over a space. They introduce more
        // particles into the system than there were before.
        
        // Faucets at the top of the screen inject a pixel each cycle to the spaces
        // below them.
        fauceted = iFaucetPix;
        
        // Spouts randomly inject water into the blank spaces around them.
        spouted = MM_isBLANK && neighborSpout && (iRand4 == 4'b0);
        
        // When the troll flames the screen, it randomly injects fire 3 into all spaces.
        trolled = iTrollFlame & (iRand4 == 4'b0);
        
        /**************************************************
         * Possible Movements of Center Particle          *
         **************************************************/
        
        // Pressure to shift if there's a non-blank space to the side, above, or below
        sftPresL = ~MR_isBLANK | ~TR_isBLANK | ~BR_isBLANK | ~BM_isBLANK | ~TM_isBLANK;
        sftPresR = ~ML_isBLANK | ~TL_isBLANK | ~BL_isBLANK | ~BM_isBLANK | ~TM_isBLANK;
        
        // Can shift if there's no proximity transform, the side space is blank, and there's shift pressure
        canShftL = ~proxTrans & sftPresL & (MM_mobile  & ML_isBLANK);
        canShftR = ~proxTrans & sftPresR & (MM_mobile  & MR_isBLANK);
        
        // Can fall if there's no proximity transform, and the space into which the particle would fall
        // is something the center particle can actually fall into. For things falling into water or oil,
        // there is only a 1/2 probability of being able to fall, to mimic water resistance.
        canFallM = ~proxTrans &
                        ( (MM_mobile  & BM_isBLANK) |
                          (MM_insolu  & BM_isWATER & (iRand4[3] == 1'b0)) |
                          (MM_isWATER & BM_isOIL   & (iRand4[3] == 1'b0)));
        canFallL = ~proxTrans & sftPresL &
                        ( (MM_mobile  & BL_isBLANK) |
                          (MM_insolu  & BL_isWATER & (iRand4[3] == 1'b0)) |
                          (MM_isWATER & BL_isOIL   & (iRand4[3] == 1'b0)));
        canFallR = ~proxTrans & sftPresR &
                        ( (MM_mobile  & BR_isBLANK) |
                          (MM_insolu  & BR_isWATER & (iRand4[3] == 1'b0)) |
                          (MM_isWATER & BR_isOIL   & (iRand4[3] == 1'b0)));
        
        /**************************************************
         * Actual Movements of Center Particle            *
         **************************************************/
        
        // Based on which of the five shift/fall movements are possible,
        // choose one at random that the particle actually performs.
        
        if(canFallM & canFallL & canFallR) begin
            // Possible to fall in any direction. Probability favors
            // falling straight down, but 1/16 chance of falling left
            // and 1/16 chance of falling right.
            shftL = 1'b0;
            shftR = 1'b0;
            fallM = ~fallL & ~fallR;
            fallL = (iRand4[3:0] == 4'b0000);
            fallR = (iRand4[3:0] == 4'b0001);
        end
        else if(canFallM & canFallL & ~canFallR) begin
            // Can fall down or left. Probability favors falling straight
            // down, but 1/16 chance of falling left.
            shftL = 1'b0;
            shftR = 1'b0;
            fallM = ~fallL & ~fallR;
            fallL = (iRand4[3:0] == 4'b0000);
            fallR = 1'b0;
        end
        else if(canFallM & ~canFallL & canFallR) begin
            // Can fall down or right. Probability favors falling straight
            // down, but 1/16 chance of falling right.
            shftL = 1'b0;
            shftR = 1'b0;
            fallM = ~fallL & ~fallR;
            fallL = 1'b0;
            fallR = (iRand4[3:0] == 4'b0001);
        end
        else if(canFallM & ~canFallL & ~canFallR) begin
            // Can only fall down. Do so with high probability, although
            // leave the possibility of not falling to avoid cases where
            // a bunch of diagonal particles all fall straight down with
            // nothing interesting happening.
            shftL = 1'b0;
            shftR = 1'b0;
            fallM = (iRand4[3:0] != 4'b0);
            fallL = 1'b0;
            fallR = 1'b0;
        end
        else if(~canFallM & canFallL & canFallR) begin
            // Can fall left or right. Half chance of choosing either.
            shftL = 1'b0;
            shftR = 1'b0;
            fallM = 1'b0;
            fallL = (iRand4[0] == 1'b0);
            fallR = (iRand4[0] == 1'b1);
        end
        else if(~canFallM & canFallL & ~canFallR) begin
            // Can only fall left, so do so.
            shftL = 1'b0;
            shftR = 1'b0;
            fallM = 1'b0;
            fallL = 1'b1;
            fallR = 1'b0;
        end
        else if(~canFallM & ~canFallL & canFallR) begin
            // Can only fall right, so do so.
            shftL = 1'b0;
            shftR = 1'b0;
            fallM = 1'b0;
            fallL = 1'b0;
            fallR = 1'b1;
        end
        else begin
            // Can't fall. Might be able to shift.
            if(canShftL & canShftR) begin
                // Can shift either way, so half chance of either.
                shftL = (iRand4[0] == 1'b0);
                shftR = (iRand4[0] == 1'b1);
                fallM = 1'b0;
                fallL = 1'b0;
                fallR = 1'b0;
            end
            else if(canShftL & ~canShftR) begin
                // Can shift left, so do so.
                shftL = 1'b1;
                shftR = 1'b0;
                fallM = 1'b0;
                fallL = 1'b0;
                fallR = 1'b0;
            end
            else if(~canShftL & canShftR) begin
                // Can shift right, so do so.
                shftL = 1'b0;
                shftR = 1'b1;
                fallM = 1'b0;
                fallL = 1'b0;
                fallR = 1'b0;
            end
            else begin
                // Can't fall, can't shift - stay put.
                shftL = 1'b0;
                shftR = 1'b0;
                fallM = 1'b0;
                fallL = 1'b0;
                fallR = 1'b0;
            end
        end
        
        /**************************************************
         * Final Action                                   *
         **************************************************/
        
        if(iRESET | iSTALL | ~iValidPix) begin
            // Halt all movement when reseting, pausing, or if not on-screen.
            nTopL = iTopL;
            nTopM = iTopM;
            nTopR = iTopR;
            nMidL = iMidL;
            nMidM = iMidM;
            nMidR = iMidR;
            nBotL = iBotL;
            nBotM = iBotM;
            nBotR = iBotR;
        end
        else if(shftL) begin
            // Shift left, swapping center pixel with left one.
            nTopL = iTopL;
            nTopM = iTopM;
            nTopR = iTopR;
            nMidL = iMidM;
            nMidM = iMidL;
            nMidR = iMidR;
            nBotL = iBotL;
            nBotM = iBotM;
            nBotR = iBotR;
        end
        else if(shftR) begin
            // Shift right, swapping center pixel with right one.
            nTopL = iTopL;
            nTopM = iTopM;
            nTopR = iTopR;
            nMidL = iMidL;
            nMidM = iMidR;
            nMidR = iMidM;
            nBotL = iBotL;
            nBotM = iBotM;
            nBotR = iBotR;
        end
        else if(fallM) begin
            // Fall straight down, swapping center pixel with bottom mid one.
            nTopL = iTopL;
            nTopM = iTopM;
            nTopR = iTopR;
            nMidL = iMidL;
            nMidM = iBotM;
            nMidR = iMidR;
            nBotL = iBotL;
            nBotM = iMidM;
            nBotR = iBotR;
        end
        else if(fallL) begin
            // Fall left, swapping center pixel with bottom left one.
            nTopL = iTopL;
            nTopM = iTopM;
            nTopR = iTopR;
            nMidL = iMidL;
            nMidM = iBotL;
            nMidR = iMidR;
            nBotL = iMidM;
            nBotM = iBotM;
            nBotR = iBotR;
        end
        else if(fallR) begin
            // Fall right, swapping center pixel with bottom right one.
            nTopL = iTopL;
            nTopM = iTopM;
            nTopR = iTopR;
            nMidL = iMidL;
            nMidM = iBotR;
            nMidR = iMidR;
            nBotL = iBotL;
            nBotM = iBotM;
            nBotR = iMidM;
        end
        else begin
            // Do not shift or fall - stay put.
            nTopL = iTopL;
            nTopM = iTopM;
            nTopR = iTopR;
            nMidL = iMidL;
            nMidM = iMidM;
            nMidR = iMidR;
            nBotL = iBotL;
            nBotM = iBotM;
            nBotR = iBotR;
        end
    end
    
    assign oTopL = nTopL;
    assign oTopM = nTopM;
    assign oTopR = nTopR;
    assign oMidL = nMidL;
    assign oMidM = iRESET      ? iCursorColor : // When reseting, fill screen with cursor color.
                   ~iValidPix  ? `PT_BLANK    : // When pixel off-screen, just make it blank.
                   iCursorDraw ? drawnColor   : // When drawing, fill center pixel with drawn color.
                   iSTALL      ? nMidM        : // When stalling, do not update center pixel.
                   fauceted    ? iFaucetType  : // When under faucet, become that faucet's output.
                   trolled     ? `PT_FIRE3    : // When flamed by the troll, become fire 3.
                   spouted     ? `PT_WATER    : // When next to spout, become water.
                   toPlant     ? `PT_PLANT    : // Become plant.
                   toSaltW     ? `PT_SALTW    : // Become salt water.
                   toWall      ? `PT_WALL     : // Become wall.
                   toFire3     ? `PT_FIRE3    : // Become fire 3.
                   toFire2     ? `PT_FIRE2    : // Become fire 2.
                   toFire1     ? `PT_FIRE1    : // Become fire 1.
                   toFire0     ? `PT_FIRE0    : // Become fire 0.
                   toBlank     ? `PT_BLANK    : // Become blank.
                   nMidM; // No proximity transform, so become what was intended by movement.
    assign oMidR = nMidR;
    assign oBotL = nBotL;
    assign oBotM = nBotM;
    assign oBotR = nBotR;
    
endmodule
