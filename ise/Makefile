DEVICE=xc7k325t-2ffg900
ISE_DIR=/cygdrive/d/Xilinx/14.7/ISE_DS/ISE/bin/nt64

chip:
	${ISE_DIR}/xst -ifn chip.xst
	${ISE_DIR}/ngdbuild -p ${DEVICE} -bm ../rtl/chip.bmm -uc ../rtl/chip.ucf chip.ngc chip.ngd
	${ISE_DIR}/map -w -timing -detail -p ${DEVICE} -o chip_map.ncd chip.ngd chip.pcf
	${ISE_DIR}/par -w chip_map.ncd chip.ncd chip.pcf
	${ISE_DIR}/trce -v 10 chip.ncd chip.pcf -xml chip.twx
	${ISE_DIR}/bitgen -w chip.ncd chip.bit chip.pcf

#prog: data
#	${ISE_DIR}/impact -batch impact.cmd

data:
	${ISE_DIR}/data2mem -bm ../rtl/chip_bd.bmm -bd ../firmware/firmware.elf -bt chip.bit -o b chip_mem.bit;

test:
	${ISE_DIR}/data2mem -bm ../rtl/chip_bd.bmm -bd ../tests/firmware/firmware.elf -bt chip.bit -o b chip_mem.bit;
	${ISE_DIR}/impact -batch impact.cmd

firmware:
	${ISE_DIR}/data2mem -bm ../rtl/chip_bd.bmm -bd ../firmware/firmware.elf -bt chip.bit -o b chip_mem.bit;
	${ISE_DIR}/impact -batch impact.cmd

dhry:
	${ISE_DIR}/data2mem -bm ../rtl/chip_bd.bmm -bd ../tests/dhrystone/dhry.elf -bt chip.bit -o b chip_mem.bit;
	${ISE_DIR}/impact -batch impact.cmd

xdl:
	${ISE_DIR}/xdl -ncd2xdl chip.ncd chip.xdl

gui: 
	${ISE_DIR}/xtclsh makegui.tcl

clean:
	rm -f *~
	rm -rf *.xrpt _xmsgs
	rm -rf *.ngc *.srp xst
	rm -rf xlnx_auto_0_xdb *.ngd netlist.lst *.bld
	rm -rf *.ngm *.pcf *.ncd *_usage.xml *_summary.xml *.mrp *.map
	rm -rf par_usage_statistics.html *.ptwx *_pad.csv *.pad *_pad.txt *.unroutes *.xpi *.par
	rm -rf *.drc *.cwbt *.bgn *.xwbt usage_statistics_webtalk.html webtalk.log
	rm -rf *.prm *.mcs *.cfi
	rm -rf _impact.cmd _impact.log _impactbatch.log
	rm -rf impact_impact.xwbt impact.xsl webtalk_impact.xml
	rm -f chip.edif ngc2edif.log
	rm -f chip_map.twr chip_map.twx
	rm -f chip.xise chip.gise *.html *.log
	rm -rf iseconfig
	rm -rf *.xdl
	rm -rf *.twr *.twx
# 	rm -f chip_bd.bmm
# 	rm -f *.bit