// 8-bit full adder using n-bit adder template
// Jared Botte
// jbotte@purdue.edu
// January 28, 2022


module adder_8bit
(
	input logic [16:0]SW,
	output logic [8:0]LEDG,
	output logic [16:0]LEDR,
	output logic [6:0]HEX0,
	output logic [6:0]HEX1,
	output logic [6:0]HEX2,
	output logic [6:0]HEX4,
	output logic [6:0]HEX5,
	output logic [6:0]HEX6,
	output logic [6:0]HEX7
);
	
	adder_nbit #(.BIT_WIDTH(8)) U1 (.a(SW[7:0]), .b(SW[15:8]), .carry_in(SW[16]), .sum(LEDG[7:0]), .overflow(LEDG[8]));

	// Additional logic to make things look nice!

	assign LEDR = SW;

	logic [15:0][0:6] display; // This is a 7-bit wide/16-element deep array. We'll use it to store the segment numbers
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

	// sum and carry out
	assign HEX0 = display[LEDG[3:0]];
	assign HEX1 = display[LEDG[7:4]];
	assign HEX2 = display[LEDG[8]];

	// input b
	assign HEX4 = display[SW[3:0]];
	assign HEX5 = display[SW[7:4]];

	// input a
	assign HEX6 = display[SW[11:8]];
	assign HEX7 = display[SW[15:12]];

	// Where to display carry in...

endmodule
