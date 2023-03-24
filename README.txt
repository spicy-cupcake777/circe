CIRCE OS
A hobby OS I'm building. It currently does not do much at all, but I'm putting it on GitHub to make it more mobile and accessible.
The build uses a Makefile which expects a cross compiler to be installed in a directory tools in the root directory as well as NASM
somewhere in the path. It also expects qemu to be installed for testing. osdev is a convenient script you can source to add tools/bin
to the PATH.
Available targets are:
  all: (default)
    Builds the kernel and puts the ELF in build/circe.elf, the flat binary in out/circe, and the debug symbols in debug/circe.sym
  test: (requires qemu)
    Depends on all and runs the flat binary in qemu.
  debug: (also requires qemu and GDB)
    Depends on all and runs the flat binary in qemu, pausing to wait for a GDB connection
  clean:
    Removes build, debug, and out directories
