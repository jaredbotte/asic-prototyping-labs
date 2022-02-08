// 4-bit mapped StP Shift Register
// Jared Botte
// jbotte@purdue.ed
// February 7, 2022

module stp_4bit
(
    input logic [1:0]KEY,
    input logic [0:0]SW,
    output logic [8:0]LEDG
);
    reg [3:0] par_out; // Can do it without this but using it for clarity.

    stp_nbit #(.BIT_WIDTH(4)) SR0 (.clk(KEY[0]), .n_rst(KEY[1]), .ser_in(SW[0]), .par_out(par_out));

    assign LEDG[3:0] = par_out;
    assign LEDG[8] = par_out[3] & par_out[2] & ~par_out[1] & par_out[0];

endmodule