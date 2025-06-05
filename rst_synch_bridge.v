// Reset synchronizer bridge module
// Provides proper reset synchronization for digital circuits

module rst_synch_bridge (
    input  wire I_RST,  // Asynchronous reset input
    input  wire CLK,    // Clock input
    output reg  O_RST   // Synchronized reset output
);

reg rst_sync_ff1, rst_sync_ff2;

always @(posedge CLK or posedge I_RST) begin
    if (I_RST) begin
        rst_sync_ff1 <= 1'b1;
        rst_sync_ff2 <= 1'b1;
        O_RST <= 1'b1;
    end else begin
        rst_sync_ff1 <= 1'b0;
        rst_sync_ff2 <= rst_sync_ff1;
        O_RST <= rst_sync_ff2;
    end
end

endmodule
