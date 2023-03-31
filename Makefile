all:
	make -C bootloader
	cp bootloader/bootloader bl

clean:
	rm -rvf bl
	make -C bootloader clean

test: all
	qemu-system-i386 -drive file=bl,format=raw

debug: all
	qemu-system-i386 -drive file=bl,format=raw -s -S
