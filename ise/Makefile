DEVICE=xc3s500e-4vq100
ISE_DIR=/cygdrive/d/Xilinx/14.7/ISE_DS/ISE/bin/nt64

chip:
	${ISE_DIR}/xst -ifn chip.xst
	${ISE_DIR}/ngdbuild -p ${DEVICE} -bm chip.bmm -uc chip.ucf chip.ngc chip.ngd
	${ISE_DIR}/map -w -timing -detail -p ${DEVICE} -o chip_map.ncd chip.ngd chip.pcf
	${ISE_DIR}/par -w chip_map.ncd chip.ncd chip.pcf
	${ISE_DIR}/bitgen -w chip.ncd chip.bit chip.pcf

#prog: data
#	${ISE_DIR}/impact -batch impact.cmd

test.elf:
	${ISE_DIR}/data2mem -bm chip_bd.bmm -bd ../sw/test.elf -bt chip.bit -o b chip_mem.bit;${ISE_DIR}/impact -batch impact.cmd

firmware.elf:
	${ISE_DIR}/data2mem -bm chip_bd.bmm -bd ../firmware/firmware.elf -bt chip.bit -o b chip_mem.bit;${ISE_DIR}/impact -batch impact.cmd


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
	rm -rf *.drc *.cwbt *.bit *.bgn *.xwbt usage_statistics_webtalk.html webtalk.log
	rm -rf *.prm *.mcs *.cfi
	rm -rf _impact.cmd _impact.log _impactbatch.log
	rm -rf impact_impact.xwbt impact.xsl webtalk_impact.xml
	rm -f chip.edif ngc2edif.log
	rm -f chip_map.twr chip_map.twx
	rm -f chip_bd.bmm
	rm -f chip.xise chip.gise *.html *.log
	rm -rf iseconfig