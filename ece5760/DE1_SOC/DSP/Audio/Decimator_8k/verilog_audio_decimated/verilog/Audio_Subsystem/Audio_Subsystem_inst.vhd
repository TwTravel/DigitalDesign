	component Audio_Subsystem is
		port (
			audio_ADCDAT              : in  std_logic                     := 'X';             -- ADCDAT
			audio_ADCLRCK             : in  std_logic                     := 'X';             -- ADCLRCK
			audio_BCLK                : in  std_logic                     := 'X';             -- BCLK
			audio_DACDAT              : out std_logic;                                        -- DACDAT
			audio_DACLRCK             : in  std_logic                     := 'X';             -- DACLRCK
			audio_clk_clk             : out std_logic;                                        -- clk
			audio_irq_irq             : out std_logic;                                        -- irq
			audio_pll_ref_clk_clk     : in  std_logic                     := 'X';             -- clk
			audio_pll_ref_reset_reset : in  std_logic                     := 'X';             -- reset
			audio_reset_reset         : out std_logic;                                        -- reset
			audio_slave_address       : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- address
			audio_slave_chipselect    : in  std_logic                     := 'X';             -- chipselect
			audio_slave_read          : in  std_logic                     := 'X';             -- read
			audio_slave_write         : in  std_logic                     := 'X';             -- write
			audio_slave_writedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			audio_slave_readdata      : out std_logic_vector(31 downto 0);                    -- readdata
			sys_clk_clk               : in  std_logic                     := 'X';             -- clk
			sys_reset_reset_n         : in  std_logic                     := 'X'              -- reset_n
		);
	end component Audio_Subsystem;

	u0 : component Audio_Subsystem
		port map (
			audio_ADCDAT              => CONNECTED_TO_audio_ADCDAT,              --               audio.ADCDAT
			audio_ADCLRCK             => CONNECTED_TO_audio_ADCLRCK,             --                    .ADCLRCK
			audio_BCLK                => CONNECTED_TO_audio_BCLK,                --                    .BCLK
			audio_DACDAT              => CONNECTED_TO_audio_DACDAT,              --                    .DACDAT
			audio_DACLRCK             => CONNECTED_TO_audio_DACLRCK,             --                    .DACLRCK
			audio_clk_clk             => CONNECTED_TO_audio_clk_clk,             --           audio_clk.clk
			audio_irq_irq             => CONNECTED_TO_audio_irq_irq,             --           audio_irq.irq
			audio_pll_ref_clk_clk     => CONNECTED_TO_audio_pll_ref_clk_clk,     --   audio_pll_ref_clk.clk
			audio_pll_ref_reset_reset => CONNECTED_TO_audio_pll_ref_reset_reset, -- audio_pll_ref_reset.reset
			audio_reset_reset         => CONNECTED_TO_audio_reset_reset,         --         audio_reset.reset
			audio_slave_address       => CONNECTED_TO_audio_slave_address,       --         audio_slave.address
			audio_slave_chipselect    => CONNECTED_TO_audio_slave_chipselect,    --                    .chipselect
			audio_slave_read          => CONNECTED_TO_audio_slave_read,          --                    .read
			audio_slave_write         => CONNECTED_TO_audio_slave_write,         --                    .write
			audio_slave_writedata     => CONNECTED_TO_audio_slave_writedata,     --                    .writedata
			audio_slave_readdata      => CONNECTED_TO_audio_slave_readdata,      --                    .readdata
			sys_clk_clk               => CONNECTED_TO_sys_clk_clk,               --             sys_clk.clk
			sys_reset_reset_n         => CONNECTED_TO_sys_reset_reset_n          --           sys_reset.reset_n
		);

