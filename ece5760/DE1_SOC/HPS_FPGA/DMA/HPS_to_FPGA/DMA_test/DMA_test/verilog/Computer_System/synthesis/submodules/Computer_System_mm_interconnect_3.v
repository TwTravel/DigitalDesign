// Computer_System_mm_interconnect_3.v

// This file was auto-generated from altera_mm_interconnect_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 15.0 145

`timescale 1 ps / 1 ps
module Computer_System_mm_interconnect_3 (
		input  wire        System_PLL_sys_clk_clk,                  //                System_PLL_sys_clk.clk
		input  wire        dma_0_reset_reset_bridge_in_reset_reset, // dma_0_reset_reset_bridge_in_reset.reset
		input  wire [27:0] dma_0_write_master_address,              //                dma_0_write_master.address
		output wire        dma_0_write_master_waitrequest,          //                                  .waitrequest
		input  wire [3:0]  dma_0_write_master_byteenable,           //                                  .byteenable
		input  wire        dma_0_write_master_chipselect,           //                                  .chipselect
		input  wire        dma_0_write_master_write,                //                                  .write
		input  wire [31:0] dma_0_write_master_writedata,            //                                  .writedata
		output wire [13:0] Onchip_SRAM_s1_address,                  //                    Onchip_SRAM_s1.address
		output wire        Onchip_SRAM_s1_write,                    //                                  .write
		input  wire [31:0] Onchip_SRAM_s1_readdata,                 //                                  .readdata
		output wire [31:0] Onchip_SRAM_s1_writedata,                //                                  .writedata
		output wire [3:0]  Onchip_SRAM_s1_byteenable,               //                                  .byteenable
		output wire        Onchip_SRAM_s1_chipselect,               //                                  .chipselect
		output wire        Onchip_SRAM_s1_clken                     //                                  .clken
	);

	wire         dma_0_write_master_translator_avalon_universal_master_0_waitrequest;   // Onchip_SRAM_s1_translator:uav_waitrequest -> dma_0_write_master_translator:uav_waitrequest
	wire  [31:0] dma_0_write_master_translator_avalon_universal_master_0_readdata;      // Onchip_SRAM_s1_translator:uav_readdata -> dma_0_write_master_translator:uav_readdata
	wire         dma_0_write_master_translator_avalon_universal_master_0_debugaccess;   // dma_0_write_master_translator:uav_debugaccess -> Onchip_SRAM_s1_translator:uav_debugaccess
	wire  [27:0] dma_0_write_master_translator_avalon_universal_master_0_address;       // dma_0_write_master_translator:uav_address -> Onchip_SRAM_s1_translator:uav_address
	wire         dma_0_write_master_translator_avalon_universal_master_0_read;          // dma_0_write_master_translator:uav_read -> Onchip_SRAM_s1_translator:uav_read
	wire   [3:0] dma_0_write_master_translator_avalon_universal_master_0_byteenable;    // dma_0_write_master_translator:uav_byteenable -> Onchip_SRAM_s1_translator:uav_byteenable
	wire         dma_0_write_master_translator_avalon_universal_master_0_readdatavalid; // Onchip_SRAM_s1_translator:uav_readdatavalid -> dma_0_write_master_translator:uav_readdatavalid
	wire         dma_0_write_master_translator_avalon_universal_master_0_lock;          // dma_0_write_master_translator:uav_lock -> Onchip_SRAM_s1_translator:uav_lock
	wire         dma_0_write_master_translator_avalon_universal_master_0_write;         // dma_0_write_master_translator:uav_write -> Onchip_SRAM_s1_translator:uav_write
	wire  [31:0] dma_0_write_master_translator_avalon_universal_master_0_writedata;     // dma_0_write_master_translator:uav_writedata -> Onchip_SRAM_s1_translator:uav_writedata
	wire   [2:0] dma_0_write_master_translator_avalon_universal_master_0_burstcount;    // dma_0_write_master_translator:uav_burstcount -> Onchip_SRAM_s1_translator:uav_burstcount

	altera_merlin_master_translator #(
		.AV_ADDRESS_W                (28),
		.AV_DATA_W                   (32),
		.AV_BURSTCOUNT_W             (1),
		.AV_BYTEENABLE_W             (4),
		.UAV_ADDRESS_W               (28),
		.UAV_BURSTCOUNT_W            (3),
		.USE_READ                    (0),
		.USE_WRITE                   (1),
		.USE_BEGINBURSTTRANSFER      (0),
		.USE_BEGINTRANSFER           (0),
		.USE_CHIPSELECT              (1),
		.USE_BURSTCOUNT              (0),
		.USE_READDATAVALID           (0),
		.USE_WAITREQUEST             (1),
		.USE_READRESPONSE            (0),
		.USE_WRITERESPONSE           (0),
		.AV_SYMBOLS_PER_WORD         (4),
		.AV_ADDRESS_SYMBOLS          (1),
		.AV_BURSTCOUNT_SYMBOLS       (0),
		.AV_CONSTANT_BURST_BEHAVIOR  (0),
		.UAV_CONSTANT_BURST_BEHAVIOR (0),
		.AV_LINEWRAPBURSTS           (0),
		.AV_REGISTERINCOMINGSIGNALS  (0)
	) dma_0_write_master_translator (
		.clk                    (System_PLL_sys_clk_clk),                                                //                       clk.clk
		.reset                  (dma_0_reset_reset_bridge_in_reset_reset),                               //                     reset.reset
		.uav_address            (dma_0_write_master_translator_avalon_universal_master_0_address),       // avalon_universal_master_0.address
		.uav_burstcount         (dma_0_write_master_translator_avalon_universal_master_0_burstcount),    //                          .burstcount
		.uav_read               (dma_0_write_master_translator_avalon_universal_master_0_read),          //                          .read
		.uav_write              (dma_0_write_master_translator_avalon_universal_master_0_write),         //                          .write
		.uav_waitrequest        (dma_0_write_master_translator_avalon_universal_master_0_waitrequest),   //                          .waitrequest
		.uav_readdatavalid      (dma_0_write_master_translator_avalon_universal_master_0_readdatavalid), //                          .readdatavalid
		.uav_byteenable         (dma_0_write_master_translator_avalon_universal_master_0_byteenable),    //                          .byteenable
		.uav_readdata           (dma_0_write_master_translator_avalon_universal_master_0_readdata),      //                          .readdata
		.uav_writedata          (dma_0_write_master_translator_avalon_universal_master_0_writedata),     //                          .writedata
		.uav_lock               (dma_0_write_master_translator_avalon_universal_master_0_lock),          //                          .lock
		.uav_debugaccess        (dma_0_write_master_translator_avalon_universal_master_0_debugaccess),   //                          .debugaccess
		.av_address             (dma_0_write_master_address),                                            //      avalon_anti_master_0.address
		.av_waitrequest         (dma_0_write_master_waitrequest),                                        //                          .waitrequest
		.av_byteenable          (dma_0_write_master_byteenable),                                         //                          .byteenable
		.av_chipselect          (dma_0_write_master_chipselect),                                         //                          .chipselect
		.av_write               (dma_0_write_master_write),                                              //                          .write
		.av_writedata           (dma_0_write_master_writedata),                                          //                          .writedata
		.av_burstcount          (1'b1),                                                                  //               (terminated)
		.av_beginbursttransfer  (1'b0),                                                                  //               (terminated)
		.av_begintransfer       (1'b0),                                                                  //               (terminated)
		.av_read                (1'b0),                                                                  //               (terminated)
		.av_readdata            (),                                                                      //               (terminated)
		.av_readdatavalid       (),                                                                      //               (terminated)
		.av_lock                (1'b0),                                                                  //               (terminated)
		.av_debugaccess         (1'b0),                                                                  //               (terminated)
		.uav_clken              (),                                                                      //               (terminated)
		.av_clken               (1'b1),                                                                  //               (terminated)
		.uav_response           (2'b00),                                                                 //               (terminated)
		.av_response            (),                                                                      //               (terminated)
		.uav_writeresponsevalid (1'b0),                                                                  //               (terminated)
		.av_writeresponsevalid  ()                                                                       //               (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (14),
		.AV_DATA_W                      (32),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (4),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (28),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (1),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.USE_READRESPONSE               (0),
		.USE_WRITERESPONSE              (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (0),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) onchip_sram_s1_translator (
		.clk                    (System_PLL_sys_clk_clk),                                                //                      clk.clk
		.reset                  (dma_0_reset_reset_bridge_in_reset_reset),                               //                    reset.reset
		.uav_address            (dma_0_write_master_translator_avalon_universal_master_0_address),       // avalon_universal_slave_0.address
		.uav_burstcount         (dma_0_write_master_translator_avalon_universal_master_0_burstcount),    //                         .burstcount
		.uav_read               (dma_0_write_master_translator_avalon_universal_master_0_read),          //                         .read
		.uav_write              (dma_0_write_master_translator_avalon_universal_master_0_write),         //                         .write
		.uav_waitrequest        (dma_0_write_master_translator_avalon_universal_master_0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid      (dma_0_write_master_translator_avalon_universal_master_0_readdatavalid), //                         .readdatavalid
		.uav_byteenable         (dma_0_write_master_translator_avalon_universal_master_0_byteenable),    //                         .byteenable
		.uav_readdata           (dma_0_write_master_translator_avalon_universal_master_0_readdata),      //                         .readdata
		.uav_writedata          (dma_0_write_master_translator_avalon_universal_master_0_writedata),     //                         .writedata
		.uav_lock               (dma_0_write_master_translator_avalon_universal_master_0_lock),          //                         .lock
		.uav_debugaccess        (dma_0_write_master_translator_avalon_universal_master_0_debugaccess),   //                         .debugaccess
		.av_address             (Onchip_SRAM_s1_address),                                                //      avalon_anti_slave_0.address
		.av_write               (Onchip_SRAM_s1_write),                                                  //                         .write
		.av_readdata            (Onchip_SRAM_s1_readdata),                                               //                         .readdata
		.av_writedata           (Onchip_SRAM_s1_writedata),                                              //                         .writedata
		.av_byteenable          (Onchip_SRAM_s1_byteenable),                                             //                         .byteenable
		.av_chipselect          (Onchip_SRAM_s1_chipselect),                                             //                         .chipselect
		.av_clken               (Onchip_SRAM_s1_clken),                                                  //                         .clken
		.av_read                (),                                                                      //              (terminated)
		.av_begintransfer       (),                                                                      //              (terminated)
		.av_beginbursttransfer  (),                                                                      //              (terminated)
		.av_burstcount          (),                                                                      //              (terminated)
		.av_readdatavalid       (1'b0),                                                                  //              (terminated)
		.av_waitrequest         (1'b0),                                                                  //              (terminated)
		.av_writebyteenable     (),                                                                      //              (terminated)
		.av_lock                (),                                                                      //              (terminated)
		.uav_clken              (1'b0),                                                                  //              (terminated)
		.av_debugaccess         (),                                                                      //              (terminated)
		.av_outputenable        (),                                                                      //              (terminated)
		.uav_response           (),                                                                      //              (terminated)
		.av_response            (2'b00),                                                                 //              (terminated)
		.uav_writeresponsevalid (),                                                                      //              (terminated)
		.av_writeresponsevalid  (1'b0)                                                                   //              (terminated)
	);

endmodule
