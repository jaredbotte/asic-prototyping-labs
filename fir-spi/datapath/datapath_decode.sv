// $Id: $
// File name:   datapath_decode.sv
// Created:     9/22/2015
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: Updated operation decode block for the FIR filter datapath design lab.

module datapath_decode
(
	input  wire [2:0] op,
	output reg w_en,
	output reg [1:0] w_data_sel,
	output reg [1:0] alu_op
);
	// dp ops constants
	localparam NOP   = 3'd0;
	localparam COPY  = 3'd1;
	localparam LOAD1 = 3'd2;
	localparam LOAD2 = 3'd3;
	localparam ADD	 = 3'd4;
	localparam SUB	 = 3'd5;
	localparam MUL	 = 3'd6;
	
	// alu ops constants
	localparam ALU_PASS = 2'd0;
	localparam ALU_ADD  = 2'd1;
	localparam ALU_SUB  = 2'd2;
	localparam ALU_MUL  = 2'd3;
	
	// alu ops constants
	localparam W_EX1 = 2'd0;
	localparam W_EX2  = 2'd1;
	localparam W_ALU  = 2'd2;
	
	always_comb
	begin
		// Default values
		w_en = 1'b1;
		w_data_sel = W_ALU;
		alu_op = ALU_PASS;
		
		// Override cases
		case(op)
			NOP:
			begin
				w_en = 1'b0;
			end
			
			// Copy taken care of by defaults
			
			LOAD1:
			begin
				w_data_sel = W_EX1;
			end
			
			LOAD2:
			begin
				w_data_sel = W_EX2;
			end
			
			ADD:
			begin
				alu_op = ALU_ADD;
			end
			
			SUB:
			begin
				alu_op = ALU_SUB;
			end
			
			MUL:
			begin
				alu_op = ALU_MUL;
			end
		endcase
	end

endmodule
