// Alphanumeric Display Module
// Jared Botte
// jbotte@purdue.edu
// March 4, 2022

module alpha_display
(
    input wire [7:0] ascii,
    output wire [6:0] disp
);

    always_comb begin : letters
        case(ascii)
        8'h23: // Will use 'H' as '#'
            disp = 7'b0001001;
        8'h2A: // Will use octothorpe as '*'
            disp = 7'b0110110;
        8'h30: // 0
            disp = 7'b1000000;
        8'h31: // 1
            disp = 7'b1111001;
        8'h32: // 2
            disp = 7'b0100100;
        8'h33: // 3
            disp = 7'b0110000;
        8'h34: // 4
            disp = 7'b0011001;
        8'h35: // 5
            disp = 7'b0010010;
        8'h36: // 6
            disp = 7'b0000010;
        8'h37: // 7
            disp = 7'b1111000;
        8'h38: // 8
            disp = 7'b0000000;
        8'h39: // 9
            disp = 7'b0011000;
        8'h41: // A
            disp = 7'b0001000;
        8'h61: // a
            disp = 7'b0001000;
        8'h42: // B
            disp = 7'b0000011;
        8'h62: // b
            disp = 7'b0000011;
        8'h43: // C
            disp = 7'b1000110;
        8'h63: // c
            disp = 7'b1000110;
        8'h44: // D 
            disp = 7'b0100001;
        8'h64: // d
            disp = 7'b0100001;
        8'h45: // E
            disp = 7'b0000110;
        8'h65: // e
            disp = 7'b0000110;
        8'h46: // F
            disp = 7'b0001110;
        8'h66: // f
            disp = 7'b0001110;
        8'h47: // G
            disp = 7'b1000010;
        8'h67: // g
            disp = 7'b1000010;
        8'h48: // H
            disp = 7'b0001011;
        8'h68: // h
            disp = 7'b0001011;
        8'h49: // I
            disp = 7'b1001111;
        8'h69: // i
            disp = 7'b1001111;
        8'h4A: // J
            disp = 7'b1100001;
        8'h6A: // j
            disp = 7'b1100001;
        8'h4C: // L
            disp = 7'b1000111;
        8'h6C: // l
            disp = 7'b1000111;
        8'h4E: // N
            disp = 7'b0101011;
        8'h6E: // n
            disp = 7'b0101011;
        8'h4F: // O
            disp = 7'b0100011;
        8'h6F: // o
            disp = 7'b0100011;
        8'h50: // P
            disp = 7'b0001100;
        8'h70: // p
            disp = 7'b0001100;
        8'h51: // Q
            disp = 7'b0011000;
        8'h71: // q
            disp = 7'b0011000;
        8'h52: // R
            disp = 7'b0101111;
        8'h72: // r
            disp = 7'b0101111;
        8'h53: // S
            disp = 7'b0010010;
        8'h73: // s
            disp = 7'b0010010;
        8'h54: // T
            disp = 7'b0000111;
        8'h74: // t
            disp = 7'b0000111;
        8'h55: // U
            disp = 7'b1000001;
        8'h75: // u
            disp = 7'b1000001;
        8'h59: // Y
            disp = 7'b0010001;
        8'h79: // y
            disp = 7'b0010001;
        default:
            disp = 7'b1111111; // This shows nothing on the display
        endcase
    end





endmodule