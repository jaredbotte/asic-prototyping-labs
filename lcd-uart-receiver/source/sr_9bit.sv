// $Id: $
// File name:   sr_9bit.sv
// Created:     2/16/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: A 9-bit shift register for the UART implementation

module sr_9bit
(
    input logic clk,
    input logic n_rst,
    input logic shift_strobe,
    input logic serial_in,
    output logic [7:0] packet_data,
    output logic stop_bit
);

    flex_stp_sr #(.NUM_BITS(9),.SHIFT_MSB(1'b0)) U1 (.clk(clk), .n_rst(n_rst), .shift_enable(shift_strobe), .serial_in(serial_in), .parallel_out({stop_bit,packet_data}));

endmodule