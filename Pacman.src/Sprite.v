`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2025 11:21:25 AM
// Design Name: 
// Module Name: Sprite
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


module Sprite(
    input [3:0] x,
    input [3:0] y,
    input [1:0] select,
    output reg [11:0] rgb
    );
    
      /************ SPRITE INFORMATION ********/
    // We need a 14x13 matrix with 12 bits of color data in each cell 
            // This is very small for a 640x480 screen, but the main VGA output can adjust the sprite information to enlarge it by a multiplier 
    // There will be three total frames for pacman's sprite
    //reg [11:0] frame1[0:3][0:3];
   // reg [11:0] frame1[0:3][0:3];
    
    // 12 bit elements with 16 rows and 16 columns
    logic [11:0] frame1[0:15][0:15] = '{ 
        '{ 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 } };
    
    
    logic [11:0] frame2[0:15][0:15] = '{
        '{ 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 } };
    
    
    logic [11:0] frame3[0:15][0:15] = '{
        '{ 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 },
        '{ 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 } };
        
        
    // Initialize the data in each frame      
/*    initial begin
    
        { frame1[0][0],frame1[1][0],frame1[2][0],frame1[3][0],frame1[4][0],frame1[5][0],frame1[6][0],frame1[7][0],frame1[8][0], frame1[9][0],frame1[10][0], frame1[11][0], frame1[12][0], frame1[13][0], frame1[14][0], frame1[15][0] } = { 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 };
        { frame1[0][1],frame1[1][1],frame1[2][1],frame1[3][1],frame1[4][1],frame1[5][1],frame1[6][1],frame1[7][1],frame1[8][1], frame1[9][1],frame1[10][1], frame1[11][1], frame1[12][1], frame1[13][1], frame1[14][1], frame1[15][1] } = { 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 };
        { frame1[0][2],frame1[1][2],frame1[2][2],frame1[3][2],frame1[4][2],frame1[5][2],frame1[6][2],frame1[7][2],frame1[8][2], frame1[9][2],frame1[10][2], frame1[11][2], frame1[12][2], frame1[13][2], frame1[14][2], frame1[15][2] } = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 };
        { frame1[0][3],frame1[1][3],frame1[2][3],frame1[3][3],frame1[4][3],frame1[5][3],frame1[6][3],frame1[7][3],frame1[8][3], frame1[9][3],frame1[10][3], frame1[11][3], frame1[12][3], frame1[13][3], frame1[14][3], frame1[15][3] } = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        { frame1[0][4],frame1[1][4],frame1[2][4],frame1[3][4],frame1[4][4],frame1[5][4],frame1[6][4],frame1[7][4],frame1[8][4], frame1[9][4],frame1[10][4], frame1[11][4], frame1[12][4], frame1[13][4], frame1[14][4], frame1[15][4] } = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        { frame1[0][5],frame1[1][5],frame1[2][5],frame1[3][5],frame1[4][5],frame1[5][5],frame1[6][5],frame1[7][5],frame1[8][5], frame1[9][5],frame1[10][5], frame1[11][5], frame1[12][5], frame1[13][5], frame1[14][5], frame1[15][5] } = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        { frame1[0][6],frame1[1][6],frame1[2][6],frame1[3][6],frame1[4][6],frame1[5][6],frame1[6][6],frame1[7][6],frame1[8][6], frame1[9][6],frame1[10][6], frame1[11][6], frame1[12][6], frame1[13][6], frame1[14][6], frame1[15][6] } = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        { frame1[0][7],frame1[1][7],frame1[2][7],frame1[3][7],frame1[4][7],frame1[5][7],frame1[6][7],frame1[7][7],frame1[8][7], frame1[9][7],frame1[10][7], frame1[11][7], frame1[12][7], frame1[13][7], frame1[14][7], frame1[15][7] } = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        { frame1[0][8],frame1[1][8],frame1[2][8],frame1[3][8],frame1[4][8],frame1[5][8],frame1[6][8],frame1[7][8],frame1[8][8], frame1[9][8],frame1[10][8], frame1[11][8], frame1[12][8], frame1[13][8], frame1[14][8], frame1[15][8] } = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        { frame1[0][9],frame1[1][9],frame1[2][9],frame1[3][9],frame1[4][9],frame1[5][9],frame1[6][9],frame1[7][9],frame1[8][9], frame1[9][9],frame1[10][9], frame1[11][9], frame1[12][9], frame1[13][9], frame1[14][9], frame1[15][9] } = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 };
        { frame1[0][10],frame1[1][10],frame1[2][10],frame1[3][10],frame1[4][10],frame1[5][10],frame1[6][10],frame1[7][10],frame1[8][10], frame1[9][10],frame1[10][10], frame1[11][10], frame1[12][10], frame1[13][10], frame1[14][10], frame1[15][10] } = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 };
        { frame1[0][11],frame1[1][11],frame1[2][11],frame1[3][11],frame1[4][11],frame1[5][11],frame1[6][11],frame1[7][11],frame1[8][11], frame1[9][11],frame1[10][11], frame1[11][11], frame1[12][11], frame1[13][11], frame1[14][11], frame1[15][11] } = { 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 };
        { frame1[0][12],frame1[1][12],frame1[2][12],frame1[3][12],frame1[4][12],frame1[5][12],frame1[6][12],frame1[7][12],frame1[8][12], frame1[9][12],frame1[10][12], frame1[11][12], frame1[12][12], frame1[13][12], frame1[14][12], frame1[15][12] } = { 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 };
        { frame1[0][13],frame1[1][13],frame1[2][13],frame1[3][13],frame1[4][13],frame1[5][13],frame1[6][13],frame1[7][13],frame1[8][13], frame1[9][13],frame1[10][13], frame1[11][13], frame1[12][13], frame1[13][13], frame1[14][13], frame1[15][13] } = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        { frame1[0][14],frame1[1][14],frame1[2][14],frame1[3][14],frame1[4][14],frame1[5][14],frame1[6][14],frame1[7][14],frame1[8][14], frame1[9][14],frame1[10][14], frame1[11][14], frame1[12][14], frame1[13][14], frame1[14][14], frame1[15][14] } = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        { frame1[0][15],frame1[1][15],frame1[2][15],frame1[3][15],frame1[4][15],frame1[5][15],frame1[6][15],frame1[7][15],frame1[8][15], frame1[9][15],frame1[10][15], frame1[11][15], frame1[12][15], frame1[13][15], frame1[14][15], frame1[15][15] } = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };

    
        frame1[0]  = { 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame1[1]  = { 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 };
        frame1[2]  = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 };
        frame1[3]  = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 };
        frame1[4]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        frame1[5]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        frame1[6]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        frame1[7]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        frame1[8]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000 };
        frame1[9]  = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 };
        frame1[10] = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 };
        frame1[11] = { 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 };
        frame1[12] = { 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame1[13] = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame1[14] = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame1[15] = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        
        // FRAME 2
        frame2[0]  = { 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame2[1]  = { 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 };
        frame2[2]  = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 };
        frame2[3]  = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 };
        frame2[4]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 };
        frame2[5]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame2[6]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame2[7]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame2[8]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 };
        frame2[9]  = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000 };
        frame2[10] = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000 };
        frame2[11] = { 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000 };
        frame2[12] = { 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame2[13] = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame2[14] = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame2[15] = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        
        // FRAME 3
        frame3[0]  = { 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[1]  = { 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[2]  = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[3]  = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[4]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[5]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[6]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[7]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[8]  = { 'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[9]  = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[10] = { 'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[11] = { 'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[12] = { 'h000,'h000,'h000,'h000,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'hFF0,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[13] = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[14] = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
        frame3[15] = { 'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000,'h000 };
    end
    
        */
        
    always @(*) begin
        if (select == 0) 
            rgb <= frame1[x][y];
        else if (select == 1)
            rgb <= frame2[x][y];
        else if (select == 2);
            rgb = frame3[x][y];
    end
        
endmodule
