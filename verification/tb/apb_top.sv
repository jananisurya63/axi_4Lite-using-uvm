/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE TOP logic.
              The top module instantiates the DUT,interface and starts the UVM test.It connects all
              components and serves as the simulation entry point.
              

 Date       : 25/03/2025

****************************************************************************************************/


`ifndef _AXI_TOP
`define _AXI_TOP


import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "axi_transaction.sv"
//`include "axi_write_seq.sv"
//`include "axi_read_seq.sv"
//`include "axi_wr_seq.sv"
//`include "axi_seqr.sv"
//`include "axi_driver.sv"
//`include "axi_monitor.sv"
//`include "axi_scoreboard.sv"
//`include "axi_coverage.sv"
//`include "axi_agent.sv"
//`include "axi_env.sv"
//`include "axi_test.sv"
//`include "axi_interface.sv"
//`include "design.sv"

module axi_top;
logic aclk;
logic aresetn;
axi_interface intf(aclk,aresetn);
axi4_lite_slave dut(.aclk(intf.aclk),
                    .aresetn(intf.aresetn),
                    .awaddr(intf.awaddr),
                    .awready(intf.awready),
                    .awvalid(intf.awvalid),
                    .wdata(intf.wdata),
                    .wready(intf.wready),
                    .wvalid(intf.wvalid),
                    .wstrb(intf.wstrb),
                    .bresp(intf.bresp),
                    .bvalid(intf.bvalid),
                    .bready(intf.bready),
                    .araddr(intf.araddr),
                    .arready(intf.arready),
                    .arvalid(intf.arvalid),
                    .rdata(intf.rdata),
                    .rvalid(intf.rvalid),
                    .rready(intf.rready),
                    .rresp(intf.rresp));

bind axi4_lite_slave axi_assertion assert_uut(intf);

always #5 aclk = ~aclk;
initial

   uvm_config_db#(virtual axi_interface)::set(null,"*","vif",intf);

initial begin
   aclk=0;aresetn=0;
   #10;
   aresetn=1;
end

initial begin
   run_test("axi_test");
end

endmodule:axi_top

`endif


