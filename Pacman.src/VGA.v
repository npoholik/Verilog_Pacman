`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2025 02:57:28 PM
// Design Name: 
// Module Name: VGA
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


module VGA(
    input CLK,
    output reg HSYNC, VSYNC,
    output reg signed [10:0] X_PIX, Y_PIX
    );
    
    // Update the pixel position
	always @(posedge CLK) begin
    	X_PIX <= X_PIX + 1;
    	if (X_PIX == 799) begin  	// 799 represents 0->640 + 16 (front) + 96 (sync) + 48 (back)
        	Y_PIX <= Y_PIX + 1;
        	if (Y_PIX == 524) begin  // 524 represents 0 -> 480 + 10 (front) + 2 (sync) + 33 (back)
            	Y_PIX <= 0;
        	end
        	X_PIX <= 0;
    	end
	end
	
	// Set up hsync and vsync (keeping in mind the porch time, sync time, and back time)
	// hsync will be set low > 640 + 16 and < 800 - 48
	// vsync will be set low > 480 + 10 and < 525 - 33
	always @(posedge CLK) begin
    	if ((X_PIX > 640 + 16) && (X_PIX < 800 - 48))
        	HSYNC <= 0;
    	else
        	HSYNC <= 1;
    	if ((Y_PIX > 480 + 10) && (Y_PIX < 525 - 33))
        	VSYNC <= 0;
    	else
        	VSYNC <= 1;
	end
	
endmodule
