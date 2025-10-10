;check if the registers are in a valid state right after the _start
;stack layout:
;+0: ret ptr
global check_boot
check_boot:
  cmp eax, 0x36d76289
  jne check_boot
  ret
