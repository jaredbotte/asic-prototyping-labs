// $Id: $
// File name:   alu.sv
// Created:     9/22/2015
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: Updated ALU for the FIR filter design lab.

module alu
(
	input  wire signed [16:0] src1_data,
	input  wire signed [16:0] src2_data,
	input  wire 			 [1:0]	alu_op,
	output reg signed  [16:0] result,
	output reg 							overflow
);
	localparam PASS = 2'd0;
	localparam ADD  = 2'd1;
	localparam SUB  = 2'd2;
	localparam MUL  = 2'd3;

	// Declare internal wire sets
	wire [30:0] aligned_sample;
	wire [30:0] aligned_coefficient;
	wire [61:0] full_mult;
	wire [15:0] truncated_mult;
	wire signed [17:0] large_sum;
	wire signed [17:0] large_dif;

	// Align the input values after extracting the unsigned portion
	assign aligned_sample = {src1_data[15:0], 15'd0};
	assign aligned_coefficient = {15'd0, src2_data[15:0]};
	
	// Multiply the aligned values
	assign full_mult = aligned_sample * aligned_coefficient;
	
	// Extract out the lowest 16-bits of the whole-number region for the result
	assign truncated_mult = full_mult[45:30];
	
	// Need an extra large add result vector for overflow checks
	assign large_sum = src1_data + src2_data;
	
	// Need an extra large sub result vector for overflow checks
	assign large_dif = src1_data - src2_data;

	always_comb
	begin
		// Default values
		result = '0;
		overflow = 1'b0;
	
		case(alu_op)
			PASS:
			begin
				result = src1_data;
			end
			
			ADD:
			begin
				if(2'b01 == large_sum[17:16])
				begin // Overflow happened
					overflow = 1'b1;
				end
				else if(2'b10 == large_sum[17:16])
				begin // Underflow happened (Negative overflow)
					overflow = 1'b1;
				end
				result = large_sum[16:0];
			end
			
			SUB:
			begin
				if(2'b01 == large_dif[17:16])
				begin // Overflow happened
					overflow = 1'b1;
				end
				else if(2'b10 == large_dif[17:16])
				begin // Underflow happened (Negative overflow)
					overflow = 1'b1;
				end
				result = large_dif[16:0];
			end
			
			MUL:
			begin
				if(0 < full_mult[61:46])
				begin // multiplaction overflow
					overflow = 1'b1;
				end
				result = truncated_mult;
			end
		endcase
	end

endmodule
