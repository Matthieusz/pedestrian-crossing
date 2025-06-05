
module top
(  
  input  wire       CLK_PCB,
  input  wire       nRST_PCB, 
  
  input  wire       ROAD_DET,
  output wire       ROAD_RED,
  output wire       ROAD_YELLOW,
  output wire       ROAD_GREEN,
  
  input  wire       PED_BUTT,
  output wire       PED_RED,
  output wire       PED_GREEN,

  output wire [3:0] LED
);    
//-------------------------------------------------------------------------------
  parameter SIM = "FALSE";
//-------------------------------------------------------------------------------
  wire CLK = CLK_PCB;
  wire RST_PCB = ~nRST_PCB;
  wire RST_async, RST_sync, RST;         
//-------------------------------------------------------------------------------  
  assign RST_async = RST_PCB ;
  rst_synch_bridge my_rst_synch_bridge(.I_RST(RST_async), .CLK(CLK), .O_RST(RST_sync));
  assign RST = RST_sync;
//-------------------------------------------------------------------------------
//if(SIM == "TRUE")
//-------------------------------------------------------------------------------
  reg [31:0] heartbeat_clk;
//-------------------------------------------------------------------------------
  always@(posedge CLK        or posedge RST)
  if(RST   ) heartbeat_clk           <= 0;
  else       heartbeat_clk           <= heartbeat_clk        + 1;
//------------------------------------------------------------------------------------------------------
assign LED = ~{ROAD_DET, PED_BUTT, RST, heartbeat_clk[27]};
//------------------------------------------------------------------------------------------------------
assign {ROAD_RED, ROAD_YELLOW, ROAD_GREEN, PED_RED, PED_GREEN}= heartbeat_clk[26:22];
//------------------------------------------------------------------------------------------------------

endmodule
