/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE READ SEQUENCE logic.The read sequence generates AXI read
              transactions.It reads data from DUT addresses and checks rsponses.
 Date       : 25/03/2025

****************************************************************************************************/

`ifndef _AXI_READ_SEQ
`define _AXI_READ_SEQ
// AXI read sequence
class axi_read_seq extends uvm_sequence#(axi_transaction);
// Handle for transaction   
    axi_transaction transaction_req_h;
    axi_transaction transaction_res_h;
// Factory Registration    
    `uvm_object_utils_begin(axi_read_seq)
    `uvm_field_object(transaction_req_h,UVM_ALL_ON)
    `uvm_object_utils_end
// Number of transactions to generate
      int number_of_transaction;
// Constructor
   function new(string name="axi_read_seq");
      super.new(name);
   endfunction:new


   task body();
// Creating memory for response transaction object      
      transaction_res_h=axi_transaction::type_id::create("transaction_res_h");
// Read transaction count from command line      
      if($value$plusargs("number_of_transaction=%0d",number_of_transaction))
// Use user-specified transaction         
         number_of_transaction=number_of_transaction;
      else
// Default transaction count         
         number_of_transaction=10;

      repeat(number_of_transaction)begin
// Creating memory for request transaction object         
         transaction_req_h=axi_transaction::type_id::create("transaction_req_h");
         `uvm_info(get_type_name(),"before start item",UVM_LOW);
// Send transaction to driver
         start_item(transaction_req_h);
         `uvm_info(get_type_name(),"after start item",UVM_LOW);
// Check if previous transaction was interrupted by reset         
         if(transaction_res_h.flag==1)begin
// Clear reset flag
            transaction_res_h.flag=0;
// Copy request data into request transaction            
            transaction_req_h.copy(transaction_res_h);
            `uvm_info("debug",$sformatf("response data passing to driver=%0s",transaction_req_h.sprint()),UVM_LOW);
         end
         else begin
            `uvm_info(get_type_name(),"before randomize",UVM_LOW);
// Randomize transaction fields            
            if(!transaction_req_h.randomize()with{awaddr==0;wdata==0;})
               $display("not randomized");
            `uvm_info(get_type_name(),$sformatf("randomizing data=%0s",transaction_req_h.sprint()),UVM_LOW);
            `uvm_info(get_type_name(),"after randomize",UVM_LOW);
         end
         `uvm_info(get_type_name(),"before finish item",UVM_LOW);
// Complete transaction and send to driver         
         finish_item(transaction_req_h);
         `uvm_info(get_type_name(),"after finish item",UVM_LOW);
         `uvm_info("res get","get response",UVM_LOW);
// Receive response transaction         
         get_response(transaction_res_h);
         `uvm_info("res debug",$sformatf("get response data=%0s",transaction_res_h.sprint()),UVM_LOW);
      end

   endtask:body

endclass:axi_read_seq

`endif

