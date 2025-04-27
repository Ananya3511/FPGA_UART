`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2025 16:45:55
// Design Name: 
// Module Name: Rx
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


module Rx( clk, reset, rx,shift_reg,rx_ready);
input clk, reset, rx;
output reg [7:0]shift_reg;
output reg rx_ready;
parameter baud_rate = 9600;
parameter clk_freq = 100_000_000;
parameter baud_ticks = clk_freq / baud_rate;

reg [3:0] bit_index;
reg [9:0] out;
reg [13:0] baud_counter;
reg [1:0] state;

parameter IDLE = 2'b00, START = 2'b01,DATA = 2'b10,STOP = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        rx_ready <= 0;
        shift_reg <= 0;
        baud_counter <= 0;
        bit_index <= 0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
            rx_ready <= 0;
            
                if(!rx)begin
                    shift_reg <= 0;
                    baud_counter <= 0;
                    bit_index <= 0;
                    state <= START;end
               end
            START: begin
                if (baud_counter == (baud_ticks-1) / 2) begin
                     baud_counter <= 0;
                     state <= DATA;
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
            
            DATA: begin
                if (baud_counter == baud_ticks - 1) begin
                    baud_counter <= 0;
                    shift_reg[bit_index] <= rx;
                    bit_index <= bit_index + 1;
                    if (bit_index == 8) begin
                        state <= STOP;
                    end
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
            
            STOP: begin
                if (baud_counter == baud_ticks - 1) begin
                    shift_reg <= shift_reg;
                    rx_ready <= 1;
                    state <= IDLE;
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
        endcase
    end
end

endmodule
