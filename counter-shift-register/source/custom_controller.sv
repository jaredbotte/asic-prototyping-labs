// A module to interface with a custom controller. NOT MAPPED.
// Jared Botte
// jbotte@purdue.edu
// February 7, 2022

module custom_controller
(
    input logic clk,
    input logic n_rst,
    input logic data,
    output logic latch,
    output logic pulse,
    //output logic debug,
    output logic [7:0] buttons
);
    parameter IDLE = 0, LATCHING = 1, READING = 2;

    reg [1:0]state; // The current state
    reg [1:0]next_state; // The next state
    reg [7:0]next_buttons; // The next buttons
    reg [7:0]data_out; // Current data from the shift register
    reg [5:0]pulse_clock; // The current count of the pulse clock
    reg next_latch; // The next latch line value
    reg next_pulse; // The next pulse line value
    reg latch_roll; // The end of the latch pulse. 12 µs
    reg poll_roll; // The end of the polling period. 60 Hz
    reg pulse_clock_roll; // The end of one pulse period. 12 µs
    reg pulse_finished; // The end of all pulses. 8 total pulses

    reg latch_clear;
    reg next_latch_clear;
    reg pulse_clock_clear;
    reg next_pulse_clock_clear;
    reg pulse_count_clear;
    reg next_pulse_count_clear;

    // Need clock divider for 60 Hz polling time. Divisor of 833,333. Requires a 20-bit counter.
    // Output of this clock divider will start latch pulse.
    flex_counter #(.NUM_CNT_BITS(20)) POLL_CNT (.clk(clk), .n_rst(n_rst), .clear(1'b0), .count_enable(1'b1), .rollover_val(20'd833333), .rollover_flag(poll_roll));
    // Need counter for latch signal. 50 Mhz = 0.2 µs. 12 µs = 60 pulses. Requires a 6-bit counter
    flex_counter #(.NUM_CNT_BITS(6)) LATCH_CNT (.clk(clk), .n_rst(n_rst), .clear(latch_clear), .count_enable(1'b1), .rollover_val(6'd60), .rollover_flag(latch_roll));
    // Need another counter to create clock for pulse. Also need to keep track of the number of pulses.
    flex_counter #(.NUM_CNT_BITS(6)) PULSE_CLOCK_CNT (.clk(clk), .n_rst(n_rst), .clear(pulse_clock_clear), .count_enable(1'b1), .rollover_val(6'd60), .rollover_flag(pulse_clock_roll), .count_out(pulse_clock));
    flex_counter #(.NUM_CNT_BITS(5)) PULSE_CNT (.clk(pulse_clock_roll), .n_rst(n_rst), .clear(pulse_count_clear), .count_enable(1'b1), .rollover_val(5'd8), .rollover_flag(pulse_finished));

    stp_nbit #(.BIT_WIDTH(8)) SHIFT_REG (.ser_in(data), .clk(~pulse_clock), .n_rst(n_rst), .par_out(data_out));

    always @ (posedge clk, negedge n_rst)
    begin
        if (n_rst == 1'b0) begin
            state <= IDLE;
            buttons <= '1;
            latch <= 1'b1;
            pulse <= 1'b0;
            latch_clear <= 1'b1;
            pulse_clock_clear <= 1'b1;
            pulse_count_clear <= 1'b1;
        end else begin
            latch <= next_latch;
            pulse <= next_pulse;
            state <= next_state;
            buttons <= next_buttons;
            latch_clear <= next_latch_clear;
            pulse_clock_clear <= next_pulse_clock_clear;
            pulse_count_clear <= next_pulse_count_clear;
        end
    end 

    always_comb
    begin
        next_latch = latch;
        next_buttons = buttons;
        next_pulse = pulse_clock <= 30 ? 1'b0 : 1'b1;
        next_latch_clear = latch_clear;
        next_pulse_clock_clear = pulse_clock_clear;
        next_pulse_count_clear = pulse_count_clear;

        case(state)
        IDLE:
            next_state = poll_roll ? LATCHING : IDLE;
        LATCHING:
            next_state = latch_roll ? READING : LATCHING;
        READING:
            next_state = pulse_finished ? IDLE : READING;
        default:
            // Bad situation... Guess we'll reset to IDLE.
            next_state = IDLE;
        endcase

        // Detect state changes
        if (next_state != state)
        begin
            case(next_state)
            LATCHING:
            begin
                next_latch = 1'b0;
                next_latch_clear = 1'b0;
            end
            READING:
            begin
                next_latch = 1'b1;
                next_latch_clear = 1'b0;
                next_pulse_clock_clear = 1'b0;
                next_pulse_count_clear = 1'b0;
            end
            IDLE:
            begin
                next_pulse_clock_clear = 1'b1;
                next_pulse_count_clear = 1'b1;
                // Put new data on buttons.
                next_buttons = data_out;
            end
            endcase
        end
    end
endmodule