/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE SCOREBOARD  logic.
              The scoreboard checks DUT behavior by comparing actual outputs with expected results.
              It reports data matches and mismatches.
 Date       : 25/03/2025

****************************************************************************************************/


`ifndef _AXI_SCOREBOARD
`define _AXI_SCOREBOARD


class axi_scoreboard extends uvm_scoreboard;
// Handle for transaction
   axi_transaction transaction_h;
// Factory Registration   
   `uvm_component_utils(axi_scoreboard)
   bit[31:0]mem[bit[11:0]];
// Analysis port to connect transaction,scoreboard   
   uvm_analysis_imp#(axi_transaction,axi_scoreboard)ap_sb;

// Construct
   function new(string name="axi_scoreboard",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

// Build Phase
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
// Memory for the Analysis port      
      ap_sb=new("ap_sb",this);
   endfunction:build_phase

// Write Method receives transaction from monitor
   function void write(axi_transaction transaction_h);
      `uvm_info(get_type_name(),"inside scoreboard receiving the packet",UVM_LOW);
      if(transaction_h.bresp==2'b10||transaction_h.rresp==2'b10)begin
         `uvm_info(get_type_name(),$sformatf("slverr is generating because address is out of range bresp=%0b rresp=%0b",transaction_h.bresp,transaction_h.rresp),UVM_LOW);

      end
// Check write response is OKAY      
      if(transaction_h.bresp==2'b00)begin
// store write data into memory         
         mem[transaction_h.awaddr]=transaction_h.wdata;
         `uvm_info(get_type_name(),$sformatf("write pass to memory awaddr=%0h wdata=%0h",transaction_h.awaddr,transaction_h.wdata),UVM_LOW);
      end
// Check read response is OKAY
      if(transaction_h.rresp==2'b00)begin

         `uvm_info(get_type_name(),$sformatf("read pass araddr=%0h randomize data=%0h  actual data=%0h",transaction_h.araddr,mem[transaction_h.araddr],transaction_h.rdata),UVM_LOW);
// Check if read address exists in memory         
         if(mem.exists(transaction_h.araddr))begin
            if(mem[transaction_h.araddr]==transaction_h.rdata)begin
               `uvm_info(get_type_name(),$sformatf("rad pass araddr=%0h randomize data=%0h actual data=%0h",transaction_h.araddr,mem[transaction_h.araddr],transaction_h.rdata),UVM_LOW);
            end
            else begin
               `uvm_info(get_type_name(),$sformatf("Read pass araddr=%0h randomize data=%0h acutal_data=%0h",transaction_h.araddr,mem[transaction_h.araddr],transaction_h.rdata),UVM_LOW);
            end
         end
         else begin
            `uvm_info(get_type_name(),$sformatf("read from uninitialized araddr=%0h this address is not found in the memory",transaction_h.araddr),UVM_LOW);
         end
      end
   endfunction:write
endclass:axi_scoreboard

`endif

