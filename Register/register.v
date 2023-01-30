// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps

// Special Register for the parallelization of input of LED driver.
// The register modules checks if the input is considered as valid by the receiver
// and outputs only valid data
module register(reset, data_in, valid, PERROR, FERROR, out);

input[7:0] data_in;
input reset, valid, PERROR, FERROR;
output [15:0] out;

reg[15:0] out;
reg[7:0] temp1;
reg[2:0] counter;
reg error_detected;

// output when error occurs
parameter FFFF = 16'b1100_1100_1100_1100;
  
always @ (posedge valid) begin 
	if(counter == 1) 
		temp1 <= data_in;
	else begin
		if (error_detected == 1'b0) begin
			out[7:0] <= temp1;
			out[15:8] <= data_in;
		end
		else begin
			out <= FFFF;
			error_detected <= 1'b0;
		end
	end
end

always @ (posedge PERROR or posedge FERROR) begin 
	error_detected = 1'b1;
end

// counter
always@(posedge reset or posedge valid or posedge PERROR or posedge FERROR)
begin
	if (reset) begin
		error_detected = 1'b0;
		counter = 0;
	end	
  
	else begin
		if (counter == 1 && valid == 1'b1)
		    counter = 0;
		else
			counter = counter + 1;
	end
end

endmodule