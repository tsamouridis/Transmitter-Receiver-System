// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps

// Encoder implementing a simple encoding
// task by adding 1 to each of the
// two 4-bit-characters that are given as
// input of 8 bit
module encoder(data_in, data_out);
	input[7:0] data_in;
	output[7:0] data_out;

	wire [3:0] char1, char2; 
	wire [3:0] out_char1, out_char2; 
	wire [7:0] data_out;
	
	assign char1 = data_in[3:0];
	assign char2 = data_in[7:4];
	assign out_char1 = char1 + 1'b1;
    assign out_char2 = char2 + 1'b1;

	assign data_out[3:0] = out_char1;
	assign data_out[7:4] = out_char2; 
endmodule