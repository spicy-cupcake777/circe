#![no_std]
#![no_main]

use core::{panic::PanicInfo, arch::asm};


#[no_mangle]
#[link_section = ".beginning"]
pub extern "C" fn stage2() -> ! {
    let mut buffer = 0xb8000 as *mut u16;
    unsafe {
        *(buffer) = 0x7744
    }

    loop {}
}

#[panic_handler]
pub fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
