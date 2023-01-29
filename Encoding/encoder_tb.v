`timescale 1ns / 1ps

`include "encoder.v"

module encoder_tb;

reg[7:0] data_in;
wire[7:0] data_out;

encoder encoder_test(.data_in(data_in), .data_out(data_out));

initial begin
    #10;
    data_in = 8'b01011011;
    #100;
    data_in = 8'b01110011;
    #100;
	

    $dumpfile("dump.vcd"); $dumpvars;
    #100 $finish;
end    
endmodule
