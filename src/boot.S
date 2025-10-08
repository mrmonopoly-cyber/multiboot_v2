;doc info: https:/www.gnu.org/software/grub/manual/multiboot2/multiboot.html

%define MAGIC 0xE85250D6                                          ;from specs
%define ARCH 0                                                    ;32-bit (protected mode) of i386 
%define HEADER_LENGTH (multiboot2_header_end - multiboot2_header) ;header size
%define CHECKSUM -(MAGIC + ARCH + HEADER_LENGTH)                  ;added to ‘magic’,‘architecture’,‘header_length’, = zero.

%define COM1 0x3F8

%define NEWLINE 0x0D,0x0A; \r\n
%define CHAR_0 0x30

section .multiboot
align 8
multiboot2_header:
dd MAGIC
dd ARCH 
dd HEADER_LENGTH 
dd CHECKSUM

;*tags

dd 0 ;type=0 (end)
dd 8 ;size=8
multiboot2_header_end:

section .bss
stack_start:
resb 16384 ;16KB
stack_end:

section .text
global _start
_start:
  mov esp, stack_end

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
  cli
  jmp _hlt


;print a base 10 number to COM1 port
;stack_layout:
;+0: ret ptr
;+4: byte value
write_base_10_unit:
  ;setting up registers
  mov eax, [esp + 4]

  add al, '0'
  push eax
  push dword COM1
  call outb
  add esp, 8
  ret


;print a u8 number to COM1 port in base 10
;stack_layout:
;+0: ret ptr
;+4: byte value
;+8: base 
write_base_u8_int:
  ;clean up
  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

  push ebp
  mov ebp, esp
  sub esp, 4

  mov dword [ebp-4], 0
  mov ebx, [ebp+8];value

.store_unit:
  mov eax, ebx
  mov edx, 0
  mov ecx, [ebp+12]
  div ecx               ; EAX = value / 10 (tens), EDX = value % 10 (units)

  push edx
  inc dword [ebp-4]

  cmp eax, 0
  je .print_digits
  mov ebx, eax
  jmp .store_unit
  
.print_digits:
  mov ecx, [ebp-4]
.print_digits_loop:
  cmp ecx, 0
  je .exit

  call write_base_10_unit
  pop eax
  dec ecx
  jmp .print_digits_loop

.exit:
  mov esp, ebp
  pop ebp
  ret


;print newline to COM1 port
;stack_layout:
;+0: ret ptr
write_new_line:
  push dword 0xD;\r
  push dword COM1
  call outb
  add esp, 8

  push dword 0xA;\n
  push dword COM1
  call outb
  add esp, 8
  ret

;print a char to COM1 port
;stack_layout:
;+0: ret ptr
;+4: byte value
write_char:
  ;clean up
  xor eax, eax
  xor ebx, ebx

  ;setting up registers
  mov al, [esp + 4]

  push eax
  push dword COM1
  call outb
  add esp, 8
  ret



;print a string to COM1 port
;stack layout:
;+0: ret ptr
;+4: str ptr
write_str:
  mov esi, [esp + 4]

.next_char:
  mov al, byte [esi]
  cmp al, 0
  je .done_str
  
  xor eax, eax
  mov ax, [esi]

  push dword eax
  push dword COM1
  call outb
  add esp, 8

  inc esi
  jmp .next_char

.done_str:
  ret

  


;print a byte on a port
;stack layout:
;+0: ret ptr
;+4: port
;+8: value
outb:
  xor eax, eax
  xor edx, edx

  mov dx, [esp + 4]
  mov al, [esp + 8]
  out dx, al
  ret


section .data
align 4
hello: db 'hello',NEWLINE
