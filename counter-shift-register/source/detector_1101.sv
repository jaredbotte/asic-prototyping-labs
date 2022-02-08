// "1101" detector using a state machine
// Jared Botte
// jbotte@purdue.edu
// February 7, 2022

module detector_1101
(
    input logic clk, n_rst, data,
    output logic [2:0] state,
    output logic out
);
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
    reg [2:0] next_state;

    always_ff @ (posedge clk, negedge n_rst)
    begin
        if (n_rst == 1'b0)
            state <= S0;
        else
            state <= next_state;
    end

    always_comb
    begin
        case (state)
        S0:
            next_state = data == 1'b1 ? S1 : S0;
        S1:
           next_state = data == 1'b1 ? S2 : S0;
        S2:
           next_state = data == 1'b1 ? S2 : S3;
        S3:
           next_state = data == 1'b1 ? S4 : S0;
        S4:
           next_state = data == 1'b1 ? S1 : S0;
        default:
            next_state = S0;
        endcase
    end

    assign out = state == S4;

endmodule