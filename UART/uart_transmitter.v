`timescale 1ns / 1ps
`include "baud_rate.v"

module uart_transmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY); 

input clk, reset; 
input [7:0] Tx_DATA; 
input [2:0] baud_select; 
input Tx_EN; 
input Tx_WR; 

output TxD; 
output Tx_BUSY; 

reg TxD;
reg Tx_BUSY; //1 when transmitter already sends data
reg [3:0] current_state, next_state;
reg [7:0] temp_data; //stores the Tx_DATA when the transmission starts
wire Tx_sample_ENABLE; // output of Baud Rate Generator
reg [4:0] counter_1_period = 5'd00000;
reg [4:0] rises_in_1_period = 5'd00000;

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
          STOP = 4'b1011;

always @ (posedge clk or posedge reset)         
    // transmitter leaves WAIT state only if Tx_EN is 1
	begin : STATE_MEMORY
      if (~reset || ~Tx_EN)  
            current_state <= WAIT;              
        else        
            current_state <= next_state;                
    end
    
baud_controller baud_controller_tx_instance(.reset(reset), .clk(clk), .baud_select(baud_select), .sample_ENABLE(Tx_sample_ENABLE));

  always @ (posedge clk)
    begin: NEXT_STATE_LOGIC
        case(current_state)
            WAIT: begin
                if(Tx_WR == 1'b1)
                    next_state = START;
                else 
                    next_state = WAIT;
            end

            START: begin
                if(counter_1_period == 0)
                    next_state = D0;
                else 
                    next_state = START;
            end

            D0: begin
                if(counter_1_period == 0) 
                    begin
                        next_state = D1;
                    end
                else
                    begin
                        next_state = D0;
                    end
            end

            D1: begin
                if(counter_1_period == 0) 
                    begin
                        next_state = D2;
                    end
                else
                    begin
                        next_state = D1;
                    end
            end

            D2: begin
                if(counter_1_period == 0) 
                    begin
                        next_state = D3;
                    end
                else
                    begin
                        next_state = D2;
                    end
            end

            D3: begin
                if(counter_1_period == 0) 
                    begin
                        next_state = D4;
                    end
                else
                    begin
                        next_state = D3;
                    end
            end

            D4: begin
                if(counter_1_period == 0) 
                    begin
                        next_state = D5;
                    end
                else
                    begin
                        next_state = D4;
                    end
            end

            D5: begin
                if(counter_1_period == 0) 
                    begin
                        next_state = D6;
                    end
                else
                    begin
                        next_state = D5;
                    end
            end

            D6: begin
                if(counter_1_period == 0) 
                    begin
                        next_state = D7;
                    end
                else
                    begin
                        next_state = D6;
                    end
            end

            D7: begin
                if(counter_1_period == 0) 
                    begin
                        next_state = PARITY;
                    end
                else
                    begin
                        next_state = D7;
                    end
            end

            PARITY: begin
                if(counter_1_period == 0) 
                    begin
                        next_state = STOP;
                    end
                else
                    begin
                        next_state = PARITY;
                    end
            end

            
            STOP: begin
                if(counter_1_period == 0) 
                    begin
                        next_state = WAIT;
                    end
                else
                    begin
                        next_state = STOP;
                    end
            end
        endcase
    end
    
  always @ (posedge clk)
    begin: OUTPUT_LOGIC
        case(current_state)
            WAIT: begin
                temp_data = Tx_DATA;
                Tx_BUSY = 1'b0; // ready to take input data
            end
            
            START: begin
                TxD = 1'b0; // send start bit
                Tx_BUSY = 1'b1; // transmitter is busy
            end

            D0: begin
                TxD = temp_data[0];
            end

            D1: begin
                TxD = temp_data[1];
            end

            D2: begin
                TxD = temp_data[2];
            end

            D3: begin
                TxD = temp_data[3];
            end

            D4: begin
                TxD = temp_data[4];
            end

            D5: begin
                TxD = temp_data[5];
            end

            D6: begin
                TxD = temp_data[6];
            end

            D7: begin
                TxD = temp_data[7];
            end

            PARITY: begin
                TxD = ^(temp_data);   
                // xor of the temp_data gives 1 when we have odd sum of 1'b1
                // xor of the temp_data gives 0 when we have even sum of 1'b1 
            end

            STOP: begin
                TxD = 1'b1; // send stop bit
            end
        endcase
    end

always @ (baud_select)
begin
    case(baud_select)
        3'b000 : begin
            rises_in_1_period = 10417;
        end
        3'b001 : begin 
            rises_in_1_period = 2604;
        end
        3'b010 : begin
            rises_in_1_period = 651;
        end
        3'b011 : begin
            rises_in_1_period = 326;
        end
        3'b100 : begin 
            rises_in_1_period = 163;
        end
        3'b101 : begin
            rises_in_1_period = 81;
        end
        3'b110 : begin 
            rises_in_1_period = 54;
        end
        3'b111 : begin 
            rises_in_1_period = 27;
        end
    endcase  
end

always@(posedge Tx_sample_ENABLE or posedge reset)
begin
	if (reset)
	begin
		counter_1_period = 0;
	end	
  
	else 
	begin
		if (counter_1_period == rises_in_1_period)
		begin
			counter_1_period = 0;
		end
		else
		begin
			counter_1_period = counter_1_period + 1;
		end
	end
end

endmodule