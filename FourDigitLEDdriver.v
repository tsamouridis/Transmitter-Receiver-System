`timescale 1ns / 1ps
`include "LEDdecoder.sv"

module FourDigitLEDdriver(reset, clk, signal_to_display, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);

input [15:0] signal_to_display; 
output dp;
  
input clk, reset; // add more inputs if needed
output an3, an2, an1, an0; // our anodes
output a, b, c, d, e, f, g;	//	our signals

//		    a
//   	 ------
//    f |	   |  b
//	    |   g  |
//	  	 ------
//      |      |
//	  e |	   |  c
//	     ------      .dp
//			d

reg a,b,c,d,e,f,g,dp;
reg an0,an1,an2,an3;
wire [6:0] LED;

reg [3:0] char; // based on your received message, use this 4bit signal to drive our decoder
reg [3:0] counter; // counter to compute the time that the anodes will be active

//////////////////
//		FSM		//
//////////////////
reg [3:0] current_state, next_state;
  
parameter S0 = 4'b0000, 
          S1 = 4'b0001,
          S2 = 4'b0010,
          S3 = 4'b0011,
          S4 = 4'b0100,
          S5 = 4'b0101,
          S6 = 4'b0110,
          S7 = 4'b0111,
          S8 = 4'b1000,
          S9 = 4'b1001,
          S10 = 4'b1010,
          S11 = 4'b1011,
          S12 = 4'b1100,
          S13 = 4'b1101,
          S14 = 4'b1110,
          S15 = 4'b1111;
  
always @ (posedge clk or posedge reset) 
	begin: STATE_MEMORY 
      if (reset)
			current_state <= S11;
		else
		 	current_state <= next_state; 
	end

  always @ (current_state or posedge clk)
    begin: NEXT_STATE_LOGIC
        case (current_state)
            S0 : if(counter == 4'b0000)
                    next_state = S1;
                 else 
                    next_state = S0;
            S1 : if(counter == 4'b0000)
                    next_state = S2;
                 else 
                    next_state = S1;
            S2 : if(counter == 4'b0000)
                    next_state = S3;
                 else 
                    next_state = S2;   
            S3 : if(counter == 4'b0000)
                    next_state = S4;
                 else 
                    next_state = S3; 
            S4 : if(counter == 4'b0000)
                    next_state = S5;
                 else 
                    next_state = S4; 
            S5 : if(counter == 4'b0000)
                    next_state = S6;
                 else 
                    next_state = S5;
            S6 : if(counter == 4'b0000)
                    next_state = S7;
                 else 
                    next_state = S6;  
            S7 : if(counter == 4'b0000)
                    next_state = S8;
                 else 
                    next_state = S7; 
            S8 : if(counter == 4'b0000)
                    next_state = S9;
                 else 
                    next_state = S8;
            S9 : if(counter == 4'b0000)
                    next_state = S10;
                 else 
                    next_state = S9;
            S10 : if(counter == 4'b0000)
                    next_state = S11;
                 else 
                    next_state = S10;   
            S11 : if(counter == 4'b0000)
                    next_state = S12;
                 else 
                    next_state = S11; 
            S12 : if(counter == 4'b0000)
                    next_state = S13;
                 else 
                    next_state = S12;
            S13 : if(counter == 4'b0000)
                    next_state = S14;
                 else 
                    next_state = S13;
            S14 : if(counter == 4'b0000)
                    next_state = S15;
                 else 
                    next_state = S14;  
            S15 : if(counter == 4'b0000)
                    next_state = S0;
                 else 
                    next_state = S15;   
        endcase
    end

  always @ (current_state or posedge clk)
    begin: OUTPUT_LOGIC
        case (current_state)
            S0 : char = signal_to_display[11:8];
            S2 : begin
                    an3 = 1'b1;
                    an2 = 1'b0;
                    an1 = 1'b1;
                    an0 = 1'b1;
                 end   
            S4 : char = signal_to_display[7:4]; 
            S6 : begin
                    an3 = 1'b1;
                    an2 = 1'b1;
                    an1 = 1'b0;
                    an0 = 1'b1;
                 end 
            S8 : char = signal_to_display[3:0];
            S10 : begin
                    an3 = 1'b1;
                    an2 = 1'b1;
                    an1 = 1'b1;
                    an0 = 1'b0;
                 end   
            S12 : char = signal_to_display[15:12];
            S14 : begin
                    an3 = 1'b0;
                    an2 = 1'b1;
                    an1 = 1'b1;
                    an0 = 1'b1;
                 end  
            default: begin
                        an3 = 1'b1;
                        an2 = 1'b1;
                        an1 = 1'b1;
                        an0 = 1'b1;
                     end  
        endcase 
    end

////////////////////////////////
//	Decoder	Instantiation	  //
////////////////////////////////
LEDdecoder LEDdecoderINSTANCE (.char(char),.LED(LED));


//////////////////////////////////////////////////
//		Counter for the 16 states of anodes		//
//////////////////////////////////////////////////
always@(posedge clk or posedge reset)
begin
	if (reset)
	begin
		counter = 4'b0000;
	end	
  
	else 
	begin
		if (counter == 4'b0000)
		begin
			counter = 4'b1111;
		end
		else
		begin
			counter = counter - 1'b1;
		end
	end
end

endmodule
