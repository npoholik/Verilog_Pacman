`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2025 03:05:25 PM
// Design Name: 
// Module Name: Pac_Move
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


module Pac_Move #(SPRITE_SCALE,UP,DOWN,LEFT,RIGHT)
    (
    input CLK, 
    input signed [10:0] X_VGA, Y_VGA,
    input [1:0] PAC_DIRECTION,
    output reg signed [10:0] PAC_X, PAC_Y,
    output reg [2:0] FRAME_SELECT
    );
    
    reg [3:0] frameCount;
    reg [2:0] cur_Frame;
    reg signed [10:0] cur_Pac_X, cur_Pac_Y;

    always @(*) begin
        PAC_X <= cur_Pac_X;
        PAC_Y <= cur_Pac_Y;
        FRAME_SELECT <= cur_Frame;
    end
     
    // This will handle movement + frame information 
    always @(posedge CLK) begin 
        if (X_VGA == 0 && Y_VGA == 0) begin
            if (frameCount == 1) begin
            
                // Update sprites 
                if(cur_Frame == 3) cur_Frame <= 0;
                else cur_Frame <= cur_Frame + 1;
                
                frameCount <= 0;
            end
            frameCount <= frameCount + 1; 
            
            // Move pacman's position on screen in regards to the direction he is facing 
            // Goal is constant movement, but this movement must know what tile is ahead of pacman in terms of direction he is facing (otherwise do not let Pacman move)
            if (PAC_DIRECTION == UP) begin
                if (cur_Pac_Y > 0 - 16 * SPRITE_SCALE) begin
                    cur_Pac_Y <= cur_Pac_Y - SPRITE_SCALE;
                end else 
                    cur_Pac_Y <= 480 + 16 * SPRITE_SCALE;
            end
            if (PAC_DIRECTION == RIGHT) begin
                if (cur_Pac_X < 680 + 16 * SPRITE_SCALE) begin
                    cur_Pac_X <= cur_Pac_X + SPRITE_SCALE;
                end else 
                    cur_Pac_X <= 0 - 16 * SPRITE_SCALE;
            end
            if (PAC_DIRECTION == LEFT) begin
                if (cur_Pac_X > (0 - (16 * SPRITE_SCALE))) begin
                    cur_Pac_X <= cur_Pac_X - SPRITE_SCALE;
                end else 
                    cur_Pac_X <= 680 + 16 * SPRITE_SCALE;
            end
            if (PAC_DIRECTION == DOWN) begin
                if (cur_Pac_Y < 480 + 16 * SPRITE_SCALE) begin
                    cur_Pac_Y <= cur_Pac_Y + SPRITE_SCALE;
                end else 
                    cur_Pac_Y <= 0 - 16 * SPRITE_SCALE;
             end
        end
    end
    
endmodule
