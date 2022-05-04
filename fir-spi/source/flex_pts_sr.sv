// $Id: $
// File name:   flex_pts_sr.sv
// Created:     2/9/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: A flexible parallel to serial shift register implementation

module flex_pts_sr
#(
    parameter NUM_BITS = 4,
    parameter SHIFT_MSB = 1'b1
)
(
    input logic clk,
    input logic n_rst,
    input logic shift_enable,
    input logic load_enable,
    input logic [(NUM_BITS-1):0]parallel_in,
    output logic serial_out
);

    reg [NUM_BITS-1:0] val;
    reg [NUM_BITS-1:0] next_val;
    reg next_serial_out;

    always_ff @ (posedge clk, negedge n_rst)
    begin
        if (n_rst == 1'b0) begin
            val <= '1;
            serial_out <= 1'b1;
        end else begin
            val <= next_val;
            serial_out <= next_serial_out;
        end
    end

    always_comb
    begin : next_logic
        if (load_enable)
            next_val = parallel_in;
        else if (~shift_enable)
            next_val = val;
        else if (SHIFT_MSB)
            next_val = {val[NUM_BITS-2:0], 1'b0};
        else
            next_val = {1'b0, val[NUM_BITS-1:1]};

        if (SHIFT_MSB)
            next_serial_out = next_val[NUM_BITS-1];
        else
            next_serial_out = next_val[0];
    end

endmodule