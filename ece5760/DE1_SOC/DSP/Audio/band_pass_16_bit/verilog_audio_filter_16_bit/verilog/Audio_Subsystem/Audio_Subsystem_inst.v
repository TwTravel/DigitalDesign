	Audio_Subsystem u0 (
		.audio_ADCDAT              (<connected-to-audio_ADCDAT>),              //               audio.ADCDAT
		.audio_ADCLRCK             (<connected-to-audio_ADCLRCK>),             //                    .ADCLRCK
		.audio_BCLK                (<connected-to-audio_BCLK>),                //                    .BCLK
		.audio_DACDAT              (<connected-to-audio_DACDAT>),              //                    .DACDAT
		.audio_DACLRCK             (<connected-to-audio_DACLRCK>),             //                    .DACLRCK
		.audio_clk_clk             (<connected-to-audio_clk_clk>),             //           audio_clk.clk
		.audio_irq_irq             (<connected-to-audio_irq_irq>),             //           audio_irq.irq
		.audio_pll_ref_clk_clk     (<connected-to-audio_pll_ref_clk_clk>),     //   audio_pll_ref_clk.clk
		.audio_pll_ref_reset_reset (<connected-to-audio_pll_ref_reset_reset>), // audio_pll_ref_reset.reset
		.audio_reset_reset         (<connected-to-audio_reset_reset>),         //         audio_reset.reset
		.audio_slave_address       (<connected-to-audio_slave_address>),       //         audio_slave.address
		.audio_slave_chipselect    (<connected-to-audio_slave_chipselect>),    //                    .chipselect
		.audio_slave_read          (<connected-to-audio_slave_read>),          //                    .read
		.audio_slave_write         (<connected-to-audio_slave_write>),         //                    .write
		.audio_slave_writedata     (<connected-to-audio_slave_writedata>),     //                    .writedata
		.audio_slave_readdata      (<connected-to-audio_slave_readdata>),      //                    .readdata
		.sys_clk_clk               (<connected-to-sys_clk_clk>),               //             sys_clk.clk
		.sys_reset_reset_n         (<connected-to-sys_reset_reset_n>)          //           sys_reset.reset_n
	);

