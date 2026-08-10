/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE AGENT logic.
              AXI agent groups the driver,sequencer and monitor into a single reusable component.It 
              connects the driver and sequencer and  manages AXI protocol activities.

 Date       : 25/04/2025

****************************************************************************************************/
`ifndef _AXI_AGENT
`define _AXI_AGENT

class axi_agent extends uvm_agent;
// Handle for driver,sequencer,monitor   
   axi_driver axi_driver_h;
   axi_seqr axi_seqr_h;
   axi_monitor axi_monitor_h;
// Factory Registration   
   `uvm_component_utils(axi_agent)
// Construct
   function new(string name="axi_agent",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

//Build Phase
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"this is constructor of axi agent",UVM_LOW);
// Creating Memory for driver,sequencer,monitor      
      axi_driver_h=axi_driver::type_id::create("axi_driver_h",this);
      axi_seqr_h=axi_seqr::type_id::create("axi_seqr_h",this);
      axi_monitor_h=axi_monitor::type_id::create("axi_monitor_h",this);
   endfunction:build_phase

// Connect Phase
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
// Connect driver to sequencer      
      axi_driver_h.seq_item_port.connect(axi_seqr_h.seq_item_export);
   endfunction:connect_phase

endclass:axi_agent

`endif
