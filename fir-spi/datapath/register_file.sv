// $Id: $
// File name:   reg_file.sv
// Created:     9/22/2015
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: Updated register file for the FIR Filter design lab.

module register_file
#(
	parameter NUM_BITS = 17,
	parameter NUM_SEL_BITS = 4
)
(
	input  wire clk,
	input  wire n_reset,
	input  wire w_en,
	input  wire [(NUM_SEL_BITS - 1):0] r1_sel,
	input  wire [(NUM_SEL_BITS - 1):0] r2_sel,
	input  wire [(NUM_SEL_BITS - 1):0] w_sel,
	input  wire signed [(NUM_BITS - 1):0] w_data,
	output wire signed [(NUM_BITS - 1):0] r1_data,
	output wire signed [(NUM_BITS - 1):0] r2_data,
	output wire signed [(NUM_BITS - 1):0] outreg_data
);
	
	// Calculate local params
	localparam NUM_REGS = 2 ** NUM_SEL_BITS;


	// Declare the internal nets
	reg [(NUM_REGS - 1):0] write_enables;
	reg signed [(NUM_BITS - 1):0] regs_matrix [(NUM_REGS - 1):0];
	
	genvar i;
	
	// Decode the write enable values
	always_comb
	begin: decoding
		// Default value
		write_enables = '0;
		
		// Handle override case for selected dest reg w/ w_en
		if(1'b1 == w_en)
		begin // Writes enabled
			write_enables[w_sel] = 1'b1;
		end
	end
	
	// Handle the Register matrix
	generate
		for(i = 0; i < NUM_REGS; i++)
		begin : gen_matrix
			flex_sreg #(.NUM_BITS(NUM_BITS))
				REGX(
							.clk(clk),
							.n_reset(n_reset),
							.write_enable(write_enables[i]),
							.new_value(w_data),
							.current_value(regs_matrix[i])
						);
		end
	endgenerate
	
	// Handle output reg port
	assign outreg_data = regs_matrix[0];
	
	// Handle read output ports
	assign r1_data = regs_matrix[r1_sel];
	assign r2_data = regs_matrix[r2_sel];

endmodule
