# SHELL := /bin/bash

MAKE = make
FIRMWAREDIR = firmware
ISEPRJDIR = ise
# can not work
# unisims_DIR=/cygdrive/d/Xilinx/14.7/ISE_DS/ISE/verilog/src/unisims

# work
# unisims_DIR=../../../../../Xilinx/14.7/ISE_DS/ISE/verilog/src/unisims
# unimacro_DIR=../../../../../Xilinx/14.7/ISE_DS/ISE/verilog/src/unimacro
# glbl=../../../../../Xilinx/14.7/ISE_DS/ISE/verilog/src/glbl.v

unisims_DIR=../../ISE/verilog/src/unisims
unimacro_DIR=../../ISE/verilog/src/unimacro
glbl=../../ISE/verilog/src/glbl.v

isedir_FILES = $(wildcard ise/*.v) 
rtldir_FILES = $(wildcard rtl/*.v)

sw: 
	cd $(FIRMWAREDIR) && $(MAKE) firmware

sw_clean:
	cd $(FIRMWAREDIR) && $(MAKE) clean

hw:
	cd $(ISEPRJDIR) && $(MAKE) chip

hw_prog:
	cd $(ISEPRJDIR) && $(MAKE) firmware

hw_clean:
	cd $(ISEPRJDIR) && $(MAKE) clean

test:
	echo $(Verilog_FILES)

hw_sim: ise/tb_chip.vvp
	vvp -N $<

ise/tb_chip.vvp: $(isedir_FILES) $(glbl) $(rtldir_FILES)
	iverilog -s testbench -y $(unisims_DIR) -y $(unimacro_DIR) -I ./ise \
		-o $@ $(isedir_FILES) $(glbl)
	chmod -x $@

hw_sim_clean:
	rm -rf testbench.vcd #testbench.gtkw
	rm -rf ise/tb_chip.vvp