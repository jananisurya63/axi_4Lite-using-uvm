/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE ERROR SEQUENCE logic.The error sequence generates AXI 
              error transactions.It sends randomized write address and read address out of range it will randomize send to the DUT,it through the slverr.
 Date       : 25/03/2025

****************************************************************************************************/


`ifndef _AXI_ERROR_SEQ
`define _AXI_ERROR_SEQ

class axi_error_seq extends uvm_sequence#(axi_transaction);

   axi_transaction transaction_req_h;
   axi_transaction transaction_res_h;
   `uvm_object_utils_begin(axi_error_seq)
   `uvm_field_object(transaction_req_h,UVM_ALL_ON)
   `uvm_object_utils_end

   int number_of_transaction;

   function new(string name="axi_error_seq");
      super.new(name);
   endfunction:new


   task body();
      transaction_res_h=axi_transaction::type_id::create("transaction_res_h");
      if($value$plusargs("number_of_transaction=%0d",number_of_transaction))
         number_of_transaction=number_of_transaction;
      else
         number_of_transaction=10;

      repeat(number_of_transaction)begin
         transaction_req_h=axi_transaction::type_id::create("transaction_req_h");
         `uvm_info(get_type_name(),"before start item",UVM_LOW);
         start_item(transaction_req_h);
         `uvm_info(get_type_name(),"after start item",UVM_LOW);
         if(transaction_res_h.flag==1)begin
            transaction_res_h.flag=0;
            transaction_req_h.copy(transaction_res_h);
            `uvm_info("debug",$sformatf("response data passing to driver=%0s",transaction_req_h.sprint()),UVM_LOW);
         end
         else begin
            `uvm_info(get_type_name(),"before randomize",UVM_LOW);
            transaction_req_h.response.constraint_mode(0);
            transaction_req_h.awaddr_randomize.constraint_mode(0);
            transaction_req_h.araddr_randomize.constraint_mode(0);
            if(!transaction_req_h.randomize()with{araddr==12'hffd;awaddr==12'hfff;})
               `uvm_fatal("not randomize","not randomizing the value")
            `uvm_info(get_type_name(),$sformatf("randomizing data=%0s",transaction_req_h.sprint()),UVM_LOW);
            `uvm_info(get_type_name(),"after randomize",UVM_LOW);
         end
         finish_item(transaction_req_h);
         `uvm_info(get_type_name(),"after finish item",UVM_LOW);
         `uvm_info("res_get","get response",UVM_LOW);
         get_response(transaction_res_h);
         `uvm_info("res_debug",$sformatf("get response data=%0s",transaction_res_h.sprint()),UVM_LOW);
      end
   endtask:body
endclass:axi_error_seq

`endif

