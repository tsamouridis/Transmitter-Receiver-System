`timescale 1ns / 1ps

`include "decoder.v"

module decoder_tb;

reg[7:0] data_in;
wire[7:0] data_out;

decoder decoder_test(.data_in(data_in), .data_out(data_out));

initial begin
    #10;
    data_in = 8'b0110_1100;
    #100;
    data_in = 8'b1000_0100;
    #100;

    $dumpfile("dump.vcd"); $dumpvars;
    #100 $finish;

end    
endmodule