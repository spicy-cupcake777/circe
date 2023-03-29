#![no_std]
#![no_main]

use core::{arch::{asm, global_asm}, panic::PanicInfo};

global_asm!(include_str!("boot.s"));


#[no_mangle]
pub extern "C" fn stage1(disk_number: u16) {
    let stage2: extern "C" fn() = unsafe { core::mem::transmute(0x7e00 as *const()) };
    let disk = 0x7dfd as *mut u8;
    unsafe {
        *disk = (disk_number & 0xff) as u8;
        set_bios();
    }
    stage2();
}

pub unsafe fn set_bios() {
    unsafe {
        asm!(
            "xor ah, ah",
            "mov al, 0x03",
            "int 0x10"
        );
    }
}

#[panic_handler]
pub fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
