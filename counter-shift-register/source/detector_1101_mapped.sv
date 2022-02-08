// Mapped "1101" detector using state machine
// Jared Botte
// jbotte@purdue.edu
// February 7, 2022

module detector_1101_mapped
(
    input logic [1:0]KEY,
    input logic [0:0]SW,
    output logic [8:0]LEDG
);

detector_1101 D0 (.clk(KEY[0]), .n_rst(KEY[1]), .data(SW[0]), .out(LEDG[8]), .state(LEDG[2:0]));

endmodule