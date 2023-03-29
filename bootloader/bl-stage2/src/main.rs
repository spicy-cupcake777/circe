#![no_std]
#![no_main]

use core::{panic::PanicInfo, arch::asm};


#[no_mangle]
#[link_section = ".beginning"]
pub extern "C" fn stage2() -> ! {
    let gdt = [
        GdtDesc {
            limit1: 0x0000,
            base1: 0x0000,
            base2: 0x00,
            access: 0x00,
            flaglimit: 0x00,
            base3: 0x00
        },
        GdtDesc {
            limit1: 0xffff,
            base1: 0x0000,
            base2: 0x00,
            access: 0x9a,
            flaglimit: 0xcf,
            base3: 0x00
        },
        GdtDesc {
            limit1: 0xffff,
            base1: 0x0000,
            base2: 0x00,
            access: 0x92,
            flaglimit: 0xcf,
            base3: 0x00
        }
    ];
    let gdtr = Gdtr {
        size: 8*3-1,
        offset: &gdt as *const [GdtDesc;3] as u32
    };
    unsafe {
        lgdt(gdtr)
    }
    loop {}
}

#[panic_handler]
pub fn panic(_info: &PanicInfo) -> ! {
    loop {}
}


#[repr(C, packed)]
struct GdtDesc {
    limit1: u16,
    base1: u16,
    base2: u8,
    access: u8,
    flaglimit: u8,
    base3: u8
}
#[repr(C, packed)]
struct Gdtr {
    size: u16,
    offset: u32
}

unsafe fn lgdt(gdtr: Gdtr) {
    asm!(
        "lgdt [{}]",
        in(reg) &gdtr
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
        "mov cr0, eax"
    );
}
