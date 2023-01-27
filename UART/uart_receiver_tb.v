`timescale 1ns / 1ps

module uart_receiver_tb;

reg give_clk, give_reset;
reg [2:0] give_baud_select; 
reg give_Rx_EN;   
reg give_RxD;

wire [7:0] Rx_DATA; 
wire Rx_FERROR, Rx_PERROR, Rx_VALID;

reg transmitter_fake_clk;

uart_receiver receiver_test(.reset(give_reset),
						.clk(give_clk),
						.Rx_DATA(Rx_DATA),
						.baud_select(give_baud_select),
						.RX_EN(give_Rx_EN),
						.RxD(give_RxD),
						.Rx_FERROR(Rx_FERROR),
						.Rx_PERROR(Rx_PERROR),
						.Rx_VALID(Rx_VALID) );

initial begin

	give_clk = 0; // our clock is initialy set to 0
	transmitter_fake_clk = 1;
	give_RxD = 1'b1;
	give_reset = 1; // our reset signal is initialy set to 1

	#400; // after 100 timing units, i.e. ns
					
	give_reset = 0; // set reset signal to 0
			
	// #200000 $finish;	 // after 200000 timing units, i.e. ns, finish our simulation
end
  
initial begin
	$dumpfile("dump.vcd"); $dumpvars;
	give_Rx_EN = 1'b1;
	give_baud_select = 3'b111;
end  
	
always #10 give_clk = ~ give_clk; // create our clock, with a period of 20ns

always #280 transmitter_fake_clk = ~ transmitter_fake_clk; //!
  
always@(posedge give_clk) begin

	// From the following select the desired
	// functionality to check that module works properly 
	// Desired output: 10000_101 

	////////////////////////////////////////////////
	// Normal functionality
	//           [start] [DATA{LSB->MSB}] [parity] [stop]
	// message =    0    101 000 01     1       1
	////////////////////////////////////////////////
	#6000;
	give_RxD = 0; #560; //start

	// DATA = 101 000 01
	give_RxD = 1; #560; //D0
	give_RxD = 0; #560; //D1
	give_RxD = 1; #560; //D2
	give_RxD = 0; #560; //D3
	give_RxD = 0; #560; //D4
	give_RxD = 0; #560; //D5
	give_RxD = 0; #560; //D6
	give_RxD = 1; #560; //D7

	give_RxD = 1; #560; //parity (right)
	give_RxD = 1; #560; //stop

	// ///////////////////////////////////////////////
	// // Parity error 
	// //           [start] [  DATA  ] [parity] [stop]
	// // message =    0    101 000 01     0       1
	// ///////////////////////////////////////////////
	// #6000;
	// give_RxD = 0; #560; //start

	// // DATA = 101 000 01
	// give_RxD = 1; #560; //D0
	// give_RxD = 0; #560; //D1
	// give_RxD = 1; #560; //D2
	// give_RxD = 0; #560; //D3
	// give_RxD = 0; #560; //D4
	// give_RxD = 0; #560; //D5
	// give_RxD = 0; #560; //D6
	// give_RxD = 1; #560; //D7

	// give_RxD = 0; #560; //parity (false)
	// give_RxD = 1; #560; //stop

	// ///////////////////////////////////////////////
	// // Framing error error 
	// //           [start] [  DATA  ] [parity] [stop]
	// // message =    0    [1]01 000 01     0       1
	// //////////////////////////////////////////////
	// #6000;
	// give_RxD = 0; #560; //start

	// // DATA = 101 000 01
	// give_RxD = 1; #160; //D0
	// give_RxD = 0; #400; //noisy D0 

	// give_RxD = 0; #560; //D1
	// give_RxD = 1; #560; //D2
	// give_RxD = 0; #560; //D3
	// give_RxD = 0; #560; //D4
	// give_RxD = 0; #560; //D5
	// give_RxD = 0; #560; //D6
	// give_RxD = 1; #560; //D7

	// give_RxD = 1; #560; //parity (right)
	// give_RxD = 1; #560; //stop
	// ! when there is ferror there is perror too?
	 
end

endmodule
