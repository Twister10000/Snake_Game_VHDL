#************************************************************
# THIS IS A WIZARD-GENERATED FILE.                           
#
# Version 13.1.0 Build 162 10/23/2013 SJ Web Edition
#
#************************************************************

# Copyright (C) 1991-2013 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.



# Clock constraints

create_clock -name "clk" -period 20.000ns [get_ports {clk}] -waveform {0.000 10.000}

set vga_clk { \PLL:PLL1|altpll_component|auto_generated|pll1|clk[0] } 


# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

# tsu/th constraints

set_input_delay -clock $vga_clk -max 0ns [get_ports {BTN_LEFT BTN_RIGHT Reset}] 
set_input_delay -clock $vga_clk -min 0.000ns [get_ports {BTN_LEFT BTN_RIGHT Reset}] 


# tco constraints

set_output_delay -clock $vga_clk -max 0ns [get_ports { B[3] B[2] B[1] B[0] G* R[3] R[2] R[1] R[0] Segment0* Segment1* Segment2* Segment3* vsync_top hsync_top}] 
set_output_delay -clock $vga_clk -min -0.000ns [get_ports { B[3] B[2] B[1] B[0] G* R[3] R[2] R[1] R[0] Segment0* Segment1* Segment2* Segment3* vsync_top hsync_top}] 


# tpd constraints

