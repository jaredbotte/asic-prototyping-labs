// $Id: $
// File name:   counter.sv
// Created:     3/1/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: 1k counter for FIR Filter implementation

module counter
(
    input logic clk,
    input logic n_rst,
    input logic cnt_up,
    input logic clear,
    output logic one_k_samples
);

    flex_counter #(.NUM_CNT_BITS(10)) C1 (.clk(clk), .n_rst(n_rst), .clear(clear | one_k_samples), .count_enable(cnt_up),
                .rollover_val(10'd999), .rollover_flag(one_k_samples));

endmodule