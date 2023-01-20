`timescale 1ns / 1ps

module baud_controller(reset, clk, baud_select, sample_ENABLE);
input clk, reset; 
input [2:0] baud_select; 
output sample_ENABLE;

reg [13:0] counter;
reg sample_ENABLE;
reg [13:0] reverse_sample_ENABLE = 4'd0; μ//! is it ok?

always @ (baud_select)
begin
    case(baud_select)
        3'b000 : reverse_sample_ENABLE = 14'd5208;
        3'b001 : reverse_sample_ENABLE = 14'd1302;
        3'b010 : reverse_sample_ENABLE = 14'd326;
        3'b011 : reverse_sample_ENABLE = 14'd163;
        3'b100 : reverse_sample_ENABLE = 14'd81;
        3'b101 : reverse_sample_ENABLE = 14'd41;
        3'b110 : reverse_sample_ENABLE = 14'd27;
        3'b111 : reverse_sample_ENABLE = 14'd14;
    endcase  
end

// counter counts from 1 till reverse_sample_ENABLE 
always @ (posedge clk or posedge reset)
begin
	if (reset)
	begin
        sample_ENABLE = 1'b0;
		counter = 14'd1;
	end	
	else 
	begin
		if (counter == reverse_sample_ENABLE)
		begin
			counter = 4'd1;
            sample_ENABLE = ~ sample_ENABLE;
		end
		else
		begin
			counter = counter + 1;
		end
	end
end
endmodule