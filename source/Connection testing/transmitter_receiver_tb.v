// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps
`include "transmitter_receiver.v"

//testbench for the UART receiver
module transmitter_receiver_tb;

reg clk1,clk2, reset1,reset2;
reg [7:0] give_Tx_DATA;
reg [2:0]baud_select;
reg Tx_EN, Rx_EN, Tx_WR;
reg [7:0] Tx_DATA;
 
wire Tx_BUSY, Rx_VALID, Rx_FERROR,Rx_PERROR;
wire [7:0] Rx_DATA;

transmitter_receiver transmitter_receiver_test (.clk1(clk1),.clk2(clk2), .reset1(reset1), .reset2(reset2), .baud_select(baud_select),
                    .Rx_EN(Rx_EN), .Tx_EN(Tx_EN), .Tx_WR(Tx_WR), .Tx_DATA(Tx_DATA), .Tx_BUSY(Tx_BUSY), .Rx_VALID(Rx_VALID),
                    .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_DATA(Rx_DATA));

initial begin
    clk1 = 1;
	clk2 = 0;
	reset1 = 1;
    reset2 = 1;
    baud_select = 3'b111;
    Rx_EN = 1'b1;
    Tx_EN = 1'b1;
    if(Tx_BUSY == 1'b0)
        Tx_WR = 1'b1;  
    else
        Tx_WR = 1'b0;  

	#100;		
	reset1 = 0; 
    reset2 = 0;

    #100;
    Tx_DATA = 8'b10010100;

    #200;
    if(Tx_BUSY == 1'b0)
        Tx_WR = 1'b1;  
    else
        Tx_WR = 1'b0;  

    #1000;
    Tx_WR = 1'b0;

    #110160;
    Tx_DATA = 8'b10100001;
    
    #200;
    if(Tx_BUSY == 1'b0)
        Tx_WR = 1'b1;  
    else
        Tx_WR = 1'b0;  

	$dumpfile("dump.vcd"); $dumpvars;
    // #150000 $finish;
     
end  

always #10 clk1 = ~ clk1; // create our clock, with a period of 20ns
always #10 clk2 = ~ clk2;

 
endmodule

