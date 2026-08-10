/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE DRIVER logic.
              The driver receives transactions from the sequencer and drives AXI interface signals to
              the DUT.It converts transaction level data into pin level activity.
 Date       : 25/04/2025

****************************************************************************************************/

`ifndef _AXI_DRIVER
`define _AXI_DRIVER


class axi_driver extends uvm_driver#(axi_transaction);

   axi_transaction transaction_res_h;
   axi_transaction transaction_req_h;
   `uvm_component_utils(axi_driver)
// Handshake between dut and driver through virtual interface   
   virtual axi_interface vif;

//   constructor for the axi driver
   function new(string name="axi_driver",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

//   build_phase for the axi driver   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"this is constructor of axi driver",UVM_LOW);
// Getting the signal using config_db through virtual interface   
      
      if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif))
         `uvm_fatal("vif","virtual interface is not found")
   endfunction:build_phase

   task run_phase(uvm_phase phase);
      forever begin
// Receive transaction from sequencer         
         seq_item_port.get_next_item(transaction_req_h);
// Perform read/write operation         
         main_run(transaction_req_h);
// Inform sequencer transaction is completed         
         seq_item_port.item_done();
//if reset occurs send that transaction to sequence or actual transaction should pass to sequence      
    
         if(transaction_res_h!=null&&transaction_res_h.flag==1)begin
            `uvm_info("res","put response",UVM_LOW);
            seq_item_port.put_response(transaction_res_h);
            transaction_res_h=null;
         end
         else begin 
            `uvm_info("res","put response",UVM_LOW);
            seq_item_port.put_response(transaction_req_h);
         end

      end
   endtask:run_phase
// Main Run
  task main_run(axi_transaction transaction_req_h);
      @(vif.master_cb);
// If reset is active execute reset logic otherwise execute AXI driver logic      
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_logic(transaction_req_h);
      end
      else begin
         driver_logic(transaction_req_h);
      end
   endtask:main_run

   extern task reset_code(axi_transaction transaction_req_h);
// Reset Logic
   task reset_logic(axi_transaction transaction_req_h);
      `uvm_info("reset_occurs","inside reset_logic",UVM_LOW);
      do begin
//When reset is active clear all AXI signals         
      vif.master_cb.awvalid<=0;
      vif.master_cb.awaddr<=0;
      vif.master_cb.araddr<=0;
      vif.master_cb.wdata<=0;
      vif.master_cb.wvalid<=0;
      vif.master_cb.bready<=0;
      vif.master_cb.arvalid<=0;
      vif.master_cb.rready<=0;
      @(vif.master_cb);
   end
      while(!vif.aresetn||$isunknown(vif.aresetn));
      `uvm_info("reset_occurs","outside reset_logic",UVM_LOW);
   endtask:reset_logic
// Driver Logic
   task driver_logic(axi_transaction transaction_req_h);
// Execute AXI write and read transaction      
             write_address(transaction_req_h);
             write_data(transaction_req_h);
             write_response(transaction_req_h);
             read_address(transaction_req_h);
             read_data(transaction_req_h);
    
   endtask:driver_logic
// Write Address
   task write_address(axi_transaction transaction_req_h);
      @(posedge vif.aclk);
// Check reset      
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         return;
      end
      else begin
         `uvm_info("write_addr","awvalid is asserted",UVM_LOW);
// Driver write address         
         vif.master_cb.awvalid<=1'b1;
         vif.master_cb.awaddr<=transaction_req_h.awaddr;
      end
// Wait until slave asserts awready      
      do begin
         if(!vif.master_cb.awready);
         @(posedge vif.aclk);
      end
      while(vif.master_cb.awready);
      @(posedge vif.aclk);
// Check Reset      
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         return;
      end
      else begin
// Address handshake completed 
// Deassert Awvalid
         vif.master_cb.awvalid<=1'b0;
      end
   endtask:write_address


// Write data   
   task write_data(axi_transaction transaction_req_h);
// Check Reset      
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         return;
      end
      else begin
// Drive Write Data         
         vif.master_cb.wvalid<=1'b1;
         vif.master_cb.wdata<=transaction_req_h.wdata;
         vif.master_cb.wstrb<=transaction_req_h.wstrb;
      end
// Wit until slave asserts wready      
      do begin
         if(!vif.master_cb.wready);
         @(posedge vif.aclk);
      end
      while(vif.master_cb.wready);
      @(posedge vif.aclk);
// Check Reset      
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         return;
      end
      else begin
// Handshake completed
// Deasserts wvalid
         vif.master_cb.wvalid<=1'b0;
      end
   endtask:write_data

// Write Response Channel   
   task write_response(axi_transaction transaction_req_h);
// Wait until slave asserts bvalid      
      do begin
         if(!vif.master_cb.bvalid);
         @(posedge vif.aclk);
      end
      while(vif.master_cb.bvalid);

      @(posedge vif.aclk);
// Check Reset      
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         return;
      end
      else begin
// Assert bready to accept write response         
         vif.master_cb.bready<=1'b1;
// Capture bresp from slave         
         transaction_req_h.bresp<=vif.master_cb.bresp;
      end

      @(posedge vif.aclk);
// Check reset      
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         return;
      end
      else begin
// Response transafer completed
// Deassert bready
         vif.master_cb.bready<=1'b0;
         `uvm_info(get_type_name(),$sformatf("write is completed data =%0s",transaction_req_h.sprint()),UVM_LOW);
      end
   endtask:write_response


// Read address Channel   
   task read_address(axi_transaction transaction_req_h);
      @(posedge vif.aclk);
// Check Reset      
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         return;
      end
      else begin
// Drive read address from transaction         
         vif.master_cb.araddr<=transaction_req_h.araddr;
// Assert arvalid         
         vif.master_cb.arvalid<=1'b1;
      end
// Wait until slave accepts read address      
      do begin
         if(!vif.master_cb.arready);
         @(posedge vif.aclk);
      end
      while(vif.master_cb.arready);

      @(posedge vif.aclk);
// Check reset
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         return;
      end
      else begin
// Read address transafer completed
// Deasserts arvalid
         vif.master_cb.arvalid<=1'b0;
      end
   endtask:read_address

// Read Data Channel   
   task read_data(axi_transaction transaction_req_h);
// Wait until slave asserts rvalid      
      do begin
         if(!vif.master_cb.rvalid);
         @(posedge vif.aclk);
      end
      while(vif.master_cb.rvalid);
// Check Reset
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         return;
      end
      else begin
// Assert ready to accept read data         
         vif.master_cb.rready<=1'b1;
// Capture read data from slave         
         transaction_req_h.rdata<=vif.master_cb.rdata;
// Capture read response         
         transaction_req_h.rresp<=vif.master_cb.rresp;
      end
      @(posedge vif.aclk);
// Check Reset      
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         return;
      end
      else begin

// Read transaction completed
// Deassert rready
         vif.master_cb.rready<=1'b0;
         `uvm_info(get_type_name(),$sformatf("read is completed data =%0s",transaction_req_h.sprint()),UVM_LOW);
      end
   endtask:read_data
endclass:axi_driver

task axi_driver::reset_code(axi_transaction transaction_req_h);
// Create an exact copy of request transaction   
   $cast(transaction_res_h,transaction_req_h.clone());
// Copy transaction information to response   
   transaction_res_h.set_id_info(transaction_req_h);
   transaction_res_h.flag=1;
   `uvm_info("rd",$sformatf("reset data =%0s",transaction_res_h.sprint()) ,UVM_LOW);
// Drive all interface signals to reset state   
   reset_logic(transaction_req_h);
endtask:reset_code


  `endif

