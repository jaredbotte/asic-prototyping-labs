// $Id: $
// File name:   fir_filter.sv
// Created:     3/1/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: FIR Filter Implementation Top Block

module fir_filter
(
    input logic clk,
    input logic n_reset,
    input logic [15:0] sample_data,
    input logic [15:0] fir_coefficient,
    input logic load_coeff,
    input logic data_ready,
    output logic one_k_samples,
    output logic modwait,
    output logic [15:0] fir_out,
    output logic err
);

    wire ovf, cnt_up, clear;
    wire [2:0] op;
    wire [3:0] src1, src2, dest;
    wire [16:0] dpath_out;

    // Sample counter. Will clear on coefficient load. TODO: Needs to count up each time a sample comes in.
    counter SAMPLE_COUNT (.clk(clk), .n_rst(n_reset), .cnt_up(cnt_up), .clear(clear), .one_k_samples(one_k_samples));

    // Controller
    controller CONT (.clk(clk), .n_rst(n_reset), .dr(data_ready), .lc(load_coeff), .overflow(ovf), .cnt_up(cnt_up),
                    .clear(clear), .modwait(modwait), .op(op), .src1(src1), .src2(src2), .dest(dest), .err(err));

    // Magnitude. Takes in the result of the datapath and outputs the positive version on fir_out
    magnitude MAG (.in(dpath_out), .out(fir_out));

    // Synchronizers
    //sync_low LC_SYNC (.clk(clk), .n_rst(n_reset), .async_in(load_coeff), .sync_out(lc));
    //sync_low DR_SYNC (.clk(clk), .n_rst(n_reset), .async_in(data_ready), .sync_out(dr));

    // Datapath
    datapath DPATH (.clk(clk), .n_reset(n_reset), .op(op), .src1(src1), .src2(src2), .dest(dest), 
                    .ext_data1(fir_coefficient), .ext_data2(sample_data), .outreg_data(dpath_out), .overflow(ovf));

endmodule