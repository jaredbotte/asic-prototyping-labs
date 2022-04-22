// 24-bit Linear-Feedback Shift Register. Has a maximal period of 16,777,215.
// Jared Botte
// jbotte@purdue.edu
// February 20, 2022

module lfsr
(
    input logic clk,
    input logic n_rst,
    input logic shift_enable,
    input logic load_enable,
    input logic [23:0] seed,
    output logic [23:0] value
);

reg [23:0] next_value;

always_ff @ (posedge clk, negedge n_rst)
begin
    if (n_rst == 1'b0)
        value <= '1;
    else
        value <= next_value;
end

always_comb
begin
    if (load_enable == 1'b1)
        next_value = seed;
    else if (shift_enable == 1'b0)
        next_value = value;
    else
        next_value = {value[22:0],value[23] ^ value[22] ^ value[21] ^ value[16]};
end

endmodule