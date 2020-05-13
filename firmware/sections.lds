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

    . = 0x4000; /* 16KB */
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
}
