# run_bft_kintex7_project.tcl
# BFT sample design 
#    A Vivado script that demonstrates an RTL-to-bitstream project flow.
#    This script will create a project, copy sources into the project 
#    directory, run synthesis, implementation and generate a bitstream.
#    It will also write a few reports to disk and open the GUI when finished.
#
# NOTE:  -Typical usage would be "vivado -mode tcl -source run_bft_kintex7_project.tcl" 
#        -To use -mode batch comment out the "start_gui" and "open_run impl_1" to save time
#
create_project -force riscv_picorv32 ./riscv_picorv32 -part xc7k325tffg900-2

add_files ../rtl/chip.v
add_files ../rtl/tb_chip.v
# add_files [ glob ../rtl/*.v ]
# add_files [ glob ../rtl/eth/*.v ]
# add_files [ glob ../rtl/uart/*.v ]

add_files -fileset sim_1 ../rtl/tb_chip.v

add_files -fileset constrs_1 ./chip.xdc 
add_files -fileset constrs_1 ./chip_mmi.xdc
add_files -fileset constrs_1 ./axis_async_fifo.tcl

set_property used_in_synthesis false [get_files -of_objects [get_filesets sources_1] ../rtl/tb_chip.v]
set_property used_in_implementation false [get_files -of_objects [get_filesets sources_1] ../rtl/tb_chip.v]

set_property top chip [current_fileset]

set_param general.maxThreads 8

# Mimic GUI behavior of automatically setting top and file compile order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Launch Synthesis
launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name netlist_1
# Generate a timing and power reports and write to disk
report_timing_summary -delay_type max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -file ./riscv_picorv32/syn_timing.rpt
report_power -file ./riscv_picorv32/syn_power.rpt
# Launch Implementation
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1 
# Generate a timing and power reports and write to disk
# comment out the open_run for batch mode
open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -file ./riscv_picorv32/imp_timing.rpt
report_power -file ./riscv_picorv32/imp_power.rpt
# comment out the for batch mode
start_gui
