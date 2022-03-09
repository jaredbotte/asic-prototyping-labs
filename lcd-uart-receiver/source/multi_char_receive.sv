// Code that combines the alpha display and rcv_block to recieve multiple characters
// Jared Botte
// jbotte@purdue.edu
// March 9, 2022

module multi_char_receive
(
    input logic CLOCK_50,
    input logic [0:0]KEY,
    input logic UART_RXD,
    input logic UART_RTS,
    output logic UART_TXD,
    output logic UART_CTS,
    output logic [1:0]LEDR,
    output logic [6:0]HEX0,
    output logic [6:0]HEX1,
    output logic [6:0]HEX2,
    output logic [6:0]HEX3,
    output logic [6:0]HEX4,
    output logic [6:0]HEX5,
    output logic [6:0]HEX6,
    output logic [6:0]HEX7
);

    logic [7:0] rx_data, data0, data1, data2, data3, data4, data5, data6, data7;
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

    alpha_display D0 (.ascii(data0), .disp(HEX0));
    alpha_display D1 (.ascii(data1), .disp(HEX1));
    alpha_display D2 (.ascii(data2), .disp(HEX2));
    alpha_display D3 (.ascii(data3), .disp(HEX3));
    alpha_display D4 (.ascii(data4), .disp(HEX4));
    alpha_display D5 (.ascii(data5), .disp(HEX5));
    alpha_display D6 (.ascii(data6), .disp(HEX6));
    alpha_display D7 (.ascii(data7), .disp(HEX7));

    always_ff @ (posedge data_ready, negedge KEY[0])
    begin
        if (KEY[0] == 1'b0) begin
            data0 <= '0;
            data1 <= '0;
            data2 <= '0;
            data3 <= '0;
            data4 <= '0;
            data5 <= '0;
            data6 <= '0;
            data7 <= '0;
        end else begin
            data7 <= data6;
            data6 <= data5;
            data5 <= data4;
            data4 <= data3;
            data3 <= data2;
            data2 <= data1;
            data1 <= data0;
            data0 <= rx_data;
        end
    end

    always_comb begin : comb_logic
        data_read = data0 == rx_data;
        UART_CTS = 1'b0;
        UART_TXD = 1'b1;
    end

endmodule