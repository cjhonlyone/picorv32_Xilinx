# SHELL := /bin/bash

MAKE = make
FIRMWAREDIR = firmware
ISEPRJDIR = ise
VIVADOPRJDIR = vivado
VERILATOR = verilator
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



hw:
	cd $(ISEPRJDIR) && $(MAKE) chip

hw_prog:
	cd $(ISEPRJDIR) && $(MAKE) firmware



test:
	echo $(Verilog_FILES)

hw_sim: rtl/tb_chip.vvp
	vvp -N $<

rtl/tb_chip.vvp: $(rtldir_FILES) $(glbl) 
	iverilog -s testbench -y $(unisims_DIR) -y $(unimacro_DIR) -I ./rtl -I ./rlt/eth \
		-o $@ rtl/tb_chip.v rtl/chip.v $(glbl)
	chmod -x $@

zprog: 
	cd $(VIVADOPRJDIR) && $(MAKE) zprog

clean: sw_clean hw_clean hw_sim_clean vivado_clean
	rm -rf _xmsgs

sw_clean:
	cd $(FIRMWAREDIR) && $(MAKE) clean

hw_clean:
	cd $(ISEPRJDIR) && $(MAKE) clean

vivado_clean:
	cd $(VIVADOPRJDIR) && $(MAKE) clean

hw_sim_clean:
	rm -rf rtl/testbench.vcd #testbench.gtkw
	rm -rf rtl/tb_chip.vvp