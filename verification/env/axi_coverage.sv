/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE COVERAGE logic.
              Coverage measures how much of the design functionality has been exercised.It collects
              statistics on signal values and protocol scenarios during simulation.
 Date       : 25/03/2025

****************************************************************************************************/


`ifndef _AXI_COVERAGE
`define _AXI_COVERAGE


class axi_coverage extends uvm_subscriber#(axi_transaction);
// Handle for transaction
   axi_transaction transaction_h;
// Factory Registration   
   `uvm_component_utils(axi_coverage)
// Analysis Implementation Port   
   uvm_analysis_imp#(axi_transaction,axi_coverage)ap_cov;

// Coverage group for write address channel  
   covergroup write_addr_cg;
// Coverage for awready signals      
      AWREADY:coverpoint transaction_h.awready
      { 
         bins awready_low={0};
         bins awready_high={1};
      }
// Coverage for awvalid signals
      AWVALID:coverpoint transaction_h.awvalid
      { 
         bins awvalid_low={0};
         bins awvalid_high={1};
      }
// Coverage for write address values
      AWADDR:coverpoint transaction_h.awaddr
      {
         bins low_awaddr={[0:255]};
         bins mid_awaddr={[256:1023]};
         bins high_awaddr={[1024:4095]};
      }                       
    endgroup:write_addr_cg
// Coverage group for write data channel
    covergroup write_data_cg;
// Coverage for wready signal       
       WREADY:coverpoint transaction_h.wready
       { 
          bins wready_low={0};
          bins wready_high={1};
       }
// Coverage for wvalid signal
       WVALID:coverpoint transaction_h.wvalid
       { 
          bins wvalid_low={0};
          bins wvalid_high={1};
       }
// Coverage for write data values 
       WDATA:coverpoint transaction_h.wdata
      {
         bins zero_data={32'b0};
         bins all_1_data={32'hffff_ffff};
         bins others=default;
      }
// Coverage for write strobe values
       WSTRB:coverpoint transaction_h.wstrb
      {
         bins byte0={4'b0001};
         bins byte1={4'b0010};
         bins byte2={4'b0100};
         bins byte3={4'b1000};

         bins byte_full={4'b1111};
      }
   endgroup:write_data_cg

// Coverage group for write response channel
covergroup write_response_cg;
// Coverage for bready signal
      BREADY:coverpoint transaction_h.bready
      { 
         bins bready_low={0};              
         bins bready_high={1};
      }

// Coverage for bvalid signal
      BVALID:coverpoint transaction_h.bvalid
      { 
         bins bvalid_low={0};
         bins bvalid_high={1};
      }
                                  
// Coverage for write response
      BRESP:coverpoint transaction_h.bresp
      { // successful write response
         bins bresp_okay={2'b00};
        // Exclusive access response
         bins bresp_exokay={2'b01};
        // Slave error response
         bins bresp_slverr={2'b10};
        // Decode error response
         bins bresp_decerr={2'b11};
      }

    endgroup:write_response_cg

// Coverage group for read address channel
    covergroup read_addr_cg;
// Coverage for arready signal
      ARREADY:coverpoint transaction_h.arready
      { 
         bins arready_low={0};
         bins arready_high={1};
      }
// Coverage for arvalid signal
      ARVALID:coverpoint transaction_h.arvalid
      { 
         bins arvalid_low={0};
         bins arvalid_high={1};
      }

// Coverage for read address values
      ARADDR:coverpoint transaction_h.araddr
      {
         bins low_awaddr={[0:255]};
         bins mid_awaddr={[256:1023]};
         bins high_awaddr={[1024:4095]};
      }
    endgroup:read_addr_cg

// Coverage group for read data channel
    covergroup read_data_cg;
// Coverage for rready signal
      RREADY:coverpoint transaction_h.rready
      { 
         bins rready_low={0};
         bins rready_high={1};
      }
// Coverage for rvalid signal
      RVALID:coverpoint transaction_h.rvalid
      { 
         bins rvalid_low={0};
         bins rvalid_high={1};
      }

// Coverage for read data values
      RDATA:coverpoint transaction_h.rdata
      {
         bins zero_data={32'b0};
         bins all_1_data={32'hffff_ffff};
         bins others=default;
      }
// Coverage for read response
      RRESP:coverpoint transaction_h.rresp
      {// suscessful read response
        bins rresp_okay={2'b00};
       // Exclusive access response
        bins rresp_exokay={2'b01};
       // Slave error response
        bins rres_slverr={2'b10};
       // Decode error response
        bins rresp_decerr={2'b11};
      } 

    endgroup:read_data_cg

// Construct
    function new(string name="axi_coverage",uvm_component parent=null);
       super.new(name,parent);
// Creating memory for write address,write data,write response,read address and read data coverage group 
       write_addr_cg=new();
       write_data_cg=new();
       write_response_cg=new();
       read_addr_cg=new();
       read_data_cg=new();

    endfunction:new
// Build Phase
    function void build_phase(uvm_phase phase);
       super.build_phase(phase);
// Create analysis implementation port       
       ap_cov=new("ap_cov",this);
    endfunction:build_phase

// Receive transaction and sample coverage
    function void write(axi_transaction t);
       transaction_h=t;
// Sample write address coverage       
       write_addr_cg.sample();
// Sample write data coverage       
       write_data_cg.sample();
// Sample write response coverage
       write_response_cg.sample();
// Sample read address coverage       
       read_addr_cg.sample();
// Sample read data coverage       
       read_data_cg.sample();
    endfunction:write

 endclass:axi_coverage

 `endif
       









                                



