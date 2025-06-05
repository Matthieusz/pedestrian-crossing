module traffic_fsm (
  input  wire clk,
  input  wire rst,

  output reg ROAD_RED,
  output reg ROAD_YELLOW,
  output reg ROAD_GREEN,
  output reg PED_RED,
  output reg PED_GREEN
);

  typedef enum logic [2:0] {
    S_CAR_GREEN       = 3'd0,
    S_CAR_YELLOW      = 3'd1,
    S_ALL_RED         = 3'd2,
    S_PED_GREEN       = 3'd3,
    S_PED_BLINK_GREEN = 3'd4,
    S_CAR_RED_YELLOW  = 3'd5
  } state_t;

  state_t state, next_state, prev_state;
  reg [31:0] counter;

  localparam SEC_1 = 1;
  localparam SEC_4 = 4 * SEC_1;
  localparam SEC_5 = 5 * SEC_1;

  reg blink;  // uzywane do migania zielonego swiatla

  // Licznik i FSM
	always_ff @(posedge clk or posedge rst) begin
	  if (rst) begin
	    state       <= S_CAR_GREEN;
	    prev_state  <= S_CAR_GREEN;
	    counter     <= SEC_5;
	    blink       <= 0;
	  end else begin
	    if (counter > 0)
	      counter <= counter - 1;
	    else begin
	      prev_state <= state;
	      state <= next_state;
	      case (next_state)
	        S_CAR_GREEN:       counter <= SEC_5;
	        S_CAR_YELLOW:      counter <= SEC_1;
	        S_ALL_RED:         counter <= SEC_1;
	        S_PED_GREEN:       counter <= SEC_4;
	        S_PED_BLINK_GREEN: counter <= SEC_1;
	        S_CAR_RED_YELLOW:  counter <= SEC_1;
	      endcase
	    end
	
	    if (state == S_PED_BLINK_GREEN && counter[24] == 0)
	      blink <= ~blink;
	  end
	end

  // Logika wyjsc
  always_comb begin
    next_state = state;
    ROAD_RED = 0; ROAD_YELLOW = 0; ROAD_GREEN = 0;
    PED_RED  = 0; PED_GREEN   = 0;

    case (state)
      S_CAR_GREEN: begin
        ROAD_GREEN = 1;
        PED_RED    = 1;
        if (counter == 0) next_state = S_CAR_YELLOW;
      end

      S_CAR_YELLOW: begin
        ROAD_YELLOW = 1;
        PED_RED     = 1;
        if (counter == 0) next_state = S_ALL_RED;
      end

      S_ALL_RED: begin
	  ROAD_RED = 1;
	  PED_RED  = 1;
	  if (counter == 0) begin
	    if (prev_state == S_CAR_YELLOW)       next_state = S_PED_GREEN;
	    else if (prev_state == S_PED_BLINK_GREEN) next_state = S_CAR_RED_YELLOW;
	    else next_state = S_CAR_GREEN; // fallback awaryjny
	  end
	end

      S_PED_GREEN: begin
        ROAD_RED   = 1;
        PED_GREEN  = 1;
        if (counter == 0) next_state = S_PED_BLINK_GREEN;
      end

      S_PED_BLINK_GREEN: begin
        ROAD_RED = 1;
        PED_GREEN = blink;
        if (counter == 0) next_state = S_ALL_RED;
      end

      S_CAR_RED_YELLOW: begin
        ROAD_RED    = 1;
        ROAD_YELLOW = 1;
        PED_RED     = 1;
        if (counter == 0) next_state = S_CAR_GREEN;
      end
    endcase
  end

endmodule
