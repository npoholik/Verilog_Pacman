`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2025 02:58:24 PM
// Design Name: 
// Module Name: Clock_Divider
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


module Clock_Divider(
    input CLK,
    output reg CLK_DIV 
    );
    
    reg[1:0] counter = 0;
    
    // clock divider for 25 MHz
	// for every 4 rising edges of master clock, clk_div will have a rising edge
	// This requires 2 master clock rising edges per rise and 2 master clock rising edges per fall of clk_div
	always @(posedge CLK) begin
    	if(counter == 1) begin
        	CLK_DIV <= ~CLK_DIV;
        	counter <= 0;
    	end else
        	counter <= counter + 1;
	end
    
endmodule


