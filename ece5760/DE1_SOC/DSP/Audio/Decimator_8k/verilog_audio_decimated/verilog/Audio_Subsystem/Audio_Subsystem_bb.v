
module Audio_Subsystem (
	audio_ADCDAT,
	audio_ADCLRCK,
	audio_BCLK,
	audio_DACDAT,
	audio_DACLRCK,
	audio_clk_clk,
	audio_irq_irq,
	audio_pll_ref_clk_clk,
	audio_pll_ref_reset_reset,
	audio_reset_reset,
	audio_slave_address,
	audio_slave_chipselect,
	audio_slave_read,
	audio_slave_write,
	audio_slave_writedata,
	audio_slave_readdata,
	sys_clk_clk,
	sys_reset_reset_n);	

	input		audio_ADCDAT;
	input		audio_ADCLRCK;
	input		audio_BCLK;
	output		audio_DACDAT;
	input		audio_DACLRCK;
	output		audio_clk_clk;
	output		audio_irq_irq;
	input		audio_pll_ref_clk_clk;
	input		audio_pll_ref_reset_reset;
	output		audio_reset_reset;
	input	[1:0]	audio_slave_address;
	input		audio_slave_chipselect;
	input		audio_slave_read;
	input		audio_slave_write;
	input	[31:0]	audio_slave_writedata;
	output	[31:0]	audio_slave_readdata;
	input		sys_clk_clk;
	input		sys_reset_reset_n;
endmodule
