`timescale 1ns / 1ps

module baud_controller_tb;

reg give_clk,give_reset;
reg [2:0] give_baud_select;
  
wire sample_ENABLE;

baud_controller baud_controller_test(.reset(give_reset), .clk(give_clk), .baud_select(give_baud_select), .sample_ENABLE(sample_ENABLE));

initial begin

	give_clk = 0; // our clock is initialy set to 0
	give_reset = 1; // our reset signal is initialy set to 1

	#400; // after 100 timing units, i.e. ns
					
	give_reset = 0; // set reset signal to 0
			
	#20000 $finish;	 // after 10000 timing units, i.e. ns, finish our simulation
end
  
initial begin
  $dumpfile("dump.vcd"); $dumpvars;
end  
	
always #10 give_clk = ~ give_clk; // create our clock, with a period of 20ns

always@(posedge give_clk)
begin
  
  give_baud_select= 3'b111;
  #5230 give_baud_select= 3'b110;
  #5230;
end

  
endmodule
