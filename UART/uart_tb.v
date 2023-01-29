// module uart_system(clk1, clk2, reset, baud_select,
//                     Rx_EN, Tx_EN, Tx_WR, Tx_DATA, Tx_BUSY
//                     AN0, AN1, AN2, AN3,
//                     a,b,c,d,e,f,g,dp);

`timescale 1ns / 1ps

module uart_system_tb;

reg give_clk1, give_clk2, give_reset;
reg [2:0] give_baud_select; 

reg give_Rx_EN, give_Tx_EN, give_Tx_WR;   
reg [7:0] give_Tx_DATA;

wire Tx_BUSY;
wire an0, an1, an2, an3;
wire a, b, c, d, e, f, g, dp;

uart_system system_tb(.clk1(give_clk1), .clk2(give_clk2), .reset(give_reset), .baud_select(give_baud_select),
                    .Rx_EN(give_Rx_EN), .Tx_EN(give_Tx_EN), .Tx_WR(give_Tx_WR), .Tx_DATA(give_Tx_DATA), 
                    .Tx_BUSY(Tx_BUSY), .AN0(an0), .AN1(an1), .AN2(an2), .AN3(an3),
                    .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

initial begin

	give_clk1 = 0;
	give_clk2 = 0;
	give_reset = 1;
    give_baud_select = 3'b111;
    give_Rx_EN = 1'b1;
    give_Tx_EN = 1'b1;
    give_Tx_WR = 1'b0;

	#100;		
	give_reset = 0; // set reset signal to 0

    //! add the rest
    #100;
    give_Tx_DATA = 8'b10101010;
    #200;
    give_Tx_WR = 1'b1;

    #1000;
    give_Tx_WR = 1'b0;

    #110160;
    give_Tx_DATA = 8'b01101000;
    give_Tx_WR = 1'b1;


	$dumpfile("dump.vcd"); $dumpvars;
end  
	
always #10 give_clk1 = ~ give_clk1; // create our clock, with a period of 20ns
always #10 give_clk2 = ~ give_clk2; // create our clock, with a period of 20ns

endmodule
