`timescale 1ns / 1ps

module encoder(char1, char2, out_char1, out_char2);
	input [3:0] char1, char2; 
	output [3:0] out_char1, out_char2; 

	reg [3:0] out_char1, out_char1;
	
	assign out_char1 = char1+1;
    assign out_char2 = char2+1;
endmodule