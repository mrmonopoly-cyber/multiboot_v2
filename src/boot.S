%include "./src/io/serial/serial.h"
%include "./src/headers/boot.h"

%define NEWLINE 0x0D,0x0A; \r\n

%ifdef MULTIBOOT_V2
%include "./src/headers/boot/multiboot_v2.h"
%endif

section .rodata
align 4
valid_boot: db 'valid_boot',NEWLINE, 0
FRAMEBUFFER_ADDR: db 'FRAMEBUFFER_ADDR: ', 0
value_framebuffer: db 'value: ', 0

section .data

section .bss
stack_start:
resb 16384 ;16KB
stack_end:

section .text
global _start
_start:
  cli; disable interrupt
  mov esp, stack_end ;setup stack

  call boot_check ;check boot
  add esp, 4

  push valid_boot ;print valid boot on serial
  call write_str
  add esp, 4

  push FRAMEBUFFER_ADDR
  call write_str
  add esp, 4

  push 128 ;FRAMEBUFFER_ADDR
  push ebx
  call boot_get_info
  add esp, 4

  push 10
  push eax
  call write_base_u8_int
  add esp, 4

  call write_new_line 
  add esp, 4

  push value_framebuffer 
  call write_str
  add esp, 4

  push 10
  push dword [eax]
  call write_base_u8_int
  add esp, 4

  call write_new_line
  add esp, 4

  mov esi, ebx ;save on esi ptr to information structure

  ;;application

_hlt: 
  jmp _hlt
