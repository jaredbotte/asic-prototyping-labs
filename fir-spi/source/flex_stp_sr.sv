// $Id: $
// File name:   flex_stp_sr.sv
// Created:     2/9/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: A flexible n-bit serial-to-parallel shift register implementation

module flex_stp_sr
#(
    parameter NUM_BITS = 4,
    parameter SHIFT_MSB = 1'b1
)
(
    input logic clk,
    input logic n_rst,
    input logic shift_enable,
    input logic serial_in,
    output logic [NUM_BITS - 1:0]parallel_out
);
    reg [NUM_BITS-1:0]next_val;

    always_ff @ (posedge clk, negedge n_rst)
    begin
        if (n_rst == 1'b0)
            parallel_out <= '1;
        else
            parallel_out <= next_val;
    end

    always_comb
    begin : next_logic
        if (shift_enable == 1'b0)
            next_val = parallel_out;
        else if (SHIFT_MSB == 1'b1)
            next_val = {parallel_out[NUM_BITS-2:0],serial_in};
        else
            next_val = {serial_in,parallel_out[NUM_BITS-1:1]};
    end

endmodule