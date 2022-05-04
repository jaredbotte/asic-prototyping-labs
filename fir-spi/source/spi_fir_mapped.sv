// Mapped wrapper file of spi fir
// Jared Botte
// jbotte@purdue.edu
// May 1st, 2022

module spi_fir_mapped (
    input logic CLOCK_50,
    input logic [0:0] KEY,
    input logic [0:0] SW,
    inout logic [5:0] GPIO
);
    
    spi_fir SPI_FIR (
        .clk(CLOCK_50),
        .n_rst(KEY[0]),
        .mode(SW[0]),
        .sck(GPIO[0]),
        .mosi(GPIO[1]),
        .miso(GPIO[2]),
        .nss(GPIO[3]),
        .debug({GPIO[4], GPIO[5]})
    );

endmodule