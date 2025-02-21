`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2025 04:03:04 PM
// Design Name: 
// Module Name: Color_Chooser
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


module Color_Chooser #(BACKGROUND = 'h002,
                       SPRITE_SCALE,
                       UP, DOWN, LEFT, RIGHT)
    (
    input signed [10:0] x_VGA, y_VGA,
    input signed [10:0] x_Pac, y_Pac, 
    input [1:0] pac_Direction, 
    input reg [2:0] pac_Frame,
    output reg [11:0] PIX_COLOR
    );
    
//************************
/*** INITIALIZE SPRITES ***/ 
reg [3:0] pac_Col, pac_Row;
reg [11:0] pac_RGB;
Pac_Sprite pacman(pac_Col, pac_Row, pac_Frame, pac_RGB);


//************************
/*** Check positions and choose color **/
	// color chooser
	always @(*) begin
    	if(~(x_VGA > 639 || y_VGA > 479)) begin
        	
        	// Check for the bounds of pacman within the drawing of the screen (scaled up by n)
        	// We will draw Pacman out from the center of his x,y position 
        	if ((x_VGA > x_Pac - 8 * SPRITE_SCALE && x_VGA <= x_Pac + 8 * SPRITE_SCALE) 
        	     && (y_VGA > y_Pac - 8 * SPRITE_SCALE && y_VGA <= y_Pac + 8 * SPRITE_SCALE)) begin 

					// This will draw pacman facing right
					if (pac_Direction == RIGHT) begin 
                	   pac_Col =  (((((8*SPRITE_SCALE)-1) + y_VGA) - y_Pac) >> (SPRITE_SCALE/2));
                	   pac_Row =  (((((8*SPRITE_SCALE)-1) + x_VGA) - x_Pac) >> (SPRITE_SCALE/2));
                	end
                	
                	
                	// This will draw pacman facing right 
                	if (pac_Direction == LEFT) begin 
                	   pac_Col =  (((((8*SPRITE_SCALE)-1) + y_VGA) - y_Pac) >> (SPRITE_SCALE/2));
                	   pac_Row =  (8 * SPRITE_SCALE - 1) - (((((8*SPRITE_SCALE)-1) + x_VGA) - x_Pac) >> (SPRITE_SCALE/2));
                	end 
                	
                	// This will draw pacman facing up
                	if (pac_Direction == DOWN) begin 
                	   pac_Col =  (((((8*SPRITE_SCALE)-1) + x_VGA) - x_Pac) >> (SPRITE_SCALE/2));
                	   pac_Row =  (((((8*SPRITE_SCALE)-1) + y_VGA) - y_Pac) >> (SPRITE_SCALE/2));
                	end
      
                	// This will draw pacman facing down
                	if (pac_Direction == UP) begin 
                	   pac_Col =  (((((8*SPRITE_SCALE)-1) + x_VGA) - x_Pac) >> (SPRITE_SCALE/2));
                	   pac_Row =  (8 * SPRITE_SCALE - 1) - (((((8*SPRITE_SCALE)-1) + y_VGA) - y_Pac) >> (SPRITE_SCALE/2));
                	end 

				// Only draw non-transparent aspects of the sprite
            	if(~(pac_RGB == 0)) begin
                	PIX_COLOR <= pac_RGB;
            	end else begin
                	PIX_COLOR <= BACKGROUND;
            	end
            	
            	
			// If not within Pacman's bounds, simply draw the background
        	end else begin 
            	PIX_COLOR <= BACKGROUND;
        	end
        	

    	end else begin  	// Avoid driving color when outside drawable area
        	PIX_COLOR <= 4'b0000;
    	end
	end
	
endmodule
