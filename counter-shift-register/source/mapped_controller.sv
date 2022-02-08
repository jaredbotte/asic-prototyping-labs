// Mapped controller file for custom controller
// Jared Botte
// jbotte@purdue.edu
// February 7, 2022

module mapped_controller
(
    input logic CLOCK_50,
    input logic [0:0]KEY,
    output logic [7:0]LEDG,
    output logic [3:0]LEDR // Really unsure if this is the way to do this.
);

    custom_controller CC0 (.clk(CLOCK_50), .n_rst(KEY[0]), .data('1), .latch(LEDR[1]), .pulse(LEDR[2]), .buttons(LEDG));

endmodule