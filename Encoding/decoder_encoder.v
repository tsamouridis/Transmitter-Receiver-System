// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps

`include "encoder.v"
`include "decoder.v"
 
// Decoder-encoder system
module decoder_encoder(data_in, data_out);

input [7:0] data_in;
output [7:0] data_out;

wire [7:0] data_out;

// internal nets
wire[7:0] data_encoded;


// Modules' instantiation
encoder encoder_instance(.data_in(data_in), .data_out(data_encoded));
decoder decoder_instance(.data_in(data_encoded), .data_out(data_out));


endmodule