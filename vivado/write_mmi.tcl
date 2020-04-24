#Created by stephenm@xilinx.com. This is not supported by WTS
#The cell_name is the name of the Block RAM in the BD.
#This has been tested with a memory range 0K - 1M
#This only supports data width of 32 bits.


proc write_mmi {cell_name} {
	set proj [current_project]
	set filename "${cell_name}.mmi"
	set fileout [open $filename "w"]
	set brams [split [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ BMEM.bram.* }] " "]
	#isolate all BRAMs identified by cell_name
	set cell_name_bram ""
	for {set i 0} {$i < [llength $brams]} {incr i} {
		if { [regexp -nocase "top" [lindex $brams $i]] } {
			lappend cell_name_bram [lindex $brams $i]
		}
	}
	# set proc_found 0	
	# set inst_path [split [get_cells -hierarchical -filter { NAME =~  "*${cell_name}*" } ] " "]
	# if {$inst_path == ""} {
		# puts "Warning: No Processor found"
		set inst_path "dummy"
	# } else {
	# 	set proc_found 1
	# 	set inst_path [lindex $inst_path 0]
	# }
		
	puts $fileout "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
	puts $fileout "<MemInfo Version=\"1\" Minor=\"0\">"
	set inst_temp [lindex $brams 0]
	set loc_temp [string first $cell_name $inst_temp]
	set inst [string range $inst_temp 0 $loc_temp]
	set new_inst [string last "/" $inst]
	set new_inst [string range $inst 0 $new_inst-1]
	puts $fileout "  <Processor Endianness=\"Little\" InstPath=\"$inst_path\">"
	set bram_range 0
	for {set i 0} {$i < [llength $cell_name_bram]} {incr i} {
		set bram_type [get_property REF_NAME [get_cells [lindex $cell_name_bram $i]]]
		if {$bram_type == "RAMB36E1"} {
			set bram_range [expr {$bram_range + 4096}]	
		}
	}
	puts $fileout "  <AddressSpace Name=\"$cell_name\" Begin=\"0\" End=\"[expr {$bram_range - 1}]\">"

	set bram [llength $cell_name_bram]
	# if {$bram >= 32} {
	# 	set sequence "7,6,5,4,3,2,1,0,15,14,13,12,11,10,9,8,23,22,21,20,19,18,17,16,31,30,29,28,27,26,25,24"
	# 	set bus_blocks [expr {$bram / 32}]
	# } elseif {$bram >= 16 && $bram < 32} {
	# 	set sequence "7,5,3,1,15,13,11,9,23,21,19,17,31,29,27,25"
	# 	set bus_blocks 1
	# } elseif {$bram >= 8 && $bram < 16} {
	# 	set sequence "7,3,15,11,23,19,31,27"
	# 	set bus_blocks 1
	# } elseif {$bram >= 4 && $bram < 8} {
		set sequence "7,15,23,31"
		set bus_blocks 8
	# } else {
	# 	set sequence "15,31"
	# 	set bus_blocks 1
	# }
	set sequence [split $sequence ","]
	
	set j 0
	for {set b 0} {$b < $bus_blocks} {incr b} {
		puts $fileout "      <BusBlock>"
		for {set i 0} {$i < [llength $sequence]} {incr i} {
			# for {set j 0} {$j < [llength $cell_name_bram]} {incr j} {
				set block_start [expr {32768 * $b}]
				set bmm_width [bram_info [lindex $cell_name_bram $j] "bit_lane"]
				set bmm_width [split $bmm_width ":"]
				set bmm_msb [lindex $bmm_width 0]
				set bmm_lsb [lindex $bmm_width 1]
				set bmm_range [bram_info [lindex $cell_name_bram $j] "range"]
				set split_ranges [split $bmm_range ":"]
				set MSB [lindex $sequence $i]
				# if {$MSB == $bmm_msb && $block_start == [lindex $split_ranges 0]} {
					set bram_type [get_property REF_NAME [get_cells [lindex $cell_name_bram $j]]]
					set status [get_property STATUS [get_cells [lindex $cell_name_bram $j]]]
																							
					if {$status == "UNPLACED"} {
						set placed "X0Y0"
					} else {
						set placed [get_property LOC [get_cells [lindex $cell_name_bram $j]]]
						set placed_list [split $placed "_"]
						set placed [lindex $placed_list 1]
					}
					set bram_type [get_property REF_NAME [get_cells [lindex $cell_name_bram $j]]]			
					if {$bram_type == "RAMB36E1"} {
						set bram_type "RAMB32"
					}
															
					puts $fileout "        <BitLane MemType=\"$bram_type\" Placement=\"$placed\">"
					puts $fileout "          <DataWidth MSB=\"$bmm_msb\" LSB=\"$bmm_lsb\"/>"
					puts $fileout "          <AddressRange Begin=\"[lindex $split_ranges 0]\" End=\"[lindex $split_ranges 1]\"/>"
					puts $fileout "          <Parity ON=\"false\" NumBits=\"0\"/>"
					puts $fileout "        </BitLane>"

					# if { [expr {$j % 4}] == 3 } {
					
					# 	break
					# } else {
					# 	incr j
					# }
				# }
			# }
			incr j
		}
		puts $fileout "      </BusBlock>"
	}
	puts $fileout "  </AddressSpace>"
	puts $fileout "  </Processor>"
	puts $fileout "<Config>"
	puts $fileout "  <Option Name=\"Part\" Val=\"[get_property PART [current_project ]]\"/>"
  	puts $fileout "</Config>"
  	puts $fileout "</MemInfo>"
	close $fileout
	puts "MMI file ($filename) created successfully."
	puts "To run Updatemem, use the command line below after write_bitstream:"
	puts "updatemem -force --meminfo $filename --data <path to data file>.elf/mem --bit <path to bit file>.bit --proc $inst_path --out <output bit file>.bit"
}

proc bram_info {bram type} {
	puts $bram
	puts $type
	set temp [get_property bmm_info_memory_device [get_cells $bram]]
	set bmm_info_memory_device [regexp {\[(.+)\]\s+\[(.+)\]} $temp all 1 2]
	if {$type == "bit_lane"} {
		return $1
	} elseif {$type == "range"} {
		return $2
	} else {
		return $all
	}
}

proc export2sdk {} {
	set proj [current_project]
	set file_list ""
	set get_impl [split [get_runs] " "]
	set get_impl [lindex $get_impl [expr {[llength $get_impl] - 1}]]
	set sdk_dir [glob -nocomplain -type d *.sdk]
	if {$sdk_dir == ""} {
		puts "Creating SDK folder: ${proj}.sdk"
		file mkdir ${proj}.sdk
	}
	set mmi_file [glob -nocomplain -directory ${proj}.runs/${get_impl} *.mmi]
	if {$mmi_file != ""} {
		lappend file_list $mmi_file
	}
        set bit_file [glob -nocomplain -directory ${proj}.runs/${get_impl} *.bit]
	if {$bit_file != ""} {
		lappend file_list $bit_file
	}
        set hwdef_file [glob -nocomplain -directory ${proj}.runs/${get_impl} *.hwdef]
	if {$hwdef_file != ""} {
		lappend file_list $hwdef_file
	}
	write_sysdef -force -meminfo $mmi_file -hwdef $hwdef_file -bitfile $bit_file -file ${proj}.sdk/test.hdf
	puts "Creating HDF file containing"
	for {set i 0} {$i <= [llength $file_list]} {incr i} {
	puts [lindex $file_list $i]
	}
}