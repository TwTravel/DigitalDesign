	component Computer_System is
		port (
			adc_sclk                   : out   std_logic;                                        -- sclk
			adc_cs_n                   : out   std_logic;                                        -- cs_n
			adc_dout                   : in    std_logic                     := 'X';             -- dout
			adc_din                    : out   std_logic;                                        -- din
			audio_ADCDAT               : in    std_logic                     := 'X';             -- ADCDAT
			audio_ADCLRCK              : in    std_logic                     := 'X';             -- ADCLRCK
			audio_BCLK                 : in    std_logic                     := 'X';             -- BCLK
			audio_DACDAT               : out   std_logic;                                        -- DACDAT
			audio_DACLRCK              : in    std_logic                     := 'X';             -- DACLRCK
			audio_clk_clk              : out   std_logic;                                        -- clk
			audio_pll_ref_clk_clk      : in    std_logic                     := 'X';             -- clk
			audio_pll_ref_reset_reset  : in    std_logic                     := 'X';             -- reset
			av_config_SDAT             : inout std_logic                     := 'X';             -- SDAT
			av_config_SCLK             : out   std_logic;                                        -- SCLK
			expansion_jp1_export       : inout std_logic_vector(31 downto 0) := (others => 'X'); -- export
			expansion_jp2_export       : inout std_logic_vector(31 downto 0) := (others => 'X'); -- export
			hex3_hex0_export           : out   std_logic_vector(31 downto 0);                    -- export
			hex5_hex4_export           : out   std_logic_vector(15 downto 0);                    -- export
			irda_TXD                   : out   std_logic;                                        -- TXD
			irda_RXD                   : in    std_logic                     := 'X';             -- RXD
			leds_export                : out   std_logic_vector(9 downto 0);                     -- export
			ps2_port_CLK               : inout std_logic                     := 'X';             -- CLK
			ps2_port_DAT               : inout std_logic                     := 'X';             -- DAT
			ps2_port_dual_CLK          : inout std_logic                     := 'X';             -- CLK
			ps2_port_dual_DAT          : inout std_logic                     := 'X';             -- DAT
			pushbuttons_export         : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			sdram_addr                 : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba                   : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n                : out   std_logic;                                        -- cas_n
			sdram_cke                  : out   std_logic;                                        -- cke
			sdram_cs_n                 : out   std_logic;                                        -- cs_n
			sdram_dq                   : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_dqm                  : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_ras_n                : out   std_logic;                                        -- ras_n
			sdram_we_n                 : out   std_logic;                                        -- we_n
			sdram_clk_clk              : out   std_logic;                                        -- clk
			slider_switches_export     : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			system_pll_ref_clk_clk     : in    std_logic                     := 'X';             -- clk
			system_pll_ref_reset_reset : in    std_logic                     := 'X';             -- reset
			vga_CLK                    : out   std_logic;                                        -- CLK
			vga_HS                     : out   std_logic;                                        -- HS
			vga_VS                     : out   std_logic;                                        -- VS
			vga_BLANK                  : out   std_logic;                                        -- BLANK
			vga_SYNC                   : out   std_logic;                                        -- SYNC
			vga_R                      : out   std_logic_vector(7 downto 0);                     -- R
			vga_G                      : out   std_logic_vector(7 downto 0);                     -- G
			vga_B                      : out   std_logic_vector(7 downto 0);                     -- B
			vga_pll_ref_clk_clk        : in    std_logic                     := 'X';             -- clk
			vga_pll_ref_reset_reset    : in    std_logic                     := 'X';             -- reset
			video_in_TD_CLK27          : in    std_logic                     := 'X';             -- TD_CLK27
			video_in_TD_DATA           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- TD_DATA
			video_in_TD_HS             : in    std_logic                     := 'X';             -- TD_HS
			video_in_TD_VS             : in    std_logic                     := 'X';             -- TD_VS
			video_in_clk27_reset       : in    std_logic                     := 'X';             -- clk27_reset
			video_in_TD_RESET          : out   std_logic;                                        -- TD_RESET
			video_in_overflow_flag     : out   std_logic                                         -- overflow_flag
		);
	end component Computer_System;

	u0 : component Computer_System
		port map (
			adc_sclk                   => CONNECTED_TO_adc_sclk,                   --                  adc.sclk
			adc_cs_n                   => CONNECTED_TO_adc_cs_n,                   --                     .cs_n
			adc_dout                   => CONNECTED_TO_adc_dout,                   --                     .dout
			adc_din                    => CONNECTED_TO_adc_din,                    --                     .din
			audio_ADCDAT               => CONNECTED_TO_audio_ADCDAT,               --                audio.ADCDAT
			audio_ADCLRCK              => CONNECTED_TO_audio_ADCLRCK,              --                     .ADCLRCK
			audio_BCLK                 => CONNECTED_TO_audio_BCLK,                 --                     .BCLK
			audio_DACDAT               => CONNECTED_TO_audio_DACDAT,               --                     .DACDAT
			audio_DACLRCK              => CONNECTED_TO_audio_DACLRCK,              --                     .DACLRCK
			audio_clk_clk              => CONNECTED_TO_audio_clk_clk,              --            audio_clk.clk
			audio_pll_ref_clk_clk      => CONNECTED_TO_audio_pll_ref_clk_clk,      --    audio_pll_ref_clk.clk
			audio_pll_ref_reset_reset  => CONNECTED_TO_audio_pll_ref_reset_reset,  --  audio_pll_ref_reset.reset
			av_config_SDAT             => CONNECTED_TO_av_config_SDAT,             --            av_config.SDAT
			av_config_SCLK             => CONNECTED_TO_av_config_SCLK,             --                     .SCLK
			expansion_jp1_export       => CONNECTED_TO_expansion_jp1_export,       --        expansion_jp1.export
			expansion_jp2_export       => CONNECTED_TO_expansion_jp2_export,       --        expansion_jp2.export
			hex3_hex0_export           => CONNECTED_TO_hex3_hex0_export,           --            hex3_hex0.export
			hex5_hex4_export           => CONNECTED_TO_hex5_hex4_export,           --            hex5_hex4.export
			irda_TXD                   => CONNECTED_TO_irda_TXD,                   --                 irda.TXD
			irda_RXD                   => CONNECTED_TO_irda_RXD,                   --                     .RXD
			leds_export                => CONNECTED_TO_leds_export,                --                 leds.export
			ps2_port_CLK               => CONNECTED_TO_ps2_port_CLK,               --             ps2_port.CLK
			ps2_port_DAT               => CONNECTED_TO_ps2_port_DAT,               --                     .DAT
			ps2_port_dual_CLK          => CONNECTED_TO_ps2_port_dual_CLK,          --        ps2_port_dual.CLK
			ps2_port_dual_DAT          => CONNECTED_TO_ps2_port_dual_DAT,          --                     .DAT
			pushbuttons_export         => CONNECTED_TO_pushbuttons_export,         --          pushbuttons.export
			sdram_addr                 => CONNECTED_TO_sdram_addr,                 --                sdram.addr
			sdram_ba                   => CONNECTED_TO_sdram_ba,                   --                     .ba
			sdram_cas_n                => CONNECTED_TO_sdram_cas_n,                --                     .cas_n
			sdram_cke                  => CONNECTED_TO_sdram_cke,                  --                     .cke
			sdram_cs_n                 => CONNECTED_TO_sdram_cs_n,                 --                     .cs_n
			sdram_dq                   => CONNECTED_TO_sdram_dq,                   --                     .dq
			sdram_dqm                  => CONNECTED_TO_sdram_dqm,                  --                     .dqm
			sdram_ras_n                => CONNECTED_TO_sdram_ras_n,                --                     .ras_n
			sdram_we_n                 => CONNECTED_TO_sdram_we_n,                 --                     .we_n
			sdram_clk_clk              => CONNECTED_TO_sdram_clk_clk,              --            sdram_clk.clk
			slider_switches_export     => CONNECTED_TO_slider_switches_export,     --      slider_switches.export
			system_pll_ref_clk_clk     => CONNECTED_TO_system_pll_ref_clk_clk,     --   system_pll_ref_clk.clk
			system_pll_ref_reset_reset => CONNECTED_TO_system_pll_ref_reset_reset, -- system_pll_ref_reset.reset
			vga_CLK                    => CONNECTED_TO_vga_CLK,                    --                  vga.CLK
			vga_HS                     => CONNECTED_TO_vga_HS,                     --                     .HS
			vga_VS                     => CONNECTED_TO_vga_VS,                     --                     .VS
			vga_BLANK                  => CONNECTED_TO_vga_BLANK,                  --                     .BLANK
			vga_SYNC                   => CONNECTED_TO_vga_SYNC,                   --                     .SYNC
			vga_R                      => CONNECTED_TO_vga_R,                      --                     .R
			vga_G                      => CONNECTED_TO_vga_G,                      --                     .G
			vga_B                      => CONNECTED_TO_vga_B,                      --                     .B
			vga_pll_ref_clk_clk        => CONNECTED_TO_vga_pll_ref_clk_clk,        --      vga_pll_ref_clk.clk
			vga_pll_ref_reset_reset    => CONNECTED_TO_vga_pll_ref_reset_reset,    --    vga_pll_ref_reset.reset
			video_in_TD_CLK27          => CONNECTED_TO_video_in_TD_CLK27,          --             video_in.TD_CLK27
			video_in_TD_DATA           => CONNECTED_TO_video_in_TD_DATA,           --                     .TD_DATA
			video_in_TD_HS             => CONNECTED_TO_video_in_TD_HS,             --                     .TD_HS
			video_in_TD_VS             => CONNECTED_TO_video_in_TD_VS,             --                     .TD_VS
			video_in_clk27_reset       => CONNECTED_TO_video_in_clk27_reset,       --                     .clk27_reset
			video_in_TD_RESET          => CONNECTED_TO_video_in_TD_RESET,          --                     .TD_RESET
			video_in_overflow_flag     => CONNECTED_TO_video_in_overflow_flag      --                     .overflow_flag
		);

