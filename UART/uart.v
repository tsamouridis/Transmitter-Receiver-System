// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps

`include "uart_receiver.v"
`include "uart_transmitter.v"
`include "FourDigitLEDdriver.v"
`include "register.v"

//! maybe 2 reset as input?
// Uart-LED-displays system implementation 
module uart(clk1, clk2, reset, baud_select,
                    Rx_EN, Tx_EN, Tx_WR, Tx_DATA, Tx_BUSY,
                    AN0, AN1, AN2, AN3,
                    a,b,c,d,e,f,g,dp);


input clk1, clk2, reset, Rx_EN, Tx_EN, Tx_WR;
input [2:0] baud_select;
input [7:0] Tx_DATA;

output Tx_BUSY;
output AN0, AN1, AN2, AN3;
output a, b, c, d, e, f, g, dp;

wire Tx_BUSY, AN0, AN1, AN2, AN3;
wire a, b, c, d, e, f, g, dp;

// internal nets
wire TxD;
wire Rx_VALID, Rx_FERROR, Rx_PERROR;
wire [7:0] Rx_DATA;
wire [15:0] signal_to_display;

// Modules' instantiation
uart_transmitter transmitter_instance(.reset(reset), .clk(clk1), .Tx_DATA(Tx_DATA), .baud_select(baud_select),
                                     .Tx_WR(Tx_WR),.Tx_EN(Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));

uart_receiver receiver_instance(.reset(reset), .clk(clk2), .Rx_DATA(Rx_DATA), .baud_select(baud_select),
                                .RX_EN(Rx_EN), .RxD(TxD), .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), 
                                .Rx_VALID(Rx_VALID));
register register_instance(.reset(reset), .data_in(Rx_DATA), .valid(Rx_VALID), .PERROR(Rx_PERROR), .FERROR(Rx_FERROR), .out(signal_to_display));

FourDigitLEDdriver LEDdriver_instance(.reset(reset), .clk(clk2), .signal_to_display(signal_to_display), .an3(AN3), .an2(AN2), .an1(AN1),
                                      .an0(AN0), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

endmodule