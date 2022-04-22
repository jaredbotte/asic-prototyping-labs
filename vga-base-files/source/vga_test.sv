// A file to map and test the VGA files
// Jared Botte
// jbotte@purdue.edu
// February 18, 2022

module vga_test
(
    input logic CLOCK_50,
    input logic [0:0]KEY,
    output logic VGA_HS,
    output logic VGA_VS,
    output logic VGA_BLANK_N,
    output logic VGA_SYNC_N,
    output logic VGA_CLK,
    output logic [7:0] VGA_R,
    output logic [7:0] VGA_B,
    output logic [7:0] VGA_G
);

    logic [9:0] hPix, vPix; // (hPix, vPix) is the current pixel to be sending to the DAC. All 1's indicates blanking.
    logic frame_end;

    vga_timing TIMING (.clk(CLOCK_50), .n_rst(KEY[0]), .h_sync(VGA_HS), .v_sync(VGA_VS), .n_blank(VGA_BLANK_N), .vga_clk(VGA_CLK), .n_sync(VGA_SYNC_N), .hPix(hPix), .vPix(vPix));

    assign VGA_R = 8'h37;
    assign VGA_G = 8'hC8;
    assign VGA_B = 8'h97;

    // next_color = ((end - start) / frame_width) * curr_frame + start;

endmodule