ENTRY(stage2)

SECTIONS
{
	. = 0x7e00;
	.beginning : {
		*(.beginning)
	}
	.text : {
		*(.text .text.*)
	}
	.rodata : {
		*(.rodata .rodata.*)
	}
	.data : {
		*(.data .data.*)
	}
	.bss : {
		*(.bss .bss.*)
	}
}
