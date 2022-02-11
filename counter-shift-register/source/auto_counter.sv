// Automaticc counter using flex counter and clock signal
// Jared Botte
// jbotte@purdue.edu
// February 6, 2022

module auto_counter
(
    input logic [2:0]KEY,
    input logic CLOCK_50,
    output logic [6:0]HEX0,
    output logic [6:0]HEX1,
    output logic [6:0]HEX2,
    output logic [6:0]HEX3,
    output logic [6:0]HEX4,
    output logic [6:0]HEX5,
    output logic [6:0]HEX6,
    output logic [6:0]HEX7
);

    wire [12:0] curr_count;
    wire div_clk;

    flex_counter #(.NUM_CNT_BITS(22)) U0 (.clk(CLOCK_50), .n_rst(KEY[2]), .clear(1'b0), .count_enable(1'b1), .rollover_val(22'd2500000), .rollover_flag(div_clk));
    
    flex_counter #(.NUM_CNT_BITS(13)) U1 (.clk(div_clk), .n_rst(KEY[2]), .clear(~KEY[1]), .count_enable(KEY[0]), .rollover_val('1), .count_out(curr_count));

    wire cross12, cross23, cross34;

    dec_display D0 (.value(curr_count[3:0]), .carry_in(1'b0), .carry_out(cross12), .disp(HEX0));
    dec_display D1 (.value(curr_count[7:4]), .carry_in(cross12), .carry_out(cross23), .disp(HEX1));
    dec_display D2 (.value(curr_count[11:8]), .carry_in(cross23), .carry_out(cross34), .disp(HEX2));
    dec_display D3 (.value(curr_count[12:11]), .carry_in(cross34), .disp(HEX3));

    hex_display D4 (.value(curr_count[3:0]), .disp(HEX4));
    hex_display D5 (.value(curr_count[7:4]), .disp(HEX5));
    hex_display D6 (.value(curr_count[11:8]), .disp(HEX6));
    hex_display D7 (.value(curr_count[15:12]), .disp(HEX7));

endmodule

