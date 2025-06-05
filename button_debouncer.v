// Button debouncer module
// Eliminates mechanical switch bounce effects
// Generates a clean single pulse on button press

module button_debouncer #(
    parameter DEBOUNCE_TIME = 1000000  // ~20ms at 50MHz
) (
    input  wire clk,
    input  wire rst,
    input  wire button_in,
    output reg  button_pressed
);

reg [19:0] counter;
reg button_sync1, button_sync2, button_state;

// Synchronize button input to clock domain
always @(posedge clk or posedge rst) begin
    if (rst) begin
        button_sync1 <= 1'b0;
        button_sync2 <= 1'b0;
    end else begin
        button_sync1 <= button_in;
        button_sync2 <= button_sync1;
    end
end

// Debounce logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 20'b0;
        button_state <= 1'b0;
        button_pressed <= 1'b0;
    end else begin
        button_pressed <= 1'b0;  // Default: no pulse
        
        if (button_sync2 != button_state) begin
            // Button state is changing, start/restart debounce counter
            counter <= 20'b0;
        end else begin
            // Button state is stable, increment counter
            if (counter < DEBOUNCE_TIME) begin
                counter <= counter + 1'b1;
            end else begin
                // Debounce time expired, update button state
                if (!button_state && button_sync2) begin
                    // Rising edge detected (button press)
                    button_pressed <= 1'b1;
                end
                button_state <= button_sync2;
            end
        end
    end
end

endmodule
