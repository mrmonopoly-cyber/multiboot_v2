#include <stdint.h>

#include "multiboot2_header.h"

__attribute__((__section__(".multiboot")))
MultibootV2Header multiboot_v2 = 
{
  .magic = V2_MAGIC,
  .arch = V2_ARCH,
  .header_length = HEADER_LENGTH(2),
  .checksum = -(V2_MAGIC + V2_ARCH + HEADER_LENGTH(2)),

  .tags = 
  {
    EFI_BOOT_SERIVE_TAG,

    END_TAG, //INFO: must be at the end
  }
};


__attribute__((__section__(".bss"))) //16 KB
uint16_t stack[16384];


__attribute__((__naked__, section(".bootstrap")))
void _bootstrap(void)
{
  asm volatile("cli");

  asm volatile ("movabs $(_start), %rax");
  asm volatile ("jmp *%rax");
}

__attribute__((__naked__, section(".text")))
void _start(void)
{

  asm volatile("hlt");
}
