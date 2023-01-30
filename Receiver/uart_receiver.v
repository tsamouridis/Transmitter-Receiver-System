// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps

// Uart Receiver implementation
module uart_receiver(reset, clk, Rx_DATA, baud_select, RX_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);

input clk, reset;
input [2:0] baud_select;
input RX_EN;
input RxD;

output [7:0] Rx_DATA;
output Rx_FERROR; // Framing Error //
output Rx_PERROR; // Parity Error // 
output Rx_VALID; // Rx_DATA is Valid //

reg Rx_FERROR; 
reg Rx_PERROR; 
reg Rx_VALID;
reg [7:0] Rx_DATA;

reg [3:0] current_state, next_state;
reg [4:0] counter_1_period = 5'd00000;
reg temp_out;
reg xor_result;
reg expected_parity;

  
wire Rx_sample_ENABLE;

parameter WAIT = 4'b0000, 
          START = 4'b0001,
          D0 = 4'b0010,
          D1 = 4'b0011,
          D2 = 4'b0100,
          D3 = 4'b0101,
          D4 = 4'b0110,
          D5 = 4'b0111,
          D6 = 4'b1000,
          D7 = 4'b1001,
          PARITY = 4'b1010,
          STOP = 4'b1011,
          OUTPUT = 4'b1100;

////////////////////////////////////
//	Baud Controler Instantiation  //
////////////////////////////////////
baud_controller baud_controller_instance(.reset(reset), .clk(clk), .baud_select(baud_select), .sample_ENABLE(Rx_sample_ENABLE));

always @ (posedge Rx_sample_ENABLE or posedge reset) 
    // receiver leaves WAIT state only if Rx_EN is 1
	begin: STATE_MEMORY 
      if (reset || ~RX_EN)
			current_state <= WAIT;
		else
		 	current_state <= next_state; 
	end

always @ (current_state or posedge Rx_sample_ENABLE)
    begin: NEXT_STATE_LOGIC
    // period stands for one period of Rx_sample_ENABLE
        case (current_state)
            WAIT : if(RxD == 0) begin
                    next_state = START;
                end     
                else begin
                    next_state = WAIT;
                 end
            START : if(counter_1_period == 16)
                    next_state = D0;
                 else 
                    next_state = START;
            D0 : if(counter_1_period == 16)
                    next_state = D1;
                 else 
                    next_state = D0;  
            D1 : if(counter_1_period == 16)
                    next_state = D2;
                 else 
                    next_state = D1;  
            D2 : if(counter_1_period == 16)
                    next_state = D3;
                 else 
                    next_state = D2;  
            D3 : if(counter_1_period == 16)
                    next_state = D4;
                 else 
                    next_state = D3;  
            D4 : if(counter_1_period == 16)
                    next_state = D5;
                 else 
                    next_state = D4;  
            D5 : if(counter_1_period == 16)
                    next_state = D6;
                 else 
                    next_state = D5;  
            D6 : if(counter_1_period == 16)
                    next_state = D7;
                 else 
                    next_state = D6;   
            D7 : if(counter_1_period == 16)
                    next_state = PARITY;
                 else 
                    next_state = D7;   
            PARITY : if(counter_1_period == 16)
                    next_state = STOP;
                 else 
                    next_state = PARITY;
            STOP : if(counter_1_period == 16)
                    next_state = OUTPUT;
                 else 
                    next_state = STOP; 
            OUTPUT : if(counter_1_period == 2)
                    next_state = WAIT;
                 else 
                    next_state = OUTPUT;
        endcase
    end

  always @ (current_state or posedge Rx_sample_ENABLE)
    begin: OUTPUT_LOGIC
        case (current_state)
            WAIT : begin
                Rx_DATA = 8'b0;
                Rx_FERROR = 1'b0;
                Rx_PERROR = 1'b0;
                Rx_VALID = 1'b0;
                counter_1_period = 1;
                // and other things++
            end

            START : begin
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin

                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1)   // if xor gives 1 it means we got a change 
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                end
                else
                    temp_out = temp_out;// do nothing
            end

            D0 : begin
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin

                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1)   // if xor gives 1 it means we got a change
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                end
                else
                    temp_out = temp_out;// do nothing
                if(Rx_FERROR == 0 && counter_1_period == 8)
                    Rx_DATA[0] = RxD;
                else
                    Rx_DATA[0] = Rx_DATA[0];
            end
            
            D1 : begin
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin

                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1)   // if xor gives 1 it means we got a change
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                end
                else
                    temp_out = temp_out;// do nothing

                if(Rx_FERROR == 0 && counter_1_period == 8)
                    Rx_DATA[1] = RxD;
                else
                    Rx_DATA[1] = Rx_DATA[1];
            end 

            D2 : begin
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin

                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1)   // if xor gives 1 it means we got a change
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                end
                else
                    temp_out = temp_out;// do nothing

                if(Rx_FERROR == 0 && counter_1_period == 8)
                    Rx_DATA[2] = RxD;
                else
                    Rx_DATA[2] = Rx_DATA[2];
            end 
            
            D3 :  begin
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin

                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1)   // if xor gives 1 it means we got a change
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                end
                else
                    temp_out = temp_out;// do nothing

                if(Rx_FERROR == 0 && counter_1_period == 8)
                    Rx_DATA[3] = RxD;
                else
                    Rx_DATA[3] = Rx_DATA[3];
            end 

            D4 :  begin
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin

                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1)   // if xor gives 1 it means we got a change
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                end
                else
                    temp_out = temp_out;// do nothing

                if(Rx_FERROR == 0 && counter_1_period == 8)
                    Rx_DATA[4] = RxD;
                else
                    Rx_DATA[4] = Rx_DATA[4];
            end 

            D5 : begin
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin

                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1)   // if xor gives 1 it means we got a change
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                end
                else
                    temp_out = temp_out;// do nothing

                if(Rx_FERROR == 0 && counter_1_period == 8)
                    Rx_DATA[5] = RxD;
                else
                    Rx_DATA[5] = Rx_DATA[5];
            end 
            
            D6 : begin
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin

                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1)   // if xor gives 1 it means we got a change
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                end
                else
                    temp_out = temp_out;// do nothing

                if(Rx_FERROR == 0 && counter_1_period == 8)
                    Rx_DATA[6] = RxD;
                else
                    Rx_DATA[6] = Rx_DATA[6];
            end 
            
            D7 : begin
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin

                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1)   // if xor gives 1 it means we got a change
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                end
                else
                    temp_out = temp_out;// do nothing

                if(Rx_FERROR == 0 && counter_1_period == 8)
                    Rx_DATA[7] = RxD;
                else
                    Rx_DATA[7] = Rx_DATA[7];
            end 

            PARITY : begin
                expected_parity = ^(Rx_DATA);

                // Framing error check 
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin
                    
                    // Framing error check
                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1)   // if xor gives 1 it means we got a change
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                    
                    // Parity error check
                    if(temp_out != expected_parity)     // if xor is not the expected one, it means we got a change in the first period
                        Rx_PERROR <= 1'b1;  // parity error detected
                    else
                        Rx_PERROR <= Rx_PERROR;
                end 
            end  

            STOP : begin
                expected_parity = ^(Rx_DATA);

                // Framing error check 
                if(counter_1_period == 2)
                    temp_out = RxD; //first sample of the bit at the second posedge of clk. It is zero for start bit
                else if(counter_1_period == 4 || counter_1_period == 8 || 
                        counter_1_period == 10 || counter_1_period == 12 || 
                        counter_1_period == 14) begin
                    
                    // Framing error check
                    xor_result = RxD ^ temp_out;
                    if(xor_result == 1'b1 || temp_out != 1'b1)
                        Rx_FERROR = 1'b1;   // framing error detected
                    else 
                        Rx_FERROR = Rx_FERROR;
                end 
            end  

            OUTPUT :
                Rx_VALID = ~(Rx_FERROR | Rx_PERROR);
                
        endcase 
    end

//////////////////////////////////////////////////////
//		Counter for 1 period of Rx_sample_ENABLE	//
//////////////////////////////////////////////////////

always@(posedge Rx_sample_ENABLE or posedge reset)
begin
	if (reset) begin
		counter_1_period = 1;
	end	
  
	else begin
		if (counter_1_period == 16)
		    counter_1_period = 1;
		else
			counter_1_period = counter_1_period + 1;
	end
end
endmodule