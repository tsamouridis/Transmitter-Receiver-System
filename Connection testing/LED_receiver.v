// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps

`include "uart_receiver.v"
`include "FourDigitLEDdriver.v"
`include "register.v"

// Led-Receiver system
module LED_receiver(clk, reset, baud_select,
                    Rx_EN, RxD,
                    AN0, AN1, AN2, AN3,
                    a,b,c,d,e,f,g,dp);


input clk, reset, Rx_EN;
input [2:0] baud_select;
input RxD;

output AN0, AN1, AN2, AN3;
output a, b, c, d, e, f, g, dp;

wire AN0, AN1, AN2, AN3;
wire a, b, c, d, e, f, g, dp;

// internal nets
wire Rx_VALID, Rx_FERROR, Rx_PERROR;
wire [7:0] Rx_DATA;
wire [15:0] signal_to_display;

// Modules' instantiation
uart_receiver receiver_instance(.reset(reset), .clk(clk), .Rx_DATA(Rx_DATA), .baud_select(baud_select),
                                .RX_EN(Rx_EN), .RxD(RxD), .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), 
                                .Rx_VALID(Rx_VALID));

register register_instance(.reset(reset), .data_in(Rx_DATA), .valid(Rx_VALID), .PERROR(Rx_PERROR), .FERROR(Rx_FERROR), .out(signal_to_display));

FourDigitLEDdriver LEDdriver_instance(.reset(reset), .clk(clk), .signal_to_display(signal_to_display), .an3(AN3), .an2(AN2), .an1(AN1),
                                      .an0(AN0), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

endmodule