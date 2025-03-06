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
    
    //*** Use assert to compare the divided clock to the 25.175MHz required for 640x480 VGA @ 60 Hertz *** //
        property check_period;
            realtime cur_time;
            realtime diff;
            (1, cur_time = $realtime) // for 1st change, store the current time)
            ##1 // wait for the next change
            (1, diff = $realtime - cur_time) // Store the difference of the times
            ##0 // Simultaneously perform next step (checking the distance)
            diff >= 39ns && diff <= 41ns;     // 25.175 MHz should be ~40 ns, we are giving a grace of +/- 1ns
        endproperty 
    check_period_VGA: assert property (@(posedge CLK) check_period) $display ("Stable VGA Clock Achieved. Period: %f", diff);
        else $warning ("Unstable VGA Clock Detected. Period: %f", diff);

//******************************************
/**** HANDLE BUTTON INPUTS ***/
    reg[3:0] cursor;
    reg[1:0] pac_Direction;
    
    Button btn_up(SW_up, m_CLK, cursor[0]);
    Button btn_left(SW_left, m_CLK, cursor[1]);
    Button btn_right(SW_right, m_CLK, cursor[2]);
    Button btn_down(SW_down, m_CLK, cursor[3]); 
    
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
    reg [5:0] grid_Type;
    
    // Module for initializing map and obtaining GRID_TYPE for a giving 8x8 grid on map 
    Map_Access map(x_VGA, y_VGA, grid_Type);
    
    // Module for actually drawing sprite information 
    Color_Chooser #(.SPRITE_SCALE(SPRITE_SCALE), .UP(UP), .DOWN(DOWN), .LEFT(LEFT), .RIGHT(RIGHT)) 
    color (x_VGA, y_VGA, x_Pac, y_Pac, pac_Direction, pac_Frame, VGA_RGB);
    
    // Module for tracking movement of Pacman 
    Pac_Move #(.SPRITE_SCALE(SPRITE_SCALE), .UP(UP),.DOWN(DOWN),.LEFT(LEFT),.RIGHT(RIGHT))
    pac_move(CLK, x_VGA, y_VGA, pac_Direction, x_Pac, y_Pac, pac_Frame);
   
endmodule
