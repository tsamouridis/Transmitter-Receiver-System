`timescale 1ns / 1ps

module register_SIPO_tb;

reg give_clk,give_data, give_read, give_data_valid;
wire[7:0] out;

register_SIPO register_test(.clk(give_clk), .data_in(give_data), .read(give_read), .data_valid(give_data_valid), .out(out));

initial begin
	give_data = 1'b1;
    give_read = 1'b0;
    give_data_valid = 1'b0;
  
	give_clk = 0; // our clock is initialy set to 0
			
	#20000 $finish;	 // after 10000 timing units, i.e. ns, finish our simulation
end
  
initial begin
  $dumpfile("dump.vcd"); $dumpvars;
end  
	
always #10 give_clk = ~ give_clk; // create our clock, with a period of 20ns

always@(posedge give_clk)
begin
  
  #40 give_data = 1'b1;
  #40 give_data = 1'b0;
  #40 give_data = 1'b1;
  
  #40 give_read = 1'b1;
  
  #20 give_data_valid = 1'b1;
end
endmodule
