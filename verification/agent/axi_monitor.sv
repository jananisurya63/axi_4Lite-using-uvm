/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE MONITOR logic.
              The monitor observes DUT interface signals without driving them.It collects transaction
              information and sends it to the scoreboard and coverage.
 Date       : 25/04/2025

****************************************************************************************************/


`ifndef _AXI_MONITOR
`define _AXI_MONITOR


class axi_monitor extends uvm_monitor;
// Handle for transaction
   axi_transaction transaction_h;
// Factory Registration   
   `uvm_component_utils(axi_monitor)
// Handshake between dut and monitor through virtual interface   
   virtual axi_interface vif;
// Analysis Port   
   uvm_analysis_port#(axi_transaction)ap_mon;

// Construct
   function new(string name="axi_monitor",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

// Build Phase
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
// Memory for the Analysis Port      
      ap_mon=new("ap_mon",this);
// Get the signal using config_db through virtual interface      
      if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif))
         `uvm_fatal("vif","virtual interface is not found")
   
   endfunction:build_phase

// Run Phase
  task run_phase(uvm_phase phase);
     forever begin
        @(posedge vif.aclk);
// Creating memory for transaction object        
           transaction_h=axi_transaction::type_id::create("transaction_h");
// Capture write address when handshake occurs           
        if(vif.monitor_cb.awvalid&&vif.monitor_cb.awready)begin
           transaction_h.awaddr=vif.monitor_cb.awaddr;
           transaction_h.awvalid=vif.monitor_cb.awvalid;
           transaction_h.awready=vif.monitor_cb.awready;
        end
// Capture write data when handshake occurs
        if(vif.monitor_cb.wvalid&&vif.monitor_cb.wready)begin
           transaction_h.wdata=vif.monitor_cb.wdata;
           transaction_h.wvalid=vif.monitor_cb.wvalid;
           transaction_h.wready=vif.monitor_cb.wready;
           transaction_h.wstrb=vif.monitor_cb.wstrb;
        end
// Capture write response when handshake occurs
        if(vif.monitor_cb.bready&&vif.monitor_cb.bvalid)begin
           transaction_h.bvalid=vif.monitor_cb.bvalid;
           transaction_h.bready=vif.monitor_cb.bready;
           transaction_h.bresp=vif.monitor_cb.bresp;
// Send transaction through analysis port           
           ap_mon.write(transaction_h);
           `uvm_info(get_type_name(),$sformatf("monitoring write data=%0s",transaction_h.sprint()),UVM_LOW);
        end
// Capture read address when arvalid and arready handshake occurs
        if(vif.monitor_cb.arvalid&&vif.monitor_cb.arready)begin
// Store read address           
           transaction_h.arvalid=vif.monitor_cb.arvalid;
           transaction_h.arready=vif.monitor_cb.arready;
           transaction_h.araddr=vif.monitor_cb.araddr;
        end
// Capture read data when rvalid and rready handshake occurs        
        if(vif.monitor_cb.rvalid&&vif.monitor_cb.rready)begin
// Store read data           
           transaction_h.rvalid=vif.monitor_cb.rvalid;
           transaction_h.rready=vif.monitor_cb.rready;
           transaction_h.rdata=vif.monitor_cb.rdata;
// Store read response           
           transaction_h.rresp=vif.monitor_cb.rresp;
           ap_mon.write(transaction_h);
           `uvm_info(get_type_name(),$sformatf("monitoring read data=%0s",transaction_h.sprint()),UVM_LOW);
        end


        end
     
  endtask:run_phase

  endclass:axi_monitor

  `endif
