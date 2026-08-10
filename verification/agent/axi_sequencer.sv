/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE SQUENCER logic.
              The sequencer controls the flow of transaction between the sequence and driver.It
              receives transactions from sequences and sends them to the driver in an orderly manner.
 Date       : 25/04/2025

****************************************************************************************************/



`ifndef _AXI_SEQR
`define _AXI_SEQR

class axi_seqr extends uvm_sequencer#(axi_transaction);
//Factory Registration   
   `uvm_component_utils(axi_seqr)

//Constructor
    function new(string name="axi_seqr",uvm_component parent=null);
       super.new(name,parent);
    endfunction:new

 endclass:axi_seqr

 `endif
