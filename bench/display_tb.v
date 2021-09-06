`include "ClockGen.v"

`timescale 1ns / 100ps

module display_tb ;


   /////////////////////////////////
   //   100 MHz clock generator   //
   /////////////////////////////////

   wire clk100 ;

   ClockGen ClockGen_inst ( .clk(clk100) ) ;


   ///////////////////////////
   //   device under test   //
   ///////////////////////////


   wire hsync, vsync;
   reg [9:0] sx;
   reg [9:0] sy;
   reg rst;
   reg enable;

   display_timing  DUT (.clk(clk100), .rst(rst), .hsync(hsync), .vsync(vsync), .sx(sx), .sy(sy), .enable(enable) ) ;



   ///////////////////////
   //   main stimulus   //
   ///////////////////////
   
   
   initial begin
   
   rst = 1'b1;
   
   #300 rst = 1'b0;
   
   #200000 $finish;
   
   end
   
   
endmodule
