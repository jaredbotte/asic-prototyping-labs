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
    output logic shift,
    output logic [7:0] buttons
);
    
    logic [19:0] system_count;
    logic [10:0] pulse_length_count;
    logic [10:0] shift_reg_count;
    logic [7:0] next_buttons;
    logic pulse_en;

    flex_stp_sr #(.NUM_BITS(8), .SHIFT_MSB(1'b1)) SHIFT_REGISTER (.clk(shift), .n_rst(n_rst), .shift_enable(pulse_en), .serial_in(data), .parallel_out(next_buttons));

    flex_counter #(.NUM_CNT_BITS(20)) SYSTEM_COUNTER (.clk(clk), .n_rst(n_rst), .clear(1'b0), .count_enable(1'b1), .rollover_val(20'd833333), .count_out(system_count));

    flex_counter #(.NUM_CNT_BITS(10)) PULSE_LENGTH_COUNTER (.clk(clk), .n_rst(n_rst), .clear(~latch), .count_enable(pulse_en), .rollover_val(10'd600), .count_out(pulse_length_count));

    flex_counter #(.NUM_CNT_BITS(10)) SHIFT_REG_COUNTER (.clk(clk), .n_rst(n_rst), .clear(~latch), .count_enable(pulse_en), .rollover_val(10'd600), .count_out(shift_reg_count));

    always_comb begin : controller_logic
        latch = ~(system_count < 601);
        pulse = ~(pulse_length_count < 301);
        pulse_en = system_count < 5400;
        shift = (shift_reg_count > 150) && (shift_reg_count < 451);
    end

    always_ff @ (negedge pulse_en, negedge n_rst)
    begin
        if(n_rst == 1'b0)
            buttons <= '1;
        else
            buttons <= next_buttons;
    end

endmodule