`timescale 1ns / 1ps

module uart_receiver_tb;

reg give_clk, give_reset;
reg [7:0] give_Rx_DATA; 
reg [2:0] give_baud_select; 
reg give_Rx_EN;  
  
wire RxD;
wire Tx_BUSY, Rx_FERROR, Rx_PERROR, Rx_VALID;

uart_receiver receiver_test(.reset(give_reset), .clk(give_clk), .Rx_DATA(give_Rx_DATA), .baud_select(give_baud_select), .RX_EN(give_Rx_EN), .RxD(RxD), .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));

initial begin

	give_clk = 0; // our clock is initialy set to 0
	give_reset = 1; // our reset signal is initialy set to 1

	#400; // after 100 timing units, i.e. ns
					
	give_reset = 0; // set reset signal to 0
			
	#200000 $finish;	 // after 200000 timing units, i.e. ns, finish our simulation
end
  
initial begin
	$dumpfile("dump.vcd"); $dumpvars;
	give_Rx_EN = 1'b1;
	give_baud_select = 3'b111;
	
	give_Rx_DATA = 8'b10011010;
end  
	
always #10 give_clk = ~ give_clk; // create our clock, with a period of 20ns
  
endmodule
