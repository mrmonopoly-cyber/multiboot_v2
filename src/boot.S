;doc info: https:/www.gnu.org/software/grub/manual/multiboot2/multiboot.html

%define MAGIC 0xE85250D6                                          ;from specs
%define ARCH 0                                                    ;32-bit (protected mode) of i386 
%define HEADER_LENGTH (multiboot2_header_end - multiboot2_header) ;header size
%define CHECKSUM -(MAGIC + ARCH + HEADER_LENGTH)                  ;added to ‘magic’,‘architecture’,‘header_length’, = zero.


%define NEWLINE 0x0D,0x0A; \r\n
%define CHAR_0 0x30

extern write_base_u8_int
extern write_new_line
extern write_str

section .multiboot
align 8
multiboot2_header:
dd MAGIC
dd ARCH 
dd HEADER_LENGTH 
dd CHECKSUM

;*tags
framebuffer_tag:
dw 5 ;type=5 (frame buffer)
dw 0 ;flags
dd (framebuffer_tag_end - framebuffer_tag);size
dd 0;width
dd 0;height
dd 0;depth
framebuffer_tag_end:

end_tag:
dw 0 ;type=0 (end)
dd 8 ;size=8
multiboot2_header_end:

section .bss
stack_start:
resb 16384 ;16KB
stack_end:

section .text
global _start
_start:
  cli
  mov esp, stack_end

  push dword 10
  push ebx
  call write_base_u8_int
  add esp, 8

  push dword 32
  push dword 32
  call write_base_u8_int
  add esp, 8

  call write_new_line
  add esp, 4

  push dword hello
  call write_str
  add esp, 4

_hlt: 
  jmp _hlt



section .data
align 4
hello: db 'hello',NEWLINE
