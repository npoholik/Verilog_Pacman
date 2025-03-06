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


module Map_Sprite(
    input [4:0] GRID_SELECT,
    input [1:0] ROTATE_SELECT,
    input [1:0] MIRROR_SELECT,
    input [2:0] X_INDEX,
    input [2:0] Y_INDEX,
    output reg [11:0] MAP_COLOR
    );

/************ SPRITE INFORMATION ********/
// We need to declare a sprite for each component of the maze grid 
// Many of these components can be rotated in order to avoid redundancy 

logic [11:0] mapBoundaryCorner [0:7][0:7] = '{   // Use for corner map boundaries 
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h00F, 'h000, 'h000, 'h00F, 'h00F, 'h00F, 'h00F},
    '{'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h00F, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h00F, 'h00F, 'h00F, 'h00F} };

logic [11:0] mapBoundaryWall[0:7][0:7] = '{     // Utilized for vertical map wall boundaries
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000} };

logic [11:0] mapBoundaryHalfT[0:7][0:7] = '{     // Utilize for instances where the boundary border extends into the interior of the map 
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h000, 'h000, 'h000, 'h00F, 'h00F, 'h00F},
    '{'h00F, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h00F, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000} }; 

logic [11:0] mapInteriorWall [0:7][0:7] = '{       // Utilized for defining interior walls of the map 
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000} };

logic [11:0] mapShallowCorner [0:7][0:7] = '{     // Utilized for defining interior corners of the map 
    '{'h000, 'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h00F, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h00F, 'h00F},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000} };

logic [11:0] mapDeepCorner [0:7][0:7] = '{     // Utilized for cases in the map drawing where normal corners would be off by 1 pixel 
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h00F, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h00F, 'h00F, 'h00F},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000} };

logic [11:0] mapBlank [0:7][0:7]= '{       // Represents free space for pacman to move
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000} };

logic [11:0] mapGhostGate [0:7][0:7] = '{       // White gate where the ghosts exit out of in map 
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000},
    '{'hFFF, 'hFFF, 'hFFF, 'hFFF, 'hFFF, 'hFFF, 'hFFF, 'hFFF},
    '{'hFFF, 'hFFF, 'hFFF, 'hFFF, 'hFFF, 'hFFF, 'hFFF, 'hFFF},
    '{'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000, 'h000} };
  

endmodule
