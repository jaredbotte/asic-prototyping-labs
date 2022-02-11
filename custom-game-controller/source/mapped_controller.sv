// Mapped controller file for custom controller
// Jared Botte
// jbotte@purdue.edu
// February 7, 2022

module mapped_controller
(
    input logic CLOCK_50,
    input logic [0:0]KEY,
    output logic [7:0]LEDG,
    inout logic [3:0]GPIO
);

    custom_controller CC0 (.clk(CLOCK_50), .n_rst(KEY[0]), .data(GPIO[2]), .latch(GPIO[0]), .pulse(GPIO[1]), .buttons(LEDG[7:0]), .shift(GPIO[3]));

endmodule
