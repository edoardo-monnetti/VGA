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


`timescale 1ns / 100ps


module display_timing (

   input wire clk,                   // pixel clock (25,2 MHz)
   input wire rst,                   // reset
   
   output reg [9:0] sx,              // horizontal screen position 
   output reg [9:0] sy,              // vertical screen position
   output hsync,                     // horizontal sync (31,5 kHz)
   output vsync,                     // vertical sync (60 Hz)
   output enable                     // data enable (low in blanking interval) 
   );
   
   
   
    ////////////////////////////////////////
    //   Generating 25.2 MHz PLL clock    //
    ////////////////////////////////////////
    
    wire clk_pix, pll_locked;        // output clock signals from PLL
    
    PLL  PLL_inst ( .CLK_IN(clk), .CLK_OUT(clk_pix), .LOCKED(pll_locked) ) ;   // generates 25.2 MHz output clock with maximum input-jitter filtering
    
   
   
   
   // Questa parte può essere implementata anche con dei contatori come su fpga4fun
   
    // horizontal timings
    parameter HA_END = 639;           // end of active pixels
    parameter HS_STA = HA_END + 16;   // sync starts after front porch
    parameter HS_END = HS_STA + 96;   // sync ends
    parameter LINE   = 799;           // last pixel on line (after back porch)

    // vertical timings
    parameter VA_END = 479;           // end of active pixels
    parameter VS_STA = VA_END + 10;   // sync starts after front porch
    parameter VS_END = VS_STA + 2;    // sync ends
    parameter SCREEN = 524;           // last line on screen (after back porch)
    
    
    
    ////////////////////////////////////////
    //  Moving the screen position pixel  //
    ////////////////////////////////////////
    
    
    
    always @(posedge clk_pix) begin
        if (sx == LINE) begin  // last pixel on line?
            sx <= 0;
            sy <= (sy == SCREEN) ? 0 : sy + 1;  // last line on screen?
        end 
        else begin
            sx <= sx + 1;
        end
        if (rst) begin
            sx <= 0;
            sy <= 0;
        end
    end
endmodule

