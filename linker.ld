OUTPUT_FORMAT(elf64-x86_64)
OUTPUT_ARCH(x86_64)

ENTRY(_start)

PHDRS
{
    text    PT_LOAD FLAGS((1 << 0) | (1 << 2));
    rodata  PT_LOAD FLAGS ((1 << 2));
    data    PT_LOAD FLAGS ((1 << 1) | (1 << 2));
}

SECTIONS
{
    . = 0xffffffff80000000;

    KERNEL_START = .;

    .text : {
        *(.text .text.*)
    } :text

    . += CONSTANT(MAXPAGESIZE);

    .data : {
        *(.data .data.*)
    } :data

    .bss : {
        *(COMMON)
        *(.bss .bss.*)
    } :bss

    /DISCARD/ : {
        *(.note .note.*)
    }

    KERNEL_END = .;
}
