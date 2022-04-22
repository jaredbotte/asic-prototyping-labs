// This file contains the VGA timing implementation. It will allow the screen to recognize the FPGA.
// No color data is provided to the screen in this file.
// Jared Botte
// jbotte@purdue.edu
// February 18th, 2022

module vga_timing
(
    input logic clk,
    input logic n_rst,
    output logic h_sync,
    output logic v_sync,
    output logic [9:0] hPix,
    output logic [9:0] vPix,
    output logic n_blank,
    output logic n_sync,
    output logic vga_clk,
    output logic frame_end
);

    logic [9:0] h_count, v_count;
    logic [1:0] clk_div_cnt;
    logic line_end;

    // Clock divider because we need a 25 MHz clock for VGA
    flex_counter #(.NUM_CNT_BITS(2)) CLK_DIVIDER (.clk(clk), .n_rst(n_rst), .clear(1'b0), .count_enable(1'b1), .rollover_val(2'd2), .count_out(clk_div_cnt));

    // Horizontal counter to keep track of xpos
    flex_counter #(.NUM_CNT_BITS(10)) HORIZONTAL_COUNTER (.clk(clk), .n_rst(n_rst), .clear(frame_end), .count_enable(vga_clk), .rollover_val('d800), .count_out(h_count), .rollover_flag(line_end));
    // Vertical counter to keep track of ypos
    flex_counter #(.NUM_CNT_BITS(10)) VERTICAL_COUNTER (.clk(clk), .n_rst(n_rst), .clear(frame_end), .count_enable(line_end & vga_clk), .rollover_val('d525), .count_out(v_count), .rollover_flag(frame_end));

    // HORIZONTAL NUMBERS:
    // [1 - 16] Front Porch [17 - 112] Sync Pulse [113 - 160] Back Porch [161 - 800] Visible Area
    // VERTICAL NUMBERS:
    // [1 - 10] Front Porch [11 - 12] Sync Pulse [13 - 45] Back Porch [46 - 525] Visible Area

    always_comb 
    begin
        vga_clk = clk_div_cnt == 1;
        n_blank = ~(h_count <= 160 || v_count <= 45);
        h_sync = ~(h_count > 16 && h_count <= 112);
        v_sync = ~(v_count > 10 && v_count <= 12);
        n_sync = 1'b0;

        // This should be used to get the current (x,y) of the pixel. Will be all 1s if in non-visible area.
        hPix = h_count < 159 || h_count >= 798 ? '1 : h_count - 159; // This should align the visible area to 0 - 640 Horizontally. 2 clocks off due to DAC pipeline.
        vPix = v_count < 46 ? '1 : v_count - 46; // This should align the visible area to 0 - 480 Vertically
    end

endmodule