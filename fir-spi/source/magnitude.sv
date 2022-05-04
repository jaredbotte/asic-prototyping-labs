// $Id: $
// File name:   magnitude.sv
// Created:     3/1/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Magnitude calculator for FIR Filter implementation

module magnitude
(
    input logic [16:0] in,
    output logic [15:0] out
);

always_comb begin : unsign
    out = in[16] ? ~(in[15:0] - 1) : in[15:0];
end
endmodule