TOOLCHAIN_PREFIX = /opt/riscv32im/bin/riscv32-unknown-elf-


test: test.bin makehex.py
	python3 makehex.py $< 2048 > $(addsuffix .hex,$@)
	python3 makehex_B0.py $< 2048 > $(addsuffix _B0.hex,$@)
	python3 makehex_B1.py $< 2048 > $(addsuffix _B1.hex,$@)
	python3 makehex_B2.py $< 2048 > $(addsuffix _B2.hex,$@)
	python3 makehex_B3.py $< 2048 > $(addsuffix _B3.hex,$@)
	python3 makecoe.py $< 2048 > $(addsuffix .coe,$@)

test.bin: test.elf test.elf.S
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@
	chmod -x $@

test.elf.S: test.elf
	$(TOOLCHAIN_PREFIX)objdump $< -S > $@

test.elf: support/start.o test.c util.c
	$(TOOLCHAIN_PREFIX)gcc -nostdinc -fno-builtin -c util.c
	$(TOOLCHAIN_PREFIX)gcc -nostdinc -fno-builtin -c test.c
	$(TOOLCHAIN_PREFIX)gcc -ffreestanding -nostdlib -Wl,-Bstatic,-T,support/sections.lds support/start.o test.o util.o -lgcc -o test.elf 

support/start.o: support/start.S
	$(TOOLCHAIN_PREFIX)gcc -c $< -o $@
clean:
	rm -f *.o *.elf *~ *.hex *.coe *.S
	rm -f support/*.o
