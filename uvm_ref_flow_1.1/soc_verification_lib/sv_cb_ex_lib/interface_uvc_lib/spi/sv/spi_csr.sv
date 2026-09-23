/*-------------------------------------------------------------------------
File name   : spi_csr.sv
Title       : SPI SystemVerilog UVM UVC
Project     : SystemVerilog UVM Cluster Level Verification
Created     :
Description : 
Notes       :  
---------------------------------------------------------------------------*/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV
`define SPI_CSR_SV

typedef enum bit[3:0] {SLAVE = 4'b0, MASTER = 4'b1} e_spi_csr_mode;

typedef struct packed {
  e_spi_csr_mode mode_select;
  bit [7:0] slave_sel;
  bit [7:0] word;
  bit [7:0] senable_word;
} d_btwn_s;

typedef struct packed {
  bit[3:0] spi_enable;
  d_btwn_s btwn;  
} spi_csr_ctrl_s;

typedef struct packed {
  bit[3:0] fifo_full;
  bit[3:0] fifo_not_empty;
  bit[1:0] mode_fault;
  bit[3:0] fifo_underflow;
  bit[3:0] fifo_overrun;
} fifo_s;

typedef union packed {
  fifo_s tx;
  fifo_s rx;
} spi_csr_phase_state_u;

typedef struct packed {
  bit [7:0] n_ss_out;
  bit [6:0] transfer_data_size;
  bit [15:0] baud_rate_divisor;
  bit tx_clk_phase;
  bit rx_clk_phase;
  
  spi_csr_ctrl_s ctrl_btwn;
  spi_csr_phase_state_u fifo_phase_state;
  int data_size;
} spi_csr_s;

class spi_csr extends uvm_object;

  spi_csr_s csr_s;

  //randomize SPI CSR fields
  rand bit [7:0] n_ss_out;
  rand bit [6:0] transfer_data_size;
  rand bit [15:0] baud_rate_divisor;
  rand bit tx_clk_phase;
  rand bit rx_clk_phase;
  rand e_spi_csr_mode mode_select;

  rand bit [7:0] d_btwn_slave_sel;
  rand bit [7:0] d_btwn_word;
  rand bit [7:0] d_btwn_senable_word;

  rand bit[3:0] spi_enable;

  int data_size;

  // this is a default constraint that could be overriden
  // Constrain randomisation of configuration based on UVC/RTL capabilities
  constraint c_default_config {
    n_ss_out           == 8'b01;
    transfer_data_size == 7'b0001000;
    baud_rate_divisor  == 16'b0001;
    tx_clk_phase       == 1'b0;
    rx_clk_phase       == 1'b0;
    mode_select        == 1'b1;

    d_btwn_slave_sel   == 8'h00;
    d_btwn_word        == 8'h00;
    d_btwn_senable_word== 8'h00;

    spi_enable         == 1'b1;
  }

  // These declarations implement the create() and get_type_name() as well as enable automation of the
  // transfer fields   
  `uvm_object_utils_begin(spi_csr)
    `uvm_field_int(n_ss_out,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase,        UVM_ALL_ON)
    `uvm_field_enum(e_spi_csr_mode, mode_select, UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This requires for registration of the ptp_tx_frame   
  function new(string name = "spi_csr");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int();
    Copycfg_struct();
  endfunction 

  // function to convert the 2 bit transfer_data_size to integer
  function void get_data_size_as_int();
    case(transfer_data_size)
      16'b00 : data_size = 128;
      default : data_size = int'(transfer_data_size);
    endcase
     `uvm_info("SPI CSR", $psprintf("data size is %d", data_size), UVM_MEDIUM)
  endfunction : get_data_size_as_int
    
  function void Copycfg_struct();
    csr_s.n_ss_out            = n_ss_out;
    csr_s.transfer_data_size  = transfer_data_size;
    csr_s.baud_rate_divisor   = baud_rate_divisor;
    csr_s.tx_clk_phase        = tx_clk_phase;
    csr_s.rx_clk_phase        = rx_clk_phase;
    csr_s.ctrl_btwn.btwn.mode_select         = mode_select;

    csr_s.ctrl_btwn.btwn.slave_sel     = d_btwn_slave_sel;
    csr_s.ctrl_btwn.btwn.word          = d_btwn_word;
    csr_s.ctrl_btwn.btwn.senable_word  = d_btwn_senable_word;

    csr_s.ctrl_btwn.spi_enable      = spi_enable;

    csr_s.data_size      = data_size;
  endfunction

endclass : spi_csr

`endif

