//
// Top module for VGA monitor driver
//


`timescale 10 ns / 1 ns


module VGA (

    input clk_100,
    input rst,
    
    output active_pixel,
    output [9:0] x_count,
    output [9:0] y_count,
    
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b,
    
    output hsync,
    output vsync

);


   
    ////////////////////////////////////////
    //   Generating 25.2 MHz PLL clock    //
    ////////////////////////////////////////
    
    wire clk_25, pll_locked;        // output clock signals from PLL
    
    PLL  PLL_inst ( .CLK_IN(clk_100), .CLK_OUT(clk_25), .LOCKED(pll_locked) ) ;   // generates 25.2 MHz output clock with maximum input-jitter filtering
    
    
    
    ////////////////////////////////////////
    //      generating hsync & vsync      //
    ////////////////////////////////////////
    
    
//    wire active_pixel;
//    wire [9:0] x_count;
//    wire [9:0] y_count;
    
    
    hvsync_generator hvsync_inst (
    
          .clk_25(clk_25), 
          .x_count(x_count),
          .y_count(y_count),
          .hsync(hsync),
          .vsync(vsync),
          .active_pixel(active_pixel)
          );
          
          
    ////////////////////////////////////////
    //       generating RGB signals       //
    ////////////////////////////////////////
    
    RGB_signal RGB_inst (
        
          .clk_25(clk_25), 
          .x_count(x_count),
          .y_count(y_count),
          .active_pixel(active_pixel),
          .vga_r(vga_r),
          .vga_g(vga_g),
          .vga_b(vga_b)
          );
          
   
endmodule
