`timescale 1ns / 1ps
module uart_receiver(reset, clk, Rx_DATA, baud_select, RX_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);

input clk, reset;
input [2:0] baud_select;
input RX_EN;

output RxD;
output [7:0] Rx_DATA;
output Rx_FERROR; // Framing Error //
output Rx_PERROR; // Parity Error // 
output Rx_VALID; // Rx_DATA is Valid //

reg RxD;
reg [7:0] Rx_DATA;
reg Rx_FERROR; 
reg Rx_PERROR; 
reg Rx_VALID;

reg [2:0] current_state, next_state;
reg [4:0] counter_1_period = 5'd00000;
// reg [4:0] counter_8_periods = 5'd00000;;
reg temp_out;
reg xor_result;

  
wire [6:0] Rx_sample_ENABLE;

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
          OUTPUT = 4'b1110;

////////////////////////////////////
//	Baud Controler Instantiation  //
////////////////////////////////////
baud_controller baud_controller_instance(.reset(reset), .clk(clk), .baud_select(baud_select), .sample_ENABLE(Rx_sample_ENABLE));

always @ (posedge clk or posedge reset) 
    // receiver leaves WAIT state only if Rx_EN is 1
	begin: STATE_MEMORY 
      if (reset or RX_EN)
			current_state <= WAIT;
		else
		 	current_state <= next_state; 
            Rx_DATA = 8'b0;
            Rx_FERROR = 1'b0;
            Rx_PERROR = 1'b0;
            Rx_VALID = 1'b0;
	end

always @ (current_state or posedge clk)
    begin: NEXT_STATE_LOGIC
    // period stands for one period of Rx_sample_ENABLE
    // Stays at WAIT till starting bit (till RxD becomes zero)
    // Stays at START for 1 period
    // Stays at D_i for 1 period, i = 0, 1,...,7
    // Stays at PARITY for 1 period
    // Stays at OUTPUT for 1 period
        case (current_state)
            WAIT : if(RxD == 0)
                    next_state = START;
                 else 
                    next_state = RxD;
            START : if(counter_1_period == rises_in_1_period)
                    next_state = DATA;
                 else 
                    next_state = START;
            D0 : if(counter_1_period == rises_in_1_period)
                    next_state = D1;
                 else 
                    next_state = D0;  
            D1 : if(counter_1_period == rises_in_1_period)
                    next_state = D2;
                 else 
                    next_state = D1;  
            D2 : if(counter_1_period == rises_in_1_period)
                    next_state = D3;
                 else 
                    next_state = D2;  
            D3 : if(counter_1_period == rises_in_1_period)
                    next_state = D4;
                 else 
                    next_state = D3;  
            D4 : if(counter_1_period == rises_in_1_period)
                    next_state = D5;
                 else 
                    next_state = D4;  
            D5 : if(counter_1_period == rises_in_1_period)
                    next_state = D6;
                 else 
                    next_state = D5;  
            D6 : if(counter_1_period == rises_in_1_period)
                    next_state = D7;
                 else 
                    next_state = D6;   
            D7 : if(counter_1_period == rises_in_1_period)
                    next_state = PARITY;
                 else 
                    next_state = D7;   
            PARITY : if(counter == rises_in_1_period)
                    next_state = STOP;
                 else 
                    next_state = PARITY;
            STOP : if(counter == rises_in_1_period)
                    next_state = S5;
                 else 
                    next_state = S4; 
            OUTPUT : if(counter == rises_in_1_period)
                    next_state = WAIT;
                 else 
                    next_state = OUTPUT;
        endcase
    end

//! HERE
  always @ (current_state or posedge clk)
    begin: OUTPUT_LOGIC
        case (current_state)
            WAIT : begin
                // make errors 0 and other things++
            end

            START : begin
                if counter_1_period == 0
                    temp_out = RxD; //first sample of the bit. It is zero for start bit
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_FERROR = 1'b1;   // framing error detected   // framing error detected
                    end
                end   
            end

            D0 : begin
                if(counter_1_period == 0)
                    temp_out = RxD; //first sample of the bit.
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_FERROR = 1'b1;   // framing error detected   // framing error detected
                    end
                end 
                // when half a period(approximately sometimes) passes show RxD in the output
                if(Rx_FERROR == 0 && counter_1_period == rises_in_half_period)
                    Rx_DATA[0] = RxD;
            end
            
            D1 : begin
                if(counter_1_period == 0)
                    temp_out = RxD; //first sample of the bit.
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_FERROR = 1'b1;   // framing error detected   // framing error detected
                    end
                end 
                // when half a period(approximately sometimes) passes show RxD in the output
                if(Rx_FERROR == 0 && counter_1_period == rises_in_half_period)
                    Rx_DATA[1] = RxD;
            end 

            D2 : begin
                if(counter_1_period == 0)
                    temp_out = RxD; //first sample of the bit.
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_FERROR = 1'b1;   // framing error detected   // framing error detected
                    end
                end 
                // when half a period(approximately sometimes) passes show RxD in the output
                if(Rx_FERROR == 0 && counter_1_period == rises_in_half_period)
                    Rx_DATA[2] = RxD;
            end 
            
            D3 :  begin
                if(counter_1_period == 0)
                    temp_out = RxD; //first sample of the bit.
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_FERROR = 1'b1;   // framing error detected
                    end
                end 
                // when half a period(approximately sometimes) passes show RxD in the output
                if(Rx_FERROR == 0 && counter_1_period == rises_in_half_period)
                    Rx_DATA[3] = RxD;
            end 
            D4 :  begin
                if(counter_1_period == 0)
                    temp_out = RxD; //first sample of the bit.
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_FERROR = 1'b1;   // framing error detected
                    end
                end 
                // when half a period(approximately sometimes) passes show RxD in the output
                if(Rx_FERROR == 0 && counter_1_period == rises_in_half_period)
                    Rx_DATA[4] = RxD;
            end 
            D5 : begin
                if(counter_1_period == 0)
                    temp_out = RxD; //first sample of the bit.
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_FERROR = 1'b1;   // framing error detected
                    end
                end 
                // when half a period(approximately sometimes) passes show RxD in the output
                if(Rx_FERROR == 0 && counter_1_period == rises_in_half_period)
                    Rx_DATA[5] = RxD;
            end 
            
            D6 : begin
                if(counter_1_period == 0)
                    temp_out = RxD; //first sample of the bit.
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_FERROR = 1'b1;   // framing error detected
                    end
                end 
                // when half a period(approximately sometimes) passes show RxD in the output
                if(Rx_FERROR == 0 && counter_1_period == rises_in_half_period)
                    Rx_DATA[6] = RxD;
            end 
            
            D7 : begin
                if(counter_1_period == 0)
                    temp_out = RxD; //first sample of the bit.
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_FERROR = 1'b1;   // framing error detected
                    end
                end 
                // when half a period(approximately sometimes) passes show RxD in the output
                if(Rx_FERROR == 0 && counter_1_period == rises_in_half_period)
                    Rx_DATA[7] = RxD;
            end 
            
            PARITY : begin
                if counter_1_period == 0
                    temp_out = RxD; //first sample of the bit. It is zero for start bit
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_PERROR = 1'b1;  // parity error detected
                    end
                end   
            end  

            STOP : begin
                if counter_1_period == 0
                    temp_out = RxD; //first sample of the bit. It is zero for start bit
                    if(temp_out != 1'b1)
                        Rx_FERROR = 1'b1;  // framing error detected
                else begin
                    xor_result = RxD ~^ temp_out;
                    if xor_result == 1 begin    // if xor gives 1 it means we got a change in the first period
                        Rx_FERROR = 1'b1;  // framing error detected
                    end
                end   
            end  

            OUTPUT : if(counter == rises_in_1_period)
                Rx_VALID = Rx_FERROR & Rx_PERROR;
        endcase 
    end


  
//////////////////////////////////////////////////////
//		Counter for 1 period of Rx_sample_ENABLE	//
//////////////////////////////////////////////////////

// rises_in_1_period are the number of clock rises_in_1_period in an Rx_sample_ENABLE period
always @ (baud_select)
begin
    case(baud_select)
        3'b000 : begin
            rises_in_1_period = 10417;
            rises_in_half_period = 5208; // == floor(rises_in_1_period/2))
        end
        3'b001 : begin 
            rises_in_1_period = 2604;
            rises_in_half_period = 1302;
        end
        3'b010 : begin
            rises_in_1_period = 651;
            rises_in_half_period = 325;
        end
        3'b011 : begin
            rises_in_1_period = 326;
            rises_in_half_period = 163;
        end
        3'b100 : begin 
            rises_in_1_period = 163;
            rises_in_half_period = 81;
        end
        3'b101 : begin
            rises_in_1_period = 81;
            rises_in_half_period = 40;
        end
        3'b110 : begin 
            rises_in_1_period = 54;
            rises_in_half_period = 27;
        end
        3'b111 : begin 
            rises_in_1_period = 27;
            rises_in_half_period = 13;
        end
    endcase  
end

always@(posedge clk or posedge reset)
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

// //////////////////////////////////////////////////
// //		Counter for 8 periods of Rx_sample_ENABLE	//
// //////////////////////////////////////////////////

// // rises_8_periods are the number of clock rises in an Rx_sample_ENABLE period multiplied by 8
// always @ (baud_select)
// begin
//     case(baud_select)
//         3'b000 : rises_8_periods = 8*10417; // == 83336
//         3'b001 : rises_8_periods = 8*2604;
//         3'b010 : rises_8_periods = 8*651;
//         3'b011 : rises_8_periods = 8*326;
//         3'b100 : rises_8_periods = 8*163;
//         3'b101 : rises_8_periods = 8*81;
//         3'b110 : rises_8_periods = 8*54;
//         3'b111 : rises_8_periods = 8*27;
//     endcase  
// end

// always@(posedge clk or posedge reset)
// begin
// 	if (reset)
// 	begin
// 		counter_8_periods = 0;
// 	end	
  
// 	else 
// 	begin
// 		if (counter_8_periods == rises_8_periods)
// 		begin
// 			counter_8_periods = 0;
// 		end
// 		else
// 		begin
// 			counter_8_periods = counter_8_periods + 1;
// 		end
// 	end
// end

endmodule