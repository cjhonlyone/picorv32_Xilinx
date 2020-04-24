DEVICE=xc7z020-2clg400
Vivado_DIR=/cygdrive/d/Xilinx/Vivado/2017.4/bin


chip: chip_syn chip_mmi
	@echo done

chip_syn: chip.tcl
	${Vivado_DIR}/vivado -mode tcl -source chip.tcl

chip_mmi: 
	${Vivado_DIR}/updatemem --debug --force --meminfo top.mmi \
		--data ../firmware/firmware.elf --proc dummy \
		--bit ./_output/chip.bit  --out chip_mmi.bit	

chip_prog:
	${Vivado_DIR}/vivado -mode tcl -source prog.tcl

clean:
	rm -rf .Xil _output .cache
	rm -rf *.jou *.log *.html *.xml *dmp
	rm -rf *.bit
	rm -rf *.mmi