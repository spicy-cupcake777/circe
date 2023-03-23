#include <stdint.h>


struct VGA {
	uint8_t color;
	uint8_t x;
	uint8_t y;
	uint16_t* buffer;
};
struct VGA vga = (struct VGA) { .color = 0x07, .x = 0, .y = 0, .buffer = (uint16_t*)0x0b8000 };

uint8_t strlen(char* s) {
	uint8_t idx;
	while (*((s++)+idx)) ;
	return idx;
}
void putc(char c) {
	*(vga.buffer) = (uint16_t)vga.color << 8 & c;
}


void _kmain() {
	return;
}
