`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2025 03:12:38 PM
// Design Name: 
// Module Name: Pac_Sprite
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


module Pac_Sprite(
    input [3:0] X_INDEX,
    input [3:0] Y_INDEX,
    input [2:0] FRAME_SELECT,
    output reg [11:0] RGB
    );
    
    
    /************ SPRITE INFORMATION ********/
    // We need a 16x16 matrix with 12 bits of color data in each cell 
    // There will be three total frames for pacman's sprite
    
    // 12 bit elements with 16 rows and 16 columns
    logic [11:0] frame0[0:15][0:15] = '{ 
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 } };
    
    
    logic [11:0] frame1[0:15][0:15] = '{
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 } };
    
    
    logic [11:0] frame2[0:15][0:15] = '{ 
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 } };
        
    // Output the required frame
    always @(*) begin
        if (FRAME_SELECT == 0) 
            RGB <= frame0[X_INDEX][Y_INDEX];
        else if (FRAME_SELECT == 1)
            RGB <= frame1[X_INDEX][Y_INDEX];
        else if (FRAME_SELECT == 2)
            RGB = frame2[X_INDEX][Y_INDEX];
        else if (FRAME_SELECT == 3)
            RGB = frame1[X_INDEX][Y_INDEX];
    end
        
endmodule
