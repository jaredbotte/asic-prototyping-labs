// $Id: $
// File name:   rcv_block.sv
// Created:     2/16/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: UART RX implementation

module rcv_block
(
    input logic clk,
    input logic n_rst,
    input logic serial_in,
    input logic data_read,
    output logic [7:0] rx_data,
    output logic data_ready,
    output logic overrun_error,
    output logic framing_error,
    output logic debug
);

    logic [7:0] packet_data;
    logic stop_bit, shift_strobe, new_packet_detected, packet_done, enable_timer, sbc_clear, sbc_enable, load_buffer;

    // Shift strobe comes from timing controller
    sr_9bit SHIFT_REG (.clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe), .serial_in(serial_in), .packet_data(packet_data), .stop_bit(stop_bit));

    start_bit_det START_DET (.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .new_packet_detected(new_packet_detected));

    // sbc_enable comes from RCU, stop_bit comes from shift register, sbc_clear comes from RCU
    stop_bit_chk STOP_BIT_CHECKER (.clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .stop_bit(stop_bit), .framing_error(framing_error));

    // load_buffer comes from RCU, packet_data comes from shift register
    rx_data_buff RX_DATA_BUF (.clk(clk), .n_rst(n_rst), .load_buffer(load_buffer), .packet_data(packet_data), .data_read(data_read), .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error));

    // enable_timer comes from RCU
    timer TIMING_CONT (.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), .shift_strobe(shift_strobe), .packet_done(packet_done));

    rcu RCU (.clk(clk), .n_rst(n_rst), .new_packet_detected(new_packet_detected), .packet_done(packet_done), .framing_error(framing_error), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), .enable_timer(enable_timer));

endmodule