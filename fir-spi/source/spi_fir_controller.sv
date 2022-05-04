// An SPI Loopback configuration for testing
// Jared Botte
// jbotte@purdue.edu
// May 1st, 2022

module spi_fir_controller
(
    input logic clk,
    input logic n_rst,
    input logic mode,
    input logic complete,
    input logic rise_edge,
    input logic fall_edge,
    input logic nss_fall,
    input logic modwait,
    input logic err, // TODO Remove after debugging
    input logic [16:0] fir_out,
    input logic [11:0] sample_in,
    output logic load,
    output logic data_ready,
    output logic load_coeff,
    output logic [11:0] sample_out,
    output logic [15:0] coeff,
    output logic [1:0] debug // TODO Remove after debugging
);

    typedef enum logic [4:0] {RESET, INIT1, INIT_WAIT1, INIT2, INIT_WAIT2, INIT3, INIT_WAIT3, INIT4, INIT_WAIT4,
                                IDLE, RECV, WAIT, WAIT2, WAIT3, LOAD, LOAD_DATA, WAIT1, SEND_DATA} state_type;

    state_type next_state, state;

    logic [11:0] data_buff, next_data_buff, next_sample_out;

    always_ff @ (posedge clk, negedge n_rst) begin
        if (n_rst == 1'b0) begin
            state <= RESET;
            sample_out <= '0;
            data_buff <= '0;
        end else begin
            state <= next_state;
            sample_out <= next_sample_out;
            data_buff <= next_data_buff;
        end
    end

    always_comb begin: next_state_logic
        next_data_buff = data_buff;
        next_sample_out = sample_out;
        if (nss_fall)
            next_state = IDLE;
        else begin
            case(state)
            RESET:
                next_state = INIT1;
            INIT1:
                next_state = INIT_WAIT1;
            INIT_WAIT1:
                next_state = modwait ? INIT_WAIT1 : INIT2;
            INIT2:
                next_state = INIT_WAIT2;
            INIT_WAIT2:
                next_state = modwait ? INIT_WAIT2 : INIT3;
            INIT3:
                next_state = INIT_WAIT3;
            INIT_WAIT3:
                next_state = modwait ? INIT_WAIT3 : INIT4;
            INIT4:
                next_state = INIT_WAIT4;
            INIT_WAIT4:
                next_state = modwait ? INIT_WAIT4 : IDLE;
            IDLE:
                next_state = rise_edge ? RECV : IDLE; 
            RECV:
                next_state = complete ? WAIT : RECV;
            WAIT:
                next_state = fall_edge ? (mode ? LOAD : LOAD_DATA) : WAIT;
            LOAD: begin
                next_data_buff = sample_in;
                next_sample_out = data_buff;
                next_state = IDLE;
            end
            LOAD_DATA:
                next_state = WAIT1;
            WAIT1:
                next_state = WAIT2;
            WAIT2:
                next_state = WAIT3;
            WAIT3:
                next_state = modwait ? WAIT3 : SEND_DATA;
            SEND_DATA: begin
                next_sample_out = fir_out;
                next_state = IDLE;
            end
            default:
                next_state = IDLE;
            endcase
        end

        load = state == LOAD || state == SEND_DATA;
        data_ready = state == LOAD_DATA || WAIT1 || WAIT2;
        load_coeff = state == INIT1 || state == INIT2 || state == INIT3 || state == INIT4;

        debug[0] = data_ready;
        debug[1] = err;

        case(state)
        INIT1:
            coeff = 16'h2000; // 0.25
        INIT_WAIT1:
            coeff = 16'h2000; // 0.25
        INIT2:
            coeff = 16'h8000; // 1.0
        INIT_WAIT2:
            coeff = 16'h8000; // 1.0
        INIT3:
            coeff = 16'h8000; // 1.0
        INIT_WAIT3:
            coeff = 16'h8000; // 1.0
        INIT4:
            coeff = 16'h2000; // 0.25
        INIT_WAIT4:
            coeff = 16'h2000; // 0.25
        default:
            coeff = 16'h8000; // 1.0
        endcase
    end

endmodule