`timescale 1ns / 1ps

// ! add ferror perror as input to give error output for the led

module register(reset, data_in, valid, out);

input[7:0] data_in;
input reset, valid;
output [15:0] out;

reg[15:0] out;
reg[7:0] temp1;
reg[2:0] counter;
  
// fix temp_storage_index initialization
always @ (posedge valid) begin 
      if(counter == 1) 
         temp1 <= data_in;
      else begin
         out[7:0] <= temp1;
         out[15:8] <= data_in;
      end
end


// counter
always@(posedge reset or posedge valid)
begin
	if (reset) begin
		counter = 0;
	end	
  
	else begin
		if (counter == 1)
		    counter = 0;
		else
			counter = counter + 1;
	end
end

endmodule