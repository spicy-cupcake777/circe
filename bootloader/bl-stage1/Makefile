all:
	cargo build
	cargo objcopy -- -O binary stage1

clean:
	rm -rvf stage1
	cargo clean

test:
	qemu-system-i386 -drive file=stage1,format=raw
