// Input Synchronizer and Edge Detector for SPI
// Jared Botte
// jbotte@purdue.edu
// May 1st, 2022

// This module synchonizes the clock and mosi signals,
// and detects a rising edge of the clock signal.

module sync_edge
(
    input logic clk,
    input logic n_rst,
    input logic sck,
    input logic mosi,
    input logic nss,
    output logic nss_fall,
    output logic mosi_s,
    output logic rise_edge,
    output logic fall_edge
);

/*
---sck-->|FF|---last_sck-->|FF|---oldest_sck-->
--mosi-->|FF|--last_mosi-->|FF|--oldest_mosi-->
---nss-->|FF|---last_nss-->|FF|---oldest_nss-->
*/

    logic oldest_sck, last_sck, oldest_mosi, last_mosi, oldest_nss, last_nss;

    always_ff @ (posedge clk, negedge n_rst) begin
        if (n_rst == 1'b0) begin
            oldest_sck <= 1'b0;
            oldest_mosi <= 1'b0;
            oldest_nss <= 1'b0;
            last_sck <= 1'b0;
            last_mosi <= 1'b0;
            last_nss <= 1'b0;
        end else begin
            oldest_sck <= last_sck;
            last_sck <= sck;
            oldest_mosi <= last_mosi;
            last_mosi <= mosi;
            oldest_nss <= last_nss;
            last_nss <= nss;
        end
    end

    always_comb 
    begin: comb_logic
        rise_edge = last_sck & ~oldest_sck;
        fall_edge = ~last_sck & oldest_sck;
        nss_fall = ~last_nss & oldest_nss;
        mosi_s = oldest_mosi;
    end

endmodule