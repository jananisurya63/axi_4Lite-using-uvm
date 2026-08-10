/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE TRANSACTION logic.
              A transaction is a data packet that contains AXI information such as address,data and
              response signals.It is the basic communication object exchanged between sequence,
              driver,monitor and scoreboard.
 Date       : 25/04/2025

****************************************************************************************************/




`ifndef _AXI_TRANSACTION
`define _AXI_TRANSACTION

class axi_transaction extends uvm_sequence_item;

        bit        awvalid;
        bit        awready;
   rand bit [11:0] awaddr;
        bit        wvalid;
        bit        wready;
   rand bit [31:0] wdata;
   rand bit [3:0]  wstrb;
        bit        bready;
        bit        bvalid; 
        bit [1:0]  bresp;
        bit        arready;
        bit        arvalid;
   rand bit [11:0] araddr;
        bit        rvalid;
        bit        rready;
        bit [31:0] rdata;
        bit [1:0]  rresp;

        bit flag;

// Factory Registration
    `uvm_object_utils_begin(axi_transaction)
    `uvm_field_int(awaddr,UVM_ALL_ON)
    `uvm_field_int(wdata,UVM_ALL_ON)
    `uvm_field_int(wstrb,UVM_ALL_ON)
    `uvm_field_int(bresp,UVM_ALL_ON)
    `uvm_field_int(araddr,UVM_ALL_ON)
    `uvm_field_int(rdata,UVM_ALL_ON)
    `uvm_field_int(rresp,UVM_ALL_ON)
    `uvm_object_utils_end

    constraint awaddr_randomize{awaddr inside{[12'h0:12'h50]};}
    constraint araddr_randomize{araddr inside{[12'h0:12'h50]};}

    constraint response{awaddr %4==0;
                        araddr %4==0;}

    constraint strb{wstrb==4'hf;}
// Construct    
    function new(string name="axi_transaction");
       super.new(name);
    endfunction

 endclass:axi_transaction

 `endif
        

