// 8-bit counter using flex counter template
// Jared Botte
// jbotte@purdue.edu
// February 6, 2022

module counter_8bit
(
    input logic [2:0]KEY,
    output logic [6:0]HEX0,
    output logic [6:0]HEX1
);

    wire [7:0] curr_count;
    wire rf; // Rollover flag, not used in this design.
    
    flex_counter #(.NUM_CNT_BITS(8)) U1 (.clk(KEY[0]), .n_rst(KEY[2]), .clear(~KEY[1]), .count_enable(1'b1), .rollover_val('1), .count_out(curr_count), .rollover_flag(rf));

    hex_display D0 (.value(curr_count[3:0]), .disp(HEX0));
    hex_display D1 (.value(curr_count[7:4]), .disp(HEX1));

endmodule

