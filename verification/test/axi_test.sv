/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE TEST logic.The test creates the environment and starts the              required sequences.It controls the overall verification flow and simulation execution.
 Date       : 25/03/2025

****************************************************************************************************/



`ifndef _AXI_TEST
`define _AXI_TEST


class axi_test extends uvm_test;
// Handle for sequence and environment
   axi_write_seq axi_write_seq_h;
   axi_read_seq axi_read_seq_h;
   axi_wr_seq axi_wr_seq_h;
   axi_error_seq axi_error_seq_h;
   axi_env axi_env_h;
// Factory Registration   
   `uvm_component_utils(axi_test)

// Construct
   function new(string name="axi_test",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new


// Build Phase
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
// Creating Memory for environment      
      axi_env_h=axi_env::type_id::create("axi_env_h",this);
   endfunction:build_phase
// Run Phase
   task run_phase(uvm_phase phase);
// Prevent simulation from ending      
      phase.raise_objection(this);
// Creating memory for write sequence      
      axi_write_seq_h=axi_write_seq::type_id::create("axi_write_seq_h");
// Creating memory for read sequence      
      axi_read_seq_h=axi_read_seq::type_id::create("axi_read_seq_h");
// Creating memory for wr sequence      
      axi_wr_seq_h=axi_wr_seq::type_id::create("axi_wr_seq_h");
// Creating memory for error sequence      
      axi_error_seq_h=axi_error_seq::type_id::create("axi_error_seq_h");
// Start write sequence      
      axi_write_seq_h.start(axi_env_h.axi_agent_h.axi_seqr_h);
// Start read sequence      
      axi_read_seq_h.start(axi_env_h.axi_agent_h.axi_seqr_h);
// Start wr sequence      
      axi_wr_seq_h.start(axi_env_h.axi_agent_h.axi_seqr_h);
// Start error sequence      
      axi_error_seq_h.start(axi_env_h.axi_agent_h.axi_seqr_h);
// Allow simulation to end      
      phase.drop_objection(this);
   endtask:run_phase
endclass:axi_test

`endif   
