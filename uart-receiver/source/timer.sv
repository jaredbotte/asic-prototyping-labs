// $Id: $
// File name:   timer.sv
// Created:     2/16/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: The timer module for the UART implementation

module timer
(
    input logic clk,
    input logic n_rst,
    input logic enable_timer,
    output logic shift_strobe,
    output logic packet_done
);

    flex_counter #(.NUM_CNT_BITS(10)) CLOCK_COUNT (.clk(clk), .n_rst(n_rst), .clear(~enable_timer), .count_enable(enable_timer), .rollover_val(10'd434), .rollover_flag(shift_strobe));
    flex_counter #(.NUM_CNT_BITS(4)) BIT_COUNT (.clk(clk), .n_rst(n_rst), .clear(~enable_timer), .count_enable(shift_strobe), .rollover_val(4'd10), .rollover_flag(packet_done));

endmodule