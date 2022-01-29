// 1-bit full adder
// Jared Botte
// jbotte@purdue.edu
// January 28, 2022


module adder_1bit
(
	input wire a,
	input wire b,
	input wire carry_in,
	output wire carry_out,
	output wire sum
);

	assign sum = carry_in ^ (a ^ b);
	assign carry_out = ((~carry_in) & a & b) | (carry_in & (a | b));

endmodule
