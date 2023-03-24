bits 16

global .start
extern kmain
.start:

; reads 63 512B sectors of data from the drive we booted from
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

; sets VGA to mode 3
	xor ah, ah
	mov al, 0x03
	int 0x10

; loads the GDT pointer and enters protected mode
	cli
	xor eax, eax
	mov ax, ds
	shl eax, 4
	add ax, null_desc
	mov [gdtr+2], eax
	mov eax, gdtr
	sub eax, null_desc
	mov [gdtr], ax
	lgdt [gdtr]
	mov eax, cr0
	or al, 1
	mov cr0, eax
	jmp CODE:clear_pipe

; enables the A20 line
bits 32
clear_pipe:
	mov ax, DATA
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	in al, 0x92
	or al, 2
	out 0x92, al

; jump past the 512B boot sector
	jmp stage2

; GDT segment descriptors and pointer
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
	db 0
	dw 0
CODE: equ code_desc-null_desc
DATA: equ data_desc-null_desc


; pad with zeroes until end of boot sector and have magic number
times 510-($-read_chunk) db 0
dw 0xaa55

; beginning of the post-boot-sector code
; sets up stack and calls the main kernel function (src/kernel/kmain.c)
section .text
stage2:
	mov esp, stack_bottom
	call kmain

; halt; shouldn't really reach here once we get things functional
end:
	cli
	hlt
	jmp end

; unitialized data for the stack
section .bss
stack_top:
	resb 4096
stack_bottom:
