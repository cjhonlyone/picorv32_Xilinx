# SHELL := /bin/bash

ifneq ($(OS),Windows_NT)
	TOOLCHAIN_PREFIX = /opt/riscv32imc/bin/riscv32-unknown-elf-
else
	TOOLCHAIN_PREFIX = /cygdrive/d/SysGCC/risc-v/bin/riscv64-unknown-elf-
endif

CCFLAGS = -march=rv32im -mabi=ilp32 -Wall
FIRMWARE_OBJS = start.o irq.o main.o
MYLIBS_OBJS = mylib.o
RAM_SIZE = 65536 #64*1024
BLOCK_RAM_SIZE = 4096

firmware: firmware.bin
	python3 makehex.py $< $(RAM_SIZE) $(BLOCK_RAM_SIZE) #> $(addsuffix _B0.hex,$@)

firmware.bin: firmware.elf firmware.elf.S
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@;
	wc -c firmware.bin
	size firmware.elf
	chmod -x $@

firmware.elf.S: firmware.elf
	$(TOOLCHAIN_PREFIX)objdump $< -s -d > $@

firmware.elf: $(FIRMWARE_OBJS) $(MYLIBS_OBJS) sections.lds
	$(TOOLCHAIN_PREFIX)gcc $(CCFLAGS) -Os -ffreestanding -nostdlib -o $@ \
		-Wl,-Bstatic,-T,sections.lds \
		$(FIRMWARE_OBJS) $(MYLIBS_OBJS) -lgcc
	chmod -x $@

start.o: start.S
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) -o $@ $<

%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) -Os -ffreestanding -nostdlib -o $@ $<
	
clean:
	rm -f  *.hex *.coe *.bin *.elf.S
	rm -vrf $(FIRMWARE_OBJS) $(TEST_OBJS)
	rm -f *.o
# 	rm -f *.elf