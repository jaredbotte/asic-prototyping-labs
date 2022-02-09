// This is a file so that I can incrementally test my controller code.

module test
(
    input logic CLOCK_50,
    input logic [0:0]KEY,
    output logic [0:0]GPIO,
    output logic [0:0]LEDR
);
    logic roll;

    flex_counter #(.NUM_CNT_BITS(20)) POLL_CNT (.clk(CLOCK_50), .n_rst(KEY[0]), .clear(1'b0), .count_enable(1'b1), .rollover_val(20'd833333), .rollover_flag(roll));

    assign LEDR[0] = roll;
    assign GPIO[0] = roll;

endmodule