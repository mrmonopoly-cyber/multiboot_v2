%define COM1 0x3F8

%include "./src/io/io.h"

section .text
;print a base 10 number to COM1 port
;stack_layout:
;+0: ret ptr
;+4: byte value
global write_base_10_unit
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
global write_base_u8_int
write_base_u8_int:
  ;clean up
  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

  ;creating new space on the stack
  push ebp
  mov ebp, esp
  sub esp, 4

  mov dword [ebp-4], 0;counter initialization
  mov ebx, [ebp+8];value

.store_unit:
  ;division preparation
  mov eax, ebx;numerator
  mov edx, 0;init result
  mov ecx, [ebp+12] ;denominator, base
  div ecx           ; EAX = value / 10 (tens), EDX = value % 10 (units)

  push edx; save on stack the digit to print for later
  inc dword [ebp-4] ;increment the counter

  cmp eax, 0; if the are no more digits
  je .print_digits
  mov ebx, eax; else save result of division on ebx as the new value
  jmp .store_unit
  
.print_digits:
  mov ecx, [ebp-4]; store counter to ecx
.print_digits_loop:
  cmp ecx, 0; if no more digit to print
  je .exit

  call write_base_10_unit;print the digit on top of the stack
  pop eax;pop the printed digit
  dec ecx;decrease the counter
  jmp .print_digits_loop

.exit:
  mov esp, ebp;restore old stack frame pointer
  pop ebp;clear stack
  ret


;print newline to COM1 port
;stack_layout:
;+0: ret ptr
global write_new_line:
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
global write_str:
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
