// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps

// Testbench for the FourDigitLEDdriver
module driver_tb;

reg give_clk, give_reset;
reg [15:0] give_signal_to_display;
  
wire an3, an2, an1, an0;
wire a, b, c, d, e, f, g, dp;

FourDigitLEDdriver driver_test(.reset(give_reset), .clk(give_clk), .signal_to_display(give_signal_to_display), .an3(an3), .an2(an2), .an1(an1), .an0(an0), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

initial begin

	give_clk = 0; // clock is initialy set to 0
	give_reset = 1; // reset signal is initialy set to 1

	#400; 
					
	give_reset = 0; // set reset signal to 0
			
	#20000 $finish;	 // after 20000 timing units, i.e. ns, finish our simulation

  $dumpfile("dump.vcd"); $dumpvars;
end  
	
always #10 give_clk = ~ give_clk; // clk with period of 20ns

always@(posedge give_clk)
begin
  
  give_signal_to_display = 16'b1010_0001_1001_0100;
  #5230 give_signal_to_display = 16'b1100_1100_0001_0000;
  #5230;
//   #6130 give_signal_to_display = 16'b1010_1100_0011_0010;
//   #6130 give_signal_to_display = 16'b1011_1011_1011_1011;
//   #6130;
end

  
endmodule
