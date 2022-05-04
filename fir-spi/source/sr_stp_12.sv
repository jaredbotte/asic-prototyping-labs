// 12-bit Parallel-to-Serial shift register wrapper
// Jared Botte
// jbotte@purdue.edu
// May 1st, 2022

module sr_stp_12
(
    input logic clk,
    input logic n_rst,
    input logic mosi,
    input logic pulse,
    output logic [11:0] par_out
);

    flex_stp_sr #(.NUM_BITS(12), .SHIFT_MSB(1'b1)) STP_SR (
        .clk(clk), .n_rst(n_rst),
        .shift_enable(pulse), .serial_in(mosi),
        .parallel_out(par_out));

endmodule