// Bouletsis Alexis
// Tsamouridis Anastasios Athanasios

`timescale 1ns / 1ps
`include "baud_controller.v"

// Implementation of UART transmitter
module uart_transmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);

input clk, reset;
input [7:0] Tx_DATA;
input [2:0] baud_select;
input Tx_EN;
input Tx_WR;

output TxD;
output Tx_BUSY;

reg TxD;
reg Tx_BUSY; //1 when transmitter cannot send data
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
          STOP = 4'b1011,
          POST_STOP_PERIOD = 4'b1100;

always @ (posedge Tx_sample_ENABLE or posedge reset)        
    // transmitter leaves WAIT state only if Tx_EN is 1
    begin : STATE_MEMORY
        if (reset || ~Tx_EN)  
            current_state <= WAIT;              
        else        
            current_state <= next_state;                
    end
   
baud_controller baud_controller_tx_instance(.reset(reset), .clk(clk), .baud_select(baud_select), .sample_ENABLE(Tx_sample_ENABLE));

  always @ (current_state or posedge Tx_sample_ENABLE)
    begin: NEXT_STATE_LOGIC
        case(current_state)

            WAIT: begin
                if(Tx_WR == 1'b1)
                    next_state = START;
                else
                    next_state = WAIT;
            end

            START: begin
                if(counter_1_period  == 16)
                    next_state = D0;
                else
                    next_state = START;
            end

            D0: begin
                if(counter_1_period  == 16)
                    next_state = D1;
                else
                    next_state = D0;
            end

            D1: begin
                if(counter_1_period  == 16)
                    next_state = D2;
                else
                    next_state = D1;
            end

            D2: begin
                if(counter_1_period  == 16)
                    next_state = D3;
                else
                    next_state = D2;
            end

            D3: begin
                if(counter_1_period  == 16)
                    next_state = D4;
                else
                    next_state = D3;
            end

            D4: begin
                if(counter_1_period  == 16)
                    next_state = D5;
                else
                    next_state = D4;
            end

            D5: begin
                if(counter_1_period  == 16)
                    next_state = D6;
                else
                    next_state = D5;
            end

            D6: begin
                if(counter_1_period  == 16)
                    next_state = D7;
                else
                    next_state = D6;
            end

            D7: begin
                if(counter_1_period  == 16)
                    next_state = PARITY;
                else
                    next_state = D7;
            end

            PARITY: begin
                if(counter_1_period  == 16)
                    next_state = STOP;
                else
                    next_state = PARITY;
            end

           
            STOP: begin
                if(counter_1_period  == 16)
                    next_state = POST_STOP_PERIOD;
                else
                    next_state = STOP;
            end    

            // Period before busy drops to 0, in order to prevent
            // overlapping of valid and start bit
            POST_STOP_PERIOD: begin
                if(counter_1_period  == 4)
                    next_state = WAIT;
                else
                    next_state = POST_STOP_PERIOD;
            end
        endcase
    end
   
  always @ (current_state or posedge Tx_sample_ENABLE)
    begin: OUTPUT_LOGIC
        case(current_state)
            WAIT: begin
                temp_data = Tx_DATA;
                Tx_BUSY = 1'b0; // ready to take input data
                counter_1_period = 1;
                TxD = 1'b1; 
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

            POST_STOP_PERIOD: begin
                TxD = 1'b1;
            end
        endcase
    end

always@(posedge Tx_sample_ENABLE or posedge reset) begin
    if (reset) begin
        counter_1_period = 1;
    end
 
    else begin
        if (counter_1_period == 16) begin
            counter_1_period = 1;
        end
        else begin
            counter_1_period = counter_1_period + 1;
        end
    end
end

endmodule