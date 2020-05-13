# create and open the project and set project-level properties
# DEVICE=xc6vlx75t-1ffg484
project new chip.xise
project set family Virtex6
project set device xc6vlx75t
project set package ff484
project set speed -1
# add all the source HDLs and ucf
xfile add ../rtl/chip.v
xfile add ../rtl/picorv32.v ../rtl/top.v ../rtl/simpleuart.v ../rtl/DMAC.v

xfile add ../rtl/eth/axis_adapter.v
xfile add ../rtl/eth/axis_async_fifo.v
xfile add ../rtl/eth/axis_async_fifo_adapter.v
xfile add ../rtl/eth/axis_gmii_rx.v
xfile add ../rtl/eth/axis_gmii_tx.v
xfile add ../rtl/eth/eth_mac_1g.v
xfile add ../rtl/eth/eth_mac_1g_gmii.v
xfile add ../rtl/eth/eth_mac_1g_gmii_fifo.v
xfile add ../rtl/eth/gmii_phy_if.v
xfile add ../rtl/eth/lfsr.v
xfile add ../rtl/eth/oddr.v
xfile add ../rtl/eth/ssio_sdr_in.v
xfile add ../rtl/eth/ssio_sdr_out.v

xfile add ../rtl/chip.bmm
xfile add ../rtl/chip.ucf
xfile add ../rtl/tb_chip.v -view "Simulation"


# set batch application options :
# 1. set synthesis optimization goal to speed
# 2. ignore any LOCs in ngdbuild
# 3. perform timing-driven packing
# 4. use the highest par effort level
# 5. set the par extra effort level
# 6. pass "-instyle xflow" to the par command-line
# 7. generate a verbose report from trce
# 8. create the IEEE 1532 file during bitgen
# project set "Optimization Goal" Speed
# project set "Use LOC Constraints" false
# project set "Place & Route Effort Level (Overall)" High
# project set "Extra Effort (Highest PAR level only)" "Continue on Impossible"
# project set "Report Type" "Verbose Report" -process "Generate Post-Place & Route Static Timing"
# project set "Create IEEE 1532 Configuration File" TRUE
project set "Preferred Language" "verilog"
project set "Simulator" "Modelsim-SE Mixed"
# run the entire xst-to-trce flow
# process run "Implement Design"
# close project
project close