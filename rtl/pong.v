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
    
    output [3:0] vga_r_out,
    output [3:0] vga_g_out,
    output [3:0] vga_b_out 
);

    localparam [9:0] XMAX = 800;
    localparam [9:0] YMAX = 524;
    localparam [9:0] XRES = 640;
    localparam [9:0] YRES = 480;
    localparam BALL_SIZE = 18;
      
    wire animate = ( sy == YMAX && sx == 0 );
    
    reg [9:0] spx = 10'd2;
    reg [9:0] spy = 10'd2;
    reg dx;
    reg dy;   // 0 = right, down; 1 = left, up
    reg [9:0] bx = 10'd10;
    reg [9:0] by = 10'd100;    
    
    reg b_draw;    // ball drawing enable

    reg control_x;
    reg control_y;
    reg bounce_x = 1'b0;
    reg bounce_y = 1'b0;


    ///////////////////////////////////////////////////
    // Ball animation (during y coordinate blanking) //
    ///////////////////////////////////////////////////
    
    always @(posedge clk_25) begin

        control_x = (bx[9:0] >= XRES - (spx + BALL_SIZE));
        control_y = (by[9:0] >= YRES - (spy + BALL_SIZE));
        
        if (rst) begin
            b_draw <= 1'b0;
            dx <= 1'b0;
            dy <= 1'b0;
        end  
        else begin

            b_draw <= (sx >= bx) && (sx <= bx + BALL_SIZE) && (sy >= by) && (sy <= by + BALL_SIZE);                    
        
            if (animate) begin

                // X-coordinate of the ball
                if (control_x) begin  // right edge
                    dx <= 'b1;
                    bx <= bx - 'b1;
                    bounce_x <= 1'b1;
                end else if (bx < 'b1) begin  // left edge
                    dx <= 'b0;
                    bx <= bx + 'b1;
                    bounce_x <= 1'b1;
                end else begin 
                    bx <= (dx) ? bx - 'b1 : bx + 'b1;
                    bounce_x <= 1'b0;
                end

                // X-coordinate of the ball
                if (control_y) begin  // right edge
                    dy <= 'b1;
                    by <= by - 'b1;
                    bounce_y <= 1'b1; 
                end else if (by < 'b1) begin  // left edge
                    dy <= 'b0;
                    by <= by + 'b1;
                    bounce_y <= 1'b1;
                end else begin
                    by <= (dy) ? by - 'b1 : by + 'b1;
                    bounce_y <= 1'b0;
                end
            end  // if
        end      //else  
    end          // always


    //////////////////////
    // Drawing the ball //  
    ////////////////////// 

    parameter [2:0] RED = 3'b000 ;
    parameter [2:0] ORANGE = 3'b001 ;
    parameter [2:0] YELLOW = 3'b010 ;
    parameter [2:0] GREEN = 3'b011 ;
    parameter [2:0] LIGHT_BLUE = 3'b100;
    parameter [2:0] BLUE = 3'b101 ;
    parameter [2:0] PURPLE = 3'b110 ;

    reg [2:0] STATE, STATE_NEXT ;

    
    /////////////////////
    //  State Counter  //
    /////////////////////

    reg [2:0] state_counter = 3'b0;
    reg state_counter_max = (state_counter == 3'b110);

    always @(posedge clk_25) begin
        if(animate)
            if (bounce_x | bounce_y ) begin
                if (state_counter_max) begin 
                    state_counter <= 3'b0;
                end
                else begin
                    state_counter <= state_counter + 3'b1;
                end
            end  
    end


    ////////////////////////
    //  Next state logic  //
    ////////////////////////

    always @(posedge clk_25) begin

      if(rst)
         STATE <= RED ;

      else
         STATE <= STATE_NEXT ;

    end   // always


    //////////////////////////
    //  Combinational part  //
    //////////////////////////

    reg [3:0] vga_r;
    reg [3:0] vga_g;
    reg [3:0] vga_b;

    always @(posedge clk_25) begin

        case ( STATE )

         RED : begin

            if(state_counter == 3'd1) begin
                STATE_NEXT = ORANGE ;  
            end
            else begin
                vga_r <= 4'hf;
                vga_g <= 4'h0;
                vga_b <= 4'h0;
            end

         end

         //_____________________________
         //

         ORANGE : begin

            if(state_counter == 3'd2) begin
                STATE_NEXT = YELLOW ;
            end
            else begin
                vga_r <= 4'hf;
                vga_g <= 4'h5;
                vga_b <= 4'h0;
            end

         end

         //_____________________________
         //

         YELLOW : begin

            if(state_counter == 3'd3) begin
                STATE_NEXT = GREEN ; 
            end
            else begin
                vga_r <= 4'hf;
                vga_g <= 4'hf;
                vga_b <= 4'h0;
            end

         end

         //_____________________________
         //

         GREEN : begin

            if(state_counter == 3'd4) begin
                STATE_NEXT = LIGHT_BLUE ;
            end
            else begin
                vga_r <= 4'h0;
                vga_g <= 4'hf;
                vga_b <= 4'h0;
            end

         end

         //_____________________________
         //

         LIGHT_BLUE : begin

            if(state_counter == 3'd5) begin
                STATE_NEXT = BLUE ;
            end
            else begin
                vga_r <= 4'h0;
                vga_g <= 4'hf;
                vga_b <= 4'hf;
            end

         end

         //_____________________________
         //

         BLUE : begin

            if(state_counter == 3'd6) begin
                STATE_NEXT = PURPLE ; 
            end
            else begin
                vga_r <= 4'h0;
                vga_g <= 4'h0;
                vga_b <= 4'hf;
            end

         end

         //_____________________________
         //

         PURPLE : begin

            if(state_counter == 3'd0) begin
                STATE_NEXT = RED ;
            end
            else begin
                vga_r <= 4'hf;
                vga_g <= 4'h0;
                vga_b <= 4'hf;
            end

         end

        endcase

   end   // always



    assign  vga_r_out[3:0] = (active_pixel && b_draw) ? vga_r[3:0] : 4'h0;
    assign  vga_g_out[3:0] = (active_pixel && b_draw) ? vga_g[3:0] : 4'h0;
    assign  vga_b_out[3:0] = (active_pixel && b_draw) ? vga_b[3:0] : 4'h0; 


endmodule
