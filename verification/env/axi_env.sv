/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : AXI4LITE Protocol
 Description: This file implement AXI4LITE ENVIRONMENT logic.
              The environment is the top-level verification component containing agent,scoreboard
              and coverage.It connects all verification components together.
 Date       : 25/03/2025

****************************************************************************************************/


`ifndef _AXI_ENV
`define _AXI_ENV


class axi_env extends uvm_env;
// Handle for agent,scoreboard and coverage
   axi_agent axi_agent_h;
   axi_scoreboard axi_scoreboard_h;
   axi_coverage axi_coverage_h;
// Factory Registration   
   `uvm_component_utils(axi_env)

// Construct
   function new(string name="axi_env",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new
// Build Phase
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
// Creating Memory for agent,scoreboard and coverage      
      axi_agent_h=axi_agent::type_id::create("axi_agent_h",this);
      axi_scoreboard_h=axi_scoreboard::type_id::create("axi_scoreboard_h",this);
      axi_coverage_h=axi_coverage::type_id::create("axi_coverage_h",this);
   endfunction:build_phase

// Connect Phase   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
// Connect Monitor analysis port to Scoreboard      
      axi_agent_h.axi_monitor_h.ap_mon.connect(axi_scoreboard_h.ap_sb);
      axi_agent_h.axi_monitor_h.ap_mon.connect(axi_coverage_h.ap_cov);
   endfunction:connect_phase

endclass:axi_env

`endif
