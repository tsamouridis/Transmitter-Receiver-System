// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps

// 4 to 7 decoder used to represent the input in a 7 segment LED display
module LEDdecoder(char, LED);
input [3:0] char; // input 4-bit coded character
output [6:0] LED; // output 7-bit (a, b, c, d, e, f, g) signal

reg [6:0] LED;

always@(char)
begin
	case(char)
		4'b0000:LED = 7'b000_000_1;	// 0
		4'b0001:LED = 7'b100_111_1;	// 1
		4'b0010:LED = 7'b001_001_0;	// 2
		4'b0011:LED = 7'b000_011_0;	// 3
		4'b0100:LED = 7'b100_110_0;	// 4
		4'b0101:LED = 7'b010_010_0;	// 5
		4'b0110:LED = 7'b010_000_0;	// 6
		4'b0111:LED = 7'b000_111_1;	// 7
		4'b1000:LED = 7'b000_000_0;	// 8
		4'b1001:LED = 7'b000_010_0;	// 9
		4'b1010:LED = 7'b111_111_0;	// -
		4'b1011:LED = 7'b011_100_0;	// F
		4'b1100:LED = 7'b111_111_1;	// [space]
		default:LED = 7'b111_111_1; // default -> [space]
	endcase
end
endmodule