bits 16

global .start
extern _kmain
.start:

read_chunk:
	mov ax, 0x07c0
	mov es, ax
	mov ah, 0x02
	mov al, 0x3f
	mov cl, 0x02
	xor ch, ch
	xor dh, dh
	mov bx, 0x0200
	int 0x13
	mov ah, 0x00
	mov al, 0x03
	int 0x10

	lgdt [gdtr]

a20:
	in al, 0x92
	or al, 2
	out 0x92, al

	jmp stage2

null_desc:
	dq 0
code_desc:
	dw 0xffff
	dw 0x0000
	db 0x00
	db 0x9a
	db 0xcf
	db 0x00
data_desc:
	dw 0xffff
	dw 0x0000
	db 0x00
	db 0x92
	db 0xcf
	db 0x00
gdtr:
	db gdtr-null_desc-1
	dw null_desc


times 510-($-read_chunk) db 0
dw 0xaa55

stage2:
	mov sp, stack_bottom
	call _kmain

end:
	cli
	hlt
	jmp end

section .bss
stack_top:
	resb 4096
stack_bottom:
