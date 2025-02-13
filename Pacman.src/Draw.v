`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nikolas Poholik
//
// Create Date: 01/28/2025 04:04:18 PM
// Design Name: Verilog Pacman
// Module Name: Draw
// Project Name: Verilog Pacman
// Target Devices: Basys 3 FPGA Board
// Tool Versions: Vivado 2024.1
// Description: This project aims to recreate a simple version of pacman. Aspects of the game will continue to be built incrementally. 
// 				The goal of this module is to serve as the TOP LEVEL DRAW where IO is processed
//				The inputs will be handled by certain sub modules accordingly 
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module VGA #(parameter SCALE = 2) (
	input clk,
	input [11:0] switch,
	input SW_up, SW_left, SW_right, SW_down,
	output reg [3:0] vgaRed,
	output reg [3:0] vgaBlue,
	output reg [3:0] vgaGreen,
	output reg Hsync, Vsync
	);

	reg[1:0] counter = 0;
	reg clk_div = 0;
    
	wire [11:0] spriteRGB;   	// Keep track of sprite rgb
	reg [3:0] iSprite, jSprite = 0;  // keep track of sprite color position
	reg [9:0] pacX, pacY = 0;    	// keep track of sprite position
	reg [1:0] frameSelect;  	// Select the current frame to draw
	reg [1:0] direction; 		// Track the current direction of pacman 
    reg [3:0] cursor;
    
	// Reserve enough space for a 640x480 resolution with enough space for front -> sync -> back
	reg [9:0] xPix = 0;
	reg [9:0] yPix = 0;
    reg[3:0] frameUpdate;
    
	Sprite sprite_inst(.x (iSprite),.y (jSprite), .select (frameSelect), .rgb (spriteRGB));
    Buttons btn_up(SW_up, clk, cursor[0]);
    Buttons btn_left(SW_left, clk, cursor[1]);
    Buttons btn_right(SW_right, clk, cursor[2]);
    Buttons btn_down(SW_down, clk, cursor[3]); 
    
	// clock divider for 25 MHz
	// for every 4 rising edges of master clock, clk_div will have a rising edge
	// This requires 2 master clock rising edges per rise and 2 master clock rising edges per fall of clk_div
	always @(posedge clk) begin
    	if(counter == 1) begin
        	clk_div <= ~clk_div;
        	counter <= 0;
    	end else
        	counter <= counter + 1;
	end
    
    always @(posedge clk_div) begin
        if(cursor[0]) direction = 0;
        else if (cursor[1]) direction = 2;
        else if (cursor[2]) direction = 1;
        else if (cursor[3]) direction = 3;
    end 
    
	// color chooser
	always @(posedge clk_div) begin
    	if(~(xPix > 639 || yPix > 479)) begin
        	// Check for the bounds of pacman within the drawing of the screen (scaled up by 4)
        	if ((xPix >= pacX && xPix <= pacX + 16 * SCALE) && (yPix >= pacY && yPix <= pacY + 16 * SCALE)) begin
            	if (xPix % SCALE == 0) begin	// This mod 4 will determine which sprite color data to actually use
					// This will draw pacman facing left
					if (direction == 2) begin 
                	   iSprite = (15 - ((yPix - pacY) / SCALE));
                	   jSprite = (15 - ((xPix - pacX) / SCALE));
                	// this will draw pacman facing right 
                	end else if (direction == 1) begin 
                	   iSprite = ((yPix-pacY) / SCALE);
                	   jSprite = ((xPix - pacX) / SCALE);
                	// this will draw pacman facing up
                	end else if (direction == 0) begin 
                	   iSprite = (15 - ((xPix - pacX) / SCALE));
                	   jSprite = (15 - ((yPix - pacY) / SCALE));
                	// this will draw pacman facing down
                	end else if (direction == 3) begin 
                	   iSprite = ((xPix - pacX) / SCALE); 
                	   jSprite = ((yPix - pacY) / SCALE); 
                	end 
				end

				// Only draw non-transparent aspects of the sprite
            	if(~(spriteRGB == 0)) begin
                	vgaRed = spriteRGB[11:8];
                	vgaGreen = spriteRGB[7:4];
                	vgaBlue = spriteRGB[3:0];
            	end else begin
                	vgaRed = switch[11:8];
                	vgaBlue = switch[7:4];
                	vgaGreen = switch[3:0];
            	end
			// If not within Pacman's bounds, simply draw the background
        	end else begin
            	vgaRed = switch[11:8];
            	vgaBlue = switch[7:4];
            	vgaGreen = switch[3:0];
        	end
    	end else begin  	// Avoid driving color when outside drawable area
        	vgaRed <= 4'b0000;
        	vgaBlue <= 4'b0000;
        	vgaGreen <= 4'b0000;
    	end
	end
    
    
	// Update the pixel position
	always @(posedge clk_div) begin
    	xPix <= xPix + 1;
    	if (xPix == 799) begin  	// 799 represents 0->640 + 16 (front) + 96 (sync) + 48 (back)
        	yPix <= yPix + 1;
        	if (yPix == 524) begin  // 524 represents 0 -> 480 + 10 (front) + 2 (sync) + 33 (back)
            	yPix <= 0;
        	end
        	xPix <= 0;
    	end
	end
    
	// Set up hsync and vsync (keeping in mind the porch time, sync time, and back time)
	// hsync will be set low > 640 + 16 and < 800 - 48
	// vsync will be set low > 480 + 10 and < 525 - 33
	always @(posedge clk_div) begin
    	if ((xPix > 640 + 16) && (xPix < 800 - 48))
        	Hsync <= 0;
    	else
        	Hsync <= 1;
    	if ((yPix > 480 + 10) && (yPix < 525 - 33))
        	Vsync <= 0;
    	else
        	Vsync <= 1;
	end
    
    
    reg [4:0] directionUpdate;
    
    always @(posedge clk_div) begin 
        if (yPix == 0 && xPix == 0) begin
             if (frameUpdate == 5) begin
                frameSelect = frameSelect + 1;
                frameUpdate = 0;
             end
             //if (directionUpdate == 30) begin
                //direction = direction + 1;
             //   directionUpdate = 0;
             //end
             frameUpdate = frameUpdate + 1;
             //directionUpdate = directionUpdate + 1;
        end
    end
    
endmodule
