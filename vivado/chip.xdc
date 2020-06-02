# XDC constraints for the Xilinx KC705 board
# part: xc7k325tffg900-2

# General configuration

# System clocks
# 200 MHz
set_property -dict {LOC AD12 IOSTANDARD LVDS} [get_ports FCLKIN_P]
set_property -dict {LOC AD11 IOSTANDARD LVDS} [get_ports FCLKIN_N]
create_clock -period 8.000 -name clk_125mhz [get_ports FCLKIN_N]

create_clock -period 2.5 -name clk CLK_OUT1

# LEDs
set_property -dict {LOC AB8  IOSTANDARD LVCMOS15 SLEW SLOW DRIVE 12} [get_ports {F_LED[0]}]
set_property -dict {LOC AA8  IOSTANDARD LVCMOS15 SLEW SLOW DRIVE 12} [get_ports {F_LED[1]}]
set_property -dict {LOC AC9  IOSTANDARD LVCMOS15 SLEW SLOW DRIVE 12} [get_ports {F_LED[2]}]
set_property -dict {LOC AB9  IOSTANDARD LVCMOS15 SLEW SLOW DRIVE 12} [get_ports {F_LED[3]}]

# Reset button
set_property -dict {LOC AB7  IOSTANDARD LVCMOS15} [get_ports FPGA_RESET]

# Gigabit Ethernet GMII PHY
set_property -dict {LOC U27  IOSTANDARD LVCMOS25} [get_ports PHY_RXCLK]
set_property -dict {LOC U30  IOSTANDARD LVCMOS25} [get_ports {PHY_RXD[0]}]
set_property -dict {LOC U25  IOSTANDARD LVCMOS25} [get_ports {PHY_RXD[1]}]
set_property -dict {LOC T25  IOSTANDARD LVCMOS25} [get_ports {PHY_RXD[2]}]
set_property -dict {LOC U28  IOSTANDARD LVCMOS25} [get_ports {PHY_RXD[3]}]
set_property -dict {LOC R19  IOSTANDARD LVCMOS25} [get_ports {PHY_RXD[4]}]
set_property -dict {LOC T27  IOSTANDARD LVCMOS25} [get_ports {PHY_RXD[5]}]
set_property -dict {LOC T26  IOSTANDARD LVCMOS25} [get_ports {PHY_RXD[6]}]
set_property -dict {LOC T28  IOSTANDARD LVCMOS25} [get_ports {PHY_RXD[7]}]
set_property -dict {LOC R28  IOSTANDARD LVCMOS25} [get_ports PHY_RXCTL_RXDV]
set_property -dict {LOC V26  IOSTANDARD LVCMOS25} [get_ports PHY_RXER]

set_property -dict {LOC K30  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports PHY_TXC_GTXCLK]
set_property -dict {LOC M28  IOSTANDARD LVCMOS25} [get_ports PHY_TXCLK]

set_property -dict {LOC N27  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {PHY_TXD[0]}]
set_property -dict {LOC N25  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {PHY_TXD[1]}]
set_property -dict {LOC M29  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {PHY_TXD[2]}]
set_property -dict {LOC L28  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {PHY_TXD[3]}]
set_property -dict {LOC J26  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {PHY_TXD[4]}]
set_property -dict {LOC K26  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {PHY_TXD[5]}]
set_property -dict {LOC L30  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {PHY_TXD[6]}]
set_property -dict {LOC J28  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports {PHY_TXD[7]}]
set_property -dict {LOC M27  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports PHY_TXCTL_TXEN]
set_property -dict {LOC N29  IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports PHY_TXER]
set_property -dict {LOC L20  IOSTANDARD LVCMOS25 SLEW SLOW DRIVE 12} [get_ports PHY_RESET]

#set_property -dict {LOC N30  IOSTANDARD LVCMOS25} [get_ports phy_int_n]
#set_property -dict {LOC J21  IOSTANDARD LVCMOS25 SLEW SLOW DRIVE 12} [get_ports phy_mdio]
#set_property -dict {LOC R23  IOSTANDARD LVCMOS25 SLEW SLOW DRIVE 12} [get_ports phy_mdc]

create_clock -period 8.000 -name phy_gtx_clk [get_ports PHY_TXC_GTXCLK]
create_clock -period 8.000 -name phy_rx_clk [get_ports PHY_RXCLK]

