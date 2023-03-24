SECTIONS
{
	. = 0x7c00;
	. = ALIGN(4);
	.boot : { *(.start) }
	.text : { *(.text) }
	.data : { *(.data) }
	.bss : { *(.bss) }
}
