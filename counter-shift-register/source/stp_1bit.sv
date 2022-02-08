// 1-bit serial-to-parallel (StP) shift register
// Jared Botte
// jbotte@purdue.edu
// February 7, 2022

module stp_1bit
(
    input logic ser_in,
    input logic clk,
    input logic n_rst,
    output logic par_out
);
    reg next_out;

    always_ff @ (posedge clk, negedge n_rst)
    begin
        if (n_rst == 1'b0)
            par_out <= 1'b1;
        else
            par_out <= next_out;
    end

    always_comb
    begin
        next_out = ser_in;        
    end
endmodule