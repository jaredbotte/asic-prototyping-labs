// 1-bit full adder
// Jared Botte
// jbotte@purdue.edu
// January 28, 2022


module adder_1bit_mapped
(
	input logic [17:15]SW,
	output logic [17:16]LEDR
);

	assign LEDR[16] = SW[17] ^ (SW[16] ^ SW[15]);
	assign LEDR[17] = ((~SW[17]) & SW[16] & SW[15]) | (SW[17] & (SW[16] | SW[15]));

endmodule
