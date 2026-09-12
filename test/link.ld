OUTPUT_ARCH( "riscv" )
ENTRY(_start)

MEMORY {
  rom (rx)  : ORIGIN = 0x00000000, LENGTH = 8K
  ram (rwx) : ORIGIN = 0x00002000, LENGTH = 8K
}

SECTIONS {
  .text : {
    *(.text.init)
    *(.text*)
  } > rom

  .data : {
    . = ALIGN(4);
    *(.data*)
  } > ram

  .bss : { *(.bss*) } > ram
}