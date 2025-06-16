module top (
  input  wire       CLK_PCB,
  input  wire       nRST_PCB,

  input  wire       ROAD_DET,        // Ignorowane
  output wire       ROAD_RED,
  output wire       ROAD_YELLOW,
  output wire       ROAD_GREEN,

  input  wire       PED_BUTT,        // Ignorowane
  output wire       PED_RED,
  output wire       PED_GREEN,

  output wire [3:0] LED
);

  wire CLK = CLK_PCB;
  wire RST_PCB = ~nRST_PCB;
  wire RST_async, RST_sync, RST;

  assign RST_async = RST_PCB;
  rst_synch_bridge my_rst_synch_bridge(.I_RST(RST_async), .CLK(CLK), .O_RST(RST_sync));
  assign RST = RST_sync;

  assign LED = ~{ROAD_DET, PED_BUTT, RST, 1'b0};

  traffic_fsm fsm_inst (
    .clk(CLK),
    .rst(RST),
    .ROAD_RED(ROAD_RED),
    .ROAD_YELLOW(ROAD_YELLOW),
    .ROAD_GREEN(ROAD_GREEN),
    .PED_RED(PED_RED),
    .PED_GREEN(PED_GREEN)
  );

endmodule
