all:
	-mkdir build
	-mkdir out
	-mkdir debug
	nasm -f elf32 src/boot.s -o build/boot.o
	i686-elf-gcc -g -ffreestanding -c src/kernel/kmain.c -o build/kernel.o -O0
	i686-elf-gcc -g -ffreestanding -nostdlib build/*.o -T src/linker.ld -o build/circe.elf
	i686-elf-objcopy -O binary build/circe.elf out/circe
	i686-elf-objcopy --only-keep-debug build/circe.elf debug/circe.sym

test: all
	qemu-system-i386 -drive file=out/circe,format=raw

debug: all
	qemu-system-i386 -s -S -drive file=out/circe,format=raw

clean:
	rm -rvf build out debug
