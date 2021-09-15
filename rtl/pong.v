//
// Code for pong game with RGB signals generation
//

`timescale 10 ns/ 1 ns

module pong (    // ball size in pixels

    input clk_25,
    input [9:0] sx,
    input [9:0] sy,
    input active_pixel,
    input rst,
    
    output reg [3:0] vga_r,
    output reg [3:0] vga_g,
    output reg [3:0] vga_b    
);

    localparam [9:0] XMAX = 800;
    localparam [9:0] YMAX = 524;
    localparam [9:0] XRES = 640;
    localparam [9:0] YRES = 480;
    localparam BALL_SIZE = 8;
      
    wire animate = ( sy == YMAX && sx == 0 );
    
    reg [9:0] spx = 1;
    reg [9:0] spy = 1;
    reg dx;
    reg dy;   // 0 = right, down; 1 = left, up
    reg [9:0] bx = 0;
    reg [9:0] by = 0;    
    
    reg b_draw;    // ball drawing enable

    reg control_x;
    reg control_y;
    
    // ball animation during y coordinate blanking
    
    always @(posedge clk_25) begin

        control_x = (bx[9:0] >= XRES - (spx + BALL_SIZE));
        control_y = (by[9:0] >= YRES - (spy + BALL_SIZE));
        
        if (rst) begin
            vga_r <= 4'h0;
            vga_g <= 4'h0;
            vga_b <= 4'h0;
            b_draw <= 0;
            dx <= 0;
            dy <= 0;
        end  
        else begin

            b_draw <= (sx >= bx) && (sx <= bx + BALL_SIZE) && (sy >= by) 
                      && (sy <= sy + BALL_SIZE);                    
        
            if (animate) begin

                // X-coordinate of the ball
                if (control_x) begin  // right edge
                    dx <= 1;
                    bx <= bx - 1;
                end else if (bx < 1) begin  // left edge
                    dx <= 0;
                    bx <= bx + 1;
                end else bx <= (dx) ? bx - 1 : bx + 1;

                // X-coordinate of the ball
                if (control_y) begin  // right edge
                    dy <= 1;
                    by <= by - 1;
                end else if (by < 1) begin  // left edge
                    dy <= 0;
                    by <= by + 1;
                end else by <= (dy) ? by - 1 : by + 1;
            end

            // Drawing the ball           
            vga_r <= (active_pixel && b_draw) ? 4'hF : 4'h0;
            vga_g <= (active_pixel && b_draw) ? 4'hF : 4'h0;
            vga_b <= (active_pixel && b_draw) ? 4'hF : 4'h0; 

        end    
    end

endmodule
