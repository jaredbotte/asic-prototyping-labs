// 12-bit Serial-to-Parallel shift register wrapper
// Jared Botte
// jbotte@purdue.edu
// May 1st, 2022

module sr_pts_12 (
    input logic clk,
    input logic n_rst,
    input logic load,
    input logic pulse,
    input logic [11:0] data_in,
    output logic miso
);

    flex_pts_sr #(.NUM_BITS(12), .SHIFT_MSB(1'b1)) PTS_SR (
        .clk(clk), .n_rst(n_rst),
        .shift_enable(pulse),
        .load_enable(load),
        .parallel_in(data_in),
        .serial_out(miso));

endmodule