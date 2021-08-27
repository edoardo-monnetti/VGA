// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Fri Aug 27 17:32:52 2021
// Host        : edoardo-MacBookAir running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub /home/edoardo/Desktop/VGA_project/cores/PLL/PLL_stub.v
// Design      : PLL
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module PLL(CLK_OUT, LOCKED, CLK_IN)
/* synthesis syn_black_box black_box_pad_pin="CLK_OUT,LOCKED,CLK_IN" */;
  output CLK_OUT;
  output LOCKED;
  input CLK_IN;
endmodule
