/*-------------------------------------------------------------------------
File name   : gpio_reg_seq_lib.sv
Title       : REGMEM Sequence Library
Project     :
Created     :
Description : This file implements regmem sequences
Notes       :
----------------------------------------------------------------------*/
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
 
class gpio_cfg_reg_seq extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq)

   function new(string name="gpio_cfg_reg_seq");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst;
   string gpio_rf;

   gpio_regfile reg_model;

    virtual task body();
      uvm_status_e status;
      uvm_reg_data_t read_data;
      bit [31:0] write_val;
       $sformat(gpio_rf, "gpio%0d_rf", gpio_inst);
       `uvm_info("ex_reg_rw_reg_seq", 
         "complete random gpio configuration register sequence starting...", UVM_MEDIUM)
       #200;
       write_val = 32'hAA5500FF;
       reg_model.bypass_mode.write(status, write_val);
       reg_model.direction_mode.write(status, write_val);
       reg_model.output_enable.write(status, write_val);
       #200;
       reg_model.direction_mode.read(status, read_data, .path(UVM_FRONTDOOR));
       if (read_data != write_val) begin
         `uvm_error("GPIO_CHECK", $sformatf("direction_mode mismatch: wrote 0x%0h, read back 0x%0h", write_val, read_data))
       end
       reg_model.output_enable.read(status, read_data, .path(UVM_FRONTDOOR));
       if (read_data != write_val) begin
         `uvm_error("GPIO_CHECK", $sformatf("output_enable mismatch: wrote 0x%0h, read back 0x%0h", write_val, read_data))
       end
    endtask

endclass : gpio_cfg_reg_seq