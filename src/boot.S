%include "./src/io/serial/serial.h"

%define NEWLINE 0x0D,0x0A; \r\n
%define CHAR_0 0x30

%ifdef MULTIBOOT_V2
%include "./src/headers/boot/multiboot_v2.h"
%endif

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
