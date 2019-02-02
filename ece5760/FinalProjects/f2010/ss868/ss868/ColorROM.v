/****************************************************************
 * Skyler Schneider ss868                                       *
 * ECE 5760 Final Project                                       *
 * Sand Game                                                    *
 ****************************************************************/

`include "project_params.h"

// Produces color value for each possible particle type.
module ColorROM (
    input             iCLK,  // Clock signal for reading
    input      [3:0]  iAddr, // Pixel type for ROM lookup
    output reg [23:0] oData  // 24-bit RGB color value from ROM
);
    
    always @(posedge iCLK) begin
        case(iAddr)
            `PT_BLANK: oData <= {8'd0   , 8'd0   , 8'd0   }; // Blank
            `PT_FIRE3: oData <= {8'd255 , 8'd64  , 8'd64  }; // Fire 3
            `PT_FIRE2: oData <= {8'd255 , 8'd64  , 8'd64  }; // Fire 2
            `PT_FIRE1: oData <= {8'd255 , 8'd64  , 8'd64  }; // Fire 1
            `PT_FIRE0: oData <= {8'd255 , 8'd64  , 8'd64  }; // Fire 0
            `PT_TORCH: oData <= {8'd245 , 8'd75  , 8'd15  }; // Torch
            `PT_WATER: oData <= {8'd32  , 8'd32  , 8'd255 }; // Water
            `PT_SAND : oData <= {8'd238 , 8'd204 , 8'd128 }; // Sand
            `PT_OIL  : oData <= {8'd128 , 8'd64  , 8'd64  }; // Oil
            `PT_SALT : oData <= {8'd200 , 8'd200 , 8'd200 }; // Salt
            `PT_CONC : oData <= {8'd139 , 8'd162 , 8'd162 }; // Concrete
            `PT_SALTW: oData <= {8'd64  , 8'd128 , 8'd255 }; // Salt Water
            `PT_WALL : oData <= {8'd128 , 8'd128 , 8'd128 }; // Wall
            `PT_PLANT: oData <= {8'd32  , 8'd204 , 8'd32  }; // Plant
            `PT_WAX  : oData <= {8'd255 , 8'd255 , 8'd64  }; // Wax
            `PT_SPOUT: oData <= {8'd112 , 8'd160 , 8'd255 }; // Spout
        endcase
    end
endmodule
