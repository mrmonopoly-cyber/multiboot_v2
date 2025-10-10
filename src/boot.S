%include "./src/io/serial/serial.h"
%include "./src/headers/boot.h"

%define NEWLINE 0x0D,0x0A; \r\n

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
  cli; disable interrupt
  mov esp, stack_end ;setup stack

  call check_boot ;check boot
  add esp, 4

  push valid_boot ;print valid boot on serial
  call write_str
  add esp, 4

  mov esi, ebx ;save on esi ptr to information structure

  ;;application

_hlt: 
  jmp _hlt


section .rodata
align 4
valid_boot: db 'valid_boot',NEWLINE

section .data
