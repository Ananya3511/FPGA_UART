`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2025 11:14:23
// Design Name: 
// Module Name: Tx
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


module Tx(clk,reset,start,in,tx,tx_inprog);
input clk, reset, start;
input [7:0] in;
output reg tx, tx_inprog;
parameter baud_rate = 9600;
parameter clk_freq = 100_000_000;
parameter baud_ticks = clk_freq / baud_rate;

reg [3:0] bit_index;
reg [9:0] shift_reg;
reg [13:0] baud_counter;
reg [1:0] state;

parameter  IDLE = 2'b00, START = 2'b01,DATA = 2'b10,STOP = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx_inprog <= 0;
        tx <= 1; //always '1' when no data is sended
        baud_counter <= 0;
        bit_index <= 0;
        shift_reg <=0;
        state <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    tx_inprog <= 1;
                    shift_reg <= {1'b1,in,1'b0};
//                    bit_index <= 0;
//                    baud_counter <= 0;
                    tx <= 1;
                    
                    state <= START;
                end
            end
            
            START: begin

                if (baud_counter == (baud_ticks - 1)/2) begin
                     baud_counter <= 0;
                     tx <= shift_reg[0];
                     shift_reg <= shift_reg>>1;
                     bit_index <= 1;
                     state <= DATA;
//                    tx_inprog <= 0;
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
            
            DATA: begin
//                tx <= shift_reg[0];
                if (baud_counter == (baud_ticks - 1)) begin
                    baud_counter <= 0;   
                    tx <= shift_reg[0];          
                    shift_reg <= shift_reg >> 1;
                    bit_index <= bit_index + 1;
                    if (bit_index == 9) begin
//                        tx <=1;
                        state <= STOP;
//                        bit_index <= 0;
                    end
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
            
            STOP: begin
//                tx <= 1;
                if (baud_counter == (baud_ticks - 1)) begin
                    baud_counter <= 0;
                    tx <= shift_reg[0];
                    tx_inprog <= 0;
                    state <= IDLE;
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
        endcase
    end
end

endmodule

