// $Id: $
// File name:   rcu.sv
// Created:     2/16/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: The Reviever Control Unit for the UART implementation

module rcu
(
    input logic clk,
    input logic n_rst,
    input logic new_packet_detected,
    input logic packet_done,
    input logic framing_error,
    output logic sbc_clear,
    output logic sbc_enable,
    output logic load_buffer,
    output logic enable_timer
);

    typedef enum logic [2:0] {IDLE, WAIT_1, RECEIVING, WAIT_2, CHECKING, LOAD} rcu_state;

    rcu_state state, next_state;

    logic wait_done;

    flex_counter #(.NUM_CNT_BITS(8)) WAIT_COUNT (.clk(clk), .n_rst(n_rst), .clear(~(state == WAIT_1)), .count_enable(WAIT_1), .rollover_val(8'd216), .rollover_flag(wait_done));

    always_ff @( posedge clk, negedge n_rst ) 
    begin
       if (n_rst == 1'b0) begin
           state <= IDLE;
       end else begin
           state <= next_state;
       end 
    end

    always_comb 
    begin
        case (state)
        IDLE:
            next_state = new_packet_detected ? WAIT_1 : IDLE;
        WAIT_1:
            next_state = wait_done ? RECEIVING : WAIT_1;
        RECEIVING:
            next_state = packet_done ? WAIT_2 : RECEIVING;
        WAIT_2:
            next_state = CHECKING;
        CHECKING:
            next_state = framing_error ? IDLE : LOAD;
        LOAD:
            next_state = IDLE;
        default:
            next_state = IDLE;
        endcase    

        sbc_clear = state == WAIT_1;
        sbc_enable = state == WAIT_2;
        load_buffer = state == LOAD;
        enable_timer = state == RECEIVING;
    end

endmodule