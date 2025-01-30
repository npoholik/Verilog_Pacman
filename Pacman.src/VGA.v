`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/28/2025 04:04:18 PM
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
`define SCALE 4

module VGA(
	input clk,
	input [11:0] switch,
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

    
	// Reserve enough space for a 640x480 resolution with enough space for front -> sync -> back
	reg [9:0] xPix = 0;
	reg [9:0] yPix = 0;
    
	Sprite sprite_inst(.x (iSprite),.y (jSprite), .select (frameSelect), .rgb (spriteRGB));

    
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
    
    
	// color chooser
	always @(posedge clk_div) begin
    	if(~(xPix > 639 || yPix > 479)) begin
        	// Check for the bounds of pacman within the drawing of the screen (scaled up by 4)
        	if ((xPix >= pacX && xPix <= pacX + 16 * 4) && (yPix >= pacY && yPix <= pacY + 16 * 4)) begin
            	if (xPix % 4 == 0) begin
                	iSprite = (15 - ((yPix - pacY) / 4));
                	jSprite = (15 - ((xPix - pacX) / 4));
            	end
       	 
       	 
        	// Check for the bounds of pac man (we will scale him up by 4 x )
        	//if((xPix > 0) && (xPix < 14 * 4) ) begin
            	//if((yPix > 0) && (yPix < 13 * 4)) begin
               	 
               	 
               	 
                	//vgaRed <= spriteRGB;
                	//vgaBlue <= 'hff;
                	//vgaGreen <= 'h00;
                	/*
                	// Now we know that the screen is within the bounds, lets start pulling RGB information from sprite
                	// Step one: check repeatX to see if we need to move onto next col
                	if(repeatX < 4)
                    	repeatX = repeatX + 1;
                   	 
                	else begin
                    	repeatX = 0;
                    	repeatY = repeatY + 1;
                   	 
                    	spriteX <= spriteX + 1;
                    	if (repeatY >= 4) begin
                        	repeatY = 0;
                        	spriteY <= spriteY + 1;
                    	end
                    	vgaRed <= 'hff;
                    	vgaBlue <= 'hff;
                    	vgaGreen <= 'h00;
                    	*/
               	// end
            	if(~(spriteRGB == 0)) begin
                	vgaRed = spriteRGB[11:8];
                	vgaGreen = spriteRGB[7:4];
                	vgaBlue = spriteRGB[3:0];
            	end else begin
                	vgaRed = switch[11:8];
                	vgaBlue = switch[7:4];
                	vgaGreen = switch[3:0];
            	end
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
    
	// Set up hsync and vsync
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
    
    

    
	reg [4:0] frameUpdate;
    
	always @(yPix) begin
    	if (yPix == 0) begin
         	if (frameUpdate == 20) begin
            	frameSelect = frameSelect + 1;
            	frameUpdate = 0;
         	end
         	frameUpdate = frameUpdate + 1;
    	end
	end
    
endmodule
