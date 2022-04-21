// $Id: $
// File name:   flex_counter
// Created:     1/31/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Flexible counter with rollover detection

module flex_counter
#(
	parameter NUM_CNT_BITS = 4
)
(
	input logic clk,
	input logic n_rst,
	input logic clear,
	input logic count_enable,
	input logic [(NUM_CNT_BITS-1):0] rollover_val,
	output logic [(NUM_CNT_BITS-1):0] count_out,
	output logic rollover_flag
);

	reg [NUM_CNT_BITS-1:0] next_count_out;
	reg next_rollover_flag;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0) begin
			count_out <= 'b0;
			rollover_flag <= 1'b0;
		end else begin
			count_out <= next_count_out;
			rollover_flag <= next_rollover_flag;
		end
	end


	always_comb
	begin
		next_count_out = count_out;
		next_rollover_flag = 1'b0;

		if(clear) begin
			next_count_out = 'b1;
		end else if (count_enable) begin
			next_count_out = count_out + 1;
		end

		if(next_count_out == rollover_val) begin
			next_rollover_flag = 1'b1;
		end

		if(count_out == rollover_val) begin
			next_count_out = 'd1;
		end
	end

endmodule
