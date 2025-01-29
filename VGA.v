`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nikolas Poholik
// 
// Create Date: 01/28/2025 04:04:18 PM
// Design Name: Color Choosing Switch
// Module Name: VGA
// Target Devices: Digilent Basys 3 Board
// Tool Versions: Vivado 2024.1
// Description: Allows you to output a VGA signal to display a solid color based on dip switches which correspond to RGB Hex values 
// 
// 
// Revision:
// Revision 0.01 - File Created
// 
//////////////////////////////////////////////////////////////////////////////////


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
    reg [1:0] rgb = 0;
    
    // Reserve enough space for a 640x480 resolution with enough space for front -> sync -> back
    reg [9:0] xPix = 0;
    reg [9:0] yPix = 0;
    
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
            vgaRed <= switch[11:8];
            vgaBlue <= switch[7:4];
            vgaGreen <= switch[3:0];
            
            /*if(switch[0]) begin 
                vgaRed <= 4'b1111;
                vgaBlue <= 4'b0000;
                vgaGreen <= 4'b0000;
            end else if (switch[1]) begin
                vgaRed <= 4'b0000;
                vgaBlue <= 4'b1111;
                vgaGreen <= 4'b0000;
            end else begin
                vgaRed <= 4'b0000;
                vgaBlue <= 4'b0000;
                vgaGreen <= 4'b1111;
            end*/ 
        end else begin      // Avoid driving color when outside drawable area
            vgaRed <= 4'b0000;
            vgaBlue <= 4'b0000;
            vgaGreen <= 4'b0000;
        end
    end 
    
    
    // Update the pixel position 
    always @(posedge clk_div) begin 
        xPix <= xPix + 1;
        if (xPix == 799) begin      // 799 represents 0->640 + 16 (front) + 96 (sync) + 48 (back)
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
    
    
    
endmodule
