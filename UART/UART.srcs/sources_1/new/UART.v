`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2025 16:58:47
// Design Name: 
// Module Name: UART
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART(clk,reset,start,in,tx,tx_inprog,rx,shift_reg,rx_ready);
input clk,reset,start,rx;
input [7:0]in;
output tx,tx_inprog, rx_ready;
output [7:0]shift_reg;
Tx (.clk(clk),.reset(reset),.start(start),.in(in),.tx(tx),.tx_inprog(tx_inprog));
Rx (.clk(clk),.reset(reset), .rx(rx),.shift_reg(shift_reg),.rx_ready(rx_ready));
endmodule

