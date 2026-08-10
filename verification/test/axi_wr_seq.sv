/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE WRITE-READ SEQUENCE logic.The write read sequence performs              a write operation followed bby a read operation.It verifies that the data read matches
              the data previously written.
 Date       : 25/03/2025

****************************************************************************************************/

`ifndef _AXI_WR_SEQ
`define _AXI_WR_SEQ

class axi_wr_seq extends uvm_sequence#(axi_transaction);
// Handle for transaction
   axi_transaction transaction_h;
   axi_transaction read_transaction_h;
// Factory Registration   
   `uvm_object_utils_begin(axi_wr_seq)
   `uvm_field_object(transaction_h,UVM_ALL_ON)
   `uvm_object_utils_end
// Number of transaction to generate
   int number_of_transaction;
// Construct
   function new(string name="axi_wr_seq");
      super.new(name);
   endfunction:new

   task body();
// Read transaction count from command line         
      if($value$plusargs("number_of_transaction=%0d",number_of_transaction))
// Use user specified transaction         
         number_of_transaction=number_of_transaction;
      else
// Default transaction count         
         number_of_transaction=10;

      repeat(number_of_transaction)begin
// Creating memory for transaction object         
         transaction_h=axi_transaction::type_id::create("transaction_h");
         
         `uvm_info(get_type_name(),"before start item",UVM_LOW);
// Request sequencer for transaction         
         start_item(transaction_h);
         `uvm_info(get_type_name(),"after start item",UVM_LOW);
         `uvm_info(get_type_name(),"before randomize",UVM_LOW);
// Randomize transaction with constrained address         
         if(!transaction_h.randomize()with{araddr==0;})
            $display("not randomization");
         `uvm_info(get_type_name(),$sformatf("randomizing data=%0s",transaction_h.sprint()),UVM_LOW);
         `uvm_info(get_type_name(),"after randomize",UVM_LOW);
         `uvm_info(get_type_name(),"before finish item",UVM_LOW);
// Send transaction to driver         
         finish_item(transaction_h);
         `uvm_info(get_type_name(),"after finish item",UVM_LOW);
// Receive response from driver         
         get_response(transaction_h);
         `uvm_info("res debug",$sformatf("get response data=%0s",transaction_h.sprint()),UVM_LOW);
// Creating memory for read transaction object
         read_transaction_h=axi_transaction::type_id::create("read_transaction_h");
         `uvm_info(get_type_name(),"before start item",UVM_LOW);
// Request sequencer for read transaction       
         start_item(read_transaction_h);
         `uvm_info(get_type_name(),"after start item",UVM_LOW);
         `uvm_info(get_type_name(),"before randomize",UVM_LOW);
// Randomize read transaction using address         
         if(!read_transaction_h.randomize()with{araddr==transaction_h.awaddr;
                                                awaddr==0;
                                                wdata==0;})
            $display("not randomized");
            `uvm_info(get_type_name(),$sformatf("randomizing data=%0s",transaction_h.sprint()),UVM_LOW);
            `uvm_info(get_type_name(),"after randomize",UVM_LOW);
            `uvm_info(get_type_name(),"before finish item",UVM_LOW);
// Send transaction to driver            
            finish_item(read_transaction_h);
            `uvm_info(get_type_name(),"after finish item",UVM_LOW);
            `uvm_info("res get","get response",UVM_LOW);

// Receive response transaction             
            get_response(transaction_h);
            `uvm_info("res debug",$sformatf("get response data=%0s",transaction_h.sprint()),UVM_LOW);

         end

      endtask:body

   endclass:axi_wr_seq

`endif
            
            

                                                



   
