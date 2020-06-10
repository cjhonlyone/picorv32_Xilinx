# XDC constraints
# part: xc7z030fbg676-2

# General configuration

# System clocks
# 50 MHz
set_property -dict {LOC AC23 IOSTANDARD LVCMOS33} [get_ports PL_CLK]
create_clock -period 20.000 -name clk_50mhz [get_ports PL_CLK]

# Reset button
set_property -dict {LOC AC24  IOSTANDARD LVCMOS33} [get_ports PL_RESET]

# LEDs
set_property -dict {LOC W18  IOSTANDARD LVCMOS33} [get_ports {F_LED[0]}]
set_property -dict {LOC V18  IOSTANDARD LVCMOS33} [get_ports {F_LED[1]}]
set_property -dict {LOC Y18  IOSTANDARD LVCMOS33} [get_ports {F_LED[2]}]
set_property -dict {LOC W19  IOSTANDARD LVCMOS33} [get_ports {F_LED[3]}]

# Gigabit Ethernet SGMII PHY
set_property -dict {LOC AB4} [get_ports phy_sgmii_rx_p]
set_property -dict {LOC AB3} [get_ports phy_sgmii_rx_n]
set_property -dict {LOC AA2} [get_ports phy_sgmii_tx_p]
set_property -dict {LOC AA1} [get_ports phy_sgmii_tx_n]
set_property -dict {LOC U6 } [get_ports phy_sgmii_clk_p]
set_property -dict {LOC U5 } [get_ports phy_sgmii_clk_n]

create_clock -period 8.000 -name phy_gtx_clk [get_ports phy_sgmii_clk_p]

set_property -dict {LOC AF12 IOSTANDARD LVCMOS33} [get_ports phy_reset_n]