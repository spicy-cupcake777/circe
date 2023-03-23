SECTIONS
{
	. = 0x7c00;
	.boot : { *(.start) }
	.text : { *(.text) }
	.data : { *(.data) }
	.bss : { *(.bss) }
}
