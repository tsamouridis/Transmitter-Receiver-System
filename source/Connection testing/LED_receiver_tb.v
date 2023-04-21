// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps

// Led-Receiver testbench
module LED_receiver_tb;

reg clk, reset;
reg [2:0] baud_select; 
reg Rx_EN, RxD;

wire a,b,c,d,e,f,g,dp;
wire an0, an1, an2, an3;

LED_receiver LED_receiver_test(.clk(clk), .reset(reset), .baud_select(baud_select),
                    .Rx_EN(Rx_EN), .RxD(RxD),
                    .AN0(an0), .AN1(an1), .AN2(an2), .AN3(an3),
                    .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));


initial begin

	clk = 1'b0; // our clock is initialy set to 0
	RxD = 1'b1;
	reset = 1'b1; // our reset signal is initialy set to 1
    Rx_EN = 1'b1;
    baud_select = 3'b111;
	#400;				
	reset = 1'b0; // set reset signal to 0
			
	$dumpfile("dump.vcd"); $dumpvars;

end  
	
always #10 clk = ~ clk; // create our clock, with a period of 20ns
  
always@(posedge clk) begin
	////////////////////////////////////////////////
	// Normal functionality
	//           [start] [DATA{LSB->MSB}] [parity] [stop]
	// message =    0    101 000 01     1       1
	////////////////////////////////////////////////
	#5710;
	RxD = 0; #8960; //start

	// DATA = 1000 0101
	RxD = 0; #8960; //D0
	RxD = 0; #8960; //D1
	RxD = 1; #8960; //D2
	RxD = 0; #8960; //D3
	RxD = 1; #8960; //D4
	RxD = 0; #8960; //D5
	RxD = 0; #8960; //D6
	RxD = 1; #8960; //D7

	RxD = 1; #8960; //parity (right)
	RxD = 1; #8960; //stop
    RxD = 1; #17920; //post stop period

    // second data 1100 0100
    RxD = 0; #8960; //start

    RxD = 1; #8960; //D0   
	RxD = 0; #8960; //D1
	RxD = 0; #8960; //D2
	RxD = 0; #8960; //D3
	RxD = 0; #8960; //D4
	RxD = 1; #8960; //D5
	RxD = 0; #8960; //D6
	RxD = 1; #8960; //D7

	RxD = 1; #8960; //parity (right)
	RxD = 1; #8960; //stop
    RxD = 1; #17920; //post stop period
  
	#200000;
	$finish;
	 
end

endmodule
