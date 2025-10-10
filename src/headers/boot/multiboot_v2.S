%define MULTIBOOT_V2_COMPLIANT_CHECK

;check if the registers are in a valid state right after the _start
;stack layout:
;+0: ret ptr
global check_boot
check_boot:
  cmp eax, MULTIBOOT_V2_COMPLIANT_CHECK
  jne check_boot
  ret
