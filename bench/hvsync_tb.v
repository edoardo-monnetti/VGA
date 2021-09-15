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
   wire hsync;
   wire vsync;
   wire [3:0] vga_r;
   wire [3:0] vga_g;
   wire [3:0] vga_b;

   VGA DUT (
       .clk_100(clk_100),
       .rst(rst),
       .hsync(hsync),
       .vsync(vsync),
       .vga_r(vga_r[3:0]),
       .vga_g(vga_g[3:0]),
       .vga_b(vga_b[3:0])
       );
       
       
   ///////////////////////
   //   main stimulus   //
   ///////////////////////
   
   
   initial begin
   
   rst = 1'b1;
   
   #300 rst = 1'b0;
   
   #10000 $finish;   //1'000'000 ns = 1 ms
   
   $display ("T=%0t End of simulation", $realtime); 
   
   end
   
       
endmodule  
