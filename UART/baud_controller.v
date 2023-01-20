`timescale 1ns / 1ps

module baud_controller(reset, clk, baud_select, sample_ENABLE);
input clk, reset; 
input [2:0] baud_select; 
output sample_ENABLE;

reg [13:0] counter =0;
reg sample_ENABLE;
reg [13:0] reverse_sample_ENABLE = 13'd0;

always @ (baud_select)
begin
    case(baud_select)
        3'b000 : reverse_sample_ENABLE = 14'd10417;
        3'b001 : reverse_sample_ENABLE = 14'd2604;
        3'b010 : reverse_sample_ENABLE = 14'd651;
        3'b011 : reverse_sample_ENABLE = 14'd326;
        3'b100 : reverse_sample_ENABLE = 14'd163;
        3'b101 : reverse_sample_ENABLE = 14'd81;
        3'b110 : reverse_sample_ENABLE = 14'd54;
        3'b111 : reverse_sample_ENABLE = 14'd27;
    endcase  
end

// counter counts from 1 till reverse_sample_ENABLE 
always @ (posedge clk or posedge reset)
begin
	if (reset)
	begin
        sample_ENABLE = 1'b0;
		counter = 14'd0;
	end	
	else 
	begin
		if (counter == reverse_sample_ENABLE)
		begin
			counter = 14'd0;
            sample_ENABLE = ~ sample_ENABLE;
		end
		else
		begin
			counter = counter + 1;
		end
	end
end
endmodule