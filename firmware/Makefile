# SHELL := /bin/bash
lwip = lwip141
include $(lwip)/Makefile

ifneq ($(OS),Windows_NT)
	TOOLCHAIN_PREFIX = /opt/newriscv32im/bin/riscv32-unknown-elf-
else
	TOOLCHAIN_PREFIX = /cygdrive/d/SysGCC/risc-v/bin/riscv64-unknown-elf-
endif

MAKE = make
CCFLAGS = -march=rv32im -mabi=ilp32 -Wall -g
FIRMWARE_OBJS = start.o main.o echo.o

MYLIBS_OBJS = mylib.o
RAM_SIZE = 262144 #64*1024
BLOCK_RAM_SIZE = 4096

nPORT = $(lwip)/contrib/ports/riscv
nLWIP_DIR = $(lwip)/lwip-1.4.1
INCLUDES=-I$(nLWIP_DIR)/src/include \
		-I$(nLWIP_DIR)/src/include/ipv4 \
		-I$(nPORT)/include/arch \
		-I$(nPORT)/include/netif \
		-I$(nPORT)/include
VPATH = $(nLWIP_DIR)/src/core/ $(nLWIP_DIR)/src/core/ipv4/ \
	$(nLWIP_DIR)/src/core/ipv6 \
	$(nLWIP_DIR)/src/core/snmp $(nLWIP_DIR)/src/netif \
	$(nPORT) $(nPORT)/netif

firmware: firmware.bin
	python3 makehex.py $< $(RAM_SIZE) $(BLOCK_RAM_SIZE) #> $(addsuffix _B0.hex,$@)

firmware.bin: firmware.elf firmware.elf.S
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@;
	wc -c firmware.bin
	size firmware.elf
	chmod -x $@

firmware.elf.S: firmware.elf
	$(TOOLCHAIN_PREFIX)objdump $< -S -d > $@

firmware.elf: $(FIRMWARE_OBJS) $(MYLIBS_OBJS) $(LWIP_OBJ) sections.lds
	$(TOOLCHAIN_PREFIX)gcc $(CCFLAGS) -Os -ffreestanding -nostdlib -o $@ \
		-Wl,-Bstatic,-T,sections.lds \
		$(FIRMWARE_OBJS) $(MYLIBS_OBJS) $(LWIP_OBJ) -lgcc
	chmod -x $@

start.o: start.S
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) -o $@ $<

%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) $(INCLUDES) -Os -ffreestanding -nostdlib -o $@ $<

lwip141/obj/%.o: %.c $(LWIP_INCLUDEFILES)
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) $(INCLUDES) -Os -ffreestanding -nostdlib -o $@ $<

# lwip_lib: $(LWIP_OBJS)
# 	cd lwip && $(MAKE) all

clean:
	rm -f  *.hex *.coe *.bin *.elf.S
	rm -vrf $(FIRMWARE_OBJS) $(TEST_OBJS)
	rm -f *.o
	rm -rf lwip/obj/*.o
# 	rm -f *.elf