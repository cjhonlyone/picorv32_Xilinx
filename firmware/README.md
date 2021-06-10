我们考虑到内存读写不能只由cpu控制，还要让DMA控制

还考虑到代码部分的内存最好控制成只读

因此便有了修改链接脚本的需求

链接脚本的本质就是把每个源文件生成的.o文件更具符号、函数名链接在一起

然后把各个段组合在一起

这是我最初的的链接脚本

```lds
SECTIONS {
	.memory : {
		. = 0x000000;
		start*(.text);
		*(.text);
		*(*);
		end = .;
		. = ALIGN(4);
	}
}
```

看起来非常简单，就是从零地址开始，然后先塞进去start脚本，在把其他的函数与数据堆在一起。

这样虽然简单，但是不好，不符合我们目前的需求。

目前需要分离只读段与可读写段。

看了别人的lds我是一头污水，那些乱七八糟的名字，什么sbss,rodata，把我给搞懵了。

我就想知道我这个elf里面到底有啥段

所以可以用两条命令看一看

```bash
$ Objdump -h firmware.elf
$ Readelf -S firmware.elf
```

这两个命令异曲同工，都能看elf里面有啥段

我感觉第二条命令输出的更好看，就先看第二条输出的内容。

```bash
There are 22 section headers, starting at offset 0xb3b8:

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        00000000 001000 001cfc 00  AX  0   0 16
  [ 2] .text.startup     PROGBITS        00001cfc 002cfc 0001f9 00  AX  0   0  4
  [ 3] .rodata.str1.4    PROGBITS        00001ef8 002ef8 000134 01 AMS  0   0  4
  [ 4] .srodata.cst8     PROGBITS        00002030 003030 000008 08  AM  0   0  8
  [ 5] .eh_frame         PROGBITS        00002038 003038 00003c 00   A  0   0  4
  [ 6] .rodata           PROGBITS        00002074 003074 00013c 00   A  0   0  4
  [ 7] .data             PROGBITS        00004000 004000 000020 00  WA  0   0  4
  [ 8] .bss              NOBITS          00004020 004020 000420 00  WA  0   0  4
  [ 9] .sbss             NOBITS          00004440 004020 000010 00  WA  0   0  4
  [10] .comment          PROGBITS        00000000 004020 00001a 01  MS  0   0  1
  [11] .debug_info       PROGBITS        00000000 00403a 002145 00      0   0  1
  [12] .debug_abbrev     PROGBITS        00000000 00617f 0009b5 00      0   0  1
  [13] .debug_loc        PROGBITS        00000000 006b34 002595 00      0   0  1
  [14] .debug_aranges    PROGBITS        00000000 0090c9 0000d8 00      0   0  1
  [15] .debug_ranges     PROGBITS        00000000 0091a1 000380 00      0   0  1
  [16] .debug_line       PROGBITS        00000000 009521 000f72 00      0   0  1
  [17] .debug_str        PROGBITS        00000000 00a493 00075e 01  MS  0   0  1
  [18] .debug_frame      PROGBITS        00000000 00abf4 0000c0 00      0   0  4
  [19] .symtab           SYMTAB          00000000 00acb4 000470 10     20  42  4
  [20] .strtab           STRTAB          00000000 00b124 0001b4 00      0   0  1
  [21] .shstrtab         STRTAB          00000000 00b2d8 0000de 00      0   0  1
```

我们来一条一条分析下它都是啥玩意儿

addr意思是这个段的起始地址，off是它相对于开头的偏移，size是这个段的大小

```bash
Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
                  NULL            00000000 000000 000000 00      0   0  0
.text             PROGBITS        00000000 001000 001cfc 00  AX  0   0 16
代码段
.text.startup     PROGBITS        00001cfc 002cfc 0001f9 00  AX  0   0  4
不知道怎么的它就链接到main上了
.rodata.str1.4    PROGBITS        00001ef8 002ef8 000134 01 AMS  0   0  4
费了老大劲找到的
It is actually .rodata.strM.N where M is size of character in the string
and N is alignment in bytes, so e.g. for L"abc" it might as well be
.rodata.str4.4
strM.N，M是字节数，N是需要对其的字节数
pirntf的字符串都在这里

.srodata.cst8     PROGBITS        00002030 003030 000008 08  AM  0   0  8
.rodata.cstN is for fixed size readonly constants N bytes in size (and
aligned to the same size).
这一个固定只读的数

.eh_frame         PROGBITS        00002038 003038 00003c 00   A  0   0  4
说是gcc搞出来处理异常的
.rodata           PROGBITS        00002074 003074 00013c 00   A  0   0  4
只读数据部分

.data             PROGBITS        00004000 004000 000020 00  WA  0   0  4
初始化的数据部分
int a[8] = {1,2,3,4};

.bss              NOBITS          00004020 004020 000420 00  WA  0   0  4
没初始化的数据部分，预留了地址空间
int b[8];

.sbss             NOBITS          00004440 004020 000010 00  WA  0   0  4
.bss的small版
没初始化的小数据

.comment          PROGBITS        00000000 004020 00001a 01  MS  0   0  1
注释部分
```

ENTRY(SYMBOL) ：将符号SYMBOL的值设置成入口地址。

入口地址(entry point)是指进程执行的第一条用户空间的指令在进程地址空间的地址

ld有多种方法设置进程入口地址, 按一下顺序: (编号越前, 优先级越高)

1, ld命令行的-e选项

2, 连接脚本的ENTRY(SYMBOL)命令

3, 如果定义了start符号, 使用start符号值

4, 如果存在.text section, 使用.text section的第一字节的位置值

5, 使用值0



根据这个就可以搞我们的新lds了

```lds
/*
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.
*/
	/* the memory in the testbench is 128k in size;
	 * set LENGTH=96k and leave at least 32k for stack */
/*
MEMORY {

	code_mem(rx) : ORIGIN = 0x00000000, LENGTH = 0x00020000
	data_mem(!rx) : ORIGIN = 0x00004000, LENGTH = 0x00004000
}*/


SECTIONS {
    /* The program code and other data */
    .text :
    {
        . = ALIGN(4);
        *(.text)           /* .text sections (code) */
        *(.text*)          /* .text* sections (code) */
        *(.rodata)         /* .rodata sections (constants, strings, etc.) */
        *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
        *(.srodata)        /* .rodata sections (constants, strings, etc.) */
        *(.srodata*)       /* .rodata* sections (constants, strings, etc.) */
        . = ALIGN(4);
    } 

    /* This is the initialized data section */
    .data :
    {
        . = ALIGN(4);
        *(.data)           /* .data sections */
        *(.data*)          /* .data* sections */
        *(.sdata)           /* .sdata sections not used */ 
        *(.sdata*)          /* .sdata* sections not used */
        . = ALIGN(4);
    }

    /* Uninitialized data section */
    .bss :
    {
        . = ALIGN(4);
        *(.bss)
        *(.bss*)
        *(.sbss)
        *(.sbss*)
        /* *(COMMON)  what fuck this is */
        . = ALIGN(4);
    }

    /* this is to define the start of the heap, and make sure we have a minimum size */
    .heap :
    {
        . = ALIGN(4);
    } 
}
```

查看符号表和重定位表：

readelf -s main.o

查看符号表

objdump -t main.o

重定位表：

objdump -r main.o



static 编译时候提前分配好空间

const 就是只读常量，不可更改

别用const，riscvgcc只退出不报错，好迷

