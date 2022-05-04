// The top level block for the SPI FIR filter implementation
// Jared Botte
// jbotte@purdue.edu
// May 1st, 2022

module spi_fir
(
    input logic clk,
    input logic n_rst,
    input logic mode,
    input logic sck,
    input logic mosi,
    input logic nss, // Used for synchronization
    output logic miso,
    output logic [1:0] debug
);

    logic mosi_s, rise_edge, fall_edge, load, complete;
    logic load_coeff, data_ready, nss_fall, modwait, err;
    logic [11:0] sample_in, sample_out;
    logic [15:0] coeff, fir_out;

    sync_edge SYNC_EDGE (
        .clk(clk),
        .n_rst(n_rst),
        .sck(sck),
        .mosi(mosi),
        .nss(nss),
        .mosi_s(mosi_s),
        .rise_edge(rise_edge),
        .fall_edge(fall_edge),
        .nss_fall(nss_fall));

    sr_stp_12 STP_SR (
        .clk(clk),
        .n_rst(n_rst),
        .mosi(mosi_s),
        .pulse(rise_edge),
        .par_out(sample_in));

    sr_pts_12 PTS_SR (
        .clk(clk),
        .n_rst(n_rst),
        .load(load),
        .pulse(fall_edge),
        .data_in(sample_out),
        .miso(miso));

    flex_counter #(.NUM_CNT_BITS(4)) CNT_12 (
        .clk(clk),
        .n_rst(n_rst),
        .clear(nss_fall),
        .count_enable(rise_edge),
        .rollover_val(4'd12),
        .rollover_flag(complete));

    spi_fir_controller LOOP (
        .clk(clk),
        .n_rst(n_rst),
        .nss_fall(nss_fall),
        .mode(mode),
        .err(err),
        .complete(complete),
        .rise_edge(rise_edge),
        .fall_edge(fall_edge),
        .modwait(modwait),
        .fir_out(fir_out),
        .sample_in(sample_in),
        .load(load),
        .coeff(coeff),
        .load_coeff(load_coeff),
        .data_ready(data_ready),
        .sample_out(sample_out),
        .debug(debug));

    fir_filter FIR_FILTER (
        .clk(clk),
        .n_reset(n_rst),
        .sample_data({4'b0, sample_in}),
        .fir_coefficient(coeff),
        .load_coeff(load_coeff),
        .data_ready(data_ready),
        .modwait(modwait),
        .fir_out(fir_out),
        .err(err));

endmodule