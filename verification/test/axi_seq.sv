/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE SEQUENCE logic.A sequence generates stimulus trasaction 
              for verification.It controls the order and type of transactions send to the driver.
 Date       : 25/03/2025

****************************************************************************************************/


`ifndef _AXI_SEQ
`define _AXI_SEQ


class axi_seq extends uvm_sequence#(axi_transaction);

//Handle for transaction
   axi_transaction transaction_h;
//Factory Registration   
   `uvm_object_utils_begin(axi_seq)
   `uvm_field_object(transaction_h,UVM_ALL_ON)
   `uvm_object_utils_end
// Number of transaction to generate
   int number_of_transaction;
//Construct
   function new(string name="axi4lite_seq");
      super.new(name);
   endfunction:new

//Task Body Method

task body();
// Read transaction count from command line      
   if($value$plusargs("number_of_transaction=%0d",number_of_transaction))
// Use user-specified transaction        
      number_of_transaction=number_of_transaction;
   else
// Default transaction count      
      number_of_transaction=10;

   repeat(number_of_transaction)begin
// Creating memory for transaction object           
      transaction_h=axi_transaction::type_id::create("transaction_h");
// Start Method      
      start_item(transaction_h);
// Randomize transaction      
      transaction_h.randomize();
// Finish Method      
      finish_item(transaction_h);
   end

endtask

endclass

`endif





