`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2025 02:57:10 PM
// Design Name: 
// Module Name: Controller
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


module Controller #(parameter SPRITE_SCALE = 2,
                    FONT_SCALE = 2,
                    UP = 0,
                    DOWN = 3,
                    LEFT = 2,
                    RIGHT = 1)
    (
    input m_CLK,
    input SW_up, SW_left, SW_right, SW_down,
    output reg [11:0] VGA_RGB, 
    output reg HS, VS,
    output reg [15:0] debug
    );
    
    
//******************************************
/*** Clock divider ***/
    wire CLK;
    Clock_Divider u_VGA_CLK(m_CLK, CLK);
    

//******************************************
/**** HANDLE BUTTON INPUTS ***/
    reg[3:0] cursor;
    reg[1:0] pac_Direction;
    
    Button btn_up(SW_up, CLK, cursor[0]);
    Button btn_left(SW_left, CLK, cursor[1]);
    Button btn_right(SW_right, CLK, cursor[2]);
    Button btn_down(SW_down, CLK, cursor[3]); 
    
    // Direction chooser 
    always @(posedge CLK) begin
        if(cursor[0]) pac_Direction = UP;
        else if (cursor[1]) pac_Direction = LEFT; 
        else if (cursor[2]) pac_Direction = RIGHT;
        else if (cursor[3]) pac_Direction = DOWN;
    end 
    

//******************************************
/*** Initialize VGA module and use it to keep track of screen position ***/
    reg signed [10:0] x_VGA, y_VGA;
    VGA u_VGA(CLK, HS, VS, x_VGA, y_VGA);
    

//******************************************    
/*** Track sprite position and RGB values ***/
    reg signed [10:0] x_Pac, y_Pac;
    reg [2:0] pac_Frame;
    
    Color_Chooser #(.SPRITE_SCALE(SPRITE_SCALE), .UP(UP), .DOWN(DOWN), .LEFT(LEFT), .RIGHT(RIGHT)) 
    color (x_VGA, y_VGA, x_Pac, y_Pac, pac_Direction, pac_Frame, VGA_RGB);
    
    reg [3:0] frameCount; 
    
    
    // This will handle movement + frame information 
    always @(posedge CLK) begin 
        if (y_VGA == 0 && x_VGA == 0) begin
            if (frameCount == 1) begin
            
                // Update sprites 
                if(pac_Frame == 3) pac_Frame <= 0;
                else pac_Frame <= pac_Frame + 1;
                
                frameCount <= 0;
            end
            frameCount <= frameCount + 1; 
            
            
            if (pac_Direction == UP) begin
                if (y_Pac > 0 - 16 * SPRITE_SCALE) begin
                    y_Pac <= y_Pac - SPRITE_SCALE;
                end else 
                    y_Pac <= 480 + 16 * SPRITE_SCALE;
            end
            if (pac_Direction == RIGHT) begin
                if (x_Pac < 680 + 16 * SPRITE_SCALE) begin
                    x_Pac <= x_Pac + SPRITE_SCALE;
                end else 
                    x_Pac <= 0 - 16 * SPRITE_SCALE;
            end
            if (pac_Direction == LEFT) begin
                if (x_Pac > (0 - (16 * SPRITE_SCALE))) begin
                    x_Pac <= x_Pac - SPRITE_SCALE;
                end else 
                    x_Pac <= 680 + 16 * SPRITE_SCALE;
            end
            if (pac_Direction == DOWN) begin
                if (y_Pac < 480 + 16 * SPRITE_SCALE) begin
                    y_Pac <= y_Pac + SPRITE_SCALE;
                end else 
                    y_Pac <= 0 - 16 * SPRITE_SCALE;
             end
             
             debug <= x_Pac;
        end
    end
    
    
   
endmodule
