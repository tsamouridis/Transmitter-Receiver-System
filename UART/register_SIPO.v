`timescale 1ns / 1ps

module register_SIPO(clk, data_in, read, data_valid, out);

input clk, data_in, read, data_valid;
output[7:0] out;

reg[7:0] temp_storage;
reg temp_storage_index;
reg[7:0] out;
  
// fix temp_storage_index initialization
always @ (posedge clk) 
	begin 
      if(read)
         begin
           temp_storage[0] <= data_in;
           if(temp_storage_index == 7)
               temp_storage_index <= 0;
            else
               temp_storage_index <= temp_storage_index+1;
         end
      if(data_valid == 1'b1)
         out <= temp_storage;
	end
endmodule