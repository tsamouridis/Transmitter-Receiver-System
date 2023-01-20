`timescale 1ns / 1ps

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

	give_clk = 0; // our clock is initialy set to 0
	give_reset = 1; // our reset signal is initialy set to 1

	#400; // after 100 timing units, i.e. ns
					
	give_reset = 0; // set reset signal to 0
			
	#200000 $finish;	 // after 10000 timing units, i.e. ns, finish our simulation
end
  
initial begin
	$dumpfile("dump.vcd"); $dumpvars;
	give_Tx_EN = 1'b1;
	give_baud_select = 3'b111;
	
	give_Tx_DATA = 8'b10011010;
    #100 give_Tx_WR = 1'b1;
end  
	
always #10 give_clk = ~ give_clk; // create our clock, with a period of 20ns

// always@(posedge give_clk)
// begin

// end

  
endmodule
