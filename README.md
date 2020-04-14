# A Picorv32 On Spartan3E  

For there are some people say they can not compile PicoRV32 by ISE, so I do some changes for them.  

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

- Platform: Mainly Windows
It is hard to compile riscv-unknow-elf-gcc on Windows, so c programs must compile on Linux to get `.elf` files or `.bin` files. It doesn't matter which OS you use for ISE design tools. In this repo, `Makefile` mainly written for Windows. Cygwin is a good tools for simulating UNIX enviroment. After you download these files, you should edit your ISE paths, so can compile success. 

## Things about Soc

- 8KB RAM (FPGA's Block RAM)
- Program start at 0x00000000
- IRQ entrance at 0x00000010
- Without standard C library  

## Things about FPGA Board

- Xilinx xc3s500e-4-vq100
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
|      |      |      |
| :----: | :----: | :----: |
|  Number of BUFGMUXs    |  1 out of 24    |   4%   |
|  Number of MULT18X18SIOs     |  4 out of 20    |    20%   |
|  Number of RAMB16s   |  4 out of 20    |   20%    |
| Number of Slices |2203 out of 4656|47%|
| Number of SLICEMs  |243 out of 2328|10%|

## TODO
- interrupt controller
- flash controller
- sdram controller
- ethernet controller
- ...
