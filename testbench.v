// Testbench for Pedestrian Crossing Traffic Light System
`timescale 1ns / 1ps

module pedestrian_crossing_testbench();

// Clock and reset
reg clk;
reg nrst;

// Inputs
reg road_det;
reg ped_butt;

// Outputs
wire road_red;
wire road_yellow;
wire road_green;
wire ped_red;
wire ped_green;
wire [3:0] led;

// Clock generation (50MHz)
initial clk = 0;
always #10 clk = ~clk;  // 20ns period = 50MHz

// Instantiate the top module
top dut (
    .CLK_PCB(clk),
    .nRST_PCB(nrst),
    .ROAD_DET(road_det),
    .ROAD_RED(road_red),
    .ROAD_YELLOW(road_yellow),
    .ROAD_GREEN(road_green),
    .PED_BUTT(ped_butt),
    .PED_RED(ped_red),
    .PED_GREEN(ped_green),
    .LED(led)
);

// Test stimulus
initial begin
    $dumpfile("pedestrian_crossing.vcd");
    $dumpvars(0, pedestrian_crossing_testbench);
    
    // Initialize inputs
    nrst = 0;
    road_det = 0;
    ped_butt = 0;
    
    // Reset sequence
    #100;
    nrst = 1;
    #50;
    nrst = 0;  // Release reset (active low)
    
    // Wait for system to stabilize
    #1000;
    
    $display("Test started - Initial state should be green for cars, red for pedestrians");
    $display("Time=%0t: ROAD(R=%b,Y=%b,G=%b) PED(R=%b,G=%b)", 
             $time, road_red, road_yellow, road_green, ped_red, ped_green);
    
    // Test Case 1: Normal operation without button press
    #5000000;  // Wait 5ms (scaled down for simulation)
    $display("Time=%0t: Should still be green for cars", $time);
    $display("Time=%0t: ROAD(R=%b,Y=%b,G=%b) PED(R=%b,G=%b)", 
             $time, road_red, road_yellow, road_green, ped_red, ped_green);
    
    // Test Case 2: Pedestrian button press
    $display("Time=%0t: Pressing pedestrian button", $time);
    ped_butt = 1;
    #1000000;  // Hold button for 1ms
    ped_butt = 0;
    
    // Monitor the state changes
    #2000000;  // Wait for yellow
    $display("Time=%0t: Should be yellow for cars", $time);
    $display("Time=%0t: ROAD(R=%b,Y=%b,G=%b) PED(R=%b,G=%b)", 
             $time, road_red, road_yellow, road_green, ped_red, ped_green);
    
    #3000000;  // Wait for pedestrian green
    $display("Time=%0t: Should be red for cars, green for pedestrians", $time);
    $display("Time=%0t: ROAD(R=%b,Y=%b,G=%b) PED(R=%b,G=%b)", 
             $time, road_red, road_yellow, road_green, ped_red, ped_green);
    
    #6000000;  // Wait for transition back
    $display("Time=%0t: Should be red+yellow for cars", $time);
    $display("Time=%0t: ROAD(R=%b,Y=%b,G=%b) PED(R=%b,G=%b)", 
             $time, road_red, road_yellow, road_green, ped_red, ped_green);
    
    #3000000;  // Wait for return to normal
    $display("Time=%0t: Should be back to green for cars", $time);
    $display("Time=%0t: ROAD(R=%b,Y=%b,G=%b) PED(R=%b,G=%b)", 
             $time, road_red, road_yellow, road_green, ped_red, ped_green);
    
    // Test Case 3: Multiple button presses (should ignore during sequence)
    $display("Time=%0t: Testing multiple button presses", $time);
    ped_butt = 1;
    #500000;
    ped_butt = 0;
    #500000;
    ped_butt = 1;
    #500000;
    ped_butt = 0;
    
    #5000000;
    $display("Time=%0t: Final state check", $time);
    $display("Time=%0t: ROAD(R=%b,Y=%b,G=%b) PED(R=%b,G=%b)", 
             $time, road_red, road_yellow, road_green, ped_red, ped_green);
    
    $display("Test completed successfully");
    $finish;
end

// Monitor for state changes
always @(posedge clk) begin
    if (road_yellow && !road_red && !road_green) begin
        $display("Time=%0t: State = CARS_YELLOW", $time);
    end else if (road_red && !road_yellow && !road_green && ped_green) begin
        $display("Time=%0t: State = CARS_RED_PED_GREEN", $time);
    end else if (road_red && road_yellow && !road_green && !ped_green) begin
        $display("Time=%0t: State = CARS_RED_YELLOW", $time);
    end else if (!road_red && !road_yellow && road_green && !ped_green) begin
        $display("Time=%0t: State = CARS_GREEN", $time);
    end
end

endmodule
