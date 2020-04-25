# SHELL := /bin/bash

ifneq ($(OS),Windows_NT)
	TOOLCHAIN_PREFIX = /opt/riscv32imc/bin/riscv32-unknown-elf-
else
	TOOLCHAIN_PREFIX = /cygdrive/d/SysGCC/risc-v/bin/riscv64-unknown-elf-
endif

CCFLAGS = -march=rv32im -mabi=ilp32
TEST_OBJS = #$(addsuffix .o,$(basename $(wildcard tests/*.S)))
FIRMWARE_OBJS = start.o irq.o print.o #multest.o stats.o sieve.o hello.o #main.o util.o 
RAM_SIZE = 8192 #128*1024
BLOCK_RAM_SIZE = 2048

firmware: firmware.bin
# 	python3 makehex.py $< $(RAM_SIZE) > $(addsuffix .hex,$@)
	python3 makehex.py $< $(RAM_SIZE) $(BLOCK_RAM_SIZE) #> $(addsuffix _B0.hex,$@)
# 	python3 makecoe.py $< 2048 > $(addsuffix .coe,$@)

firmware.bin: firmware.elf firmware.elf.S
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@;
	wc -c firmware.bin
	chmod -x $@

firmware.elf.S: firmware.elf
	$(TOOLCHAIN_PREFIX)objdump $< -S > $@

#firmware.elf: sections.lds start.o test.c util.c
#	$(TOOLCHAIN_PREFIX)gcc $(CCFLAGS) -nostdinc -fno-builtin -c util.c
#	$(TOOLCHAIN_PREFIX)gcc $(CCFLAGS) -nostdinc -fno-builtin -c test.c
#	$(TOOLCHAIN_PREFIX)gcc $(CCFLAGS) -ffreestanding -nostdlib -Wl,-Bstatic,-T,support/sections.lds support/start.o test.o util.o -lgcc -o test.elf 

firmware.elf: $(FIRMWARE_OBJS) $(TEST_OBJS) sections.lds
	$(TOOLCHAIN_PREFIX)gcc $(CCFLAGS) -Os -ffreestanding -nostdlib -o $@ \
		-Wl,-Bstatic,-T,sections.lds\
		$(FIRMWARE_OBJS) $(TEST_OBJS) -lgcc
	chmod -x $@

start.o: start.S
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) -o $@ $<

%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) -Os -ffreestanding -nostdlib -o $@ $<
	
#-fno-builtin -nostdinc
# tests/%.o: tests/%.S tests/riscv_test.h tests/test_macros.h
# 	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) -o $@ -DTEST_FUNC_NAME=$(notdir $(basename $<)) \
# 		-DTEST_FUNC_TXT='"$(notdir $(basename $<))"' -DTEST_FUNC_RET=$(notdir $(basename $<))_ret $<

clean:
	rm -f *.elf *.hex *.coe *.bin *.elf.S
	rm -vrf $(FIRMWARE_OBJS) $(TEST_OBJS)
	rm -f *.o