###############
##   units   ##
###############

## just for reference, these are already default units
#set_units -time          ns
#set_units -voltage       V
#set_units -power         mW
#set_units -capacitance   pF


################################
##   electrical constraints   ##
################################

## voltage configurations
set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]


#############################################
##   physical constraints (port mapping)   ##
#############################################

## on-board 100 MHz clock
##set_property -dict [list PACKAGE_PIN E3 IOSTANDARD LVCMOS33] [get_ports clk_25]
set_property -dict [list PACKAGE_PIN E3 IOSTANDARD LVCMOS33] [get_ports clk_100]


## reset on BTN0
set_property -dict [list PACKAGE_PIN D9 IOSTANDARD LVCMOS33] [get_ports rst]


########################
##   Pmod Header JB   ##
########################

set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { vga_r[0] }]   ; #IO_L11P_T1_SRCC_15 Sch=jb_p[1]
set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { vga_r[1] }]   ; #IO_L11N_T1_SRCC_15 Sch=jb_n[1]
set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { vga_r[2] }]   ; #IO_L12P_T1_MRCC_15 Sch=jb_p[2]
set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { vga_r[3] }]   ; #IO_L12N_T1_MRCC_15 Sch=jb_n[2]
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { vga_b[0] }]   ; #IO_L23P_T3_FOE_B_15 Sch=jb_p[3]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { vga_b[1] }]   ; #IO_L23N_T3_FWE_B_15 Sch=jb_n[3]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { vga_b[2] }]   ; #IO_L24P_T3_RS1_15 Sch=jb_p[4]
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { vga_b[3] }]   ; #IO_L24N_T3_RS0_15 Sch=jb_n[4]


########################
##   Pmod Header JC   ##
########################

set_property -dict { PACKAGE_PIN U12  IOSTANDARD LVCMOS33 } [get_ports { vga_g[0] }]   ; #IO_L20P_T3_A08_D24_14 Sch=jc_p[1]
set_property -dict { PACKAGE_PIN V12  IOSTANDARD LVCMOS33 } [get_ports { vga_g[1] }]   ; #IO_L20N_T3_A07_D23_14 Sch=jc_n[1]
set_property -dict { PACKAGE_PIN V10  IOSTANDARD LVCMOS33 } [get_ports { vga_g[2] }]   ; #IO_L21P_T3_DQS_14 Sch=jc_p[2]
set_property -dict { PACKAGE_PIN V11  IOSTANDARD LVCMOS33 } [get_ports { vga_g[3] }]   ; #IO_L21N_T3_DQS_A06_D22_14 Sch=jc_n[2]
set_property -dict { PACKAGE_PIN U14  IOSTANDARD LVCMOS33 } [get_ports {   hsync  }]   ; #IO_L22P_T3_A05_D21_14 Sch=jc_p[3]
set_property -dict { PACKAGE_PIN V14  IOSTANDARD LVCMOS33 } [get_ports {   vsync  }]   ; #IO_L22N_T3_A04_D20_14 Sch=jc_n[3]


############################
##   timing constraints   ##
############################

## create a 100 MHz clock signal with 50% duty cycle for reg2reg Static Timing Analysis (STA)
create_clock -period 10.000 -name clk100 -waveform {0.000 5.000} -add [get_ports clk_100]
##create_clock -period 10.000 -name clk100 -waveform {0.000 5.000} -add [get_ports clk_25]


################################
##   additional constraints   ##
################################

##
## additional XDC statements to optimize the memory configuration file (.bin)
## to program the external 128 Mb Quad Serial Peripheral Interface (SPI) flash
## memory in order to automatically load the FPGA configuration at power-up
##

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4  [current_design]
set_property CONFIG_MODE SPIx4  [current_design]

