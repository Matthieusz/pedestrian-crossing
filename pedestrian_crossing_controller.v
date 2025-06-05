// Pedestrian Crossing Traffic Light Controller
// 20-point version: Default green for cars, button-activated pedestrian crossing

module pedestrian_crossing_controller (
    input  wire clk,
    input  wire rst,
    input  wire ped_button_pressed,
    output reg  road_red,
    output reg  road_yellow,
    output reg  road_green,
    output reg  ped_red,
    output reg  ped_green,
    output wire [3:0] debug_state
);

// State definitions
localparam [2:0] 
    STATE_CARS_GREEN     = 3'b000,  // Default: Green for cars, Red for pedestrians
    STATE_CARS_YELLOW    = 3'b001,  // Yellow for cars, Red for pedestrians
    STATE_CARS_RED_PED_GREEN = 3'b010,  // Red for cars, Green for pedestrians
    STATE_CARS_RED_YELLOW = 3'b011,  // Red+Yellow for cars, Red for pedestrians
    STATE_WAIT           = 3'b100;  // Wait state to prevent rapid cycling

// Timer constants (50MHz clock)
localparam [25:0]
    TIMER_1_SEC = 26'd50000000,     // 1 second
    TIMER_2_SEC = 26'd100000000,    // 2 seconds  
    TIMER_5_SEC = 26'd250000000;    // 5 seconds

// State machine registers
reg [2:0] current_state, next_state;
reg [25:0] timer_counter;
reg timer_expired;

// Timer logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        timer_counter <= 26'b0;
        timer_expired <= 1'b0;
    end else begin
        if (current_state != next_state) begin
            // State is changing, reset timer
            timer_counter <= 26'b0;
            timer_expired <= 1'b0;
        end else begin
            // Count timer
            case (current_state)
                STATE_CARS_YELLOW, STATE_CARS_RED_YELLOW: begin
                    if (timer_counter >= TIMER_2_SEC - 1) begin
                        timer_expired <= 1'b1;
                    end else begin
                        timer_counter <= timer_counter + 1'b1;
                        timer_expired <= 1'b0;
                    end
                end
                STATE_CARS_RED_PED_GREEN: begin
                    if (timer_counter >= TIMER_5_SEC - 1) begin
                        timer_expired <= 1'b1;
                    end else begin
                        timer_counter <= timer_counter + 1'b1;
                        timer_expired <= 1'b0;
                    end
                end
                STATE_WAIT: begin
                    if (timer_counter >= TIMER_1_SEC - 1) begin
                        timer_expired <= 1'b1;
                    end else begin
                        timer_counter <= timer_counter + 1'b1;
                        timer_expired <= 1'b0;
                    end
                end
                default: begin
                    timer_counter <= 26'b0;
                    timer_expired <= 1'b0;
                end
            endcase
        end
    end
end

// State register
always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= STATE_CARS_GREEN;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    next_state = current_state;  // Default: stay in current state
    
    case (current_state)
        STATE_CARS_GREEN: begin
            if (ped_button_pressed) begin
                next_state = STATE_CARS_YELLOW;
            end
        end
        
        STATE_CARS_YELLOW: begin
            if (timer_expired) begin
                next_state = STATE_CARS_RED_PED_GREEN;
            end
        end
        
        STATE_CARS_RED_PED_GREEN: begin
            if (timer_expired) begin
                next_state = STATE_CARS_RED_YELLOW;
            end
        end
        
        STATE_CARS_RED_YELLOW: begin
            if (timer_expired) begin
                next_state = STATE_WAIT;
            end
        end
        
        STATE_WAIT: begin
            if (timer_expired) begin
                next_state = STATE_CARS_GREEN;
            end
        end
        
        default: begin
            next_state = STATE_CARS_GREEN;
        end
    endcase
end

// Output logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        road_red    <= 1'b0;
        road_yellow <= 1'b0;
        road_green  <= 1'b1;  // Default green for cars
        ped_red     <= 1'b1;  // Default red for pedestrians
        ped_green   <= 1'b0;
    end else begin
        case (current_state)
            STATE_CARS_GREEN: begin
                road_red    <= 1'b0;
                road_yellow <= 1'b0;
                road_green  <= 1'b1;
                ped_red     <= 1'b1;
                ped_green   <= 1'b0;
            end
            
            STATE_CARS_YELLOW: begin
                road_red    <= 1'b0;
                road_yellow <= 1'b1;
                road_green  <= 1'b0;
                ped_red     <= 1'b1;
                ped_green   <= 1'b0;
            end
            
            STATE_CARS_RED_PED_GREEN: begin
                road_red    <= 1'b1;
                road_yellow <= 1'b0;
                road_green  <= 1'b0;
                ped_red     <= 1'b0;
                ped_green   <= 1'b1;
            end
            
            STATE_CARS_RED_YELLOW: begin
                road_red    <= 1'b1;
                road_yellow <= 1'b1;
                road_green  <= 1'b0;
                ped_red     <= 1'b1;
                ped_green   <= 1'b0;
            end
            
            STATE_WAIT: begin
                road_red    <= 1'b0;
                road_yellow <= 1'b0;
                road_green  <= 1'b1;
                ped_red     <= 1'b1;
                ped_green   <= 1'b0;
            end
            
            default: begin
                road_red    <= 1'b0;
                road_yellow <= 1'b0;
                road_green  <= 1'b1;
                ped_red     <= 1'b1;
                ped_green   <= 1'b0;
            end
        endcase
    end
end

// Debug output - show current state
assign debug_state = {1'b0, current_state};

endmodule
