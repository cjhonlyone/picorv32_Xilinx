# STEP#1: define the output directory area.
#
set outputDir ./_output
set top_module chip
set DEVICE xc7z030fbg676-2

file mkdir $outputDir

set_param general.maxThreads 8

#
# STEP#2: setup design sources and constraints
#
# read_vhdl -library bftLib [ glob ./Sources/hdl/bftLib/*.vhdl ]

read_verilog ../rtl/chip.v
read_verilog ../rtl/DMAC.v
read_verilog ../rtl/picorv32.v
read_verilog ../rtl/top.v

read_verilog ../rtl/eth/axis_adapter.v
read_verilog ../rtl/eth/axis_async_fifo_adapter.v
read_verilog ../rtl/eth/axis_async_fifo.v
read_verilog ../rtl/eth/eth_mac_1g.v
read_verilog ../rtl/eth/axis_gmii_rx.v
read_verilog ../rtl/eth/axis_gmii_tx.v
read_verilog ../rtl/eth/lfsr.v

# read_verilog ../rtl/eth/eth_mac_1g_fifo.v
# read_verilog ../rtl/eth/eth_mac_1g_gmii_fifo.v
# read_verilog ../rtl/eth/ssio_sdr_in.v
# read_verilog ../rtl/eth/eth_mac_1g_gmii.v
# read_verilog ../rtl/eth/gmii_phy_if.v
# read_verilog ../rtl/eth/oddr.v
# read_verilog ../rtl/eth/ssio_sdr_out.v

read_verilog ../rtl/uart/fifo.v
read_verilog ../rtl/uart/uart.v
read_verilog ../rtl/uart/uart_fifo.v
read_verilog ../rtl/uart/uart_top.v

# read an IP customization
read_ip ./ip/gig_ethernet_pcs_pma_0.xci

report_ip_status
upgrade_ip [get_ips *]

generate_target all [get_files *gig_ethernet_pcs_pma_0.xci]
# synth_ip [get_files *gig_ethernet_pcs_pma_0.xci]
get_files -all -of_objects [get_files *gig_ethernet_pcs_pma_0.xci]

# add_files -fileset sim_1 ../rtl/tb_chip.v

read_xdc ./chip.xdc 
read_xdc ./chip_mmi.xdc
read_xdc ./axis_async_fifo.tcl

#
# STEP#3: run synthesis, write design checkpoint, report timing,
# and utilization estimates
#

synth_design -top $top_module -part $DEVICE
# write_checkpoint -force $outputDir/post_synth.dcp
# report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
# report_utilization -file $outputDir/post_synth_util.rpt
#
# Run custom script to report critical timing paths
# reportCriticalPaths $outputDir/post_synth_critpath_report.csv
#
# STEP#4: run logic optimization, placement and physical logic optimization,
# write design checkpoint, report utilization and timing estimates
#
opt_design
# reportCriticalPaths $outputDir/post_opt_critpath_report.csv
place_design
# report_clock_utilization -file $outputDir/clock_util.rpt
#
# Optionally run optimization if there are timing violations after placement
if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]] < 0} {
puts "Found setup timing violations => running physical optimization"
phys_opt_design
}
# write_checkpoint -force $outputDir/post_place.dcp
# report_utilization -file $outputDir/post_place_util.rpt
# report_timing_summary -file $outputDir/post_place_timing_summary.rpt

#
# STEP#5: run the router, write the post-route design checkpoint, report the routing
# status, report timing, power, and DRC, and finally save the Verilog netlist.
#
route_design
# write_checkpoint -force $outputDir/post_route.dcp
report_route_status -file $outputDir/post_route_status.rpt
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
# report_power -file $outputDir/post_route_power.rpt
# report_drc -file $outputDir/post_imp_drc.rpt
# write_verilog -force $outputDir/$top_module_impl_netlist.v -mode timesim -sdf_anno true
#
# STEP#6: generate a bitstream
#
write_bitstream -force $outputDir/$top_module.bit

set_property PART xc7z030fbg676-2 [current_project]

source ./write_mmi.tcl

write_mmi top
exit