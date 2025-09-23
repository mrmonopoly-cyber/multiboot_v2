//doc info: https://www.gnu.org/software/grub/manual/multiboot2/multiboot.html

.set MAGIC, 0xE85250D6                                          //from specs
.set ARCH, 0                                                    //32-bit (protected mode) of i386 
.set HEADER_LENGTH, (multiboot2_header_end - multiboot2_header) //header size
.set CHECKSUM, -(MAGIC + ARCH + HEADER_LENGTH)                  //added to ‘magic’,‘architecture’,‘header_length’, = zero.

.section .multiboot
multiboot2_header:
.align 4
.long MAGIC
.long ARCH 
.long HEADER_LENGTH 
.long CHECKSUM
multiboot2_header_end:

.section .text
.global _start
_start:
  _loop: jmp _loop

