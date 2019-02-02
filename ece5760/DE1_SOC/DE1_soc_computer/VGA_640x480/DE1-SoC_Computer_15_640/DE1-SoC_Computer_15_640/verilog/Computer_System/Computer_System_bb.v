
module Computer_System (
	adc_sclk,
	adc_cs_n,
	adc_dout,
	adc_din,
	audio_ADCDAT,
	audio_ADCLRCK,
	audio_BCLK,
	audio_DACDAT,
	audio_DACLRCK,
	audio_clk_clk,
	audio_pll_ref_clk_clk,
	audio_pll_ref_reset_reset,
	av_config_SDAT,
	av_config_SCLK,
	expansion_jp1_export,
	expansion_jp2_export,
	hex3_hex0_export,
	hex5_hex4_export,
	irda_TXD,
	irda_RXD,
	leds_export,
	ps2_port_CLK,
	ps2_port_DAT,
	ps2_port_dual_CLK,
	ps2_port_dual_DAT,
	pushbuttons_export,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	sdram_clk_clk,
	slider_switches_export,
	system_pll_ref_clk_clk,
	system_pll_ref_reset_reset,
	vga_CLK,
	vga_HS,
	vga_VS,
	vga_BLANK,
	vga_SYNC,
	vga_R,
	vga_G,
	vga_B,
	vga_pll_ref_clk_clk,
	vga_pll_ref_reset_reset,
	video_in_TD_CLK27,
	video_in_TD_DATA,
	video_in_TD_HS,
	video_in_TD_VS,
	video_in_clk27_reset,
	video_in_TD_RESET,
	video_in_overflow_flag);	

	output		adc_sclk;
	output		adc_cs_n;
	input		adc_dout;
	output		adc_din;
	input		audio_ADCDAT;
	input		audio_ADCLRCK;
	input		audio_BCLK;
	output		audio_DACDAT;
	input		audio_DACLRCK;
	output		audio_clk_clk;
	input		audio_pll_ref_clk_clk;
	input		audio_pll_ref_reset_reset;
	inout		av_config_SDAT;
	output		av_config_SCLK;
	inout	[31:0]	expansion_jp1_export;
	inout	[31:0]	expansion_jp2_export;
	output	[31:0]	hex3_hex0_export;
	output	[15:0]	hex5_hex4_export;
	output		irda_TXD;
	input		irda_RXD;
	output	[9:0]	leds_export;
	inout		ps2_port_CLK;
	inout		ps2_port_DAT;
	inout		ps2_port_dual_CLK;
	inout		ps2_port_dual_DAT;
	input	[3:0]	pushbuttons_export;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[15:0]	sdram_dq;
	output	[1:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	output		sdram_clk_clk;
	input	[9:0]	slider_switches_export;
	input		system_pll_ref_clk_clk;
	input		system_pll_ref_reset_reset;
	output		vga_CLK;
	output		vga_HS;
	output		vga_VS;
	output		vga_BLANK;
	output		vga_SYNC;
	output	[7:0]	vga_R;
	output	[7:0]	vga_G;
	output	[7:0]	vga_B;
	input		vga_pll_ref_clk_clk;
	input		vga_pll_ref_reset_reset;
	input		video_in_TD_CLK27;
	input	[7:0]	video_in_TD_DATA;
	input		video_in_TD_HS;
	input		video_in_TD_VS;
	input		video_in_clk27_reset;
	output		video_in_TD_RESET;
	output		video_in_overflow_flag;
endmodule
