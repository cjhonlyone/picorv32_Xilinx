DEVICE=xc7k325tffg900-2
Vivado_DIR=/cygdrive/d/Xilinx/Vivado/2017.4/bin


chip: chip_syn chip_mmi
	@echo done

chip_syn: chip.tcl
	${Vivado_DIR}/vivado -mode tcl -source chip.tcl

chip_gui: chip_prj.tcl
	${Vivado_DIR}/vivado -mode tcl -source chip_prj.tcl

chip_mmi: 
	${Vivado_DIR}/updatemem --debug --force --meminfo top.mmi \
		--data ../firmware/firmware.elf --proc dummy \
		--bit ./_output/chip.bit  --out chip_mmi.bit	

chip_prog:
	${Vivado_DIR}/vivado -mode tcl -source prog.tcl

zprog :
	${Vivado_DIR}/updatemem --debug --force --meminfo top.mmi \
		--data ../firmware/firmware.elf --proc dummy \
		--bit ./_output/chip.bit  --out chip_mmi.bit	
	${Vivado_DIR}/vivado -mode tcl -source prog.tcl

clean:
	rm -rf .Xil _output .cache
	rm -rf *.jou *.log *.html *.xml *dmp
	rm -rf *.bit
	rm -rf *.mmi
	rm -rf riscv_picorv32
	rm -rf ip/doc ip//elaborate ip/hdl ip/synth
	rm -rf ip/*.veo ip/*.vho ip/*.xml ip/*.xdc 
	rm -rf gig_eth*
	rm -rf fsm_encoding.os