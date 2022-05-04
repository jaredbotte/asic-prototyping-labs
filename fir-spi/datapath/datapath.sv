// $Id: $
// File name:   datapath.sv
// Created:     9/22/2015
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: Updated Datapath module for FIR filter design lab.

module datapath
(
	input  wire clk,
	input  wire n_reset,
	input  wire [2:0] op,
	input  wire [3:0] src1,
	input  wire [3:0] src2,
	input  wire [3:0] dest,
	input  wire [15:0] ext_data1,
	input  wire [15:0] ext_data2,
	output wire [16:0] outreg_data,
	output wire overflow
);

	// alu ops constants
	localparam W_EX1 = 2'd0;
	localparam W_EX2  = 2'd1;
	localparam W_ALU  = 2'd2;
	
	// Declare internal nets
	wire [1:0] alu_op;
	reg  [1:0] w_data_sel;
	wire signed [16:0] alu_result;
	wire signed [16:0] src1_data;
	wire signed [16:0] src2_data;
	reg signed [16:0] dest_data;
	wire w_en;
	
	// Component portmaps
	datapath_decode DEC (
												.op(op),
												.w_en(w_en),
												.w_data_sel(w_data_sel),
												.alu_op(alu_op)
											);
	
	alu CORE (
							.src1_data(src1_data),
							.src2_data(src2_data),
							.alu_op(alu_op),
							.result(alu_result),
							.overflow(overflow)
						);
	
	register_file RF (
											.clk(clk),
											.n_reset(n_reset),
											.w_en(w_en),
											.r1_sel(src1),
											.r2_sel(src2),
											.w_sel(dest),
											.w_data(dest_data),
											.r1_data(src1_data),
											.r2_data(src2_data),
											.outreg_data(outreg_data)
										);
	
	// Destination data mux
	always_comb
	begin
		// Default value (connect to ouput of ALU)
		dest_data = alu_result;
		
		case(w_data_sel)
			W_EX1:
			begin
				dest_data = ext_data1;
			end
			
			W_EX2:
			begin
				dest_data = ext_data2;
			end
		endcase
	end

endmodule
