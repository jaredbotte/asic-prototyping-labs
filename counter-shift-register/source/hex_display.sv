// Hex display module
// Jared Botte
// jbotte@purdue.edu
// February 6, 2022

module hex_display
(
    input wire [3:0]value,
    output wire [6:0]disp
);

    logic [15:0][0:6] display;  // This array stores the segment numbers

    assign display[0] = 7'b1000000;
    assign display[1] = 7'b1111001;
    assign display[2] = 7'b0100100;
    assign display[3] = 7'b0110000;
    assign display[4] = 7'b0011001;
    assign display[5] = 7'b0010010;
    assign display[6] = 7'b0000010;
    assign display[7] = 7'b1111000;
    assign display[8] = 7'b0000000;
    assign display[9] = 7'b0011000;
    assign display[10] = 7'b0001000;
    assign display[11] = 7'b0000011;
    assign display[12] = 7'b1000110;
    assign display[13] = 7'b0100001;
    assign display[14] = 7'b0000110;
    assign display[15] = 7'b0001110;
    
    assign disp = display[value];

endmodule
