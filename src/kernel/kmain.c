#include <stdint.h>


void kmain() {
	*((uint16_t*)0xb8000) = 0x0744;

	return;
}
