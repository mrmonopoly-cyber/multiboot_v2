%include "./src/io/io.h"

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
