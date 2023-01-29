`timescale 1ns / 1ps
`include "register.v"

module register_no_error_tb;

reg reset;
reg [7:0] data_in; 
reg valid;
reg PERROR;
reg FERROR;
wire[15:0] out;

register register_test(.reset(reset), .data_in(data_in), .valid(valid), .PERROR(PERROR), .FERROR(FERROR), .out(out));

initial begin
	reset = 1; // our reset signal is initialy set to 1
    valid = 1'b0;
    PERROR = 1'b0;
    FERROR = 1'b0;  

	#400; // after 100 timing units, i.e. ns
	reset = 0; // set reset signal to 0	
    data_in = 8'b1001101;   

    #10;
    valid = 1'b1;

    #10;
    valid = 1'b0;

    #10;
    data_in = 8'b11100011;
    
	#10;
    valid = 1'b1;
    
    #10 valid = 1'b0;
end

endmodule
