// BCD Display module
// Jared Botte
// jbotte@purdue.edu
// February 9, 2022

module dec_display
(
    input logic [3:0] value,
    input logic carry_in,
    output logic carry_out,
    output logic [6:0] disp
);

    logic [9:0][0:6] display;  // This array stores the segment numbers

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
    
    logic [4:0] val;

    assign val = value + carry_in;

    assign carry_out = (val > 9) 

    always_comb begin : display_block
           if (val < 9)
                disp = display[val];
            else
                disp = display[val - 4];
    end

endmodule