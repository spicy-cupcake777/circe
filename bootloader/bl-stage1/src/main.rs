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
        lgdt();
    }
    stage2();
}

#[repr(C, packed(2))]
#[allow(dead_code)]
struct Gdtr {
    limit: u16,
    base: u32
}

#[repr(C, packed)]
#[allow(dead_code)]
struct GdtDesc {
    limit1: u16,
    base1: u16,
    base2: u8,
    access: u8,
    limitflag: u8,
    base3: u8
}

static GDT: [GdtDesc; 3] = [
    GdtDesc {
        limit1: 0,
        base1: 0,
        base2: 0,
        access: 0,
        limitflag: 0,
        base3: 0
    },
    GdtDesc {
        limit1: 0xffff,
        base1: 0x0000,
        base2: 0x00,
        access: 0x9a,
        limitflag: 0xcf,
        base3: 0x00
    },
    GdtDesc {
        limit1: 0xffff,
        base1: 0x0000,
        base2: 0x00,
        access: 0x92,
        limitflag: 0xcf,
        base3: 0x00
    }
];

unsafe impl Send for Gdtr {}
unsafe impl Sync for Gdtr {}

unsafe fn set_bios() {
    unsafe {
        asm!(
            "xor ah, ah",
            "mov al, 0x03",
            "int 0x10"
        );
    }
}

#[no_mangle]
unsafe fn lgdt() {
    let gdtr = Gdtr {
        limit: (64*3-1) as u16,
        base: &GDT as *const [GdtDesc;3] as u32
    };
    unsafe {
        asm!("cli",
             "lgdt [{}]",
             in(reg) &gdtr,
             options(readonly, nostack, preserves_flags)
        );
        asm!("ljmp $0x08, $2f", "2:", options(att_syntax));
        asm!(
            "mov ax, 0x10",
            "mov ds, ax",
            "mov es, ax",
            "mov fs, ax",
            "mov gs, ax",
            "mov ss, ax",
            "mov eax, cr0",
            "or eax, 1",
            "mov cr0, eax",
            "2:",
            "jmp 2b"
        );
    }
}

#[panic_handler]
pub fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
