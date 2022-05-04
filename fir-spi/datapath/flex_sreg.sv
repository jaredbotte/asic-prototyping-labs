// $Id: $
// File name:   flex_reg.sv
// Created:     9/22/2015
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: Simple scalable register with write enable.

module flex_sreg
#(
	parameter NUM_BITS = 16
)
(
	input  wire clk,
	input  wire n_reset,
	input  wire write_enable,
	input  wire signed [(NUM_BITS - 1):0]new_value,
	output wire signed [(NUM_BITS - 1):0]current_value
);

	// Declare internal wires
	reg signed [(NUM_BITS - 1):0] value;
	reg signed [(NUM_BITS - 1):0] nxt_value;
	
	// Next value logic
	always_comb
	begin
		// Default values
		nxt_value = value;
		
		// Override case(s)
		if(1'b1 == write_enable)
		begin
			nxt_value = new_value;
		end
	end
	
	// Internal Current State logic	
	always_ff @(posedge clk, negedge n_reset)
	begin
		if(1'b0 == n_reset)
		begin // Reset condition
			value <= '0;
		end
		else // Clock edge condition
		begin
			value <= nxt_value;
		end
	end
	
	// Connect to outside world
	assign current_value = value;
	
endmodule
