//
//  Generator for hsync and vsync with counters
//
//
//    Display timing values for 480p VGA
//
//    640x480 Timings      HOR    VER
//    -------------------------------
//    Active Pixels        640    480
//    Front Porch           16     10
//    Sync Width            96      2
//    Back Porch            48     33
//    Blanking Total       160     45
//    Total Pixels         800    525
//    Sync Polarity        neg    neg


`timescale 10 ns / 1 ns

module hvsync_generator (

       input clk_25,
       input rst,
       
       output reg [9:0] x_count = 10'd630,
       output reg [9:0] y_count = 10'd523,
       output hsync,
       output vsync,
       output active_pixel
);
       
       wire xmax = (x_count == 'd799);  // end of line
       wire ymax = (y_count == 'd524);  // end of screen
       
    ////////////////////////////////////////
    //  Moving the screen position pixel  //
    ////////////////////////////////////////
       
       always @(posedge clk_25) begin  
            if (xmax) begin
               x_count <= 'b0;
               if (ymax) begin
                   y_count <= 0;
               end 
               else begin
                   y_count <= y_count + 'b1;
               end
           end 
           else begin
               x_count <= x_count + 'b1;
            end
       end  

       
       
    ////////////////////////////////////////
    //      generating hsync & vsync      //
    ////////////////////////////////////////
    
               
        assign   hsync = ~((x_count > 639 + 16) && (x_count < 639 + 16 + 96));  //active for 96 clks after front porch (16 clks)
        assign   vsync = ~((y_count > 479 + 10) && (y_count < 479 + 10 + 2));   //active for 2 clks after front porch (10 clks)
        assign   active_pixel = ((x_count < 640) && (y_count < 480)); 


endmodule
