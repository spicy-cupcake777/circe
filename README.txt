CIRCE OS
A hobby OS I'm building. It currently does not do much at all, but I'm putting it on GitHub to make it more mobile and accessible.
The project requires Rust, and the test targets require QEMU.
Available make targets are:
	all (default):
		Builds subprojects and copies the complete binary to the root directory.
	test (requires QEMU):
		Runs the flat binary in QEMU.
	debug (requires QEMU):
		Does the same as test except it waits for a GDB connection.
	clean:
		Removes binaries and build artifacts
Make sure to run make clean before committing.
