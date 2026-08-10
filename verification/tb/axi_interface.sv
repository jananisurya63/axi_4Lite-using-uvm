/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE INTERFACE logic.
              An interface groups related AXI signals into a single reusable block.It simplifies 
              connection between DUT,driver and monitor.
 Date       : 25/03/2025

****************************************************************************************************/


`ifndef _AXI_INTERFACE
`define _AXI_INTERFACE


interface axi_interface(input logic aclk,input logic aresetn);

// Write Address Channel
   logic awvalid;
   logic awready;
   logic [11:0]awaddr;

// Write Data Channel   
   logic wvalid;
   logic wready;
   logic [31:0]wdata;
   logic [3:0]wstrb;

// Write Response Channel
   logic bvalid;
   logic bready;
   logic [1:0]bresp;

// Read Address Channel
   logic arvalid;
   logic arready;
   logic [11:0]araddr;

// Read Data Channel
   logic rvalid;
   logic rready;
   logic [31:0]rdata;
   logic [1:0]rresp;

   clocking master_cb@(posedge aclk);
      input awready,wready,bresp,bvalid,rresp,rvalid,rdata,arready;
      output awaddr,awvalid,wdata,wstrb,bready,rready,araddr,arvalid,wvalid;
   endclocking:master_cb

   clocking monitor_cb@(posedge aclk);
      input awready,wready,bresp,bvalid,rresp,rvalid,rdata,arready;
      input awaddr,awvalid,wdata,wstrb,bready,rready,araddr,arvalid,wvalid;
   endclocking:monitor_cb

   modport slave_mp(
      input awaddr,awvalid,wdata,wstrb,wvalid,bready,araddr,arvalid,rready,
      output awready,wready,bresp,bvalid,arready,rdata,rresp,rvalid);


endinterface:axi_interface

`endif
