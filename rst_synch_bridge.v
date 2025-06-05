module rst_synch_bridge (
  input  wire I_RST,
  input  wire CLK,
  output wire O_RST
);
  reg [1:0] sync;

  always @(posedge CLK or posedge I_RST) begin
    if (I_RST)
      sync <= 2'b11;
    else
      sync <= {sync[0], 1'b0};
  end

  assign O_RST = sync[1];
endmodule