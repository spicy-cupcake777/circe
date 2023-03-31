.section .boot, "awx"
.global _start
.code16


_start:
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov fs, ax
	mov gs, ax

	cld

	mov sp, 0x7c00

enable_a20:
	in al, 0x92
	or al, 0x02
	and al, 0xfe
	out 0x92, al

read_sectors:
	mov ax, 0x07c0
	mov es, ax
	mov ah, 0x02
	mov al, 0x10
	mov ch, 0x00
	mov cl, 0x02
	mov dh, 0x00
	mov bx, 0x0200
	int 0x13
	xor ax, ax
	mov es, ax

rust:
	push dx
	call stage1

freeze:
	hlt
	jmp freeze
