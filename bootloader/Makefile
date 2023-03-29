all:
	make -C bl-stage1
	make -C bl-stage2
	cp bl-stage1/stage1 .
	cp bl-stage2/stage2 .
	cat stage1 stage2 > bootloader

clean:
	rm -rvf bootloader stage*
	make -C bl-stage1 clean
	make -C bl-stage2 clean

test: all
	qemu-system-i386 -drive file=bootloader,format=raw
