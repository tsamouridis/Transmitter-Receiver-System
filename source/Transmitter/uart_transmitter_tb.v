// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps

// Testbench of UART transmitter
module uart_transmitter_tb;

reg give_clk, give_reset;
reg [7:0] give_Tx_DATA;
reg [2:0]give_baud_select;
reg give_Tx_EN;
reg give_Tx_WR;
 
wire TxD;
wire Tx_BUSY;

uart_transmitter transmitter_test (.reset(give_reset), .clk(give_clk), .Tx_DATA(give_Tx_DATA), .baud_select(give_baud_select), .Tx_WR(give_Tx_WR), .Tx_EN(give_Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));

initial begin
    give_clk = 0; 
    give_reset = 1;

    #400; 

    give_reset = 0; 


    $dumpfile("dump.vcd"); $dumpvars;
    give_Tx_EN = 1'b1;
    give_baud_select = 3'b111;

    give_Tx_DATA = 8'b00010111;
    #500 give_Tx_WR = 1'b1;
end  

always #10 give_clk = ~ give_clk; 
 
endmodule

