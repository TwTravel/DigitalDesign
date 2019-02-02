//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


//Legal Notice: (C)2006 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module In0_s1_arbitrator (
                           // inputs:
                            In0_s1_readdata,
                            clk,
                            cpu_0_data_master_address_to_slave,
                            cpu_0_data_master_read,
                            cpu_0_data_master_write,
                            reset_n,

                           // outputs:
                            In0_s1_address,
                            In0_s1_readdata_from_sa,
                            In0_s1_reset_n,
                            cpu_0_data_master_granted_In0_s1,
                            cpu_0_data_master_qualified_request_In0_s1,
                            cpu_0_data_master_read_data_valid_In0_s1,
                            cpu_0_data_master_requests_In0_s1,
                            d1_In0_s1_end_xfer
                         )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] In0_s1_address;
  output  [ 15: 0] In0_s1_readdata_from_sa;
  output           In0_s1_reset_n;
  output           cpu_0_data_master_granted_In0_s1;
  output           cpu_0_data_master_qualified_request_In0_s1;
  output           cpu_0_data_master_read_data_valid_In0_s1;
  output           cpu_0_data_master_requests_In0_s1;
  output           d1_In0_s1_end_xfer;
  input   [ 15: 0] In0_s1_readdata;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input            reset_n;

  wire    [  1: 0] In0_s1_address;
  wire             In0_s1_allgrants;
  wire             In0_s1_allow_new_arb_cycle;
  wire             In0_s1_any_bursting_master_saved_grant;
  wire             In0_s1_any_continuerequest;
  wire             In0_s1_arb_counter_enable;
  reg     [  1: 0] In0_s1_arb_share_counter;
  wire    [  1: 0] In0_s1_arb_share_counter_next_value;
  wire    [  1: 0] In0_s1_arb_share_set_values;
  wire             In0_s1_beginbursttransfer_internal;
  wire             In0_s1_begins_xfer;
  wire             In0_s1_end_xfer;
  wire             In0_s1_firsttransfer;
  wire             In0_s1_grant_vector;
  wire             In0_s1_in_a_read_cycle;
  wire             In0_s1_in_a_write_cycle;
  wire             In0_s1_master_qreq_vector;
  wire             In0_s1_non_bursting_master_requests;
  wire    [ 15: 0] In0_s1_readdata_from_sa;
  wire             In0_s1_reset_n;
  reg              In0_s1_slavearbiterlockenable;
  wire             In0_s1_slavearbiterlockenable2;
  wire             In0_s1_waits_for_read;
  wire             In0_s1_waits_for_write;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_In0_s1;
  wire             cpu_0_data_master_qualified_request_In0_s1;
  wire             cpu_0_data_master_read_data_valid_In0_s1;
  wire             cpu_0_data_master_requests_In0_s1;
  wire             cpu_0_data_master_saved_grant_In0_s1;
  reg              d1_In0_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_In0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 19: 0] shifted_address_to_In0_s1_from_cpu_0_data_master;
  wire             wait_for_In0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~In0_s1_end_xfer;
    end


  assign In0_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_In0_s1));
  //assign In0_s1_readdata_from_sa = In0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign In0_s1_readdata_from_sa = In0_s1_readdata;

  assign cpu_0_data_master_requests_In0_s1 = (({cpu_0_data_master_address_to_slave[19 : 4] , 4'b0} == 20'h820) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_read;
  //In0_s1_arb_share_counter set values, which is an e_mux
  assign In0_s1_arb_share_set_values = 1;

  //In0_s1_non_bursting_master_requests mux, which is an e_mux
  assign In0_s1_non_bursting_master_requests = cpu_0_data_master_requests_In0_s1;

  //In0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign In0_s1_any_bursting_master_saved_grant = 0;

  //In0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign In0_s1_arb_share_counter_next_value = In0_s1_firsttransfer ? (In0_s1_arb_share_set_values - 1) : |In0_s1_arb_share_counter ? (In0_s1_arb_share_counter - 1) : 0;

  //In0_s1_allgrants all slave grants, which is an e_mux
  assign In0_s1_allgrants = |In0_s1_grant_vector;

  //In0_s1_end_xfer assignment, which is an e_assign
  assign In0_s1_end_xfer = ~(In0_s1_waits_for_read | In0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_In0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_In0_s1 = In0_s1_end_xfer & (~In0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //In0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign In0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_In0_s1 & In0_s1_allgrants) | (end_xfer_arb_share_counter_term_In0_s1 & ~In0_s1_non_bursting_master_requests);

  //In0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          In0_s1_arb_share_counter <= 0;
      else if (In0_s1_arb_counter_enable)
          In0_s1_arb_share_counter <= In0_s1_arb_share_counter_next_value;
    end


  //In0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          In0_s1_slavearbiterlockenable <= 0;
      else if ((|In0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_In0_s1) | (end_xfer_arb_share_counter_term_In0_s1 & ~In0_s1_non_bursting_master_requests))
          In0_s1_slavearbiterlockenable <= |In0_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master In0/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = In0_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //In0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign In0_s1_slavearbiterlockenable2 = |In0_s1_arb_share_counter_next_value;

  //cpu_0/data_master In0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = In0_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //In0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign In0_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_In0_s1 = cpu_0_data_master_requests_In0_s1;
  //master is always granted when requested
  assign cpu_0_data_master_granted_In0_s1 = cpu_0_data_master_qualified_request_In0_s1;

  //cpu_0/data_master saved-grant In0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_In0_s1 = cpu_0_data_master_requests_In0_s1;

  //allow new arb cycle for In0/s1, which is an e_assign
  assign In0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign In0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign In0_s1_master_qreq_vector = 1;

  //In0_s1_reset_n assignment, which is an e_assign
  assign In0_s1_reset_n = reset_n;

  //In0_s1_firsttransfer first transaction, which is an e_assign
  assign In0_s1_firsttransfer = ~(In0_s1_slavearbiterlockenable & In0_s1_any_continuerequest);

  //In0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign In0_s1_beginbursttransfer_internal = In0_s1_begins_xfer;

  assign shifted_address_to_In0_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //In0_s1_address mux, which is an e_mux
  assign In0_s1_address = shifted_address_to_In0_s1_from_cpu_0_data_master >> 2;

  //d1_In0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_In0_s1_end_xfer <= 1;
      else if (1)
          d1_In0_s1_end_xfer <= In0_s1_end_xfer;
    end


  //In0_s1_waits_for_read in a cycle, which is an e_mux
  assign In0_s1_waits_for_read = In0_s1_in_a_read_cycle & In0_s1_begins_xfer;

  //In0_s1_in_a_read_cycle assignment, which is an e_assign
  assign In0_s1_in_a_read_cycle = cpu_0_data_master_granted_In0_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = In0_s1_in_a_read_cycle;

  //In0_s1_waits_for_write in a cycle, which is an e_mux
  assign In0_s1_waits_for_write = In0_s1_in_a_write_cycle & 0;

  //In0_s1_in_a_write_cycle assignment, which is an e_assign
  assign In0_s1_in_a_write_cycle = cpu_0_data_master_granted_In0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = In0_s1_in_a_write_cycle;

  assign wait_for_In0_s1_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module In1_s1_arbitrator (
                           // inputs:
                            In1_s1_readdata,
                            clk,
                            cpu_0_data_master_address_to_slave,
                            cpu_0_data_master_read,
                            cpu_0_data_master_write,
                            reset_n,

                           // outputs:
                            In1_s1_address,
                            In1_s1_readdata_from_sa,
                            In1_s1_reset_n,
                            cpu_0_data_master_granted_In1_s1,
                            cpu_0_data_master_qualified_request_In1_s1,
                            cpu_0_data_master_read_data_valid_In1_s1,
                            cpu_0_data_master_requests_In1_s1,
                            d1_In1_s1_end_xfer
                         )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] In1_s1_address;
  output  [ 15: 0] In1_s1_readdata_from_sa;
  output           In1_s1_reset_n;
  output           cpu_0_data_master_granted_In1_s1;
  output           cpu_0_data_master_qualified_request_In1_s1;
  output           cpu_0_data_master_read_data_valid_In1_s1;
  output           cpu_0_data_master_requests_In1_s1;
  output           d1_In1_s1_end_xfer;
  input   [ 15: 0] In1_s1_readdata;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input            reset_n;

  wire    [  1: 0] In1_s1_address;
  wire             In1_s1_allgrants;
  wire             In1_s1_allow_new_arb_cycle;
  wire             In1_s1_any_bursting_master_saved_grant;
  wire             In1_s1_any_continuerequest;
  wire             In1_s1_arb_counter_enable;
  reg     [  1: 0] In1_s1_arb_share_counter;
  wire    [  1: 0] In1_s1_arb_share_counter_next_value;
  wire    [  1: 0] In1_s1_arb_share_set_values;
  wire             In1_s1_beginbursttransfer_internal;
  wire             In1_s1_begins_xfer;
  wire             In1_s1_end_xfer;
  wire             In1_s1_firsttransfer;
  wire             In1_s1_grant_vector;
  wire             In1_s1_in_a_read_cycle;
  wire             In1_s1_in_a_write_cycle;
  wire             In1_s1_master_qreq_vector;
  wire             In1_s1_non_bursting_master_requests;
  wire    [ 15: 0] In1_s1_readdata_from_sa;
  wire             In1_s1_reset_n;
  reg              In1_s1_slavearbiterlockenable;
  wire             In1_s1_slavearbiterlockenable2;
  wire             In1_s1_waits_for_read;
  wire             In1_s1_waits_for_write;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_In1_s1;
  wire             cpu_0_data_master_qualified_request_In1_s1;
  wire             cpu_0_data_master_read_data_valid_In1_s1;
  wire             cpu_0_data_master_requests_In1_s1;
  wire             cpu_0_data_master_saved_grant_In1_s1;
  reg              d1_In1_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_In1_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 19: 0] shifted_address_to_In1_s1_from_cpu_0_data_master;
  wire             wait_for_In1_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~In1_s1_end_xfer;
    end


  assign In1_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_In1_s1));
  //assign In1_s1_readdata_from_sa = In1_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign In1_s1_readdata_from_sa = In1_s1_readdata;

  assign cpu_0_data_master_requests_In1_s1 = (({cpu_0_data_master_address_to_slave[19 : 4] , 4'b0} == 20'h830) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_read;
  //In1_s1_arb_share_counter set values, which is an e_mux
  assign In1_s1_arb_share_set_values = 1;

  //In1_s1_non_bursting_master_requests mux, which is an e_mux
  assign In1_s1_non_bursting_master_requests = cpu_0_data_master_requests_In1_s1;

  //In1_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign In1_s1_any_bursting_master_saved_grant = 0;

  //In1_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign In1_s1_arb_share_counter_next_value = In1_s1_firsttransfer ? (In1_s1_arb_share_set_values - 1) : |In1_s1_arb_share_counter ? (In1_s1_arb_share_counter - 1) : 0;

  //In1_s1_allgrants all slave grants, which is an e_mux
  assign In1_s1_allgrants = |In1_s1_grant_vector;

  //In1_s1_end_xfer assignment, which is an e_assign
  assign In1_s1_end_xfer = ~(In1_s1_waits_for_read | In1_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_In1_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_In1_s1 = In1_s1_end_xfer & (~In1_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //In1_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign In1_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_In1_s1 & In1_s1_allgrants) | (end_xfer_arb_share_counter_term_In1_s1 & ~In1_s1_non_bursting_master_requests);

  //In1_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          In1_s1_arb_share_counter <= 0;
      else if (In1_s1_arb_counter_enable)
          In1_s1_arb_share_counter <= In1_s1_arb_share_counter_next_value;
    end


  //In1_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          In1_s1_slavearbiterlockenable <= 0;
      else if ((|In1_s1_master_qreq_vector & end_xfer_arb_share_counter_term_In1_s1) | (end_xfer_arb_share_counter_term_In1_s1 & ~In1_s1_non_bursting_master_requests))
          In1_s1_slavearbiterlockenable <= |In1_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master In1/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = In1_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //In1_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign In1_s1_slavearbiterlockenable2 = |In1_s1_arb_share_counter_next_value;

  //cpu_0/data_master In1/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = In1_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //In1_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign In1_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_In1_s1 = cpu_0_data_master_requests_In1_s1;
  //master is always granted when requested
  assign cpu_0_data_master_granted_In1_s1 = cpu_0_data_master_qualified_request_In1_s1;

  //cpu_0/data_master saved-grant In1/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_In1_s1 = cpu_0_data_master_requests_In1_s1;

  //allow new arb cycle for In1/s1, which is an e_assign
  assign In1_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign In1_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign In1_s1_master_qreq_vector = 1;

  //In1_s1_reset_n assignment, which is an e_assign
  assign In1_s1_reset_n = reset_n;

  //In1_s1_firsttransfer first transaction, which is an e_assign
  assign In1_s1_firsttransfer = ~(In1_s1_slavearbiterlockenable & In1_s1_any_continuerequest);

  //In1_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign In1_s1_beginbursttransfer_internal = In1_s1_begins_xfer;

  assign shifted_address_to_In1_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //In1_s1_address mux, which is an e_mux
  assign In1_s1_address = shifted_address_to_In1_s1_from_cpu_0_data_master >> 2;

  //d1_In1_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_In1_s1_end_xfer <= 1;
      else if (1)
          d1_In1_s1_end_xfer <= In1_s1_end_xfer;
    end


  //In1_s1_waits_for_read in a cycle, which is an e_mux
  assign In1_s1_waits_for_read = In1_s1_in_a_read_cycle & In1_s1_begins_xfer;

  //In1_s1_in_a_read_cycle assignment, which is an e_assign
  assign In1_s1_in_a_read_cycle = cpu_0_data_master_granted_In1_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = In1_s1_in_a_read_cycle;

  //In1_s1_waits_for_write in a cycle, which is an e_mux
  assign In1_s1_waits_for_write = In1_s1_in_a_write_cycle & 0;

  //In1_s1_in_a_write_cycle assignment, which is an e_assign
  assign In1_s1_in_a_write_cycle = cpu_0_data_master_granted_In1_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = In1_s1_in_a_write_cycle;

  assign wait_for_In1_s1_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module In2_s1_arbitrator (
                           // inputs:
                            In2_s1_readdata,
                            clk,
                            cpu_0_data_master_address_to_slave,
                            cpu_0_data_master_read,
                            cpu_0_data_master_write,
                            reset_n,

                           // outputs:
                            In2_s1_address,
                            In2_s1_readdata_from_sa,
                            In2_s1_reset_n,
                            cpu_0_data_master_granted_In2_s1,
                            cpu_0_data_master_qualified_request_In2_s1,
                            cpu_0_data_master_read_data_valid_In2_s1,
                            cpu_0_data_master_requests_In2_s1,
                            d1_In2_s1_end_xfer
                         )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] In2_s1_address;
  output  [ 15: 0] In2_s1_readdata_from_sa;
  output           In2_s1_reset_n;
  output           cpu_0_data_master_granted_In2_s1;
  output           cpu_0_data_master_qualified_request_In2_s1;
  output           cpu_0_data_master_read_data_valid_In2_s1;
  output           cpu_0_data_master_requests_In2_s1;
  output           d1_In2_s1_end_xfer;
  input   [ 15: 0] In2_s1_readdata;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input            reset_n;

  wire    [  1: 0] In2_s1_address;
  wire             In2_s1_allgrants;
  wire             In2_s1_allow_new_arb_cycle;
  wire             In2_s1_any_bursting_master_saved_grant;
  wire             In2_s1_any_continuerequest;
  wire             In2_s1_arb_counter_enable;
  reg     [  1: 0] In2_s1_arb_share_counter;
  wire    [  1: 0] In2_s1_arb_share_counter_next_value;
  wire    [  1: 0] In2_s1_arb_share_set_values;
  wire             In2_s1_beginbursttransfer_internal;
  wire             In2_s1_begins_xfer;
  wire             In2_s1_end_xfer;
  wire             In2_s1_firsttransfer;
  wire             In2_s1_grant_vector;
  wire             In2_s1_in_a_read_cycle;
  wire             In2_s1_in_a_write_cycle;
  wire             In2_s1_master_qreq_vector;
  wire             In2_s1_non_bursting_master_requests;
  wire    [ 15: 0] In2_s1_readdata_from_sa;
  wire             In2_s1_reset_n;
  reg              In2_s1_slavearbiterlockenable;
  wire             In2_s1_slavearbiterlockenable2;
  wire             In2_s1_waits_for_read;
  wire             In2_s1_waits_for_write;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_In2_s1;
  wire             cpu_0_data_master_qualified_request_In2_s1;
  wire             cpu_0_data_master_read_data_valid_In2_s1;
  wire             cpu_0_data_master_requests_In2_s1;
  wire             cpu_0_data_master_saved_grant_In2_s1;
  reg              d1_In2_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_In2_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 19: 0] shifted_address_to_In2_s1_from_cpu_0_data_master;
  wire             wait_for_In2_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~In2_s1_end_xfer;
    end


  assign In2_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_In2_s1));
  //assign In2_s1_readdata_from_sa = In2_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign In2_s1_readdata_from_sa = In2_s1_readdata;

  assign cpu_0_data_master_requests_In2_s1 = (({cpu_0_data_master_address_to_slave[19 : 4] , 4'b0} == 20'h860) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_read;
  //In2_s1_arb_share_counter set values, which is an e_mux
  assign In2_s1_arb_share_set_values = 1;

  //In2_s1_non_bursting_master_requests mux, which is an e_mux
  assign In2_s1_non_bursting_master_requests = cpu_0_data_master_requests_In2_s1;

  //In2_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign In2_s1_any_bursting_master_saved_grant = 0;

  //In2_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign In2_s1_arb_share_counter_next_value = In2_s1_firsttransfer ? (In2_s1_arb_share_set_values - 1) : |In2_s1_arb_share_counter ? (In2_s1_arb_share_counter - 1) : 0;

  //In2_s1_allgrants all slave grants, which is an e_mux
  assign In2_s1_allgrants = |In2_s1_grant_vector;

  //In2_s1_end_xfer assignment, which is an e_assign
  assign In2_s1_end_xfer = ~(In2_s1_waits_for_read | In2_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_In2_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_In2_s1 = In2_s1_end_xfer & (~In2_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //In2_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign In2_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_In2_s1 & In2_s1_allgrants) | (end_xfer_arb_share_counter_term_In2_s1 & ~In2_s1_non_bursting_master_requests);

  //In2_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          In2_s1_arb_share_counter <= 0;
      else if (In2_s1_arb_counter_enable)
          In2_s1_arb_share_counter <= In2_s1_arb_share_counter_next_value;
    end


  //In2_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          In2_s1_slavearbiterlockenable <= 0;
      else if ((|In2_s1_master_qreq_vector & end_xfer_arb_share_counter_term_In2_s1) | (end_xfer_arb_share_counter_term_In2_s1 & ~In2_s1_non_bursting_master_requests))
          In2_s1_slavearbiterlockenable <= |In2_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master In2/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = In2_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //In2_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign In2_s1_slavearbiterlockenable2 = |In2_s1_arb_share_counter_next_value;

  //cpu_0/data_master In2/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = In2_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //In2_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign In2_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_In2_s1 = cpu_0_data_master_requests_In2_s1;
  //master is always granted when requested
  assign cpu_0_data_master_granted_In2_s1 = cpu_0_data_master_qualified_request_In2_s1;

  //cpu_0/data_master saved-grant In2/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_In2_s1 = cpu_0_data_master_requests_In2_s1;

  //allow new arb cycle for In2/s1, which is an e_assign
  assign In2_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign In2_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign In2_s1_master_qreq_vector = 1;

  //In2_s1_reset_n assignment, which is an e_assign
  assign In2_s1_reset_n = reset_n;

  //In2_s1_firsttransfer first transaction, which is an e_assign
  assign In2_s1_firsttransfer = ~(In2_s1_slavearbiterlockenable & In2_s1_any_continuerequest);

  //In2_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign In2_s1_beginbursttransfer_internal = In2_s1_begins_xfer;

  assign shifted_address_to_In2_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //In2_s1_address mux, which is an e_mux
  assign In2_s1_address = shifted_address_to_In2_s1_from_cpu_0_data_master >> 2;

  //d1_In2_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_In2_s1_end_xfer <= 1;
      else if (1)
          d1_In2_s1_end_xfer <= In2_s1_end_xfer;
    end


  //In2_s1_waits_for_read in a cycle, which is an e_mux
  assign In2_s1_waits_for_read = In2_s1_in_a_read_cycle & In2_s1_begins_xfer;

  //In2_s1_in_a_read_cycle assignment, which is an e_assign
  assign In2_s1_in_a_read_cycle = cpu_0_data_master_granted_In2_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = In2_s1_in_a_read_cycle;

  //In2_s1_waits_for_write in a cycle, which is an e_mux
  assign In2_s1_waits_for_write = In2_s1_in_a_write_cycle & 0;

  //In2_s1_in_a_write_cycle assignment, which is an e_assign
  assign In2_s1_in_a_write_cycle = cpu_0_data_master_granted_In2_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = In2_s1_in_a_write_cycle;

  assign wait_for_In2_s1_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module Out0_s1_arbitrator (
                            // inputs:
                             clk,
                             cpu_0_data_master_address_to_slave,
                             cpu_0_data_master_read,
                             cpu_0_data_master_waitrequest,
                             cpu_0_data_master_write,
                             cpu_0_data_master_writedata,
                             reset_n,

                            // outputs:
                             Out0_s1_address,
                             Out0_s1_chipselect,
                             Out0_s1_reset_n,
                             Out0_s1_write_n,
                             Out0_s1_writedata,
                             cpu_0_data_master_granted_Out0_s1,
                             cpu_0_data_master_qualified_request_Out0_s1,
                             cpu_0_data_master_read_data_valid_Out0_s1,
                             cpu_0_data_master_requests_Out0_s1,
                             d1_Out0_s1_end_xfer
                          )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] Out0_s1_address;
  output           Out0_s1_chipselect;
  output           Out0_s1_reset_n;
  output           Out0_s1_write_n;
  output           Out0_s1_writedata;
  output           cpu_0_data_master_granted_Out0_s1;
  output           cpu_0_data_master_qualified_request_Out0_s1;
  output           cpu_0_data_master_read_data_valid_Out0_s1;
  output           cpu_0_data_master_requests_Out0_s1;
  output           d1_Out0_s1_end_xfer;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] Out0_s1_address;
  wire             Out0_s1_allgrants;
  wire             Out0_s1_allow_new_arb_cycle;
  wire             Out0_s1_any_bursting_master_saved_grant;
  wire             Out0_s1_any_continuerequest;
  wire             Out0_s1_arb_counter_enable;
  reg     [  1: 0] Out0_s1_arb_share_counter;
  wire    [  1: 0] Out0_s1_arb_share_counter_next_value;
  wire    [  1: 0] Out0_s1_arb_share_set_values;
  wire             Out0_s1_beginbursttransfer_internal;
  wire             Out0_s1_begins_xfer;
  wire             Out0_s1_chipselect;
  wire             Out0_s1_end_xfer;
  wire             Out0_s1_firsttransfer;
  wire             Out0_s1_grant_vector;
  wire             Out0_s1_in_a_read_cycle;
  wire             Out0_s1_in_a_write_cycle;
  wire             Out0_s1_master_qreq_vector;
  wire             Out0_s1_non_bursting_master_requests;
  wire             Out0_s1_reset_n;
  reg              Out0_s1_slavearbiterlockenable;
  wire             Out0_s1_slavearbiterlockenable2;
  wire             Out0_s1_waits_for_read;
  wire             Out0_s1_waits_for_write;
  wire             Out0_s1_write_n;
  wire             Out0_s1_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_Out0_s1;
  wire             cpu_0_data_master_qualified_request_Out0_s1;
  wire             cpu_0_data_master_read_data_valid_Out0_s1;
  wire             cpu_0_data_master_requests_Out0_s1;
  wire             cpu_0_data_master_saved_grant_Out0_s1;
  reg              d1_Out0_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_Out0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 19: 0] shifted_address_to_Out0_s1_from_cpu_0_data_master;
  wire             wait_for_Out0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~Out0_s1_end_xfer;
    end


  assign Out0_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_Out0_s1));
  assign cpu_0_data_master_requests_Out0_s1 = (({cpu_0_data_master_address_to_slave[19 : 4] , 4'b0} == 20'h870) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_write;
  //Out0_s1_arb_share_counter set values, which is an e_mux
  assign Out0_s1_arb_share_set_values = 1;

  //Out0_s1_non_bursting_master_requests mux, which is an e_mux
  assign Out0_s1_non_bursting_master_requests = cpu_0_data_master_requests_Out0_s1;

  //Out0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign Out0_s1_any_bursting_master_saved_grant = 0;

  //Out0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign Out0_s1_arb_share_counter_next_value = Out0_s1_firsttransfer ? (Out0_s1_arb_share_set_values - 1) : |Out0_s1_arb_share_counter ? (Out0_s1_arb_share_counter - 1) : 0;

  //Out0_s1_allgrants all slave grants, which is an e_mux
  assign Out0_s1_allgrants = |Out0_s1_grant_vector;

  //Out0_s1_end_xfer assignment, which is an e_assign
  assign Out0_s1_end_xfer = ~(Out0_s1_waits_for_read | Out0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_Out0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_Out0_s1 = Out0_s1_end_xfer & (~Out0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //Out0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign Out0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_Out0_s1 & Out0_s1_allgrants) | (end_xfer_arb_share_counter_term_Out0_s1 & ~Out0_s1_non_bursting_master_requests);

  //Out0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Out0_s1_arb_share_counter <= 0;
      else if (Out0_s1_arb_counter_enable)
          Out0_s1_arb_share_counter <= Out0_s1_arb_share_counter_next_value;
    end


  //Out0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Out0_s1_slavearbiterlockenable <= 0;
      else if ((|Out0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_Out0_s1) | (end_xfer_arb_share_counter_term_Out0_s1 & ~Out0_s1_non_bursting_master_requests))
          Out0_s1_slavearbiterlockenable <= |Out0_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master Out0/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = Out0_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //Out0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign Out0_s1_slavearbiterlockenable2 = |Out0_s1_arb_share_counter_next_value;

  //cpu_0/data_master Out0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = Out0_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //Out0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign Out0_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_Out0_s1 = cpu_0_data_master_requests_Out0_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //Out0_s1_writedata mux, which is an e_mux
  assign Out0_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_Out0_s1 = cpu_0_data_master_qualified_request_Out0_s1;

  //cpu_0/data_master saved-grant Out0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_Out0_s1 = cpu_0_data_master_requests_Out0_s1;

  //allow new arb cycle for Out0/s1, which is an e_assign
  assign Out0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign Out0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign Out0_s1_master_qreq_vector = 1;

  //Out0_s1_reset_n assignment, which is an e_assign
  assign Out0_s1_reset_n = reset_n;

  assign Out0_s1_chipselect = cpu_0_data_master_granted_Out0_s1;
  //Out0_s1_firsttransfer first transaction, which is an e_assign
  assign Out0_s1_firsttransfer = ~(Out0_s1_slavearbiterlockenable & Out0_s1_any_continuerequest);

  //Out0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign Out0_s1_beginbursttransfer_internal = Out0_s1_begins_xfer;

  //~Out0_s1_write_n assignment, which is an e_mux
  assign Out0_s1_write_n = ~(cpu_0_data_master_granted_Out0_s1 & cpu_0_data_master_write);

  assign shifted_address_to_Out0_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //Out0_s1_address mux, which is an e_mux
  assign Out0_s1_address = shifted_address_to_Out0_s1_from_cpu_0_data_master >> 2;

  //d1_Out0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_Out0_s1_end_xfer <= 1;
      else if (1)
          d1_Out0_s1_end_xfer <= Out0_s1_end_xfer;
    end


  //Out0_s1_waits_for_read in a cycle, which is an e_mux
  assign Out0_s1_waits_for_read = Out0_s1_in_a_read_cycle & Out0_s1_begins_xfer;

  //Out0_s1_in_a_read_cycle assignment, which is an e_assign
  assign Out0_s1_in_a_read_cycle = cpu_0_data_master_granted_Out0_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = Out0_s1_in_a_read_cycle;

  //Out0_s1_waits_for_write in a cycle, which is an e_mux
  assign Out0_s1_waits_for_write = Out0_s1_in_a_write_cycle & 0;

  //Out0_s1_in_a_write_cycle assignment, which is an e_assign
  assign Out0_s1_in_a_write_cycle = cpu_0_data_master_granted_Out0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = Out0_s1_in_a_write_cycle;

  assign wait_for_Out0_s1_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module Out1_s1_arbitrator (
                            // inputs:
                             clk,
                             cpu_0_data_master_address_to_slave,
                             cpu_0_data_master_read,
                             cpu_0_data_master_waitrequest,
                             cpu_0_data_master_write,
                             cpu_0_data_master_writedata,
                             reset_n,

                            // outputs:
                             Out1_s1_address,
                             Out1_s1_chipselect,
                             Out1_s1_reset_n,
                             Out1_s1_write_n,
                             Out1_s1_writedata,
                             cpu_0_data_master_granted_Out1_s1,
                             cpu_0_data_master_qualified_request_Out1_s1,
                             cpu_0_data_master_read_data_valid_Out1_s1,
                             cpu_0_data_master_requests_Out1_s1,
                             d1_Out1_s1_end_xfer
                          )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] Out1_s1_address;
  output           Out1_s1_chipselect;
  output           Out1_s1_reset_n;
  output           Out1_s1_write_n;
  output  [ 17: 0] Out1_s1_writedata;
  output           cpu_0_data_master_granted_Out1_s1;
  output           cpu_0_data_master_qualified_request_Out1_s1;
  output           cpu_0_data_master_read_data_valid_Out1_s1;
  output           cpu_0_data_master_requests_Out1_s1;
  output           d1_Out1_s1_end_xfer;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] Out1_s1_address;
  wire             Out1_s1_allgrants;
  wire             Out1_s1_allow_new_arb_cycle;
  wire             Out1_s1_any_bursting_master_saved_grant;
  wire             Out1_s1_any_continuerequest;
  wire             Out1_s1_arb_counter_enable;
  reg     [  1: 0] Out1_s1_arb_share_counter;
  wire    [  1: 0] Out1_s1_arb_share_counter_next_value;
  wire    [  1: 0] Out1_s1_arb_share_set_values;
  wire             Out1_s1_beginbursttransfer_internal;
  wire             Out1_s1_begins_xfer;
  wire             Out1_s1_chipselect;
  wire             Out1_s1_end_xfer;
  wire             Out1_s1_firsttransfer;
  wire             Out1_s1_grant_vector;
  wire             Out1_s1_in_a_read_cycle;
  wire             Out1_s1_in_a_write_cycle;
  wire             Out1_s1_master_qreq_vector;
  wire             Out1_s1_non_bursting_master_requests;
  wire             Out1_s1_reset_n;
  reg              Out1_s1_slavearbiterlockenable;
  wire             Out1_s1_slavearbiterlockenable2;
  wire             Out1_s1_waits_for_read;
  wire             Out1_s1_waits_for_write;
  wire             Out1_s1_write_n;
  wire    [ 17: 0] Out1_s1_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_Out1_s1;
  wire             cpu_0_data_master_qualified_request_Out1_s1;
  wire             cpu_0_data_master_read_data_valid_Out1_s1;
  wire             cpu_0_data_master_requests_Out1_s1;
  wire             cpu_0_data_master_saved_grant_Out1_s1;
  reg              d1_Out1_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_Out1_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 19: 0] shifted_address_to_Out1_s1_from_cpu_0_data_master;
  wire             wait_for_Out1_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~Out1_s1_end_xfer;
    end


  assign Out1_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_Out1_s1));
  assign cpu_0_data_master_requests_Out1_s1 = (({cpu_0_data_master_address_to_slave[19 : 4] , 4'b0} == 20'h880) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_write;
  //Out1_s1_arb_share_counter set values, which is an e_mux
  assign Out1_s1_arb_share_set_values = 1;

  //Out1_s1_non_bursting_master_requests mux, which is an e_mux
  assign Out1_s1_non_bursting_master_requests = cpu_0_data_master_requests_Out1_s1;

  //Out1_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign Out1_s1_any_bursting_master_saved_grant = 0;

  //Out1_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign Out1_s1_arb_share_counter_next_value = Out1_s1_firsttransfer ? (Out1_s1_arb_share_set_values - 1) : |Out1_s1_arb_share_counter ? (Out1_s1_arb_share_counter - 1) : 0;

  //Out1_s1_allgrants all slave grants, which is an e_mux
  assign Out1_s1_allgrants = |Out1_s1_grant_vector;

  //Out1_s1_end_xfer assignment, which is an e_assign
  assign Out1_s1_end_xfer = ~(Out1_s1_waits_for_read | Out1_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_Out1_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_Out1_s1 = Out1_s1_end_xfer & (~Out1_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //Out1_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign Out1_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_Out1_s1 & Out1_s1_allgrants) | (end_xfer_arb_share_counter_term_Out1_s1 & ~Out1_s1_non_bursting_master_requests);

  //Out1_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Out1_s1_arb_share_counter <= 0;
      else if (Out1_s1_arb_counter_enable)
          Out1_s1_arb_share_counter <= Out1_s1_arb_share_counter_next_value;
    end


  //Out1_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Out1_s1_slavearbiterlockenable <= 0;
      else if ((|Out1_s1_master_qreq_vector & end_xfer_arb_share_counter_term_Out1_s1) | (end_xfer_arb_share_counter_term_Out1_s1 & ~Out1_s1_non_bursting_master_requests))
          Out1_s1_slavearbiterlockenable <= |Out1_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master Out1/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = Out1_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //Out1_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign Out1_s1_slavearbiterlockenable2 = |Out1_s1_arb_share_counter_next_value;

  //cpu_0/data_master Out1/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = Out1_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //Out1_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign Out1_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_Out1_s1 = cpu_0_data_master_requests_Out1_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //Out1_s1_writedata mux, which is an e_mux
  assign Out1_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_Out1_s1 = cpu_0_data_master_qualified_request_Out1_s1;

  //cpu_0/data_master saved-grant Out1/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_Out1_s1 = cpu_0_data_master_requests_Out1_s1;

  //allow new arb cycle for Out1/s1, which is an e_assign
  assign Out1_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign Out1_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign Out1_s1_master_qreq_vector = 1;

  //Out1_s1_reset_n assignment, which is an e_assign
  assign Out1_s1_reset_n = reset_n;

  assign Out1_s1_chipselect = cpu_0_data_master_granted_Out1_s1;
  //Out1_s1_firsttransfer first transaction, which is an e_assign
  assign Out1_s1_firsttransfer = ~(Out1_s1_slavearbiterlockenable & Out1_s1_any_continuerequest);

  //Out1_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign Out1_s1_beginbursttransfer_internal = Out1_s1_begins_xfer;

  //~Out1_s1_write_n assignment, which is an e_mux
  assign Out1_s1_write_n = ~(cpu_0_data_master_granted_Out1_s1 & cpu_0_data_master_write);

  assign shifted_address_to_Out1_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //Out1_s1_address mux, which is an e_mux
  assign Out1_s1_address = shifted_address_to_Out1_s1_from_cpu_0_data_master >> 2;

  //d1_Out1_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_Out1_s1_end_xfer <= 1;
      else if (1)
          d1_Out1_s1_end_xfer <= Out1_s1_end_xfer;
    end


  //Out1_s1_waits_for_read in a cycle, which is an e_mux
  assign Out1_s1_waits_for_read = Out1_s1_in_a_read_cycle & Out1_s1_begins_xfer;

  //Out1_s1_in_a_read_cycle assignment, which is an e_assign
  assign Out1_s1_in_a_read_cycle = cpu_0_data_master_granted_Out1_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = Out1_s1_in_a_read_cycle;

  //Out1_s1_waits_for_write in a cycle, which is an e_mux
  assign Out1_s1_waits_for_write = Out1_s1_in_a_write_cycle & 0;

  //Out1_s1_in_a_write_cycle assignment, which is an e_assign
  assign Out1_s1_in_a_write_cycle = cpu_0_data_master_granted_Out1_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = Out1_s1_in_a_write_cycle;

  assign wait_for_Out1_s1_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module Out2_s1_arbitrator (
                            // inputs:
                             clk,
                             cpu_0_data_master_address_to_slave,
                             cpu_0_data_master_read,
                             cpu_0_data_master_waitrequest,
                             cpu_0_data_master_write,
                             cpu_0_data_master_writedata,
                             reset_n,

                            // outputs:
                             Out2_s1_address,
                             Out2_s1_chipselect,
                             Out2_s1_reset_n,
                             Out2_s1_write_n,
                             Out2_s1_writedata,
                             cpu_0_data_master_granted_Out2_s1,
                             cpu_0_data_master_qualified_request_Out2_s1,
                             cpu_0_data_master_read_data_valid_Out2_s1,
                             cpu_0_data_master_requests_Out2_s1,
                             d1_Out2_s1_end_xfer
                          )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] Out2_s1_address;
  output           Out2_s1_chipselect;
  output           Out2_s1_reset_n;
  output           Out2_s1_write_n;
  output  [  9: 0] Out2_s1_writedata;
  output           cpu_0_data_master_granted_Out2_s1;
  output           cpu_0_data_master_qualified_request_Out2_s1;
  output           cpu_0_data_master_read_data_valid_Out2_s1;
  output           cpu_0_data_master_requests_Out2_s1;
  output           d1_Out2_s1_end_xfer;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] Out2_s1_address;
  wire             Out2_s1_allgrants;
  wire             Out2_s1_allow_new_arb_cycle;
  wire             Out2_s1_any_bursting_master_saved_grant;
  wire             Out2_s1_any_continuerequest;
  wire             Out2_s1_arb_counter_enable;
  reg     [  1: 0] Out2_s1_arb_share_counter;
  wire    [  1: 0] Out2_s1_arb_share_counter_next_value;
  wire    [  1: 0] Out2_s1_arb_share_set_values;
  wire             Out2_s1_beginbursttransfer_internal;
  wire             Out2_s1_begins_xfer;
  wire             Out2_s1_chipselect;
  wire             Out2_s1_end_xfer;
  wire             Out2_s1_firsttransfer;
  wire             Out2_s1_grant_vector;
  wire             Out2_s1_in_a_read_cycle;
  wire             Out2_s1_in_a_write_cycle;
  wire             Out2_s1_master_qreq_vector;
  wire             Out2_s1_non_bursting_master_requests;
  wire             Out2_s1_reset_n;
  reg              Out2_s1_slavearbiterlockenable;
  wire             Out2_s1_slavearbiterlockenable2;
  wire             Out2_s1_waits_for_read;
  wire             Out2_s1_waits_for_write;
  wire             Out2_s1_write_n;
  wire    [  9: 0] Out2_s1_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_Out2_s1;
  wire             cpu_0_data_master_qualified_request_Out2_s1;
  wire             cpu_0_data_master_read_data_valid_Out2_s1;
  wire             cpu_0_data_master_requests_Out2_s1;
  wire             cpu_0_data_master_saved_grant_Out2_s1;
  reg              d1_Out2_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_Out2_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 19: 0] shifted_address_to_Out2_s1_from_cpu_0_data_master;
  wire             wait_for_Out2_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~Out2_s1_end_xfer;
    end


  assign Out2_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_Out2_s1));
  assign cpu_0_data_master_requests_Out2_s1 = (({cpu_0_data_master_address_to_slave[19 : 4] , 4'b0} == 20'h890) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_write;
  //Out2_s1_arb_share_counter set values, which is an e_mux
  assign Out2_s1_arb_share_set_values = 1;

  //Out2_s1_non_bursting_master_requests mux, which is an e_mux
  assign Out2_s1_non_bursting_master_requests = cpu_0_data_master_requests_Out2_s1;

  //Out2_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign Out2_s1_any_bursting_master_saved_grant = 0;

  //Out2_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign Out2_s1_arb_share_counter_next_value = Out2_s1_firsttransfer ? (Out2_s1_arb_share_set_values - 1) : |Out2_s1_arb_share_counter ? (Out2_s1_arb_share_counter - 1) : 0;

  //Out2_s1_allgrants all slave grants, which is an e_mux
  assign Out2_s1_allgrants = |Out2_s1_grant_vector;

  //Out2_s1_end_xfer assignment, which is an e_assign
  assign Out2_s1_end_xfer = ~(Out2_s1_waits_for_read | Out2_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_Out2_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_Out2_s1 = Out2_s1_end_xfer & (~Out2_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //Out2_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign Out2_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_Out2_s1 & Out2_s1_allgrants) | (end_xfer_arb_share_counter_term_Out2_s1 & ~Out2_s1_non_bursting_master_requests);

  //Out2_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Out2_s1_arb_share_counter <= 0;
      else if (Out2_s1_arb_counter_enable)
          Out2_s1_arb_share_counter <= Out2_s1_arb_share_counter_next_value;
    end


  //Out2_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Out2_s1_slavearbiterlockenable <= 0;
      else if ((|Out2_s1_master_qreq_vector & end_xfer_arb_share_counter_term_Out2_s1) | (end_xfer_arb_share_counter_term_Out2_s1 & ~Out2_s1_non_bursting_master_requests))
          Out2_s1_slavearbiterlockenable <= |Out2_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master Out2/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = Out2_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //Out2_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign Out2_s1_slavearbiterlockenable2 = |Out2_s1_arb_share_counter_next_value;

  //cpu_0/data_master Out2/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = Out2_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //Out2_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign Out2_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_Out2_s1 = cpu_0_data_master_requests_Out2_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //Out2_s1_writedata mux, which is an e_mux
  assign Out2_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_Out2_s1 = cpu_0_data_master_qualified_request_Out2_s1;

  //cpu_0/data_master saved-grant Out2/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_Out2_s1 = cpu_0_data_master_requests_Out2_s1;

  //allow new arb cycle for Out2/s1, which is an e_assign
  assign Out2_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign Out2_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign Out2_s1_master_qreq_vector = 1;

  //Out2_s1_reset_n assignment, which is an e_assign
  assign Out2_s1_reset_n = reset_n;

  assign Out2_s1_chipselect = cpu_0_data_master_granted_Out2_s1;
  //Out2_s1_firsttransfer first transaction, which is an e_assign
  assign Out2_s1_firsttransfer = ~(Out2_s1_slavearbiterlockenable & Out2_s1_any_continuerequest);

  //Out2_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign Out2_s1_beginbursttransfer_internal = Out2_s1_begins_xfer;

  //~Out2_s1_write_n assignment, which is an e_mux
  assign Out2_s1_write_n = ~(cpu_0_data_master_granted_Out2_s1 & cpu_0_data_master_write);

  assign shifted_address_to_Out2_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //Out2_s1_address mux, which is an e_mux
  assign Out2_s1_address = shifted_address_to_Out2_s1_from_cpu_0_data_master >> 2;

  //d1_Out2_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_Out2_s1_end_xfer <= 1;
      else if (1)
          d1_Out2_s1_end_xfer <= Out2_s1_end_xfer;
    end


  //Out2_s1_waits_for_read in a cycle, which is an e_mux
  assign Out2_s1_waits_for_read = Out2_s1_in_a_read_cycle & Out2_s1_begins_xfer;

  //Out2_s1_in_a_read_cycle assignment, which is an e_assign
  assign Out2_s1_in_a_read_cycle = cpu_0_data_master_granted_Out2_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = Out2_s1_in_a_read_cycle;

  //Out2_s1_waits_for_write in a cycle, which is an e_mux
  assign Out2_s1_waits_for_write = Out2_s1_in_a_write_cycle & 0;

  //Out2_s1_in_a_write_cycle assignment, which is an e_assign
  assign Out2_s1_in_a_write_cycle = cpu_0_data_master_granted_Out2_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = Out2_s1_in_a_write_cycle;

  assign wait_for_Out2_s1_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module Out3_s1_arbitrator (
                            // inputs:
                             clk,
                             cpu_0_data_master_address_to_slave,
                             cpu_0_data_master_read,
                             cpu_0_data_master_waitrequest,
                             cpu_0_data_master_write,
                             cpu_0_data_master_writedata,
                             reset_n,

                            // outputs:
                             Out3_s1_address,
                             Out3_s1_chipselect,
                             Out3_s1_reset_n,
                             Out3_s1_write_n,
                             Out3_s1_writedata,
                             cpu_0_data_master_granted_Out3_s1,
                             cpu_0_data_master_qualified_request_Out3_s1,
                             cpu_0_data_master_read_data_valid_Out3_s1,
                             cpu_0_data_master_requests_Out3_s1,
                             d1_Out3_s1_end_xfer
                          )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] Out3_s1_address;
  output           Out3_s1_chipselect;
  output           Out3_s1_reset_n;
  output           Out3_s1_write_n;
  output  [  9: 0] Out3_s1_writedata;
  output           cpu_0_data_master_granted_Out3_s1;
  output           cpu_0_data_master_qualified_request_Out3_s1;
  output           cpu_0_data_master_read_data_valid_Out3_s1;
  output           cpu_0_data_master_requests_Out3_s1;
  output           d1_Out3_s1_end_xfer;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] Out3_s1_address;
  wire             Out3_s1_allgrants;
  wire             Out3_s1_allow_new_arb_cycle;
  wire             Out3_s1_any_bursting_master_saved_grant;
  wire             Out3_s1_any_continuerequest;
  wire             Out3_s1_arb_counter_enable;
  reg     [  1: 0] Out3_s1_arb_share_counter;
  wire    [  1: 0] Out3_s1_arb_share_counter_next_value;
  wire    [  1: 0] Out3_s1_arb_share_set_values;
  wire             Out3_s1_beginbursttransfer_internal;
  wire             Out3_s1_begins_xfer;
  wire             Out3_s1_chipselect;
  wire             Out3_s1_end_xfer;
  wire             Out3_s1_firsttransfer;
  wire             Out3_s1_grant_vector;
  wire             Out3_s1_in_a_read_cycle;
  wire             Out3_s1_in_a_write_cycle;
  wire             Out3_s1_master_qreq_vector;
  wire             Out3_s1_non_bursting_master_requests;
  wire             Out3_s1_reset_n;
  reg              Out3_s1_slavearbiterlockenable;
  wire             Out3_s1_slavearbiterlockenable2;
  wire             Out3_s1_waits_for_read;
  wire             Out3_s1_waits_for_write;
  wire             Out3_s1_write_n;
  wire    [  9: 0] Out3_s1_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_Out3_s1;
  wire             cpu_0_data_master_qualified_request_Out3_s1;
  wire             cpu_0_data_master_read_data_valid_Out3_s1;
  wire             cpu_0_data_master_requests_Out3_s1;
  wire             cpu_0_data_master_saved_grant_Out3_s1;
  reg              d1_Out3_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_Out3_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 19: 0] shifted_address_to_Out3_s1_from_cpu_0_data_master;
  wire             wait_for_Out3_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~Out3_s1_end_xfer;
    end


  assign Out3_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_Out3_s1));
  assign cpu_0_data_master_requests_Out3_s1 = (({cpu_0_data_master_address_to_slave[19 : 4] , 4'b0} == 20'h8a0) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_write;
  //Out3_s1_arb_share_counter set values, which is an e_mux
  assign Out3_s1_arb_share_set_values = 1;

  //Out3_s1_non_bursting_master_requests mux, which is an e_mux
  assign Out3_s1_non_bursting_master_requests = cpu_0_data_master_requests_Out3_s1;

  //Out3_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign Out3_s1_any_bursting_master_saved_grant = 0;

  //Out3_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign Out3_s1_arb_share_counter_next_value = Out3_s1_firsttransfer ? (Out3_s1_arb_share_set_values - 1) : |Out3_s1_arb_share_counter ? (Out3_s1_arb_share_counter - 1) : 0;

  //Out3_s1_allgrants all slave grants, which is an e_mux
  assign Out3_s1_allgrants = |Out3_s1_grant_vector;

  //Out3_s1_end_xfer assignment, which is an e_assign
  assign Out3_s1_end_xfer = ~(Out3_s1_waits_for_read | Out3_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_Out3_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_Out3_s1 = Out3_s1_end_xfer & (~Out3_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //Out3_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign Out3_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_Out3_s1 & Out3_s1_allgrants) | (end_xfer_arb_share_counter_term_Out3_s1 & ~Out3_s1_non_bursting_master_requests);

  //Out3_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Out3_s1_arb_share_counter <= 0;
      else if (Out3_s1_arb_counter_enable)
          Out3_s1_arb_share_counter <= Out3_s1_arb_share_counter_next_value;
    end


  //Out3_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Out3_s1_slavearbiterlockenable <= 0;
      else if ((|Out3_s1_master_qreq_vector & end_xfer_arb_share_counter_term_Out3_s1) | (end_xfer_arb_share_counter_term_Out3_s1 & ~Out3_s1_non_bursting_master_requests))
          Out3_s1_slavearbiterlockenable <= |Out3_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master Out3/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = Out3_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //Out3_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign Out3_s1_slavearbiterlockenable2 = |Out3_s1_arb_share_counter_next_value;

  //cpu_0/data_master Out3/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = Out3_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //Out3_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign Out3_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_Out3_s1 = cpu_0_data_master_requests_Out3_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //Out3_s1_writedata mux, which is an e_mux
  assign Out3_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_Out3_s1 = cpu_0_data_master_qualified_request_Out3_s1;

  //cpu_0/data_master saved-grant Out3/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_Out3_s1 = cpu_0_data_master_requests_Out3_s1;

  //allow new arb cycle for Out3/s1, which is an e_assign
  assign Out3_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign Out3_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign Out3_s1_master_qreq_vector = 1;

  //Out3_s1_reset_n assignment, which is an e_assign
  assign Out3_s1_reset_n = reset_n;

  assign Out3_s1_chipselect = cpu_0_data_master_granted_Out3_s1;
  //Out3_s1_firsttransfer first transaction, which is an e_assign
  assign Out3_s1_firsttransfer = ~(Out3_s1_slavearbiterlockenable & Out3_s1_any_continuerequest);

  //Out3_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign Out3_s1_beginbursttransfer_internal = Out3_s1_begins_xfer;

  //~Out3_s1_write_n assignment, which is an e_mux
  assign Out3_s1_write_n = ~(cpu_0_data_master_granted_Out3_s1 & cpu_0_data_master_write);

  assign shifted_address_to_Out3_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //Out3_s1_address mux, which is an e_mux
  assign Out3_s1_address = shifted_address_to_Out3_s1_from_cpu_0_data_master >> 2;

  //d1_Out3_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_Out3_s1_end_xfer <= 1;
      else if (1)
          d1_Out3_s1_end_xfer <= Out3_s1_end_xfer;
    end


  //Out3_s1_waits_for_read in a cycle, which is an e_mux
  assign Out3_s1_waits_for_read = Out3_s1_in_a_read_cycle & Out3_s1_begins_xfer;

  //Out3_s1_in_a_read_cycle assignment, which is an e_assign
  assign Out3_s1_in_a_read_cycle = cpu_0_data_master_granted_Out3_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = Out3_s1_in_a_read_cycle;

  //Out3_s1_waits_for_write in a cycle, which is an e_mux
  assign Out3_s1_waits_for_write = Out3_s1_in_a_write_cycle & 0;

  //Out3_s1_in_a_write_cycle assignment, which is an e_assign
  assign Out3_s1_in_a_write_cycle = cpu_0_data_master_granted_Out3_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = Out3_s1_in_a_write_cycle;

  assign wait_for_Out3_s1_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module Out4_s1_arbitrator (
                            // inputs:
                             clk,
                             cpu_0_data_master_address_to_slave,
                             cpu_0_data_master_read,
                             cpu_0_data_master_waitrequest,
                             cpu_0_data_master_write,
                             cpu_0_data_master_writedata,
                             reset_n,

                            // outputs:
                             Out4_s1_address,
                             Out4_s1_chipselect,
                             Out4_s1_reset_n,
                             Out4_s1_write_n,
                             Out4_s1_writedata,
                             cpu_0_data_master_granted_Out4_s1,
                             cpu_0_data_master_qualified_request_Out4_s1,
                             cpu_0_data_master_read_data_valid_Out4_s1,
                             cpu_0_data_master_requests_Out4_s1,
                             d1_Out4_s1_end_xfer
                          )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] Out4_s1_address;
  output           Out4_s1_chipselect;
  output           Out4_s1_reset_n;
  output           Out4_s1_write_n;
  output  [  9: 0] Out4_s1_writedata;
  output           cpu_0_data_master_granted_Out4_s1;
  output           cpu_0_data_master_qualified_request_Out4_s1;
  output           cpu_0_data_master_read_data_valid_Out4_s1;
  output           cpu_0_data_master_requests_Out4_s1;
  output           d1_Out4_s1_end_xfer;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] Out4_s1_address;
  wire             Out4_s1_allgrants;
  wire             Out4_s1_allow_new_arb_cycle;
  wire             Out4_s1_any_bursting_master_saved_grant;
  wire             Out4_s1_any_continuerequest;
  wire             Out4_s1_arb_counter_enable;
  reg     [  1: 0] Out4_s1_arb_share_counter;
  wire    [  1: 0] Out4_s1_arb_share_counter_next_value;
  wire    [  1: 0] Out4_s1_arb_share_set_values;
  wire             Out4_s1_beginbursttransfer_internal;
  wire             Out4_s1_begins_xfer;
  wire             Out4_s1_chipselect;
  wire             Out4_s1_end_xfer;
  wire             Out4_s1_firsttransfer;
  wire             Out4_s1_grant_vector;
  wire             Out4_s1_in_a_read_cycle;
  wire             Out4_s1_in_a_write_cycle;
  wire             Out4_s1_master_qreq_vector;
  wire             Out4_s1_non_bursting_master_requests;
  wire             Out4_s1_reset_n;
  reg              Out4_s1_slavearbiterlockenable;
  wire             Out4_s1_slavearbiterlockenable2;
  wire             Out4_s1_waits_for_read;
  wire             Out4_s1_waits_for_write;
  wire             Out4_s1_write_n;
  wire    [  9: 0] Out4_s1_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_Out4_s1;
  wire             cpu_0_data_master_qualified_request_Out4_s1;
  wire             cpu_0_data_master_read_data_valid_Out4_s1;
  wire             cpu_0_data_master_requests_Out4_s1;
  wire             cpu_0_data_master_saved_grant_Out4_s1;
  reg              d1_Out4_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_Out4_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 19: 0] shifted_address_to_Out4_s1_from_cpu_0_data_master;
  wire             wait_for_Out4_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~Out4_s1_end_xfer;
    end


  assign Out4_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_Out4_s1));
  assign cpu_0_data_master_requests_Out4_s1 = (({cpu_0_data_master_address_to_slave[19 : 4] , 4'b0} == 20'h8b0) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_write;
  //Out4_s1_arb_share_counter set values, which is an e_mux
  assign Out4_s1_arb_share_set_values = 1;

  //Out4_s1_non_bursting_master_requests mux, which is an e_mux
  assign Out4_s1_non_bursting_master_requests = cpu_0_data_master_requests_Out4_s1;

  //Out4_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign Out4_s1_any_bursting_master_saved_grant = 0;

  //Out4_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign Out4_s1_arb_share_counter_next_value = Out4_s1_firsttransfer ? (Out4_s1_arb_share_set_values - 1) : |Out4_s1_arb_share_counter ? (Out4_s1_arb_share_counter - 1) : 0;

  //Out4_s1_allgrants all slave grants, which is an e_mux
  assign Out4_s1_allgrants = |Out4_s1_grant_vector;

  //Out4_s1_end_xfer assignment, which is an e_assign
  assign Out4_s1_end_xfer = ~(Out4_s1_waits_for_read | Out4_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_Out4_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_Out4_s1 = Out4_s1_end_xfer & (~Out4_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //Out4_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign Out4_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_Out4_s1 & Out4_s1_allgrants) | (end_xfer_arb_share_counter_term_Out4_s1 & ~Out4_s1_non_bursting_master_requests);

  //Out4_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Out4_s1_arb_share_counter <= 0;
      else if (Out4_s1_arb_counter_enable)
          Out4_s1_arb_share_counter <= Out4_s1_arb_share_counter_next_value;
    end


  //Out4_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Out4_s1_slavearbiterlockenable <= 0;
      else if ((|Out4_s1_master_qreq_vector & end_xfer_arb_share_counter_term_Out4_s1) | (end_xfer_arb_share_counter_term_Out4_s1 & ~Out4_s1_non_bursting_master_requests))
          Out4_s1_slavearbiterlockenable <= |Out4_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master Out4/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = Out4_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //Out4_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign Out4_s1_slavearbiterlockenable2 = |Out4_s1_arb_share_counter_next_value;

  //cpu_0/data_master Out4/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = Out4_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //Out4_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign Out4_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_Out4_s1 = cpu_0_data_master_requests_Out4_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //Out4_s1_writedata mux, which is an e_mux
  assign Out4_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_Out4_s1 = cpu_0_data_master_qualified_request_Out4_s1;

  //cpu_0/data_master saved-grant Out4/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_Out4_s1 = cpu_0_data_master_requests_Out4_s1;

  //allow new arb cycle for Out4/s1, which is an e_assign
  assign Out4_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign Out4_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign Out4_s1_master_qreq_vector = 1;

  //Out4_s1_reset_n assignment, which is an e_assign
  assign Out4_s1_reset_n = reset_n;

  assign Out4_s1_chipselect = cpu_0_data_master_granted_Out4_s1;
  //Out4_s1_firsttransfer first transaction, which is an e_assign
  assign Out4_s1_firsttransfer = ~(Out4_s1_slavearbiterlockenable & Out4_s1_any_continuerequest);

  //Out4_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign Out4_s1_beginbursttransfer_internal = Out4_s1_begins_xfer;

  //~Out4_s1_write_n assignment, which is an e_mux
  assign Out4_s1_write_n = ~(cpu_0_data_master_granted_Out4_s1 & cpu_0_data_master_write);

  assign shifted_address_to_Out4_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //Out4_s1_address mux, which is an e_mux
  assign Out4_s1_address = shifted_address_to_Out4_s1_from_cpu_0_data_master >> 2;

  //d1_Out4_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_Out4_s1_end_xfer <= 1;
      else if (1)
          d1_Out4_s1_end_xfer <= Out4_s1_end_xfer;
    end


  //Out4_s1_waits_for_read in a cycle, which is an e_mux
  assign Out4_s1_waits_for_read = Out4_s1_in_a_read_cycle & Out4_s1_begins_xfer;

  //Out4_s1_in_a_read_cycle assignment, which is an e_assign
  assign Out4_s1_in_a_read_cycle = cpu_0_data_master_granted_Out4_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = Out4_s1_in_a_read_cycle;

  //Out4_s1_waits_for_write in a cycle, which is an e_mux
  assign Out4_s1_waits_for_write = Out4_s1_in_a_write_cycle & 0;

  //Out4_s1_in_a_write_cycle assignment, which is an e_assign
  assign Out4_s1_in_a_write_cycle = cpu_0_data_master_granted_Out4_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = Out4_s1_in_a_write_cycle;

  assign wait_for_Out4_s1_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_jtag_debug_module_arbitrator (
                                            // inputs:
                                             clk,
                                             cpu_0_data_master_address_to_slave,
                                             cpu_0_data_master_byteenable,
                                             cpu_0_data_master_debugaccess,
                                             cpu_0_data_master_read,
                                             cpu_0_data_master_write,
                                             cpu_0_data_master_writedata,
                                             cpu_0_instruction_master_address_to_slave,
                                             cpu_0_instruction_master_latency_counter,
                                             cpu_0_instruction_master_read,
                                             cpu_0_jtag_debug_module_readdata,
                                             cpu_0_jtag_debug_module_resetrequest,
                                             reset_n,

                                            // outputs:
                                             cpu_0_data_master_granted_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_requests_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
                                             cpu_0_jtag_debug_module_address,
                                             cpu_0_jtag_debug_module_begintransfer,
                                             cpu_0_jtag_debug_module_byteenable,
                                             cpu_0_jtag_debug_module_chipselect,
                                             cpu_0_jtag_debug_module_debugaccess,
                                             cpu_0_jtag_debug_module_readdata_from_sa,
                                             cpu_0_jtag_debug_module_reset,
                                             cpu_0_jtag_debug_module_reset_n,
                                             cpu_0_jtag_debug_module_resetrequest_from_sa,
                                             cpu_0_jtag_debug_module_write,
                                             cpu_0_jtag_debug_module_writedata,
                                             d1_cpu_0_jtag_debug_module_end_xfer
                                          )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output           cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  output  [  8: 0] cpu_0_jtag_debug_module_address;
  output           cpu_0_jtag_debug_module_begintransfer;
  output  [  3: 0] cpu_0_jtag_debug_module_byteenable;
  output           cpu_0_jtag_debug_module_chipselect;
  output           cpu_0_jtag_debug_module_debugaccess;
  output  [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  output           cpu_0_jtag_debug_module_reset;
  output           cpu_0_jtag_debug_module_reset_n;
  output           cpu_0_jtag_debug_module_resetrequest_from_sa;
  output           cpu_0_jtag_debug_module_write;
  output  [ 31: 0] cpu_0_jtag_debug_module_writedata;
  output           d1_cpu_0_jtag_debug_module_end_xfer;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input            cpu_0_data_master_debugaccess;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 19: 0] cpu_0_instruction_master_address_to_slave;
  input            cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata;
  input            cpu_0_jtag_debug_module_resetrequest;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module;
  wire    [  8: 0] cpu_0_jtag_debug_module_address;
  wire             cpu_0_jtag_debug_module_allgrants;
  wire             cpu_0_jtag_debug_module_allow_new_arb_cycle;
  wire             cpu_0_jtag_debug_module_any_bursting_master_saved_grant;
  wire             cpu_0_jtag_debug_module_any_continuerequest;
  reg     [  1: 0] cpu_0_jtag_debug_module_arb_addend;
  wire             cpu_0_jtag_debug_module_arb_counter_enable;
  reg     [  1: 0] cpu_0_jtag_debug_module_arb_share_counter;
  wire    [  1: 0] cpu_0_jtag_debug_module_arb_share_counter_next_value;
  wire    [  1: 0] cpu_0_jtag_debug_module_arb_share_set_values;
  wire    [  1: 0] cpu_0_jtag_debug_module_arb_winner;
  wire             cpu_0_jtag_debug_module_arbitration_holdoff_internal;
  wire             cpu_0_jtag_debug_module_beginbursttransfer_internal;
  wire             cpu_0_jtag_debug_module_begins_xfer;
  wire             cpu_0_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_0_jtag_debug_module_byteenable;
  wire             cpu_0_jtag_debug_module_chipselect;
  wire    [  3: 0] cpu_0_jtag_debug_module_chosen_master_double_vector;
  wire    [  1: 0] cpu_0_jtag_debug_module_chosen_master_rot_left;
  wire             cpu_0_jtag_debug_module_debugaccess;
  wire             cpu_0_jtag_debug_module_end_xfer;
  wire             cpu_0_jtag_debug_module_firsttransfer;
  wire    [  1: 0] cpu_0_jtag_debug_module_grant_vector;
  wire             cpu_0_jtag_debug_module_in_a_read_cycle;
  wire             cpu_0_jtag_debug_module_in_a_write_cycle;
  wire    [  1: 0] cpu_0_jtag_debug_module_master_qreq_vector;
  wire             cpu_0_jtag_debug_module_non_bursting_master_requests;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  wire             cpu_0_jtag_debug_module_reset;
  wire             cpu_0_jtag_debug_module_reset_n;
  wire             cpu_0_jtag_debug_module_resetrequest_from_sa;
  reg     [  1: 0] cpu_0_jtag_debug_module_saved_chosen_master_vector;
  reg              cpu_0_jtag_debug_module_slavearbiterlockenable;
  wire             cpu_0_jtag_debug_module_slavearbiterlockenable2;
  wire             cpu_0_jtag_debug_module_waits_for_read;
  wire             cpu_0_jtag_debug_module_waits_for_write;
  wire             cpu_0_jtag_debug_module_write;
  wire    [ 31: 0] cpu_0_jtag_debug_module_writedata;
  reg              d1_cpu_0_jtag_debug_module_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module;
  wire    [ 19: 0] shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master;
  wire    [ 19: 0] shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master;
  wire             wait_for_cpu_0_jtag_debug_module_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~cpu_0_jtag_debug_module_end_xfer;
    end


  assign cpu_0_jtag_debug_module_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module));
  //assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata;

  assign cpu_0_data_master_requests_cpu_0_jtag_debug_module = ({cpu_0_data_master_address_to_slave[19 : 11] , 11'b0} == 20'h0) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //cpu_0_jtag_debug_module_arb_share_counter set values, which is an e_mux
  assign cpu_0_jtag_debug_module_arb_share_set_values = 1;

  //cpu_0_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  assign cpu_0_jtag_debug_module_non_bursting_master_requests = cpu_0_data_master_requests_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_requests_cpu_0_jtag_debug_module |
    cpu_0_data_master_requests_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  assign cpu_0_jtag_debug_module_any_bursting_master_saved_grant = 0;

  //cpu_0_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_arb_share_counter_next_value = cpu_0_jtag_debug_module_firsttransfer ? (cpu_0_jtag_debug_module_arb_share_set_values - 1) : |cpu_0_jtag_debug_module_arb_share_counter ? (cpu_0_jtag_debug_module_arb_share_counter - 1) : 0;

  //cpu_0_jtag_debug_module_allgrants all slave grants, which is an e_mux
  assign cpu_0_jtag_debug_module_allgrants = |cpu_0_jtag_debug_module_grant_vector |
    |cpu_0_jtag_debug_module_grant_vector |
    |cpu_0_jtag_debug_module_grant_vector |
    |cpu_0_jtag_debug_module_grant_vector;

  //cpu_0_jtag_debug_module_end_xfer assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_end_xfer = ~(cpu_0_jtag_debug_module_waits_for_read | cpu_0_jtag_debug_module_waits_for_write);

  //end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_end_xfer & (~cpu_0_jtag_debug_module_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //cpu_0_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  assign cpu_0_jtag_debug_module_arb_counter_enable = (end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module & cpu_0_jtag_debug_module_allgrants) | (end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module & ~cpu_0_jtag_debug_module_non_bursting_master_requests);

  //cpu_0_jtag_debug_module_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_arb_share_counter <= 0;
      else if (cpu_0_jtag_debug_module_arb_counter_enable)
          cpu_0_jtag_debug_module_arb_share_counter <= cpu_0_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu_0_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_slavearbiterlockenable <= 0;
      else if ((|cpu_0_jtag_debug_module_master_qreq_vector & end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module) | (end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module & ~cpu_0_jtag_debug_module_non_bursting_master_requests))
          cpu_0_jtag_debug_module_slavearbiterlockenable <= |cpu_0_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu_0/data_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //cpu_0_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cpu_0_jtag_debug_module_slavearbiterlockenable2 = |cpu_0_jtag_debug_module_arb_share_counter_next_value;

  //cpu_0/data_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = cpu_0_jtag_debug_module_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = cpu_0_jtag_debug_module_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted cpu_0/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= 0;
      else if (1)
          last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module ? 1 : (cpu_0_jtag_debug_module_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module & cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  assign cpu_0_jtag_debug_module_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module = cpu_0_data_master_requests_cpu_0_jtag_debug_module & ~(cpu_0_instruction_master_arbiterlock);
  //cpu_0_jtag_debug_module_writedata mux, which is an e_mux
  assign cpu_0_jtag_debug_module_writedata = cpu_0_data_master_writedata;

  //mux cpu_0_jtag_debug_module_debugaccess, which is an e_mux
  assign cpu_0_jtag_debug_module_debugaccess = cpu_0_data_master_debugaccess;

  assign cpu_0_instruction_master_requests_cpu_0_jtag_debug_module = (({cpu_0_instruction_master_address_to_slave[19 : 11] , 11'b0} == 20'h0) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted cpu_0/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= 0;
      else if (1)
          last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module ? 1 : (cpu_0_jtag_debug_module_arbitration_holdoff_internal | ~cpu_0_data_master_requests_cpu_0_jtag_debug_module) ? 0 : last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module & cpu_0_data_master_requests_cpu_0_jtag_debug_module;

  assign cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module = cpu_0_instruction_master_requests_cpu_0_jtag_debug_module & ~((cpu_0_instruction_master_read & ((cpu_0_instruction_master_latency_counter != 0))) | cpu_0_data_master_arbiterlock);
  //local readdatavalid cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module = cpu_0_instruction_master_granted_cpu_0_jtag_debug_module & cpu_0_instruction_master_read & ~cpu_0_jtag_debug_module_waits_for_read;

  //allow new arb cycle for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;

  //cpu_0/instruction_master grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_instruction_master_granted_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_grant_vector[0];

  //cpu_0/instruction_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_arb_winner[0] && cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0/data_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_master_qreq_vector[1] = cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;

  //cpu_0/data_master grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_data_master_granted_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_grant_vector[1];

  //cpu_0/data_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_arb_winner[1] && cpu_0_data_master_requests_cpu_0_jtag_debug_module;

  //cpu_0/jtag_debug_module chosen-master double-vector, which is an e_assign
  assign cpu_0_jtag_debug_module_chosen_master_double_vector = {cpu_0_jtag_debug_module_master_qreq_vector, cpu_0_jtag_debug_module_master_qreq_vector} & ({~cpu_0_jtag_debug_module_master_qreq_vector, ~cpu_0_jtag_debug_module_master_qreq_vector} + cpu_0_jtag_debug_module_arb_addend);

  //stable onehot encoding of arb winner
  assign cpu_0_jtag_debug_module_arb_winner = (cpu_0_jtag_debug_module_allow_new_arb_cycle & | cpu_0_jtag_debug_module_grant_vector) ? cpu_0_jtag_debug_module_grant_vector : cpu_0_jtag_debug_module_saved_chosen_master_vector;

  //saved cpu_0_jtag_debug_module_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_saved_chosen_master_vector <= 0;
      else if (cpu_0_jtag_debug_module_allow_new_arb_cycle)
          cpu_0_jtag_debug_module_saved_chosen_master_vector <= |cpu_0_jtag_debug_module_grant_vector ? cpu_0_jtag_debug_module_grant_vector : cpu_0_jtag_debug_module_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign cpu_0_jtag_debug_module_grant_vector = {(cpu_0_jtag_debug_module_chosen_master_double_vector[1] | cpu_0_jtag_debug_module_chosen_master_double_vector[3]),
    (cpu_0_jtag_debug_module_chosen_master_double_vector[0] | cpu_0_jtag_debug_module_chosen_master_double_vector[2])};

  //cpu_0/jtag_debug_module chosen master rotated left, which is an e_assign
  assign cpu_0_jtag_debug_module_chosen_master_rot_left = (cpu_0_jtag_debug_module_arb_winner << 1) ? (cpu_0_jtag_debug_module_arb_winner << 1) : 1;

  //cpu_0/jtag_debug_module's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_arb_addend <= 1;
      else if (|cpu_0_jtag_debug_module_grant_vector)
          cpu_0_jtag_debug_module_arb_addend <= cpu_0_jtag_debug_module_end_xfer? cpu_0_jtag_debug_module_chosen_master_rot_left : cpu_0_jtag_debug_module_grant_vector;
    end


  assign cpu_0_jtag_debug_module_begintransfer = cpu_0_jtag_debug_module_begins_xfer;
  //assign lhs ~cpu_0_jtag_debug_module_reset of type reset_n to cpu_0_jtag_debug_module_reset_n, which is an e_assign
  assign cpu_0_jtag_debug_module_reset = ~cpu_0_jtag_debug_module_reset_n;

  //cpu_0_jtag_debug_module_reset_n assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_reset_n = reset_n;

  //assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest;

  assign cpu_0_jtag_debug_module_chipselect = cpu_0_data_master_granted_cpu_0_jtag_debug_module | cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  //cpu_0_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  assign cpu_0_jtag_debug_module_firsttransfer = ~(cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_jtag_debug_module_any_continuerequest);

  //cpu_0_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign cpu_0_jtag_debug_module_beginbursttransfer_internal = cpu_0_jtag_debug_module_begins_xfer;

  //cpu_0_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign cpu_0_jtag_debug_module_arbitration_holdoff_internal = cpu_0_jtag_debug_module_begins_xfer & cpu_0_jtag_debug_module_firsttransfer;

  //cpu_0_jtag_debug_module_write assignment, which is an e_mux
  assign cpu_0_jtag_debug_module_write = cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_write;

  assign shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //cpu_0_jtag_debug_module_address mux, which is an e_mux
  assign cpu_0_jtag_debug_module_address = (cpu_0_data_master_granted_cpu_0_jtag_debug_module)? (shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master >> 2) :
    (shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master >> 2);

  assign shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master = cpu_0_instruction_master_address_to_slave;
  //d1_cpu_0_jtag_debug_module_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_cpu_0_jtag_debug_module_end_xfer <= 1;
      else if (1)
          d1_cpu_0_jtag_debug_module_end_xfer <= cpu_0_jtag_debug_module_end_xfer;
    end


  //cpu_0_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  assign cpu_0_jtag_debug_module_waits_for_read = cpu_0_jtag_debug_module_in_a_read_cycle & cpu_0_jtag_debug_module_begins_xfer;

  //cpu_0_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_in_a_read_cycle = (cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cpu_0_jtag_debug_module_in_a_read_cycle;

  //cpu_0_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  assign cpu_0_jtag_debug_module_waits_for_write = cpu_0_jtag_debug_module_in_a_write_cycle & cpu_0_jtag_debug_module_begins_xfer;

  //cpu_0_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_in_a_write_cycle = cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cpu_0_jtag_debug_module_in_a_write_cycle;

  assign wait_for_cpu_0_jtag_debug_module_counter = 0;
  //cpu_0_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  assign cpu_0_jtag_debug_module_byteenable = (cpu_0_data_master_granted_cpu_0_jtag_debug_module)? cpu_0_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_cpu_0_jtag_debug_module + cpu_0_instruction_master_granted_cpu_0_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module + cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_data_master_arbitrator (
                                      // inputs:
                                       In0_s1_readdata_from_sa,
                                       In1_s1_readdata_from_sa,
                                       In2_s1_readdata_from_sa,
                                       clk,
                                       cpu_0_data_master_address,
                                       cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0,
                                       cpu_0_data_master_debugaccess,
                                       cpu_0_data_master_granted_In0_s1,
                                       cpu_0_data_master_granted_In1_s1,
                                       cpu_0_data_master_granted_In2_s1,
                                       cpu_0_data_master_granted_Out0_s1,
                                       cpu_0_data_master_granted_Out1_s1,
                                       cpu_0_data_master_granted_Out2_s1,
                                       cpu_0_data_master_granted_Out3_s1,
                                       cpu_0_data_master_granted_Out4_s1,
                                       cpu_0_data_master_granted_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave,
                                       cpu_0_data_master_granted_lcd_control_slave,
                                       cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0,
                                       cpu_0_data_master_granted_timer_0_s1,
                                       cpu_0_data_master_qualified_request_In0_s1,
                                       cpu_0_data_master_qualified_request_In1_s1,
                                       cpu_0_data_master_qualified_request_In2_s1,
                                       cpu_0_data_master_qualified_request_Out0_s1,
                                       cpu_0_data_master_qualified_request_Out1_s1,
                                       cpu_0_data_master_qualified_request_Out2_s1,
                                       cpu_0_data_master_qualified_request_Out3_s1,
                                       cpu_0_data_master_qualified_request_Out4_s1,
                                       cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
                                       cpu_0_data_master_qualified_request_lcd_control_slave,
                                       cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0,
                                       cpu_0_data_master_qualified_request_timer_0_s1,
                                       cpu_0_data_master_read,
                                       cpu_0_data_master_read_data_valid_In0_s1,
                                       cpu_0_data_master_read_data_valid_In1_s1,
                                       cpu_0_data_master_read_data_valid_In2_s1,
                                       cpu_0_data_master_read_data_valid_Out0_s1,
                                       cpu_0_data_master_read_data_valid_Out1_s1,
                                       cpu_0_data_master_read_data_valid_Out2_s1,
                                       cpu_0_data_master_read_data_valid_Out3_s1,
                                       cpu_0_data_master_read_data_valid_Out4_s1,
                                       cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
                                       cpu_0_data_master_read_data_valid_lcd_control_slave,
                                       cpu_0_data_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0,
                                       cpu_0_data_master_read_data_valid_timer_0_s1,
                                       cpu_0_data_master_requests_In0_s1,
                                       cpu_0_data_master_requests_In1_s1,
                                       cpu_0_data_master_requests_In2_s1,
                                       cpu_0_data_master_requests_Out0_s1,
                                       cpu_0_data_master_requests_Out1_s1,
                                       cpu_0_data_master_requests_Out2_s1,
                                       cpu_0_data_master_requests_Out3_s1,
                                       cpu_0_data_master_requests_Out4_s1,
                                       cpu_0_data_master_requests_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave,
                                       cpu_0_data_master_requests_lcd_control_slave,
                                       cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0,
                                       cpu_0_data_master_requests_timer_0_s1,
                                       cpu_0_data_master_write,
                                       cpu_0_data_master_writedata,
                                       cpu_0_jtag_debug_module_readdata_from_sa,
                                       d1_In0_s1_end_xfer,
                                       d1_In1_s1_end_xfer,
                                       d1_In2_s1_end_xfer,
                                       d1_Out0_s1_end_xfer,
                                       d1_Out1_s1_end_xfer,
                                       d1_Out2_s1_end_xfer,
                                       d1_Out3_s1_end_xfer,
                                       d1_Out4_s1_end_xfer,
                                       d1_cpu_0_jtag_debug_module_end_xfer,
                                       d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                       d1_lcd_control_slave_end_xfer,
                                       d1_sram_16bit_512k_0_avalon_slave_0_end_xfer,
                                       d1_timer_0_s1_end_xfer,
                                       jtag_uart_avalon_jtag_slave_irq_from_sa,
                                       jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                       jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                       lcd_control_slave_readdata_from_sa,
                                       lcd_control_slave_wait_counter_eq_0,
                                       lcd_control_slave_wait_counter_eq_1,
                                       reset_n,
                                       sram_16bit_512k_0_avalon_slave_0_readdata_from_sa,
                                       sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0,
                                       timer_0_s1_irq_from_sa,
                                       timer_0_s1_readdata_from_sa,

                                      // outputs:
                                       cpu_0_data_master_address_to_slave,
                                       cpu_0_data_master_dbs_address,
                                       cpu_0_data_master_dbs_write_16,
                                       cpu_0_data_master_irq,
                                       cpu_0_data_master_no_byte_enables_and_last_term,
                                       cpu_0_data_master_readdata,
                                       cpu_0_data_master_waitrequest
                                    )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [ 19: 0] cpu_0_data_master_address_to_slave;
  output  [  1: 0] cpu_0_data_master_dbs_address;
  output  [ 15: 0] cpu_0_data_master_dbs_write_16;
  output  [ 31: 0] cpu_0_data_master_irq;
  output           cpu_0_data_master_no_byte_enables_and_last_term;
  output  [ 31: 0] cpu_0_data_master_readdata;
  output           cpu_0_data_master_waitrequest;
  input   [ 15: 0] In0_s1_readdata_from_sa;
  input   [ 15: 0] In1_s1_readdata_from_sa;
  input   [ 15: 0] In2_s1_readdata_from_sa;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address;
  input   [  1: 0] cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0;
  input            cpu_0_data_master_debugaccess;
  input            cpu_0_data_master_granted_In0_s1;
  input            cpu_0_data_master_granted_In1_s1;
  input            cpu_0_data_master_granted_In2_s1;
  input            cpu_0_data_master_granted_Out0_s1;
  input            cpu_0_data_master_granted_Out1_s1;
  input            cpu_0_data_master_granted_Out2_s1;
  input            cpu_0_data_master_granted_Out3_s1;
  input            cpu_0_data_master_granted_Out4_s1;
  input            cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave;
  input            cpu_0_data_master_granted_lcd_control_slave;
  input            cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0;
  input            cpu_0_data_master_granted_timer_0_s1;
  input            cpu_0_data_master_qualified_request_In0_s1;
  input            cpu_0_data_master_qualified_request_In1_s1;
  input            cpu_0_data_master_qualified_request_In2_s1;
  input            cpu_0_data_master_qualified_request_Out0_s1;
  input            cpu_0_data_master_qualified_request_Out1_s1;
  input            cpu_0_data_master_qualified_request_Out2_s1;
  input            cpu_0_data_master_qualified_request_Out3_s1;
  input            cpu_0_data_master_qualified_request_Out4_s1;
  input            cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  input            cpu_0_data_master_qualified_request_lcd_control_slave;
  input            cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0;
  input            cpu_0_data_master_qualified_request_timer_0_s1;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_In0_s1;
  input            cpu_0_data_master_read_data_valid_In1_s1;
  input            cpu_0_data_master_read_data_valid_In2_s1;
  input            cpu_0_data_master_read_data_valid_Out0_s1;
  input            cpu_0_data_master_read_data_valid_Out1_s1;
  input            cpu_0_data_master_read_data_valid_Out2_s1;
  input            cpu_0_data_master_read_data_valid_Out3_s1;
  input            cpu_0_data_master_read_data_valid_Out4_s1;
  input            cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  input            cpu_0_data_master_read_data_valid_lcd_control_slave;
  input            cpu_0_data_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0;
  input            cpu_0_data_master_read_data_valid_timer_0_s1;
  input            cpu_0_data_master_requests_In0_s1;
  input            cpu_0_data_master_requests_In1_s1;
  input            cpu_0_data_master_requests_In2_s1;
  input            cpu_0_data_master_requests_Out0_s1;
  input            cpu_0_data_master_requests_Out1_s1;
  input            cpu_0_data_master_requests_Out2_s1;
  input            cpu_0_data_master_requests_Out3_s1;
  input            cpu_0_data_master_requests_Out4_s1;
  input            cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave;
  input            cpu_0_data_master_requests_lcd_control_slave;
  input            cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0;
  input            cpu_0_data_master_requests_timer_0_s1;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  input            d1_In0_s1_end_xfer;
  input            d1_In1_s1_end_xfer;
  input            d1_In2_s1_end_xfer;
  input            d1_Out0_s1_end_xfer;
  input            d1_Out1_s1_end_xfer;
  input            d1_Out2_s1_end_xfer;
  input            d1_Out3_s1_end_xfer;
  input            d1_Out4_s1_end_xfer;
  input            d1_cpu_0_jtag_debug_module_end_xfer;
  input            d1_jtag_uart_avalon_jtag_slave_end_xfer;
  input            d1_lcd_control_slave_end_xfer;
  input            d1_sram_16bit_512k_0_avalon_slave_0_end_xfer;
  input            d1_timer_0_s1_end_xfer;
  input            jtag_uart_avalon_jtag_slave_irq_from_sa;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  input            jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  input   [  7: 0] lcd_control_slave_readdata_from_sa;
  input            lcd_control_slave_wait_counter_eq_0;
  input            lcd_control_slave_wait_counter_eq_1;
  input            reset_n;
  input   [ 15: 0] sram_16bit_512k_0_avalon_slave_0_readdata_from_sa;
  input            sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0;
  input            timer_0_s1_irq_from_sa;
  input   [ 15: 0] timer_0_s1_readdata_from_sa;

  wire    [ 19: 0] cpu_0_data_master_address_to_slave;
  reg     [  1: 0] cpu_0_data_master_dbs_address;
  wire    [  1: 0] cpu_0_data_master_dbs_increment;
  wire    [ 15: 0] cpu_0_data_master_dbs_write_16;
  wire    [ 31: 0] cpu_0_data_master_irq;
  reg              cpu_0_data_master_no_byte_enables_and_last_term;
  wire    [ 31: 0] cpu_0_data_master_readdata;
  wire             cpu_0_data_master_run;
  reg              cpu_0_data_master_waitrequest;
  reg     [ 15: 0] dbs_16_reg_segment_0;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  wire             last_dbs_term_and_run;
  wire    [  1: 0] next_dbs_address;
  wire    [ 15: 0] p1_dbs_16_reg_segment_0;
  wire    [ 31: 0] p1_registered_cpu_0_data_master_readdata;
  wire             pre_dbs_count_enable;
  wire             r_0;
  wire             r_1;
  wire             r_2;
  reg     [ 31: 0] registered_cpu_0_data_master_readdata;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~cpu_0_data_master_qualified_request_In0_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_In0_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & ((~cpu_0_data_master_qualified_request_In1_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_In1_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & ((~cpu_0_data_master_qualified_request_In2_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_In2_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_Out0_s1 | ~cpu_0_data_master_requests_Out0_s1) & ((~cpu_0_data_master_qualified_request_Out0_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_Out0_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_Out1_s1 | ~cpu_0_data_master_requests_Out1_s1) & ((~cpu_0_data_master_qualified_request_Out1_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_Out1_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_Out2_s1 | ~cpu_0_data_master_requests_Out2_s1) & ((~cpu_0_data_master_qualified_request_Out2_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign cpu_0_data_master_run = r_0 & r_1 & r_2;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = ((~cpu_0_data_master_qualified_request_Out2_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_Out3_s1 | ~cpu_0_data_master_requests_Out3_s1) & ((~cpu_0_data_master_qualified_request_Out3_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_Out3_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_Out4_s1 | ~cpu_0_data_master_requests_Out4_s1) & ((~cpu_0_data_master_qualified_request_Out4_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_Out4_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_data_master_requests_cpu_0_jtag_debug_module) & (cpu_0_data_master_granted_cpu_0_jtag_debug_module | ~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module) & ((~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave) & ((~cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & ((~cpu_0_data_master_qualified_request_lcd_control_slave | ~cpu_0_data_master_read | (1 & lcd_control_slave_wait_counter_eq_1 & cpu_0_data_master_read)));

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = ((~cpu_0_data_master_qualified_request_lcd_control_slave | ~cpu_0_data_master_write | (1 & lcd_control_slave_wait_counter_eq_1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 | (cpu_0_data_master_write & !cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0 & cpu_0_data_master_dbs_address[1]) | ~cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0) & (cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0 | ~cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0) & ((~cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 | ~cpu_0_data_master_read | (1 & 1 & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 | ~cpu_0_data_master_write | (1 & ~d1_sram_16bit_512k_0_avalon_slave_0_end_xfer & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_timer_0_s1 | ~cpu_0_data_master_requests_timer_0_s1) & ((~cpu_0_data_master_qualified_request_timer_0_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_timer_0_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write)));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_0_data_master_address_to_slave = cpu_0_data_master_address[19 : 0];

  //cpu_0/data_master readdata mux, which is an e_mux
  assign cpu_0_data_master_readdata = ({32 {~cpu_0_data_master_requests_In0_s1}} | In0_s1_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_In1_s1}} | In1_s1_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_In2_s1}} | In2_s1_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_cpu_0_jtag_debug_module}} | cpu_0_jtag_debug_module_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave}} | registered_cpu_0_data_master_readdata) &
    ({32 {~cpu_0_data_master_requests_lcd_control_slave}} | lcd_control_slave_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0}} | {sram_16bit_512k_0_avalon_slave_0_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0}) &
    ({32 {~cpu_0_data_master_requests_timer_0_s1}} | timer_0_s1_readdata_from_sa);

  //actual waitrequest port, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_waitrequest <= ~0;
      else if (1)
          cpu_0_data_master_waitrequest <= ~((~(cpu_0_data_master_read | cpu_0_data_master_write))? 0: (cpu_0_data_master_run & cpu_0_data_master_waitrequest));
    end


  //unpredictable registered wait state incoming data, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          registered_cpu_0_data_master_readdata <= 0;
      else if (1)
          registered_cpu_0_data_master_readdata <= p1_registered_cpu_0_data_master_readdata;
    end


  //registered readdata mux, which is an e_mux
  assign p1_registered_cpu_0_data_master_readdata = {32 {~cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave}} | jtag_uart_avalon_jtag_slave_readdata_from_sa;

  //irq assign, which is an e_assign
  assign cpu_0_data_master_irq = {1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    timer_0_s1_irq_from_sa,
    jtag_uart_avalon_jtag_slave_irq_from_sa};

  //no_byte_enables_and_last_term, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_no_byte_enables_and_last_term <= 0;
      else if (1)
          cpu_0_data_master_no_byte_enables_and_last_term <= last_dbs_term_and_run;
    end


  //compute the last dbs term, which is an e_mux
  assign last_dbs_term_and_run = (cpu_0_data_master_dbs_address == 2'b10) & cpu_0_data_master_write & !cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0;

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (((~cpu_0_data_master_no_byte_enables_and_last_term) & cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0 & cpu_0_data_master_write & !cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0)) |
    (cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0 & cpu_0_data_master_read & 1 & 1 & ~d1_sram_16bit_512k_0_avalon_slave_0_end_xfer) |
    ((cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0 & cpu_0_data_master_write & 1 & 1 & ({sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0 & ~d1_sram_16bit_512k_0_avalon_slave_0_end_xfer})));

  //input to dbs-16 stored 0, which is an e_mux
  assign p1_dbs_16_reg_segment_0 = sram_16bit_512k_0_avalon_slave_0_readdata_from_sa;

  //dbs register for dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_16_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1]) == 0))
          dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
    end


  //mux write dbs 1, which is an e_mux
  assign cpu_0_data_master_dbs_write_16 = (cpu_0_data_master_dbs_address[1])? cpu_0_data_master_writedata[31 : 16] :
    cpu_0_data_master_writedata[15 : 0];

  //dbs count increment, which is an e_mux
  assign cpu_0_data_master_dbs_increment = (cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_0_data_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_0_data_master_dbs_address + cpu_0_data_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_0_data_master_dbs_address <= next_dbs_address;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_instruction_master_arbitrator (
                                             // inputs:
                                              clk,
                                              cpu_0_instruction_master_address,
                                              cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0,
                                              cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0,
                                              cpu_0_instruction_master_read,
                                              cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0,
                                              cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0,
                                              cpu_0_jtag_debug_module_readdata_from_sa,
                                              d1_cpu_0_jtag_debug_module_end_xfer,
                                              d1_sram_16bit_512k_0_avalon_slave_0_end_xfer,
                                              reset_n,
                                              sram_16bit_512k_0_avalon_slave_0_readdata_from_sa,
                                              sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0,

                                             // outputs:
                                              cpu_0_instruction_master_address_to_slave,
                                              cpu_0_instruction_master_dbs_address,
                                              cpu_0_instruction_master_latency_counter,
                                              cpu_0_instruction_master_readdata,
                                              cpu_0_instruction_master_readdatavalid,
                                              cpu_0_instruction_master_waitrequest
                                           )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [ 19: 0] cpu_0_instruction_master_address_to_slave;
  output  [  1: 0] cpu_0_instruction_master_dbs_address;
  output           cpu_0_instruction_master_latency_counter;
  output  [ 31: 0] cpu_0_instruction_master_readdata;
  output           cpu_0_instruction_master_readdatavalid;
  output           cpu_0_instruction_master_waitrequest;
  input            clk;
  input   [ 19: 0] cpu_0_instruction_master_address;
  input            cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0;
  input            cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0;
  input            cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  input            d1_cpu_0_jtag_debug_module_end_xfer;
  input            d1_sram_16bit_512k_0_avalon_slave_0_end_xfer;
  input            reset_n;
  input   [ 15: 0] sram_16bit_512k_0_avalon_slave_0_readdata_from_sa;
  input            sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0;

  reg              active_and_waiting_last_time;
  reg     [ 19: 0] cpu_0_instruction_master_address_last_time;
  wire    [ 19: 0] cpu_0_instruction_master_address_to_slave;
  reg     [  1: 0] cpu_0_instruction_master_dbs_address;
  wire    [  1: 0] cpu_0_instruction_master_dbs_increment;
  wire             cpu_0_instruction_master_is_granted_some_slave;
  reg              cpu_0_instruction_master_latency_counter;
  reg              cpu_0_instruction_master_read_but_no_slave_selected;
  reg              cpu_0_instruction_master_read_last_time;
  wire    [ 31: 0] cpu_0_instruction_master_readdata;
  wire             cpu_0_instruction_master_readdatavalid;
  wire             cpu_0_instruction_master_run;
  wire             cpu_0_instruction_master_waitrequest;
  reg     [ 15: 0] dbs_16_reg_segment_0;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  wire             latency_load_value;
  wire    [  1: 0] next_dbs_address;
  wire             p1_cpu_0_instruction_master_latency_counter;
  wire    [ 15: 0] p1_dbs_16_reg_segment_0;
  wire             pre_dbs_count_enable;
  wire             pre_flush_cpu_0_instruction_master_readdatavalid;
  wire             r_1;
  wire             r_2;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) & (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module | ~cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module) & ((~cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module | ~(cpu_0_instruction_master_read) | (1 & ~d1_cpu_0_jtag_debug_module_end_xfer & (cpu_0_instruction_master_read))));

  //cascaded wait assignment, which is an e_assign
  assign cpu_0_instruction_master_run = r_1 & r_2;

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 | ~cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0) & (cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0 | ~cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0) & ((~cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 | ~cpu_0_instruction_master_read | (1 & ~d1_sram_16bit_512k_0_avalon_slave_0_end_xfer & (cpu_0_instruction_master_dbs_address[1]) & cpu_0_instruction_master_read)));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_0_instruction_master_address_to_slave = cpu_0_instruction_master_address[19 : 0];

  //cpu_0_instruction_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_but_no_slave_selected <= 0;
      else if (1)
          cpu_0_instruction_master_read_but_no_slave_selected <= cpu_0_instruction_master_read & cpu_0_instruction_master_run & ~cpu_0_instruction_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign cpu_0_instruction_master_is_granted_some_slave = cpu_0_instruction_master_granted_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_cpu_0_instruction_master_readdatavalid = 0;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign cpu_0_instruction_master_readdatavalid = cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    (cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0 & dbs_counter_overflow);

  //cpu_0/instruction_master readdata mux, which is an e_mux
  assign cpu_0_instruction_master_readdata = ({32 {~(cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module & cpu_0_instruction_master_read)}} | cpu_0_jtag_debug_module_readdata_from_sa) &
    ({32 {~(cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 & cpu_0_instruction_master_read)}} | {sram_16bit_512k_0_avalon_slave_0_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0});

  //actual waitrequest port, which is an e_assign
  assign cpu_0_instruction_master_waitrequest = ~cpu_0_instruction_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_latency_counter <= 0;
      else if (1)
          cpu_0_instruction_master_latency_counter <= p1_cpu_0_instruction_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_cpu_0_instruction_master_latency_counter = ((cpu_0_instruction_master_run & cpu_0_instruction_master_read))? latency_load_value :
    (cpu_0_instruction_master_latency_counter)? cpu_0_instruction_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;

  //input to dbs-16 stored 0, which is an e_mux
  assign p1_dbs_16_reg_segment_0 = sram_16bit_512k_0_avalon_slave_0_readdata_from_sa;

  //dbs register for dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_16_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((cpu_0_instruction_master_dbs_address[1]) == 0))
          dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
    end


  //dbs count increment, which is an e_mux
  assign cpu_0_instruction_master_dbs_increment = (cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_0_instruction_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_0_instruction_master_dbs_address + cpu_0_instruction_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_0_instruction_master_dbs_address <= next_dbs_address;
    end


  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0 & cpu_0_instruction_master_read & 1 & 1 & ~d1_sram_16bit_512k_0_avalon_slave_0_end_xfer;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_0_instruction_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_address_last_time <= 0;
      else if (1)
          cpu_0_instruction_master_address_last_time <= cpu_0_instruction_master_address;
    end


  //cpu_0/instruction_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else if (1)
          active_and_waiting_last_time <= cpu_0_instruction_master_waitrequest & (cpu_0_instruction_master_read);
    end


  //cpu_0_instruction_master_address matches last port_name, which is an e_process
  always @(active_and_waiting_last_time or cpu_0_instruction_master_address or cpu_0_instruction_master_address_last_time)
    begin
      if (active_and_waiting_last_time & (cpu_0_instruction_master_address != cpu_0_instruction_master_address_last_time))
        begin
          $write("%0d ns: cpu_0_instruction_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_0_instruction_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_last_time <= 0;
      else if (1)
          cpu_0_instruction_master_read_last_time <= cpu_0_instruction_master_read;
    end


  //cpu_0_instruction_master_read matches last port_name, which is an e_process
  always @(active_and_waiting_last_time or cpu_0_instruction_master_read or cpu_0_instruction_master_read_last_time)
    begin
      if (active_and_waiting_last_time & (cpu_0_instruction_master_read != cpu_0_instruction_master_read_last_time))
        begin
          $write("%0d ns: cpu_0_instruction_master_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module jtag_uart_avalon_jtag_slave_arbitrator (
                                                // inputs:
                                                 clk,
                                                 cpu_0_data_master_address_to_slave,
                                                 cpu_0_data_master_read,
                                                 cpu_0_data_master_waitrequest,
                                                 cpu_0_data_master_write,
                                                 cpu_0_data_master_writedata,
                                                 jtag_uart_avalon_jtag_slave_dataavailable,
                                                 jtag_uart_avalon_jtag_slave_irq,
                                                 jtag_uart_avalon_jtag_slave_readdata,
                                                 jtag_uart_avalon_jtag_slave_readyfordata,
                                                 jtag_uart_avalon_jtag_slave_waitrequest,
                                                 reset_n,

                                                // outputs:
                                                 cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave,
                                                 cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
                                                 cpu_0_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
                                                 cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave,
                                                 d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                                 jtag_uart_avalon_jtag_slave_address,
                                                 jtag_uart_avalon_jtag_slave_chipselect,
                                                 jtag_uart_avalon_jtag_slave_dataavailable_from_sa,
                                                 jtag_uart_avalon_jtag_slave_irq_from_sa,
                                                 jtag_uart_avalon_jtag_slave_read_n,
                                                 jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                                 jtag_uart_avalon_jtag_slave_readyfordata_from_sa,
                                                 jtag_uart_avalon_jtag_slave_reset_n,
                                                 jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                                 jtag_uart_avalon_jtag_slave_write_n,
                                                 jtag_uart_avalon_jtag_slave_writedata
                                              )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output           cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave;
  output           cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  output           cpu_0_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  output           cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave;
  output           d1_jtag_uart_avalon_jtag_slave_end_xfer;
  output           jtag_uart_avalon_jtag_slave_address;
  output           jtag_uart_avalon_jtag_slave_chipselect;
  output           jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  output           jtag_uart_avalon_jtag_slave_irq_from_sa;
  output           jtag_uart_avalon_jtag_slave_read_n;
  output  [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  output           jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  output           jtag_uart_avalon_jtag_slave_reset_n;
  output           jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  output           jtag_uart_avalon_jtag_slave_write_n;
  output  [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            jtag_uart_avalon_jtag_slave_dataavailable;
  input            jtag_uart_avalon_jtag_slave_irq;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata;
  input            jtag_uart_avalon_jtag_slave_readyfordata;
  input            jtag_uart_avalon_jtag_slave_waitrequest;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave;
  wire             cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             cpu_0_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire             cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave;
  wire             cpu_0_data_master_saved_grant_jtag_uart_avalon_jtag_slave;
  reg              d1_jtag_uart_avalon_jtag_slave_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             jtag_uart_avalon_jtag_slave_address;
  wire             jtag_uart_avalon_jtag_slave_allgrants;
  wire             jtag_uart_avalon_jtag_slave_allow_new_arb_cycle;
  wire             jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant;
  wire             jtag_uart_avalon_jtag_slave_any_continuerequest;
  wire             jtag_uart_avalon_jtag_slave_arb_counter_enable;
  reg     [  1: 0] jtag_uart_avalon_jtag_slave_arb_share_counter;
  wire    [  1: 0] jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
  wire    [  1: 0] jtag_uart_avalon_jtag_slave_arb_share_set_values;
  wire             jtag_uart_avalon_jtag_slave_beginbursttransfer_internal;
  wire             jtag_uart_avalon_jtag_slave_begins_xfer;
  wire             jtag_uart_avalon_jtag_slave_chipselect;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_end_xfer;
  wire             jtag_uart_avalon_jtag_slave_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_grant_vector;
  wire             jtag_uart_avalon_jtag_slave_in_a_read_cycle;
  wire             jtag_uart_avalon_jtag_slave_in_a_write_cycle;
  wire             jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_avalon_jtag_slave_master_qreq_vector;
  wire             jtag_uart_avalon_jtag_slave_non_bursting_master_requests;
  wire             jtag_uart_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_reset_n;
  reg              jtag_uart_avalon_jtag_slave_slavearbiterlockenable;
  wire             jtag_uart_avalon_jtag_slave_slavearbiterlockenable2;
  wire             jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_avalon_jtag_slave_waits_for_read;
  wire             jtag_uart_avalon_jtag_slave_waits_for_write;
  wire             jtag_uart_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  wire    [ 19: 0] shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_0_data_master;
  wire             wait_for_jtag_uart_avalon_jtag_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~jtag_uart_avalon_jtag_slave_end_xfer;
    end


  assign jtag_uart_avalon_jtag_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave));
  //assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata;

  assign cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave = ({cpu_0_data_master_address_to_slave[19 : 3] , 3'b0} == 20'h800) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable;

  //assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata;

  //assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest;

  //jtag_uart_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_arb_share_set_values = 1;

  //jtag_uart_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_non_bursting_master_requests = cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave;

  //jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant = 0;

  //jtag_uart_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_arb_share_counter_next_value = jtag_uart_avalon_jtag_slave_firsttransfer ? (jtag_uart_avalon_jtag_slave_arb_share_set_values - 1) : |jtag_uart_avalon_jtag_slave_arb_share_counter ? (jtag_uart_avalon_jtag_slave_arb_share_counter - 1) : 0;

  //jtag_uart_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_allgrants = |jtag_uart_avalon_jtag_slave_grant_vector;

  //jtag_uart_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_end_xfer = ~(jtag_uart_avalon_jtag_slave_waits_for_read | jtag_uart_avalon_jtag_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave = jtag_uart_avalon_jtag_slave_end_xfer & (~jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //jtag_uart_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & jtag_uart_avalon_jtag_slave_allgrants) | (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & ~jtag_uart_avalon_jtag_slave_non_bursting_master_requests);

  //jtag_uart_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_arb_share_counter <= 0;
      else if (jtag_uart_avalon_jtag_slave_arb_counter_enable)
          jtag_uart_avalon_jtag_slave_arb_share_counter <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //jtag_uart_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= 0;
      else if ((|jtag_uart_avalon_jtag_slave_master_qreq_vector & end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave) | (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & ~jtag_uart_avalon_jtag_slave_non_bursting_master_requests))
          jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= |jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master jtag_uart/avalon_jtag_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = jtag_uart_avalon_jtag_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 = |jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;

  //cpu_0/data_master jtag_uart/avalon_jtag_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //jtag_uart_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave = cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave & ~((cpu_0_data_master_read & (~cpu_0_data_master_waitrequest)) | ((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //jtag_uart_avalon_jtag_slave_writedata mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave = cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave;

  //cpu_0/data_master saved-grant jtag_uart/avalon_jtag_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_jtag_uart_avalon_jtag_slave = cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave;

  //allow new arb cycle for jtag_uart/avalon_jtag_slave, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign jtag_uart_avalon_jtag_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign jtag_uart_avalon_jtag_slave_master_qreq_vector = 1;

  //jtag_uart_avalon_jtag_slave_reset_n assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_reset_n = reset_n;

  assign jtag_uart_avalon_jtag_slave_chipselect = cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave;
  //jtag_uart_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_firsttransfer = ~(jtag_uart_avalon_jtag_slave_slavearbiterlockenable & jtag_uart_avalon_jtag_slave_any_continuerequest);

  //jtag_uart_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_beginbursttransfer_internal = jtag_uart_avalon_jtag_slave_begins_xfer;

  //~jtag_uart_avalon_jtag_slave_read_n assignment, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_read_n = ~(cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave & cpu_0_data_master_read);

  //~jtag_uart_avalon_jtag_slave_write_n assignment, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_write_n = ~(cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave & cpu_0_data_master_write);

  assign shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //jtag_uart_avalon_jtag_slave_address mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_address = shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_0_data_master >> 2;

  //d1_jtag_uart_avalon_jtag_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_jtag_uart_avalon_jtag_slave_end_xfer <= 1;
      else if (1)
          d1_jtag_uart_avalon_jtag_slave_end_xfer <= jtag_uart_avalon_jtag_slave_end_xfer;
    end


  //jtag_uart_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_waits_for_read = jtag_uart_avalon_jtag_slave_in_a_read_cycle & jtag_uart_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_in_a_read_cycle = cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = jtag_uart_avalon_jtag_slave_in_a_read_cycle;

  //jtag_uart_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_waits_for_write = jtag_uart_avalon_jtag_slave_in_a_write_cycle & jtag_uart_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_in_a_write_cycle = cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = jtag_uart_avalon_jtag_slave_in_a_write_cycle;

  assign wait_for_jtag_uart_avalon_jtag_slave_counter = 0;
  //assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module lcd_control_slave_arbitrator (
                                      // inputs:
                                       clk,
                                       cpu_0_data_master_address_to_slave,
                                       cpu_0_data_master_byteenable,
                                       cpu_0_data_master_read,
                                       cpu_0_data_master_write,
                                       cpu_0_data_master_writedata,
                                       lcd_control_slave_readdata,
                                       reset_n,

                                      // outputs:
                                       cpu_0_data_master_granted_lcd_control_slave,
                                       cpu_0_data_master_qualified_request_lcd_control_slave,
                                       cpu_0_data_master_read_data_valid_lcd_control_slave,
                                       cpu_0_data_master_requests_lcd_control_slave,
                                       d1_lcd_control_slave_end_xfer,
                                       lcd_control_slave_address,
                                       lcd_control_slave_begintransfer,
                                       lcd_control_slave_read,
                                       lcd_control_slave_readdata_from_sa,
                                       lcd_control_slave_wait_counter_eq_0,
                                       lcd_control_slave_wait_counter_eq_1,
                                       lcd_control_slave_write,
                                       lcd_control_slave_writedata
                                    )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output           cpu_0_data_master_granted_lcd_control_slave;
  output           cpu_0_data_master_qualified_request_lcd_control_slave;
  output           cpu_0_data_master_read_data_valid_lcd_control_slave;
  output           cpu_0_data_master_requests_lcd_control_slave;
  output           d1_lcd_control_slave_end_xfer;
  output  [  1: 0] lcd_control_slave_address;
  output           lcd_control_slave_begintransfer;
  output           lcd_control_slave_read;
  output  [  7: 0] lcd_control_slave_readdata_from_sa;
  output           lcd_control_slave_wait_counter_eq_0;
  output           lcd_control_slave_wait_counter_eq_1;
  output           lcd_control_slave_write;
  output  [  7: 0] lcd_control_slave_writedata;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [  7: 0] lcd_control_slave_readdata;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_lcd_control_slave;
  wire             cpu_0_data_master_qualified_request_lcd_control_slave;
  wire             cpu_0_data_master_read_data_valid_lcd_control_slave;
  wire             cpu_0_data_master_requests_lcd_control_slave;
  wire             cpu_0_data_master_saved_grant_lcd_control_slave;
  reg              d1_lcd_control_slave_end_xfer;
  reg              d1_reasons_to_wait;
  wire             end_xfer_arb_share_counter_term_lcd_control_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  1: 0] lcd_control_slave_address;
  wire             lcd_control_slave_allgrants;
  wire             lcd_control_slave_allow_new_arb_cycle;
  wire             lcd_control_slave_any_bursting_master_saved_grant;
  wire             lcd_control_slave_any_continuerequest;
  wire             lcd_control_slave_arb_counter_enable;
  reg     [  1: 0] lcd_control_slave_arb_share_counter;
  wire    [  1: 0] lcd_control_slave_arb_share_counter_next_value;
  wire    [  1: 0] lcd_control_slave_arb_share_set_values;
  wire             lcd_control_slave_beginbursttransfer_internal;
  wire             lcd_control_slave_begins_xfer;
  wire             lcd_control_slave_begintransfer;
  wire    [  5: 0] lcd_control_slave_counter_load_value;
  wire             lcd_control_slave_end_xfer;
  wire             lcd_control_slave_firsttransfer;
  wire             lcd_control_slave_grant_vector;
  wire             lcd_control_slave_in_a_read_cycle;
  wire             lcd_control_slave_in_a_write_cycle;
  wire             lcd_control_slave_master_qreq_vector;
  wire             lcd_control_slave_non_bursting_master_requests;
  wire             lcd_control_slave_pretend_byte_enable;
  wire             lcd_control_slave_read;
  wire    [  7: 0] lcd_control_slave_readdata_from_sa;
  reg              lcd_control_slave_slavearbiterlockenable;
  wire             lcd_control_slave_slavearbiterlockenable2;
  reg     [  5: 0] lcd_control_slave_wait_counter;
  wire             lcd_control_slave_wait_counter_eq_0;
  wire             lcd_control_slave_wait_counter_eq_1;
  wire             lcd_control_slave_waits_for_read;
  wire             lcd_control_slave_waits_for_write;
  wire             lcd_control_slave_write;
  wire    [  7: 0] lcd_control_slave_writedata;
  wire    [ 19: 0] shifted_address_to_lcd_control_slave_from_cpu_0_data_master;
  wire             wait_for_lcd_control_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~lcd_control_slave_end_xfer;
    end


  assign lcd_control_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_lcd_control_slave));
  //assign lcd_control_slave_readdata_from_sa = lcd_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign lcd_control_slave_readdata_from_sa = lcd_control_slave_readdata;

  assign cpu_0_data_master_requests_lcd_control_slave = ({cpu_0_data_master_address_to_slave[19 : 4] , 4'b0} == 20'h810) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //lcd_control_slave_arb_share_counter set values, which is an e_mux
  assign lcd_control_slave_arb_share_set_values = 1;

  //lcd_control_slave_non_bursting_master_requests mux, which is an e_mux
  assign lcd_control_slave_non_bursting_master_requests = cpu_0_data_master_requests_lcd_control_slave;

  //lcd_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign lcd_control_slave_any_bursting_master_saved_grant = 0;

  //lcd_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign lcd_control_slave_arb_share_counter_next_value = lcd_control_slave_firsttransfer ? (lcd_control_slave_arb_share_set_values - 1) : |lcd_control_slave_arb_share_counter ? (lcd_control_slave_arb_share_counter - 1) : 0;

  //lcd_control_slave_allgrants all slave grants, which is an e_mux
  assign lcd_control_slave_allgrants = |lcd_control_slave_grant_vector;

  //lcd_control_slave_end_xfer assignment, which is an e_assign
  assign lcd_control_slave_end_xfer = ~(lcd_control_slave_waits_for_read | lcd_control_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_lcd_control_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_lcd_control_slave = lcd_control_slave_end_xfer & (~lcd_control_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //lcd_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign lcd_control_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_lcd_control_slave & lcd_control_slave_allgrants) | (end_xfer_arb_share_counter_term_lcd_control_slave & ~lcd_control_slave_non_bursting_master_requests);

  //lcd_control_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          lcd_control_slave_arb_share_counter <= 0;
      else if (lcd_control_slave_arb_counter_enable)
          lcd_control_slave_arb_share_counter <= lcd_control_slave_arb_share_counter_next_value;
    end


  //lcd_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          lcd_control_slave_slavearbiterlockenable <= 0;
      else if ((|lcd_control_slave_master_qreq_vector & end_xfer_arb_share_counter_term_lcd_control_slave) | (end_xfer_arb_share_counter_term_lcd_control_slave & ~lcd_control_slave_non_bursting_master_requests))
          lcd_control_slave_slavearbiterlockenable <= |lcd_control_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master lcd/control_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = lcd_control_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //lcd_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign lcd_control_slave_slavearbiterlockenable2 = |lcd_control_slave_arb_share_counter_next_value;

  //cpu_0/data_master lcd/control_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = lcd_control_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //lcd_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign lcd_control_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_lcd_control_slave = cpu_0_data_master_requests_lcd_control_slave;
  //lcd_control_slave_writedata mux, which is an e_mux
  assign lcd_control_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_lcd_control_slave = cpu_0_data_master_qualified_request_lcd_control_slave;

  //cpu_0/data_master saved-grant lcd/control_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_lcd_control_slave = cpu_0_data_master_requests_lcd_control_slave;

  //allow new arb cycle for lcd/control_slave, which is an e_assign
  assign lcd_control_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign lcd_control_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign lcd_control_slave_master_qreq_vector = 1;

  assign lcd_control_slave_begintransfer = lcd_control_slave_begins_xfer;
  //lcd_control_slave_firsttransfer first transaction, which is an e_assign
  assign lcd_control_slave_firsttransfer = ~(lcd_control_slave_slavearbiterlockenable & lcd_control_slave_any_continuerequest);

  //lcd_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign lcd_control_slave_beginbursttransfer_internal = lcd_control_slave_begins_xfer;

  //lcd_control_slave_read assignment, which is an e_mux
  assign lcd_control_slave_read = ((cpu_0_data_master_granted_lcd_control_slave & cpu_0_data_master_read))& ~lcd_control_slave_begins_xfer & (lcd_control_slave_wait_counter < 13);

  //lcd_control_slave_write assignment, which is an e_mux
  assign lcd_control_slave_write = ((cpu_0_data_master_granted_lcd_control_slave & cpu_0_data_master_write)) & ~lcd_control_slave_begins_xfer & (lcd_control_slave_wait_counter >= 13) & (lcd_control_slave_wait_counter < 26) & lcd_control_slave_pretend_byte_enable;

  assign shifted_address_to_lcd_control_slave_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //lcd_control_slave_address mux, which is an e_mux
  assign lcd_control_slave_address = shifted_address_to_lcd_control_slave_from_cpu_0_data_master >> 2;

  //d1_lcd_control_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_lcd_control_slave_end_xfer <= 1;
      else if (1)
          d1_lcd_control_slave_end_xfer <= lcd_control_slave_end_xfer;
    end


  //lcd_control_slave_wait_counter_eq_1 assignment, which is an e_assign
  assign lcd_control_slave_wait_counter_eq_1 = lcd_control_slave_wait_counter == 1;

  //lcd_control_slave_waits_for_read in a cycle, which is an e_mux
  assign lcd_control_slave_waits_for_read = lcd_control_slave_in_a_read_cycle & wait_for_lcd_control_slave_counter;

  //lcd_control_slave_in_a_read_cycle assignment, which is an e_assign
  assign lcd_control_slave_in_a_read_cycle = cpu_0_data_master_granted_lcd_control_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = lcd_control_slave_in_a_read_cycle;

  //lcd_control_slave_waits_for_write in a cycle, which is an e_mux
  assign lcd_control_slave_waits_for_write = lcd_control_slave_in_a_write_cycle & wait_for_lcd_control_slave_counter;

  //lcd_control_slave_in_a_write_cycle assignment, which is an e_assign
  assign lcd_control_slave_in_a_write_cycle = cpu_0_data_master_granted_lcd_control_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = lcd_control_slave_in_a_write_cycle;

  assign lcd_control_slave_wait_counter_eq_0 = lcd_control_slave_wait_counter == 0;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          lcd_control_slave_wait_counter <= 0;
      else if (1)
          lcd_control_slave_wait_counter <= lcd_control_slave_counter_load_value;
    end


  assign lcd_control_slave_counter_load_value = ((lcd_control_slave_in_a_read_cycle & lcd_control_slave_begins_xfer))? 24 :
    ((lcd_control_slave_in_a_write_cycle & lcd_control_slave_begins_xfer))? 37 :
    (~lcd_control_slave_wait_counter_eq_0)? lcd_control_slave_wait_counter - 1 :
    0;

  assign wait_for_lcd_control_slave_counter = lcd_control_slave_begins_xfer | ~lcd_control_slave_wait_counter_eq_0;
  //lcd_control_slave_pretend_byte_enable byte enable port mux, which is an e_mux
  assign lcd_control_slave_pretend_byte_enable = (cpu_0_data_master_granted_lcd_control_slave)? cpu_0_data_master_byteenable :
    -1;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sram_16bit_512k_0_avalon_slave_0_arbitrator (
                                                     // inputs:
                                                      clk,
                                                      cpu_0_data_master_address_to_slave,
                                                      cpu_0_data_master_byteenable,
                                                      cpu_0_data_master_dbs_address,
                                                      cpu_0_data_master_dbs_write_16,
                                                      cpu_0_data_master_no_byte_enables_and_last_term,
                                                      cpu_0_data_master_read,
                                                      cpu_0_data_master_write,
                                                      cpu_0_instruction_master_address_to_slave,
                                                      cpu_0_instruction_master_dbs_address,
                                                      cpu_0_instruction_master_latency_counter,
                                                      cpu_0_instruction_master_read,
                                                      reset_n,
                                                      sram_16bit_512k_0_avalon_slave_0_readdata,

                                                     // outputs:
                                                      cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0,
                                                      cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0,
                                                      cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0,
                                                      cpu_0_data_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0,
                                                      cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0,
                                                      cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0,
                                                      cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0,
                                                      cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0,
                                                      cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0,
                                                      d1_sram_16bit_512k_0_avalon_slave_0_end_xfer,
                                                      sram_16bit_512k_0_avalon_slave_0_address,
                                                      sram_16bit_512k_0_avalon_slave_0_byteenable_n,
                                                      sram_16bit_512k_0_avalon_slave_0_chipselect_n,
                                                      sram_16bit_512k_0_avalon_slave_0_read_n,
                                                      sram_16bit_512k_0_avalon_slave_0_readdata_from_sa,
                                                      sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0,
                                                      sram_16bit_512k_0_avalon_slave_0_write_n,
                                                      sram_16bit_512k_0_avalon_slave_0_writedata
                                                   )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0;
  output           cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0;
  output           cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0;
  output           cpu_0_data_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0;
  output           cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0;
  output           cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0;
  output           cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0;
  output           cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0;
  output           cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0;
  output           d1_sram_16bit_512k_0_avalon_slave_0_end_xfer;
  output  [ 17: 0] sram_16bit_512k_0_avalon_slave_0_address;
  output  [  1: 0] sram_16bit_512k_0_avalon_slave_0_byteenable_n;
  output           sram_16bit_512k_0_avalon_slave_0_chipselect_n;
  output           sram_16bit_512k_0_avalon_slave_0_read_n;
  output  [ 15: 0] sram_16bit_512k_0_avalon_slave_0_readdata_from_sa;
  output           sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0;
  output           sram_16bit_512k_0_avalon_slave_0_write_n;
  output  [ 15: 0] sram_16bit_512k_0_avalon_slave_0_writedata;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [ 15: 0] cpu_0_data_master_dbs_write_16;
  input            cpu_0_data_master_no_byte_enables_and_last_term;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 19: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_dbs_address;
  input            cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            reset_n;
  input   [ 15: 0] sram_16bit_512k_0_avalon_slave_0_readdata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire    [  1: 0] cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0;
  wire    [  1: 0] cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0_segment_0;
  wire    [  1: 0] cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0_segment_1;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_data_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_data_master_saved_grant_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_instruction_master_saved_grant_sram_16bit_512k_0_avalon_slave_0;
  reg              d1_reasons_to_wait;
  reg              d1_sram_16bit_512k_0_avalon_slave_0_end_xfer;
  wire             end_xfer_arb_share_counter_term_sram_16bit_512k_0_avalon_slave_0;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_0_data_master_granted_slave_sram_16bit_512k_0_avalon_slave_0;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_sram_16bit_512k_0_avalon_slave_0;
  wire    [ 19: 0] shifted_address_to_sram_16bit_512k_0_avalon_slave_0_from_cpu_0_data_master;
  wire    [ 19: 0] shifted_address_to_sram_16bit_512k_0_avalon_slave_0_from_cpu_0_instruction_master;
  wire    [ 17: 0] sram_16bit_512k_0_avalon_slave_0_address;
  wire             sram_16bit_512k_0_avalon_slave_0_allgrants;
  wire             sram_16bit_512k_0_avalon_slave_0_allow_new_arb_cycle;
  wire             sram_16bit_512k_0_avalon_slave_0_any_bursting_master_saved_grant;
  wire             sram_16bit_512k_0_avalon_slave_0_any_continuerequest;
  reg     [  1: 0] sram_16bit_512k_0_avalon_slave_0_arb_addend;
  wire             sram_16bit_512k_0_avalon_slave_0_arb_counter_enable;
  reg     [  1: 0] sram_16bit_512k_0_avalon_slave_0_arb_share_counter;
  wire    [  1: 0] sram_16bit_512k_0_avalon_slave_0_arb_share_counter_next_value;
  wire    [  1: 0] sram_16bit_512k_0_avalon_slave_0_arb_share_set_values;
  wire    [  1: 0] sram_16bit_512k_0_avalon_slave_0_arb_winner;
  wire             sram_16bit_512k_0_avalon_slave_0_arbitration_holdoff_internal;
  wire             sram_16bit_512k_0_avalon_slave_0_beginbursttransfer_internal;
  wire             sram_16bit_512k_0_avalon_slave_0_begins_xfer;
  wire    [  1: 0] sram_16bit_512k_0_avalon_slave_0_byteenable_n;
  wire             sram_16bit_512k_0_avalon_slave_0_chipselect_n;
  wire    [  3: 0] sram_16bit_512k_0_avalon_slave_0_chosen_master_double_vector;
  wire    [  1: 0] sram_16bit_512k_0_avalon_slave_0_chosen_master_rot_left;
  wire             sram_16bit_512k_0_avalon_slave_0_counter_load_value;
  wire             sram_16bit_512k_0_avalon_slave_0_end_xfer;
  wire             sram_16bit_512k_0_avalon_slave_0_firsttransfer;
  wire    [  1: 0] sram_16bit_512k_0_avalon_slave_0_grant_vector;
  wire             sram_16bit_512k_0_avalon_slave_0_in_a_read_cycle;
  wire             sram_16bit_512k_0_avalon_slave_0_in_a_write_cycle;
  wire    [  1: 0] sram_16bit_512k_0_avalon_slave_0_master_qreq_vector;
  wire             sram_16bit_512k_0_avalon_slave_0_non_bursting_master_requests;
  wire             sram_16bit_512k_0_avalon_slave_0_read_n;
  wire    [ 15: 0] sram_16bit_512k_0_avalon_slave_0_readdata_from_sa;
  reg     [  1: 0] sram_16bit_512k_0_avalon_slave_0_saved_chosen_master_vector;
  reg              sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable;
  wire             sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable2;
  reg              sram_16bit_512k_0_avalon_slave_0_wait_counter;
  wire             sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0;
  wire             sram_16bit_512k_0_avalon_slave_0_waits_for_read;
  wire             sram_16bit_512k_0_avalon_slave_0_waits_for_write;
  wire             sram_16bit_512k_0_avalon_slave_0_write_n;
  wire    [ 15: 0] sram_16bit_512k_0_avalon_slave_0_writedata;
  wire             wait_for_sram_16bit_512k_0_avalon_slave_0_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~sram_16bit_512k_0_avalon_slave_0_end_xfer;
    end


  assign sram_16bit_512k_0_avalon_slave_0_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 | cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0));
  //assign sram_16bit_512k_0_avalon_slave_0_readdata_from_sa = sram_16bit_512k_0_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_readdata_from_sa = sram_16bit_512k_0_avalon_slave_0_readdata;

  assign cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0 = ({cpu_0_data_master_address_to_slave[19] , 19'b0} == 20'h80000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //sram_16bit_512k_0_avalon_slave_0_arb_share_counter set values, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_arb_share_set_values = (cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0)? 2 :
    (cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0)? 2 :
    (cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0)? 2 :
    (cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0)? 2 :
    1;

  //sram_16bit_512k_0_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_non_bursting_master_requests = cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0 |
    cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0 |
    cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0 |
    cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0;

  //sram_16bit_512k_0_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_any_bursting_master_saved_grant = 0;

  //sram_16bit_512k_0_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_arb_share_counter_next_value = sram_16bit_512k_0_avalon_slave_0_firsttransfer ? (sram_16bit_512k_0_avalon_slave_0_arb_share_set_values - 1) : |sram_16bit_512k_0_avalon_slave_0_arb_share_counter ? (sram_16bit_512k_0_avalon_slave_0_arb_share_counter - 1) : 0;

  //sram_16bit_512k_0_avalon_slave_0_allgrants all slave grants, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_allgrants = |sram_16bit_512k_0_avalon_slave_0_grant_vector |
    |sram_16bit_512k_0_avalon_slave_0_grant_vector |
    |sram_16bit_512k_0_avalon_slave_0_grant_vector |
    |sram_16bit_512k_0_avalon_slave_0_grant_vector;

  //sram_16bit_512k_0_avalon_slave_0_end_xfer assignment, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_end_xfer = ~(sram_16bit_512k_0_avalon_slave_0_waits_for_read | sram_16bit_512k_0_avalon_slave_0_waits_for_write);

  //end_xfer_arb_share_counter_term_sram_16bit_512k_0_avalon_slave_0 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sram_16bit_512k_0_avalon_slave_0 = sram_16bit_512k_0_avalon_slave_0_end_xfer & (~sram_16bit_512k_0_avalon_slave_0_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sram_16bit_512k_0_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_arb_counter_enable = (end_xfer_arb_share_counter_term_sram_16bit_512k_0_avalon_slave_0 & sram_16bit_512k_0_avalon_slave_0_allgrants) | (end_xfer_arb_share_counter_term_sram_16bit_512k_0_avalon_slave_0 & ~sram_16bit_512k_0_avalon_slave_0_non_bursting_master_requests);

  //sram_16bit_512k_0_avalon_slave_0_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_16bit_512k_0_avalon_slave_0_arb_share_counter <= 0;
      else if (sram_16bit_512k_0_avalon_slave_0_arb_counter_enable)
          sram_16bit_512k_0_avalon_slave_0_arb_share_counter <= sram_16bit_512k_0_avalon_slave_0_arb_share_counter_next_value;
    end


  //sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable <= 0;
      else if ((|sram_16bit_512k_0_avalon_slave_0_master_qreq_vector & end_xfer_arb_share_counter_term_sram_16bit_512k_0_avalon_slave_0) | (end_xfer_arb_share_counter_term_sram_16bit_512k_0_avalon_slave_0 & ~sram_16bit_512k_0_avalon_slave_0_non_bursting_master_requests))
          sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable <= |sram_16bit_512k_0_avalon_slave_0_arb_share_counter_next_value;
    end


  //cpu_0/data_master sram_16bit_512k_0/avalon_slave_0 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable2 = |sram_16bit_512k_0_avalon_slave_0_arb_share_counter_next_value;

  //cpu_0/data_master sram_16bit_512k_0/avalon_slave_0 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master sram_16bit_512k_0/avalon_slave_0 arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master sram_16bit_512k_0/avalon_slave_0 arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted sram_16bit_512k_0/avalon_slave_0 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_sram_16bit_512k_0_avalon_slave_0 <= 0;
      else if (1)
          last_cycle_cpu_0_instruction_master_granted_slave_sram_16bit_512k_0_avalon_slave_0 <= cpu_0_instruction_master_saved_grant_sram_16bit_512k_0_avalon_slave_0 ? 1 : (sram_16bit_512k_0_avalon_slave_0_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_sram_16bit_512k_0_avalon_slave_0;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_sram_16bit_512k_0_avalon_slave_0 & cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0;

  //sram_16bit_512k_0_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 = cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0 & ~(((cpu_0_data_master_no_byte_enables_and_last_term | !cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0) & cpu_0_data_master_write) | cpu_0_instruction_master_arbiterlock);
  //sram_16bit_512k_0_avalon_slave_0_writedata mux, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_writedata = cpu_0_data_master_dbs_write_16;

  assign cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0 = (({cpu_0_instruction_master_address_to_slave[19] , 19'b0} == 20'h80000) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted sram_16bit_512k_0/avalon_slave_0 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_sram_16bit_512k_0_avalon_slave_0 <= 0;
      else if (1)
          last_cycle_cpu_0_data_master_granted_slave_sram_16bit_512k_0_avalon_slave_0 <= cpu_0_data_master_saved_grant_sram_16bit_512k_0_avalon_slave_0 ? 1 : (sram_16bit_512k_0_avalon_slave_0_arbitration_holdoff_internal | ~cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0) ? 0 : last_cycle_cpu_0_data_master_granted_slave_sram_16bit_512k_0_avalon_slave_0;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_sram_16bit_512k_0_avalon_slave_0 & cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0;

  assign cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 = cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0 & ~((cpu_0_instruction_master_read & ((cpu_0_instruction_master_latency_counter != 0))) | cpu_0_data_master_arbiterlock);
  //local readdatavalid cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0 = cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0 & cpu_0_instruction_master_read & ~sram_16bit_512k_0_avalon_slave_0_waits_for_read;

  //allow new arb cycle for sram_16bit_512k_0/avalon_slave_0, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for sram_16bit_512k_0/avalon_slave_0, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0;

  //cpu_0/instruction_master grant sram_16bit_512k_0/avalon_slave_0, which is an e_assign
  assign cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0 = sram_16bit_512k_0_avalon_slave_0_grant_vector[0];

  //cpu_0/instruction_master saved-grant sram_16bit_512k_0/avalon_slave_0, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_sram_16bit_512k_0_avalon_slave_0 = sram_16bit_512k_0_avalon_slave_0_arb_winner[0] && cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0;

  //cpu_0/data_master assignment into master qualified-requests vector for sram_16bit_512k_0/avalon_slave_0, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_master_qreq_vector[1] = cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0;

  //cpu_0/data_master grant sram_16bit_512k_0/avalon_slave_0, which is an e_assign
  assign cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0 = sram_16bit_512k_0_avalon_slave_0_grant_vector[1];

  //cpu_0/data_master saved-grant sram_16bit_512k_0/avalon_slave_0, which is an e_assign
  assign cpu_0_data_master_saved_grant_sram_16bit_512k_0_avalon_slave_0 = sram_16bit_512k_0_avalon_slave_0_arb_winner[1] && cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0;

  //sram_16bit_512k_0/avalon_slave_0 chosen-master double-vector, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_chosen_master_double_vector = {sram_16bit_512k_0_avalon_slave_0_master_qreq_vector, sram_16bit_512k_0_avalon_slave_0_master_qreq_vector} & ({~sram_16bit_512k_0_avalon_slave_0_master_qreq_vector, ~sram_16bit_512k_0_avalon_slave_0_master_qreq_vector} + sram_16bit_512k_0_avalon_slave_0_arb_addend);

  //stable onehot encoding of arb winner
  assign sram_16bit_512k_0_avalon_slave_0_arb_winner = (sram_16bit_512k_0_avalon_slave_0_allow_new_arb_cycle & | sram_16bit_512k_0_avalon_slave_0_grant_vector) ? sram_16bit_512k_0_avalon_slave_0_grant_vector : sram_16bit_512k_0_avalon_slave_0_saved_chosen_master_vector;

  //saved sram_16bit_512k_0_avalon_slave_0_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_16bit_512k_0_avalon_slave_0_saved_chosen_master_vector <= 0;
      else if (sram_16bit_512k_0_avalon_slave_0_allow_new_arb_cycle)
          sram_16bit_512k_0_avalon_slave_0_saved_chosen_master_vector <= |sram_16bit_512k_0_avalon_slave_0_grant_vector ? sram_16bit_512k_0_avalon_slave_0_grant_vector : sram_16bit_512k_0_avalon_slave_0_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign sram_16bit_512k_0_avalon_slave_0_grant_vector = {(sram_16bit_512k_0_avalon_slave_0_chosen_master_double_vector[1] | sram_16bit_512k_0_avalon_slave_0_chosen_master_double_vector[3]),
    (sram_16bit_512k_0_avalon_slave_0_chosen_master_double_vector[0] | sram_16bit_512k_0_avalon_slave_0_chosen_master_double_vector[2])};

  //sram_16bit_512k_0/avalon_slave_0 chosen master rotated left, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_chosen_master_rot_left = (sram_16bit_512k_0_avalon_slave_0_arb_winner << 1) ? (sram_16bit_512k_0_avalon_slave_0_arb_winner << 1) : 1;

  //sram_16bit_512k_0/avalon_slave_0's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_16bit_512k_0_avalon_slave_0_arb_addend <= 1;
      else if (|sram_16bit_512k_0_avalon_slave_0_grant_vector)
          sram_16bit_512k_0_avalon_slave_0_arb_addend <= sram_16bit_512k_0_avalon_slave_0_end_xfer? sram_16bit_512k_0_avalon_slave_0_chosen_master_rot_left : sram_16bit_512k_0_avalon_slave_0_grant_vector;
    end


  assign sram_16bit_512k_0_avalon_slave_0_chipselect_n = ~(cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0 | cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0);
  //sram_16bit_512k_0_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_firsttransfer = ~(sram_16bit_512k_0_avalon_slave_0_slavearbiterlockenable & sram_16bit_512k_0_avalon_slave_0_any_continuerequest);

  //sram_16bit_512k_0_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_beginbursttransfer_internal = sram_16bit_512k_0_avalon_slave_0_begins_xfer;

  //sram_16bit_512k_0_avalon_slave_0_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_arbitration_holdoff_internal = sram_16bit_512k_0_avalon_slave_0_begins_xfer & sram_16bit_512k_0_avalon_slave_0_firsttransfer;

  //~sram_16bit_512k_0_avalon_slave_0_read_n assignment, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_read_n = ~(((cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0 & cpu_0_instruction_master_read))& ~sram_16bit_512k_0_avalon_slave_0_begins_xfer);

  //~sram_16bit_512k_0_avalon_slave_0_write_n assignment, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_write_n = ~(((cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0 & cpu_0_data_master_write)) & ~sram_16bit_512k_0_avalon_slave_0_begins_xfer & (sram_16bit_512k_0_avalon_slave_0_wait_counter >= 1));

  assign shifted_address_to_sram_16bit_512k_0_avalon_slave_0_from_cpu_0_data_master = {cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1],
    {1 {1'b0}}};

  //sram_16bit_512k_0_avalon_slave_0_address mux, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_address = (cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0)? (shifted_address_to_sram_16bit_512k_0_avalon_slave_0_from_cpu_0_data_master >> 1) :
    (shifted_address_to_sram_16bit_512k_0_avalon_slave_0_from_cpu_0_instruction_master >> 1);

  assign shifted_address_to_sram_16bit_512k_0_avalon_slave_0_from_cpu_0_instruction_master = {cpu_0_instruction_master_address_to_slave >> 2,
    cpu_0_instruction_master_dbs_address[1],
    {1 {1'b0}}};

  //d1_sram_16bit_512k_0_avalon_slave_0_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sram_16bit_512k_0_avalon_slave_0_end_xfer <= 1;
      else if (1)
          d1_sram_16bit_512k_0_avalon_slave_0_end_xfer <= sram_16bit_512k_0_avalon_slave_0_end_xfer;
    end


  //sram_16bit_512k_0_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_waits_for_read = sram_16bit_512k_0_avalon_slave_0_in_a_read_cycle & sram_16bit_512k_0_avalon_slave_0_begins_xfer;

  //sram_16bit_512k_0_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_in_a_read_cycle = (cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0 & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sram_16bit_512k_0_avalon_slave_0_in_a_read_cycle;

  //sram_16bit_512k_0_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_waits_for_write = sram_16bit_512k_0_avalon_slave_0_in_a_write_cycle & wait_for_sram_16bit_512k_0_avalon_slave_0_counter;

  //sram_16bit_512k_0_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  assign sram_16bit_512k_0_avalon_slave_0_in_a_write_cycle = cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sram_16bit_512k_0_avalon_slave_0_in_a_write_cycle;

  assign sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0 = sram_16bit_512k_0_avalon_slave_0_wait_counter == 0;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_16bit_512k_0_avalon_slave_0_wait_counter <= 0;
      else if (1)
          sram_16bit_512k_0_avalon_slave_0_wait_counter <= sram_16bit_512k_0_avalon_slave_0_counter_load_value;
    end


  assign sram_16bit_512k_0_avalon_slave_0_counter_load_value = ((sram_16bit_512k_0_avalon_slave_0_in_a_write_cycle & sram_16bit_512k_0_avalon_slave_0_begins_xfer))? 1 :
    (~sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0)? sram_16bit_512k_0_avalon_slave_0_wait_counter - 1 :
    0;

  assign wait_for_sram_16bit_512k_0_avalon_slave_0_counter = sram_16bit_512k_0_avalon_slave_0_begins_xfer | ~sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0;
  //~sram_16bit_512k_0_avalon_slave_0_byteenable_n byte enable port mux, which is an e_mux
  assign sram_16bit_512k_0_avalon_slave_0_byteenable_n = ~((cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0)? cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0 :
    -1);

  assign {cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0_segment_1,
cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0 = ((cpu_0_data_master_dbs_address[1] == 0))? cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0_segment_0 :
    cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0_segment_1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0 + cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_sram_16bit_512k_0_avalon_slave_0 + cpu_0_instruction_master_saved_grant_sram_16bit_512k_0_avalon_slave_0 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module timer_0_s1_arbitrator (
                               // inputs:
                                clk,
                                cpu_0_data_master_address_to_slave,
                                cpu_0_data_master_read,
                                cpu_0_data_master_waitrequest,
                                cpu_0_data_master_write,
                                cpu_0_data_master_writedata,
                                reset_n,
                                timer_0_s1_irq,
                                timer_0_s1_readdata,

                               // outputs:
                                cpu_0_data_master_granted_timer_0_s1,
                                cpu_0_data_master_qualified_request_timer_0_s1,
                                cpu_0_data_master_read_data_valid_timer_0_s1,
                                cpu_0_data_master_requests_timer_0_s1,
                                d1_timer_0_s1_end_xfer,
                                timer_0_s1_address,
                                timer_0_s1_chipselect,
                                timer_0_s1_irq_from_sa,
                                timer_0_s1_readdata_from_sa,
                                timer_0_s1_reset_n,
                                timer_0_s1_write_n,
                                timer_0_s1_writedata
                             )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output           cpu_0_data_master_granted_timer_0_s1;
  output           cpu_0_data_master_qualified_request_timer_0_s1;
  output           cpu_0_data_master_read_data_valid_timer_0_s1;
  output           cpu_0_data_master_requests_timer_0_s1;
  output           d1_timer_0_s1_end_xfer;
  output  [  2: 0] timer_0_s1_address;
  output           timer_0_s1_chipselect;
  output           timer_0_s1_irq_from_sa;
  output  [ 15: 0] timer_0_s1_readdata_from_sa;
  output           timer_0_s1_reset_n;
  output           timer_0_s1_write_n;
  output  [ 15: 0] timer_0_s1_writedata;
  input            clk;
  input   [ 19: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;
  input            timer_0_s1_irq;
  input   [ 15: 0] timer_0_s1_readdata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_timer_0_s1;
  wire             cpu_0_data_master_qualified_request_timer_0_s1;
  wire             cpu_0_data_master_read_data_valid_timer_0_s1;
  wire             cpu_0_data_master_requests_timer_0_s1;
  wire             cpu_0_data_master_saved_grant_timer_0_s1;
  reg              d1_reasons_to_wait;
  reg              d1_timer_0_s1_end_xfer;
  wire             end_xfer_arb_share_counter_term_timer_0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 19: 0] shifted_address_to_timer_0_s1_from_cpu_0_data_master;
  wire    [  2: 0] timer_0_s1_address;
  wire             timer_0_s1_allgrants;
  wire             timer_0_s1_allow_new_arb_cycle;
  wire             timer_0_s1_any_bursting_master_saved_grant;
  wire             timer_0_s1_any_continuerequest;
  wire             timer_0_s1_arb_counter_enable;
  reg     [  1: 0] timer_0_s1_arb_share_counter;
  wire    [  1: 0] timer_0_s1_arb_share_counter_next_value;
  wire    [  1: 0] timer_0_s1_arb_share_set_values;
  wire             timer_0_s1_beginbursttransfer_internal;
  wire             timer_0_s1_begins_xfer;
  wire             timer_0_s1_chipselect;
  wire             timer_0_s1_end_xfer;
  wire             timer_0_s1_firsttransfer;
  wire             timer_0_s1_grant_vector;
  wire             timer_0_s1_in_a_read_cycle;
  wire             timer_0_s1_in_a_write_cycle;
  wire             timer_0_s1_irq_from_sa;
  wire             timer_0_s1_master_qreq_vector;
  wire             timer_0_s1_non_bursting_master_requests;
  wire    [ 15: 0] timer_0_s1_readdata_from_sa;
  wire             timer_0_s1_reset_n;
  reg              timer_0_s1_slavearbiterlockenable;
  wire             timer_0_s1_slavearbiterlockenable2;
  wire             timer_0_s1_waits_for_read;
  wire             timer_0_s1_waits_for_write;
  wire             timer_0_s1_write_n;
  wire    [ 15: 0] timer_0_s1_writedata;
  wire             wait_for_timer_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~timer_0_s1_end_xfer;
    end


  assign timer_0_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_timer_0_s1));
  //assign timer_0_s1_readdata_from_sa = timer_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign timer_0_s1_readdata_from_sa = timer_0_s1_readdata;

  assign cpu_0_data_master_requests_timer_0_s1 = ({cpu_0_data_master_address_to_slave[19 : 5] , 5'b0} == 20'h840) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //timer_0_s1_arb_share_counter set values, which is an e_mux
  assign timer_0_s1_arb_share_set_values = 1;

  //timer_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign timer_0_s1_non_bursting_master_requests = cpu_0_data_master_requests_timer_0_s1;

  //timer_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign timer_0_s1_any_bursting_master_saved_grant = 0;

  //timer_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign timer_0_s1_arb_share_counter_next_value = timer_0_s1_firsttransfer ? (timer_0_s1_arb_share_set_values - 1) : |timer_0_s1_arb_share_counter ? (timer_0_s1_arb_share_counter - 1) : 0;

  //timer_0_s1_allgrants all slave grants, which is an e_mux
  assign timer_0_s1_allgrants = |timer_0_s1_grant_vector;

  //timer_0_s1_end_xfer assignment, which is an e_assign
  assign timer_0_s1_end_xfer = ~(timer_0_s1_waits_for_read | timer_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_timer_0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_timer_0_s1 = timer_0_s1_end_xfer & (~timer_0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //timer_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign timer_0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_timer_0_s1 & timer_0_s1_allgrants) | (end_xfer_arb_share_counter_term_timer_0_s1 & ~timer_0_s1_non_bursting_master_requests);

  //timer_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_0_s1_arb_share_counter <= 0;
      else if (timer_0_s1_arb_counter_enable)
          timer_0_s1_arb_share_counter <= timer_0_s1_arb_share_counter_next_value;
    end


  //timer_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_0_s1_slavearbiterlockenable <= 0;
      else if ((|timer_0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_timer_0_s1) | (end_xfer_arb_share_counter_term_timer_0_s1 & ~timer_0_s1_non_bursting_master_requests))
          timer_0_s1_slavearbiterlockenable <= |timer_0_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master timer_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = timer_0_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //timer_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign timer_0_s1_slavearbiterlockenable2 = |timer_0_s1_arb_share_counter_next_value;

  //cpu_0/data_master timer_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = timer_0_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //timer_0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign timer_0_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_timer_0_s1 = cpu_0_data_master_requests_timer_0_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //timer_0_s1_writedata mux, which is an e_mux
  assign timer_0_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_timer_0_s1 = cpu_0_data_master_qualified_request_timer_0_s1;

  //cpu_0/data_master saved-grant timer_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_timer_0_s1 = cpu_0_data_master_requests_timer_0_s1;

  //allow new arb cycle for timer_0/s1, which is an e_assign
  assign timer_0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign timer_0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign timer_0_s1_master_qreq_vector = 1;

  //timer_0_s1_reset_n assignment, which is an e_assign
  assign timer_0_s1_reset_n = reset_n;

  assign timer_0_s1_chipselect = cpu_0_data_master_granted_timer_0_s1;
  //timer_0_s1_firsttransfer first transaction, which is an e_assign
  assign timer_0_s1_firsttransfer = ~(timer_0_s1_slavearbiterlockenable & timer_0_s1_any_continuerequest);

  //timer_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign timer_0_s1_beginbursttransfer_internal = timer_0_s1_begins_xfer;

  //~timer_0_s1_write_n assignment, which is an e_mux
  assign timer_0_s1_write_n = ~(cpu_0_data_master_granted_timer_0_s1 & cpu_0_data_master_write);

  assign shifted_address_to_timer_0_s1_from_cpu_0_data_master = cpu_0_data_master_address_to_slave;
  //timer_0_s1_address mux, which is an e_mux
  assign timer_0_s1_address = shifted_address_to_timer_0_s1_from_cpu_0_data_master >> 2;

  //d1_timer_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_timer_0_s1_end_xfer <= 1;
      else if (1)
          d1_timer_0_s1_end_xfer <= timer_0_s1_end_xfer;
    end


  //timer_0_s1_waits_for_read in a cycle, which is an e_mux
  assign timer_0_s1_waits_for_read = timer_0_s1_in_a_read_cycle & timer_0_s1_begins_xfer;

  //timer_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign timer_0_s1_in_a_read_cycle = cpu_0_data_master_granted_timer_0_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = timer_0_s1_in_a_read_cycle;

  //timer_0_s1_waits_for_write in a cycle, which is an e_mux
  assign timer_0_s1_waits_for_write = timer_0_s1_in_a_write_cycle & 0;

  //timer_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign timer_0_s1_in_a_write_cycle = cpu_0_data_master_granted_timer_0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = timer_0_s1_in_a_write_cycle;

  assign wait_for_timer_0_s1_counter = 0;
  //assign timer_0_s1_irq_from_sa = timer_0_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign timer_0_s1_irq_from_sa = timer_0_s1_irq;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module bigNios_reset_clk_domain_synch_module (
                                               // inputs:
                                                clk,
                                                data_in,
                                                reset_n,

                                               // outputs:
                                                data_out
                                             )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "MAX_DELAY=\"100ns\" ; PRESERVE_REGISTER=ON"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else if (1)
          data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else if (1)
          data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module bigNios (
                 // 1) global signals:
                  clk,
                  reset_n,

                 // the_In0
                  in_port_to_the_In0,

                 // the_In1
                  in_port_to_the_In1,

                 // the_In2
                  in_port_to_the_In2,

                 // the_Out0
                  out_port_from_the_Out0,

                 // the_Out1
                  out_port_from_the_Out1,

                 // the_Out2
                  out_port_from_the_Out2,

                 // the_Out3
                  out_port_from_the_Out3,

                 // the_Out4
                  out_port_from_the_Out4,

                 // the_lcd
                  LCD_E_from_the_lcd,
                  LCD_RS_from_the_lcd,
                  LCD_RW_from_the_lcd,
                  LCD_data_to_and_from_the_lcd,

                 // the_sram_16bit_512k_0
                  SRAM_ADDR_from_the_sram_16bit_512k_0,
                  SRAM_CE_N_from_the_sram_16bit_512k_0,
                  SRAM_DQ_to_and_from_the_sram_16bit_512k_0,
                  SRAM_LB_N_from_the_sram_16bit_512k_0,
                  SRAM_OE_N_from_the_sram_16bit_512k_0,
                  SRAM_UB_N_from_the_sram_16bit_512k_0,
                  SRAM_WE_N_from_the_sram_16bit_512k_0
               )
;

  output           LCD_E_from_the_lcd;
  output           LCD_RS_from_the_lcd;
  output           LCD_RW_from_the_lcd;
  inout   [  7: 0] LCD_data_to_and_from_the_lcd;
  output  [ 17: 0] SRAM_ADDR_from_the_sram_16bit_512k_0;
  output           SRAM_CE_N_from_the_sram_16bit_512k_0;
  inout   [ 15: 0] SRAM_DQ_to_and_from_the_sram_16bit_512k_0;
  output           SRAM_LB_N_from_the_sram_16bit_512k_0;
  output           SRAM_OE_N_from_the_sram_16bit_512k_0;
  output           SRAM_UB_N_from_the_sram_16bit_512k_0;
  output           SRAM_WE_N_from_the_sram_16bit_512k_0;
  output           out_port_from_the_Out0;
  output  [ 17: 0] out_port_from_the_Out1;
  output  [  9: 0] out_port_from_the_Out2;
  output  [  9: 0] out_port_from_the_Out3;
  output  [  9: 0] out_port_from_the_Out4;
  input            clk;
  input   [ 15: 0] in_port_to_the_In0;
  input   [ 15: 0] in_port_to_the_In1;
  input   [ 15: 0] in_port_to_the_In2;
  input            reset_n;

  wire    [  1: 0] In0_s1_address;
  wire    [ 15: 0] In0_s1_readdata;
  wire    [ 15: 0] In0_s1_readdata_from_sa;
  wire             In0_s1_reset_n;
  wire    [  1: 0] In1_s1_address;
  wire    [ 15: 0] In1_s1_readdata;
  wire    [ 15: 0] In1_s1_readdata_from_sa;
  wire             In1_s1_reset_n;
  wire    [  1: 0] In2_s1_address;
  wire    [ 15: 0] In2_s1_readdata;
  wire    [ 15: 0] In2_s1_readdata_from_sa;
  wire             In2_s1_reset_n;
  wire             LCD_E_from_the_lcd;
  wire             LCD_RS_from_the_lcd;
  wire             LCD_RW_from_the_lcd;
  wire    [  7: 0] LCD_data_to_and_from_the_lcd;
  wire    [  1: 0] Out0_s1_address;
  wire             Out0_s1_chipselect;
  wire             Out0_s1_reset_n;
  wire             Out0_s1_write_n;
  wire             Out0_s1_writedata;
  wire    [  1: 0] Out1_s1_address;
  wire             Out1_s1_chipselect;
  wire             Out1_s1_reset_n;
  wire             Out1_s1_write_n;
  wire    [ 17: 0] Out1_s1_writedata;
  wire    [  1: 0] Out2_s1_address;
  wire             Out2_s1_chipselect;
  wire             Out2_s1_reset_n;
  wire             Out2_s1_write_n;
  wire    [  9: 0] Out2_s1_writedata;
  wire    [  1: 0] Out3_s1_address;
  wire             Out3_s1_chipselect;
  wire             Out3_s1_reset_n;
  wire             Out3_s1_write_n;
  wire    [  9: 0] Out3_s1_writedata;
  wire    [  1: 0] Out4_s1_address;
  wire             Out4_s1_chipselect;
  wire             Out4_s1_reset_n;
  wire             Out4_s1_write_n;
  wire    [  9: 0] Out4_s1_writedata;
  wire    [ 17: 0] SRAM_ADDR_from_the_sram_16bit_512k_0;
  wire             SRAM_CE_N_from_the_sram_16bit_512k_0;
  wire    [ 15: 0] SRAM_DQ_to_and_from_the_sram_16bit_512k_0;
  wire             SRAM_LB_N_from_the_sram_16bit_512k_0;
  wire             SRAM_OE_N_from_the_sram_16bit_512k_0;
  wire             SRAM_UB_N_from_the_sram_16bit_512k_0;
  wire             SRAM_WE_N_from_the_sram_16bit_512k_0;
  wire             clk_reset_n;
  wire    [ 19: 0] cpu_0_data_master_address;
  wire    [ 19: 0] cpu_0_data_master_address_to_slave;
  wire    [  3: 0] cpu_0_data_master_byteenable;
  wire    [  1: 0] cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0;
  wire    [  1: 0] cpu_0_data_master_dbs_address;
  wire    [ 15: 0] cpu_0_data_master_dbs_write_16;
  wire             cpu_0_data_master_debugaccess;
  wire             cpu_0_data_master_granted_In0_s1;
  wire             cpu_0_data_master_granted_In1_s1;
  wire             cpu_0_data_master_granted_In2_s1;
  wire             cpu_0_data_master_granted_Out0_s1;
  wire             cpu_0_data_master_granted_Out1_s1;
  wire             cpu_0_data_master_granted_Out2_s1;
  wire             cpu_0_data_master_granted_Out3_s1;
  wire             cpu_0_data_master_granted_Out4_s1;
  wire             cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave;
  wire             cpu_0_data_master_granted_lcd_control_slave;
  wire             cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_data_master_granted_timer_0_s1;
  wire    [ 31: 0] cpu_0_data_master_irq;
  wire             cpu_0_data_master_no_byte_enables_and_last_term;
  wire             cpu_0_data_master_qualified_request_In0_s1;
  wire             cpu_0_data_master_qualified_request_In1_s1;
  wire             cpu_0_data_master_qualified_request_In2_s1;
  wire             cpu_0_data_master_qualified_request_Out0_s1;
  wire             cpu_0_data_master_qualified_request_Out1_s1;
  wire             cpu_0_data_master_qualified_request_Out2_s1;
  wire             cpu_0_data_master_qualified_request_Out3_s1;
  wire             cpu_0_data_master_qualified_request_Out4_s1;
  wire             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             cpu_0_data_master_qualified_request_lcd_control_slave;
  wire             cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_data_master_qualified_request_timer_0_s1;
  wire             cpu_0_data_master_read;
  wire             cpu_0_data_master_read_data_valid_In0_s1;
  wire             cpu_0_data_master_read_data_valid_In1_s1;
  wire             cpu_0_data_master_read_data_valid_In2_s1;
  wire             cpu_0_data_master_read_data_valid_Out0_s1;
  wire             cpu_0_data_master_read_data_valid_Out1_s1;
  wire             cpu_0_data_master_read_data_valid_Out2_s1;
  wire             cpu_0_data_master_read_data_valid_Out3_s1;
  wire             cpu_0_data_master_read_data_valid_Out4_s1;
  wire             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire             cpu_0_data_master_read_data_valid_lcd_control_slave;
  wire             cpu_0_data_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_data_master_read_data_valid_timer_0_s1;
  wire    [ 31: 0] cpu_0_data_master_readdata;
  wire             cpu_0_data_master_requests_In0_s1;
  wire             cpu_0_data_master_requests_In1_s1;
  wire             cpu_0_data_master_requests_In2_s1;
  wire             cpu_0_data_master_requests_Out0_s1;
  wire             cpu_0_data_master_requests_Out1_s1;
  wire             cpu_0_data_master_requests_Out2_s1;
  wire             cpu_0_data_master_requests_Out3_s1;
  wire             cpu_0_data_master_requests_Out4_s1;
  wire             cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave;
  wire             cpu_0_data_master_requests_lcd_control_slave;
  wire             cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_data_master_requests_timer_0_s1;
  wire             cpu_0_data_master_waitrequest;
  wire             cpu_0_data_master_write;
  wire    [ 31: 0] cpu_0_data_master_writedata;
  wire    [ 19: 0] cpu_0_instruction_master_address;
  wire    [ 19: 0] cpu_0_instruction_master_address_to_slave;
  wire    [  1: 0] cpu_0_instruction_master_dbs_address;
  wire             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_instruction_master_latency_counter;
  wire             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_instruction_master_read;
  wire             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0;
  wire    [ 31: 0] cpu_0_instruction_master_readdata;
  wire             cpu_0_instruction_master_readdatavalid;
  wire             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0;
  wire             cpu_0_instruction_master_waitrequest;
  wire    [  8: 0] cpu_0_jtag_debug_module_address;
  wire             cpu_0_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_0_jtag_debug_module_byteenable;
  wire             cpu_0_jtag_debug_module_chipselect;
  wire             cpu_0_jtag_debug_module_debugaccess;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  wire             cpu_0_jtag_debug_module_reset;
  wire             cpu_0_jtag_debug_module_reset_n;
  wire             cpu_0_jtag_debug_module_resetrequest;
  wire             cpu_0_jtag_debug_module_resetrequest_from_sa;
  wire             cpu_0_jtag_debug_module_write;
  wire    [ 31: 0] cpu_0_jtag_debug_module_writedata;
  wire             d1_In0_s1_end_xfer;
  wire             d1_In1_s1_end_xfer;
  wire             d1_In2_s1_end_xfer;
  wire             d1_Out0_s1_end_xfer;
  wire             d1_Out1_s1_end_xfer;
  wire             d1_Out2_s1_end_xfer;
  wire             d1_Out3_s1_end_xfer;
  wire             d1_Out4_s1_end_xfer;
  wire             d1_cpu_0_jtag_debug_module_end_xfer;
  wire             d1_jtag_uart_avalon_jtag_slave_end_xfer;
  wire             d1_lcd_control_slave_end_xfer;
  wire             d1_sram_16bit_512k_0_avalon_slave_0_end_xfer;
  wire             d1_timer_0_s1_end_xfer;
  wire             jtag_uart_avalon_jtag_slave_address;
  wire             jtag_uart_avalon_jtag_slave_chipselect;
  wire             jtag_uart_avalon_jtag_slave_dataavailable;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_irq;
  wire             jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_reset_n;
  wire             jtag_uart_avalon_jtag_slave_waitrequest;
  wire             jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  wire    [  1: 0] lcd_control_slave_address;
  wire             lcd_control_slave_begintransfer;
  wire             lcd_control_slave_irq;
  wire             lcd_control_slave_read;
  wire    [  7: 0] lcd_control_slave_readdata;
  wire    [  7: 0] lcd_control_slave_readdata_from_sa;
  wire             lcd_control_slave_wait_counter_eq_0;
  wire             lcd_control_slave_wait_counter_eq_1;
  wire             lcd_control_slave_write;
  wire    [  7: 0] lcd_control_slave_writedata;
  wire             out_port_from_the_Out0;
  wire    [ 17: 0] out_port_from_the_Out1;
  wire    [  9: 0] out_port_from_the_Out2;
  wire    [  9: 0] out_port_from_the_Out3;
  wire    [  9: 0] out_port_from_the_Out4;
  wire             reset_n_sources;
  wire    [ 17: 0] sram_16bit_512k_0_avalon_slave_0_address;
  wire    [  1: 0] sram_16bit_512k_0_avalon_slave_0_byteenable_n;
  wire             sram_16bit_512k_0_avalon_slave_0_chipselect_n;
  wire             sram_16bit_512k_0_avalon_slave_0_read_n;
  wire    [ 15: 0] sram_16bit_512k_0_avalon_slave_0_readdata;
  wire    [ 15: 0] sram_16bit_512k_0_avalon_slave_0_readdata_from_sa;
  wire             sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0;
  wire             sram_16bit_512k_0_avalon_slave_0_write_n;
  wire    [ 15: 0] sram_16bit_512k_0_avalon_slave_0_writedata;
  wire    [  2: 0] timer_0_s1_address;
  wire             timer_0_s1_chipselect;
  wire             timer_0_s1_irq;
  wire             timer_0_s1_irq_from_sa;
  wire    [ 15: 0] timer_0_s1_readdata;
  wire    [ 15: 0] timer_0_s1_readdata_from_sa;
  wire             timer_0_s1_reset_n;
  wire             timer_0_s1_write_n;
  wire    [ 15: 0] timer_0_s1_writedata;
  In0_s1_arbitrator the_In0_s1
    (
      .In0_s1_address                             (In0_s1_address),
      .In0_s1_readdata                            (In0_s1_readdata),
      .In0_s1_readdata_from_sa                    (In0_s1_readdata_from_sa),
      .In0_s1_reset_n                             (In0_s1_reset_n),
      .clk                                        (clk),
      .cpu_0_data_master_address_to_slave         (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_In0_s1           (cpu_0_data_master_granted_In0_s1),
      .cpu_0_data_master_qualified_request_In0_s1 (cpu_0_data_master_qualified_request_In0_s1),
      .cpu_0_data_master_read                     (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_In0_s1   (cpu_0_data_master_read_data_valid_In0_s1),
      .cpu_0_data_master_requests_In0_s1          (cpu_0_data_master_requests_In0_s1),
      .cpu_0_data_master_write                    (cpu_0_data_master_write),
      .d1_In0_s1_end_xfer                         (d1_In0_s1_end_xfer),
      .reset_n                                    (clk_reset_n)
    );

  In0 the_In0
    (
      .address  (In0_s1_address),
      .clk      (clk),
      .in_port  (in_port_to_the_In0),
      .readdata (In0_s1_readdata),
      .reset_n  (In0_s1_reset_n)
    );

  In1_s1_arbitrator the_In1_s1
    (
      .In1_s1_address                             (In1_s1_address),
      .In1_s1_readdata                            (In1_s1_readdata),
      .In1_s1_readdata_from_sa                    (In1_s1_readdata_from_sa),
      .In1_s1_reset_n                             (In1_s1_reset_n),
      .clk                                        (clk),
      .cpu_0_data_master_address_to_slave         (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_In1_s1           (cpu_0_data_master_granted_In1_s1),
      .cpu_0_data_master_qualified_request_In1_s1 (cpu_0_data_master_qualified_request_In1_s1),
      .cpu_0_data_master_read                     (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_In1_s1   (cpu_0_data_master_read_data_valid_In1_s1),
      .cpu_0_data_master_requests_In1_s1          (cpu_0_data_master_requests_In1_s1),
      .cpu_0_data_master_write                    (cpu_0_data_master_write),
      .d1_In1_s1_end_xfer                         (d1_In1_s1_end_xfer),
      .reset_n                                    (clk_reset_n)
    );

  In1 the_In1
    (
      .address  (In1_s1_address),
      .clk      (clk),
      .in_port  (in_port_to_the_In1),
      .readdata (In1_s1_readdata),
      .reset_n  (In1_s1_reset_n)
    );

  In2_s1_arbitrator the_In2_s1
    (
      .In2_s1_address                             (In2_s1_address),
      .In2_s1_readdata                            (In2_s1_readdata),
      .In2_s1_readdata_from_sa                    (In2_s1_readdata_from_sa),
      .In2_s1_reset_n                             (In2_s1_reset_n),
      .clk                                        (clk),
      .cpu_0_data_master_address_to_slave         (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_In2_s1           (cpu_0_data_master_granted_In2_s1),
      .cpu_0_data_master_qualified_request_In2_s1 (cpu_0_data_master_qualified_request_In2_s1),
      .cpu_0_data_master_read                     (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_In2_s1   (cpu_0_data_master_read_data_valid_In2_s1),
      .cpu_0_data_master_requests_In2_s1          (cpu_0_data_master_requests_In2_s1),
      .cpu_0_data_master_write                    (cpu_0_data_master_write),
      .d1_In2_s1_end_xfer                         (d1_In2_s1_end_xfer),
      .reset_n                                    (clk_reset_n)
    );

  In2 the_In2
    (
      .address  (In2_s1_address),
      .clk      (clk),
      .in_port  (in_port_to_the_In2),
      .readdata (In2_s1_readdata),
      .reset_n  (In2_s1_reset_n)
    );

  Out0_s1_arbitrator the_Out0_s1
    (
      .Out0_s1_address                             (Out0_s1_address),
      .Out0_s1_chipselect                          (Out0_s1_chipselect),
      .Out0_s1_reset_n                             (Out0_s1_reset_n),
      .Out0_s1_write_n                             (Out0_s1_write_n),
      .Out0_s1_writedata                           (Out0_s1_writedata),
      .clk                                         (clk),
      .cpu_0_data_master_address_to_slave          (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_Out0_s1           (cpu_0_data_master_granted_Out0_s1),
      .cpu_0_data_master_qualified_request_Out0_s1 (cpu_0_data_master_qualified_request_Out0_s1),
      .cpu_0_data_master_read                      (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_Out0_s1   (cpu_0_data_master_read_data_valid_Out0_s1),
      .cpu_0_data_master_requests_Out0_s1          (cpu_0_data_master_requests_Out0_s1),
      .cpu_0_data_master_waitrequest               (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                     (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                 (cpu_0_data_master_writedata),
      .d1_Out0_s1_end_xfer                         (d1_Out0_s1_end_xfer),
      .reset_n                                     (clk_reset_n)
    );

  Out0 the_Out0
    (
      .address    (Out0_s1_address),
      .chipselect (Out0_s1_chipselect),
      .clk        (clk),
      .out_port   (out_port_from_the_Out0),
      .reset_n    (Out0_s1_reset_n),
      .write_n    (Out0_s1_write_n),
      .writedata  (Out0_s1_writedata)
    );

  Out1_s1_arbitrator the_Out1_s1
    (
      .Out1_s1_address                             (Out1_s1_address),
      .Out1_s1_chipselect                          (Out1_s1_chipselect),
      .Out1_s1_reset_n                             (Out1_s1_reset_n),
      .Out1_s1_write_n                             (Out1_s1_write_n),
      .Out1_s1_writedata                           (Out1_s1_writedata),
      .clk                                         (clk),
      .cpu_0_data_master_address_to_slave          (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_Out1_s1           (cpu_0_data_master_granted_Out1_s1),
      .cpu_0_data_master_qualified_request_Out1_s1 (cpu_0_data_master_qualified_request_Out1_s1),
      .cpu_0_data_master_read                      (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_Out1_s1   (cpu_0_data_master_read_data_valid_Out1_s1),
      .cpu_0_data_master_requests_Out1_s1          (cpu_0_data_master_requests_Out1_s1),
      .cpu_0_data_master_waitrequest               (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                     (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                 (cpu_0_data_master_writedata),
      .d1_Out1_s1_end_xfer                         (d1_Out1_s1_end_xfer),
      .reset_n                                     (clk_reset_n)
    );

  Out1 the_Out1
    (
      .address    (Out1_s1_address),
      .chipselect (Out1_s1_chipselect),
      .clk        (clk),
      .out_port   (out_port_from_the_Out1),
      .reset_n    (Out1_s1_reset_n),
      .write_n    (Out1_s1_write_n),
      .writedata  (Out1_s1_writedata)
    );

  Out2_s1_arbitrator the_Out2_s1
    (
      .Out2_s1_address                             (Out2_s1_address),
      .Out2_s1_chipselect                          (Out2_s1_chipselect),
      .Out2_s1_reset_n                             (Out2_s1_reset_n),
      .Out2_s1_write_n                             (Out2_s1_write_n),
      .Out2_s1_writedata                           (Out2_s1_writedata),
      .clk                                         (clk),
      .cpu_0_data_master_address_to_slave          (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_Out2_s1           (cpu_0_data_master_granted_Out2_s1),
      .cpu_0_data_master_qualified_request_Out2_s1 (cpu_0_data_master_qualified_request_Out2_s1),
      .cpu_0_data_master_read                      (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_Out2_s1   (cpu_0_data_master_read_data_valid_Out2_s1),
      .cpu_0_data_master_requests_Out2_s1          (cpu_0_data_master_requests_Out2_s1),
      .cpu_0_data_master_waitrequest               (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                     (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                 (cpu_0_data_master_writedata),
      .d1_Out2_s1_end_xfer                         (d1_Out2_s1_end_xfer),
      .reset_n                                     (clk_reset_n)
    );

  Out2 the_Out2
    (
      .address    (Out2_s1_address),
      .chipselect (Out2_s1_chipselect),
      .clk        (clk),
      .out_port   (out_port_from_the_Out2),
      .reset_n    (Out2_s1_reset_n),
      .write_n    (Out2_s1_write_n),
      .writedata  (Out2_s1_writedata)
    );

  Out3_s1_arbitrator the_Out3_s1
    (
      .Out3_s1_address                             (Out3_s1_address),
      .Out3_s1_chipselect                          (Out3_s1_chipselect),
      .Out3_s1_reset_n                             (Out3_s1_reset_n),
      .Out3_s1_write_n                             (Out3_s1_write_n),
      .Out3_s1_writedata                           (Out3_s1_writedata),
      .clk                                         (clk),
      .cpu_0_data_master_address_to_slave          (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_Out3_s1           (cpu_0_data_master_granted_Out3_s1),
      .cpu_0_data_master_qualified_request_Out3_s1 (cpu_0_data_master_qualified_request_Out3_s1),
      .cpu_0_data_master_read                      (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_Out3_s1   (cpu_0_data_master_read_data_valid_Out3_s1),
      .cpu_0_data_master_requests_Out3_s1          (cpu_0_data_master_requests_Out3_s1),
      .cpu_0_data_master_waitrequest               (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                     (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                 (cpu_0_data_master_writedata),
      .d1_Out3_s1_end_xfer                         (d1_Out3_s1_end_xfer),
      .reset_n                                     (clk_reset_n)
    );

  Out3 the_Out3
    (
      .address    (Out3_s1_address),
      .chipselect (Out3_s1_chipselect),
      .clk        (clk),
      .out_port   (out_port_from_the_Out3),
      .reset_n    (Out3_s1_reset_n),
      .write_n    (Out3_s1_write_n),
      .writedata  (Out3_s1_writedata)
    );

  Out4_s1_arbitrator the_Out4_s1
    (
      .Out4_s1_address                             (Out4_s1_address),
      .Out4_s1_chipselect                          (Out4_s1_chipselect),
      .Out4_s1_reset_n                             (Out4_s1_reset_n),
      .Out4_s1_write_n                             (Out4_s1_write_n),
      .Out4_s1_writedata                           (Out4_s1_writedata),
      .clk                                         (clk),
      .cpu_0_data_master_address_to_slave          (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_Out4_s1           (cpu_0_data_master_granted_Out4_s1),
      .cpu_0_data_master_qualified_request_Out4_s1 (cpu_0_data_master_qualified_request_Out4_s1),
      .cpu_0_data_master_read                      (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_Out4_s1   (cpu_0_data_master_read_data_valid_Out4_s1),
      .cpu_0_data_master_requests_Out4_s1          (cpu_0_data_master_requests_Out4_s1),
      .cpu_0_data_master_waitrequest               (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                     (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                 (cpu_0_data_master_writedata),
      .d1_Out4_s1_end_xfer                         (d1_Out4_s1_end_xfer),
      .reset_n                                     (clk_reset_n)
    );

  Out4 the_Out4
    (
      .address    (Out4_s1_address),
      .chipselect (Out4_s1_chipselect),
      .clk        (clk),
      .out_port   (out_port_from_the_Out4),
      .reset_n    (Out4_s1_reset_n),
      .write_n    (Out4_s1_write_n),
      .writedata  (Out4_s1_writedata)
    );

  cpu_0_jtag_debug_module_arbitrator the_cpu_0_jtag_debug_module
    (
      .clk                                                                (clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_debugaccess                                      (cpu_0_data_master_debugaccess),
      .cpu_0_data_master_granted_cpu_0_jtag_debug_module                  (cpu_0_data_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module        (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module          (cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_data_master_requests_cpu_0_jtag_debug_module                 (cpu_0_data_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                        (cpu_0_data_master_writedata),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_granted_cpu_0_jtag_debug_module           (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module   (cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_requests_cpu_0_jtag_debug_module          (cpu_0_instruction_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_jtag_debug_module_address                                    (cpu_0_jtag_debug_module_address),
      .cpu_0_jtag_debug_module_begintransfer                              (cpu_0_jtag_debug_module_begintransfer),
      .cpu_0_jtag_debug_module_byteenable                                 (cpu_0_jtag_debug_module_byteenable),
      .cpu_0_jtag_debug_module_chipselect                                 (cpu_0_jtag_debug_module_chipselect),
      .cpu_0_jtag_debug_module_debugaccess                                (cpu_0_jtag_debug_module_debugaccess),
      .cpu_0_jtag_debug_module_readdata                                   (cpu_0_jtag_debug_module_readdata),
      .cpu_0_jtag_debug_module_readdata_from_sa                           (cpu_0_jtag_debug_module_readdata_from_sa),
      .cpu_0_jtag_debug_module_reset                                      (cpu_0_jtag_debug_module_reset),
      .cpu_0_jtag_debug_module_reset_n                                    (cpu_0_jtag_debug_module_reset_n),
      .cpu_0_jtag_debug_module_resetrequest                               (cpu_0_jtag_debug_module_resetrequest),
      .cpu_0_jtag_debug_module_resetrequest_from_sa                       (cpu_0_jtag_debug_module_resetrequest_from_sa),
      .cpu_0_jtag_debug_module_write                                      (cpu_0_jtag_debug_module_write),
      .cpu_0_jtag_debug_module_writedata                                  (cpu_0_jtag_debug_module_writedata),
      .d1_cpu_0_jtag_debug_module_end_xfer                                (d1_cpu_0_jtag_debug_module_end_xfer),
      .reset_n                                                            (clk_reset_n)
    );

  cpu_0_data_master_arbitrator the_cpu_0_data_master
    (
      .In0_s1_readdata_from_sa                                              (In0_s1_readdata_from_sa),
      .In1_s1_readdata_from_sa                                              (In1_s1_readdata_from_sa),
      .In2_s1_readdata_from_sa                                              (In2_s1_readdata_from_sa),
      .clk                                                                  (clk),
      .cpu_0_data_master_address                                            (cpu_0_data_master_address),
      .cpu_0_data_master_address_to_slave                                   (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0        (cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_data_master_dbs_address                                        (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_16                                       (cpu_0_data_master_dbs_write_16),
      .cpu_0_data_master_debugaccess                                        (cpu_0_data_master_debugaccess),
      .cpu_0_data_master_granted_In0_s1                                     (cpu_0_data_master_granted_In0_s1),
      .cpu_0_data_master_granted_In1_s1                                     (cpu_0_data_master_granted_In1_s1),
      .cpu_0_data_master_granted_In2_s1                                     (cpu_0_data_master_granted_In2_s1),
      .cpu_0_data_master_granted_Out0_s1                                    (cpu_0_data_master_granted_Out0_s1),
      .cpu_0_data_master_granted_Out1_s1                                    (cpu_0_data_master_granted_Out1_s1),
      .cpu_0_data_master_granted_Out2_s1                                    (cpu_0_data_master_granted_Out2_s1),
      .cpu_0_data_master_granted_Out3_s1                                    (cpu_0_data_master_granted_Out3_s1),
      .cpu_0_data_master_granted_Out4_s1                                    (cpu_0_data_master_granted_Out4_s1),
      .cpu_0_data_master_granted_cpu_0_jtag_debug_module                    (cpu_0_data_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave                (cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave),
      .cpu_0_data_master_granted_lcd_control_slave                          (cpu_0_data_master_granted_lcd_control_slave),
      .cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0           (cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_data_master_granted_timer_0_s1                                 (cpu_0_data_master_granted_timer_0_s1),
      .cpu_0_data_master_irq                                                (cpu_0_data_master_irq),
      .cpu_0_data_master_no_byte_enables_and_last_term                      (cpu_0_data_master_no_byte_enables_and_last_term),
      .cpu_0_data_master_qualified_request_In0_s1                           (cpu_0_data_master_qualified_request_In0_s1),
      .cpu_0_data_master_qualified_request_In1_s1                           (cpu_0_data_master_qualified_request_In1_s1),
      .cpu_0_data_master_qualified_request_In2_s1                           (cpu_0_data_master_qualified_request_In2_s1),
      .cpu_0_data_master_qualified_request_Out0_s1                          (cpu_0_data_master_qualified_request_Out0_s1),
      .cpu_0_data_master_qualified_request_Out1_s1                          (cpu_0_data_master_qualified_request_Out1_s1),
      .cpu_0_data_master_qualified_request_Out2_s1                          (cpu_0_data_master_qualified_request_Out2_s1),
      .cpu_0_data_master_qualified_request_Out3_s1                          (cpu_0_data_master_qualified_request_Out3_s1),
      .cpu_0_data_master_qualified_request_Out4_s1                          (cpu_0_data_master_qualified_request_Out4_s1),
      .cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module          (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave      (cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave),
      .cpu_0_data_master_qualified_request_lcd_control_slave                (cpu_0_data_master_qualified_request_lcd_control_slave),
      .cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 (cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_data_master_qualified_request_timer_0_s1                       (cpu_0_data_master_qualified_request_timer_0_s1),
      .cpu_0_data_master_read                                               (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_In0_s1                             (cpu_0_data_master_read_data_valid_In0_s1),
      .cpu_0_data_master_read_data_valid_In1_s1                             (cpu_0_data_master_read_data_valid_In1_s1),
      .cpu_0_data_master_read_data_valid_In2_s1                             (cpu_0_data_master_read_data_valid_In2_s1),
      .cpu_0_data_master_read_data_valid_Out0_s1                            (cpu_0_data_master_read_data_valid_Out0_s1),
      .cpu_0_data_master_read_data_valid_Out1_s1                            (cpu_0_data_master_read_data_valid_Out1_s1),
      .cpu_0_data_master_read_data_valid_Out2_s1                            (cpu_0_data_master_read_data_valid_Out2_s1),
      .cpu_0_data_master_read_data_valid_Out3_s1                            (cpu_0_data_master_read_data_valid_Out3_s1),
      .cpu_0_data_master_read_data_valid_Out4_s1                            (cpu_0_data_master_read_data_valid_Out4_s1),
      .cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module            (cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_data_master_read_data_valid_jtag_uart_avalon_jtag_slave        (cpu_0_data_master_read_data_valid_jtag_uart_avalon_jtag_slave),
      .cpu_0_data_master_read_data_valid_lcd_control_slave                  (cpu_0_data_master_read_data_valid_lcd_control_slave),
      .cpu_0_data_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0   (cpu_0_data_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_data_master_read_data_valid_timer_0_s1                         (cpu_0_data_master_read_data_valid_timer_0_s1),
      .cpu_0_data_master_readdata                                           (cpu_0_data_master_readdata),
      .cpu_0_data_master_requests_In0_s1                                    (cpu_0_data_master_requests_In0_s1),
      .cpu_0_data_master_requests_In1_s1                                    (cpu_0_data_master_requests_In1_s1),
      .cpu_0_data_master_requests_In2_s1                                    (cpu_0_data_master_requests_In2_s1),
      .cpu_0_data_master_requests_Out0_s1                                   (cpu_0_data_master_requests_Out0_s1),
      .cpu_0_data_master_requests_Out1_s1                                   (cpu_0_data_master_requests_Out1_s1),
      .cpu_0_data_master_requests_Out2_s1                                   (cpu_0_data_master_requests_Out2_s1),
      .cpu_0_data_master_requests_Out3_s1                                   (cpu_0_data_master_requests_Out3_s1),
      .cpu_0_data_master_requests_Out4_s1                                   (cpu_0_data_master_requests_Out4_s1),
      .cpu_0_data_master_requests_cpu_0_jtag_debug_module                   (cpu_0_data_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave               (cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave),
      .cpu_0_data_master_requests_lcd_control_slave                         (cpu_0_data_master_requests_lcd_control_slave),
      .cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0          (cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_data_master_requests_timer_0_s1                                (cpu_0_data_master_requests_timer_0_s1),
      .cpu_0_data_master_waitrequest                                        (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                              (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                          (cpu_0_data_master_writedata),
      .cpu_0_jtag_debug_module_readdata_from_sa                             (cpu_0_jtag_debug_module_readdata_from_sa),
      .d1_In0_s1_end_xfer                                                   (d1_In0_s1_end_xfer),
      .d1_In1_s1_end_xfer                                                   (d1_In1_s1_end_xfer),
      .d1_In2_s1_end_xfer                                                   (d1_In2_s1_end_xfer),
      .d1_Out0_s1_end_xfer                                                  (d1_Out0_s1_end_xfer),
      .d1_Out1_s1_end_xfer                                                  (d1_Out1_s1_end_xfer),
      .d1_Out2_s1_end_xfer                                                  (d1_Out2_s1_end_xfer),
      .d1_Out3_s1_end_xfer                                                  (d1_Out3_s1_end_xfer),
      .d1_Out4_s1_end_xfer                                                  (d1_Out4_s1_end_xfer),
      .d1_cpu_0_jtag_debug_module_end_xfer                                  (d1_cpu_0_jtag_debug_module_end_xfer),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                              (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .d1_lcd_control_slave_end_xfer                                        (d1_lcd_control_slave_end_xfer),
      .d1_sram_16bit_512k_0_avalon_slave_0_end_xfer                         (d1_sram_16bit_512k_0_avalon_slave_0_end_xfer),
      .d1_timer_0_s1_end_xfer                                               (d1_timer_0_s1_end_xfer),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                              (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                         (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                      (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .lcd_control_slave_readdata_from_sa                                   (lcd_control_slave_readdata_from_sa),
      .lcd_control_slave_wait_counter_eq_0                                  (lcd_control_slave_wait_counter_eq_0),
      .lcd_control_slave_wait_counter_eq_1                                  (lcd_control_slave_wait_counter_eq_1),
      .reset_n                                                              (clk_reset_n),
      .sram_16bit_512k_0_avalon_slave_0_readdata_from_sa                    (sram_16bit_512k_0_avalon_slave_0_readdata_from_sa),
      .sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0                   (sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0),
      .timer_0_s1_irq_from_sa                                               (timer_0_s1_irq_from_sa),
      .timer_0_s1_readdata_from_sa                                          (timer_0_s1_readdata_from_sa)
    );

  cpu_0_instruction_master_arbitrator the_cpu_0_instruction_master
    (
      .clk                                                                         (clk),
      .cpu_0_instruction_master_address                                            (cpu_0_instruction_master_address),
      .cpu_0_instruction_master_address_to_slave                                   (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                                        (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_cpu_0_jtag_debug_module                    (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0           (cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_instruction_master_latency_counter                                    (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module          (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 (cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_instruction_master_read                                               (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module            (cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0   (cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_instruction_master_readdata                                           (cpu_0_instruction_master_readdata),
      .cpu_0_instruction_master_readdatavalid                                      (cpu_0_instruction_master_readdatavalid),
      .cpu_0_instruction_master_requests_cpu_0_jtag_debug_module                   (cpu_0_instruction_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0          (cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_instruction_master_waitrequest                                        (cpu_0_instruction_master_waitrequest),
      .cpu_0_jtag_debug_module_readdata_from_sa                                    (cpu_0_jtag_debug_module_readdata_from_sa),
      .d1_cpu_0_jtag_debug_module_end_xfer                                         (d1_cpu_0_jtag_debug_module_end_xfer),
      .d1_sram_16bit_512k_0_avalon_slave_0_end_xfer                                (d1_sram_16bit_512k_0_avalon_slave_0_end_xfer),
      .reset_n                                                                     (clk_reset_n),
      .sram_16bit_512k_0_avalon_slave_0_readdata_from_sa                           (sram_16bit_512k_0_avalon_slave_0_readdata_from_sa),
      .sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0                          (sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0)
    );

  cpu_0 the_cpu_0
    (
      .clk                                   (clk),
      .d_address                             (cpu_0_data_master_address),
      .d_byteenable                          (cpu_0_data_master_byteenable),
      .d_irq                                 (cpu_0_data_master_irq),
      .d_read                                (cpu_0_data_master_read),
      .d_readdata                            (cpu_0_data_master_readdata),
      .d_waitrequest                         (cpu_0_data_master_waitrequest),
      .d_write                               (cpu_0_data_master_write),
      .d_writedata                           (cpu_0_data_master_writedata),
      .i_address                             (cpu_0_instruction_master_address),
      .i_read                                (cpu_0_instruction_master_read),
      .i_readdata                            (cpu_0_instruction_master_readdata),
      .i_readdatavalid                       (cpu_0_instruction_master_readdatavalid),
      .i_waitrequest                         (cpu_0_instruction_master_waitrequest),
      .jtag_debug_module_address             (cpu_0_jtag_debug_module_address),
      .jtag_debug_module_begintransfer       (cpu_0_jtag_debug_module_begintransfer),
      .jtag_debug_module_byteenable          (cpu_0_jtag_debug_module_byteenable),
      .jtag_debug_module_clk                 (clk),
      .jtag_debug_module_debugaccess         (cpu_0_jtag_debug_module_debugaccess),
      .jtag_debug_module_debugaccess_to_roms (cpu_0_data_master_debugaccess),
      .jtag_debug_module_readdata            (cpu_0_jtag_debug_module_readdata),
      .jtag_debug_module_reset               (cpu_0_jtag_debug_module_reset),
      .jtag_debug_module_resetrequest        (cpu_0_jtag_debug_module_resetrequest),
      .jtag_debug_module_select              (cpu_0_jtag_debug_module_chipselect),
      .jtag_debug_module_write               (cpu_0_jtag_debug_module_write),
      .jtag_debug_module_writedata           (cpu_0_jtag_debug_module_writedata),
      .reset_n                               (cpu_0_jtag_debug_module_reset_n)
    );

  jtag_uart_avalon_jtag_slave_arbitrator the_jtag_uart_avalon_jtag_slave
    (
      .clk                                                             (clk),
      .cpu_0_data_master_address_to_slave                              (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave           (cpu_0_data_master_granted_jtag_uart_avalon_jtag_slave),
      .cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave (cpu_0_data_master_qualified_request_jtag_uart_avalon_jtag_slave),
      .cpu_0_data_master_read                                          (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_jtag_uart_avalon_jtag_slave   (cpu_0_data_master_read_data_valid_jtag_uart_avalon_jtag_slave),
      .cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave          (cpu_0_data_master_requests_jtag_uart_avalon_jtag_slave),
      .cpu_0_data_master_waitrequest                                   (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                         (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                     (cpu_0_data_master_writedata),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                         (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .jtag_uart_avalon_jtag_slave_address                             (jtag_uart_avalon_jtag_slave_address),
      .jtag_uart_avalon_jtag_slave_chipselect                          (jtag_uart_avalon_jtag_slave_chipselect),
      .jtag_uart_avalon_jtag_slave_dataavailable                       (jtag_uart_avalon_jtag_slave_dataavailable),
      .jtag_uart_avalon_jtag_slave_dataavailable_from_sa               (jtag_uart_avalon_jtag_slave_dataavailable_from_sa),
      .jtag_uart_avalon_jtag_slave_irq                                 (jtag_uart_avalon_jtag_slave_irq),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                         (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_avalon_jtag_slave_read_n                              (jtag_uart_avalon_jtag_slave_read_n),
      .jtag_uart_avalon_jtag_slave_readdata                            (jtag_uart_avalon_jtag_slave_readdata),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                    (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_readyfordata                        (jtag_uart_avalon_jtag_slave_readyfordata),
      .jtag_uart_avalon_jtag_slave_readyfordata_from_sa                (jtag_uart_avalon_jtag_slave_readyfordata_from_sa),
      .jtag_uart_avalon_jtag_slave_reset_n                             (jtag_uart_avalon_jtag_slave_reset_n),
      .jtag_uart_avalon_jtag_slave_waitrequest                         (jtag_uart_avalon_jtag_slave_waitrequest),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                 (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .jtag_uart_avalon_jtag_slave_write_n                             (jtag_uart_avalon_jtag_slave_write_n),
      .jtag_uart_avalon_jtag_slave_writedata                           (jtag_uart_avalon_jtag_slave_writedata),
      .reset_n                                                         (clk_reset_n)
    );

  jtag_uart the_jtag_uart
    (
      .av_address     (jtag_uart_avalon_jtag_slave_address),
      .av_chipselect  (jtag_uart_avalon_jtag_slave_chipselect),
      .av_irq         (jtag_uart_avalon_jtag_slave_irq),
      .av_read_n      (jtag_uart_avalon_jtag_slave_read_n),
      .av_readdata    (jtag_uart_avalon_jtag_slave_readdata),
      .av_waitrequest (jtag_uart_avalon_jtag_slave_waitrequest),
      .av_write_n     (jtag_uart_avalon_jtag_slave_write_n),
      .av_writedata   (jtag_uart_avalon_jtag_slave_writedata),
      .clk            (clk),
      .dataavailable  (jtag_uart_avalon_jtag_slave_dataavailable),
      .readyfordata   (jtag_uart_avalon_jtag_slave_readyfordata),
      .rst_n          (jtag_uart_avalon_jtag_slave_reset_n)
    );

  lcd_control_slave_arbitrator the_lcd_control_slave
    (
      .clk                                                   (clk),
      .cpu_0_data_master_address_to_slave                    (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                          (cpu_0_data_master_byteenable),
      .cpu_0_data_master_granted_lcd_control_slave           (cpu_0_data_master_granted_lcd_control_slave),
      .cpu_0_data_master_qualified_request_lcd_control_slave (cpu_0_data_master_qualified_request_lcd_control_slave),
      .cpu_0_data_master_read                                (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_lcd_control_slave   (cpu_0_data_master_read_data_valid_lcd_control_slave),
      .cpu_0_data_master_requests_lcd_control_slave          (cpu_0_data_master_requests_lcd_control_slave),
      .cpu_0_data_master_write                               (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                           (cpu_0_data_master_writedata),
      .d1_lcd_control_slave_end_xfer                         (d1_lcd_control_slave_end_xfer),
      .lcd_control_slave_address                             (lcd_control_slave_address),
      .lcd_control_slave_begintransfer                       (lcd_control_slave_begintransfer),
      .lcd_control_slave_read                                (lcd_control_slave_read),
      .lcd_control_slave_readdata                            (lcd_control_slave_readdata),
      .lcd_control_slave_readdata_from_sa                    (lcd_control_slave_readdata_from_sa),
      .lcd_control_slave_wait_counter_eq_0                   (lcd_control_slave_wait_counter_eq_0),
      .lcd_control_slave_wait_counter_eq_1                   (lcd_control_slave_wait_counter_eq_1),
      .lcd_control_slave_write                               (lcd_control_slave_write),
      .lcd_control_slave_writedata                           (lcd_control_slave_writedata),
      .reset_n                                               (clk_reset_n)
    );

  lcd the_lcd
    (
      .LCD_E         (LCD_E_from_the_lcd),
      .LCD_RS        (LCD_RS_from_the_lcd),
      .LCD_RW        (LCD_RW_from_the_lcd),
      .LCD_data      (LCD_data_to_and_from_the_lcd),
      .address       (lcd_control_slave_address),
      .begintransfer (lcd_control_slave_begintransfer),
      .irq           (lcd_control_slave_irq),
      .read          (lcd_control_slave_read),
      .readdata      (lcd_control_slave_readdata),
      .write         (lcd_control_slave_write),
      .writedata     (lcd_control_slave_writedata)
    );

  sram_16bit_512k_0_avalon_slave_0_arbitrator the_sram_16bit_512k_0_avalon_slave_0
    (
      .clk                                                                         (clk),
      .cpu_0_data_master_address_to_slave                                          (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                                (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0               (cpu_0_data_master_byteenable_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_data_master_dbs_address                                               (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_16                                              (cpu_0_data_master_dbs_write_16),
      .cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0                  (cpu_0_data_master_granted_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_data_master_no_byte_enables_and_last_term                             (cpu_0_data_master_no_byte_enables_and_last_term),
      .cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0        (cpu_0_data_master_qualified_request_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_data_master_read                                                      (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0          (cpu_0_data_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0                 (cpu_0_data_master_requests_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_data_master_write                                                     (cpu_0_data_master_write),
      .cpu_0_instruction_master_address_to_slave                                   (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                                        (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0           (cpu_0_instruction_master_granted_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_instruction_master_latency_counter                                    (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0 (cpu_0_instruction_master_qualified_request_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_instruction_master_read                                               (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0   (cpu_0_instruction_master_read_data_valid_sram_16bit_512k_0_avalon_slave_0),
      .cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0          (cpu_0_instruction_master_requests_sram_16bit_512k_0_avalon_slave_0),
      .d1_sram_16bit_512k_0_avalon_slave_0_end_xfer                                (d1_sram_16bit_512k_0_avalon_slave_0_end_xfer),
      .reset_n                                                                     (clk_reset_n),
      .sram_16bit_512k_0_avalon_slave_0_address                                    (sram_16bit_512k_0_avalon_slave_0_address),
      .sram_16bit_512k_0_avalon_slave_0_byteenable_n                               (sram_16bit_512k_0_avalon_slave_0_byteenable_n),
      .sram_16bit_512k_0_avalon_slave_0_chipselect_n                               (sram_16bit_512k_0_avalon_slave_0_chipselect_n),
      .sram_16bit_512k_0_avalon_slave_0_read_n                                     (sram_16bit_512k_0_avalon_slave_0_read_n),
      .sram_16bit_512k_0_avalon_slave_0_readdata                                   (sram_16bit_512k_0_avalon_slave_0_readdata),
      .sram_16bit_512k_0_avalon_slave_0_readdata_from_sa                           (sram_16bit_512k_0_avalon_slave_0_readdata_from_sa),
      .sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0                          (sram_16bit_512k_0_avalon_slave_0_wait_counter_eq_0),
      .sram_16bit_512k_0_avalon_slave_0_write_n                                    (sram_16bit_512k_0_avalon_slave_0_write_n),
      .sram_16bit_512k_0_avalon_slave_0_writedata                                  (sram_16bit_512k_0_avalon_slave_0_writedata)
    );

  sram_16bit_512k_0 the_sram_16bit_512k_0
    (
      .SRAM_ADDR (SRAM_ADDR_from_the_sram_16bit_512k_0),
      .SRAM_CE_N (SRAM_CE_N_from_the_sram_16bit_512k_0),
      .SRAM_DQ   (SRAM_DQ_to_and_from_the_sram_16bit_512k_0),
      .SRAM_LB_N (SRAM_LB_N_from_the_sram_16bit_512k_0),
      .SRAM_OE_N (SRAM_OE_N_from_the_sram_16bit_512k_0),
      .SRAM_UB_N (SRAM_UB_N_from_the_sram_16bit_512k_0),
      .SRAM_WE_N (SRAM_WE_N_from_the_sram_16bit_512k_0),
      .iADDR     (sram_16bit_512k_0_avalon_slave_0_address),
      .iBE_N     (sram_16bit_512k_0_avalon_slave_0_byteenable_n),
      .iCE_N     (sram_16bit_512k_0_avalon_slave_0_chipselect_n),
      .iCLK      (clk),
      .iDATA     (sram_16bit_512k_0_avalon_slave_0_writedata),
      .iOE_N     (sram_16bit_512k_0_avalon_slave_0_read_n),
      .iWE_N     (sram_16bit_512k_0_avalon_slave_0_write_n),
      .oDATA     (sram_16bit_512k_0_avalon_slave_0_readdata)
    );

  timer_0_s1_arbitrator the_timer_0_s1
    (
      .clk                                            (clk),
      .cpu_0_data_master_address_to_slave             (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_timer_0_s1           (cpu_0_data_master_granted_timer_0_s1),
      .cpu_0_data_master_qualified_request_timer_0_s1 (cpu_0_data_master_qualified_request_timer_0_s1),
      .cpu_0_data_master_read                         (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_timer_0_s1   (cpu_0_data_master_read_data_valid_timer_0_s1),
      .cpu_0_data_master_requests_timer_0_s1          (cpu_0_data_master_requests_timer_0_s1),
      .cpu_0_data_master_waitrequest                  (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                        (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                    (cpu_0_data_master_writedata),
      .d1_timer_0_s1_end_xfer                         (d1_timer_0_s1_end_xfer),
      .reset_n                                        (clk_reset_n),
      .timer_0_s1_address                             (timer_0_s1_address),
      .timer_0_s1_chipselect                          (timer_0_s1_chipselect),
      .timer_0_s1_irq                                 (timer_0_s1_irq),
      .timer_0_s1_irq_from_sa                         (timer_0_s1_irq_from_sa),
      .timer_0_s1_readdata                            (timer_0_s1_readdata),
      .timer_0_s1_readdata_from_sa                    (timer_0_s1_readdata_from_sa),
      .timer_0_s1_reset_n                             (timer_0_s1_reset_n),
      .timer_0_s1_write_n                             (timer_0_s1_write_n),
      .timer_0_s1_writedata                           (timer_0_s1_writedata)
    );

  timer_0 the_timer_0
    (
      .address    (timer_0_s1_address),
      .chipselect (timer_0_s1_chipselect),
      .clk        (clk),
      .irq        (timer_0_s1_irq),
      .readdata   (timer_0_s1_readdata),
      .reset_n    (timer_0_s1_reset_n),
      .write_n    (timer_0_s1_write_n),
      .writedata  (timer_0_s1_writedata)
    );

  //reset is asserted asynchronously and deasserted synchronously
  bigNios_reset_clk_domain_synch_module bigNios_reset_clk_domain_synch
    (
      .clk      (clk),
      .data_in  (1'b1),
      .data_out (clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0 |
    cpu_0_jtag_debug_module_resetrequest_from_sa |
    cpu_0_jtag_debug_module_resetrequest_from_sa);


endmodule


//synthesis translate_off



// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE

// AND HERE WILL BE PRESERVED </ALTERA_NOTE>


// If user logic components use Altsync_Ram with convert_hex2ver.dll,
// set USE_convert_hex2ver in the user comments section above

`ifdef USE_convert_hex2ver
`else
`define NO_PLI 1
`endif

`include "c:/altera/61/quartus/eda/sim_lib/altera_mf.v"
`include "c:/altera/61/quartus/eda/sim_lib/220model.v"
`include "c:/altera/61/quartus/eda/sim_lib/sgate.v"
`include "Out2.v"
`include "timer_0.v"
`include "In1.v"
`include "In0.v"
`include "cpu_0_test_bench.v"
`include "cpu_0_mult_cell.v"
`include "cpu_0_jtag_debug_module.v"
`include "cpu_0_jtag_debug_module_wrapper.v"
`include "cpu_0.vo"
`include "Out4.v"
`include "Out3.v"
`include "In2.v"
`include "jtag_uart.v"
`include "Out0.v"
`include "SRAM_16Bit_512K.v"
`include "sram_16bit_512k_0.v"
`include "lcd.v"
`include "Out1.v"

`timescale 1ns / 1ps

module test_bench 
;


  wire             LCD_E_from_the_lcd;
  wire             LCD_RS_from_the_lcd;
  wire             LCD_RW_from_the_lcd;
  wire    [  7: 0] LCD_data_to_and_from_the_lcd;
  wire    [ 17: 0] SRAM_ADDR_from_the_sram_16bit_512k_0;
  wire             SRAM_CE_N_from_the_sram_16bit_512k_0;
  wire    [ 15: 0] SRAM_DQ_to_and_from_the_sram_16bit_512k_0;
  wire             SRAM_LB_N_from_the_sram_16bit_512k_0;
  wire             SRAM_OE_N_from_the_sram_16bit_512k_0;
  wire             SRAM_UB_N_from_the_sram_16bit_512k_0;
  wire             SRAM_WE_N_from_the_sram_16bit_512k_0;
  reg              clk;
  wire    [ 15: 0] in_port_to_the_In0;
  wire    [ 15: 0] in_port_to_the_In1;
  wire    [ 15: 0] in_port_to_the_In2;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             lcd_control_slave_irq;
  wire             out_port_from_the_Out0;
  wire    [ 17: 0] out_port_from_the_Out1;
  wire    [  9: 0] out_port_from_the_Out2;
  wire    [  9: 0] out_port_from_the_Out3;
  wire    [  9: 0] out_port_from_the_Out4;
  reg              reset_n;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  bigNios DUT
    (
      .LCD_E_from_the_lcd                        (LCD_E_from_the_lcd),
      .LCD_RS_from_the_lcd                       (LCD_RS_from_the_lcd),
      .LCD_RW_from_the_lcd                       (LCD_RW_from_the_lcd),
      .LCD_data_to_and_from_the_lcd              (LCD_data_to_and_from_the_lcd),
      .SRAM_ADDR_from_the_sram_16bit_512k_0      (SRAM_ADDR_from_the_sram_16bit_512k_0),
      .SRAM_CE_N_from_the_sram_16bit_512k_0      (SRAM_CE_N_from_the_sram_16bit_512k_0),
      .SRAM_DQ_to_and_from_the_sram_16bit_512k_0 (SRAM_DQ_to_and_from_the_sram_16bit_512k_0),
      .SRAM_LB_N_from_the_sram_16bit_512k_0      (SRAM_LB_N_from_the_sram_16bit_512k_0),
      .SRAM_OE_N_from_the_sram_16bit_512k_0      (SRAM_OE_N_from_the_sram_16bit_512k_0),
      .SRAM_UB_N_from_the_sram_16bit_512k_0      (SRAM_UB_N_from_the_sram_16bit_512k_0),
      .SRAM_WE_N_from_the_sram_16bit_512k_0      (SRAM_WE_N_from_the_sram_16bit_512k_0),
      .clk                                       (clk),
      .in_port_to_the_In0                        (in_port_to_the_In0),
      .in_port_to_the_In1                        (in_port_to_the_In1),
      .in_port_to_the_In2                        (in_port_to_the_In2),
      .out_port_from_the_Out0                    (out_port_from_the_Out0),
      .out_port_from_the_Out1                    (out_port_from_the_Out1),
      .out_port_from_the_Out2                    (out_port_from_the_Out2),
      .out_port_from_the_Out3                    (out_port_from_the_Out3),
      .out_port_from_the_Out4                    (out_port_from_the_Out4),
      .reset_n                                   (reset_n)
    );

  initial
    clk = 1'b0;
  always
    #10 clk <= ~clk;
  
  initial 
    begin
      reset_n <= 0;
      #200 reset_n <= 1;
    end

endmodule


//synthesis translate_on