`include "ClockGen.v"

`timescale 10 ns / 1 ns

module hvsync_tb ;


   /////////////////////////////////
   //   100 MHz clock generator   //
   /////////////////////////////////

   wire clk_100 ;

   ClockGen ClockGen_inst ( .clk(clk_100) ) ;


   ///////////////////////////
   //   device under test   //
   ///////////////////////////
   
   
   reg rst;
   wire [9:0] x_count;
   wire [9:0] y_count;
   wire hsync;
   wire vsync;
   wire active_pixel;

   VGA DUT (
       .clk_100(clk_100),
       .rst(rst),
       .hsync(hsync),
       .vsync(vsync),
       .vga_r(vga_r),
       .vga_g(vga_g),
       .vga_b(vga_b)
       );
       
       
   ///////////////////////
   //   main stimulus   //
   ///////////////////////
   
   
   initial begin
   
   rst = 1'b1;
   
   #300 rst = 1'b0;
   
   #100000 $finish;   //1'000'000 ns = 1 ms
   
   $display ("T=%0t End of simulation", $realtime); 
   
   end
   
       
endmodule  
