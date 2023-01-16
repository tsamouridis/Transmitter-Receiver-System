module uart_transmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, TX_EN, TxD, TX_BUSY); 
input clk, reset; 
input [7:0] Tx_DATA; 
input [2:0] baud_select; 
input TX_EN; 
input Tx_WR; 
output TxD; 
output Tx_BUSY; 

baud_controller baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE); 


endmodule