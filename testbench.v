`timescale 1ns / 1ps

module tb_traffic;

  reg clk = 0;
  reg rst = 1;

  wire road_red, road_yellow, road_green;
  wire ped_red, ped_green;

  traffic_fsm uut (
    .clk(clk),
    .rst(rst),
    .ROAD_RED(road_red),
    .ROAD_YELLOW(road_yellow),
    .ROAD_GREEN(road_green),
    .PED_RED(ped_red),
    .PED_GREEN(ped_green)
  );

  // Zegar 50 MHz
  always #10 clk = ~clk;

  initial begin
    $dumpfile("traffic.vcd");
    $dumpvars(0, tb_traffic);

    // Reset przez 200 ns
    #200 rst = 0;

    // Symulacja przez ~60 sekund (zegar 20ns -> 50MHz)
    #50000;
    $finish;
  end

endmodule
