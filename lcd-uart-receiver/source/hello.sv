// Hello on 7-segment displays
// Jared Botte
// jbotte@purdue.edu
// March 4, 2022

module hello
(
    output logic [6:0]HEX4,
    output logic [6:0]HEX3,
    output logic [6:0]HEX2,
    output logic [6:0]HEX1,
    output logic [6:0]HEX0
);

    alpha_display D0 (.ascii(8'h48), .disp(HEX4));
    alpha_display D1 (.ascii(8'h45), .disp(HEX3));
    alpha_display D2 (.ascii(8'h4C), .disp(HEX2));
    alpha_display D3 (.ascii(8'h4C), .disp(HEX1));
    alpha_display D4 (.ascii(8'h4F), .disp(HEX0));

endmodule