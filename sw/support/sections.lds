SECTIONS {
	.memory : {
		. = 0x00000000;
		*(.init);
		*(.text);
		*(.rodata);
		*(.data);
		*(.bss);
		. = ALIGN(4);
		end = .;
	}
}
