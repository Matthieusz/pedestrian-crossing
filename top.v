
// Top module for Pedestrian Crossing Traffic Light System
// 20-point version: Default green for cars with button-activated pedestrian crossing

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
  // Button debouncer
  wire ped_button_pressed;
  
  button_debouncer ped_debouncer (
    .clk(CLK),
    .rst(RST),
    .button_in(PED_BUTT),
    .button_pressed(ped_button_pressed)
  );
//-------------------------------------------------------------------------------
  // Pedestrian crossing controller
  wire [3:0] debug_state;
  
  pedestrian_crossing_controller crossing_ctrl (
    .clk(CLK),
    .rst(RST),
    .ped_button_pressed(ped_button_pressed),
    .road_red(ROAD_RED),
    .road_yellow(ROAD_YELLOW),
    .road_green(ROAD_GREEN),
    .ped_red(PED_RED),
    .ped_green(PED_GREEN),
    .debug_state(debug_state)
  );
//-------------------------------------------------------------------------------
  // Heartbeat for debug purposes
  reg [31:0] heartbeat_clk;
  
  always@(posedge CLK or posedge RST) begin
    if(RST)   heartbeat_clk <= 0;
    else      heartbeat_clk <= heartbeat_clk + 1;
  end
//-------------------------------------------------------------------------------
  // LED debug display: [ROAD_DET, PED_BUTT, debug_state[1:0]]
  assign LED = ~{ROAD_DET, PED_BUTT, debug_state[1:0]};
//-------------------------------------------------------------------------------

endmodule
