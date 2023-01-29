`timescale 1ns / 1ps

`include "uart_receiver.v"
`include "uart_transmitter.v"

module transmitter_receiver(clk1, clk2, reset1, reset2, baud_select,
                    Rx_EN, Tx_EN, Tx_WR, Tx_DATA, Tx_BUSY, Rx_VALID,
                    Rx_FERROR, Rx_PERROR, Rx_DATA);


input clk1, clk2, reset1, reset2, Rx_EN, Tx_EN, Tx_WR;
input [2:0] baud_select;
input [7:0] Tx_DATA;

output Tx_BUSY;
output Rx_VALID, Rx_FERROR, Rx_PERROR;
output [7:0] Rx_DATA;

// internal nets
wire RxD;

// Modules' instantiation
uart_transmitter transmitter_instance(.reset(reset1), .clk(clk1), .Tx_DATA(Tx_DATA), .baud_select(baud_select),
                                     .Tx_WR(Tx_WR),.Tx_EN(Tx_EN), .TxD(RxD), .Tx_BUSY(Tx_BUSY));

uart_receiver receiver_instance(.reset(reset2), .clk(clk2), .Rx_DATA(Rx_DATA), .baud_select(baud_select),
                                .RX_EN(Rx_EN), .RxD(RxD), .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), 
                                .Rx_VALID(Rx_VALID));
                                
endmodule