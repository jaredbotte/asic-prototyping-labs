// n-bit StP shift register
// Jared Botte
// jbotte@purdue.edu
// February 7, 2022

module stp_nbit
#(
    parameter BIT_WIDTH = 4
)
(
    input logic ser_in,
    input logic clk,
    input logic n_rst,
    output logic [BIT_WIDTH-1:0] par_out
);

    reg [BIT_WIDTH:0] connections;
    genvar i;

    assign connections[0] = ser_in;

    generate
        for(i = 0; i < BIT_WIDTH; i = i + 1) 
        begin : stp_sr_generate
            stp_1bit IX (.clk(clk), .ser_in(connections[i]), .n_rst(n_rst), .par_out(connections[i+1]));
        end
    endgenerate 

    assign par_out = connections[BIT_WIDTH:1];

endmodule