# A Picorv32 On Virtex6

## How To Compile  

- I suggest compiling one riscv32imc is enough. It only occupies 2GB on your disk. What if you need [i], [im], [ic] or other ISA combinations, use `-march`.

```bash
# Ubuntu packages needed:
sudo apt-get install autoconf automake autotools-dev curl libmpc-dev \
        libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
    gperf libtool patchutils bc zlib1g-dev git libexpat1-dev

sudo mkdir /opt/riscv32imc
sudo chown $USER /opt/riscv32imc

git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32imc
cd riscv-gnu-toolchain-rv32imc
git checkout 411d134
git submodule update --init --recursive

mkdir build; cd build
../configure --with-arch=rv32imc --prefix=/opt/riscv32imc
make -j$(nproc)
```

- Platform: Windows  

Suddenly, I realized that 64 bit library can compile 32 bit program, so we can do all of these compile on Windows. The prebuilt library you can download at this page. [Prebuilt Windows Toolchain for RISC-V](https://gnutoolchains.com/risc-v/)  

- Compile Hardware  

```bash
# Windows os / cygwin
# ISE
cd ise
# Compile FPGA bit stream
make chip
# write firmware.elf to Block RAMs
# and program FPGA
make firmware
# or generate ise gui project
make gui

# vivado
# Compile FPGA bit stream
make chip_syn
# write firmware.elf to Block RAMs
make chip_mmi
# and program FPGA
make chip_prog

```

- Compile Software  

```bash
# Windows os / cygwin
cd firmware
# generate firmware.elf and some .hex for simulation
make firmware
```

## Things about Soc  

- 128KB RAM (FPGA's Block RAM)
- Program start at 0x00000000
- IRQ entrance at 0x00000010
- Without standard C library  

## Things about FPGA Board  

- Xilinx xc7z020clg400-2
- Four LEDs
- Two switches
- Two buttons
- A LCD with two digits

## Things about program  

- LED address at 0x80000000
- Uart address at 0x80000004
- LCD address at 0x80000014
- [m] ISA made by a four stage pipeline multiplier

## Utilization  

|  ISE    |      |      |
| :----: | :----: | :----: |
|  Number of BUFGs    |   2 out of 32      |   6%   |
|  Number of DSP48E1s     |  4 out of 288    |    1%   |
|  Number of RAMB36E1s   |  32 out of 156    |   20%    |
| Number of Slices |3,861 out of  46,560|8%|
| Number of Slice Registers  |2,350 out of  93,120|2%|

## TODO
- interrupt controller
- flash controller
- sdram controller
- ethernet controller
- ...
