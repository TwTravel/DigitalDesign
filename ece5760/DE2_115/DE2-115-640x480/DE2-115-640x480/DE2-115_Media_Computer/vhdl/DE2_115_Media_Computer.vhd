
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DE2_115_Media_Computer is

-------------------------------------------------------------------------------
--							 Port Declarations							 --
-------------------------------------------------------------------------------
port (
	-- Inputs
	CLOCK_50			: in std_logic;
	TD_CLK27			: in std_logic;
	KEY				  	: in std_logic_vector (3 downto 0);
	SW				   	: in std_logic_vector (17 downto 0);

	--  Communication
	UART_RXD			: in std_logic;

	--  Audio
	AUD_ADCDAT			: in std_logic;

	--  IrDA
	IRDA_RXD				: in std_logic;
	
	--  Video In
	TD_DATA				: in std_logic_vector (7 downto 0);
	TD_HS					: in std_logic;
	TD_VS					: in std_logic;
	
	--  USB
	OTG_INT  				: in std_logic_vector (1 downto 0);
	
	-- Bidirectionals
	GPIO				: inout std_logic_vector (35 downto 0);

	--  Memory (SRAM)
	SRAM_DQ				: inout std_logic_vector (15 downto 0);
	
	-- Memory (SDRAM)
	DRAM_DQ				: inout std_logic_vector (31 downto 0);

	--  PS2 Port
	PS2_KBCLK			: inout std_logic;
	PS2_KBDAT			: inout std_logic;
	PS2_MSCLK			: inout std_logic;
	PS2_MSDAT			: inout std_logic;
	
	--  Audio
	AUD_BCLK			: inout std_logic;
	AUD_ADCLRCK			: inout std_logic;
	AUD_DACLRCK			: inout std_logic;
	
	--  Char LCD 16x2
	LCD_DATA			: inout std_logic_vector (7 downto 0);

	--  AV Config
	I2C_SDAT			: inout std_logic;
	
	--  Flash
	FL_DQ				: inout std_logic_vector (7 downto 0);
	
	--  SD Card
	SD_CMD				: inout std_logic;
	SD_DAT				: inout std_logic_vector (3 downto 0);
	
	--  USB
	OTG_DATA			: inout std_logic_vector (15 downto 0);
	
	-- Outputs
	TD_RESET_N			: out std_logic;
	
	--  Simple
	LEDG				: out std_logic_vector (8 downto 0);
	LEDR				: out std_logic_vector (17 downto 0);
	HEX0				: out std_logic_vector (6 downto 0);
	HEX1				: out std_logic_vector (6 downto 0);
	HEX2				: out std_logic_vector (6 downto 0);
	HEX3				: out std_logic_vector (6 downto 0);
	HEX4				: out std_logic_vector (6 downto 0);
	HEX5				: out std_logic_vector (6 downto 0);
	HEX6				: out std_logic_vector (6 downto 0);
	HEX7				: out std_logic_vector (6 downto 0);

	--  Memory (SRAM)
	SRAM_ADDR			: out std_logic_vector (19 downto 0);
	SRAM_CE_N			: out std_logic;
	SRAM_WE_N			: out std_logic;
	SRAM_OE_N			: out std_logic;
	SRAM_UB_N			: out std_logic;
	SRAM_LB_N			: out std_logic;

	--  Communication
	UART_TXD			: out std_logic;
	
	-- Memory (SDRAM)
	DRAM_ADDR			: out std_logic_vector (12 downto 0);
	DRAM_BA				: out std_logic_vector (1 downto 0);
	DRAM_CAS_N			: out std_logic;
	DRAM_RAS_N			: out std_logic;
	DRAM_CLK			: out std_logic;
	DRAM_CKE			: out std_logic;
	DRAM_CS_N			: out std_logic;
	DRAM_WE_N			: out std_logic;
	DRAM_DQM			: out std_logic_vector (3 downto 0);

	--  Audio
	AUD_XCK				: out std_logic;
	AUD_DACDAT			: out std_logic;
	
	--  VGA
	VGA_CLK				: out std_logic;
	VGA_HS				: out std_logic;
	VGA_VS				: out std_logic;
	VGA_BLANK_N			: out std_logic;
	VGA_SYNC_N			: out std_logic;
	VGA_R				: out std_logic_vector (7 downto 0);
	VGA_G				: out std_logic_vector (7 downto 0);
	VGA_B				: out std_logic_vector (7 downto 0);

	--  Char LCD 16x2
	LCD_ON				: out std_logic;
	LCD_BLON			: out std_logic;
	LCD_EN				: out std_logic;
	LCD_RS				: out std_logic;
	LCD_RW				: out std_logic;
	
	--  AV Config
	I2C_SCLK			: out std_logic;
	
	--  SD Card
	SD_CLK			: out std_logic;
	
	--  Flash
	FL_ADDR			: out std_logic_vector (22 downto 0);
	FL_CE_N			: out std_logic;
	FL_OE_N			: out std_logic;
	FL_RESET_N			: out std_logic;
	FL_WE_N			: out std_logic;
	
	-- USB
	OTG_ADDR			: out std_logic_vector (1 downto 0);
	OTG_CS_N			: out std_logic;
	OTG_OE_N			: out std_logic;
	OTG_RST_N		: out std_logic;
	OTG_WE_N			: out std_logic
		
	);
end DE2_115_Media_Computer;


architecture DE2_115_Media_Computer_rtl of DE2_115_Media_Computer is

-------------------------------------------------------------------------------
--						   Subentity Declarations						  --
-------------------------------------------------------------------------------
	component nios_system
		port (
              -- 1) global signals:
                 signal clk : IN STD_LOGIC;
                 signal clk_27 : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sys_clk : OUT STD_LOGIC;
                 signal vga_clk : OUT STD_LOGIC;
                 signal sdram_clk : OUT STD_LOGIC;
                 signal audio_clk : OUT STD_LOGIC;

              -- the_AV_Config
                 signal I2C_SCLK_from_the_AV_Config : OUT STD_LOGIC;
                 signal I2C_SDAT_to_and_from_the_AV_Config : INOUT STD_LOGIC;

              -- the_Audio
                 signal AUD_ADCDAT_to_the_Audio : IN STD_LOGIC;
                 signal AUD_ADCLRCK_to_the_Audio : INOUT STD_LOGIC;
                 signal AUD_BCLK_to_the_Audio : INOUT STD_LOGIC;
                 signal AUD_DACDAT_from_the_Audio : OUT STD_LOGIC;
                 signal AUD_DACLRCK_to_the_Audio : INOUT STD_LOGIC;

              -- the_Char_LCD_16x2
                 signal LCD_BLON_from_the_Char_LCD_16x2 : OUT STD_LOGIC;
                 signal LCD_DATA_to_and_from_the_Char_LCD_16x2 : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal LCD_EN_from_the_Char_LCD_16x2 : OUT STD_LOGIC;
                 signal LCD_ON_from_the_Char_LCD_16x2 : OUT STD_LOGIC;
                 signal LCD_RS_from_the_Char_LCD_16x2 : OUT STD_LOGIC;
                 signal LCD_RW_from_the_Char_LCD_16x2 : OUT STD_LOGIC;

              -- the_Expansion_JP5
                 signal GPIO_to_and_from_the_Expansion_JP5 : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_Green_LEDs
                 signal LEDG_from_the_Green_LEDs : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);

              -- the_HEX3_HEX0
                 signal HEX0_from_the_HEX3_HEX0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal HEX1_from_the_HEX3_HEX0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal HEX2_from_the_HEX3_HEX0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal HEX3_from_the_HEX3_HEX0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

              -- the_HEX7_HEX4
                 signal HEX4_from_the_HEX7_HEX4 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal HEX5_from_the_HEX7_HEX4 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal HEX6_from_the_HEX7_HEX4 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal HEX7_from_the_HEX7_HEX4 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

              -- the_PS2_Port
                 signal PS2_CLK_to_and_from_the_PS2_Port : INOUT STD_LOGIC;
                 signal PS2_DAT_to_and_from_the_PS2_Port : INOUT STD_LOGIC;

              -- the_PS2_Port_Dual
                 signal PS2_CLK_to_and_from_the_PS2_Port_Dual : INOUT STD_LOGIC;
                 signal PS2_DAT_to_and_from_the_PS2_Port_Dual : INOUT STD_LOGIC;

              -- the_Pushbuttons
                 signal KEY_to_the_Pushbuttons : IN STD_LOGIC_VECTOR (3 DOWNTO 0);

              -- the_Red_LEDs
                 signal LEDR_from_the_Red_LEDs : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);

              -- the_SDRAM
                 signal zs_addr_from_the_SDRAM : OUT STD_LOGIC_VECTOR (12 DOWNTO 0);
                 signal zs_ba_from_the_SDRAM : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal zs_cas_n_from_the_SDRAM : OUT STD_LOGIC;
                 signal zs_cke_from_the_SDRAM : OUT STD_LOGIC;
                 signal zs_cs_n_from_the_SDRAM : OUT STD_LOGIC;
                 signal zs_dq_to_and_from_the_SDRAM : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal zs_dqm_from_the_SDRAM : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal zs_ras_n_from_the_SDRAM : OUT STD_LOGIC;
                 signal zs_we_n_from_the_SDRAM : OUT STD_LOGIC;

              -- the_SRAM
                 signal SRAM_ADDR_from_the_SRAM : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
                 signal SRAM_CE_N_from_the_SRAM : OUT STD_LOGIC;
                 signal SRAM_DQ_to_and_from_the_SRAM : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal SRAM_LB_N_from_the_SRAM : OUT STD_LOGIC;
                 signal SRAM_OE_N_from_the_SRAM : OUT STD_LOGIC;
                 signal SRAM_UB_N_from_the_SRAM : OUT STD_LOGIC;
                 signal SRAM_WE_N_from_the_SRAM : OUT STD_LOGIC;

              -- the_Serial_Port
                 signal UART_RXD_to_the_Serial_Port : IN STD_LOGIC;
                 signal UART_TXD_from_the_Serial_Port : OUT STD_LOGIC;

              -- the_Slider_Switches
                 signal SW_to_the_Slider_Switches : IN STD_LOGIC_VECTOR (17 DOWNTO 0);

              -- the_VGA_Controller
                 signal VGA_BLANK_from_the_VGA_Controller : OUT STD_LOGIC;
                 signal VGA_B_from_the_VGA_Controller : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal VGA_CLK_from_the_VGA_Controller : OUT STD_LOGIC;
                 signal VGA_G_from_the_VGA_Controller : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal VGA_HS_from_the_VGA_Controller : OUT STD_LOGIC;
                 signal VGA_R_from_the_VGA_Controller : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal VGA_SYNC_from_the_VGA_Controller : OUT STD_LOGIC;
                 signal VGA_VS_from_the_VGA_Controller : OUT STD_LOGIC;
					  
              --  IrDA
                 signal irda_rxd	: IN STD_LOGIC;
	
              --  Video In
                 signal video_in_TD_DATA : IN STD_LOGIC_VECTOR (7 downto 0);
                 signal video_in_TD_HS : IN STD_LOGIC;
                 signal video_in_TD_VS : IN STD_LOGIC;
                 signal video_in_TD_RESET : OUT STD_LOGIC;
                 signal video_in_clk27_reset : in STD_LOGIC;
				 
              --  Flash
                 signal flash_ADDR : OUT STD_LOGIC_VECTOR (22 downto 0);
                 signal flash_CE_N : OUT STD_LOGIC;
                 signal flash_OE_N : OUT STD_LOGIC;
                 signal flash_RST_N : OUT STD_LOGIC;
                 signal flash_WE_N : OUT STD_LOGIC;
                 signal flash_DQ	 : INOUT STD_LOGIC_VECTOR (7 downto 0);
	
              --  SD Card
                 signal sdcard_b_SD_cmd : INOUT STD_LOGIC;
                 signal sdcard_b_SD_dat : INOUT STD_LOGIC;
                 signal sdcard_b_SD_dat3 : INOUT STD_LOGIC;
                 signal sdcard_o_SD_clock : OUT STD_LOGIC;
					  
				  --  USB
					  signal usb_INT0 : IN STD_LOGIC;
					  signal usb_INT1 : IN STD_LOGIC;
					  signal usb_DATA : INOUT STD_LOGIC_VECTOR (15 downto 0);
					  signal usb_ADDR : OUT STD_LOGIC_VECTOR (1 downto 0);
					  signal usb_CS_N : OUT STD_LOGIC;
					  signal usb_RD_N : OUT STD_LOGIC;
					  signal usb_RST_N : OUT STD_LOGIC;
					  signal usb_WR_N : OUT STD_LOGIC
			  );
	end component;
	
-------------------------------------------------------------------------------
--						   Parameter Declarations						  --
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--				 Internal Wires and Registers Declarations				 --
-------------------------------------------------------------------------------
-- Internal Wires

-- Internal Registers

-- State Machine Registers

begin

-------------------------------------------------------------------------------
--						 Finite State Machine(s)						   --
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--							 Sequential Logic							  --
-------------------------------------------------------------------------------
	
-------------------------------------------------------------------------------
--							Combinational Logic							--
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--							  Internal Modules							 --
-------------------------------------------------------------------------------



NiosII : nios_system
	port map(
		-- 1) global signals:
		clk	   									=> CLOCK_50,
		clk_27 									=> TD_CLK27,
		reset_n									=> KEY(0),
		sdram_clk								=> DRAM_CLK,
		audio_clk								=> AUD_XCK,
	
		-- the_AV_Config
		I2C_SDAT_to_and_from_the_AV_Config		=> I2C_SDAT,
		I2C_SCLK_from_the_AV_Config				=> I2C_SCLK,
	
		-- the_Audio
		AUD_ADCDAT_to_the_Audio					=> AUD_ADCDAT,
		AUD_BCLK_to_the_Audio			      => AUD_BCLK,
		AUD_ADCLRCK_to_the_Audio		      => AUD_ADCLRCK,
		AUD_DACLRCK_to_the_Audio		      => AUD_DACLRCK,
		AUD_DACDAT_from_the_Audio				=> AUD_DACDAT,

		-- the_Char_LCD_16x2
		LCD_DATA_to_and_from_the_Char_LCD_16x2	=> LCD_DATA,
		LCD_ON_from_the_Char_LCD_16x2			=> LCD_ON,
		LCD_BLON_from_the_Char_LCD_16x2			=> LCD_BLON,
		LCD_EN_from_the_Char_LCD_16x2			=> LCD_EN,
		LCD_RS_from_the_Char_LCD_16x2			=> LCD_RS,
		LCD_RW_from_the_Char_LCD_16x2			=> LCD_RW,

		-- the_Expansion_JP5
		GPIO_to_and_from_the_Expansion_JP5(0)	=> GPIO(1),
		GPIO_to_and_from_the_Expansion_JP5(13 downto 1)	
												=> GPIO(15 downto 3),
		GPIO_to_and_from_the_Expansion_JP5(14)	=> GPIO(17),
		GPIO_to_and_from_the_Expansion_JP5(31 downto 15)	
												=> GPIO(35 downto 19),

		-- the_Green_LEDs
		LEDG_from_the_Green_LEDs 				=> LEDG,
		
		-- the_HEX3_HEX0
		HEX0_from_the_HEX3_HEX0 				=> HEX0,
		HEX1_from_the_HEX3_HEX0 				=> HEX1,
		HEX2_from_the_HEX3_HEX0 				=> HEX2,
		HEX3_from_the_HEX3_HEX0 				=> HEX3,
		
		-- the_HEX7_HEX4
		HEX4_from_the_HEX7_HEX4 				=> HEX4,
		HEX5_from_the_HEX7_HEX4					=> HEX5,
		HEX6_from_the_HEX7_HEX4					=> HEX6,
		HEX7_from_the_HEX7_HEX4					=> HEX7,
		
		-- the_PS2_Port
		PS2_CLK_to_and_from_the_PS2_Port		=> PS2_KBCLK,
		PS2_DAT_to_and_from_the_PS2_Port		=> PS2_KBDAT,
	
		-- the_PS2_Port_Dual
		PS2_CLK_to_and_from_the_PS2_Port_Dual	=> PS2_MSCLK,
		PS2_DAT_to_and_from_the_PS2_Port_Dual	=> PS2_MSDAT,
	
		-- the_Pushbuttons
		KEY_to_the_Pushbuttons					=> (KEY(3 downto 1) & "1"),

		-- the_Red_LEDs
		LEDR_from_the_Red_LEDs 					=> LEDR,
		
		-- the_SDRAM
		zs_addr_from_the_sdram					=> DRAM_ADDR,
		zs_ba_from_the_sdram					=> DRAM_BA,
		zs_cas_n_from_the_sdram					=> DRAM_CAS_N,
		zs_cke_from_the_sdram					=> DRAM_CKE,
		zs_cs_n_from_the_sdram					=> DRAM_CS_N,
		zs_dq_to_and_from_the_sdram				=> DRAM_DQ,
		zs_dqm_from_the_sdram					=> DRAM_DQM,
		zs_ras_n_from_the_sdram					=> DRAM_RAS_N,
		zs_we_n_from_the_sdram					=> DRAM_WE_N,
		
		-- the_SRAM
		SRAM_ADDR_from_the_SRAM					=> SRAM_ADDR,
		SRAM_CE_N_from_the_SRAM					=> SRAM_CE_N,
		SRAM_DQ_to_and_from_the_SRAM			=> SRAM_DQ,
		SRAM_LB_N_from_the_SRAM					=> SRAM_LB_N,
		SRAM_OE_N_from_the_SRAM					=> SRAM_OE_N,
		SRAM_UB_N_from_the_SRAM 				=> SRAM_UB_N,
		SRAM_WE_N_from_the_SRAM 				=> SRAM_WE_N,
		
		-- the_Serial_port
		UART_RXD_to_the_Serial_port				=> UART_RXD,
		UART_TXD_from_the_Serial_port			=> UART_TXD,
		
		-- the_Slider_switches
		SW_to_the_Slider_switches				=> SW,
		
		-- the_VGA_Controller
		VGA_CLK_from_the_VGA_Controller			=> VGA_CLK,
		VGA_HS_from_the_VGA_Controller			=> VGA_HS,
		VGA_VS_from_the_VGA_Controller			=> VGA_VS,
		VGA_BLANK_from_the_VGA_Controller		=> VGA_BLANK_N,
		VGA_SYNC_from_the_VGA_Controller		=> VGA_SYNC_N,
		VGA_R_from_the_VGA_Controller			=> VGA_R,
		VGA_G_from_the_VGA_Controller			=> VGA_G,
		VGA_B_from_the_VGA_Controller			=> VGA_B,
		
		--  IrDA
		irda_rxd								=> IRDA_RXD,
	
		--  Video In
		video_in_TD_DATA 						=> TD_DATA,
		video_in_TD_HS 							=> TD_HS,
		video_in_TD_VS							=> TD_VS,
		video_in_TD_RESET						=> TD_RESET_N,
		video_in_clk27_reset					=> (KEY(0)),
				  
		--  Flash
		flash_ADDR								=> FL_ADDR,						
		flash_CE_N								=> FL_CE_N,
		flash_OE_N								=> FL_OE_N,
		flash_RST_N								=> FL_RESET_N,
		flash_WE_N								=> FL_WE_N,
		flash_DQ								=> FL_DQ,
	
		--  SD Card
		sdcard_b_SD_cmd						=> SD_CMD,
		sdcard_b_SD_dat						=> SD_DAT(0),
		sdcard_b_SD_dat3						=> SD_DAT(3),
		sdcard_o_SD_clock						=> SD_CLK,
		
		--  USB             
      usb_INT1                         => OTG_INT(1),
      usb_DATA                         => OTG_DATA,
		usb_RST_N                        => OTG_RST_N,
		usb_ADDR                         => OTG_ADDR,
		usb_CS_N                         => OTG_CS_N,
		usb_RD_N                         => OTG_OE_N,
		usb_WR_N                         => OTG_WE_N,
		usb_INT0                         => OTG_INT(0)
	);
	
end DE2_115_Media_Computer_rtl;

