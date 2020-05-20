
MAKE = make
FIRMWAREDIR = firmware
ISEPRJDIR = ise
VERILATOR = verilator

unisims_DIR=../../../ISE/verilog/src/unisims
unimacro_DIR=../../../ISE/verilog/src/unimacro
glbl=../../../ISE/verilog/src/glbl.v

test: tb_chip.v testbench.cc
	$(VERILATOR) --cc --exe -Wno-lint -I$(unisims_DIR) -I$(unimacro_DIR) --top-module testbench \
			tb_chip.v chip.v ../../../ISE/verilog/src/glbl.v \
			testbench.cc \
			--Mdir testbench_verilator_dir
	$(MAKE) -C testbench_verilator_dir -f Vtestbench.mk
	cp testbench_verilator_dir/Vtestbench testbench_verilator