//
// Top module for VGA monitor driver
//


`timescale 10 ns / 1 ns


module VGA (

    input clk_100,
    input rst,
    
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
    
    
    wire active_pixel;
    wire [9:0] x_count;
    wire [9:0] y_count;
    
    
    hvsync_generator hvsync_inst (
    
          .clk_25(clk_25), 
          .rst(rst | (~pll_locked)),
//          .rst(rst),
          .x_count(x_count),
          .y_count(y_count),
          .hsync(hsync),
          .vsync(vsync),
          .active_pixel(active_pixel)
          );
          
          
    ////////////////////////////////////////
    //       generating RGB signals       //
    ////////////////////////////////////////
    
        pong pong_inst (
        
          .clk_25(clk_25), 
          .rst(rst | (~pll_locked)),
          .sx(x_count[9:0]),
          .sy(y_count[9:0]),
          .active_pixel(active_pixel),
          .vga_r_out(vga_r[3:0]),
          .vga_g_out(vga_g[3:0]),
          .vga_b_out(vga_b[3:0])
          );

//        RGB_signal RGB_inst (
//        
//          .clk_25(clk_25), 
//          .x_count(x_count[9:0]),
//          .y_count(y_count[9:0]),
//          .active_pixel(active_pixel),
//          .vga_r(vga_r[3:0]),
//          .vga_g(vga_g[3:0]),
//          .vga_b(vga_b[3:0])
//          );
          
   
endmodule
