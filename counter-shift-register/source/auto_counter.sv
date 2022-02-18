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
    output logic [6:0]HEX3
);

    wire [15:0] curr_count;
    wire div_clk;

    flex_counter #(.NUM_CNT_BITS(22)) U0 (.clk(CLOCK_50), .n_rst(KEY[2]), .clear(1'b0), .count_enable(KEY[0]), .rollover_val(22'd2500000), .rollover_flag(div_clk));
    
    flex_counter #(.NUM_CNT_BITS(13)) U1 (.clk(CLOCK_50), .n_rst(KEY[2]), .clear(~KEY[1]), .count_enable(div_clk), .rollover_val('1), .count_out(curr_count));

    hex_display D0 (.value(curr_count[3:0]), .disp(HEX0));
    hex_display D1 (.value(curr_count[7:4]), .disp(HEX1));
    hex_display D2 (.value(curr_count[11:8]), .disp(HEX2));
    hex_display D3 (.value(curr_count[15:12]), .disp(HEX3));

endmodule

