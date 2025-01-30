`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2025 03:00:10 PM
// Design Name: 
// Module Name: Buttons
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


module Buttons(
    input btn, clk,
    output btn_out 
    );
    
    wire Q1, Q2, Q0, slow_clk;
    slow_clk(clk, slow_clk); 
    
    dff d0(slow_clk, btn, Q0);
    
    dff d1(slow_clk, Q0, Q1);
    dff d2(slow_clk, Q1, Q2);
    
    assign btn_out = (~Q1 & Q2) || (Q1 & Q2);
endmodule


module dff(
    input clk, D,
    output reg Q
    );
    
    always@(posedge clk) begin
        Q <= D;
    end 
endmodule


module slow_clk (
    input clk, 
    output reg slow_clk
    );
    reg [26:0] counter = 0;
    
    always @(posedge clk) begin 
        counter <= (counter >= 249999)?0:counter + 1;
        slow_clk <= (counter < 125000)?1'b0:1'b1; 
    end 
    
endmodule
