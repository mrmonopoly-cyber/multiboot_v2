//doc info: https://www.gnu.org/software/grub/manual/multiboot2/multiboot.html

.set MAGIC, 0xE85250D6                                          //from specs
.set ARCH, 0                                                    //32-bit (protected mode) of i386 
.set HEADER_LENGTH, (multiboot2_header_end - multiboot2_header) //header size
.set CHECKSUM, -(MAGIC + ARCH + HEADER_LENGTH)                  //added to ‘magic’,‘architecture’,‘header_length’, = zero.

.section .multiboot
.align 8
multiboot2_header:
.long MAGIC
.long ARCH 
.long HEADER_LENGTH 
.long CHECKSUM

/*tags*/
.align 8
/*end tag*/
.long 0 /*type=0 (end)*/
.long 8 /*size=8*/
multiboot2_header_end:

.section .bss

.section .text
.global _start
_start:
  _loop: jmp _loop

