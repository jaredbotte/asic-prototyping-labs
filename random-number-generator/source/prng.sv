// A Pseudo-Random Number Generator using the LFSR
// Jared Botte
// jbotte@purdue.edu
// February 21, 2022

module prng
#(
    parameter NUM_BITS = 4 // The bit width of the number generated.
)
(
    input logic clk,
    input logic n_rst,
    input logic gen_number,
    output logic number_ready,
    output logic [NUM_BITS-1:0] number
);

    logic [23:0] val, seed;
    logic first_num;

    //flex_counter #(.NUM_CNT_BITS(24)) SEEDER (.clk(clk), .n_rst(n_rst), .clear(1'b0), .count_enable(first_num), .count_out(seed));
    assign seed = 24'b100000000000000000000001;

    flex_counter #(.NUM_CNT_BITS(16)) COUNTER (.clk(clk), .n_rst(n_rst), .clear(gen_number), .count_enable(~number_ready), .rollover_val(NUM_BITS), .rollover_flag(number_ready));

    lfsr SHIFT_REG (.clk(clk), .n_rst(n_rst), .shift_enable(~number_ready), .load_enable(first_num), .value(val), .seed(seed));

    assign number = val[NUM_BITS-1:0];

    always_ff @(posedge gen_number, negedge n_rst)
    begin
        if (n_rst == 1'b0)
            first_num <= 1'b1;
        else
            first_num <= 1'b0;
    end

endmodule