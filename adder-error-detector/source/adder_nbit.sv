// n-bit full adder template
// Jared Botte
// jbotte@purdue.edu
// January 28, 2022

module adder_nbit
#(
	parameter BIT_WIDTH = 4
)
(
	input wire [(BIT_WIDTH-1):0] a,
	input wire [(BIT_WIDTH-1):0] b,
	input wire carry_in,
	output wire [(BIT_WIDTH-1):0] sum,
	output wire overflow
);

	wire [BIT_WIDTH:0] interc;
	genvar i;

	assign interc[0] = carry_in;
	generate
	for(i = 0; i < BIT_WIDTH; i = i + 1)
		begin : adder_gen
			adder_1bit IX (.a(a[i]), .b(b[i]), .carry_in(interc[i]), .carry_out(interc[i + 1]), .sum(sum[i]));
		end
	endgenerate
	assign overflow = interc[BIT_WIDTH];
endmodule
