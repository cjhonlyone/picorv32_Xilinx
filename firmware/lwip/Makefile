include lwip/Makefile.lwip
include lwip/Makefile.adapter

# ARCHIVER=/cygdrive/d/SysGCC/risc-v/bin/riscv64-unknown-elf-ar

ifneq ($(OS),Windows_NT)
	TOOLCHAIN_PREFIX = /opt/riscv32im/bin/riscv32-unknown-elf-
else
	TOOLCHAIN_PREFIX = /cygdrive/d/SysGCC/risc-v/bin/riscv64-unknown-elf-
endif

COMPILER_FLAGS=-march=rv32im -mabi=ilp32 -Wall -Os -ffreestanding -nostdlib 

INCLUDES=-I$(LWIP_DIR)/src/include \
		-I$(LWIP_DIR)/src/include/ipv4 \
		-I$(PORT)/include/arch \
		-I$(PORT)/include/netif \
		-I$(PORT)/include

OUTS = obj/*.o
OBJ_DIR = obj
LWIP_OBJ1 = $(LWIP_OBJS) $(ADAPTER_OBJS)
LWIP_OBJ = $(addprefix lwip/$(OBJ_DIR)/,$(LWIP_OBJ1))
INCLUDEFILES = $(LWIP_INCLUDES) $(ADAPTER_INCLUDES)  
LWIP_INCLUDEFILES = $(addprefix lwip/,$(INCLUDEFILES))

# SRCS = $(LWIP_SRCS) $(ADAPTER_SRCS)

# vpath %.c $(dir $(SRCS))

# VPATH = $(LWIP_DIR)/src/core/ $(LWIP_DIR)/src/core/ipv4/ \
# 	$(LWIP_DIR)/src/core/ipv6 \
# 	$(LWIP_DIR)/src/core/snmp $(LWIP_DIR)/src/netif \
# 	$(PORT) $(PORT)/netif

# all: $(OBJS)
# 	@echo $(INCLUDES)

# $(OBJ_DIR)/%.o: %.c
# 	$(TOOLCHAIN_PREFIX)gcc -c $(CC_FLAGS) $(INCLUDES) -o $@ $<

# clean:
# 	rm -rf ${OUTS}