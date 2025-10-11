%define MULTIBOOT_V2_COMPLIANT_CHECK 0x36d76289

;check if the registers are in a valid state right after the _start
;stack layout:
;+0: ret ptr
global boot_check
boot_check:
  cmp eax, MULTIBOOT_V2_COMPLIANT_CHECK
  jne boot_check 
  ret

;return value of the requested info based on the protocol
;if info exist return value in eax and ebx set to 0, if not set 1 into ebx and eax to 0
;stack layout:
;+0: ret ptr
;+4: ptr to info structure
;+8: parameter specifier (u32 according to the protocol)
%define FRAMEBUFFER_ADDR 128 ; (8 << 4) | (0<0)
global boot_get_info
boot_get_info:
  xor ebx, eax; clear
  xor ebx, ebx; clear

  mov ebx, [esp + 8] ;tag type to search
  mov esi, [esp + 4] ;ptr to information structure

  mov edx, [esi] ;total size

  add esi, 8 ;skip reserved part
  sub edx, 8 ;sub initial tag of total size

  .search_tag:
    mov eax, [esi] ;load new tag
    cmp ah, bh ;check search type
    je .found
    sub edx, [esi +4] ;sub tot size
    cmp edx, 0
    jl .no_found ;no more modules
    add esi, [esi + 4] ;skip the module by adding its size
    jmp .search_tag

  .found:
    add esi, 8
    add esi, 4 ;FRAMEBUFFER_ADDR is 64 bit long
    mov eax, [esi]
    mov ebx, 0
    ret

  .no_found:
    mov eax, 0
    mov ebx, 1
    ret
