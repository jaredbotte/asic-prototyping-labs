// Code that combines the alpha display and rcv_block to recieve 1 character
// Jared Botte
// jbotte@purdue.edu
// March 3, 2022

module single_char_receive
(
    input logic CLOCK_50,
    input logic [0:0]KEY,
    input logic UART_RXD,
    input logic UART_RTS,
    output logic UART_TXD,
    output logic UART_CTS,
    output logic [1:0]LEDR,
    output logic [6:0]HEX0
);

    logic [7:0] rx_data, disp_data;
    wire data_ready, data_read;

    rcv_block UART (
        .clk(CLOCK_50), 
        .n_rst(KEY[0]), 
        .serial_in(UART_RXD),
        .data_read(data_read),
        .rx_data(rx_data),
        .data_ready(data_ready),
        .overrun_error(LEDR[0]),
        .framing_error(LEDR[1]),
        );

    alpha_display D0 (.ascii(disp_data), .disp(HEX0));

    always_ff @ (posedge data_ready, negedge KEY[0])
    begin
        if (KEY[0] == 1'b0) begin
            disp_data <= 8'h30;
        end else begin
            disp_data <= rx_data;
        end
    end

    always_comb begin : comb_logic
        data_read = disp_data == rx_data;
        UART_CTS = 1'b0;
        UART_TXD = 1'b1;
    end

endmodule