module sensor
(
	input logic [3:0]SW,
	output logic [8:8]LEDR
);
	assign LEDR[8] = SW[0] ? 1'b1 : ((SW[2] | SW[3]) & SW[1]) ? 1'b1 : 1'b0;

endmodule
