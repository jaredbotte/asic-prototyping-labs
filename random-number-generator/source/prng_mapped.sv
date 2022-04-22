// A mapped version of the PRNG that will display a random
// number to a hexidecimal display
// Jared Botte
// jbotte@purdue.edu
// February 21, 2022

module prng_mapped
(
    input logic CLOCK_50,
    input logic [1:0]KEY,
    output logic [6:0]HEX0
);

    logic nr;
    logic [3:0] next_num, num;

    prng RNG (.clk(CLOCK_50), .n_rst(KEY[0]), .gen_number(KEY[1]), .number_ready(nr), .number(next_num));

    hex_display DISP0 (.disp(HEX0), .value(num));

    always_ff @ (posedge CLOCK_50, negedge KEY[0])
    begin
        if (KEY[0] == 1'b0)
            num <= 4'b0;
        else if (nr == 1'b1)
            num <= next_num;
        else
            num <= num;
    end

endmodule