## Generated SDC file "DE1_SoC_SDRAM_Nios_Test.out.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus Prime License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 15.1.0 Build 185 10/21/2015 SJ Lite Edition"

## DATE    "Mon Feb 15 15:05:15 2016"

##
## DEVICE  "5CSEMA5F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 33.333 -waveform { 0.000 16.666 } [get_ports {altera_reserved_tck}]
create_clock -name {CLOCK2_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK2_50}]
create_clock -name {CLOCK3_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK3_50}]
create_clock -name {CLOCK4_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK4_50}]
create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]
create_clock -name {sdram_clk} -period 6.993 -waveform { 0.000 3.496 } [get_ports {DRAM_CLK}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {U0|pll|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} -source [get_pins {U0|pll|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin}] -duty_cycle 50.000 -multiply_by 143 -divide_by 5 -master_clock {CLOCK_50} [get_pins {U0|pll|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}] 
create_generated_clock -name {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 10 -master_clock {U0|pll|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {U0|pll|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {U0|pll|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 10 -phase -193.462 -master_clock {U0|pll|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {U0|pll|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.190  
set_clock_uncertainty -rise_from [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.190  
set_clock_uncertainty -rise_from [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.190  
set_clock_uncertainty -fall_from [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.190  
set_clock_uncertainty -fall_from [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {U0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}] -setup 0.170  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}] -setup 0.170  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}] -setup 0.170  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}] -setup 0.170  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -hold 0.270  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_registers {*|alt_jtag_atlantic:*|jupdate}] -to [get_registers {*|alt_jtag_atlantic:*|jupdate1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rdata[*]}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read}] -to [get_registers {*|alt_jtag_atlantic:*|read1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read_req}] 
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rvalid}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|t_dav}] -to [get_registers {*|alt_jtag_atlantic:*|tck_t_dav}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|user_saw_rvalid}] -to [get_registers {*|alt_jtag_atlantic:*|rvalid0*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|wdata[*]}] -to [get_registers *]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write}] -to [get_registers {*|alt_jtag_atlantic:*|write1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_ena*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_pause*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_valid}] 
set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]
set_false_path -from [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_nios2_oci_break:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci_break|break_readreg*}] -to [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck|*sr*}]
set_false_path -from [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_nios2_oci_debug:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci_debug|*resetlatch}] -to [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck|*sr[33]}]
set_false_path -from [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_nios2_oci_debug:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci_debug|monitor_ready}] -to [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck|*sr[0]}]
set_false_path -from [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_nios2_oci_debug:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci_debug|monitor_error}] -to [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck|*sr[34]}]
set_false_path -from [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_nios2_ocimem:the_DE1_SoC_QSYS_nios2_qsys_nios2_ocimem|*MonDReg*}] -to [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck|*sr*}]
set_false_path -from [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_tck|*sr*}] -to [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_sysclk:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_sysclk|*jdo*}]
set_false_path -from [get_keepers {sld_hub:*|irf_reg*}] -to [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_wrapper|DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_sysclk:the_DE1_SoC_QSYS_nios2_qsys_jtag_debug_module_sysclk|ir*}]
set_false_path -from [get_keepers {sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1]}] -to [get_keepers {*DE1_SoC_QSYS_nios2_qsys:*|DE1_SoC_QSYS_nios2_qsys_nios2_oci:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci|DE1_SoC_QSYS_nios2_qsys_nios2_oci_debug:the_DE1_SoC_QSYS_nios2_qsys_nios2_oci_debug|monitor_go}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

